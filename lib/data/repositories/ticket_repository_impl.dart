import 'package:drift/drift.dart';
import '../../domain/entities/ticket.dart';
import '../../domain/repositories/i_ticket_repository.dart';
import '../datasources/local/app_database.dart' hide Ticket;

class TicketRepositoryImpl implements ITicketRepository {
  final AppDatabase _db;

  TicketRepositoryImpl(this._db);

  @override
  Future<List<Ticket>> getTickets() async {
    // 1. Get all tickets
    final dbTickets = await _db.getAllTickets();
    final List<Ticket> result = [];

    // 2. Loop through each ticket and fetch its attachments
    for (final t in dbTickets) {

      // Fetch attachments for THIS specific ticket ID
      final attachmentRows = await (_db.select(_db.ticketAttachments)
        ..where((a) => a.ticketId.equals(t.id))).get();

      final attachmentPaths = attachmentRows.map((a) => a.filePath).toList();

      result.add(Ticket(
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

        // --- FIX: Pass the fetched paths instead of [] ---
        attachments: attachmentPaths,
      ));
    }

    return result;
  }

  @override
  Future<void> createTicket(Ticket ticket) async {
    await _db.transaction(() async {
      // 1. Insert Main Ticket
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
        // Note: We do NOT insert into the 'attachments' column of the Tickets table.
        // We use the secondary table below.
      ));

      // 2. Insert Attachments into the secondary table
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

      // Replace Attachments
      await (_db.delete(_db.ticketAttachments)..where((a) => a.ticketId.equals(ticket.id))).go();

      for (final path in ticket.attachments) {
        String type = 'image';
        if (path.toLowerCase().endsWith('.mp4')) type = 'video';
        else if (path.toLowerCase().endsWith('.m4a')) type = 'audio';

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
    final ticketRow = await (_db.select(_db.tickets)..where((t) => t.id.equals(id))).getSingleOrNull();
    if (ticketRow == null) return null;

    final attachmentRows = await (_db.select(_db.ticketAttachments)..where((a) => a.ticketId.equals(id))).get();
    final attachmentPaths = attachmentRows.map((a) => a.filePath).toList();

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