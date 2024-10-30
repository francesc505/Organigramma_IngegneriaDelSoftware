package com.example.ProgettoFinale_IngegneriaDelSoftware.Mapper;

import com.example.ProgettoFinale_IngegneriaDelSoftware.Composite.Composite.Gruppo;
import com.example.ProgettoFinale_IngegneriaDelSoftware.Composite.Composite.UnitaOrganizzativa;
import com.example.ProgettoFinale_IngegneriaDelSoftware.DTO.GruppoDTO;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(componentModel = "spring", uses = {DipendenteDTOMapper.class})
public interface GruppoDTOMapper {

    @Mapping(source = "nome", target = "nome")
    @Mapping(source = "dipendenti", target = "dipendenteDTOList")
    @Mapping(source = "unitaOrganizzativa.id", target = "unitaOrganizzativaId")
    GruppoDTO toDTO(Gruppo gruppo);

    @Mapping(source = "nome", target = "nome")
    @Mapping(source = "dipendenteDTOList", target = "dipendenti")
    @Mapping(source = "unitaOrganizzativaId", target = "unitaOrganizzativa.id")
    Gruppo toEntity(GruppoDTO gruppoDTO);


}
