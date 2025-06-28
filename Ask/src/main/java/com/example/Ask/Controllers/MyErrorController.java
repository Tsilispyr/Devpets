package com.example.Ask.Controllers;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.boot.web.servlet.error.ErrorController;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.http.ResponseEntity;
import java.util.HashMap;
import java.util.Map;

@RestController
public class MyErrorController implements ErrorController {

    @RequestMapping("/error")
    public ResponseEntity<Map<String, Object>> handleError(HttpServletRequest request) {
        Object status = request.getAttribute(RequestDispatcher.ERROR_STATUS_CODE);
        Map<String, Object> errorResponse = new HashMap<>();
        if (status != null) {
            Integer statusCode = Integer.valueOf(status.toString());
            errorResponse.put("status", statusCode);
            if(statusCode == HttpStatus.NOT_FOUND.value()) {
                errorResponse.put("error", "Not Found");
            }
            else if(statusCode == HttpStatus.FORBIDDEN.value()) {
                errorResponse.put("error", "Forbidden");
            }
            else if(statusCode == HttpStatus.INTERNAL_SERVER_ERROR.value()) {
                errorResponse.put("error", "Internal Server Error");
            } else {
                errorResponse.put("error", "Unknown Error");
            }
        } else {
            errorResponse.put("error", "Unknown Error");
        }
        return ResponseEntity.status((int)errorResponse.getOrDefault("status", 500)).body(errorResponse);
    }
}