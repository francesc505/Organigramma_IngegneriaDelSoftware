package com.example.ProgettoFinale_IngegneriaDelSoftware.factoryMethod;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Login {
    private String userType;
    private String email;
    private String password;
}