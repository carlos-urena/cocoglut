Folders structure
-----------------
(obtained and adapted from: 
http://hiltmon.com/blog/2013/07/03/a-simple-c-plus-plus-project-structure/)


** bin 

   executable files for the simple test program. Two versions: one built
   with static linking and the other with dynamic link.

** build

   object files, is removed on a clean.

** include

   C/C++ header with the (partial) GLUT api declarations

** lib 

   the library compiled as a Mac OSX dynamic library (.dylib) file

** src 

   C/C++/Objective-C sources for the implementation (headers and units)

** test

   C/C++ source for  a simple test program.
