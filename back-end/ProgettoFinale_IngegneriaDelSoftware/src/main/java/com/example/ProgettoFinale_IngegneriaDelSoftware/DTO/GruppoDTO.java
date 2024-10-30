package com.example.ProgettoFinale_IngegneriaDelSoftware.DTO;


import com.example.ProgettoFinale_IngegneriaDelSoftware.Composite.Composite.UnitaOrganizzativa;
import lombok.*;

import java.util.List;

@Builder
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class GruppoDTO {
    private Long id;
    private String nome;
    private List<DipendenteDTO> dipendenteDTOList;
    private Long unitaOrganizzativaId;
}
