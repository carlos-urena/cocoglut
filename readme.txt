Folders structure
-----------------
(obtained and adapted from: 
http://hiltmon.com/blog/2013/07/03/a-simple-c-plus-plus-project-structure/)

** makefile

   makefile for compiling the library and for cleaning

** bin 

   Executable files for the simple test program. Two versions: one built
   with static linking and the other with dynamic link.
   Removed on a clean.

** build

   Object files, all of them removed on a clean.

** include

   C/C++ header with the (partial) GLUT api declarations

** lib 

   The library compiled as a Mac OSX dynamic library (cocoglut.dylib) 
   file, and also compiled as a static file (cocoglut.a).
   Both files are removed on clean.

** src 

   C/C++/Objective-C sources for the implementation (headers and units)

** test

   C/C++ source for a simple test program.
   (includes a makefile for running the test).
