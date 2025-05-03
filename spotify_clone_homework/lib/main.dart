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

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Good Evening'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Icon(Icons.notifications_none),
          SizedBox(width: 16),
          Icon(Icons.history),
          SizedBox(width: 16),
          Icon(Icons.settings),
          SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(16),
              itemCount: albums.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemBuilder: (context, index) {
                final album = albums[index];
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
                        Flexible(
                          child: Text(
                            album['title']!,
                            style: TextStyle(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
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
                  icon: Icon(
                    _isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                  ),
                  onPressed: _togglePlayback,
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
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
