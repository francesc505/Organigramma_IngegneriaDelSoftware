package com.example.ProgettoFinale_IngegneriaDelSoftware.DTO;

import com.example.ProgettoFinale_IngegneriaDelSoftware.Composite.Composite.Gruppo;
import jakarta.persistence.Entity;
import lombok.*;

import java.util.List;

@Builder
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class DipendenteDTO {
    private Long id;
    private String nome;
    private String cognome;
    private String ruolo;
    private List<Gruppo> gruppoDTOList;
}
