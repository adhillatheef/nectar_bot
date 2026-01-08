import 'package:get/get.dart';
import 'data/datasources/local/app_database.dart';
import 'data/repositories/ticket_repository_impl.dart';
import 'domain/repositories/i_ticket_repository.dart';
import 'domain/usecases/delete_ticket_usecase.dart';
import 'domain/usecases/get_ticket_by_id_usecase.dart';
import 'domain/usecases/get_tickets_usecase.dart';
import 'domain/usecases/create_ticket_usecase.dart';
import 'domain/usecases/update_ticket_status_usecase.dart';
import 'domain/usecases/update_ticket_usecase.dart';

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
    Get.put(CreateTicketUseCase(Get.find<ITicketRepository>()));
    Get.put(DeleteTicketUseCase(Get.find<ITicketRepository>()));
    Get.put(UpdateTicketStatusUseCase(Get.find<ITicketRepository>()));
    Get.put(UpdateTicketUseCase(Get.find<ITicketRepository>()));
    Get.put(GetTicketByIdUseCase(Get.find<ITicketRepository>()));
  }
}