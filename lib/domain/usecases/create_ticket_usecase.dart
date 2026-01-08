import '../entities/ticket.dart';
import '../repositories/i_ticket_repository.dart';

class CreateTicketUseCase {
  final ITicketRepository repository;

  CreateTicketUseCase(this.repository);

  Future<void> call(Ticket ticket) async {
    return await repository.createTicket(ticket);
  }
}