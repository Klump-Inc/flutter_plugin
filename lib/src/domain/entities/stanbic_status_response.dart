import 'package:equatable/equatable.dart';

class StanbicStatusResponse extends Equatable {
  final bool isCompleted;
  final bool isSuccessful;
  final String message;

  const StanbicStatusResponse({
    required this.isCompleted,
    required this.isSuccessful,
    required this.message,
  });

  @override
  List<Object?> get props => [
        isCompleted,
        isSuccessful,
        message,
      ];
}
