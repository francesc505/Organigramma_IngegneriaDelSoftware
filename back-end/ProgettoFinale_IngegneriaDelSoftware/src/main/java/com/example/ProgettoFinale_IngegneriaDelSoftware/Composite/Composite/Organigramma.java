package com.example.ProgettoFinale_IngegneriaDelSoftware.Composite.Composite;

import com.example.ProgettoFinale_IngegneriaDelSoftware.Composite.CompositeOrganigrammaElement;
import com.example.ProgettoFinale_IngegneriaDelSoftware.Composite.OrganigrammaElement;
import com.example.ProgettoFinale_IngegneriaDelSoftware.factoryMethod.User;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;

@Entity
@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
public class Organigramma implements CompositeOrganigrammaElement {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    Long id;
    String nome_organigramma;

    String visualizationType;

    @OneToMany( cascade = CascadeType.ALL, orphanRemoval = true)
    List<UnitaOrganizzativa> unitaList = new ArrayList<>();

   // @ManyToOne
    //User user;

    @Override
    public OrganigrammaElement getChild(int i) {
        return null;
    }

    @Override
    public void addChild(OrganigrammaElement organigrammaElement) {
            if(organigrammaElement instanceof UnitaOrganizzativa) unitaList.add((UnitaOrganizzativa) organigrammaElement);
    }

    @Override
    public void removeChild(int i) {
        unitaList.remove(i);
    }

    @Override
    public CompositeOrganigrammaElement getParent() {
        return null;
    }

    @Override
    public void setParent(CompositeOrganigrammaElement parent) {}

    @Override
    public String toString(){
        return "Organigramma{" +
                "nome_organigramma='" + nome_organigramma + '\'' +
                ", visualizationType='" + visualizationType + '\'' +
                ", unitaList=" + unitaList.toString() +
                '}';
    }

}
