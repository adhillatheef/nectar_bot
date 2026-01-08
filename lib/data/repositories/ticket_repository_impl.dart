import 'package:drift/drift.dart';
import '../../domain/entities/ticket.dart';
import '../../domain/repositories/i_ticket_repository.dart';
import '../datasources/local/app_database.dart' hide Ticket;

class TicketRepositoryImpl implements ITicketRepository {
  final AppDatabase _db;

  TicketRepositoryImpl(this._db);

  @override
  Future<List<Ticket>> getTickets() async {
    final dbTickets = await _db.getAllTickets();

    return dbTickets.map((t) => Ticket(
      id: t.id,
      title: t.title,
      description: t.description,
      category: t.category,
      priority: t.priority,
      status: t.status,
      location: t.location,
      createdAt: t.createdAt,
      assetId: t.assetId,
      contactNumber: t.contactNumber,
      email: t.email,
      preferredDate: t.preferredDate,
      preferredTime: t.preferredTime,
      accessRequired: t.accessRequired,
      sla: t.sla,
      reportedBy: t.reportedBy,
      attachments: [],
    )).toList();
  }

  @override
  Future<void> createTicket(Ticket ticket) async {
    await _db.transaction(() async {

      // 1. Insert the Main Ticket
      await _db.insertTicket(TicketsCompanion(
        id: Value(ticket.id),
        title: Value(ticket.title),
        description: Value(ticket.description),
        category: Value(ticket.category),
        priority: Value(ticket.priority),
        status: Value(ticket.status),
        location: Value(ticket.location),
        createdAt: Value(ticket.createdAt),
        reportedBy: Value(ticket.reportedBy),
        assetId: Value(ticket.assetId),
        contactNumber: Value(ticket.contactNumber),
        email: Value(ticket.email),
        preferredDate: Value(ticket.preferredDate),
        preferredTime: Value(ticket.preferredTime),
        accessRequired: Value(ticket.accessRequired),
        sla: Value(ticket.sla),
      ));

      // 2. Insert Attachments (Iterate through the list provided by the Entity)
      for (final path in ticket.attachments) {
        String type = 'image';
        if (path.toLowerCase().endsWith('.mp4') || path.toLowerCase().endsWith('.mov')) {
          type = 'video';
        } else if (path.toLowerCase().endsWith('.m4a') || path.toLowerCase().endsWith('.mp3')) {
          type = 'audio';
        }

        await _db.insertAttachment(TicketAttachmentsCompanion.insert(
          ticketId: ticket.id,
          filePath: path,
          fileType: type,
        ));
      }
    });
  }

  @override
  Future<void> updateTicket(Ticket ticket) async {
    await _db.transaction(() async {
      // 1. Update Core Fields
      await (_db.update(_db.tickets)..where((t) => t.id.equals(ticket.id))).write(
        TicketsCompanion(
          title: Value(ticket.title),
          description: Value(ticket.description),
          category: Value(ticket.category),
          priority: Value(ticket.priority),
          location: Value(ticket.location),
          assetId: Value(ticket.assetId),
          contactNumber: Value(ticket.contactNumber),
          email: Value(ticket.email),
          preferredDate: Value(ticket.preferredDate),
          preferredTime: Value(ticket.preferredTime),
          accessRequired: Value(ticket.accessRequired),
          sla: Value(ticket.sla),
        ),
      );

      // 2. Replace Attachments
      // First, delete existing attachments for this ticket
      await (_db.delete(_db.ticketAttachments)..where((a) => a.ticketId.equals(ticket.id))).go();

      // Second, insert the new list
      for (final path in ticket.attachments) {
        String type = 'image';
        if (path.toLowerCase().endsWith('.mp4') || path.toLowerCase().endsWith('.mov')) {
          type = 'video';
        } else if (path.toLowerCase().endsWith('.m4a') || path.toLowerCase().endsWith('.mp3')) {
          type = 'audio';
        }

        await _db.insertAttachment(TicketAttachmentsCompanion.insert(
          ticketId: ticket.id,
          filePath: path,
          fileType: type,
        ));
      }
    });
  }

  @override
  Future<void> deleteTicket(String id) async {
    await _db.deleteTicket(id);
  }

  @override
  Future<void> updateTicketStatus(String id, String status) async {
    await _db.updateTicketStatus(id, status);
  }

  @override
  Future<Ticket?> getTicketById(String id) async {
    // 1. Fetch Ticket
    final ticketRow = await (_db.select(_db.tickets)..where((t) => t.id.equals(id))).getSingleOrNull();
    if (ticketRow == null) return null;

    // 2. Fetch Attachments
    final attachmentRows = await (_db.select(_db.ticketAttachments)..where((a) => a.ticketId.equals(id))).get();
    final attachmentPaths = attachmentRows.map((a) => a.filePath).toList();

    // 3. Combine
    return Ticket(
      id: ticketRow.id,
      title: ticketRow.title,
      description: ticketRow.description,
      category: ticketRow.category,
      priority: ticketRow.priority,
      status: ticketRow.status,
      location: ticketRow.location,
      createdAt: ticketRow.createdAt,
      reportedBy: ticketRow.reportedBy,
      assetId: ticketRow.assetId,
      contactNumber: ticketRow.contactNumber,
      email: ticketRow.email,
      preferredDate: ticketRow.preferredDate,
      preferredTime: ticketRow.preferredTime,
      accessRequired: ticketRow.accessRequired,
      sla: ticketRow.sla,
      attachments: attachmentPaths,
    );
  }
}