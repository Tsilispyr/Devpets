package com.example.Ask.Service;

import com.example.Ask.Repositories.AnimalRepository;
import jakarta.persistence.Column;
import jakarta.transaction.Transactional;
import org.springframework.stereotype.Service;
import com.example.Ask.Entities.Animal;
import java.util.List;


@Service
public class AnimalService {
    private AnimalRepository AnimalRepo;
    private AnimalService animalservice;
    public AnimalService(AnimalRepository AnimalRepo) {
        this.AnimalRepo = AnimalRepo;
        this.animalservice = this;
    }

    @Transactional
    public List<Animal> getAnimals() {
        return AnimalRepo.findAll();
    }

    @Transactional
    public Animal saveAnimal(Animal animal) {
        AnimalRepo.save(animal);
        return animal;
    }

    @Transactional
    public Animal getAnimal(Integer id) {
        return AnimalRepo.findById(id).get();
    }
    @Transactional
    public void Delanimal(Animal animal) {
        AnimalRepo.delete(animal);
    }


    @Transactional
    public void delAnimal(Integer id) {
        AnimalRepo.deleteById(id);
    }


    }




