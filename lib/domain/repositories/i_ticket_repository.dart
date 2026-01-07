import '../entities/ticket.dart';

abstract class ITicketRepository {
  Future<List<Ticket>> getTickets();
  Future<void> deleteTicket(String id);
  Future<void> updateTicketStatus(String id, String status);
// We can add more later (e.g., getTicketById)
}