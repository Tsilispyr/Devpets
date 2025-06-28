package com.example.Ask.Repositories;

import com.example.Ask.Entities.Animal;
import com.example.Ask.Entities.Role;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface AnimalRepository extends JpaRepository<Animal, Integer> {
    Optional<Animal> findByName(String animalName);

}