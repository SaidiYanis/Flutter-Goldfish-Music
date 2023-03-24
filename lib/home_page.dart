import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'music_information.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Ajoutez cette méthode pour récupérer l'URL du logo depuis Firebase
  String _logoUrl = '';

  Future<void> fetchLogoUrl() async {
    final logoDoc = await FirebaseFirestore.instance.collection('logo').doc('o2lIEGcVl8FNO5TH6JwN').get();
    final logoData = logoDoc.data()! as Map<String, dynamic>;
    setState(() {
      _logoUrl = logoData['url'] ?? '';
    });
  }

  @override
  void initState() {
    super.initState();
    fetchLogoUrl(); // Appelez fetchLogoUrl ici
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GoldFish Music'),
    actions: [
      _logoUrl.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.network(
              _logoUrl,
              height: 30, // Ajustez la hauteur selon vos préférences
              fit: BoxFit.cover,
            ),
          )
        : Container(),
  ],
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

