# \brief adds for the given target a fake executable targets which allows all
#        headers and symbols to be shown in IDEs.
# \param target_name Which target properties should be added to the IDE support target.
function(target_add_ide_support target_name)
  if (NOT TARGET ${target_name})
    message(FATAL_ERROR "No target defined with name ${target_name}, cannot target_add_ide_support it.")
  endif()

  set (target_for_ide "${target_name}_ide_support")
  if (NOT TARGET ${target_for_ide})
      file(GLOB_RECURSE target_for_ide_srcs "*.h" "*.hpp" "*.hxx" "*.c" "*.cpp" "*.cxx")
      add_executable(${target_for_ide} ${target_for_ide_srcs})
      set_target_properties(${target_for_ide} PROPERTIES EXCLUDE_FROM_ALL 1 EXCLUDE_FROM_DEFAULT_BUILD 1)
  endif()

  get_target_property(dirs ${target_name} INCLUDE_DIRECTORIES)
  target_include_directories(${target_for_ide} PRIVATE ${dirs})

endfunction(target_add_ide_support)
