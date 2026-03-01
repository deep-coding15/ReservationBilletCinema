import 'package:go_router/go_router.dart';
import 'package:reservation_billet_cinema/features/splash/presentation/pages/splash_page.dart';
import 'package:reservation_billet_cinema/features/home/presentation/pages/home_page.dart';
import 'package:reservation_billet_cinema/features/auth/presentation/pages/login_page.dart';
import 'package:reservation_billet_cinema/features/programmation/presentation/pages/films_list_page.dart';
import 'package:reservation_billet_cinema/features/reservation/presentation/pages/seat_selection_page.dart';
import 'package:reservation_billet_cinema/features/profil/presentation/pages/profil_page.dart';
import 'package:reservation_billet_cinema/features/billets/presentation/pages/billets_page.dart';
import 'package:reservation_billet_cinema/features/support/presentation/pages/faq_page.dart';
import 'package:reservation_billet_cinema/features/events/presentation/pages/events_page.dart';

/// Routes de l'application (GoRouter).
final goRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      name: 'splash',
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/auth/login',
      name: 'login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/films',
      name: 'films',
      builder: (context, state) => const FilmsListPage(),
    ),
    GoRoute(
      path: '/reservation',
      name: 'reservation',
      builder: (context, state) => const SeatSelectionPage(),
    ),
    GoRoute(
      path: '/profil',
      name: 'profil',
      builder: (context, state) => const ProfilPage(),
    ),
    GoRoute(
      path: '/billets',
      name: 'billets',
      builder: (context, state) => const BilletsPage(),
    ),
    GoRoute(
      path: '/faq',
      name: 'faq',
      builder: (context, state) => const FaqPage(),
    ),
    GoRoute(
      path: '/events',
      name: 'events',
      builder: (context, state) => const EventsPage(),
    ),
  ],
);
