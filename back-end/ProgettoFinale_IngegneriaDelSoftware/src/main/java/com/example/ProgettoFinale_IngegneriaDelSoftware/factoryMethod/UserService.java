package com.example.ProgettoFinale_IngegneriaDelSoftware.factoryMethod;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class UserService {

    @Autowired
    UserRepository userRepository;

    public User registerUser(String UserType, String email, String password) {
        User user = UserFactory.createUser(UserType, email, password);
        userRepository.save(user);
        return user;
    }
}