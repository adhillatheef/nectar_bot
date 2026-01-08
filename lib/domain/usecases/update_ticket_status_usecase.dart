import '../repositories/i_ticket_repository.dart';

class UpdateTicketStatusUseCase {
  final ITicketRepository repository;

  UpdateTicketStatusUseCase(this.repository);

  Future<void> call(String id, String status) async {
    return await repository.updateTicketStatus(id, status);
  }
}