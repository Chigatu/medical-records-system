# Multi-stage build для оптимального размера образа
FROM ubuntu:22.04 AS builder

# Установка зависимостей для сборки
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    libpoco-dev \
    && rm -rf /var/lib/apt/lists/*

# Копирование исходного кода
WORKDIR /app
COPY . .

# Сборка проекта
RUN mkdir build && cd build && \
    cmake .. && \
    make -j4

# Копируем web файлы в build директорию (важно!)
RUN cp -r ../web build/ 2>/dev/null || cp -r web build/

# Финальный образ
FROM ubuntu:22.04

# Установка runtime зависимостей
RUN apt-get update && apt-get install -y \
    libpoco-dev \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Копирование собранного бинарника и web файлов
WORKDIR /app
COPY --from=builder /app/build/medical_api .
COPY --from=builder /app/build/web ./web

# Проверяем наличие файлов
RUN ls -la ./web/ && ls -la ./web/docs/ && ls -la ./web/swagger/ || true

# Открываем порт
EXPOSE 8080

# Здоровье проверка
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8080/health || exit 1

# Запуск
CMD ["./medical_api"]
