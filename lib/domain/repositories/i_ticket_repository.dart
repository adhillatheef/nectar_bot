import '../entities/ticket.dart';

abstract class ITicketRepository {
  Future<List<Ticket>> getTickets();
  Future<void> createTicket(Ticket ticket);
  Future<void> updateTicket(Ticket ticket);
  Future<void> updateTicketStatus(String id, String status);
  Future<void> deleteTicket(String id);
  Future<Ticket?> getTicketById(String id);
}