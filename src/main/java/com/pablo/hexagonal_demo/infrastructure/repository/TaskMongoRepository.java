package com.pablo.hexagonal_demo.infrastructure.repository;

import com.pablo.hexagonal_demo.domain.model.Task;
import com.pablo.hexagonal_demo.domain.repository.TaskRepository;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface TaskMongoRepository extends MongoRepository<Task, String>, TaskRepository {
}
