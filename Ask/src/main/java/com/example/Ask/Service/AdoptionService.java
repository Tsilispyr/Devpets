package com.example.Ask.Service;

import com.example.Ask.Entities.AdoptionRequest;
import com.example.Ask.Repositories.AdoptionRepository;
import com.example.Ask.Service.EmailService;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class AdoptionService {
    @Autowired private AdoptionRepository adoptionRepo;
    @Autowired private EmailService emailService;

    @Transactional
    public List<AdoptionRequest> getPendingAdoptions() {
        return adoptionRepo.findAll().stream()
            .filter(r -> "pending".equals(r.getStatus()))
            .toList();
    }

    @Transactional
    public AdoptionRequest createAdoption(AdoptionRequest req) {
        req.setStatus("pending");
        AdoptionRequest saved = adoptionRepo.save(req);
        if (req.getUser() != null && req.getUser().getEmail() != null) {
            emailService.send(req.getUser().getEmail(), "Adoption Request Submitted",
                "Your adoption request for animal '" + (req.getAnimal() != null ? req.getAnimal().getName() : "") + "' is pending approval.");
        }
        return saved;
    }

    @Transactional
    public void approveAdoption(Long id) {
        AdoptionRequest req = adoptionRepo.findById(id).orElseThrow();
        req.setStatus("approved");
        adoptionRepo.save(req);
        if (req.getUser() != null && req.getUser().getEmail() != null) {
            emailService.send(req.getUser().getEmail(), "Adoption Approved",
                "Your adoption request for animal '" + (req.getAnimal() != null ? req.getAnimal().getName() : "") + "' has been approved!");
        }
    }

    @Transactional
    public void denyAdoption(Long id) {
        AdoptionRequest req = adoptionRepo.findById(id).orElseThrow();
        req.setStatus("denied");
        adoptionRepo.save(req);
        if (req.getUser() != null && req.getUser().getEmail() != null) {
            emailService.send(req.getUser().getEmail(), "Adoption Denied",
                "Your adoption request for animal '" + (req.getAnimal() != null ? req.getAnimal().getName() : "") + "' has been denied.");
        }
    }

    public List<AdoptionRequest> getAdoptionsByUsername(String username) {
        return adoptionRepo.findAll().stream()
            .filter(a -> a.getUser() != null && username.equals(a.getUser().getUsername()))
            .toList();
    }
} 