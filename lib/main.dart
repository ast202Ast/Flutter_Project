import 'package:flutter/material.dart';

void main() {
  runApp(AjouterEtuApp());
}

class AjouterEtuApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AjouterEtu',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AjouterEtuHome(),
    );
  }
}

class AjouterEtuHome extends StatefulWidget {
  @override
  _AjouterEtuHomeState createState() => _AjouterEtuHomeState();
}

class _AjouterEtuHomeState extends State<AjouterEtuHome> {
  final List<Map<String, String>> etudiants =
      []; // Liste qui stocke les étudiants

  void ajouterEtu(String nom, String prenom, String email) {
    setState(() {
      etudiants.add({"nom": nom, "prenom": prenom, "email": email});
    });
  }

  void supprEtu(int index) {
    setState(() {
      etudiants.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: Navigator(
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/':
              return MaterialPageRoute(
                builder: (context) => ajouterEtuPage(onajouterEtu: ajouterEtu),
              );
            case '/etudiants':
              return MaterialPageRoute(
                builder: (context) => etudiantsListPage(
                  etudiants: etudiants,
                  onsupprEtu: supprEtu,
                ),
              );
            case '/details':
              final args = settings.arguments as Map<String,
                  dynamic>?; // Eviter les erreurs dûes aux valeurs nulles
              if (args != null &&
                  args.containsKey('etudiant') &&
                  args.containsKey('index')) {
                return MaterialPageRoute(
                  builder: (context) => etudiantDetailPage(
                    etudiant: args['etudiant'] as Map<String, String>,
                    index: args['index'] as int,
                    onsupprEtu: supprEtu,
                  ),
                );
              }
              return null;
            default:
              return MaterialPageRoute(
                  builder: (context) =>
                      ajouterEtuPage(onajouterEtu: ajouterEtu));
          }
        },
      ),
    );
  }
}

class ajouterEtuPage extends StatelessWidget {
  final Function(String, String, String) onajouterEtu;
  final TextEditingController nomController = TextEditingController();
  final TextEditingController prenomController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  ajouterEtuPage({required this.onajouterEtu});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text('Nouvel étudiant',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Divider(color: Colors.black, thickness: 1.5),
          SizedBox(height: 30),
          TextField(
              controller: nomController,
              decoration: InputDecoration(
                labelText: 'Nom',
                labelStyle: TextStyle(color: Colors.black), // Couleur du label
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.black), // Couleur de la bordure inactive
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.black), // Couleur de la bordure active
                ),
              )),
          SizedBox(height: 20),
          TextField(
              controller: prenomController,
              decoration: InputDecoration(
                labelText: 'Prénom',
                labelStyle: TextStyle(color: Colors.black), // Couleur du label
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.black), // Couleur de la bordure inactive
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.black), // Couleur de la bordure active
                ),
              )),
          SizedBox(height: 20),
          TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: Colors.black), // Couleur du label
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.black), // Couleur de la bordure inactive
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.black), // Couleur de la bordure active
                ),
              )),
          SizedBox(height: 50),
          ElevatedButton(
            onPressed: () {
              onajouterEtu(nomController.text, prenomController.text,
                  emailController.text);
              Navigator.pushReplacementNamed(context, '/etudiants');
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(
                  horizontal: 32, vertical: 16), // Agrandir le bouton
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5), // Bordures plus carrées
              ),
              textStyle: TextStyle(fontSize: 18), // Agrandir le texte
            ),
            child: Text('Enregistrer', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }
}

class etudiantsListPage extends StatelessWidget {
  final List<Map<String, String>> etudiants;
  final Function(int) onsupprEtu;

  etudiantsListPage({required this.etudiants, required this.onsupprEtu});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Liste des étudiants',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add, size: 35),
            onPressed: () => Navigator.pushReplacementNamed(context, '/'),
          ),
        ],
      ),
      body: etudiants.isEmpty
          ? Center(child: Text('Aucun étudiant enregistré'))
          : ListView.builder(
              itemCount: etudiants.length,
              itemBuilder: (context, index) {
                final etudiant = etudiants[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey,
                  ),
                  title: Text('${etudiant["prenom"]} ${etudiant["nom"]}'),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/details',
                      arguments: {'etudiant': etudiant, 'index': index},
                    );
                  },
                );
              },
            ),
    );
  }
}

class etudiantDetailPage extends StatelessWidget {
  final Map<String, String> etudiant;
  final int index;
  final Function(int) onsupprEtu;

  etudiantDetailPage(
      {required this.etudiant, required this.index, required this.onsupprEtu});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Détails')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey,
            ),
            SizedBox(height: 20),
            Text('Nom : ${etudiant["nom"]}', style: TextStyle(fontSize: 18)),
            Text('Prénom : ${etudiant["prenom"]}',
                style: TextStyle(fontSize: 18)),
            Text('Email : ${etudiant["email"]}',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            Text('Lorem ipsum dolor sit amet, ' * 10,
                maxLines: 10, overflow: TextOverflow.ellipsis),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                onsupprEtu(index);
                Navigator.pushReplacementNamed(context, '/etudiants');
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                    horizontal: 32, vertical: 16), // Agrandir le bouton
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(5), // Bordures plus carrées
                ),
                textStyle: TextStyle(fontSize: 18), // Agrandir le texte
              ),
              child: Text('Supprimer', style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }
}
