## ctulu_target_use_ccache(target)
# Enable ccache use on the given target if the compiler support it
#   {value} [in] target:   Target
function(ctulu_target_use_ccache target)
    if(NOT TARGET ${target})
        message(FATAL_ERROR "Ctulu -- Invalid argument: ${target} is not a target")
    endif()

    ctulu_define_compiler_variables()
    if(COMPILER_GCC OR COMPILER_CLANG)
        find_program(CCACHE_PROGRAM ccache)
        if(NOT ${CCACHE_PROGRAM} STREQUAL CCACHE_PROGRAM-NOTFOUND)
            message(STATUS "Ctulu -- ccache found: ${CCACHE_PROGRAM}")
            set_target_properties(${target} PROPERTIES C_COMPILER_LAUNCHER "${CCACHE_PROGRAM}")
            set_target_properties(${target} PROPERTIES CXX_COMPILER_LAUNCHER "${CCACHE_PROGRAM}")
            message(STATUS "Ctulu -- ${target} -- enabled ccache use")
        endif()
    endif()
endfunction()