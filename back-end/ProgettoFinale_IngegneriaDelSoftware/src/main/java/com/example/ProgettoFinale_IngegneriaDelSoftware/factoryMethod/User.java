package com.example.ProgettoFinale_IngegneriaDelSoftware.factoryMethod;

import com.example.ProgettoFinale_IngegneriaDelSoftware.Composite.other.Organigramma;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;

@Entity
@Inheritance(strategy = InheritanceType.JOINED)
@NoArgsConstructor
@Getter
@Setter
@Table(name="users")
public abstract class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY) // Strategia di generazione per l'ID
    private Long id;
    String email;
    String password;
    String UserType;

    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL) // Associa la relazione
    private List<Organigramma> organigrammi;


}
