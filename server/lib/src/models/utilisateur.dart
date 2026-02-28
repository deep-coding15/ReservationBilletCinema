/// Modèle Utilisateur (spectateur).
class Utilisateur {
  final int? id;
  final String nom;
  final String email;
  final String telephone;
  final String motDePasseHash;
  final List<String> preferences;
  final String statut;

  Utilisateur({
    this.id,
    required this.nom,
    required this.email,
    required this.telephone,
    required this.motDePasseHash,
    this.preferences = const [],
    this.statut = 'actif',
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'nom': nom,
        'email': email,
        'telephone': telephone,
        'motDePasseHash': motDePasseHash,
        'preferences': preferences,
        'statut': statut,
      };

  factory Utilisateur.fromJson(Map<String, dynamic> json) => Utilisateur(
        id: json['id'] as int?,
        nom: json['nom'] as String,
        email: json['email'] as String,
        telephone: json['telephone'] as String,
        motDePasseHash: json['motDePasseHash'] as String,
        preferences: (json['preferences'] as List<dynamic>?)?.cast<String>() ?? [],
        statut: json['statut'] as String? ?? 'actif',
      );
}
