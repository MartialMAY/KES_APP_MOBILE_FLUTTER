import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InterventionForm extends StatefulWidget {
  @override
  _InterventionFormState createState() => _InterventionFormState();
}

class _InterventionFormState extends State<InterventionForm> {
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _numController = TextEditingController();
  final _typeController = TextEditingController();
  final _marqueController = TextEditingController();
  final _modeleController = TextEditingController();
  final _serieController = TextEditingController();
  final _clientController = TextEditingController();
  final _commentController = TextEditingController();
  final _technicienController = TextEditingController();
  final _arriveeController = TextEditingController();
  final _departController = TextEditingController();
  final _designationController = TextEditingController();
  final _referenceController = TextEditingController();
  final _quantiteController = TextEditingController();
  bool _sousContrat = false;

  Future<void> _addIntervention() async {
    if (_formKey.currentState!.validate()) {
      await FirebaseFirestore.instance.collection('interventions').add({
        'date': _dateController.text,
        'num': _numController.text,
        'type': _typeController.text,
        'marque': _marqueController.text,
        'modele': _modeleController.text,
        'serie': _serieController.text,
        'client': _clientController.text,
        'commentaire': _commentController.text,
        'technicien': _technicienController.text,
        'arrivee': _arriveeController.text,
        'depart': _departController.text,
        'designation': _designationController.text,
        'reference': _referenceController.text,
        'quantite': int.parse(_quantiteController.text),
        'sous_contrat': _sousContrat,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Intervention ajoutée')),
      );
      _formKey.currentState!.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fiche d\'Intervention'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _dateController,
                  decoration: InputDecoration(labelText: 'Date'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer une date';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _numController,
                  decoration: InputDecoration(labelText: 'Numéro d\'intervention'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un numéro d\'intervention';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _typeController,
                  decoration: InputDecoration(labelText: 'Type de machine'),
                ),
                TextFormField(
                  controller: _marqueController,
                  decoration: InputDecoration(labelText: 'Marque'),
                ),
                TextFormField(
                  controller: _modeleController,
                  decoration: InputDecoration(labelText: 'Modèle'),
                ),
                TextFormField(
                  controller: _serieController,
                  decoration: InputDecoration(labelText: 'Numéro de série'),
                ),
                TextFormField(
                  controller: _clientController,
                  decoration: InputDecoration(labelText: 'Client'),
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
                TextFormField(
                  controller: _commentController,
                  decoration: InputDecoration(labelText: 'Commentaire'),
                ),
                TextFormField(
                  controller: _technicienController,
                  decoration: InputDecoration(labelText: 'Nom technicien'),
                ),
                TextFormField(
                  controller: _arriveeController,
                  decoration: InputDecoration(labelText: 'Heure d\'arrivée'),
                ),
                TextFormField(
                  controller: _departController,
                  decoration: InputDecoration(labelText: 'Heure de départ'),
                ),
                TextFormField(
                  controller: _designationController,
                  decoration: InputDecoration(labelText: 'Désignation'),
                ),
                TextFormField(
                  controller: _referenceController,
                  decoration: InputDecoration(labelText: 'Référence'),
                ),
                TextFormField(
                  controller: _quantiteController,
                  decoration: InputDecoration(labelText: 'Quantité'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer une quantité';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Veuillez entrer un nombre valide';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _addIntervention,
                  child: Text('Ajouter Intervention'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
