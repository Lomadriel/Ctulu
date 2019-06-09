## target_generate_clang_format(target)
# Generate a format target named ${clang_format_target_name}.
# The generated target lanch clang-format on all the targets sources with -style=file
#   {value}  [in] clang_format_target_name  Name of the generated target
#   {value}  [in] files:                    Sources files
#   {value}  [in] directories:              Directories from which sources files are generated
#   {value}  [in] targets:                  Targets from which getting the source files
function(ctulu_generate_clang_format clang_format_target_name)
    set(options NORECURSE)
    set(multiValueArgs DIRS FILES TARGETS)
    cmake_parse_arguments(ctulu_generate_clang_format "${options}" "" "${multiValueArgs}" ${ARGN})

    find_program(CLANG_FORMAT clang-format
            NAMES clang-format-9 clang-format-8 clang-format-7 clang-format-6)
    if(${CLANG_FORMAT} STREQUAL CLANG_FORMAT-NOTFOUND)
        message(WARNING "Ctulu -- clang-format not found, ${clang_format_target_name} not generated")
        return()
    else()
        message(STATUS "Ctulu -- clang-format found: ${CLANG_FORMAT}")
    endif()

    if(ctulu_generate_clang_format_TARGETS)
        foreach(it ${ctulu_generate_clang_format_TARGETS})
            get_target_property(target_type ${it} TYPE)
            if (target_type STREQUAL "INTERFACE_LIBRARY")
                get_target_property(target_includes_dir ${it} INTERFACE_INCLUDE_DIRECTORIES)
                set(ctulu_generate_clang_format_DIRS ${ctulu_generate_clang_format_DIRS} ${target_includes_dir})
            else()
                get_target_property(target_sources ${it} SOURCES)
                set(ctulu_generate_clang_format_FILES ${ctulu_generate_clang_format_FILES} ${target_sources})
            endif()
        endforeach()
    endif()

    if(ctulu_generate_clang_format_DIRS)
        foreach(it ${ctulu_generate_clang_format_DIRS})
            if(ctulu_generate_clang_format_NORECURSE)
                ctulu_list_files(tmp_files ${it} NORECURSE)
            else()
                ctulu_list_files(tmp_files ${it})
            endif()
            set(ctulu_generate_clang_format_FILES ${ctulu_generate_clang_format_FILES} ${tmp_files})
        endforeach()
    endif()

    add_custom_target(
            ${clang_format_target_name}
            COMMAND "${CLANG_FORMAT}" -style=file -i ${ctulu_generate_clang_format_FILES}
            WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
            VERBATIM)

    message(STATUS "Ctulu -- Format target \"${clang_format_target_name}\" generated")
endfunction()