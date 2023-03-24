import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:just_audio/just_audio.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MusicInformation extends StatelessWidget {
  final String id;
  final String nom;
  final String img;
  final String artiste;
  final String son;

  MusicInformation({required this.id, required this.nom, required this.img, required this.artiste, required this.son});
 Widget _buildGestureDetector(BuildContext context, String son) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ArtistePage(id: id, nom: nom, img: img, artiste: artiste, son: son),
    ),
  );
},
      child: Container(
        margin: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.25),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            img.isNotEmpty
                ? Image.network(
                    img,
                    height: 145,
                    width: 145,
                    fit: BoxFit.cover,
                  )
                : Container(),
            SizedBox(height: 4),
            Text(nom, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
            SizedBox(height: 2),
            Text(artiste, style: TextStyle(fontSize: 16, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildGestureDetector(context, son);
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pour vous',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pour vous'),
      ),
      body: Container(
        color: Colors.grey[850],
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('Music').snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Erreur: ${snapshot.error}');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            return ListView(
             children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
               return MusicInformation(
                 id: document.id,
                  nom: data['nom'] ?? 'Nom inconnu',
                  img: data['img'] ?? '',
                  artiste: data['artiste'] ?? 'Artiste inconnu',
                  son: data['son'] ?? '',
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}

// ArtistePage est la classe qui affiche la page de détails de l'artiste lorsqu'un élément de musique est sélectionné.
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

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playMusic(String url) async {
    await _audioPlayer.setUrl(url);
    _audioPlayer.play();
  }

  void _pauseMusic() {
    _audioPlayer.pause();
  }

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
            color: Colors.grey[850],
            child: SingleChildScrollView(
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
          );
        },
      ),
    );
  }
}