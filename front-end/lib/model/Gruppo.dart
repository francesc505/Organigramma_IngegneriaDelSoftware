
import 'package:front_end_ing_software/model/Dipendente.dart';

class Gruppo {
  
  String nome;
  List<Dipendente> dipendenteList;

  Gruppo({required this.nome, required this.dipendenteList});

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'dipendenti': dipendenteList.map((d) => d.toJson()).toList(),
    };
  }
}
