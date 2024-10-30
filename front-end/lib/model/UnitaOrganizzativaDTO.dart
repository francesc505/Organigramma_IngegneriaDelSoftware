import 'package:front_end_ing_software/model/GruppoDTO.dart';

class UnitaOrgnizzativaDTO {
  String nome;
  List<GruppoDTO> gruppi;

  UnitaOrgnizzativaDTO({required this.nome, required this.gruppi});

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'gruppoList': gruppi.map((g) => g.toJson()).toList(),
    };
  }
}
