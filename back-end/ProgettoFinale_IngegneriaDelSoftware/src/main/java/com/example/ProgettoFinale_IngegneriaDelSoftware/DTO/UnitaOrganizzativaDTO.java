package com.example.ProgettoFinale_IngegneriaDelSoftware.DTO;


import com.example.ProgettoFinale_IngegneriaDelSoftware.Composite.Composite.Gruppo;
import lombok.*;

import java.util.List;

@Builder
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class UnitaOrganizzativaDTO {
    private Long id;
    private String nome;
    private Long organigrammaId;
    private List<Gruppo> gruppoList;
}
