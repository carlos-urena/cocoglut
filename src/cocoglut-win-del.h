// *********************************************************************
// **
// ** Interface for "WindowDelegate" class
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

#ifndef COCOGLUT_WIN_DEL_H
#define COCOGLUT_WIN_DEL_H

#import <Cocoa/Cocoa.h>

namespace cocoglut { class LibraryState ; }

// *********************************************************************
//
// Class implementing protocol NSWindowDelegate
// see:
// https://developer.apple.com/library/mac/documentation/Cocoa/Reference/NSWindowDelegate_Protocol/

@interface ccg_WindowDelegate : NSObject  <NSWindowDelegate> 
   {
      @public unsigned windowId ;            // 'LibraryState' window id for the window this view is in.
      @public cocoglut::LibraryState * ls ;  // link to the library state singleton object
   }

   - (void)windowWillClose:(NSNotification *)notification ;

@end

// *********************************************************************


#endif
