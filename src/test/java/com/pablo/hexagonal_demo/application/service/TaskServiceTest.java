package com.pablo.hexagonal_demo.application.service;

import com.pablo.hexagonal_demo.domain.model.Task;
import com.pablo.hexagonal_demo.domain.repository.TaskRepository;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.junit.jupiter.api.extension.ExtendWith;
import java.util.List;
import static org.mockito.Mockito.*;
import static org.junit.jupiter.api.Assertions.*;

@ExtendWith(MockitoExtension.class)
class TaskServiceTest {

    @Mock
    private TaskRepository taskRepository;

    @InjectMocks
    private TaskService taskService;

    @Test
    void testCreateTask() {
        Task task = new Task();
        when(taskRepository.save(task)).thenReturn(task);
        Task createdTask = taskService.createTask(task);
        assertNotNull(createdTask);
        verify(taskRepository, times(1)).save(task);
    }

    @Test
    void testGetAllTasks() {
        when(taskRepository.findAll()).thenReturn(List.of(new Task()));
        List<Task> tasks = taskService.getAllTasks();
        assertFalse(tasks.isEmpty());
        verify(taskRepository, times(1)).findAll();
    }
}
