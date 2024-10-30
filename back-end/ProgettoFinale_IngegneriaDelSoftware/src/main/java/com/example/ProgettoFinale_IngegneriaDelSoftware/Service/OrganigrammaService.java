package com.example.ProgettoFinale_IngegneriaDelSoftware.Service;

import com.example.ProgettoFinale_IngegneriaDelSoftware.Composite.Leaf.Dipendente;
import com.example.ProgettoFinale_IngegneriaDelSoftware.Composite.Composite.Gruppo;
import com.example.ProgettoFinale_IngegneriaDelSoftware.Composite.Composite.UnitaOrganizzativa;
import com.example.ProgettoFinale_IngegneriaDelSoftware.Repository.DipendenteRepository;
import com.example.ProgettoFinale_IngegneriaDelSoftware.Repository.GruppoRepository;
import com.example.ProgettoFinale_IngegneriaDelSoftware.Repository.OrganigrammaRepository;
import com.example.ProgettoFinale_IngegneriaDelSoftware.Repository.UnitaOrganizzativaRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class OrganigrammaService {

    @Autowired
    private DipendenteRepository dipendenteRepository;

    @Autowired
    private UnitaOrganizzativaRepository unitaOrganizzativaRepository;

    @Autowired
    private OrganigrammaRepository organigrammaRepository;

    @Autowired
    private GruppoRepository gruppoRepository;

    public Dipendente addDipendente(Dipendente dipendente){
        return dipendenteRepository.save(dipendente);
    }

    public Gruppo aggiungiGruppo(Gruppo gruppo) {
        return gruppoRepository.save(gruppo);
    }

    public UnitaOrganizzativa aggiungiUnitaOrganizzativa(UnitaOrganizzativa unita) {
        return unitaOrganizzativaRepository.save(unita);
    }

    public List<Dipendente> getAllDipendenti() {
        return dipendenteRepository.findAll();
    }

    public List<Gruppo> getAllGruppi() {
        return gruppoRepository.findAll();
    }

    public List<UnitaOrganizzativa> getAllUnitaOrganizzative() {
        return unitaOrganizzativaRepository.findAll();
    }





}
