package com.example.ProgettoFinale_IngegneriaDelSoftware.Strategy;

import com.example.ProgettoFinale_IngegneriaDelSoftware.Composite.other.Organigramma;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestBody;

public interface SaveStrategy {
    ResponseEntity<String> save(@RequestBody Organigramma organigramma);
}
