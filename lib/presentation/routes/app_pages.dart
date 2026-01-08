import 'package:get/get.dart';
import '../features/chat/binding/chat_binding.dart';
import '../features/chat/pages/chat_screen.dart';
import '../features/edit_ticket/binding/edit_ticket_binding.dart';
import '../features/edit_ticket/pages/edit_ticket_screen.dart';
import '../features/splash/binding/splash_binding.dart';
import '../features/splash/pages/splash_screen.dart';
import '../features/ticket_detail/binding/ticket_detail_binding.dart';
import '../features/ticket_detail/pages/ticket_detail_screen.dart';
import '../features/ticket_list/binding/ticket_list_binding.dart';
import '../features/ticket_list/pages/ticket_list_screen.dart';
import 'app_routes.dart';


class AppPages {
  static final routes = [
    GetPage(
      name: Routes.SPLASH,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.TICKET_LIST,
      page: () => const TicketListScreen(),
      binding: TicketListBinding(),
    ),
    GetPage(
      name: Routes.CHAT,
      page: () => const ChatScreen(),
      binding: ChatBinding(),
    ),
    GetPage(
      name: Routes.TICKET_DETAIL,
      page: () => const TicketDetailScreen(),
      binding: TicketDetailBinding(),
    ),
    GetPage(
      name: Routes.EDIT_TICKET,
      page: () => const EditTicketScreen(),
      binding: EditTicketBinding(),
    ),
  ];
}