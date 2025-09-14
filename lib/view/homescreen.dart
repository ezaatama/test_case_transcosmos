import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_case_transcosmos/comp/audio_player_comp.dart';
import 'package:test_case_transcosmos/comp/search_bar.dart';
import 'package:test_case_transcosmos/data/audio/audio_player_bloc.dart';
import 'package:test_case_transcosmos/model/surah_response.dart';
import 'package:test_case_transcosmos/service/api_service.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  final ApiService _apiService = ApiService();
  List<SurahResponse> _surah = [];
  List<SurahResponse> _searchResult = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadSurah();
  }

  Future<void> _loadSurah() async {
    try {
      final surah = await _apiService.getSurahs();
      setState(() {
        _surah = surah!;
        _searchResult = surah;
      });
    } catch (e) {
      print("Error load surah $e");
    }
  }

  void _onSearch(String query) {
    setState(() {
      _searchQuery = query;

      if (query.isEmpty) {
        _searchResult = _surah;
      } else {
        final searchText = query.toLowerCase();
        _searchResult = _surah.where((surah) {
          return surah.nama.toLowerCase().contains(searchText) ||
              surah.namaLatin.toLowerCase().contains(searchText) ||
              surah.nomor.toString().contains(searchText);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: AppBar(
        title: Text("Quran App", style: TextStyle(color: Color(0xFFFFFFFF))),
        elevation: 0,
        backgroundColor: Colors.blue,
      ),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(left: 30, right: 30, top: 20),
          child: Column(
            children: [
              SearchBarComp(onSearch: _onSearch),
              Expanded(
                child: BlocListener<AudioPlayerBloc, AudioPlayerState>(
                  listener: (context, state) {
                    if (state is AudioPlayerSearchResult) {
                      setState(() {
                        _searchResult = state.results;
                      });
                    }
                  },
                  child: _searchResult.isEmpty
                      ? const Center(
                          child: Text('Tidak ada surah yang ditemukan'),
                        )
                      : ListView.builder(
                          itemCount: _searchResult.length,
                          itemBuilder: (ctx, i) {
                            final surah = _searchResult[i];
                            return ListTile(
                              leading: Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    surah.nomor.toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              title: Text(
                                surah.nama,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              subtitle: Text(
                                surah.namaLatin,
                                style: const TextStyle(
                                  fontFamily: 'Arabic',
                                  fontSize: 16,
                                ),
                              ),
                              trailing: Text('${surah.jumlahAyat} ayat'),
                              onTap: () {
                                context.read<AudioPlayerBloc>().add(
                                  PauseAudio(),
                                );
                                context.read<AudioPlayerBloc>().add(
                                  LoadAudio(surah.audio),
                                );
                              },
                            );
                          },
                        ),
                ),
              ),
              const AudioPlayerComp(),
            ],
          ),
        ),
      ),
    );
  }
}
