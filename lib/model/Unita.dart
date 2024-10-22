import 'package:front_end_ing_software/model/Gruppo.dart';

class Unita {
  String nome;
  List<Gruppo> gruppoList;

  Unita({required this.nome, required this.gruppoList});

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'gruppi': gruppoList.map((g) => g.toJson()).toList(),
    };
  }
}
