package com.example.ProgettoFinale_IngegneriaDelSoftware.Composite;

public interface OrganigrammaElement {
    CompositeOrganigrammaElement getParent();

    void setParent(CompositeOrganigrammaElement parent);
}
