package com.example.Ask.Controllers;

import com.example.Ask.Entities.Request;
import com.example.Ask.Repositories.RequestRepository;
import com.example.Ask.Service.AnimalService;
import com.example.Ask.Service.RequestService;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.*;
import com.example.Ask.Entities.Animal;
import java.util.List;
import org.springframework.http.ResponseEntity;

@RestController
@RequestMapping("api/requests")
public class RequestController {

    private AnimalService animalService;
    private RequestService requestService;
    public RequestController(RequestService requestService,AnimalService animalService) {
        this.requestService = requestService;
        this.animalService = animalService;
    }

    @RequestMapping("")
    public List<Request> showRequests() {
        return requestService.getRequests();
    }
    @GetMapping("/{id}")
    public Request showRequest(@PathVariable Integer id){
        return requestService.getRequest(id);
    }

    @PostMapping("/Approve/{id}")
    public Request AdminApprove(@PathVariable Integer id) {
        Request request = requestService.getRequest(id);
        request.setAdminApproved(1);
        requestService.CheckRequest(request);
        return request;
    }
    @PostMapping("/ApproveD/{id}")
    public Request DocApprove(@PathVariable Integer id){
        Request request = requestService.getRequest(id);
        request.setDocApproved(1);
        requestService.CheckRequest(request);
        return request;
    }
    @GetMapping("/new")
    public Request addRequest(){
        return new Request();
    }
    @PostMapping("/new")
    public List<Request> saveRequest(@RequestBody Request request) {
        requestService.saveRequest(request);
        return requestService.getRequests();
    }

    @PostMapping("")
    public Request createRequest(@RequestBody Request request) {
        return requestService.saveRequest(request);
    }

    @PutMapping("/{id}")
    public Request updateRequest(@PathVariable Integer id, @RequestBody Request request) {
        request.setId(id);
        return requestService.saveRequest(request);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteRequest(@PathVariable Integer id) {
        Request request = requestService.getRequest(id);
        if (request == null) {
            return ResponseEntity.notFound().build();
        }
        requestService.DelRequest(request);
        return ResponseEntity.noContent().build();
    }

    @PutMapping("/Approve/{id}")
    public Request adminApprove(@PathVariable Integer id) {
        Request request = requestService.getRequest(id);
        request.setAdminApproved(1);
        requestService.CheckRequest(request);
        return requestService.saveRequest(request);
    }

    @PutMapping("/ApproveD/{id}")
    public Request docApprove(@PathVariable Integer id) {
        Request request = requestService.getRequest(id);
        request.setDocApproved(1);
        requestService.CheckRequest(request);
        return requestService.saveRequest(request);
    }
}
