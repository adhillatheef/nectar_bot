import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

// Required for code generation
part 'app_database.g.dart';

// --- TABLE DEFINITIONS ---

// 1. Tickets Table
class Tickets extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get description => text()();
  TextColumn get category => text()();
  TextColumn get priority => text()();
  TextColumn get status => text().withDefault(const Constant('Open'))();
  TextColumn get location => text()();
  TextColumn get reportedBy => text()();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get assetId => text().nullable()();
  TextColumn get contactNumber => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get preferredDate => text().nullable()();
  TextColumn get preferredTime => text().nullable()();
  TextColumn get accessRequired => text().nullable()();
  TextColumn get sla => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// 2. Form Sessions (To resume chatbot)
class FormSessions extends Table {
  TextColumn get sessionId => text()();
  TextColumn get lastQuestionId => text().nullable()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get lastUpdated => dateTime()();

  @override
  Set<Column> get primaryKey => {sessionId};
}

// 3. Form Answers (Stores partial progress)
class FormAnswers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get sessionId => text().references(FormSessions, #sessionId)();
  TextColumn get questionId => text()();
  TextColumn get answer => text()();
}

// 4. Ticket Attachments
class TicketAttachments extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get ticketId => text().references(Tickets, #id)();
  TextColumn get filePath => text()();
  TextColumn get fileType => text()(); // image, video, audio
}

// --- DATABASE CLASS ---

@DriftDatabase(tables: [Tickets, FormSessions, FormAnswers, TicketAttachments])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // -- TICKET OPERATIONS --
  Future<int> insertTicket(TicketsCompanion ticket) {
    return into(tickets).insert(ticket);
  }

  Future<List<Ticket>> getAllTickets() {
    return (select(tickets)..orderBy([(t) => OrderingTerm.desc(t.createdAt)])).get();
  }

  Future<void> updateTicketStatus(String id, String newStatus) {
    return (update(tickets)..where((t) => t.id.equals(id))).write(
      TicketsCompanion(status: Value(newStatus)),
    );
  }

  Future<void> deleteTicket(String id) {
    return (delete(tickets)..where((t) => t.id.equals(id))).go();
  }

  // -- ATTACHMENT OPERATIONS --
  Future<int> insertAttachment(TicketAttachmentsCompanion attachment) {
    return into(ticketAttachments).insert(attachment);
  }

  Future<List<TicketAttachment>> getAttachmentsForTicket(String ticketId) {
    return (select(ticketAttachments)..where((a) => a.ticketId.equals(ticketId))).get();
  }

  // -- SESSION & RESUME LOGIC --

  // Get the last active (incomplete) session
  Future<FormSession?> getLastIncompleteSession() {
    return (select(formSessions)
      ..where((s) => s.isCompleted.equals(false))
      ..orderBy([(t) => OrderingTerm.desc(t.lastUpdated)])
      ..limit(1)
    ).getSingleOrNull();
  }

  // Create or Update a Session
  Future<void> saveSession(String sessionId, String lastQuestionId) {
    return into(formSessions).insertOnConflictUpdate(FormSessionsCompanion(
      sessionId: Value(sessionId),
      lastQuestionId: Value(lastQuestionId),
      lastUpdated: Value(DateTime.now()),
      isCompleted: const Value(false),
    ));
  }

  // Save an Answer
  Future<void> saveAnswer(FormAnswersCompanion answer) {
    return into(formAnswers).insertOnConflictUpdate(answer);
  }

  // Get all answers for a specific session
  Future<List<FormAnswer>> getAnswersForSession(String sessionId) {
    return (select(formAnswers)..where((a) => a.sessionId.equals(sessionId))).get();
  }

  // Mark session as complete
  Future<void> completeSession(String sessionId) {
    return (update(formSessions)..where((s) => s.sessionId.equals(sessionId))).write(
      const FormSessionsCompanion(isCompleted: Value(true)),
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'nectar_db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}