package com.example.ProgettoFinale_IngegneriaDelSoftware.Composite;

public interface CompositeOrganigrammaElement extends OrganigrammaElement{
    OrganigrammaElement getChild(int i);
    void addChild(OrganigrammaElement organigrammaElement);

    void removeChild(int i);
}