package com.example.ProgettoFinale_IngegneriaDelSoftware.Strategy;

import com.example.ProgettoFinale_IngegneriaDelSoftware.Composite.Leaf.Dipendente;
import com.example.ProgettoFinale_IngegneriaDelSoftware.Composite.Composite.Gruppo;
import com.example.ProgettoFinale_IngegneriaDelSoftware.Composite.Composite.Organigramma;
import com.example.ProgettoFinale_IngegneriaDelSoftware.Composite.Composite.UnitaOrganizzativa;
import com.example.ProgettoFinale_IngegneriaDelSoftware.DTO.OrganigrammaDTO;
import com.example.ProgettoFinale_IngegneriaDelSoftware.Mapper.OrganigrammaDTOMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;
import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;

@RestController
@CrossOrigin
public class FileSave implements SaveStrategy {

    @Autowired
    OrganigrammaDTOMapper organigrammaDTOMapper;

    @PostMapping(value = "/salvaOrganigrammaFile", consumes = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<String> save(@RequestBody OrganigrammaDTO organigrammaDTO) {
        String filePath = "salvaFile.txt"; // Specifica il percorso del file

        Organigramma organigramma = organigrammaDTOMapper.toEntity(organigrammaDTO);

        try (BufferedWriter writer = new BufferedWriter(new FileWriter(filePath, true))) {
            // Centro il nome dell'organigramma

            writer.write("NOME ORGANIGRAMMA: " + organigramma.getNome_organigramma());
            writer.newLine();
            writer.newLine(); // Riga vuota per separazione

            // Ciclo per ogni unità organizzativa
            for (UnitaOrganizzativa unitaOrganizzativa : organigramma.getUnitaList()) {
                // Scrivo il nome dell'unità organizzativa
                writer.write("NOME UNITA' ORGANIZZATIVA: " + unitaOrganizzativa.getNome());
                writer.newLine();
                writer.newLine(); // Riga vuota per separazione

                // Ciclo per ogni gruppo nell'unità
                for (Gruppo gruppo : unitaOrganizzativa.getGruppi()) {
                    // Scrivo il nome del gruppo, spostato a destra rispetto all'unità organizzativa
                    writer.write("\tNOME GRUPPO: " + gruppo.getNome());
                    writer.newLine();

                    // Ciclo per ogni dipendente del gruppo
                    writer.write("\t\tNOME DEI DIPENDENTI DEL GRUPPO:");
                    writer.newLine();

                    for (Dipendente dipendente : gruppo.getDipendenti()) {
                        // Scrivo il nome del dipendente, cognome e ruolo, con ulteriore indentazione
                        writer.write("\t\t\tNome: " + dipendente.getNome() + ", Cognome: " + dipendente.getCognome() + ", Ruolo: " + dipendente.getRuolo());
                        writer.newLine();
                    }

                    writer.newLine(); // Riga vuota per separazione tra gruppi
                }

                writer.newLine(); // Riga vuota per separazione tra unità organizzative
            }

            return ResponseEntity.ok("Salvataggio su file riuscito");
        } catch (IOException e) {
            return ResponseEntity.badRequest().body("Salvataggio su file non riuscito");
        }
    }
}