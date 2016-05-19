// *********************************************************************
// **
// ** Implementation for "MyOpenGLView" class
// **
// **
// ** This is a Cocoa custom OpenGl View, see:
// **   https://developer.apple.com/opengl/
// **   https://developer.apple.com/library/mac/documentation/GraphicsImaging/Conceptual/OpenGL-MacProgGuide/opengl_drawing/opengl_drawing.html#//apple_ref/doc/uid/TP40001987-CH404-SW8
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

#include <iostream>
#import <cocoglut-view.h>
#import <cocoglut-state.h>

// *********************************************************************

@implementation ccg_OpenGLView

- (BOOL) acceptsFirstResponder // needed ?
{
    return YES;
}
// ---------------------------------------------------------------------
// checks library state pointer (ls) is not null, aborts when it is

- (void) checkLs
{
   using namespace std ;

   if ( ls == NULL )
   {
      cout << "cocoglut: error: event received at the view with null library state reference " << endl << flush ;
      exit(1);
   }
}
// ---------------------------------------------------------------------
// handles a redraw event

-(void) drawRect: (NSRect) bounds
{
   [self checkLs] ;
   ls->drawRect( windowId, &bounds );
}
// ---------------------------------------------------------------------
// handles reshape event

- (void) reshape
{
   [self checkLs] ;
   ls->reshape( windowId ) ;
}

// ---------------------------------------------------------------------
// handles left mouse down event

- (void)mouseDown:(NSEvent *)theEvent
{
   [self checkLs] ;
   if ( ! ls->handleEvent( windowId, theEvent ) )
      [[self nextResponder] mouseDown:theEvent];
}
// ---------------------------------------------------------------------
// handles left mouse up event

- (void)mouseUp:(NSEvent *)theEvent
{
   [self checkLs] ;
   if ( ! ls->handleEvent( windowId, theEvent) )
      [[self nextResponder] mouseUp:theEvent];
}
// ---------------------------------------------------------------------
// handles right mouse down event

- (void)rightMouseDown:(NSEvent *)theEvent
{
   [self checkLs] ;

   if ( ! ls->handleEvent( windowId, theEvent ) )
      [[self nextResponder] rightMouseDown:theEvent];
}
// ---------------------------------------------------------------------
// handles right mouse up event

- (void)rightMouseUp:(NSEvent *)theEvent
{
   [self checkLs] ;
   if ( ! ls->handleEvent( windowId, theEvent) )
      [[self nextResponder] rightMouseUp:theEvent];
}
// ---------------------------------------------------------------------
// handles other (middle?) mouse down event

- (void)otherMouseDown:(NSEvent *)theEvent
{
   [self checkLs] ;
   if ( ! ls->handleEvent( windowId, theEvent ) )
      [[self nextResponder] otherMouseDown:theEvent];
}
// ---------------------------------------------------------------------
// handles other (middle?) mouse up event

- (void)otherMouseUp:(NSEvent *)theEvent
{
   [self checkLs] ;
   if ( ! ls->handleEvent( windowId, theEvent) )
      [[self nextResponder] otherMouseUp:theEvent];
}
// ---------------------------------------------------------------------
// handles key down event

- (void) keyDown:(NSEvent *)theEvent
{
   [self checkLs] ;
   if ( ! ls->handleEvent( windowId, theEvent ) )
      [[self nextResponder] keyDown:theEvent];
}
// ---------------------------------------------------------------------
// handles key up event

- (void) keyUp:(NSEvent *)theEvent
{
   [self checkLs] ;
   if ( ! ls->handleEvent( windowId, theEvent ) )
      [[self nextResponder] keyUp:theEvent];
}

// ---------------------------------------------------------------------
// handles mouse dragged event (mouse moved with left button pressed)

- (void)mouseDragged:(NSEvent *)theEvent
{
   [self checkLs] ;
   if ( ! ls->handleEvent( windowId, theEvent ) )
      [[self nextResponder] mouseDragged:theEvent];
}

// *********************************************************************


@end  // @implementation MyOpenGLView.
