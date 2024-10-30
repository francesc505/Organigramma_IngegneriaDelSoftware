class DipendenteDTO {
  
  String nome;
  String cognome;
  String ruolo;

  DipendenteDTO({required this.nome, required this.cognome, required this.ruolo});

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'cognome': cognome,
      'ruolo': ruolo,
    };
  }
}
