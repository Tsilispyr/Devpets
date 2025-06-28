package com.example.Ask.Controllers;

import com.example.Ask.Entities.Role;
import com.example.Ask.Entities.User;
import jakarta.annotation.PostConstruct;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/")
public class HomeController {
    @GetMapping()
    public Map<String, String> home() {
        Map<String, String> response = new HashMap<>();
        response.put("title", "Home");
        return response;
    }
}