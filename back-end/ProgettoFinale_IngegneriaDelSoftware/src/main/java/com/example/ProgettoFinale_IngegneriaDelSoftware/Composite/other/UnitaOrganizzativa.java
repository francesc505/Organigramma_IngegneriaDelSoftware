package com.example.ProgettoFinale_IngegneriaDelSoftware.Composite.other;
import com.example.ProgettoFinale_IngegneriaDelSoftware.Composite.CompositeOrganigrammaElement;
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
public class UnitaOrganizzativa implements CompositeOrganigrammaElement {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    Long id;
    String nome;

    @ManyToOne
    Organigramma organigramma;

    @OneToMany( cascade = CascadeType.ALL, orphanRemoval = true)
    List<Gruppo> gruppi = new ArrayList<>();

    @Override
    public OrganigrammaElement getChild(int i) {
        return  gruppi.get(i);
    }

    @Override
    public void addChild(OrganigrammaElement organigrammaElement) {
        if(organigrammaElement instanceof  Gruppo) gruppi.add((Gruppo) organigrammaElement);
    }

    @Override
    public void removeChild(int i) {
        gruppi.remove(i);
    }

    @Override
    public CompositeOrganigrammaElement getParent() {
        return organigramma;
    }

    @Override
    public void setParent(CompositeOrganigrammaElement parent) {
        if(parent instanceof Organigramma)  parent = organigramma;
    }

    @Override
    public String toString(){
        return "UnitaOrganizzativa{" +
                "nome='" + nome + '\'' +
                ", gruppi=" + gruppi.toString() +
                '}';
    }

    public UnitaOrganizzativa(String nome){
        this.nome = nome;
    }


}
