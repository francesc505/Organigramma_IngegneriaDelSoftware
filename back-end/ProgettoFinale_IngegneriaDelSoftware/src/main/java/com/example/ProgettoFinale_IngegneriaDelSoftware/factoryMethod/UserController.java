package com.example.ProgettoFinale_IngegneriaDelSoftware.factoryMethod;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@CrossOrigin
public class UserController {

    @Autowired
    private UserService userService; // Assicurati di avere un UserService per gestire la registrazione

    @Autowired
    private UserRepository userRepository;

    @PostMapping("/register")
    public ResponseEntity<String> register(@RequestBody Login login) {
        String email = login.getEmail();
        if(userRepository.existsByEmail(email)) {
            return ResponseEntity.badRequest().body("email gia presente");
        }
        User user = userService.registerUser(login.getUserType(), email, login.getPassword());
        return ResponseEntity.ok("Utente registrato: " + user.getUserType());
    }

    @PostMapping("/login")
    public ResponseEntity<String> login(@RequestBody Login login){

        if(!userRepository.existsByEmailAndPasswordAndUserType(login.getEmail(),
                login.getUserType(), login.getPassword())){
            return ResponseEntity.badRequest().body("devi prima registrarti");
        }
        return ResponseEntity.ok("Login effettuato" + login.getUserType());
    }
}