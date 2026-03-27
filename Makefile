# Makefile для Medical Records Management System

CXX = g++
CXXFLAGS = -std=c++17 -Wall -Wextra
BUILD_DIR = build
SRC_DIR = src
WEB_DIR = web
TARGET = medical_api

.PHONY: all clean build run docker-build docker-up docker-down test help

all: build

# Сборка проекта
build: prepare
	@echo "Building project..."
	cd $(BUILD_DIR) && cmake .. && make -j4
	@echo "Build complete. Binary: $(BUILD_DIR)/$(TARGET)"

# Подготовка директории build
prepare:
	@echo "Preparing build directory..."
	@rm -rf $(BUILD_DIR)
	@mkdir -p $(BUILD_DIR)
	@cp -r $(WEB_DIR) $(BUILD_DIR)/
	@echo "Web files copied to $(BUILD_DIR)/$(WEB_DIR)"

# Запуск сервера
run: build
	@echo "Starting Medical Records API Server..."
	cd $(BUILD_DIR) && ./$(TARGET)

# Очистка
clean:
	@echo "Cleaning build directory..."
	@rm -rf $(BUILD_DIR)
	@echo "Clean complete"

# Docker сборка
docker-build:
	@echo "Building Docker image..."
	docker build -t medical-records-api .

# Docker запуск
docker-up:
	@echo "Starting Docker container..."
	docker-compose up

# Docker запуск в фоне
docker-up-d:
	@echo "Starting Docker container in background..."
	docker-compose up -d

# Docker остановка
docker-down:
	@echo "Stopping Docker container..."
	docker-compose down

# Запуск тестов
test: build
	@echo "Running API tests..."
	cd $(BUILD_DIR) && ./$(TARGET) &
	@echo "Waiting for server to start..."
	@sleep 3
	@./test_api.sh
	@echo "Stopping server..."
	@-pkill -f $(TARGET) || true

# Помощь
help:
	@echo "Available commands:"
	@echo "  make build       - Build the project"
	@echo "  make run         - Build and run the server"
	@echo "  make clean       - Clean build directory"
	@echo "  make docker-build - Build Docker image"
	@echo "  make docker-up   - Run with Docker Compose"
	@echo "  make docker-up-d - Run with Docker Compose (detached)"
	@echo "  make docker-down - Stop Docker containers"
	@echo "  make test        - Run API tests"
	@echo "  make help        - Show this help"
