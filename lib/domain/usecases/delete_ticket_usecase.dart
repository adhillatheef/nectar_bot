import '../repositories/i_ticket_repository.dart';

class DeleteTicketUseCase {
  final ITicketRepository repository;

  DeleteTicketUseCase(this.repository);

  Future<void> call(String id) async {
    return await repository.deleteTicket(id);
  }
}