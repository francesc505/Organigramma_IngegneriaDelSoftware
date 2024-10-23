package com.example.ProgettoFinale_IngegneriaDelSoftware.Composite.Leaf;


import com.example.ProgettoFinale_IngegneriaDelSoftware.Composite.CompositeOrganigrammaElement;
import com.example.ProgettoFinale_IngegneriaDelSoftware.Composite.OrganigrammaElement;
import com.example.ProgettoFinale_IngegneriaDelSoftware.Composite.other.Gruppo;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;

@Entity
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class Dipendente implements OrganigrammaElement {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    Long id;

    String nome;
    String cognome;
    String ruolo;

    @ManyToMany
    List<Gruppo> gruppi = new ArrayList<>();

    @Override
    public void setParent(CompositeOrganigrammaElement parent) {
        if(parent instanceof Gruppo) gruppi.add((Gruppo) parent);
    }

    @Override
    public CompositeOrganigrammaElement getParent() {
        return gruppi.getFirst();
    }

    @Override
    public String toString() {
        return "Dipendente{" +
                "nome='" + nome + '\'' +
                ", cognome='" + cognome + '\'' +
                ", ruolo='" + ruolo + '\'' +
                '}';
    }

    public Dipendente(String nome , String cognome, String ruolo){
        this.nome = nome;
        this.cognome = cognome;
        this.ruolo = ruolo;
    }

}