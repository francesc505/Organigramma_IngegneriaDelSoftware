package com.example.ProgettoFinale_IngegneriaDelSoftware.Mapper;

import com.example.ProgettoFinale_IngegneriaDelSoftware.Composite.Composite.Organigramma;
import com.example.ProgettoFinale_IngegneriaDelSoftware.DTO.OrganigrammaDTO;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(componentModel = "spring", uses = {UnitaOrganizzativaDTOMapper.class})
public interface OrganigrammaDTOMapper {

    @Mapping(source = "nome_organigramma", target = "nome_organigramma")
    @Mapping(source = "visualizationType", target = "visualizationType")
    @Mapping(source = "unitaList", target = "unitaList")
    OrganigrammaDTO toDTO(Organigramma organigramma);

    @Mapping(source = "nome_organigramma", target = "nome_organigramma")
    @Mapping(source = "visualizationType", target = "visualizationType")
    @Mapping(source = "unitaList", target = "unitaList")
    Organigramma toEntity(OrganigrammaDTO organigrammaDTO);


}
