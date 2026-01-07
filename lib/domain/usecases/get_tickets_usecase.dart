import '../entities/ticket.dart';
import '../repositories/i_ticket_repository.dart';

class GetTicketsUseCase {
  final ITicketRepository repository;

  GetTicketsUseCase(this.repository);

  Future<List<Ticket>> call() async {
    return await repository.getTickets();
  }
}