package com.example.ProgettoFinale_IngegneriaDelSoftware.factoryMethod;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface UserRepository extends JpaRepository<User, String> {

    @Query("SELECT CASE WHEN COUNT(u) > 0 THEN true ELSE false END FROM User u WHERE u.email = :email")
    boolean existsByEmail(@Param("email") String email);

    @Query("SELECT CASE WHEN COUNT(u) > 0 THEN TRUE ELSE FALSE END "
            + "FROM User u WHERE u.email = :email "
            + "AND u.UserType = :userType "
            + "AND u.password = :password")
    boolean existsByEmailAndPasswordAndUserType(@Param("email") String email, @Param("userType") String userType,
                                                @Param("password") String password);
}
