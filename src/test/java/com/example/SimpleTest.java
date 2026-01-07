package com.example;

// Change these two imports to JUnit 4
import org.junit.Test;
import static org.junit.Assert.assertTrue;

public class SimpleTest {
    @Test
    public void pipelineTest() {
        System.out.println("Running pipeline validation test...");
        assertTrue(true);
    }
}
