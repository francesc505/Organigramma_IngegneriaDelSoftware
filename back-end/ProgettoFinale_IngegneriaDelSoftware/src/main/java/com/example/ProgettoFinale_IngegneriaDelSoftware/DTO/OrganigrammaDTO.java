package com.example.ProgettoFinale_IngegneriaDelSoftware.DTO;

import lombok.*;

import java.util.List;

@Builder
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class OrganigrammaDTO {
    private Long id;
    private String nome_organigramma;
    private String visualizationType;
    private List<UnitaOrganizzativaDTO> unitaList;
}