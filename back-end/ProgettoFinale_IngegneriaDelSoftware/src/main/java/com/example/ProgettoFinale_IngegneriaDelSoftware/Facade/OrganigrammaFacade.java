package com.example.ProgettoFinale_IngegneriaDelSoftware.Facade;

import com.example.ProgettoFinale_IngegneriaDelSoftware.Composite.Leaf.Dipendente;
import com.example.ProgettoFinale_IngegneriaDelSoftware.Composite.other.Gruppo;
import com.example.ProgettoFinale_IngegneriaDelSoftware.Composite.other.UnitaOrganizzativa;
import com.example.ProgettoFinale_IngegneriaDelSoftware.Service.OrganigrammaService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
public class OrganigrammaFacade {

    @Autowired
    private OrganigrammaService organigrammaService;

    public Dipendente creaDipendente(String nome , String cognome, String ruolo){
        Dipendente dipendente = new Dipendente(nome , cognome, ruolo);
        return organigrammaService.addDipendente(dipendente);
    }

    public Gruppo creaGruppo(String nome){
        Gruppo gruppo = new Gruppo(nome);
        return  organigrammaService.aggiungiGruppo(gruppo);
    }

    public UnitaOrganizzativa creaUnitaOrganizzativa(String nome) {
        UnitaOrganizzativa unita = new UnitaOrganizzativa();
        unita.setNome(nome);
        return organigrammaService.aggiungiUnitaOrganizzativa(unita);
    }

    public List<Dipendente> ottieniTuttiIDipendenti() {
        return organigrammaService.getAllDipendenti();
    }

    public List<Gruppo> ottieniTuttiIGruppi() {
        return organigrammaService.getAllGruppi();
    }

    public List<UnitaOrganizzativa> ottieniTutteLeUnitaOrganizzative() {
        return organigrammaService.getAllUnitaOrganizzative();
    }

}
