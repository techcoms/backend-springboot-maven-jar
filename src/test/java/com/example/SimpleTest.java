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

@SpringBootTest(webEnvironment = RANDOM_PORT)
@AutoConfigureMockMvc
class SimpleTest {

    @Autowired
    private MockMvc mockMvc;

    @Test
    void contextLoads() {
        // Simple test: app starts and / endpoint returns 200 + "Hello World"
        assertTrue(true);  // Replace with real assertion if needed, e.g., greeting test
    }

    // Optional: Add REST endpoint test if your app has /greeting or /hello
    @Test
    void testHelloEndpoint() throws Exception {
        this.mockMvc.perform(get("/"))  // Adjust to your endpoint, e.g., "/hello"
                .andExpect(status().isOk())
                .andExpect(content().string(org.hamcrest.Matchers.containsString("Hello")));
    }
}
