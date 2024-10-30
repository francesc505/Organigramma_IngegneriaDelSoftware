package com.example.ProgettoFinale_IngegneriaDelSoftware.Controller;

import com.example.ProgettoFinale_IngegneriaDelSoftware.Composite.Leaf.Dipendente;
import com.example.ProgettoFinale_IngegneriaDelSoftware.Composite.Composite.Gruppo;
import com.example.ProgettoFinale_IngegneriaDelSoftware.Composite.Composite.UnitaOrganizzativa;
import com.example.ProgettoFinale_IngegneriaDelSoftware.Facade.OrganigrammaFacade;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/organigramma")
public class OrganigrammaController {
    @Autowired
    private OrganigrammaFacade organigrammaFacade;

    @PostMapping("/dipendente")
    public ResponseEntity<Dipendente> aggiungiDipendente(@RequestBody Dipendente dipendente) {
        Dipendente nuovoDipendente = organigrammaFacade.creaDipendente(dipendente.getNome(),
                dipendente.getCognome(), dipendente.getRuolo());
        return ResponseEntity.ok(nuovoDipendente);
    }

    @PostMapping("/gruppo")
    public ResponseEntity<Gruppo> aggiungiGruppo(@RequestBody Gruppo gruppo) {
        Gruppo nuovoGruppo = organigrammaFacade.creaGruppo(gruppo.getNome());
        return ResponseEntity.ok(nuovoGruppo);
    }

    @PostMapping("/unita")
    public ResponseEntity<UnitaOrganizzativa> aggiungiUnitaOrganizzativa(@RequestBody UnitaOrganizzativa unita) {
        UnitaOrganizzativa nuovaUnita = organigrammaFacade.creaUnitaOrganizzativa(unita.getNome());
        return ResponseEntity.ok(nuovaUnita);
    }

    @GetMapping("/dipendenti")
    public ResponseEntity<List<Dipendente>> ottieniDipendenti() {
        return ResponseEntity.ok(organigrammaFacade.ottieniTuttiIDipendenti());
    }

    @GetMapping("/gruppi")
    public ResponseEntity<List<Gruppo>> ottieniGruppi() {
        return ResponseEntity.ok(organigrammaFacade.ottieniTuttiIGruppi());
    }

    @GetMapping("/unita")
    public ResponseEntity<List<UnitaOrganizzativa>> ottieniUnitaOrganizzative() {
        return ResponseEntity.ok(organigrammaFacade.ottieniTutteLeUnitaOrganizzative());
    }
}