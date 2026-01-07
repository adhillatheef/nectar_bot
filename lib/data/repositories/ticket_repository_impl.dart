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
    )).toList();
  }

  @override
  Future<void> deleteTicket(String id) async {
    await _db.deleteTicket(id);
  }

  @override
  Future<void> updateTicketStatus(String id, String status) async {
    await _db.updateTicketStatus(id, status);
  }
}