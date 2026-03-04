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

abstract class PaymentResult
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  PaymentResult._({
    required this.success,
    required this.transactionId,
    required this.message,
    required this.montantTotal,
  });

  factory PaymentResult({
    required bool success,
    required String transactionId,
    required String message,
    required double montantTotal,
  }) = _PaymentResultImpl;

  factory PaymentResult.fromJson(Map<String, dynamic> jsonSerialization) {
    return PaymentResult(
      success: jsonSerialization['success'] as bool,
      transactionId: jsonSerialization['transactionId'] as String,
      message: jsonSerialization['message'] as String,
      montantTotal: (jsonSerialization['montantTotal'] as num).toDouble(),
    );
  }

  bool success;

  String transactionId;

  String message;

  double montantTotal;

  /// Returns a shallow copy of this [PaymentResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PaymentResult copyWith({
    bool? success,
    String? transactionId,
    String? message,
    double? montantTotal,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PaymentResult',
      'success': success,
      'transactionId': transactionId,
      'message': message,
      'montantTotal': montantTotal,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PaymentResult',
      'success': success,
      'transactionId': transactionId,
      'message': message,
      'montantTotal': montantTotal,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _PaymentResultImpl extends PaymentResult {
  _PaymentResultImpl({
    required bool success,
    required String transactionId,
    required String message,
    required double montantTotal,
  }) : super._(
         success: success,
         transactionId: transactionId,
         message: message,
         montantTotal: montantTotal,
       );

  /// Returns a shallow copy of this [PaymentResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PaymentResult copyWith({
    bool? success,
    String? transactionId,
    String? message,
    double? montantTotal,
  }) {
    return PaymentResult(
      success: success ?? this.success,
      transactionId: transactionId ?? this.transactionId,
      message: message ?? this.message,
      montantTotal: montantTotal ?? this.montantTotal,
    );
  }
}
