class Dipendente {
  
  String nome;
  String cognome;
  String ruolo;

  Dipendente({required this.nome, required this.cognome, required this.ruolo});

  Map<String, dynamic> toJson() {
    return {
     
      'nome': nome,
      'cognome': cognome,
      'ruolo': ruolo,
    };
  }
}
