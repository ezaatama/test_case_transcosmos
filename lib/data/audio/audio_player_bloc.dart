import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:just_audio/just_audio.dart';
import 'package:test_case_transcosmos/model/surah_response.dart';
import 'package:test_case_transcosmos/service/api_service.dart';

part 'audio_player_event.dart';
part 'audio_player_state.dart';

class AudioPlayerBloc extends Bloc<AudioPlayerEvent, AudioPlayerState> {
  final ApiService apiService;
  final AudioPlayer audioPlayer;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _playerStateSubscription;
  StreamSubscription? _processingStateSubscription;

  // Menyimpan state terakhir untuk menghindari emit yang tidak perlu
  AudioPlayerState? _lastState;
  Duration _lastPosition = Duration.zero;
  Duration _lastDuration = Duration.zero;
  String? _lastAudioUrl;
  bool _isCompleted = false;

  AudioPlayerBloc({required this.apiService})
    : audioPlayer = AudioPlayer(),
      super(AudioPlayerInitial()) {
    on<LoadAudio>(_onLoadAudio);
    on<PlayAudio>(_onPlayAudio);
    on<PauseAudio>(_onPauseAudio);
    on<ResumeAudio>(_onResumeAudio);
    on<SeekAudio>(_onSeekAudio);
    on<SearchAudio>(_onSearchAudio);
    on<UpdatePosition>(_onUpdatePosition);
    on<AudioCompleted>(_onAudioCompleted);
    on<RestartAudio>(_onRestartAudio);

    _playerStateSubscription = audioPlayer.playerStateStream.listen((
      playerState,
    ) {
      if (playerState.playing) {
        add(PlayAudio());
      } else if (playerState.processingState == ProcessingState.completed) {
        add(AudioCompleted());
      }
    });

    _processingStateSubscription = audioPlayer.processingStateStream.listen((
      processingState,
    ) {
      print("Processing state: $processingState");
    });

    _positionSubscription = audioPlayer.positionStream.listen((position) {
      if (_lastPosition != position) {
        _lastPosition = position;
        add(UpdatePosition(position));

        if (_lastDuration.inMilliseconds > 0 &&
            position.inMilliseconds >= _lastDuration.inMilliseconds - 100) {
          _isCompleted = true;
        }
      }
    });
  }

  Future<void> _onLoadAudio(
    LoadAudio event,
    Emitter<AudioPlayerState> emit,
  ) async {
    try {
      emit(AudioPlayerLoading());
      print("Loading audio from: ${event.audioUrl}");

      _lastAudioUrl = event.audioUrl;
      _isCompleted = false;

      await audioPlayer.stop();

      await audioPlayer.setUrl(event.audioUrl);

      await audioPlayer.load();

      final duration = audioPlayer.duration ?? Duration.zero;
      _lastDuration = duration;
      print("Audio duration: $duration");

      final playingState = AudioPlayerPlaying(
        currentPosition: Duration.zero,
        totalDuration: duration,
        isPlaying: false, // Masih belum playing
      );

      _lastState = playingState;
      emit(playingState);

      await audioPlayer.play();

      final updatedState = AudioPlayerPlaying(
        currentPosition: Duration.zero,
        totalDuration: duration,
        isPlaying: true,
      );

      _lastState = updatedState;
      emit(updatedState);

      print("Audio started playing");
    } catch (e) {
      print("Error loading audio: $e");
      await audioPlayer.stop();
      final errorState = AudioPlayerError('Failed to load audio: $e');
      _lastState = errorState;
      emit(errorState);
    }
  }

  void _onPlayAudio(PlayAudio event, Emitter<AudioPlayerState> emit) async {
    try {
      if (state is AudioPlayerPaused || state is AudioPlayerInitial) {
        await audioPlayer.play();
        final newState = AudioPlayerPlaying(
          currentPosition: audioPlayer.position,
          totalDuration: _lastDuration,
          isPlaying: true,
        );

        _lastState = newState;
        emit(newState);
      }
    } catch (e) {
      print("Error playing audio: $e");
      await audioPlayer.stop();
      final errorState = AudioPlayerError('Failed to play audio: $e');
      _lastState = errorState;
      emit(errorState);
    }
  }

  Future<void> _onPauseAudio(
    PauseAudio event,
    Emitter<AudioPlayerState> emit,
  ) async {
    try {
      if (state is AudioPlayerPlaying) {
        final currentPosition = audioPlayer.position;
        await audioPlayer.pause();

        final newState = AudioPlayerPaused(
          currentPosition: currentPosition,
          totalDuration: _lastDuration,
        );

        _lastState = newState;
        emit(newState);
      }
    } catch (e) {
      print("Error pausing audio: $e");
      await audioPlayer.stop();
      final errorState = AudioPlayerError('Failed to pause audio: $e');
      _lastState = errorState;
      emit(errorState);
    }
  }

  Future<void> _onResumeAudio(
    ResumeAudio event,
    Emitter<AudioPlayerState> emit,
  ) async {
    try {
      if (state is AudioPlayerPaused) {
        // Lanjutkan dari posisi terakhir, bukan dari awal
        final currentState = state as AudioPlayerPaused;
        await audioPlayer.play();

        final newState = AudioPlayerPlaying(
          currentPosition: currentState.currentPosition,
          totalDuration: currentState.totalDuration,
          isPlaying: true,
        );

        _lastState = newState;
        emit(newState);
      }
    } catch (e) {
      print("Error resuming audio: $e");
      await audioPlayer.stop();
      final errorState = AudioPlayerError('Failed to resume audio: $e');
      _lastState = errorState;
      emit(errorState);
    }
  }

  Future<void> _onSeekAudio(
    SeekAudio event,
    Emitter<AudioPlayerState> emit,
  ) async {
    try {
      await audioPlayer.seek(event.position);

      if (event.position < _lastDuration) {
        _isCompleted = false;
      }

      // Update state setelah seeking
      if (state is AudioPlayerPlaying) {
        final newState = AudioPlayerPlaying(
          currentPosition: event.position,
          totalDuration: _lastDuration,
          isPlaying: true,
        );

        _lastState = newState;
        emit(newState);
      } else if (state is AudioPlayerPaused) {
        final newState = AudioPlayerPaused(
          currentPosition: event.position,
          totalDuration: _lastDuration,
        );

        _lastState = newState;
        emit(newState);
      }
    } catch (e) {
      print("Error seeking audio: $e");
      await audioPlayer.stop();
      final errorState = AudioPlayerError('Failed to seek audio: $e');
      _lastState = errorState;
      emit(errorState);
    }
  }

  Future<void> _onSearchAudio(
    SearchAudio event,
    Emitter<AudioPlayerState> emit,
  ) async {
    try {
      emit(AudioPlayerLoading());
      final results = await apiService.searchSurahs(event.query);
      final newState = AudioPlayerSearchResult(results!);
      _lastState = newState;
      emit(newState);
    } catch (e) {
      print("Error searching: $e");
      final errorState = AudioPlayerError('Failed to search: $e');
      _lastState = errorState;
      emit(errorState);
    }
  }

  void _onUpdatePosition(UpdatePosition event, Emitter<AudioPlayerState> emit) {
    // Hanya update state jika posisi berubah dan state adalah playing
    if (_lastState is AudioPlayerPlaying) {
      final currentState = _lastState as AudioPlayerPlaying;

      // Pastikan kita tidak emit state yang sama berulang kali
      if (currentState.currentPosition != event.position) {
        final newState = AudioPlayerPlaying(
          currentPosition: event.position,
          totalDuration: currentState.totalDuration,
          isPlaying: true,
        );

        _lastState = newState;
        emit(newState);
      }
    }
  }

  void _onAudioCompleted(AudioCompleted event, Emitter<AudioPlayerState> emit) {
    print("Audio completed");
    _isCompleted = true;

    final newState = AudioPlayerCompleted(totalDuration: _lastDuration);

    _lastState = newState;
    emit(newState);
  }

  Future<void> _onRestartAudio(
    RestartAudio event,
    Emitter<AudioPlayerState> emit,
  ) async {
    try {
      print("Restarting audio from beginning");
      _isCompleted = false;

      // Seek ke awal
      await audioPlayer.seek(Duration.zero);

      // Mulai play
      await audioPlayer.play();

      final newState = AudioPlayerPlaying(
        currentPosition: Duration.zero,
        totalDuration: _lastDuration,
        isPlaying: true,
      );

      _lastState = newState;
      emit(newState);
    } catch (e) {
      print("Error restarting audio: $e");
      await audioPlayer.stop();
      final errorState = AudioPlayerError('Failed to repeat audio: $e');
      _lastState = errorState;
      emit(errorState);
    }
  }

  @override
  Future<void> close() {
    _positionSubscription?.cancel();
    _playerStateSubscription?.cancel();
    _processingStateSubscription?.cancel();
    audioPlayer.dispose();
    return super.close();
  }
}
