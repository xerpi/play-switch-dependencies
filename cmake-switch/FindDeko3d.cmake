## A CMake helper to find deko3d on the system.
##
## On success, it will define:
## > DEKO3D_FOUND        - The system has deko3d
## > DEKO3D_INCLUDE_DIRS - The deko3d include directories
## > DEKO3D_LIBRARIES    - The static deko3d libraries
##
## It also adds the imported targets named `switch::deko3d` and `switch::deko3dd`.
##
## ```
## target_link_libraries(my_executable switch::deko3d)
## ```
## is equivalent to
## ```
## target_include_directories(my_executable PRIVATE ${DEKO3D_INCLUDE_DIRS})
## target_link_libraries(my_executable ${DEKO3D_LIBRARIES})
## ```
##
## By default, CMake will look for deko3d in $DEVKITPRO/libnx.
## If you want to use a custom fork, you need to override the
## `DEKO3D` variable within CMake before this file is used.

include(FindPackageHandleStandardArgs)

if(NOT SWITCH)
    message(FATAL_ERROR "This helper can only be used when cross-compiling for the Switch.")
endif()

set(DEKO3D_PATHS ${DEKO3D} $ENV{DEKO3D} ${DEVKITPRO}/libnx libnx)

find_path(DEKO3D_INCLUDE_DIR deko3d.h
        PATHS ${DEKO3D_PATHS}
        PATH_SUFFIXES include)

find_library(DEKO3D_LIBRARY NAMES libdeko3d.a
        PATHS ${DEKO3D_PATHS}
        PATH_SUFFIXES lib)

find_library(DEKO3DD_LIBRARY NAMES libdeko3dd.a
        PATHS ${DEKO3D_PATHS}
        PATH_SUFFIXES lib)

set(DEKO3D_INCLUDE_DIRS ${DEKO3D_INCLUDE_DIR})
set(DEKO3D_LIBRARIES ${DEKO3D_LIBRARY} ${DEKO3DD_LIBRARY})

find_package_handle_standard_args(DEKO3D DEFAULT_MSG
        DEKO3D_INCLUDE_DIR DEKO3D_LIBRARY DEKO3DD_LIBRARY)

mark_as_advanced(DEKO3D_INCLUDE_DIR DEKO3D_LIBRARY DEKO3DD_LIBRARY)

if(DEKO3D_FOUND)
    set(DEKO3D ${DEKO3D_INCLUDE_DIR}/..)

    add_library(switch::deko3d STATIC IMPORTED GLOBAL)
    set_target_properties(switch::deko3d PROPERTIES
            IMPORTED_LOCATION "${DEKO3D_LIBRARY}"
            INTERFACE_INCLUDE_DIRECTORIES "${DEKO3D_INCLUDE_DIR}")

    add_library(switch::deko3dd STATIC IMPORTED GLOBAL)
    set_target_properties(switch::deko3dd PROPERTIES
            IMPORTED_LOCATION "${DEKO3DD_LIBRARY}"
            INTERFACE_INCLUDE_DIRECTORIES "${DEKO3D_INCLUDE_DIR}")
endif()
