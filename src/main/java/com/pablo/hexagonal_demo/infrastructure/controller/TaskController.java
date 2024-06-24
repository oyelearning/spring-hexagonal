package com.pablo.hexagonal_demo.infrastructure.controller;

import com.pablo.hexagonal_demo.application.service.TaskService;
import com.pablo.hexagonal_demo.domain.model.Task;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/tasks")
public class TaskController {

    @Autowired
    private TaskService taskService;

    @PostMapping
    public Task createTask(@RequestBody Task task) {
        return taskService.createTask(task);
    }

    @GetMapping
    public List<Task> getAllTasks() {
        return taskService.getAllTasks();
    }

    @GetMapping("/{id}")
    public Optional<Task> getTaskById(@PathVariable String id) {
        return taskService.getTaskById(id);
    }

    @DeleteMapping("/{id}")
    public void deleteTaskById(@PathVariable String id) {
        taskService.deleteTaskById(id);
    }
}
