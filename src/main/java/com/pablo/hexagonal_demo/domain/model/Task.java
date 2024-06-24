package com.pablo.hexagonal_demo.domain.model;

import java.time.LocalDate;
import java.util.List;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class Task {

    private String id;

    private String description;
    private LocalDate endDate;
    private boolean status;
    private List<String> tags;
    private String title;
}
