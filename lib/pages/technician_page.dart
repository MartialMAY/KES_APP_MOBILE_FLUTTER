import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';

Widget _getStatusWidget(String status) {
  String statusText;
  IconData statusIcon;
  Color iconColor;

  if (status == 'in_progress') {
    statusText = 'Incomplet';
    statusIcon = Icons.error_outline;
    iconColor = Colors.red;
  } else if (status == 'complete') {
    statusText = 'Complet';
    statusIcon = Icons.check_circle_outline;
    iconColor = Colors.green;
  } else {
    statusText = 'Statut inconnu';
    statusIcon = Icons.help_outline;
    iconColor = Colors.grey;
  }

  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(statusText),
      SizedBox(width: 5),
      Icon(
        statusIcon,
        color: iconColor,
      ),
    ],
  );
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

class TechnicianPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Technicien Interface'),
        
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('interventions')
            .where('status', whereIn: ['in_progress', 'complete'])
            .orderBy('date', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Aucune donnée disponible'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var doc = snapshot.data!.docs[index];
                return ListTile(
                  title: Text(doc['client']),
                  subtitle: Text(doc['type']),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _getStatusWidget(doc['status']),
                      SizedBox(height: 5),
                      Text(_formatDate(doc['date']?.toDate())),
                    ],
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => InterventionDetailPage(
                          docId: doc.id,
                          data: doc.data() as Map<String, dynamic>,
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}

class InterventionDetailPage extends StatefulWidget {
  final String docId;
  final Map<String, dynamic> data;

  InterventionDetailPage({required this.docId, required this.data});

  @override
  _InterventionDetailPageState createState() => _InterventionDetailPageState();
}

class _InterventionDetailPageState extends State<InterventionDetailPage> {
  final _formKey = GlobalKey<FormState>();
  final _commentController = TextEditingController();
  final _heureArriveeController = TextEditingController();
  final _heureDepartController = TextEditingController();
  final _technicienController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _commentController.text = widget.data['commentaire'] ?? '';
    _heureArriveeController.text = widget.data['heure_arrivee'] ?? '';
    _heureDepartController.text = widget.data['heure_depart'] ?? '';
    _technicienController.text = widget.data['technicien'] ?? '';
  }

  bool _isValidTimeFormat(String time) {
    final timeRegex = RegExp(r'^[0-2][0-9]:[0-5][0-9]$');
    return timeRegex.hasMatch(time);
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      await FirebaseFirestore.instance.collection('interventions').doc(widget.docId).update({
        'commentaire': _commentController.text,
        'technicien': _technicienController.text,
        'heure_arrivee': _heureArriveeController.text,
        'heure_depart': _heureDepartController.text,
        'status': 'complete',
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Intervention complétée')),
      );
      Navigator.pop(context);
    }
  }

  Future<void> _update() async {
    if (_formKey.currentState!.validate()) {
      await FirebaseFirestore.instance.collection('interventions').doc(widget.docId).update({
        'commentaire': _commentController.text,
        'technicien': _technicienController.text,
        'heure_arrivee': _heureArriveeController.text,
        'heure_depart': _heureDepartController.text,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Intervention mise à jour')),
      );
    }
  }

  Future<void> _showDeleteConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmer la suppression'),
          content: Text('Êtes-vous sûr de vouloir supprimer cette intervention ?'),
          actions: <Widget>[
            TextButton(
              child: Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Supprimer'),
              onPressed: () async {
                await FirebaseFirestore.instance.collection('interventions').doc(widget.docId).delete();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails de l\'intervention'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => _showDeleteConfirmationDialog(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  initialValue: widget.data['type'],
                  decoration: InputDecoration(labelText: 'Type de machine'),
                  readOnly: true,
                ),
                TextFormField(
                  initialValue: widget.data['marque'],
                  decoration: InputDecoration(labelText: 'Marque'),
                  readOnly: true,
                ),
                TextFormField(
                  initialValue: widget.data['modele'],
                  decoration: InputDecoration(labelText: 'Modèle'),
                  readOnly: true,
                ),
                TextFormField(
                  initialValue: widget.data['serie'],
                  decoration: InputDecoration(labelText: 'Numéro de série'),
                  readOnly: true,
                ),
                TextFormField(
                  initialValue: widget.data['client'],
                  decoration: InputDecoration(labelText: 'Client'),
                  readOnly: true,
                ),
                TextFormField(
                  controller: _technicienController,
                  decoration: InputDecoration(labelText: 'Nom technicien'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Veuillez saisir le Nom technicien';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _heureArriveeController,
                  decoration: InputDecoration(labelText: 'Heure d\'arrivée', 
                  hintText: '07:00',
                  hintStyle: TextStyle(
                  fontSize: 17,
                  color: Colors.grey.withOpacity(0.6),
                ),),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Veuillez saisir l\'heure d\'arrivée';
                    }
                    if (!_isValidTimeFormat(value)) {
                      return 'Veuillez saisir l\'heure au format HH4:MM';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _heureDepartController,
                  decoration: InputDecoration(labelText: 'Heure de départ', 
                  hintText: '07:00',
                  hintStyle: TextStyle(
                  fontSize: 17,
                  color: Colors.grey.withOpacity(0.6),
                ),),
                  
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Veuillez saisir l\'heure de départ';
                    }
                    if (!_isValidTimeFormat(value)) {
                      return 'Veuillez saisir l\'heure au format HH:MM';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _commentController,
                  decoration: InputDecoration(labelText: 'Commentaire'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Veuillez saisir le Commentaire';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: _submit,
                      child: Text('Compléter Intervention'),
                    ),
                    ElevatedButton(
                      onPressed: _update,
                      child: Text('Mettre à jour'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
