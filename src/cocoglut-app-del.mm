// *********************************************************************
// **
// ** Implementation for "AppDelegate" class
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


#import <iostream>
#import <cocoglut-app-del.h>
#import <cocoglut-state.h>

using namespace std ;

// *********************************************************************

@implementation ccg_AppDelegate

- (id)init {
    
    if ( self = [super init] ) 
    {
      ls = NULL ;
    }
    return self;
}
// ---------------------------------------------------------------------

- (void) checkLs
{
   if ( ls == NULL )
   {
      cout << "cocoglut: error: ccg_AppDelegate::checkLs: 'ls' is NULL" << endl << flush ;
      exit(1) ;
   }
}
// ---------------------------------------------------------------------
// called when NSApplication run method is called from 'glutMainLoop'

- (void)applicationWillFinishLaunching:(NSNotification *)notification 
{
   [self checkLs] ;
   logd("begins: ccg_AppDelegate::applicationWillFinishLaunching:") ;
   
   ls->appWillFinishLaunching( notification ) ;

   logd("ends  : ccg_AppDelegate::applicationWillFinishLaunching:") ;
}
// ---------------------------------------------------------------------
// called just after 'applicationWillFinishLaunching:'

- (void)applicationDidFinishLaunching:(NSNotification *) notification 
{
   [self checkLs] ;

   logd("begins: ccg_AppDelegate::applicationDidFinishLaunching:" ) ;
   
   ls->appDidFinishLaunching( notification ) ;
   
   logd("ends  : ccg_AppDelegate::applicationDidFinishLaunching:" ) ;
   
}
// ---------------------------------------------------------------------
// called when the idle notification has been received, callback is installed
// from 'glutMainLoop'

- (void) idleNotificationReceived: (NSNotification *) notification
{
   logd("begins: ccg_AppDelegate::::idleNotificationReceived") ;
   
   [self checkLs] ;
   ls->idleNotificationReceived( notification ) ;
   
   logd("ends : ccg_AppDelegate::idleNotificationReceived") ;
}

// ---------------------------------------------------------------------

- (void)dealloc 
{
   logd("begins: ccg_AppDelegate::::dealloc:") ;
    
   [super dealloc];

   logd("ends  : ccg_AppDelegate::dealloc:") ;
   
}

@end
