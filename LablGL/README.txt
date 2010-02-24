
  === LablGL Interoperability ===

  If you wish to swap from LablGL to glMLite or the opposite,
  this directory provides two different ways to achieve this task.

  Typing 'make sed' will provide two sed scripts which you can use
  to help convert source files from and to the LablGL bindings:
      LablGL_to_glMLite.sed.sh
      glMLite_to_LablGL.sed.sh

  You can also use the file 'LablGL.ml' to use glMLite with the LablGL
  interface, so you don't need to modify source files using LablGL much:
  just opening this module at the beginning of the code.


