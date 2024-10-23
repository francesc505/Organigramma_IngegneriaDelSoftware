package com.example.ProgettoFinale_IngegneriaDelSoftware.Composite.other;

import com.example.ProgettoFinale_IngegneriaDelSoftware.Composite.CompositeOrganigrammaElement;
import com.example.ProgettoFinale_IngegneriaDelSoftware.Composite.Leaf.Dipendente;
import com.example.ProgettoFinale_IngegneriaDelSoftware.Composite.OrganigrammaElement;
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
public class Gruppo implements CompositeOrganigrammaElement {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    Long id;
    String nome;

    @ManyToOne
    @JoinColumn(name = "unita_organizzativa_id")
    UnitaOrganizzativa unitaOrganizzativa;

    @ManyToMany(cascade = CascadeType.PERSIST)
    List<Dipendente> dipendenti =  new ArrayList<>();

    @Override
    public OrganigrammaElement getChild(int i) {
        return null;
    }

    @Override
    public void addChild(OrganigrammaElement organigrammaElement) {
        if(organigrammaElement instanceof Dipendente) dipendenti.add((Dipendente) organigrammaElement);
    }

    @Override
    public void removeChild(int i) {
        dipendenti.remove(i);
    }

    @Override
    public CompositeOrganigrammaElement getParent() {
        return unitaOrganizzativa;
    }

    @Override
    public void setParent(CompositeOrganigrammaElement parent) {
        if(parent instanceof UnitaOrganizzativa) parent = unitaOrganizzativa;
    }

    @Override
    public String toString() {
        return "Gruppo{" +
                "nome='" + nome + '\'' +
                ", dipendenti=" + dipendenti.toString() +
                '}';
    }

    public Gruppo(String nome){
        this.nome = nome;
    }

}