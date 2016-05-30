# COCOGLUT
**A basic implementation of GLUT over COCOA**

This project is aimed at obtaining a basic implementation of GLUT API for OSX, where 'basic' means to provide the ability for creating/destroying windows and handling redraw, keyboard, mouse, idle and timer events. This implementation uses the COCOA framework, so you can take advantage of full retina display resolution. Current version seems to work correctly, at least for the test program in the repository. You can select to use either an OpenGL 2.0 or an OpenGL 4.0 rendering context, although this is still not exposed in the API.

The current (December 2015) solution provided by Apple is an implementation for GLUT which runs over XQuartz, thus halving retina display resolution. Building the library does not requires any XCode IDE project files, it can be built and linked from the command line. It neither uses any nib file. The code is written in Objective-C++ (mixed with C++), and the API can be used from C, C++ or Objective-C++ written applications.

## List of already implemented GLUT functions:


    int  glutCreateWindow       ( const char *name );
    void glutDestroyWindow      ( int win );
    int  glutGetWindow          ( void );
    void glutSetWindow          ( int win );
    void glutSwapBuffers        ( void );
    void glutInit               ( int *argcp, char **argv );
    void glutInitWindowSize     ( int width, int height );
    void glutInitWindowPosition ( int x, int y );
    void glutMainLoop           ( void );
    void glutPostRedisplay      ( void );

    void glutKeyboardFunc ( KeyboardCBPType func );
    void glutSpecialFunc  ( SpecialCBPType  func );
    void glutDisplayFunc  ( DisplayCBPType  func );
    void glutMouseFunc    ( MouseCBPType    func );
    void glutReshapeFunc  ( ReshapeCBPType  func );
    void glutMotionFunc   ( MotionCBPType   func );
    void glutIdleFunc     ( IdleCBPType     func );

    int  glutCreateMenu       ( MenuCBPType func ) ;
    void glutSetMenu          ( int menu ) ;
    int  glutGetMenu          ( void ) ;
    void glutDestroyMenu      ( int menu ) ;
    void glutAddMenuEntry     ( const char * name, int value ) ; // added 'const'
    void glutAddSubMenu       ( const char * name, int menu ) ;
    void glutChangeToMenuEntry( int entry, const char * name, int value ) ; // added 'const'
    void glutChangeToSubMenu  ( int entry, const char * name, int value ) ; // added 'const'
    void glutAttachMenu       ( int button ) ;
    void glutDetachMenu       ( int button ) ;

Callback function pointer types are defined as follows:

    typedef void (* KeyboardCBPType ) ( unsigned char key, int x, int y ) ;
    typedef void (* SpecialCBPType  ) ( int key, int x, int y ) ;
    typedef void (* DisplayCBPType  ) ( void ) ;
    typedef void (* MouseCBPType    ) ( int button, int state, int x, int y );
    typedef void (* ReshapeCBPType  ) ( int width, int height );
    typedef void (* MotionCBPType   ) ( int x, int y ) ;
    typedef void (* IdleCBPType     ) ( void ) ;

## Folders structure

(obtained and adapted from: http://hiltmon.com/blog/2013/07/03/a-simple-c-plus-plus-project-structure/)

**List with files or folders on the root folder**

`makefile`

Makefile for compiling the library and for cleaning.

`bin`     

Folder with executable files for the simple test program. There are two executables:

* `test1`: statically linked version.
* `test1-dl` dynamically linked version.

Removed on a clean.

`build`   

Folder with object files, all of them removed on a clean.

`include`  

Folder which includes the C/C++ header with the (partial) GLUT api declarations (`cocoglut-api.h`)

`lib`

Folder with the library file, already compiled for Mac OSX projects, there are two versions:

* `cocoglut.dylib`:  dynamic library file
* `cocoglut.a`: for static linking

Both files are removed on clean.

`src`

C/C++/Objective-C sources for the implementation (headers and units)

`test`

C/C++ source for a simple test program. (includes a makefile for running the test).
