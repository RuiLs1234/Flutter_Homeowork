import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

void main() {
  runApp(SpotifyCloneApp());
}

class SpotifyCloneApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spotify Clone Homework',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: SpotifyHomePage(),
    );
  }
}

class SpotifyHomePage extends StatefulWidget {
  @override
  _SpotifyHomePageState createState() => _SpotifyHomePageState();
}

class _SpotifyHomePageState extends State<SpotifyHomePage> {
  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;
  String _nowPlayingTitle = 'Nothing Playing';
  String _searchQuery = '';
  int _selectedIndex = 0;

  final List<Map<String, String>> albums = [
    {
      'title': 'Focus Flow',
      'artist': 'Lo-Fi',
      'cover': '🎵',
      'url': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
    },
    {
      'title': 'Chill Beats',
      'artist': 'Various',
      'cover': '🎧',
      'url': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
    },
    {
      'title': 'Workout',
      'artist': 'Pump Up',
      'cover': '💪',
      'url': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
    },
    {
      'title': 'Jazz Vibes',
      'artist': 'Smooth',
      'cover': '🎷',
      'url': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3',
    },
  ];

  final List<String> favorites = [];

  List<Map<String, String>> get _filteredAlbums {
    List<Map<String, String>> base = _selectedIndex == 2
        ? albums.where((album) => favorites.contains(album['title'])).toList()
        : albums;

    if (_searchQuery.isEmpty) return base;
    return base
        .where((album) => album['title']!.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  void _togglePlayback() async {
    if (_player.playing) {
      await _player.pause();
      setState(() => _isPlaying = false);
    } else {
      await _player.play();
      setState(() => _isPlaying = true);
    }
  }

  Future<void> _playAlbum(Map<String, String> album) async {
    await _player.setUrl(album['url']!);
    await _player.play();
    setState(() {
      _isPlaying = true;
      _nowPlayingTitle = album['title']!;
    });
  }

  void _toggleFavorite(String title) {
    setState(() {
      if (favorites.contains(title)) {
        favorites.remove(title);
      } else {
        favorites.add(title);
      }
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedIndex == 2 ? 'Your Library' : 'Good Evening'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          if (_selectedIndex != 2) Icon(Icons.notifications_none),
          if (_selectedIndex != 2) SizedBox(width: 16),
          if (_selectedIndex != 2) Icon(Icons.history),
          if (_selectedIndex != 2) SizedBox(width: 16),
          Icon(Icons.settings),
          SizedBox(width: 16),
        ],
        bottom: _selectedIndex == 1
            ? PreferredSize(
          preferredSize: Size.fromHeight(48),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search (e.g. workout)',
                hintStyle: TextStyle(color: Colors.white60),
                filled: true,
                fillColor: Colors.grey[800],
                prefixIcon: Icon(Icons.search, color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        )
            : null,
      ),
      body: Column(
        children: [
          Expanded(
            child: _filteredAlbums.isEmpty
                ? Center(
              child: Text(
                _selectedIndex == 2
                    ? 'No favorites yet.'
                    : 'No results found.',
                style: TextStyle(color: Colors.white70),
              ),
            )
                : GridView.builder(
              padding: EdgeInsets.all(16),
              itemCount: _filteredAlbums.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemBuilder: (context, index) {
                final album = _filteredAlbums[index];
                final isFav = favorites.contains(album['title']);
                return GestureDetector(
                  onTap: () => _playAlbum(album),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[850],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.all(8),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.green,
                          child: Text(album['cover']!, style: TextStyle(fontSize: 16)),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                album['title']!,
                                style: TextStyle(fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            color: isFav ? Colors.red : Colors.white,
                          ),
                          onPressed: () {
                            _toggleFavorite(album['title']!);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            color: Colors.grey[900],
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(Icons.music_note, color: Colors.white),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Now Playing: $_nowPlayingTitle',
                    style: TextStyle(fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.white),
                  onPressed: _togglePlayback,
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() {
          _selectedIndex = index;
          _searchQuery = '';
        }),
        backgroundColor: Colors.black,
        selectedItemColor: Colors.greenAccent[400],
        unselectedItemColor: Colors.white70,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.library_music), label: 'Library'),
        ],
      ),
    );
  }
}
