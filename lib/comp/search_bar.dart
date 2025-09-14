import 'package:flutter/material.dart';

class SearchBarComp extends StatefulWidget {
  final Function(String) onSearch;

  const SearchBarComp({Key? key, required this.onSearch}) : super(key: key);

  @override
  _SearchBarCompState createState() => _SearchBarCompState();
}

class _SearchBarCompState extends State<SearchBarComp> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: 'Cari surah...',
          suffixIcon: IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              _controller.clear();
              widget.onSearch('');
            },
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        ),
        onChanged: (value) {
          widget.onSearch(value);
        },
        onSubmitted: (value) {
          widget.onSearch(value);
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
