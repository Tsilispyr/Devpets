package com.example.Ask.Controllers;

import com.example.Ask.Service.AnimalService;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.*;
import com.example.Ask.Entities.Animal;
import com.example.Ask.Entities.Gender;
import java.util.List;
import org.springframework.http.ResponseEntity;
import com.example.Ask.Repositories.RequestRepository;
import com.example.Ask.Service.EmailService;
import com.example.Ask.Entities.Request;
import java.util.Optional;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.Authentication;
import com.example.Ask.Service.UserService;
import com.example.Ask.Entities.User;

@RestController
@RequestMapping("/api/animals")
public class AnimalController {

    private AnimalService animalservice;
    private RequestRepository requestRepository;
    private EmailService emailService;
    private UserService userService;

    public AnimalController(AnimalService animalservice, RequestRepository requestRepository, EmailService emailService, UserService userService) {
        this.animalservice = animalservice;
        this.requestRepository = requestRepository;
        this.emailService = emailService;
        this.userService = userService;
    }

    @RequestMapping("")
    public List<Animal> showAnimals() {
        return animalservice.getAnimals();
    }

    @GetMapping("/{id}")
    public Animal showAnimal(@PathVariable Integer id){
        return animalservice.getAnimal(id);
    }

    @PostMapping("")
    public Animal createAnimal(@RequestBody Animal animal) {
        return animalservice.saveAnimal(animal);
    }

    @PutMapping("/{id}")
    public Animal updateAnimal(@PathVariable Integer id, @RequestBody Animal animal) {
        animal.setId(id);
        return animalservice.saveAnimal(animal);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteAnimal(@PathVariable Integer id) {
        Animal animal = animalservice.getAnimal(id);
        animalservice.Delanimal(animal);
        return ResponseEntity.noContent().build();
    }

    @PutMapping("/Request/{id}")
    public Animal requestAnimal(@PathVariable Integer id) {
        Animal animal = animalservice.getAnimal(id);
        animal.setReq(1);
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String username = authentication.getName();
        User user = userService.findByUsername(username);
        animal.setUserId(user != null ? user.getId() : null);
        return animalservice.saveAnimal(animal);
    }

    @PutMapping("/Deny/{id}")
    public Animal denyAnimal(@PathVariable Integer id) {
        Animal animal = animalservice.getAnimal(id);
        animal.setReq(0);
        return animalservice.saveAnimal(animal);
    }

    @PostMapping("/{id}/accept-adoption")
    public ResponseEntity<String> acceptAdoption(@PathVariable Integer id) {
        Animal animal = animalservice.getAnimal(id);
        // Get the user email from the userId field
        String userEmail = null;
        if (animal.getUserId() != null) {
            User user = userService.getUser(animal.getUserId());
            if (user != null) {
                userEmail = user.getEmail();
            }
        }
        if (userEmail != null) {
            emailService.send(userEmail, "Η υιοθεσία σας έγινε αποδεκτή!", "Η υιοθεσία του ζώου " + animal.getName() + " έγινε αποδεκτή.");
        }
        animalservice.Delanimal(animal);
        return ResponseEntity.ok("Adoption accepted, animal deleted, and email sent.");
    }







}