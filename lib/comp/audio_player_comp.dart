import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_case_transcosmos/comp/progress_bar.dart';
import 'package:test_case_transcosmos/data/audio/audio_player_bloc.dart';

class AudioPlayerComp extends StatelessWidget {
  const AudioPlayerComp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AudioPlayerBloc, AudioPlayerState>(
      listener: (context, state) {
        if (state is AudioPlayerError) {
          // Show error message if needed
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        print("Current audio state: ${state.runtimeType}");
        if (state is AudioPlayerLoading) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 8),
                  Text('Memuat audio...'),
                ],
              ),
            ),
          );
        } else if (state is AudioPlayerPlaying) {
          return Column(
            children: [
              ProgressBar(
                currentPosition: state.currentPosition,
                totalDuration: state.totalDuration,
                onSeek: (position) {
                  context.read<AudioPlayerBloc>().add(SeekAudio(position));
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (state.isPlaying)
                    IconButton(
                      icon: const Icon(Icons.pause),
                      iconSize: 36,
                      onPressed: () {
                        context.read<AudioPlayerBloc>().add(PauseAudio());
                      },
                    )
                  else
                    const CircularProgressIndicator(),
                ],
              ),
            ],
          );
        } else if (state is AudioPlayerPaused) {
          return Column(
            children: [
              ProgressBar(
                currentPosition: state.currentPosition,
                totalDuration: state.totalDuration,
                onSeek: (position) {
                  context.read<AudioPlayerBloc>().add(SeekAudio(position));
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.play_arrow),
                    iconSize: 36,
                    onPressed: () {
                      context.read<AudioPlayerBloc>().add(ResumeAudio());
                    },
                  ),
                ],
              ),
            ],
          );
        } else if (state is AudioPlayerCompleted) {
          return Column(
            children: [
              ProgressBar(
                currentPosition: state.totalDuration,
                totalDuration: state.totalDuration,
                onSeek: (position) {
                  context.read<AudioPlayerBloc>().add(SeekAudio(position));
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.replay),
                    iconSize: 36,
                    onPressed: () {
                      context.read<AudioPlayerBloc>().add(RestartAudio());
                    },
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  "Audio selesai",
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ],
          );
        } else if (state is AudioPlayerError) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                children: [
                  Icon(Icons.error, color: Colors.red, size: 36),
                  SizedBox(height: 8),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
          );
        } else {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                children: [
                  Icon(Icons.music_note, size: 36),
                  SizedBox(height: 8),
                  Text('Pilih surah untuk memutar audio'),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
