package com.example.Ask.Service;

import com.example.Ask.Entities.Animal;
import com.example.Ask.Repositories.AnimalRepository;
import com.example.Ask.Repositories.RequestRepository;
import jakarta.persistence.Column;
import jakarta.transaction.Transactional;
import org.springframework.stereotype.Service;
import com.example.Ask.Entities.Request;
import java.util.List;
@Service
public class RequestService {
    private final AnimalService animalService;
    private RequestRepository requestRepository;
    private RequestService requestService;

    public RequestService(RequestRepository requestRepository, AnimalService animalService) {
        this.requestRepository = requestRepository;
        this.requestService = this;
        this.animalService = animalService;
    }

    @Transactional
    public List<Request> getRequests() {
        return requestRepository.findAll();
    }

    @Transactional
    public Request saveRequest(Request request) {
        requestRepository.save(request);
        return request;
    }

    @Transactional
    public Request getRequest(Integer id) {
        return requestRepository.findById(id).orElse(null);
    }
    @Transactional
    public void DelRequest(Request request) {
        requestRepository.delete(request);
    }






    @Transactional
    public void CheckRequest(Request request) {

        int check =1;
            if (request.getDocApproved() == 1 && request.getAdminApproved() == 1) {
                Animal animal = new Animal();
                animal.setAge(request.getAge());
                animal.setGender(request.getGender());
                animal.setType(request.getType());
                animal.setName(request.getName());
                animalService.saveAnimal(animal);
                requestService.DelRequest(request);
            }

}
}
