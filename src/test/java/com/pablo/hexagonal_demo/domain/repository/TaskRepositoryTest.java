package com.pablo.hexagonal_demo.domain.repository;

import com.pablo.hexagonal_demo.domain.model.Task;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.data.mongo.DataMongoTest;
import java.util.List;
import static org.junit.jupiter.api.Assertions.*;

@DataMongoTest
class TaskRepositoryTest {

    @Autowired
    private TaskRepository taskRepository;

    @Test
    void testSaveAndFind() {
        Task task = new Task();
        Task savedTask = taskRepository.save(task);
        assertNotNull(savedTask);
        List<Task> tasks = taskRepository.findAll();
        assertFalse(tasks.isEmpty());
    }
}
