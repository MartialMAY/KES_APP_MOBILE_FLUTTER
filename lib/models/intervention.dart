// intervention_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Intervention {
  String id;
  String type;
  String marque;
  String modele;
  String serie;
  String client;
  bool sousContrat;
  String status;
  String commentaire;
  String heureArrivee;
  String heureDepart;
  String technicien;

  Intervention({
    required this.id,
    required this.type,
    required this.marque,
    required this.modele,
    required this.serie,
    required this.client,
    required this.sousContrat,
    required this.status,
    this.commentaire = '',
    this.heureArrivee = '',
    this.heureDepart = '',
    this.technicien = '',
  });

  factory Intervention.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Intervention(
      id: doc.id,
      type: data['type'] ?? '',
      marque: data['marque'] ?? '',
      modele: data['modele'] ?? '',
      serie: data['serie'] ?? '',
      client: data['client'] ?? '',
      sousContrat: data['sous_contrat'] ?? false,
      status: data['status'] ?? 'in_progress',
      commentaire: data['commentaire'] ?? '',
      heureArrivee: data['heure_arrivee'] ?? '',
      heureDepart: data['heure_depart'] ?? '',
      technicien: data['technicien'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'marque': marque,
      'modele': modele,
      'serie': serie,
      'client': client,
      'sous_contrat': sousContrat,
      'status': status,
      'commentaire': commentaire,
      'heure_arrivee': heureArrivee,
      'heure_depart': heureDepart,
      'technicien': technicien,
    };
  }
}
