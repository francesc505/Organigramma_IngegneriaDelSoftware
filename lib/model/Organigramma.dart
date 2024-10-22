import 'package:front_end_ing_software/model/Unita.dart';

class Organigramma {
  String nomeAzienda;
  String visualizationType;
  List<Unita> nodi;

  Organigramma(
      {required this.nomeAzienda,
      required this.visualizationType,
      required this.nodi});

  Map<String, dynamic> toJson() {
    return {
      'nome_organigramma': nomeAzienda,
      'visualizationType': visualizationType,
      'unitaList': nodi.map((d) => d.toJson()).toList(),
    };
  }
}