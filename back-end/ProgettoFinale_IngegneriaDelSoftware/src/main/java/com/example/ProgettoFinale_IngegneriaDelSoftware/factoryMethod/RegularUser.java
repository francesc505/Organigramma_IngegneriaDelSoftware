package com.example.ProgettoFinale_IngegneriaDelSoftware.factoryMethod;


import jakarta.persistence.Entity;
import lombok.AllArgsConstructor;

@Entity
@AllArgsConstructor
public class RegularUser extends User{

    public RegularUser(String UserType,String email, String password) {
        this.setUserType(UserType);
        this.setEmail(email);
        this.setPassword(password);
    }


    @Override
    public String getUserType() {
        return   "Regular_User";
    }
}
