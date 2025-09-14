part of 'audio_player_bloc.dart';

sealed class AudioPlayerEvent extends Equatable {
  const AudioPlayerEvent();

  @override
  List<Object> get props => [];
}

class LoadAudio extends AudioPlayerEvent {
  final String audioUrl;

  const LoadAudio(this.audioUrl);
}

class PlayAudio extends AudioPlayerEvent {}

class PauseAudio extends AudioPlayerEvent {}

class ResumeAudio extends AudioPlayerEvent {}

class SeekAudio extends AudioPlayerEvent {
  final Duration position;

  const SeekAudio(this.position);
}

class SearchAudio extends AudioPlayerEvent {
  final String query;

  const SearchAudio(this.query);
}

class UpdatePosition extends AudioPlayerEvent {
  final Duration position;

  const UpdatePosition(this.position);
}

class AudioCompleted extends AudioPlayerEvent {}

class RestartAudio extends AudioPlayerEvent {}
