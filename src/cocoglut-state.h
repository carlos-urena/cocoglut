// *********************************************************************
// **
// ** Declaration for "WindowState" and "LibraryState" classes
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

#ifndef COCOGLUT_STATE_H
#define COCOGLUT_STATE_H

#include <vector>
#include <string>
#include <cocoglut-api.hpp>

#import <Cocoa/Cocoa.h>
#import <cocoglut-view.h>
#import <cocoglut-app-del.h>

//#define logd( msg )  cout << "cocoglut: debug: " << msg << endl << flush
#define logd( msg )


// *********************************************************************

namespace cocoglut
{

// *********************************************************************
// struct used to store callback functions pointers for a window
// (only for window-specific callbacks, not for global callbacks like idle or timers)

struct WinCallbackPointers
{
   KeyboardCBPType keyboardCBP ;
   SpecialCBPType  specialCBP ;
   DisplayCBPType  displayCBP ;
   MouseCBPType    mouseCBP ;
   ReshapeCBPType  reshapeCBP ;
   MotionCBPType   motionCBP ;

   WinCallbackPointers()
   {
      keyboardCBP = NULL ;
      specialCBP  = NULL ;
      displayCBP  = NULL ;
      mouseCBP    = NULL ;
      reshapeCBP  = NULL ;
      motionCBP   = NULL ;
   }
} ;

// *********************************************************************
// struct used for a window state data

class WindowState
{
   public:

   NSWindow *          cocoaWindow ; // reference to Cocoa window object
   ccg_OpenGLView *    cocoaView ;   // reference to Cocoa OpenGL view object
   int                 id ;          // window id (1 plus its position in window state vector)
   WinCallbackPointers callbacks ;   // set of callback pointers for this window
   bool                isClosed ;    // true if the window has been already closed

   WindowState()
   {
      cocoaWindow = NULL ;
      cocoaView   = NULL ;
      id          = 0 ;
      isClosed    = false ;
   }
} ;

// *****************************************************************************
class MenuItem ;

class Menu
{
   public:
   Menu();
   std::vector<MenuItem *> items ;
   NSMenu *                cocoaMenu ;
} ;
// *****************************************************************************

class MenuItem
{
public:

   MenuItem( const std::string & p_title, Menu * p_menu );
   std::string    title ;
   unsigned       index ;
   NSMenuItem *   cocoaItem ;
   Menu *         menu ;
   void clicked();
} ;

// *********************************************************************
// singleton class LibraryState

class LibraryState
{
   private:

   // attributes for next window to be created
   int nextWinPosX,  // x position
       nextWinPosY,  // y position
       nextWinSizeX, // x size
       nextWinSizeY; // y size

   unsigned int idMode ; // init display mode for next opengl context creation
                         // must be CCG_OPENGL_2 CCG_OPENGL_4

   // window state info
   unsigned windowCount;  // total number of created windows
   int      currWinId ;   // identifier of the current window (0 implies there is no current window)
   bool     initCalled;   // 'true' after 'glutInit' called, 'false' before

   std::vector<WindowState *> ws ;  // window state for all created windows (size()==windowCount)

   // cocoa application and application delegate
   NSAutoreleasePool *  pool ;   // autorelease pool used to free something
   NSApplication *      app ;    // reference to main application singleton object
   ccg_AppDelegate *    appDel ; // application delegate singleton object

   // idle callback managing
   bool             idleObsReg; // 'true' if idle notification observer already registered
   IdleCBPType      idleCBP;    // idle callback funtion pointer (NULL when not set)
   TimerCBPType     timerCBP ;  // timer callback function pointer (NULL when not set)
   NSNotification * idleNotification ; // idle notification object

   //

   // ******************************************************************
   // aux methods

   // checks init has been called (exits when it has not)
   void checkInit() ;

   // returns window state pointer in 'ws':
   //
   // ** if the state is inconsistent or 'winId' is invalid, aborts
   // ** if the window has been closed, returns NULL
   // ** otherwise: return pointer to window state in ws

   WindowState * getWindowState( int winId ) ;

   // returns window state pointer for current window in 'ws', after these checks
   //
   // ** if there is no current window, aborts
   // ** if the current window has been closed, aborts
   // ** otherwise, returns the pointer (which will be allways non-null)

   WindowState * getCurrentWindowState() ;

   // creates a pixel format for an opengl view (must be called before creating the view)
   // idMode must be: CCG_OPENGL_2 (default) or CCG_OPENGL_4
   NSOpenGLPixelFormat * createPixelFormat( ) ;

   // prints debug state info on 'cout'
   void debugState() ;

   // test about how to create a menu (in response to an event)
   void testMenu(NSEvent * event, WindowState * cws);
   void testMenu2(NSEvent * event, WindowState * cws);


   // ******************************************************************
   // public methods

   public:

   // ------------------------------------------------------------------
   // inline constructor, sets default or initial values

   LibraryState()
   {
      // executed just after executable is loaded on RAM,
      // do NOT use Cocoa/OpenGL functionality here
      nextWinPosX      = 256 ,
      nextWinPosY      = 256 ,
      nextWinSizeX     = 512 ,
      nextWinSizeY     = 512 ;
      windowCount      = 0 ;
      currWinId        = 0 ; // identifier of the current window ( 0 --> there is no current window )
      initCalled       = false ;
      pool             = NULL ;
      app              = NULL ;
      idleNotification = NULL ;
      idleObsReg       = false ;
      idleCBP          = NULL ;
      timerCBP         = NULL ;
      idMode           = CCG_OPENGL_2 ;
   }

   void menuTestMethod();// just for test, called from the view

   // ------------------------------------------------------------------
   // methods called from one of the opengl views or window delegate, when
   // cocoa user events occurr or when redraw or reshape is neccesary,
   // or when a window will be closed

   void windowWillClose( const int windowId ) ;
   void drawRect( const int windowId, const NSRect * bounds ) ;
   void reshape( const int windowId ) ;
   bool handleEvent( const int windowId, NSEvent *  event ) ;

   // ------------------------------------------------------------------
   // called from the application delegate singleton

   void appWillFinishLaunching  ( NSNotification * notification ) ;
   void appDidFinishLaunching   ( NSNotification * notification ) ;
   void idleNotificationReceived( NSNotification * notification ) ;

   // ------------------------------------------------------------------
   // glut API methods for callback registration

   void keyboardFunc ( KeyboardCBPType func ) ;
   void specialFunc  ( SpecialCBPType  func ) ;
   void displayFunc  ( DisplayCBPType  func ) ;
   void mouseFunc    ( MouseCBPType    func ) ;
   void reshapeFunc  ( ReshapeCBPType  func ) ;
   void motionFunc   ( MotionCBPType   func ) ;
   void idleFunc     ( IdleCBPType     func ) ;
   void timerFunc    ( unsigned int msecs, TimerCBPType func, int value ) ;


   // ------------------------------------------------------------------
   // glut API methods for window management and initialization

   int  createWindow       ( const char *name ) ;
   void destroyWindow      ( int win );
   int  getWindow          ( ) ;
   void setWindow          ( int win );
   void swapBuffers        ( ) ;

   void init               ( int *argcp, char **argv ) ;
   void initDisplayMode    ( unsigned int mode ) ;
   void initWindowPosition ( int x, int y ) ;
   void initWindowSize     ( int width, int height );
   void mainLoop           ( ) ;
   void postRedisplay      ( ) ;

   // -----------------------------------------------------------------
   // menu functions

   void createMenu       ( MenuCBPType func ) ;
   void setMenu          ( int menu ) ;
   int  getMenu          ( void ) ;
   void destroyMenu      ( int menu ) ;
   void addMenuEntry     ( const char * name, int value ) ; // added 'const'
   void addSubMenu       ( const char * name, int menu ) ;
   void changeToMenuEntry( int entry, const char * name, int value ) ;
   void changeToSubMenu  ( int entry, const char * name, int value ) ;
   void removeMenuItem   ( int entry ) ;
   void attachMenu       ( int button ) ;
   void dettachMenu      ( int button ) ;

} ; // end class LibraryState.

// *********************************************************************

// returns the library state singleton

LibraryState * GetState() ;


}  // end namespace osxglut


#endif // no def LIBR....
