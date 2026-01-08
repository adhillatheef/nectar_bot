import '../entities/ticket.dart';
import '../repositories/i_ticket_repository.dart';

class GetTicketByIdUseCase {
  final ITicketRepository repository;
  GetTicketByIdUseCase(this.repository);

  Future<Ticket?> call(String id) async {
    return await repository.getTicketById(id);
  }
}