// src/main/java/com/example/demo/HelloController.java

package com.example.demo;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import java.time.ZonedDateTime;

@RestController
public class HelloController {

    @GetMapping("/hello")
    public String sayHello() {
        return "Hello from AKS! The time is " + ZonedDateTime.now() + ".";
    }
}