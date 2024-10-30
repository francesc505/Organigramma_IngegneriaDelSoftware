import 'package:front_end_ing_software/model/DipendenteDTO.dart';

class GruppoDTO {
  
  String nome;
  List<DipendenteDTO> dipendenteList;

  GruppoDTO({required this.nome, required this.dipendenteList});

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'dipendenti': dipendenteList.map((d) => d.toJson()).toList(),
    };
  }
}
