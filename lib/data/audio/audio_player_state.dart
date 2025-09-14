part of 'audio_player_bloc.dart';

sealed class AudioPlayerState extends Equatable {
  const AudioPlayerState();

  @override
  List<Object> get props => [];
}

final class AudioPlayerInitial extends AudioPlayerState {}

final class AudioPlayerLoading extends AudioPlayerState {}

final class AudioPlayerPlaying extends AudioPlayerState {
  final Duration currentPosition;
  final Duration totalDuration;
  final bool isPlaying;

  const AudioPlayerPlaying({
    required this.currentPosition,
    required this.totalDuration,
    required this.isPlaying,
  });

  @override
  List<Object> get props => [currentPosition, totalDuration, isPlaying];
}

final class AudioPlayerPaused extends AudioPlayerState {
  final Duration currentPosition;
  final Duration totalDuration;

  const AudioPlayerPaused({
    required this.currentPosition,
    required this.totalDuration,
  });

  @override
  List<Object> get props => [currentPosition, totalDuration];
}

final class AudioPlayerError extends AudioPlayerState {
  final String message;

  const AudioPlayerError(this.message);

  @override
  List<Object> get props => [message];
}

final class AudioPlayerSearchResult extends AudioPlayerState {
  final List<SurahResponse> results;

  const AudioPlayerSearchResult(this.results);

  @override
  List<Object> get props => [results];
}

class AudioPlayerCompleted extends AudioPlayerState {
  final Duration totalDuration;

  const AudioPlayerCompleted({required this.totalDuration});

  @override
  List<Object> get props => [totalDuration];
}
