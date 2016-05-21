// *********************************************************************
// **
// ** C++ header for COCOGLUT api declarations
// **
// ** Copyright (C) 2015 Carlos Ureña
// **
// ** This program is free software: you can redistribute it and/or modify
// ** it under the terms of the GNU General Public License as published by
// ** the Free Software Foundation, either version 3 of the License, or
// ** (at your option) any later version.
// **
// ** This program is distributed in the hope that it will be useful,
// ** but WITHOUT ANY WARRANTY; without even the implied warranty of
// ** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// ** GNU General Public License for more details.
// **
// ** You should have received a copy of the GNU General Public License
// ** along with this program.  If not, see <http://www.gnu.org/licenses/>.
// **
//


#ifndef COCOGLUT_HPP
#define COCOGLUT_HPP

namespace cocoglut
{

// Constants

enum Constants
{
   GLUT_LEFT_BUTTON,
   GLUT_MIDDLE_BUTTON,
   GLUT_RIGHT_BUTTON,

   GLUT_UP,
   GLUT_DOWN,

   GLUT_KEY_LEFT,
   GLUT_KEY_UP,
   GLUT_KEY_RIGHT,
   GLUT_KEY_DOWN,

   CCG_OPENGL_2,
   CCG_OPENGL_4
} ;

// Callback function pointer types

typedef void (* KeyboardCBPType ) ( unsigned char key, int x, int y ) ;
typedef void (* SpecialCBPType  ) ( int key, int x, int y ) ;
typedef void (* DisplayCBPType  ) ( void ) ;
typedef void (* MouseCBPType    ) ( int button, int state, int x, int y );
typedef void (* ReshapeCBPType  ) ( int width, int height );
typedef void (* MotionCBPType   ) ( int x, int y ) ;
typedef void (* IdleCBPType     ) ( void ) ;
typedef void (* TimerCBPType    ) ( int value );
typedef void (* MenuCBPType     ) ( int value );


// Window managing and initialization functions

int  glutCreateWindow       ( const char *name );  // deviation from glut: I use 'const' here
void glutDestroyWindow      ( int win );
int  glutGetWindow          ( void );
void glutSetWindow          ( int win );
void glutSwapBuffers        ( void );
void glutInit               ( int *argcp, char **argv );
void glutInitDisplayMode    ( unsigned int mode );
void glutInitWindowSize     ( int width, int height );
void glutInitWindowPosition ( int x, int y );
void glutMainLoop           ( void );
void glutPostRedisplay      ( void );


// Callback registration functions
// https://www.opengl.org/documentation/specs/glut/spec3/node45.html

void glutKeyboardFunc ( KeyboardCBPType func );
void glutSpecialFunc  ( SpecialCBPType  func );
void glutDisplayFunc  ( DisplayCBPType  func );
void glutMouseFunc    ( MouseCBPType    func );
void glutReshapeFunc  ( ReshapeCBPType  func );
void glutMotionFunc   ( MotionCBPType   func );
void glutIdleFunc     ( IdleCBPType     func );
void glutTimerFunc    ( unsigned int msecs, TimerCBPType func, int value );


// Menu handling functions
// https://www.opengl.org/resources/libraries/glut/spec3/node35.html

void glutCreateMenu       ( MenuCBPType func ) ;
void glutSetMenu          ( int menu ) ;
int  glutGetMenu          ( void ) ;
void glutDestroyMenu      ( int menu ) ;
void glutAddMenuEntry     ( const char * name, int value ) ; // added 'const'
void glutAddSubMenu       ( const char * name, int menu ) ;
void glutChangeToMenuEntry( int entry, const char * name, int value ) ;
void glutChangeToSubMenu  ( int entry, const char * name, int value ) ;
void glutRemoveMenuItem   ( int entry ) ;
void glutAttachMenu       ( int button ) ;
void glutDetachMenu       ( int button ) ;

} // end namespace cocoglut

#endif
