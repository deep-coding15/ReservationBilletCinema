/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../auth/email_idp_endpoint.dart' as _i2;
import '../auth/jwt_refresh_endpoint.dart' as _i3;
import '../endpoints/auth_endpoint.dart' as _i4;
import '../endpoints/profil_endpoint.dart' as _i5;
import '../events/events_endpoint.dart' as _i6;
import '../films/films_endpoint.dart' as _i7;
import '../reservations/reservations_endpoint.dart' as _i8;
import '../admin/admin_endpoint.dart' as _i11;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _i9;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _i10;

class Endpoints extends _i1.EndpointDispatch {
  @override
  void initializeEndpoints(_i1.Server server) {
    var endpoints = <String, _i1.Endpoint>{
      'emailIdp': _i2.EmailIdpEndpoint()
        ..initialize(
          server,
          'emailIdp',
          null,
        ),
      'jwtRefresh': _i3.JwtRefreshEndpoint()
        ..initialize(
          server,
          'jwtRefresh',
          null,
        ),
      'auth': _i4.AuthEndpoint()
        ..initialize(
          server,
          'auth',
          null,
        ),
      'profil': _i5.ProfilEndpoint()
        ..initialize(
          server,
          'profil',
          null,
        ),
      'events': _i6.EventsEndpoint()
        ..initialize(
          server,
          'events',
          null,
        ),
      'films': _i7.FilmsEndpoint()
        ..initialize(
          server,
          'films',
          null,
        ),
      'reservations': _i8.ReservationsEndpoint()
        ..initialize(
          server,
          'reservations',
          null,
        ),
      'admin': _i11.AdminEndpoint()
        ..initialize(
          server,
          'admin',
          null,
        ),
    };
    connectors['emailIdp'] = _i1.EndpointConnector(
      name: 'emailIdp',
      endpoint: endpoints['emailIdp']!,
      methodConnectors: {
        'login': _i1.MethodConnector(
          name: 'login',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'password': _i1.ParameterDescription(
              name: 'password',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint).login(
                session,
                email: params['email'],
                password: params['password'],
              ),
        ),
        'startRegistration': _i1.MethodConnector(
          name: 'startRegistration',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .startRegistration(
                    session,
                    email: params['email'],
                  ),
        ),
        'verifyRegistrationCode': _i1.MethodConnector(
          name: 'verifyRegistrationCode',
          params: {
            'accountRequestId': _i1.ParameterDescription(
              name: 'accountRequestId',
              type: _i1.getType<_i1.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _i1.ParameterDescription(
              name: 'verificationCode',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .verifyRegistrationCode(
                    session,
                    accountRequestId: params['accountRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishRegistration': _i1.MethodConnector(
          name: 'finishRegistration',
          params: {
            'registrationToken': _i1.ParameterDescription(
              name: 'registrationToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'password': _i1.ParameterDescription(
              name: 'password',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .finishRegistration(
                    session,
                    registrationToken: params['registrationToken'],
                    password: params['password'],
                  ),
        ),
        'startPasswordReset': _i1.MethodConnector(
          name: 'startPasswordReset',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .startPasswordReset(
                    session,
                    email: params['email'],
                  ),
        ),
        'verifyPasswordResetCode': _i1.MethodConnector(
          name: 'verifyPasswordResetCode',
          params: {
            'passwordResetRequestId': _i1.ParameterDescription(
              name: 'passwordResetRequestId',
              type: _i1.getType<_i1.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _i1.ParameterDescription(
              name: 'verificationCode',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .verifyPasswordResetCode(
                    session,
                    passwordResetRequestId: params['passwordResetRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishPasswordReset': _i1.MethodConnector(
          name: 'finishPasswordReset',
          params: {
            'finishPasswordResetToken': _i1.ParameterDescription(
              name: 'finishPasswordResetToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'newPassword': _i1.ParameterDescription(
              name: 'newPassword',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .finishPasswordReset(
                    session,
                    finishPasswordResetToken:
                        params['finishPasswordResetToken'],
                    newPassword: params['newPassword'],
                  ),
        ),
        'hasAccount': _i1.MethodConnector(
          name: 'hasAccount',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .hasAccount(session),
        ),
      },
    );
    connectors['jwtRefresh'] = _i1.EndpointConnector(
      name: 'jwtRefresh',
      endpoint: endpoints['jwtRefresh']!,
      methodConnectors: {
        'refreshAccessToken': _i1.MethodConnector(
          name: 'refreshAccessToken',
          params: {
            'refreshToken': _i1.ParameterDescription(
              name: 'refreshToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['jwtRefresh'] as _i3.JwtRefreshEndpoint)
                  .refreshAccessToken(
                    session,
                    refreshToken: params['refreshToken'],
                  ),
        ),
      },
    );
    connectors['auth'] = _i1.EndpointConnector(
      name: 'auth',
      endpoint: endpoints['auth']!,
      methodConnectors: {
        'isAdmin': _i1.MethodConnector(
          name: 'isAdmin',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['auth'] as _i4.AuthEndpoint).isAdmin(session),
        ),
        'saveProfile': _i1.MethodConnector(
          name: 'saveProfile',
          params: {
            'nom': _i1.ParameterDescription(
              name: 'nom',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'telephone': _i1.ParameterDescription(
              name: 'telephone',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'dateNaissance': _i1.ParameterDescription(
              name: 'dateNaissance',
              type: _i1.getType<DateTime?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['auth'] as _i4.AuthEndpoint).saveProfile(
                session,
                nom: params['nom'],
                email: params['email'],
                telephone: params['telephone'],
                dateNaissance: params['dateNaissance'],
              ),
        ),
      },
    );
    connectors['profil'] = _i1.EndpointConnector(
      name: 'profil',
      endpoint: endpoints['profil']!,
      methodConnectors: {
        'getProfil': _i1.MethodConnector(
          name: 'getProfil',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['profil'] as _i5.ProfilEndpoint).getProfil(
                session,
              ),
        ),
        'updateProfil': _i1.MethodConnector(
          name: 'updateProfil',
          params: {
            'nom': _i1.ParameterDescription(
              name: 'nom',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'telephone': _i1.ParameterDescription(
              name: 'telephone',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'preferences': _i1.ParameterDescription(
              name: 'preferences',
              type: _i1.getType<List<String>?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['profil'] as _i5.ProfilEndpoint).updateProfil(
                    session,
                    nom: params['nom'],
                    telephone: params['telephone'],
                    preferences: params['preferences'],
                  ),
        ),
        'getFavoris': _i1.MethodConnector(
          name: 'getFavoris',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['profil'] as _i5.ProfilEndpoint).getFavoris(
                session,
              ),
        ),
        'ajouterFavori': _i1.MethodConnector(
          name: 'ajouterFavori',
          params: {
            'cinemaId': _i1.ParameterDescription(
              name: 'cinemaId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['profil'] as _i5.ProfilEndpoint).ajouterFavori(
                    session,
                    cinemaId: params['cinemaId'],
                  ),
        ),
        'supprimerFavori': _i1.MethodConnector(
          name: 'supprimerFavori',
          params: {
            'cinemaId': _i1.ParameterDescription(
              name: 'cinemaId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['profil'] as _i5.ProfilEndpoint).supprimerFavori(
                    session,
                    cinemaId: params['cinemaId'],
                  ),
        ),
        'getHistoriqueReservations': _i1.MethodConnector(
          name: 'getHistoriqueReservations',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['profil'] as _i5.ProfilEndpoint)
                  .getHistoriqueReservations(session),
        ),
      },
    );
    connectors['events'] = _i1.EndpointConnector(
      name: 'events',
      endpoint: endpoints['events']!,
      methodConnectors: {
        'getEvents': _i1.MethodConnector(
          name: 'getEvents',
          params: {
            'ville': _i1.ParameterDescription(
              name: 'ville',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'date': _i1.ParameterDescription(
              name: 'date',
              type: _i1.getType<DateTime?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['events'] as _i6.EventsEndpoint).getEvents(
                session,
                ville: params['ville'],
                date: params['date'],
              ),
        ),
        'getEventById': _i1.MethodConnector(
          name: 'getEventById',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['events'] as _i6.EventsEndpoint).getEventById(
                    session,
                    params['id'],
                  ),
        ),
        'createEventReservation': _i1.MethodConnector(
          name: 'createEventReservation',
          params: {
            'eventId': _i1.ParameterDescription(
              name: 'eventId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'nbBillets': _i1.ParameterDescription(
              name: 'nbBillets',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'montantTotal': _i1.ParameterDescription(
              name: 'montantTotal',
              type: _i1.getType<double>(),
              nullable: false,
            ),
            'utilisateurId': _i1.ParameterDescription(
              name: 'utilisateurId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['events'] as _i6.EventsEndpoint)
                  .createEventReservation(
                    session,
                    eventId: params['eventId'],
                    nbBillets: params['nbBillets'],
                    montantTotal: params['montantTotal'],
                    utilisateurId: params['utilisateurId'],
                  ),
        ),
      },
    );
    connectors['films'] = _i1.EndpointConnector(
      name: 'films',
      endpoint: endpoints['films']!,
      methodConnectors: {
        'getFilms': _i1.MethodConnector(
          name: 'getFilms',
          params: {
            'search': _i1.ParameterDescription(
              name: 'search',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'genre': _i1.ParameterDescription(
              name: 'genre',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['films'] as _i7.FilmsEndpoint).getFilms(
                session,
                search: params['search'],
                genre: params['genre'],
              ),
        ),
        'getFilmById': _i1.MethodConnector(
          name: 'getFilmById',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['films'] as _i7.FilmsEndpoint).getFilmById(
                session,
                params['id'],
              ),
        ),
        'getSeancesByFilm': _i1.MethodConnector(
          name: 'getSeancesByFilm',
          params: {
            'filmId': _i1.ParameterDescription(
              name: 'filmId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['films'] as _i7.FilmsEndpoint).getSeancesByFilm(
                    session,
                    params['filmId'],
                  ),
        ),
        'getSeancesByCinema': _i1.MethodConnector(
          name: 'getSeancesByCinema',
          params: {
            'cinemaId': _i1.ParameterDescription(
              name: 'cinemaId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'date': _i1.ParameterDescription(
              name: 'date',
              type: _i1.getType<DateTime?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['films'] as _i7.FilmsEndpoint).getSeancesByCinema(
                    session,
                    params['cinemaId'],
                    date: params['date'],
                  ),
        ),
        'getCinemas': _i1.MethodConnector(
          name: 'getCinemas',
          params: {
            'ville': _i1.ParameterDescription(
              name: 'ville',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['films'] as _i7.FilmsEndpoint).getCinemas(
                session,
                ville: params['ville'],
              ),
        ),
      },
    );
    connectors['reservations'] = _i1.EndpointConnector(
      name: 'reservations',
      endpoint: endpoints['reservations']!,
      methodConnectors: {
        'getSiegesBySalle': _i1.MethodConnector(
          name: 'getSiegesBySalle',
          params: {
            'salleId': _i1.ParameterDescription(
              name: 'salleId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['reservations'] as _i8.ReservationsEndpoint)
                  .getSiegesBySalle(session, params['salleId']),
        ),
        'getReservedSiegeIdsForSeance': _i1.MethodConnector(
          name: 'getReservedSiegeIdsForSeance',
          params: {
            'seanceId': _i1.ParameterDescription(
              name: 'seanceId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['reservations'] as _i8.ReservationsEndpoint)
                  .getReservedSiegeIdsForSeance(
                    session,
                    params['seanceId'],
                  ),
        ),
        'createReservation': _i1.MethodConnector(
          name: 'createReservation',
          params: {
            'seanceId': _i1.ParameterDescription(
              name: 'seanceId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'siegeIds': _i1.ParameterDescription(
              name: 'siegeIds',
              type: _i1.getType<List<int>>(),
              nullable: false,
            ),
            'utilisateurId': _i1.ParameterDescription(
              name: 'utilisateurId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['reservations'] as _i8.ReservationsEndpoint)
                  .createReservation(
                    session,
                    seanceId: params['seanceId'],
                    siegeIds: params['siegeIds'],
                    utilisateurId: params['utilisateurId'],
                  ),
        ),
      },
    );
    connectors['admin'] = _i1.EndpointConnector(
      name: 'admin',
      endpoint: endpoints['admin']!,
      methodConnectors: {
        'getDashboardStats': _i1.MethodConnector(
          name: 'getDashboardStats',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i11.AdminEndpoint)
                  .getDashboardStats(session),
        ),
        'getUsers': _i1.MethodConnector(
          name: 'getUsers',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i11.AdminEndpoint).getUsers(session),
        ),
      },
    );
    modules['serverpod_auth_idp'] = _i9.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth_core'] = _i10.Endpoints()
      ..initializeEndpoints(server);
  }
}
