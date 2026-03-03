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
import '../endpoints/admin_films_endpoint.dart' as _i4;
import '../endpoints/admin_seances_endpoint.dart' as _i5;
import '../greetings/greeting_endpoint.dart' as _i6;
import 'package:cinema_reservation_server/src/generated/films/film.dart' as _i7;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _i8;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _i9;

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
      'adminFilms': _i4.AdminFilmsEndpoint()
        ..initialize(
          server,
          'adminFilms',
          null,
        ),
      'adminSeances': _i5.AdminSeancesEndpoint()
        ..initialize(
          server,
          'adminSeances',
          null,
        ),
      'greeting': _i6.GreetingEndpoint()
        ..initialize(
          server,
          'greeting',
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
    connectors['adminFilms'] = _i1.EndpointConnector(
      name: 'adminFilms',
      endpoint: endpoints['adminFilms']!,
      methodConnectors: {
        'getFilms': _i1.MethodConnector(
          name: 'getFilms',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['adminFilms'] as _i4.AdminFilmsEndpoint)
                  .getFilms(session),
        ),
        'createFilm': _i1.MethodConnector(
          name: 'createFilm',
          params: {
            'film': _i1.ParameterDescription(
              name: 'film',
              type: _i1.getType<_i7.Film>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['adminFilms'] as _i4.AdminFilmsEndpoint)
                  .createFilm(
                    session,
                    params['film'],
                  ),
        ),
        'updateFilm': _i1.MethodConnector(
          name: 'updateFilm',
          params: {
            'film': _i1.ParameterDescription(
              name: 'film',
              type: _i1.getType<_i7.Film>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['adminFilms'] as _i4.AdminFilmsEndpoint)
                  .updateFilm(
                    session,
                    params['film'],
                  ),
        ),
        'deleteFilm': _i1.MethodConnector(
          name: 'deleteFilm',
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
              ) async => (endpoints['adminFilms'] as _i4.AdminFilmsEndpoint)
                  .deleteFilm(
                    session,
                    params['id'],
                  ),
        ),
      },
    );
    connectors['adminSeances'] = _i1.EndpointConnector(
      name: 'adminSeances',
      endpoint: endpoints['adminSeances']!,
      methodConnectors: {
        'getSeances': _i1.MethodConnector(
          name: 'getSeances',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['adminSeances'] as _i5.AdminSeancesEndpoint)
                  .getSeances(session),
        ),
        'getFilmsDisponibles': _i1.MethodConnector(
          name: 'getFilmsDisponibles',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['adminSeances'] as _i5.AdminSeancesEndpoint)
                  .getFilmsDisponibles(session),
        ),
        'getSallesDisponibles': _i1.MethodConnector(
          name: 'getSallesDisponibles',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['adminSeances'] as _i5.AdminSeancesEndpoint)
                  .getSallesDisponibles(session),
        ),
        'createSeance': _i1.MethodConnector(
          name: 'createSeance',
          params: {
            'filmId': _i1.ParameterDescription(
              name: 'filmId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'salleId': _i1.ParameterDescription(
              name: 'salleId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'dateHeure': _i1.ParameterDescription(
              name: 'dateHeure',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'langue': _i1.ParameterDescription(
              name: 'langue',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'typeProjection': _i1.ParameterDescription(
              name: 'typeProjection',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'placesDisponibles': _i1.ParameterDescription(
              name: 'placesDisponibles',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'prix': _i1.ParameterDescription(
              name: 'prix',
              type: _i1.getType<double>(),
              nullable: false,
            ),
            'typeSeance': _i1.ParameterDescription(
              name: 'typeSeance',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['adminSeances'] as _i5.AdminSeancesEndpoint)
                  .createSeance(
                    session,
                    filmId: params['filmId'],
                    salleId: params['salleId'],
                    dateHeure: params['dateHeure'],
                    langue: params['langue'],
                    typeProjection: params['typeProjection'],
                    placesDisponibles: params['placesDisponibles'],
                    prix: params['prix'],
                    typeSeance: params['typeSeance'],
                  ),
        ),
        'updateSeance': _i1.MethodConnector(
          name: 'updateSeance',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'filmId': _i1.ParameterDescription(
              name: 'filmId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'salleId': _i1.ParameterDescription(
              name: 'salleId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'dateHeure': _i1.ParameterDescription(
              name: 'dateHeure',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'langue': _i1.ParameterDescription(
              name: 'langue',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'typeProjection': _i1.ParameterDescription(
              name: 'typeProjection',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'placesDisponibles': _i1.ParameterDescription(
              name: 'placesDisponibles',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'prix': _i1.ParameterDescription(
              name: 'prix',
              type: _i1.getType<double>(),
              nullable: false,
            ),
            'typeSeance': _i1.ParameterDescription(
              name: 'typeSeance',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['adminSeances'] as _i5.AdminSeancesEndpoint)
                  .updateSeance(
                    session,
                    id: params['id'],
                    filmId: params['filmId'],
                    salleId: params['salleId'],
                    dateHeure: params['dateHeure'],
                    langue: params['langue'],
                    typeProjection: params['typeProjection'],
                    placesDisponibles: params['placesDisponibles'],
                    prix: params['prix'],
                    typeSeance: params['typeSeance'],
                  ),
        ),
        'deleteSeance': _i1.MethodConnector(
          name: 'deleteSeance',
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
              ) async => (endpoints['adminSeances'] as _i5.AdminSeancesEndpoint)
                  .deleteSeance(
                    session,
                    params['id'],
                  ),
        ),
      },
    );
    connectors['greeting'] = _i1.EndpointConnector(
      name: 'greeting',
      endpoint: endpoints['greeting']!,
      methodConnectors: {
        'hello': _i1.MethodConnector(
          name: 'hello',
          params: {
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['greeting'] as _i6.GreetingEndpoint).hello(
                session,
                params['name'],
              ),
        ),
      },
    );
    modules['serverpod_auth_idp'] = _i8.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth_core'] = _i9.Endpoints()
      ..initializeEndpoints(server);
  }
}
