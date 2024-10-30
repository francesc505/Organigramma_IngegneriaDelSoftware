package com.example.ProgettoFinale_IngegneriaDelSoftware.Mapper;

import com.example.ProgettoFinale_IngegneriaDelSoftware.Composite.Leaf.Dipendente;
import com.example.ProgettoFinale_IngegneriaDelSoftware.DTO.DipendenteDTO;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(componentModel = "spring",uses = {GruppoDTOMapper.class})
public interface DipendenteDTOMapper {



    @Mapping(source = "id", target = "id")
    @Mapping(source = "nome", target = "nome")
    @Mapping(source = "cognome", target = "cognome")
    @Mapping(source = "ruolo", target = "ruolo")
    @Mapping(source = "gruppi", target = "gruppoDTOList")
    DipendenteDTO toDTO(Dipendente dipendente);

    @Mapping(source = "id", target = "id")
    @Mapping(source = "nome", target = "nome")
    @Mapping(source = "cognome", target = "cognome")
    @Mapping(source = "ruolo", target = "ruolo")
    @Mapping(source = "gruppoDTOList", target = "gruppi")
    Dipendente toEntity(DipendenteDTO dipendenteDTO);

}
