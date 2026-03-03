import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cinema_reservation_client/cinema_reservation_client.dart'
    show Cinema, Seance, ReservationResult;
import 'package:reservation_billet_cinema/core/layout/app_shell.dart';
import 'package:reservation_billet_cinema/features/splash/presentation/pages/splash_page.dart';
import 'package:reservation_billet_cinema/features/home/presentation/pages/home_page.dart';
import 'package:reservation_billet_cinema/features/auth/presentation/pages/login_page.dart';
import 'package:reservation_billet_cinema/features/programmation/presentation/pages/films_list_page.dart';
import 'package:reservation_billet_cinema/features/programmation/presentation/pages/film_detail_page.dart';
import 'package:reservation_billet_cinema/features/reservation/data/models/recap_data.dart';
import 'package:reservation_billet_cinema/features/reservation/presentation/pages/seat_selection_page.dart';
import 'package:reservation_billet_cinema/features/reservation/presentation/pages/reservation_recap_page.dart';
import 'package:reservation_billet_cinema/features/reservation/presentation/pages/paiement_page.dart';
import 'package:reservation_billet_cinema/features/reservation/presentation/pages/reservation_confirmation_page.dart';
import 'package:reservation_billet_cinema/features/profil/presentation/pages/profil_page.dart';
import 'package:reservation_billet_cinema/features/billets/presentation/pages/billets_page.dart';
import 'package:reservation_billet_cinema/features/support/presentation/pages/faq_page.dart';
import 'package:reservation_billet_cinema/features/events/presentation/pages/events_page.dart';
import 'package:reservation_billet_cinema/features/events/presentation/pages/event_detail_page.dart';
import 'package:reservation_billet_cinema/features/events/presentation/pages/event_reservation_quantity_page.dart';
import 'package:reservation_billet_cinema/features/events/presentation/pages/event_recap_page.dart';
import 'package:reservation_billet_cinema/features/events/data/models/evenement.dart';
import 'package:reservation_billet_cinema/features/auth/presentation/pages/register_page.dart';

/// Routes de l'application (GoRouter). Shell = sidebar (drawer) sur toutes les pages internes.
final goRouter = GoRouter(
  initialLocation: '/splash',
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
    ShellRoute(
      builder: (context, state, child) => AppShell(
        currentPath: state.uri.path,
        child: child,
      ),
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
              name: 'filmDetail',
              pageBuilder: (context, state) {
                final id = int.tryParse(state.pathParameters['id'] ?? '0') ?? 0;
                final cinema = state.extra is Cinema ? state.extra as Cinema : null;
                return CustomTransitionPage(
                  key: state.pageKey,
                  child: FilmDetailPage(filmId: id, cinema: cinema),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    return FadeTransition(
                      opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
                      child: ScaleTransition(
                        scale: Tween<double>(begin: 0.96, end: 1).animate(
                          CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
                        ),
                        child: child,
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
        GoRoute(
          path: '/reservation',
          name: 'reservation',
          builder: (context, state) {
            final seance = state.extra as Seance?;
            return SeatSelectionPage(seance: seance);
          },
          routes: [
            GoRoute(
              path: 'recap',
              name: 'reservationRecap',
              builder: (context, state) {
                final data = state.extra is ReservationRecapData ? state.extra as ReservationRecapData : null;
                return ReservationRecapPage(recapData: data);
              },
            ),
            GoRoute(
              path: 'paiement',
              name: 'paiement',
              builder: (context, state) {
                final data = state.extra is ReservationRecapData ? state.extra as ReservationRecapData : null;
                return PaiementPage(recapData: data);
              },
            ),
            GoRoute(
              path: 'confirmation',
              name: 'reservationConfirmation',
              builder: (context, state) {
                final result = state.extra as ReservationResult?;
                return ReservationConfirmationPage(result: result);
              },
            ),
          ],
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
          routes: [
            GoRoute(
              path: ':id',
              name: 'eventDetail',
              pageBuilder: (context, state) {
                final id = int.tryParse(state.pathParameters['id'] ?? '0') ?? 0;
                return CustomTransitionPage(
                  key: state.pageKey,
                  child: EventDetailPage(eventId: id),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    return FadeTransition(
                      opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
                      child: ScaleTransition(
                        scale: Tween<double>(begin: 0.96, end: 1).animate(
                          CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
                        ),
                        child: child,
                      ),
                    );
                  },
                );
              },
              routes: [
                GoRoute(
                  path: 'reservation',
                  name: 'eventReservation',
                  builder: (context, state) {
                    final event = state.extra is Evenement ? state.extra as Evenement : null;
                    if (event == null) {
                      final id = int.tryParse(state.pathParameters['id'] ?? '0') ?? 0;
                      return EventDetailPage(eventId: id);
                    }
                    return EventReservationQuantityPage(
                      eventId: event.id,
                      titre: event.titre,
                      prixUnitaire: event.prix,
                      placesDisponibles: event.placesDisponibles,
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: '/reservation-event',
          name: 'reservationEvent',
          builder: (context, state) {
            final data = state.extra is EventRecapData ? state.extra as EventRecapData : null;
            return EventRecapPage(recapData: data);
          },
          routes: [
            GoRoute(
              path: 'paiement',
              name: 'eventPaiement',
              builder: (context, state) {
                final data = state.extra is EventRecapData ? state.extra as EventRecapData : null;
                return PaiementPage(recapData: null, eventRecapData: data);
              },
            ),
          ],
        ),
      ],
    ),
  ],
);
