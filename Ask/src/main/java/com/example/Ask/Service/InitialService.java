package com.example.Ask.Service;

import com.example.Ask.Entities.*;
import com.example.Ask.Repositories.AnimalRepository;
import com.example.Ask.Repositories.RequestRepository;
import com.example.Ask.Repositories.RoleRepository;
import com.example.Ask.Repositories.UserRepository;
import jakarta.annotation.PostConstruct;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import java.util.HashSet;
import java.util.Set;

@Service
public class InitialService {
    BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
    UserRepository userRepository;
    UserService userService;
    RoleRepository roleRepository;
    AnimalRepository animalRepository;
    AnimalService animalService;
    RequestService requestService;
    RequestRepository requestRepository;
    public InitialService(UserRepository userRepository, UserService userService, RoleRepository roleRepository, BCryptPasswordEncoder passwordEncoder, AnimalRepository animalRepository, AnimalService animalService, RequestRepository requestRepository, RequestService requestService) {
        this.userRepository = userRepository;
        this.userService = userService;
        this.roleRepository = roleRepository;
        this.passwordEncoder = passwordEncoder;
        this.animalRepository = animalRepository;
        this.animalService = animalService;
        this.requestRepository = requestRepository;
        this.requestService = requestService;
    }

    public void AnimalInitial() {
        createRequestIfNotFound("Alex", 8, Gender.Male, "Dog");
        createRequestIfNotFound("Coco", 8, Gender.Male, "Parrot");

        createAnimalIfNotFound("Pepper", 2, Gender.Female, "Cat");
        createAnimalIfNotFound("Nova", 1, Gender.Male, "Dog");
    }

    private void createRequestIfNotFound(String name, int age, Gender gender, String type) {
        this.requestRepository.findByName(name).orElseGet(() -> {
            Request request = new Request();
            request.setAge(age);
            request.setGender(gender);
            request.setType(type);
            request.setName(name);
            requestService.saveRequest(request);
            return null;
        });
    }

    private void createAnimalIfNotFound(String name, int age, Gender gender, String type) {
        this.animalRepository.findByName(name).orElseGet(() -> {
            Animal animal = new Animal();
            animal.setAge(age);
            animal.setGender(gender);
            animal.setType(type);
            animal.setName(name);
            animalService.saveAnimal(animal);
            return null;
        });
    }
@PostConstruct
    public void init() {
        this.AnimalInitial();
        // Create initial roles if not exist
        Role adminRole = roleRepository.findByName("ROLE_ADMIN").orElseGet(() -> roleRepository.save(new Role("ROLE_ADMIN")));
        Role userRole = roleRepository.findByName("ROLE_USER").orElseGet(() -> roleRepository.save(new Role("ROLE_USER")));
        Role doctorRole = roleRepository.findByName("ROLE_DOCTOR").orElseGet(() -> roleRepository.save(new Role("ROLE_DOCTOR")));
        Role shelterRole = roleRepository.findByName("ROLE_SHELTER").orElseGet(() -> roleRepository.save(new Role("ROLE_SHELTER")));
        // Create initial admin and user if not exist
        userRepository.findByUsername("admin").orElseGet(() -> {
            User admin = new User("admin", "admin@hua.gr", passwordEncoder.encode("admin"));
            Set<Role> roles = new HashSet<>();
            roles.add(adminRole);
            admin.setRoles(roles);
            admin.setEmailVerified(true);
            userRepository.save(admin);
            return admin;
        });
        userRepository.findByUsername("user").orElseGet(() -> {
            User user = new User("user", "user@hua.gr", passwordEncoder.encode("user"));
            Set<Role> roles = new HashSet<>();
            roles.add(userRole);
            user.setRoles(roles);
            user.setEmailVerified(true);
            userRepository.save(user);
            return user;
        });
        userRepository.findByUsername("doctor").orElseGet(() -> {
            User doctor = new User("doctor", "doctor@hua.gr", passwordEncoder.encode("doctor"));
            Set<Role> roles = new HashSet<>();
            roles.add(doctorRole);
            doctor.setRoles(roles);
            doctor.setEmailVerified(true);
            userRepository.save(doctor);
            return doctor;
        });
        userRepository.findByUsername("shelter").orElseGet(() -> {
            User shelter = new User("shelter", "shelter@hua.gr", passwordEncoder.encode("shelter"));
            Set<Role> roles = new HashSet<>();
            roles.add(shelterRole);
            shelter.setRoles(roles);
            shelter.setEmailVerified(true);
            userRepository.save(shelter);
            return shelter;
        });
    }
}

