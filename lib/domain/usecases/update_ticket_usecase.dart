import '../entities/ticket.dart';
import '../repositories/i_ticket_repository.dart';

class UpdateTicketUseCase {
  final ITicketRepository repository;

  UpdateTicketUseCase(this.repository);

  Future<void> call(Ticket ticket) async {
    return await repository.updateTicket(ticket);
  }
}