package com.pablo.hexagonal_demo.application.service;

import com.pablo.hexagonal_demo.domain.model.Task;
import com.pablo.hexagonal_demo.domain.repository.TaskRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class TaskService {

    private final TaskRepository taskRepository;

    public TaskService(TaskRepository taskRepository) {
        this.taskRepository = taskRepository;
    }

    public Task createTask(Task task) {
        return taskRepository.save(task);
    }

    public List<Task> getAllTasks() {
        return taskRepository.findAll();
    }

    public Optional<Task> getTaskById(String id) {
        return taskRepository.findById(id);
    }

    public void deleteTaskById(String id) {
        taskRepository.deleteById(id);
    }
}
