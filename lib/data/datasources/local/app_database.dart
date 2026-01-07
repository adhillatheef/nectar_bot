import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';


// 1. Tickets Table
class Tickets extends Table {
  TextColumn get id => text()(); // UUID
  TextColumn get title => text()();
  TextColumn get description => text()();
  TextColumn get category => text()();
  TextColumn get priority => text()(); // Low, Medium, High
  TextColumn get status => text().withDefault(const Constant('Open'))(); // Open, In Progress, Closed
  TextColumn get location => text()();
  TextColumn get reportedBy => text()();
  DateTimeColumn get createdAt => dateTime()();

  // Additional fields captured by the form can be stored as a JSON string
  // or added as specific columns if the schema is rigid.
  // Given the dynamic nature, we keep core columns + explicit ones.

  @override
  Set<Column> get primaryKey => {id};
}

// 2. Form Sessions (To resume chatbot if app is killed) [cite: 39]
class FormSessions extends Table {
  TextColumn get sessionId => text()();
  TextColumn get lastQuestionId => text().nullable()(); // Tracks progress
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get lastUpdated => dateTime()();

  @override
  Set<Column> get primaryKey => {sessionId};
}

// 3. Form Answers (Stores temp answers before ticket creation)
class FormAnswers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get sessionId => text().references(FormSessions, #sessionId)();
  TextColumn get questionId => text()();
  TextColumn get answer => text()(); // JSON string or simple text
}

// 4. Ticket Attachments [cite: 41, 46]
class TicketAttachments extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get ticketId => text().references(Tickets, #id)();
  TextColumn get filePath => text()(); // Local path
  TextColumn get fileType => text()(); // image, video, audio
}

// --- DATABASE CLASS ---

@DriftDatabase(tables: [Tickets, FormSessions, FormAnswers, TicketAttachments])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // -- CRUD OPERATIONS --

  // Create Ticket
  Future<int> insertTicket(TicketsCompanion ticket) {
    return into(tickets).insert(ticket);
  }

  // Read All Tickets
  Future<List<Ticket>> getAllTickets() {
    return (select(tickets)..orderBy([(t) => OrderingTerm.desc(t.createdAt)])).get();
  }

  // Read Single Ticket
  Future<Ticket?> getTicket(String id) {
    return (select(tickets)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  // Update Status [cite: 69]
  Future<void> updateTicketStatus(String id, String newStatus) {
    return (update(tickets)..where((t) => t.id.equals(id))).write(
      TicketsCompanion(status: Value(newStatus)),
    );
  }

  // Delete Ticket
  Future<void> deleteTicket(String id) {
    return (delete(tickets)..where((t) => t.id.equals(id))).go();
  }

  // -- ATTACHMENT OPERATIONS --
  Future<int> insertAttachment(TicketAttachment attachment) {
    return into(ticketAttachments).insert(attachment);
  }

  Future<List<TicketAttachment>> getAttachmentsForTicket(String ticketId) {
    return (select(ticketAttachments)..where((a) => a.ticketId.equals(ticketId))).get();
  }
}

// --- CONNECTION EXECUTOR ---
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'nectar_db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}