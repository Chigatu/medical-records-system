cmake_minimum_required(VERSION 3.14)
project(MedicalRecordsSystem VERSION 2.0.0)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Поиск POCO библиотек
find_package(Poco REQUIRED COMPONENTS Foundation Net JSON)

# Создаем исполняемый файл
add_executable(medical_api src/main.cpp)

# Включаемые директории
target_include_directories(medical_api PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/src
)

# Линковка библиотек
target_link_libraries(medical_api
    Poco::Foundation
    Poco::Net
    Poco::JSON
)

# Подавляем предупреждения для чистоты вывода
if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    target_compile_options(medical_api PRIVATE -Wno-unused-parameter)
endif()
