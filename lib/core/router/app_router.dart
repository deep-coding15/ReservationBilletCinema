import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:reservation_billet_cinema/core/layout/app_shell.dart';
import 'package:reservation_billet_cinema/core/theme/app_theme.dart';
import 'package:reservation_billet_cinema/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:reservation_billet_cinema/features/auth/presentation/pages/login_page.dart';
import 'package:reservation_billet_cinema/features/auth/presentation/pages/register_page.dart';
import 'package:reservation_billet_cinema/features/billets/presentation/pages/billets_page.dart';
import 'package:reservation_billet_cinema/features/events/data/models/evenement.dart';
import 'package:reservation_billet_cinema/features/events/presentation/pages/event_detail_page.dart';
import 'package:reservation_billet_cinema/features/events/presentation/pages/event_recap_page.dart';
import 'package:reservation_billet_cinema/features/events/presentation/pages/event_reservation_quantity_page.dart';
import 'package:reservation_billet_cinema/features/events/presentation/pages/events_page.dart';
import 'package:reservation_billet_cinema/features/home/presentation/pages/home_page.dart';
import 'package:reservation_billet_cinema/features/profil/presentation/pages/edit_profil_page.dart';
import 'package:reservation_billet_cinema/features/profil/presentation/pages/profil_page.dart';
import 'package:reservation_billet_cinema/features/programmation/presentation/pages/film_detail_page.dart';
import 'package:reservation_billet_cinema/features/programmation/presentation/pages/films_list_page.dart';
import 'package:reservation_billet_cinema/features/reservation/presentation/pages/paiement_page.dart';
import 'package:reservation_billet_cinema/features/reservation/presentation/pages/reservation_confirmation_page.dart';
import 'package:reservation_billet_cinema/features/reservation/presentation/pages/reservation_recap_page.dart';
import 'package:reservation_billet_cinema/features/reservation/data/models/recap_data.dart';
import 'package:reservation_billet_cinema/features/reservation/presentation/pages/seat_selection_page.dart';
import 'package:reservation_billet_cinema/features/splash/presentation/pages/splash_page.dart';
import 'package:reservation_billet_cinema/features/support/presentation/pages/faq_page.dart';
import 'package:reservation_billet_cinema/features/admin/presentation/layout/admin_shell.dart';
import 'package:reservation_billet_cinema/features/admin/presentation/pages/admin_dashboard_page.dart';
import 'package:reservation_billet_cinema/features/admin/presentation/pages/admin_events_page.dart';
import 'package:reservation_billet_cinema/features/admin/presentation/pages/admin_films_page.dart';
import 'package:reservation_billet_cinema/features/admin/presentation/pages/admin_seances_page.dart';
import 'package:reservation_billet_cinema/features/admin/presentation/pages/admin_users_page.dart';
import 'package:cinema_reservation_client/cinema_reservation_client.dart';

/// Routes de l'application (GoRouter) avec shell (drawer + bottom nav) et page d'erreur stylée.
final goRouter = GoRouter(
  initialLocation: '/splash',
  redirect: (context, state) => null,
  errorBuilder: (context, state) => _ErrorPage(
    error: state.error?.toString() ?? 'Page non trouvée',
    path: state.uri.path,
  ),
  routes: [
    GoRoute(
      path: '/splash',
      name: 'splash',
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: '/auth/login',
      name: 'login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/auth/register',
      name: 'register',
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: '/auth/forgot-password',
      name: 'forgot-password',
      builder: (context, state) => const ForgotPasswordPage(),
    ),
    ShellRoute(
      builder: (context, state, child) {
        return AppShell(
          currentPath: state.uri.path,
          child: child,
        );
      },
      routes: [
        GoRoute(
          path: '/',
          name: 'home',
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: '/films',
          name: 'films',
          builder: (context, state) => const FilmsListPage(),
          routes: [
            GoRoute(
              path: ':id',
              name: 'film-detail',
              builder: (context, state) {
                final id = state.pathParameters['id']!;
                final cinema = state.extra is Cinema ? state.extra as Cinema : null;
                return FilmDetailPage(
                  filmId: int.parse(id),
                  cinema: cinema,
                );
              },
            ),
          ],
        ),
        GoRoute(
          path: '/events',
          name: 'events',
          builder: (context, state) => const EventsPage(),
          routes: [
            GoRoute(
              path: ':id',
              name: 'event-detail',
              builder: (context, state) {
                final id = state.pathParameters['id']!;
                return EventDetailPage(eventId: int.parse(id));
              },
              routes: [
                GoRoute(
                  path: 'reservation',
                  name: 'event-reservation',
                  builder: (context, state) {
                    final e = state.extra is Evenement
                        ? state.extra as Evenement
                        : null;
                    if (e == null) return const SizedBox.shrink();
                    return EventReservationQuantityPage(
                      eventId: e.id,
                      titre: e.titre,
                      prixUnitaire: e.prix,
                      placesDisponibles: e.placesDisponibles ?? 0,
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: '/reservation',
          name: 'reservation',
          builder: (context, state) => SeatSelectionPage(
            seance: state.extra is Seance ? state.extra as Seance : null,
          ),
          routes: [
            GoRoute(
              path: 'recap',
              name: 'reservation-recap',
              builder: (context, state) {
                final data = state.extra;
                return ReservationRecapPage(
                  recapData: data is ReservationRecapData ? data : null,
                );
              },
            ),
            GoRoute(
              path: 'paiement',
              name: 'reservation-paiement',
              builder: (context, state) {
                final e = state.extra;
                return PaiementPage(
                  recapData: e is ReservationRecapData ? e : null,
                  eventRecapData: e is EventRecapData ? e : null,
                );
              },
            ),
            GoRoute(
              path: 'confirmation',
              name: 'reservation-confirmation',
              builder: (context, state) {
                final result = state.extra is ReservationResult
                    ? state.extra as ReservationResult
                    : null;
                return ReservationConfirmationPage(result: result);
              },
            ),
          ],
        ),
        GoRoute(
          path: '/profil',
          name: 'profil',
          builder: (context, state) => const ProfilPage(),
          routes: [
            GoRoute(
              path: 'edit',
              name: 'edit-profil',
              builder: (context, state) => const EditProfilPage(),
            ),
          ],
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
          path: '/reservation-event',
          name: 'reservation-event',
          builder: (context, state) {
            final data = state.extra is EventRecapData ? state.extra as EventRecapData : null;
            return EventRecapPage(recapData: data);
          },
          routes: [
            GoRoute(
              path: 'paiement',
              name: 'reservation-event-paiement',
              builder: (context, state) {
                final e = state.extra;
                return PaiementPage(
                  recapData: e is ReservationRecapData ? e : null,
                  eventRecapData: e is EventRecapData ? e : null,
                );
              },
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/admin',
      builder: (context, state) => AdminShell(
        currentPath: state.uri.path,
        child: const AdminDashboardPage(),
      ),
      routes: [
        ShellRoute(
          builder: (context, state, child) {
            return AdminShell(currentPath: state.uri.path, child: child);
          },
          routes: [
            GoRoute(
              path: 'dashboard',
              name: 'admin-dashboard',
              builder: (context, state) => const AdminDashboardPage(),
            ),
            GoRoute(
              path: 'films',
              name: 'admin-films',
              builder: (context, state) => const AdminFilmsPage(),
            ),
            GoRoute(
              path: 'seances',
              name: 'admin-seances',
              builder: (context, state) => const AdminSeancesPage(),
            ),
            GoRoute(
              path: 'evenements',
              name: 'admin-evenements',
              builder: (context, state) => const AdminEventsPage(),
            ),
            GoRoute(
              path: 'utilisateurs',
              name: 'admin-utilisateurs',
              builder: (context, state) => const AdminUsersPage(),
            ),
          ],
        ),
      ],
    ),
  ],
);

/// Page d'erreur 404 : dégradé noir → rouge, lien Accueil.
class _ErrorPage extends StatelessWidget {
  const _ErrorPage({required this.error, required this.path});

  final String error;
  final String path;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0d0d0d),
              Color(0xFF1a0a0e),
              Color(0xFF2d0d12),
              AppColors.primaryDark,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.movie_filter_rounded,
                size: 64,
                color: AppColors.primary.withValues(alpha: 0.8),
              ),
              const SizedBox(height: 24),
              Text(
                'Page non trouvée',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  error,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ),
              if (path.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  path,
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                  ),
                ),
              ],
              const SizedBox(height: 32),
              TextButton.icon(
                onPressed: () => context.go('/'),
                icon: const Icon(Icons.home_rounded, color: Colors.white),
                label: const Text(
                  'Accueil',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
