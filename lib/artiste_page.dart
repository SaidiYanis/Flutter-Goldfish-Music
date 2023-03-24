import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ArtistePage extends StatefulWidget {
  final String id;
  final String nom;
  final String img;
  final String artiste;
  final String son;

  ArtistePage({required this.id, required this.nom, required this.img, required this.artiste, required this.son});

  @override
  _ArtistePageState createState() => _ArtistePageState();
}

class _ArtistePageState extends State<ArtistePage> {
  late AudioPlayer _audioPlayer;
  String _logoUrl = '';

  // Méthode pour récupérer l'URL du logo depuis Firebase
  Future<void> fetchLogoUrl() async {
    final logoDoc = await FirebaseFirestore.instance.collection('logo').doc('2FcyjRwXFEUPEJ6PocBr').get();
    final logoData = logoDoc.data()! as Map<String, dynamic>;
    setState(() {
      _logoUrl = logoData['url'] ?? '';
    });
  }

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    fetchLogoUrl(); // Appelez fetchLogoUrl ici
  }

  // Libérer les ressources d'AudioPlayer lors de la suppression de l'état
  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  // Méthode Lire la musique
  Future<void> _playMusic(String url) async {
    await _audioPlayer.setUrl(url); 
    _audioPlayer.play();
  }

  // Méthode pause de la musique
  void _pauseMusic() {
    _audioPlayer.pause();
  }

  // Méthode arrêter de la musique
  void _stopMusic() {
    _audioPlayer.stop();
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Music Player'),
    ),
    body: LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Container(
          height: constraints.maxHeight,
          decoration: BoxDecoration(
            color: Colors.grey[850],
            image: _logoUrl.isNotEmpty
                ? DecorationImage(
                    image: NetworkImage(_logoUrl),
                    alignment: Alignment(-20.5, 0), // Positionnement du logo à gauche
                    fit: BoxFit.none,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.35), // Appliquer l'opacité de 65% (100% - 65% = 35%)
                      BlendMode.dstIn, // Utiliser BlendMode.dstIn pour gérer l'opacité
                    ),
                  )
                : null,
          ),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 25),
                  GestureDetector(
                    onTap: () {
                      _playMusic(widget.son);
                    },
                    child: widget.img.isNotEmpty
                        ? Image.network(
                            widget.img,
                            height: 250,
                            width: 250,
                            fit: BoxFit.cover,
                          )
                        : Container(),
                  ),
                  SizedBox(height: 8),
                  Text(widget.nom, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white70)),
                  SizedBox(height: 4),
                  Text(widget.artiste, style: TextStyle(fontSize: 20, color: Colors.grey)),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _playMusic(widget.son);
                        },
                        child: Text('Play'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _pauseMusic();
                        },
                        child: Text('Pause'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _stopMusic();
                        },
                        child: Text('Stop'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ),
  );
}
}