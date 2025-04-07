cmake_minimum_required(VERSION 3.20)
project(calc VERSION 0.1.1 LANGUAGES CXX)

add_subdirectory(third-party/wjr)

set(CALC_INCLUDE_DIR ${PROJECT_SOURCE_DIR}/include)
set(CALC_LIB_DIR ${PROJECT_SOURCE_DIR}/src)

add_custom_command(
    OUTPUT 
        ${PROJECT_BINARY_DIR}/calc.yy.cpp
    COMMAND
        flex -+ -o${PROJECT_BINARY_DIR}/calc.yy.cpp ${CALC_LIB_DIR}/calc.l
    DEPENDS
        ${CALC_INCLUDE_DIR}/calc_lexer.hpp ${CALC_LIB_DIR}/calc.l
)

add_custom_command(
    OUTPUT 
        ${PROJECT_BINARY_DIR}/calc.tab.hpp
        ${PROJECT_BINARY_DIR}/calc.tab.cpp
    COMMAND
        bison -d -o ${PROJECT_BINARY_DIR}/calc.tab.cpp ${CALC_LIB_DIR}/calc.y
    DEPENDS
        ${CALC_INCLUDE_DIR}/calc_lexer.hpp ${CALC_LIB_DIR}/calc.y
)

add_executable(calc 
    src/main.cpp 
    src/calc_lexer.cpp
    ${PROJECT_BINARY_DIR}/calc.yy.cpp 
    ${PROJECT_BINARY_DIR}/calc.tab.cpp
)
target_include_directories(calc PUBLIC ${CALC_INCLUDE_DIR} ${PROJECT_BINARY_DIR})
target_link_libraries(calc wjr)