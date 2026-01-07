import '../../domain/entities/ticket.dart';
import '../../domain/repositories/i_ticket_repository.dart';
import '../datasources/local/app_database.dart' hide Ticket;

class TicketRepositoryImpl implements ITicketRepository {
  final AppDatabase _db;

  TicketRepositoryImpl(this._db);

  @override
  Future<List<Ticket>> getTickets() async {
    // 1. Get raw data from Drift
    final dbTickets = await _db.getAllTickets();

    // 2. Convert (Map) to Domain Entity
    return dbTickets.map((t) => Ticket(
      id: t.id,
      title: t.title,
      description: t.description,
      category: t.category,
      priority: t.priority,
      status: t.status,
      location: t.location,
      createdAt: t.createdAt,
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