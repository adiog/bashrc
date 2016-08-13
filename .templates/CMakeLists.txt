cmake_minimum_required(VERSION 3.4)
project(HackerRank CXX)
enable_testing()

MACRO(CCACHE_INCLUDE_DIRECTORIES path)
    SET(CCACHE_INCLUDES "${CCACHE_INCLUDES} -I${path}")
ENDMACRO()

IF(CLION)
    INCLUDE_DIRECTORIES(${CMAKE_CURRENT_SOURCE_DIR})
    SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++14 -O2 -Wall -pedantic")
ELSE()
    CCACHE_INCLUDE_DIRECTORIES(${CMAKE_CURRENT_SOURCE_DIR})
    SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_COMPILER} ${CMAKE_CXX_FLAGS} -std=c++14 -O2 -Wall -pedantic ${CCACHE_INCLUDES}")
    SET(CMAKE_CXX_COMPILER "ccache")
ENDIF()

FILE(COPY ${CMAKE_CURRENT_SOURCE_DIR}/.cmake/EXEC DESTINATION ${CMAKE_CURRENT_BINARY_DIR})

MACRO(COLLECT_CC current_path)
    MESSAGE("-- CollectCC -- Searching for cc-files in ${current_path}")
    FILE(GLOB children RELATIVE ${current_path} ${current_path}/*)
    FOREACH(child ${children})
        IF(IS_DIRECTORY ${current_path}/${child})
            IF("${child}" STREQUAL ".git")
                MESSAGE("-- CollectCC -- Skipping .git directory")
            ELSEIF("${child}" STREQUAL ".idea")
                MESSAGE("-- CollectCC -- Skipping .idea directory")
            ELSEIF("${child}" STREQUAL "build")
                MESSAGE("-- CollectCC -- Skipping build directory")
            ELSE()
                COLLECT_CC(${current_path}/${child})
            ENDIF()
        ELSE ()
            GET_FILENAME_COMPONENT(test_ext ${current_path}/${child} EXT)
            GET_FILENAME_COMPONENT(test_name ${current_path}/${child} NAME_WE)
            IF ("${test_ext}" STREQUAL ".cc")
                ADD_EXECUTABLE(${test_name} ${current_path}/${child})
                MESSAGE("-- CollectCC -- Adding executable ${test_name} - done")

                # for every file test_name*.in add test (if exists correspondig 
                # test_name*.out add test and check the output against it)
                FILE(GLOB inputs RELATIVE ${current_path} ${current_path}/${test_name}*.in)
                IF(NOT "${inputs}" STREQUAL "")
                    SET(sorted_inputs ${inputs})
                    LIST(SORT sorted_inputs)
                    FOREACH(input ${sorted_inputs})
                        STRING(REPLACE ".in" ".out" output ${input})
                        IF(EXISTS ${current_path}/${output})
                            ADD_TEST(${input} 
                                EXEC ${CMAKE_CURRENT_BINARY_DIR}/${test_name}
                                INPUT ${current_path}/${input}
                                EXPECTED_OUTPUT ${current_path}/${output}
                            )
                            MESSAGE("-- CollectCC -- Adding test ${test_name} (in: ${input}, out: ${output}) - done")
                        ELSE()
                            ADD_TEST(${input} 
                                EXEC ${CMAKE_CURRENT_BINARY_DIR}/${test_name}
                                INPUT ${current_path}/${input}
                            )
                            MESSAGE("-- CollectCC -- Adding test ${test_name} (in: ${input}) - done")
                        ENDIF()                
                    ENDFOREACH()
                ELSE()
                    STRING(REPLACE ".cc" ".out" output ${child})
                    IF(EXISTS ${current_path}/${output})
                        ADD_TEST(${output} 
                            EXEC ${CMAKE_CURRENT_BINARY_DIR}/${test_name}
                            EXPECTED_OUTPUT ${current_path}/${output}
                        )
                        MESSAGE("-- CollectCC -- Adding test ${test_name} (out: ${output}) - done")
                    ELSE()
                        ADD_TEST(${test_name} ${CMAKE_CURRENT_BINARY_DIR}/${test_name})
                        MESSAGE("-- CollectCC -- Adding test ${test_name} - done")
                    ENDIF()
                ENDIF()
            ENDIF ()
        ENDIF()
    ENDFOREACH()
    MESSAGE("-- CollectCC -- Searching for cc-files in ${current_path} - done")
ENDMACRO()


IF((NOT DEFINED COMPONENT) OR ("${COMPONENT}" STREQUAL "BUILD_ALL_CC"))
  COLLECT_CC(${CMAKE_CURRENT_SOURCE_DIR})
ENDIF()

