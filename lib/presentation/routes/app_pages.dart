import 'package:get/get.dart';
import '../pages/ticket_detail/ticket_detail_screen.dart';
import '../pages/ticket_list/ticket_list_screen.dart';
import 'app_routes.dart';
import '../pages/chat/chat_screen.dart';
// import '../pages/splash/splash_screen.dart';

class AppPages {
  // We'll set the initial route to CHAT for now to test immediately.
  // Later we change this to SPLASH.
  static const INITIAL = Routes.CHAT;

  static final routes = [
    // Chat Route
    GetPage(
      name: Routes.CHAT,
      page: () => ChatScreen(),
      transition: Transition.fadeIn,
    ),

    // Placeholder for future routes (Uncomment as you build them)

    // GetPage(
    //   name: Routes.SPLASH,
    //   page: () => SplashScreen(),
    // ),
    GetPage(
      name: Routes.TICKET_LIST,
      page: () => TicketListScreen(),
    ),

    GetPage(
      name: Routes.TICKET_DETAIL,
      page: () => TicketDetailScreen(),
    ),
  ];
}