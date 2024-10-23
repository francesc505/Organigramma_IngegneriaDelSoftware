package com.example.ProgettoFinale_IngegneriaDelSoftware.factoryMethod;

public class UserFactory {
    public static User createUser(String userType, String email, String password) {
        if ("admin".equalsIgnoreCase(userType)) {
            return new AdminUser(userType,email, password);
        } else {
            return new RegularUser(userType,email, password);
        }
    }
}
