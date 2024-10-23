package com.example.ProgettoFinale_IngegneriaDelSoftware.factoryMethod;

import jakarta.persistence.Entity;
import lombok.AllArgsConstructor;


@Entity
@AllArgsConstructor
public class AdminUser extends User {

    public AdminUser(String UserType,String email, String password){
        this.setUserType(UserType);
        this.setEmail(email);
        this.setPassword(password);
    }



    @Override
    public String getUserType() {
        return "Admin"; // Restituisce il ruolo
    }

}