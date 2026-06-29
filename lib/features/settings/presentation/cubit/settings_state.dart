import 'package:equatable/equatable.dart';
import '../../../home/data/models/location_config.dart';

class SettingsState extends Equatable {
  final LocationConfig config;
  final bool isLoading;

  const SettingsState({this.config = const LocationConfig(), this.isLoading = false});

  SettingsState copyWith({LocationConfig? config, bool? isLoading}) {
    return SettingsState(
      config: config ?? this.config,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [config, isLoading];
}
