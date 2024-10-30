import 'package:front_end_ing_software/model/UnitaOrganizzativaDTO.dart';

class OrganigrammaDTO {
  String nomeAzienda;
  String visualizationType;
  List<UnitaOrgnizzativaDTO> nodi;
  
  OrganigrammaDTO(
      {required this.nomeAzienda,
      required this.visualizationType,
      required this.nodi,
});

  Map<String, dynamic> toJson() {
    return {
      'nome_organigramma': nomeAzienda,
      'visualizationType': visualizationType,
      'unitaList': nodi.map((d) => d.toJson()).toList(),
    };
  }
}

