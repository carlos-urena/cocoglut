// *********************************************************************
// **
// ** Implementation for cocoglut API functions
// ** (redirections to cocoglut::LibraryState methods)
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
// ** along with this program.  If not, see http://www.gnu.org/licenses.
// **
// *********************************************************************

#include <cocoglut-state.h>
#include <cocoglut-api.hpp>

// *********************************************************************

namespace cocoglut
{
// ---------------------------------------------------------------------

int glutCreateWindow( const char * name )
{
   return GetState()->createWindow( name ) ;
}
// ---------------------------------------------------------------------

void glutDestroyWindow( int win )
{
   GetState()->destroyWindow( win ) ;
}
// ---------------------------------------------------------------------

int glutGetWindow( void )
{
   return GetState()->getWindow() ;
}

// ---------------------------------------------------------------------

void glutSetWindow( int win )
{
   GetState()->setWindow( win ) ;
}

// ---------------------------------------------------------------------

void glutSwapBuffers( void )
{
   return GetState()->swapBuffers() ;
}
// ---------------------------------------------------------------------

void glutInit( int *argcp, char **argv )
{
   GetState()->init( argcp, argv ) ;
}
// ---------------------------------------------------------------------

void glutInitWindowPosition( int x, int y )
{
   GetState()->initWindowPosition( x, y );
}
// ---------------------------------------------------------------------

void glutInitWindowSize( int width, int height )
{
   GetState()->initWindowSize( width, height );
}
// ---------------------------------------------------------------------

void glutMainLoop( void )
{
   GetState()->mainLoop() ;
}
// ---------------------------------------------------------------------

void glutPostRedisplay( void )
{
   GetState()->postRedisplay() ;
}

// *********************************************************************
//
// callback registration  functions:
//
// *********************************************************************

void glutKeyboardFunc( KeyboardCBPType func )
{
   GetState()->keyboardFunc( func ) ;
}
// ---------------------------------------------------------------------

void glutSpecialFunc( SpecialCBPType func )
{
   GetState()->specialFunc( func ) ;
}
// ---------------------------------------------------------------------

void glutDisplayFunc( DisplayCBPType func )
{
   GetState()->displayFunc( func ) ;
}
// ---------------------------------------------------------------------

void glutMouseFunc( MouseCBPType func )
{
   GetState()->mouseFunc( func ) ;
}
// ---------------------------------------------------------------------

void glutReshapeFunc( ReshapeCBPType func )
{
   GetState()->reshapeFunc( func ) ;
}
// ---------------------------------------------------------------------

void glutMotionFunc( MotionCBPType func )
{
   GetState()->motionFunc( func ) ;
}
// ---------------------------------------------------------------------

void glutIdleFunc( IdleCBPType func )
{
    GetState()->idleFunc( func ) ;
}
// ---------------------------------------------------------------------

void glutTimerFunc( unsigned int msecs, TimerCBPType func, int value )
{
    GetState()->timerFunc( msecs, func, value );
}
// ----------------------------------------------------------------------------

void glutInitDisplayMode( unsigned int mode )
{
    GetState()->initDisplayMode( mode );
}
// ----------------------------------------------------------------------------

void glutCreateMenu( MenuCBPType func )
{
   GetState()->createMenu( func );
}
// ----------------------------------------------------------------------------

void glutSetMenu( int menu )
{
   GetState()->setMenu( menu );
}
// ----------------------------------------------------------------------------

int  glutGetMenu( void )
{
   return GetState()->getMenu();
}
// ----------------------------------------------------------------------------

void glutDestroyMenu( int menu )
{
   GetState()->destroyMenu( menu );
}
// ----------------------------------------------------------------------------

void glutAddMenuEntry( const char * name, int value )
{
   GetState()->addMenuEntry( name, value);
}
// ----------------------------------------------------------------------------

void glutAddSubMenu( const char * name, int menu )
{
   GetState()->addSubMenu( name, menu );
}
// ----------------------------------------------------------------------------

void glutChangeToMenuEntry( int entry, const char * name, int value )
{
   GetState()->changeToMenuEntry( entry, name, value );
}
// ----------------------------------------------------------------------------

void glutChangeToSubMenu( int entry, const char * name, int value )
{
   GetState()->changeToSubMenu( entry, name, value );
}
// ----------------------------------------------------------------------------

void glutRemoveMenuItem( int entry )
{
   GetState()->removeMenuItem( entry );
}
// ----------------------------------------------------------------------------

void glutAttachMenu( int button )
{
   GetState()->attachMenu( button );
}
// ----------------------------------------------------------------------------

void glutDetachMenu( int button )
{
   GetState()->dettachMenu( button );
}


// *********************************************************************

}  // end namespace cocoglut
