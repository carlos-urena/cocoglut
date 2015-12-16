// *********************************************************************
// **
// ** Interface for "MyOpenGLView" class
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

#ifndef COCOGLUT_VIEW_H
#define COCOGLUT_VIEW_H

#import <Cocoa/Cocoa.h>

namespace cocoglut { class LibraryState ; } 

// *********************************************************************
// custom opengl cocoa view class
// see:
// https://developer.apple.com/library/mac/documentation/GraphicsImaging/Conceptual/OpenGL-MacProgGuide/opengl_drawing/opengl_drawing.html#//apple_ref/doc/uid/TP40001987-CH404-SW8

@interface ccg_OpenGLView : NSOpenGLView
   
   {
      @public unsigned windowId ;            // 'LibraryState' window id for the window this view is in.
      @public cocoglut::LibraryState * ls ;  // link to the library state singleton object
   }
   - (void) checkLs ;
   - (BOOL) acceptsFirstResponder ; // no necesario??

   // ---------------------------------------------------------------------
   // cocoa events callbacks (all of them are redirected to the library state)

   - (void) drawRect:       (NSRect) bounds;
   - (void) reshape ;
   - (void) mouseDown:      (NSEvent *)theEvent ;
   - (void) mouseUp:        (NSEvent *)theEvent ;
   - (void) rightMouseDown: (NSEvent *)theEvent ;
   - (void) rightMouseUp:   (NSEvent *)theEvent ;
   - (void) otherMouseDown: (NSEvent *)theEvent ;  
   - (void) otherMouseUp:   (NSEvent *)theEvent ;
   - (void) keyDown:        (NSEvent *)theEvent ;
   - (void) keyUp:          (NSEvent *)theEvent ;
   - (void) mouseDragged:   (NSEvent *)theEvent ;


@end

// *********************************************************************



#endif // MYOPENGLVIEW_H
