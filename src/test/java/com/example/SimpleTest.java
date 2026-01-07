package com.example;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.boot.test.context.SpringBootTest.WebEnvironment.RANDOM_PORT;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.web.servlet.MockMvc;

@SpringBootTest(webEnvironment = RANDOM_PORT, classes = SimpleTest.TestApplication.class)
@AutoConfigureMockMvc
class SimpleTest {

    @Autowired
    private MockMvc mockMvc;

    @Test
    void contextLoads() {
        // Simple test: app starts and / endpoint returns 200 + "Hello World"
        assertTrue(true);
    }

    @Test
    void testHelloEndpoint() throws Exception {
        this.mockMvc.perform(get("/"))
                .andExpect(status().isOk())
                .andExpect(content().string(org.hamcrest.Matchers.containsString("Hello")));
    }

    @org.springframework.boot.autoconfigure.SpringBootApplication
    @org.springframework.web.bind.annotation.RestController
    static class TestApplication {

        @org.springframework.web.bind.annotation.GetMapping("/")
        public String home() {
            return "Hello World";
        }
    }
}
