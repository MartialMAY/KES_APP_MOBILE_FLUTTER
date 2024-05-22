import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';

class AssistantPage extends StatefulWidget {
  @override
  _AssistantPageState createState() => _AssistantPageState();
}

String _formatDate(DateTime? date) {
  if (date == null) return 'Date inconnue';

  DateTime now = DateTime.now();
  DateTime startOfToday = DateTime(now.year, now.month, now.day);

  if (date.isAfter(startOfToday)) {
    return 'Aujourd\'hui';
  }

  return '${date.day}/${date.month}/${date.year}';
}

class _AssistantPageState extends State<AssistantPage> {
  final _formKey = GlobalKey<FormState>();
  final _typeController = TextEditingController();
  final _marqueController = TextEditingController();
  final _modeleController = TextEditingController();
  final _serieController = TextEditingController();
  final _clientController = TextEditingController();
  bool _sousContrat = false;

  Future<void> _createIntervention() async {
    if (_formKey.currentState!.validate()) {
      await FirebaseFirestore.instance.collection('interventions').add({
        'date': Timestamp.now(),
        'num': DateTime.now().millisecondsSinceEpoch.toString(),
        'type': _typeController.text,
        'marque': _marqueController.text,
        'modele': _modeleController.text,
        'serie': _serieController.text,
        'client': _clientController.text,
        'sous_contrat': _sousContrat,
        'status': 'in_progress',
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Intervention créée')),
      );
      _formKey.currentState!.reset();
    }
  }

  void _updateIntervention(DocumentSnapshot doc) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Modifier Intervention'),
          content: SingleChildScrollView(
            child: Form(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: TextEditingController(text: doc['type']),
                    decoration: InputDecoration(labelText: 'Type de machine'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Veuillez entrer le type de machine';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: TextEditingController(text: doc['marque']),
                    decoration: InputDecoration(labelText: 'Marque'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Veuillez entrer le type de marque';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: TextEditingController(text: doc['modele']),
                    decoration: InputDecoration(labelText: 'Modèle'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Veuillez entrer le type de modèle';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: TextEditingController(text: doc['serie']),
                    decoration: InputDecoration(labelText: 'Numéro de série'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Veuillez entrer le type de numéro de série';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: TextEditingController(text: doc['client']),
                    decoration: InputDecoration(labelText: 'Client'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Veuillez entrer le type de client';
                      }
                      return null;
                    },
                  ),
                  SwitchListTile(
                    title: Text('Sous Contrat'),
                    value: doc['sous_contrat'],
                    onChanged: (bool value) {
                      setState(() {
                        _sousContrat = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Mettez à jour l'intervention dans Firestore
                FirebaseFirestore.instance
                    .collection('interventions')
                    .doc(doc.id)
                    .update({
                  'type': _typeController.text,
                  'marque': _marqueController.text,
                  'modele': _modeleController.text,
                  'serie': _serieController.text,
                  'client': _clientController.text,
                  'sous_contrat': _sousContrat,
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Intervention mise à jour')),
                );
                Navigator.of(context).pop();
              },
              child: Text('Mettre à jour'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Annuler'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteIntervention(DocumentSnapshot doc) async {
    await FirebaseFirestore.instance
        .collection('interventions')
        .doc(doc.id)
        .delete();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Intervention supprimée')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assistant Interface'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _typeController,
                  decoration: InputDecoration(labelText: 'Type de machine'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Veuillez saisir le type de machine';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _marqueController,
                  decoration: InputDecoration(labelText: 'Marque'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Veuillez saisir le marque';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _modeleController,
                  decoration: InputDecoration(labelText: 'Modèle'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Veuillez saisir le modèle';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _serieController,
                  decoration: InputDecoration(labelText: 'Numéro de série'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Veuillez saisir le numéro de série';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _clientController,
                  decoration: InputDecoration(labelText: 'Client'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Veuillez saisir le client';
                    }
                    return null;
                  },
                ),
                SwitchListTile(
                  title: Text('Sous Contrat'),
                  value: _sousContrat,
                  onChanged: (bool value) {
                    setState(() {
                      _sousContrat = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _createIntervention,
                  child: Text('Créer Intervention'),
                ),
                SizedBox(height: 20),
                Text(
                  'Interventions ajoutées:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('interventions')
                      .where('status', whereIn: ['in_progress', 'complete'])
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }
                    return ListView(
                      shrinkWrap: true,
                      children: snapshot.data!.docs.map((snap) {
                        return Card(
                          child: ListTile(
                            title: Text(snap['client'].toString()),
                            subtitle: Text(snap['type'].toString()),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(_formatDate(snap['date']?.toDate())),
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    _updateIntervention(snap);
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    _deleteIntervention(snap);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
