import 'package:get/get.dart';
import 'data/datasources/local/app_database.dart';
import 'data/repositories/ticket_repository_impl.dart';
import 'domain/repositories/i_ticket_repository.dart';
import 'domain/usecases/get_tickets_usecase.dart';

// You can create more specific use cases here later (e.g., CreateTicket, DeleteTicket)
import 'domain/usecases/create_ticket_usecase.dart';

class DependencyInjection {
  static void init() {
    // 1. Data Layer - Database
    // Initialize the Drift Database and put it in memory
    final database = AppDatabase();
    Get.put<AppDatabase>(database, permanent: true);

    // 2. Data Layer - Repository
    // The repository needs the database, so we find it immediately
    Get.put<ITicketRepository>(TicketRepositoryImpl(Get.find<AppDatabase>()));

    // 3. Domain Layer - Use Cases
    // Controllers will inject these Use Cases
    Get.put(GetTicketsUseCase(Get.find<ITicketRepository>()));

    // Example: If you create a separate use case for creation later
    // Get.put(CreateTicketUseCase(Get.find<ITicketRepository>()));
  }
}