package com.example.ProgettoFinale_IngegneriaDelSoftware.Strategy;

import com.example.ProgettoFinale_IngegneriaDelSoftware.Composite.Leaf.Dipendente;
import com.example.ProgettoFinale_IngegneriaDelSoftware.Composite.other.Gruppo;
import com.example.ProgettoFinale_IngegneriaDelSoftware.Composite.other.Organigramma;
import com.example.ProgettoFinale_IngegneriaDelSoftware.Composite.other.UnitaOrganizzativa;
import com.example.ProgettoFinale_IngegneriaDelSoftware.Repository.DipendenteRepository;
import com.example.ProgettoFinale_IngegneriaDelSoftware.Repository.GruppoRepository;
import com.example.ProgettoFinale_IngegneriaDelSoftware.Repository.OrganigrammaRepository;
import com.example.ProgettoFinale_IngegneriaDelSoftware.Repository.UnitaOrganizzativaRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;
import java.util.List;

@RestController
@CrossOrigin
public class DBSave implements SaveStrategy{

    @Autowired
    OrganigrammaRepository organigrammaRepository;

    @Autowired
    UnitaOrganizzativaRepository unitaOrganizzativaRepository;

    @Autowired
    GruppoRepository gruppoRepository;

    @Autowired
    DipendenteRepository dipendenteRepository;

    @PostMapping(value = "/salvaOrganigrammaDB", consumes = MediaType.APPLICATION_JSON_VALUE)
    @Transactional
    @Override
    public ResponseEntity<String> save(@RequestBody Organigramma organigramma) {
        // Crea una nuova istanza di Organigramma e imposta i valori iniziali
        Organigramma organigramma1 = new Organigramma();
        organigramma1.setNome_organigramma(organigramma.getNome_organigramma());
        organigramma1.setVisualizationType(organigramma.getVisualizationType());
        organigrammaRepository.save(organigramma1);

        // Cicla su ogni UnitaOrganizzativa nell'organigramma ricevuto
        for (UnitaOrganizzativa unita : organigramma.getUnitaList()) {
            UnitaOrganizzativa unita1 = new UnitaOrganizzativa();
            unita1.setNome(unita.getNome());
            unita1.setOrganigramma(organigramma1);  // Collega l'unità al nuovo organigramma
            unitaOrganizzativaRepository.save(unita1);  // Salva l'unità organizzativa

            // Inizializza la lista dei gruppi
            List<Gruppo> gruppiCopy = new ArrayList<>();
            for (Gruppo gruppo : unita.getGruppi()) {
                Gruppo gruppo1 = new Gruppo();
                gruppo1.setNome(gruppo.getNome());
                gruppo1.setParent(unita1);  // Collega il gruppo all'unità organizzativa
                gruppo1.setDipendenti(new ArrayList<>(gruppo.getDipendenti()));  // Crea una nuova lista di dipendenti

                // Cicla su ogni dipendente associato al gruppo
                for (Dipendente dipendente : gruppo1.getDipendenti()) {
                    if (dipendente.getGruppi() == null) {
                        dipendente.setGruppi(new ArrayList<>());
                    }
                    dipendente.getGruppi().add(gruppo1);  // Aggiungi il gruppo corrente alla lista dei gruppi
                    dipendenteRepository.save(dipendente);  // Salva il dipendente
                }

                gruppiCopy.add(gruppo1);
                gruppoRepository.save(gruppo1);  // Salva il gruppo
            }

            unita1.setGruppi(gruppiCopy);  // Imposta i gruppi copiati all'unità
        }

        return ResponseEntity.ok("Salvataggio completato");
    }



}
