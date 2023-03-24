import 'package:flutter/material.dart';
import 'artiste_page.dart';


class MusicInformation extends StatelessWidget {
  final String id;
  final String nom;
  final String img;
  final String artiste;
  final String son;

  MusicInformation({required this.id, required this.nom, required this.img, required this.artiste, required this.son});

  // Classe représentant un élément de musique
class MusicInformation extends StatelessWidget {
  final String id;
  final String nom;
  final String img;
  final String artiste;
  final String son;

  MusicInformation({required this.id, required this.nom, required this.img, required this.artiste, required this.son});

  // Créer un widget GestureDetector pour chaque élément de musique
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
}