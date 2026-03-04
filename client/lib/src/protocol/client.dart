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
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i1;
import 'package:serverpod_client/serverpod_client.dart' as _i2;
import 'dart:async' as _i3;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i4;
import 'package:cinema_reservation_client/src/protocol/films/film.dart' as _i5;
import 'package:cinema_reservation_client/src/protocol/films/seance.dart'
    as _i6;
import 'package:cinema_reservation_client/src/protocol/films/cinema.dart'
    as _i7;
import 'package:cinema_reservation_client/src/protocol/greetings/greeting.dart'
    as _i8;
import 'package:cinema_reservation_client/src/protocol/reservations/siege.dart'
    as _i10;
import 'package:cinema_reservation_client/src/protocol/reservations/reservation_result.dart'
    as _i11;
import 'protocol.dart' as _i9;

/// By extending [EmailIdpBaseEndpoint], the email identity provider endpoints
/// are made available on the server and enable the corresponding sign-in widget
/// on the client.
/// {@category Endpoint}
class EndpointEmailIdp extends _i1.EndpointEmailIdpBase {
  EndpointEmailIdp(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'emailIdp';

  /// Logs in the user and returns a new session.
  ///
  /// Throws an [EmailAccountLoginException] in case of errors, with reason:
  /// - [EmailAccountLoginExceptionReason.invalidCredentials] if the email or
  ///   password is incorrect.
  /// - [EmailAccountLoginExceptionReason.tooManyAttempts] if there have been
  ///   too many failed login attempts.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _i3.Future<_i4.AuthSuccess> login({
    required String email,
    required String password,
  }) => caller.callServerEndpoint<_i4.AuthSuccess>(
    'emailIdp',
    'login',
    {
      'email': email,
      'password': password,
    },
  );

  /// Starts the registration for a new user account with an email-based login
  /// associated to it.
  ///
  /// Upon successful completion of this method, an email will have been
  /// sent to [email] with a verification link, which the user must open to
  /// complete the registration.
  ///
  /// Always returns a account request ID, which can be used to complete the
  /// registration. If the email is already registered, the returned ID will not
  /// be valid.
  @override
  _i3.Future<_i2.UuidValue> startRegistration({required String email}) =>
      caller.callServerEndpoint<_i2.UuidValue>(
        'emailIdp',
        'startRegistration',
        {'email': email},
      );

  /// Verifies an account request code and returns a token
  /// that can be used to complete the account creation.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if no request exists
  ///   for the given [accountRequestId] or [verificationCode] is invalid.
  @override
  _i3.Future<String> verifyRegistrationCode({
    required _i2.UuidValue accountRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyRegistrationCode',
    {
      'accountRequestId': accountRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a new account registration, creating a new auth user with a
  /// profile and attaching the given email account to it.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if the [registrationToken]
  ///   is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  ///
  /// Returns a session for the newly created user.
  @override
  _i3.Future<_i4.AuthSuccess> finishRegistration({
    required String registrationToken,
    required String password,
  }) => caller.callServerEndpoint<_i4.AuthSuccess>(
    'emailIdp',
    'finishRegistration',
    {
      'registrationToken': registrationToken,
      'password': password,
    },
  );

  /// Requests a password reset for [email].
  ///
  /// If the email address is registered, an email with reset instructions will
  /// be send out. If the email is unknown, this method will have no effect.
  ///
  /// Always returns a password reset request ID, which can be used to complete
  /// the reset. If the email is not registered, the returned ID will not be
  /// valid.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to request a password reset.
  ///
  @override
  _i3.Future<_i2.UuidValue> startPasswordReset({required String email}) =>
      caller.callServerEndpoint<_i2.UuidValue>(
        'emailIdp',
        'startPasswordReset',
        {'email': email},
      );

  /// Verifies a password reset code and returns a finishPasswordResetToken
  /// that can be used to finish the password reset.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to verify the password reset.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// If multiple steps are required to complete the password reset, this endpoint
  /// should be overridden to return credentials for the next step instead
  /// of the credentials for setting the password.
  @override
  _i3.Future<String> verifyPasswordResetCode({
    required _i2.UuidValue passwordResetRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyPasswordResetCode',
    {
      'passwordResetRequestId': passwordResetRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a password reset request by setting a new password.
  ///
  /// The [verificationCode] returned from [verifyPasswordResetCode] is used to
  /// validate the password reset request.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.policyViolation] if the new
  ///   password does not comply with the password policy.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _i3.Future<void> finishPasswordReset({
    required String finishPasswordResetToken,
    required String newPassword,
  }) => caller.callServerEndpoint<void>(
    'emailIdp',
    'finishPasswordReset',
    {
      'finishPasswordResetToken': finishPasswordResetToken,
      'newPassword': newPassword,
    },
  );

  @override
  _i3.Future<bool> hasAccount() => caller.callServerEndpoint<bool>(
    'emailIdp',
    'hasAccount',
    {},
  );
}

/// By extending [RefreshJwtTokensEndpoint], the JWT token refresh endpoint
/// is made available on the server and enables automatic token refresh on the client.
/// {@category Endpoint}
class EndpointJwtRefresh extends _i4.EndpointRefreshJwtTokens {
  EndpointJwtRefresh(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'jwtRefresh';

  /// Creates a new token pair for the given [refreshToken].
  ///
  /// Can throw the following exceptions:
  /// -[RefreshTokenMalformedException]: refresh token is malformed and could
  ///   not be parsed. Not expected to happen for tokens issued by the server.
  /// -[RefreshTokenNotFoundException]: refresh token is unknown to the server.
  ///   Either the token was deleted or generated by a different server.
  /// -[RefreshTokenExpiredException]: refresh token has expired. Will happen
  ///   only if it has not been used within configured `refreshTokenLifetime`.
  /// -[RefreshTokenInvalidSecretException]: refresh token is incorrect, meaning
  ///   it does not refer to the current secret refresh token. This indicates
  ///   either a malfunctioning client or a malicious attempt by someone who has
  ///   obtained the refresh token. In this case the underlying refresh token
  ///   will be deleted, and access to it will expire fully when the last access
  ///   token is elapsed.
  ///
  /// This endpoint is unauthenticated, meaning the client won't include any
  /// authentication information with the call.
  @override
  _i3.Future<_i4.AuthSuccess> refreshAccessToken({
    required String refreshToken,
  }) => caller.callServerEndpoint<_i4.AuthSuccess>(
    'jwtRefresh',
    'refreshAccessToken',
    {'refreshToken': refreshToken},
    authenticated: false,
  );
}

/// {@category Endpoint}
class EndpointAuth extends _i2.EndpointRef {
  EndpointAuth(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'auth';

  _i3.Future<void> saveProfile({
    required String nom,
    required String email,
    String? telephone,
    DateTime? dateNaissance,
  }) => caller.callServerEndpoint<void>(
    'auth',
    'saveProfile',
    {
      'nom': nom,
      'email': email,
      'telephone': telephone,
      'dateNaissance': dateNaissance,
    },
  );
}

/// Endpoint événements : liste et détail. Retourne des Map pour le client.
/// {@category Endpoint}
class EndpointEvents extends _i2.EndpointRef {
  EndpointEvents(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'events';

  /// Liste des événements à venir (filtres optionnels ville, date).
  _i3.Future<List<Map<String, dynamic>>> getEvents({
    String? ville,
    DateTime? date,
  }) => caller.callServerEndpoint<List<Map<String, dynamic>>>(
    'events',
    'getEvents',
    {
      'ville': ville,
      'date': date,
    },
  );

  /// Détail d'un événement par id.
  _i3.Future<Map<String, dynamic>?> getEventById(int id) =>
      caller.callServerEndpoint<Map<String, dynamic>?>(
        'events',
        'getEventById',
        {'id': id},
      );

  /// Crée une réservation pour un événement (même logique que cinéma).
  _i3.Future<Map<String, dynamic>> createEventReservation({
    required int eventId,
    required int nbBillets,
    required double montantTotal,
    required int utilisateurId,
  }) => caller.callServerEndpoint<Map<String, dynamic>>(
    'events',
    'createEventReservation',
    {
      'eventId': eventId,
      'nbBillets': nbBillets,
      'montantTotal': montantTotal,
      'utilisateurId': utilisateurId,
    },
  );
}

/// Endpoint Films & séances : catalogue, recherche, listes, horaires, cinémas.
/// {@category Endpoint}
class EndpointFilms extends _i2.EndpointRef {
  EndpointFilms(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'films';

  /// Liste des films à l'affiche (date du jour entre date_debut et date_fin).
  _i3.Future<List<_i5.Film>> getFilms({
    String? search,
    String? genre,
  }) => caller.callServerEndpoint<List<_i5.Film>>(
    'films',
    'getFilms',
    {
      'search': search,
      'genre': genre,
    },
  );

  /// Détail d'un film par id.
  _i3.Future<_i5.Film?> getFilmById(int id) =>
      caller.callServerEndpoint<_i5.Film?>(
        'films',
        'getFilmById',
        {'id': id},
      );

  /// Séances à venir pour un film (avec nom cinéma et code salle).
  _i3.Future<List<_i6.Seance>> getSeancesByFilm(int filmId) =>
      caller.callServerEndpoint<List<_i6.Seance>>(
        'films',
        'getSeancesByFilm',
        {'filmId': filmId},
      );

  /// Séances à venir pour un cinéma (optionnel: filtrer par date).
  _i3.Future<List<_i6.Seance>> getSeancesByCinema(
    int cinemaId, {
    DateTime? date,
  }) => caller.callServerEndpoint<List<_i6.Seance>>(
    'films',
    'getSeancesByCinema',
    {
      'cinemaId': cinemaId,
      'date': date,
    },
  );

  /// Liste des cinémas.
  _i3.Future<List<_i7.Cinema>> getCinemas({String? ville}) =>
      caller.callServerEndpoint<List<_i7.Cinema>>(
        'films',
        'getCinemas',
        {'ville': ville},
      );
}

/// Endpoint réservations : sièges, créneaux réservés, création réservation.
/// {@category Endpoint}
class EndpointReservations extends _i2.EndpointRef {
  EndpointReservations(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'reservations';

  _i3.Future<List<_i10.Siege>> getSiegesBySalle(int salleId) =>
      caller.callServerEndpoint<List<_i10.Siege>>(
        'reservations',
        'getSiegesBySalle',
        {'salleId': salleId},
      );

  _i3.Future<List<int>> getReservedSiegeIdsForSeance(int seanceId) =>
      caller.callServerEndpoint<List<int>>(
        'reservations',
        'getReservedSiegeIdsForSeance',
        {'seanceId': seanceId},
      );

  _i3.Future<_i11.ReservationResult> createReservation({
    required int seanceId,
    required List<int> siegeIds,
    int utilisateurId = 1,
  }) =>
      caller.callServerEndpoint<_i11.ReservationResult>(
        'reservations',
        'createReservation',
        {
          'seanceId': seanceId,
          'siegeIds': siegeIds,
          'utilisateurId': utilisateurId,
        },
      );
}

/// This is an example endpoint that returns a greeting message through
/// its [hello] method.
/// {@category Endpoint}
class EndpointGreeting extends _i2.EndpointRef {
  EndpointGreeting(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'greeting';

  /// Returns a personalized greeting message: "Hello {name}".
  _i3.Future<_i8.Greeting> hello(String name) =>
      caller.callServerEndpoint<_i8.Greeting>(
        'greeting',
        'hello',
        {'name': name},
      );
}

class Modules {
  Modules(Client client) {
    serverpod_auth_idp = _i1.Caller(client);
    serverpod_auth_core = _i4.Caller(client);
  }

  late final _i1.Caller serverpod_auth_idp;

  late final _i4.Caller serverpod_auth_core;
}

class Client extends _i2.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    @Deprecated(
      'Use authKeyProvider instead. This will be removed in future releases.',
    )
    super.authenticationKeyManager,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _i2.MethodCallContext,
      Object,
      StackTrace,
    )?
    onFailedCall,
    Function(_i2.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
  }) : super(
         host,
         _i9.Protocol(),
         securityContext: securityContext,
         streamingConnectionTimeout: streamingConnectionTimeout,
         connectionTimeout: connectionTimeout,
         onFailedCall: onFailedCall,
         onSucceededCall: onSucceededCall,
         disconnectStreamsOnLostInternetConnection:
             disconnectStreamsOnLostInternetConnection,
       ) {
    emailIdp = EndpointEmailIdp(this);
    jwtRefresh = EndpointJwtRefresh(this);
    auth = EndpointAuth(this);
    events = EndpointEvents(this);
    films = EndpointFilms(this);
    greeting = EndpointGreeting(this);
    reservations = EndpointReservations(this);
    modules = Modules(this);
  }

  late final EndpointEmailIdp emailIdp;

  late final EndpointJwtRefresh jwtRefresh;

  late final EndpointAuth auth;

  late final EndpointEvents events;

  late final EndpointFilms films;

  late final EndpointGreeting greeting;

  late final EndpointReservations reservations;

  late final Modules modules;

  @override
  Map<String, _i2.EndpointRef> get endpointRefLookup => {
    'emailIdp': emailIdp,
    'jwtRefresh': jwtRefresh,
    'auth': auth,
    'events': events,
    'films': films,
    'greeting': greeting,
    'reservations': reservations,
  };

  @override
  Map<String, _i2.ModuleEndpointCaller> get moduleLookup => {
    'serverpod_auth_idp': modules.serverpod_auth_idp,
    'serverpod_auth_core': modules.serverpod_auth_core,
  };
}
