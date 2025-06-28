package com.example.Ask.Controllers;

import com.example.Ask.Entities.User;
import com.example.Ask.Service.UserService;
import com.example.Ask.Service.EmailService;
import com.example.Ask.config.JwtUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

@RestController
@RequestMapping("/api/auth")
public class AuthController {
    @Autowired
    private UserService userService;
    @Autowired
    private JwtUtil jwtUtil;
    @Autowired
    private AuthenticationManager authenticationManager;
    @Autowired
    private EmailService emailService;

    @PostMapping("/register")
    public ResponseEntity<?> register(@RequestBody Map<String, String> registerData) {
        try {
            System.out.println("Registration request received: " + registerData);
            
            String username = registerData.get("username");
            String email = registerData.get("email");
            String password = registerData.get("password");

            System.out.println("Username: " + username);
            System.out.println("Email: " + email);
            System.out.println("Password: " + (password != null ? "***" : "null"));

            // Validate input
            if (username == null || username.trim().isEmpty()) {
                Map<String, String> response = new HashMap<>();
                response.put("error", "Username is required");
                System.out.println("Validation error: Username is required");
                return ResponseEntity.badRequest().body(response);
            }

            if (email == null || email.trim().isEmpty()) {
                Map<String, String> response = new HashMap<>();
                response.put("error", "Email is required");
                System.out.println("Validation error: Email is required");
                return ResponseEntity.badRequest().body(response);
            }

            if (password == null || password.trim().isEmpty()) {
                Map<String, String> response = new HashMap<>();
                response.put("error", "Password is required");
                System.out.println("Validation error: Password is required");
                return ResponseEntity.badRequest().body(response);
            }

            // Check if user already exists
            if (userService.existsByUsername(username)) {
                Map<String, String> response = new HashMap<>();
                response.put("error", "Username already exists");
                System.out.println("Validation error: Username already exists");
                return ResponseEntity.badRequest().body(response);
            }

            if (userService.existsByEmail(email)) {
                Map<String, String> response = new HashMap<>();
                response.put("error", "Email already exists");
                System.out.println("Validation error: Email already exists");
                return ResponseEntity.badRequest().body(response);
            }

            System.out.println("Creating user...");
            // Create user with verification token
            User user = new User(username, email, password);
            String verificationToken = UUID.randomUUID().toString();
            user.setVerificationToken(verificationToken);
            user.setVerificationTokenExpiry(LocalDateTime.now().plusHours(24));
            
            Integer userId = userService.saveUser(user);
            System.out.println("User created with ID: " + userId);

            // Send verification email (don't let email failure break registration)
            try {
                emailService.sendVerificationEmail(email, username, verificationToken);
                System.out.println("Verification email sent successfully");
            } catch (Exception e) {
                System.err.println("Failed to send verification email, but user was created: " + e.getMessage());
            }

            Map<String, String> response = new HashMap<>();
            response.put("message", "Registration successful. Please check your email to verify your account.");
            System.out.println("Registration completed successfully");
            return ResponseEntity.ok(response);

        } catch (Exception e) {
            System.err.println("Registration error: " + e.getMessage());
            e.printStackTrace();
            Map<String, String> response = new HashMap<>();
            response.put("error", "Registration failed: " + e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody Map<String, String> loginData, HttpServletRequest request) {
        try {
            String username = loginData.get("username");
            String password = loginData.get("password");

            // Check if user exists and is verified
            User user = userService.findByUsername(username);
            if (user == null) {
                Map<String, String> response = new HashMap<>();
                response.put("error", "Invalid username or password");
                return ResponseEntity.badRequest().body(response);
            }

            if (!user.getEmailVerified()) {
                Map<String, String> response = new HashMap<>();
                response.put("error", "Please verify your email before logging in");
                return ResponseEntity.badRequest().body(response);
            }

            Authentication authentication = authenticationManager.authenticate(
                    new UsernamePasswordAuthenticationToken(username, password)
            );
            SecurityContextHolder.getContext().setAuthentication(authentication);
            String token = jwtUtil.generateToken(authentication);

            // Update last login time
            user.setLastLogin(LocalDateTime.now());
            userService.updateUser(user);

            // Send login notification email
            String loginTime = LocalDateTime.now().toString();
            String ipAddress = getClientIpAddress(request);
            emailService.sendLoginNotification(user.getEmail(), user.getUsername(), loginTime, ipAddress);

            Map<String, Object> response = new HashMap<>();
            response.put("token", token);
            response.put("user", user);
            return ResponseEntity.ok(response);

        } catch (Exception e) {
            Map<String, String> response = new HashMap<>();
            response.put("error", "Invalid username or password");
            return ResponseEntity.badRequest().body(response);
        }
    }

    @GetMapping("/verify-email")
    public ResponseEntity<?> verifyEmail(@RequestParam String token) {
        try {
            User user = userService.findByVerificationToken(token);
            
            if (user == null) {
                Map<String, String> response = new HashMap<>();
                response.put("error", "Invalid verification token");
                return ResponseEntity.badRequest().body(response);
            }

            if (user.getVerificationTokenExpiry().isBefore(LocalDateTime.now())) {
                Map<String, String> response = new HashMap<>();
                response.put("error", "Verification token has expired");
                return ResponseEntity.badRequest().body(response);
            }

            // Mark email as verified
            user.setEmailVerified(true);
            user.setVerificationToken(null);
            user.setVerificationTokenExpiry(null);
            userService.updateUser(user);

            // Send welcome email
            emailService.sendWelcomeEmail(user.getEmail(), user.getUsername());

            Map<String, String> response = new HashMap<>();
            response.put("message", "Email verified successfully! You can now login.");
            return ResponseEntity.ok(response);

        } catch (Exception e) {
            Map<String, String> response = new HashMap<>();
            response.put("error", "Email verification failed: " + e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }

    private String getClientIpAddress(HttpServletRequest request) {
        String xForwardedFor = request.getHeader("X-Forwarded-For");
        if (xForwardedFor != null && !xForwardedFor.isEmpty()) {
            return xForwardedFor.split(",")[0].trim();
        }
        return request.getRemoteAddr();
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<?> handleException(Exception e) {
        System.err.println("Global exception handler caught: " + e.getMessage());
        e.printStackTrace();
        Map<String, String> response = new HashMap<>();
        response.put("error", "An error occurred: " + e.getMessage());
        return ResponseEntity.badRequest().body(response);
    }
} 