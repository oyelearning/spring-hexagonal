#!/bin/bash

BASE_URL="http://localhost:8080/tasks"

# Function to execute curl command and wait for user input
execute_curl() {
    read -p "Press Enter to execute: $1"
    response=$(eval $1)
    
    # Check if the response contains "Error"
    if [[ $response == *"Error"* ]]; then
        echo -e "\nCommand executed!\nResponse:\n$response\n"
    else
        # If no error is found, use jq to format JSON
        formatted_response=$(echo "$response" | jq '.')
        echo -e "\nCommand executed!\nFormatted Response:\n$formatted_response\n"
    fi
}

# Create Task
execute_curl "curl -X POST -H 'Content-Type: application/json' -d '{
  \"id\": \"task1\",
  \"title\": \"Task 1\",
  \"description\": \"Description of Task 1\",
  \"completed\": false
}' $BASE_URL"

# Get All Tasks
execute_curl "curl $BASE_URL"

# Get Task by ID (assuming 'task1' exists)
execute_curl "curl $BASE_URL/task1"

# Delete Task by ID (assuming 'task1' exists)
execute_curl "curl -X DELETE $BASE_URL/task1"
