package com.example.Ask.Repositories;

import com.example.Ask.Entities.AdoptionRequest;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface AdoptionRepository extends JpaRepository<AdoptionRequest, Long> {
} 