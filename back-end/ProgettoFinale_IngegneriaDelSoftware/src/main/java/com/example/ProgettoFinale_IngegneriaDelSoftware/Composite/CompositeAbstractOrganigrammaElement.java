/*package com.example.ProgettoFinale_IngegneriaDelSoftware.Composite;

import java.util.ArrayList;

public abstract class CompositeAbstractOrganigrammaElement extends AbstractOrganigrammaElement
        implements CompositeOrganigrammaElement {

    public ArrayList<OrganigrammaElement> elements = new ArrayList<>();

    @Override
    public OrganigrammaElement getChild(int i){
        return elements.get(i);

    }

    @Override
    public void addChild(OrganigrammaElement organigrammaElement){
        elements.add(organigrammaElement);
        ((AbstractOrganigrammaElement) organigrammaElement).setParent(this);
    }

    @Override
    public void removeChild(int i){
        AbstractOrganigrammaElement el = (AbstractOrganigrammaElement)
                elements.remove(i);
        el.setParent(null);
    }


}*/