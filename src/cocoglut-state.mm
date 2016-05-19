// *********************************************************************
// **
// ** Implementation for "WindowState" and "LibraryState" classes
// **
// ** See:
// **   https://casperbhansen.wordpress.com/2010/08/15/dev-tip-nibless-development/
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


#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>
#import <iostream>
#import <vector>
#import <string>
#import <cocoglut-state.h>
#import <cocoglut-app-del.h>
#import <cocoglut-win-del.h>
#import <cocoglut-api.hpp>
#include <OpenGL/gl.h>  // only for test code...¿?

using namespace std ;

namespace cocoglut
{

// *********************************************************************
// library state singleton (created on binary load)

static LibraryState libraryState ;

// ---------------------------------------------------------------------
// returns the library state singleton

LibraryState * GetState()
{
   return &libraryState ;

}

// *********************************************************************
// class LibraryState methods implementation

void LibraryState::checkInit()
{
   if ( ! initCalled )
   {
      cout << "cocoglut: error: a function has been called before 'glutInit'." << endl ;
      exit(1);
   }
}
// ---------------------------------------------------------------------

WindowState * LibraryState::getWindowState( int winId )
{
   checkInit() ;


   if ( winId > windowCount || windowCount > ws.size() || winId <= 0 )
   {
      cout << "cocoglut: error: inconsistent state or window id in 'getWindowState'." << endl ;
      exit(1);
   }

   WindowState * winSt = ws[winId-1] ;

   if ( winSt == NULL )
   {
      cout << "cocoglut: error: current window is NULL." << endl ;
      exit(1);
   }
   if ( winSt->isClosed )
      return NULL ;   // NULL return value means the window was already closed

   if ( winSt->cocoaWindow == NULL || winSt->cocoaView == NULL )
   {
      cout << "cocoglut: error: the window (winId) has NULL cocoa window or NULL cocoa view, but is not closed !!" << endl ;
      exit(1);
   }

   return winSt ;
}
// ---------------------------------------------------------------------

WindowState * LibraryState::getCurrentWindowState()
{
   WindowState * cws = getWindowState( currWinId ) ;
   if ( cws == NULL )
   {
      cout << "error: the current window has been closed" << endl << flush ; // this may happen ?
      exit(1);
   }
   return cws ;
}

// ---------------------------------------------------------------------
// creates a pixel format for an opengl view (before creating the view)

NSOpenGLPixelFormat * LibraryState::createPixelFormat(  )
{
   // see:
   // http://stackoverflow.com/questions/11602406/opengl-3-2-w-nsopenglview

   NSOpenGLPixelFormatAttribute attrs_v1[] =
   {
      NSOpenGLPFADoubleBuffer,
      NSOpenGLPFADepthSize, 24,
      //NSOpenGLPFASupersample,
      //NSOpenGLPFASampleBuffers, (NSOpenGLPixelFormatAttribute)1,
      //NSOpenGLPFASamples, (NSOpenGLPixelFormatAttribute)4,
      NSOpenGLPFAAccumSize,  32,
      //NSOpenGLPFAOpenGLProfile,  NSOpenGLProfileVersion3_2Core,
      0
   };

   NSOpenGLPixelFormatAttribute attrs_v2[] =
   {
      NSOpenGLPFAOpenGLProfile,  NSOpenGLProfileVersion3_2Core,
      0
   };

   NSOpenGLPixelFormatAttribute * attrs = NULL ;

   switch( idMode )
   {
      case CCG_OPENGL_2 :
         attrs = attrs_v1 ;
         break ;
      case CCG_OPENGL_4 :
         attrs = attrs_v2 ;
         break ;
      default:
         cout << "error: invalid mode for creating opengl context" ;
         exit(1);
         break ;
   }

   NSOpenGLPixelFormat *
      pf =  [[[NSOpenGLPixelFormat alloc] initWithAttributes:attrs] autorelease ];

   if ( pf == NULL )
   {  cout << "cocoglut: error: cannot create required pixel format for the OpenGL view." << endl << flush ;
      exit(1);
   }

   return pf ;
   //return [NSOpenGLView defaultPixelFormat] ; // we could use this for the default pixel format
}

// ---------------------------------------------------------------------

void LibraryState::debugState()
{
   logd( "LibraryState::debugState") ;
   logd( "     app key window: == " << app.keyWindow);
   logd( "     window list == ");

   for( unsigned i = 0 ; i < ws.size() ; i++ )
      logd( "                " << (i+1) << " window == " << ws[i]->cocoaWindow );

   logd( "**** end" );
}


// -----------------------------------------------------------------------------

void LibraryState::drawRect( const int windowId, const NSRect * bounds )
{
   logd( "LibraryState::drawRect begins, window id   == " << windowId ) ;

   // get window state, return if closed
   WindowState * cws = getWindowState( windowId ) ;
   if ( cws == NULL )   // means the window is closed
   {  logd( " drawRect: window was closed " );
      return ;
   }

   // get callback pointer and return when NULL
   DisplayCBPType displayCBP = cws->callbacks.displayCBP ;
   if (  displayCBP == NULL )
      return ;

   // make current and invoke callback
   currWinId = windowId ;
   displayCBP() ;

}
// -----------------------------------------------------------------------------

void LibraryState::reshape( const int windowId )
{
   logd( "begins LibraryState::reshape(" << windowId << ")" ) ;

   // get window state, return if closed
   WindowState * cws = getWindowState( windowId ) ;
   if ( cws == NULL )   // means the window is closed
   {
      logd("    reshape: window was closed " ) ;
      return ;
   }

   // get info about the new frame
   NSRect  frame = [cws->cocoaView frame] ;
   logd("    frame orig == " << frame.origin.x  << " , " << frame.origin.y ) ;
   logd("    frame size == " << frame.size.width << " x " << frame.size.height ) ;

   // compute pixels units
   const int factor = 2 ; // should use cocoa conversion functions here!!!
   const int pixWidth   = int(frame.size.width * factor),
             pixHeight  = int(frame.size.height * factor);


   // get callback pointer and return when NULL
   ReshapeCBPType reshapeCBP = cws->callbacks.reshapeCBP ;
   if (  reshapeCBP == NULL )
   {
      // we must call glViewport here, according to glut standard
      glViewport( 0,0, pixWidth,pixHeight ) ;
      logd( "ends reshape(" << windowId << ")  (not handled: no callback registered)" ) ;
      return ;
   }

   // make current and invoke callback
   currWinId = windowId ;
   reshapeCBP( pixWidth, pixHeight ) ;
   logd( "ends reshape(" << windowId << ")  (handled)") ;
}
// ---------------------------------------------------------------------

bool LibraryState::handleEvent( const int windowId, NSEvent * event )
{
   logd("LibraryState::handleEvent, window id  == " << windowId ) ;

   // get window state, return if closed
   WindowState * cws = getWindowState( windowId ) ; // get window state data
   if ( cws == NULL )
   {
      // this may happen if the current window has been already closed,
      // but events from it where generated before being closed

      logd("the window has been closed? - event not managed" << windowId ) ;
      return false ;
   }

   // initialize several local vars....
   bool          handled      = false,   // result: true if the event was handled
                 isMouse      = false,   // true iif the event is a mouse button press/raise or dragged event
                 isDragged    = false,   // true iif the event is a mouse dragged event (left button only)
                 isKey        = false ;  // true if the event is a keyboard or special event
   std::string   typeDesc ;              // cocoa event type descriptor string (for debug)
   int           mouseButton,            // glut code for button pressed on mouse events
                 typeUpDown;             // glut code for type up/down (both for mouse and keys)

   // set glut event data from cocoa event type
   switch( event.type )
   {
      case NSLeftMouseDown:
         typeDesc    = "NSLeftMouseDown:" ;
         isMouse     = true ;
         mouseButton = GLUT_LEFT_BUTTON ;
         typeUpDown  = GLUT_DOWN ;
         break ;
      case NSRightMouseDown:
         typeDesc    = "NSRightMouseDown:" ;
         isMouse     = true ;
         mouseButton = GLUT_RIGHT_BUTTON ;
         typeUpDown  = GLUT_DOWN ;
         break ;
      case NSOtherMouseDown:
         typeDesc    = "NSOtherMouseDown:" ;
         isMouse     = true ;
         mouseButton = GLUT_MIDDLE_BUTTON ; // we assume cocoa 'other' is glut 'middle' ¿?
         typeUpDown  = GLUT_DOWN ;
         break ;
      case NSLeftMouseUp:
         typeDesc    = "NSLeftMouseUp:" ;
         isMouse     = true ;
         mouseButton = GLUT_LEFT_BUTTON ;
         typeUpDown  = GLUT_UP ;
         break ;
      case NSRightMouseUp:
         typeDesc    = "NSRightMouseUp:" ;
         isMouse     = true ;
         mouseButton = GLUT_RIGHT_BUTTON ;
         typeUpDown  = GLUT_UP ;
         break ;
      case NSLeftMouseDragged:
         typeDesc    = "NSLeftMouseDragged:" ;
         isDragged   = true ;
         isMouse     = true ;
         break ;
      case NSKeyDown:
         typeDesc    = "NSKeyDown:" ;
         isKey       = true ;
         typeUpDown  = GLUT_DOWN ;
         break ;
      case NSKeyUp:
         typeDesc    = "NSKeyUp:" ;
         isKey       = true ;
         typeUpDown  = GLUT_UP ;
         break ;
      default:
         typeDesc    = "Other/unknown" ;
         break ;
   }

   logd(" ##### event type == " << typeDesc ) ;

   // invoke appropiate callback (if any callback is registered)
   if ( isMouse )
   {
      NSPoint      mousePos = event.locationInWindow ;
      int          pos_x    = (int)round(mousePos.x),
                   pos_y    = (int)round(mousePos.y) ;

      logd( "    mouse pos x  == " << pos_x );
      logd( "    mouse pos y  == " << pos_y );


      if ( isDragged )   // mouse moved with left button clicked
      {
         MotionCBPType motionCBP = cws->callbacks.motionCBP ;
         if ( motionCBP != NULL )
         {
            // make window the current window and actually invoke callback
            currWinId = windowId ;
            motionCBP( pos_x, pos_y );
            handled = true ;
         }
      }
      else  // it must be a click on a button
      {

         if ( typeUpDown == GLUT_DOWN &&
              mouseButton == GLUT_RIGHT_BUTTON )  // cambiar a: si hay regitrado menu
         {
            static NSMenu *theMenu = NULL ;
            if ( theMenu == NULL )
            {
               theMenu = [[NSMenu alloc] initWithTitle:@"Contextual Menu"];
               [theMenu insertItemWithTitle:@"Beep" action:@selector(beep:) keyEquivalent:@"" atIndex:0];
               [theMenu insertItemWithTitle:@"Honk" action:@selector(honk:) keyEquivalent:@"" atIndex:1];
            }
            [NSMenu popUpContextMenu:theMenu withEvent:event forView:cws->cocoaView ];
         }
         else
         {
            MouseCBPType mouseCBP = cws->callbacks.mouseCBP ;
            if ( mouseCBP != NULL )
            {
               // make window the current window and actually invoke callback
               currWinId = windowId ;
               mouseCBP( mouseButton, typeUpDown, pos_x, pos_y );
               handled = true ;
            }
         }
      }
   }
   else if ( isKey && typeUpDown == GLUT_DOWN )  // it looks like glut ignores key release.....¿?
   {

      // see apple docs:
      // https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/EventOverview/HandlingKeyEvents/HandlingKeyEvents.html#//apple_ref/doc/uid/10000060i-CH7-SW1

      const char *    charsCStr     = [event.characters UTF8String];
      NSString *      charactersIM  = [event charactersIgnoringModifiers],
               *      characters    = [event characters] ;
      bool            isSpecial     = false ;
      unsigned short  keyCode       = event.keyCode ;
      unsigned int    specialKey ;           // arrow key glut code
      std::string     skd ;                  // special key description

      // check for special arrow keys
      if ([event modifierFlags] & NSNumericPadKeyMask)
      {
         if ( [charactersIM length] == 1 )
         {
            unichar keyChar = [charactersIM characterAtIndex:0];
            isSpecial = true ;
            switch( keyChar )
            {
               case NSLeftArrowFunctionKey:
                  specialKey = GLUT_KEY_LEFT ;
                  skd = "left arrow" ;
                  break ;
               case NSRightArrowFunctionKey:
                  specialKey = GLUT_KEY_RIGHT ;
                  skd = "right arrow" ;
                  break ;
               case NSUpArrowFunctionKey:
                  specialKey = GLUT_KEY_UP ;
                  skd = "up arrow" ;
                  break ;
               case NSDownArrowFunctionKey:
                  specialKey = GLUT_KEY_DOWN ;
                  skd = "down arrow" ;
                  break ;
               default:
                  isSpecial = false ;
                  break ;
            }
         }
      }

      NSPoint mousePos = event.locationInWindow ;
      int     pos_x    = (int)round(mousePos.x) ,
              pos_y    = (int)round(mousePos.y) ;

      if ( isSpecial ) // special key
      {
         logd("    key type     == special" );
         logd("    key descr.   == " << skd );

         SpecialCBPType specialCBP = cws->callbacks.specialCBP ;

         if ( specialCBP != NULL  )
         {
            // make window the current window and actually invoke callback
            currWinId = windowId ;
            specialCBP( specialKey, pos_x, pos_y );
            handled = true ;
         }
      }
      else  // normal key
      {
         logd( "    key type    == normal" ) ;
         logd( "    key code    == " << keyCode )  ;
         logd( "    characters  == '" << charsCStr << "'" )  ;

         KeyboardCBPType keyboardCBP = cws->callbacks.keyboardCBP ;

         if ( keyboardCBP != NULL && strlen(charsCStr) > 0 )   // todo: call a function to compute whether it is a normal char or not
         {
            unsigned char first = charsCStr[0] ;
            // make window the current window and actually invoke callback
            currWinId = windowId ;
            keyboardCBP( first, pos_x, pos_y );
            handled = true ;
         }
      } // end if ( isSpecial ....)
   } // end if ( isKey .... )
   else if ( isKey && typeUpDown == GLUT_UP )
   {
      handled = true ;  // avoid cococa beep on key up (we state we handled it)
   }


   // debug report
   if ( handled )
      logd( " event handled" ) ;
   else
      logd( " event NOT handled (no callback registered or unknown type)" ) ;

   // done, return.
   return handled ;
}
// ---------------------------------------------------------------------

void LibraryState::appWillFinishLaunching( NSNotification * notification )
{
   if ( windowCount == 0 || windowCount != ws.size() )
   {
      cout << "cocoglut: error at 'LibraryState::appWillFinishLaunching', inconsisten state or no windows created before?" << endl << flush ;
      exit(1) ;
   }

   // link every view to its window
   for( unsigned i = 0 ; i < ws.size() ; i++ )
   {
      if ( ! ws[i]->isClosed )
      {
         NSWindow * win = ws[i]->cocoaWindow ;
         [win setContentView: ws[i]->cocoaView ];
         [win makeFirstResponder: ws[i]->cocoaView];
      }
   }
}
// ---------------------------------------------------------------------

void LibraryState::appDidFinishLaunching( NSNotification * notification )
{

   if ( appDel == NULL )
   {
      cout << "cocoglut: error: - no appDel in 'LibraryState::appDidFinishLaunching'" << endl << flush ;
      exit(1);
   }
   if ( windowCount == 0 || windowCount != ws.size())
   {
      cout << "cocoglut: error: ('LibraryState::appDidFinishLaunching'), no windows created before?" << endl << flush ;
      exit(1) ;
   }

   // show every window and link it with the app delegate

   for( unsigned i = 0 ; i < ws.size() ; i++ )
   {
      if ( ! ws[i]->isClosed )
      {
         NSWindow * win = ws[i]->cocoaWindow ;
         [win makeKeyAndOrderFront:appDel];
         [win orderFrontRegardless] ;
         //win.level = 0 ;
      }
   }
}
// ---------------------------------------------------------------------
// creates a new window, 'name' can be utf-8

int LibraryState::createWindow( const char *name )
{
   logd("begins LibraryState::createWindow(" << name << ")" ) ;

   checkInit() ;

   // increase window counter and save new window id
   windowCount ++ ;
   unsigned newWinId = windowCount ;

   // create a reference rect (arreglar)
   NSRect contentSize = NSMakeRect((float)nextWinPosX,  (float)nextWinPosX,
                                   (float)nextWinSizeX, (float)nextWinSizeY );

   // allocate window
   NSWindow * newWindow = [[NSWindow alloc]
      initWithContentRect: contentSize
      styleMask:           NSTitledWindowMask |
                           NSClosableWindowMask |
                           NSMiniaturizableWindowMask |
                           NSResizableWindowMask
      backing:             NSBackingStoreBuffered
      defer:               YES   // will it be shown on 'app did finish launch....' event
      //defer:               NO
   ];

   newWindow.title = [NSString stringWithUTF8String:name] ;

   // create the pixel format 'pf' for the view
   NSOpenGLPixelFormat *pf = createPixelFormat( ) ;

   // allocate, configure a new view, link it with the window
   //    the view wants the best resolution, see:
   //    https://www.opengl.org/discussion_boards/showthread.php/178916-Using-the-retina-display-on-a-macbook-pro
   //    https://developer.apple.com/library/mac/documentation/GraphicsAnimation/Conceptual/HighResolutionOSX/CapturingScreenContents/CapturingScreenContents.html
   //    https://developer.apple.com/library/mac/documentation/GraphicsAnimation/Conceptual/HighResolutionOSX/Introduction/Introduction.html

   ccg_OpenGLView * newView = [[ccg_OpenGLView alloc] initWithFrame:contentSize pixelFormat: pf];

   // falta: view == NULL?

   newView->windowId = newWinId ;
   newView->ls       = this ;

   [newView setWantsBestResolutionOpenGLSurface: YES] ;

   // crate delegate and link it to the library

   ccg_WindowDelegate * winDel = [ccg_WindowDelegate alloc] ;

   winDel->windowId   = newWinId ;
   winDel->ls         = this ;
   newWindow.delegate = winDel ;

   // create window state object and add it to the list in 'ws'
   WindowState * nws = new WindowState ;

   nws->cocoaWindow = newWindow ;
   nws->cocoaView   = newView ;
   nws->id          = newWinId ;

   ws.push_back( nws ) ;

   // ????? quite probably not needed at all

   [newWindow makeFirstResponder:newView];
   newWindow.initialFirstResponder= newView ;

   [newWindow makeKeyWindow];

   // just debugging
   bool cbkw = newWindow.canBecomeKeyWindow ;
   logd(" window.canBecomeKeyWindow: returns  [" <<  cbkw <<"]" ) ;

   // the window becomes the current window
   currWinId = newWinId ;

   logd("ends: LibraryState::createWindow(" << name << "), window id == " << currWinId ) ;

   // done. return new window identifier:
   return  newWinId ;
}

// ---------------------------------------------------------------------
// called from ccg_WindowDelegate whenever a cocoa window is to be closed,
// both when it is programatically  closed (from glutDestroyWindow)
// and when the close button is clicked

void LibraryState::windowWillClose( const int windowId )
{
   logd( "begins: LibraryState::windowWillClose(" << windowId << ")" ) ;

   WindowState * dws = getWindowState( windowId ) ;
   if ( dws == NULL )
   {
      cout << "cocoglut: error: inconsistent state when attempting to destroy an already destroyed window!" << endl << flush ;
      exit(1);
   }
   if ( windowId == currWinId )  // required by the api spec
      currWinId = 0 ;

   // save window and view for later use in this function ¿?
   NSWindow *     oldWin  = dws->cocoaWindow ;
   ccg_OpenGLView * oldView = dws->cocoaView ;

   // reset the entry in 'ws' array
   dws->isClosed    = true ;  // mark as closed
   dws->cocoaWindow = NULL ;  // unlink from library state
   dws->cocoaView   = NULL ;  // unlink from library state

   // if there are no more opened windows, terminate the app
   unsigned openCount = 0 ;
   for( unsigned i = 0 ; i < ws.size() ; i++ )
   {
      logd( "      windowId == " << i+1 << " : "  << (ws[i]->isClosed ? "is closed" : "is opened") );
      if ( ! ws[i]->isClosed )
         openCount ++ ;
   }

   logd( "open count == " << openCount ) ;

   // exit the loop if there are no more opened windows
   // this is non standard: glut states 'glutMainLopps' never returns
   //if ( openCount == 0 )
   //   [app stop: nil] ;
}

// ---------------------------------------------------------------------
// destroys the window:
// https://www.opengl.org/resources/libraries/glut/spec3/node19.html

void LibraryState::destroyWindow( int win )
{
   logd( "begins LibraryState::destroyWindow(" << win << ")" ) ;

   WindowState * dws = getWindowState( win ) ;
   if ( dws == NULL )
   {
      cout << "cocoglut: error: 'glutDestroyWindow' attempt to destroy an already destroyed window!" << endl << flush ;
      exit(1);
   }
   if ( win == currWinId )  // required by the api spec
      currWinId = 0 ;

   // calls 'windowWillClose', then close
   [dws->cocoaWindow close] ;
}

// ---------------------------------------------------------------------
// returns current window id, 0 if there is no current window

int LibraryState::getWindow()
{
   return currWinId ;
}

// ---------------------------------------------------------------------

void LibraryState::setWindow( int win )
{
   WindowState * sws = getWindowState( win ) ;
   if ( sws == NULL )
   {
      cout << "cocoglut: error: the window with id " << win << " is closed." << endl << flush ;
      exit(1);
   }
   currWinId = win ;
}

// ---------------------------------------------------------------------

void LibraryState::swapBuffers( )
{
   // we could check whether redisplay callback is running or not
   // and emit an error when it is not. Here, we just assume it is.

   WindowState * cws = getCurrentWindowState(); // requires a current window

   // wait for all pending opengl commands to terminate
   glFlush() ;
   // actually swap buffers:
   glSwapAPPLE() ;

}

// ---------------------------------------------------------------------

void LibraryState::init( int *argcp, char **argv )
{
   // disallow repeated call
   if ( initCalled )
   {
      cout << "cocoglut: error: 'glutInit' called twice." << endl ;
      exit(1);
   }

   logd( "begins: LibraryState::init" ) ;

   // create an autorelease pool
   pool = [[NSAutoreleasePool alloc] init];

   // make sure the application singleton has been instantiated, and
   // get a reference to it.
   app  = [NSApplication sharedApplication];


   // just testing.....
   NSMenu* theMenu = [[[app mainMenu] itemAtIndex:0] submenu];
   theMenu.title = @"COCO Glut App" ;

   // configure the application singleton
   // needed: see: http://www.cocoawithlove.com/2010/09/minimalist-cocoa-programming.html
   // (if this is not done, key events are not send to the views)
   [app setActivationPolicy:NSApplicationActivationPolicyRegular];

   // instantiate our new application delegate
   appDel = [[[ccg_AppDelegate alloc] init] autorelease];

   // set 'ls' pointer in the app delegate.
   // allows accessing this state object from the app delegate
   appDel->ls = this ;

   // assign our delegate to the NSApplication
   [app setDelegate: (id)appDel]; // cua: added "(id)"

   // register call to 'glutInit
   initCalled = true ;

   logd( "ends: LibraryState::init") ;
}
// ---------------------------------------------------------------------

void LibraryState::initWindowPosition( int x, int y )
{
   checkInit();

   nextWinPosX = x ;
   nextWinPosY = y ;
}
// ---------------------------------------------------------------------

void LibraryState::initWindowSize( int width, int height )
{
   checkInit() ;

   nextWinSizeX = width ;
   nextWinSizeY = height ;
}


// -----------------------------------------------------------------------------

void LibraryState::idleNotificationReceived( NSNotification * notification )
{
   static int counter = 0 ;
   logd( "begins: LibraryState::idleNotificationReceived, counter = " << counter ) ;
   counter++ ;
   assert( idleNotification != NULL );

   if ( idleCBP == NULL )  // may have been deactivted after idle notification posted
   {
      logd( "ends : idleNotificationReceived (callback is set to NULL)" ) ;
      return ;             // (notification is not re-posted, so callback is not called anymore)
   }

   // actually call idle callback:
   // (the callback is responsible for setting the current window, if needed,
   //  according to the glut standard)

   idleCBP() ;

   // enque the notification in the default notification queue
   // (re-post notification, so callback will be called again)

   [[NSNotificationQueue defaultQueue]
      enqueueNotification : idleNotification
      postingStyle        : NSPostWhenIdle
   ];

   logd( "ends : LibraryState::idleNotificationReceived (notification has been reposted)" ) ;
}

// -----------------------------------------------------------------------------



void LibraryState::idleFunc( IdleCBPType func )
{
   logd( " begins: LibraryState::idleFunc"  ) ;
   checkInit() ;

   // save function pointer, when it is NULL, do nothing more
   idleCBP = func ;
   if ( idleCBP == NULL )
      return ;

   // the first time a idle callback is set:
   // register for notification observation on the appDelegate
   if ( ! idleObsReg )
   {
      [[NSNotificationCenter defaultCenter]
         addObserver   : appDel
         selector      : @selector(idleNotificationReceived:)
         name          : @"CocoglutIdleNotification"
         object        : nil
      ];
      idleObsReg = true ;
   }

   // re-create notification object
   // (if it is re-used here, a core dump is obtained  ¿¿??)

   idleNotification =
         [NSNotification
            notificationWithName : @"CocoglutIdleNotification"
            object               : NULL //(id)this //myIdleHandlerObject
         ];
   assert( idleNotification != NULL ) ;

   // enque the notification in the default notification queue
   // (this causes the notification to be posted the first time)

   [[NSNotificationQueue defaultQueue]
      enqueueNotification  : idleNotification
      postingStyle         : NSPostWhenIdle
   ];

   logd( "ends : LibraryState::idleFunc" ) ;
}

// -----------------------------------------------------------------------------

void LibraryState::timerFunc( unsigned int msecs, TimerCBPType func, int value )
{
  logd( "begins: LibraryState::timerFunc"  ) ;
  checkInit() ;

  // save function pointer, when it is NULL, do nothing more
  timerCBP = func ;
  if ( timerCBP == NULL )
  {  logd( "ends: LibraryState::timerFunc: timer callback function pointer set to NULL." );
     return ;
  }
}

// -----------------------------------------------------------------------------

void LibraryState::mainLoop( )
{

   logd( "begins: LibraryState::mainLoop" ) ;
   checkInit() ;

   if ( windowCount == 0 )
   {
      cout << "osxglut: error: 'glutMainLoop' called before any call to 'glutCreateWindow'." << endl ;
      exit(1);
   }

   // call the run method of our application
   [app run];

   // drain the autorelease pool
   [pool drain];

   logd( "ends : LibraryState::mainLoop" ) ;
}
// ---------------------------------------------------------------------

void LibraryState::postRedisplay()
{
   logd( "begins: LibraryState::postRedisplay" ) ;
   WindowState * cws = getCurrentWindowState();
   [cws->cocoaView setNeedsDisplay:YES] ;
   logd( "ends : LibraryState::postRedisplay" ) ;

}
// ---------------------------------------------------------------------

void LibraryState::keyboardFunc( KeyboardCBPType func )
{
   WindowState * cws = getCurrentWindowState();
   cws->callbacks.keyboardCBP = func ;
}
// ---------------------------------------------------------------------

void LibraryState::specialFunc( SpecialCBPType func )
{
   WindowState * cws = getCurrentWindowState();
   cws->callbacks.specialCBP = func ;
}
// ---------------------------------------------------------------------

void LibraryState::displayFunc( DisplayCBPType func )
{
   WindowState * cws = getCurrentWindowState();
   cws->callbacks.displayCBP = func ;
}
// ---------------------------------------------------------------------

void LibraryState::mouseFunc( MouseCBPType func )
{
   WindowState * cws = getCurrentWindowState();
   cws->callbacks.mouseCBP = func ;
}
// ---------------------------------------------------------------------

void LibraryState::reshapeFunc( ReshapeCBPType func )
{
   WindowState * cws = getCurrentWindowState();
   cws->callbacks.reshapeCBP = func ;
}
// ---------------------------------------------------------------------

void LibraryState::motionFunc( MotionCBPType func )
{
   WindowState * cws = getCurrentWindowState();
   cws->callbacks.motionCBP = func ;
}
// ---------------------------------------------------------------------

void LibraryState::initDisplayMode( unsigned int mode )
{
   assert( idMode == CCG_OPENGL_2 || idMode == CCG_OPENGL_4 );
   idMode = mode ;
}


// *********************************************************************
}  // end namespace cocoglut
