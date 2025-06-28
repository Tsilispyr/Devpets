// package com.example.Ask.Controllers;

// import com.example.Ask.Entities.AdoptionRequest;
// import com.example.Ask.Service.AdoptionService;
// import org.springframework.beans.factory.annotation.Autowired;
// import org.springframework.http.ResponseEntity;
// import org.springframework.web.bind.annotation.*;
// import java.util.List;

// @RestController
// @RequestMapping("/api/adoptions")
// public class AdoptionController {
//     @Autowired private AdoptionService adoptionService;

//     @GetMapping("/pending")
//     public List<AdoptionRequest> getPendingAdoptions() {
//         return adoptionService.getPendingAdoptions();
//     }

//     @PostMapping
//     public AdoptionRequest createAdoption(@RequestBody AdoptionRequest req) {
//         return adoptionService.createAdoption(req);
//     }

//     @PostMapping("/{id}/approve")
//     public ResponseEntity<?> approveAdoption(@PathVariable Long id) {
//         adoptionService.approveAdoption(id);
//         return ResponseEntity.ok().build();
//     }

//     @PostMapping("/{id}/deny")
//     public ResponseEntity<?> denyAdoption(@PathVariable Long id) {
//         adoptionService.denyAdoption(id);
//         return ResponseEntity.ok().build();
//     }
// } 