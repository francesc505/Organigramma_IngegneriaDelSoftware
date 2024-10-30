package com.example.ProgettoFinale_IngegneriaDelSoftware.Mapper;

import com.example.ProgettoFinale_IngegneriaDelSoftware.Composite.Composite.UnitaOrganizzativa;
import com.example.ProgettoFinale_IngegneriaDelSoftware.DTO.UnitaOrganizzativaDTO;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(componentModel = "spring", uses = {GruppoDTOMapper.class})
public interface UnitaOrganizzativaDTOMapper {

    @Mapping(source = "organigramma.id", target = "organigrammaId")
    @Mapping(source = "gruppi", target = "gruppoList")
    UnitaOrganizzativaDTO toDTO(UnitaOrganizzativa unita);

    @Mapping(source = "organigrammaId", target = "organigramma.id")
    @Mapping(source = "gruppoList", target = "gruppi")
    UnitaOrganizzativa toEntity(UnitaOrganizzativaDTO unitaDTO);


}
