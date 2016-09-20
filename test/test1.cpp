// *********************************************************************
// **
// ** Cocoglut test program
// **
// ** Copyright (C) 2016 Carlos Ureña
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

#include <cassert>
#include <iostream>
#include <cocoglut-api.hpp>
#include <vector>
#include <OpenGL/gl.h>

using namespace cocoglut ;
using namespace std ;


bool closed1 = false ,
     closed2 = false ;


int win1, win2 ;

float       ang  = 0.0 ;
const float dang = 6.0 ;


//#define logt1( msg )  cout << "test1: debug: " << msg << endl << flush
#define logt1( msg )


bool idleIsActived = false ;

// -----------------------------------------------------------------------------

void OpenGLReport(  )
{
   GLint acc_r, acc_g, acc_b ;
   glGetIntegerv( GL_ACCUM_RED_BITS,   &acc_r );
   glGetIntegerv( GL_ACCUM_GREEN_BITS, &acc_g );
   glGetIntegerv( GL_ACCUM_BLUE_BITS,  &acc_b );

   GLboolean depthTestEnabled ;
   GLint     depthTestBits ;
   glGetBooleanv( GL_DEPTH_TEST, &depthTestEnabled );
   glGetIntegerv( GL_DEPTH_BITS, &depthTestBits );

   using namespace std ;
   cout  << "OpenGL implementation info:" << endl
         << "    Implementation vendor     == " << glGetString(GL_VENDOR)  << endl
         << "    Renderer (GPU)            == " << glGetString(GL_RENDERER) << endl
         << "    OpenGL version            == " << glGetString(GL_VERSION) << endl
         << "    GLSL version              == " << glGetString(GL_SHADING_LANGUAGE_VERSION) << endl
         << "    Accum. buffer bits (rgb)  == " << "(" << acc_r << "," << acc_g << "," << acc_b << ")" << endl
         << "    Depth test is enabled     == " << ( depthTestEnabled == GL_TRUE ? "yes" : "no" ) << endl
         << "    Depth buffer num. bits    == " << depthTestBits << endl
         //<< "    Extensions:" << glGetString(GL_EXTENSIONS) << endl
         << flush ;
}
// -----------------------------------------------------------------------------

void DrawTriangleBE()
{
   glBegin(GL_TRIANGLES);
      glColor3f( 1.0, 0.0, 0.0 ); glVertex3f(  0.0,  0.9, 0.0 );
      glColor3f( 0.0, 1.0, 0.0 ); glVertex3f( -0.9, -0.9, 0.0 );
      glColor3f( 0.0, 0.0, 1.0 ); glVertex3f( +0.9, -0.9 ,0.0 );
   glEnd();
}
// -----------------------------------------------------------------------------
void DrawPrimitive3( int primitiveType,
                     const std::vector<float> & vertices,
                     const std::vector<float> & colors )
{

   assert( vertices.size() % 3 == 0 && vertices.size() > 0 );

   if (colors.size() == 3 )
      glColor4f( colors[0], colors[1], colors[2], 1.0 );
   else if (colors.size() > 0 )
      assert( colors.size() == vertices.size());

   const bool sendColorsArray = colors.size() > 3 ;

   // specify and enable pointer to vertex array
   glVertexPointer( 3, GL_FLOAT, 0, vertices.data() );
   glEnableClientState( GL_VERTEX_ARRAY );

   // specify and enable pointer to colors array
   if ( sendColorsArray )
   {  glColorPointer( 3, GL_FLOAT, 0, colors.data() );
      glEnableClientState( GL_COLOR_ARRAY );
   }

   // draw the polygon
   glDrawArrays( primitiveType, 0, vertices.size()/3 ) ;

   // disable vertex and color arrays
   glDisableClientState( GL_VERTEX_ARRAY );
   if ( sendColorsArray )
      glDisableClientState( GL_COLOR_ARRAY );
}
// -----------------------------------------------------------------------------

void DrawTriangleDA()
{
   const std::vector<float> vertices =
   {   0.0,  0.9, 0.0,
      -0.9, -0.9, 0.0,
       0.9, -0.9, 0.0
    } ;

    const std::vector<float> colors =
    {  1.0, 0.0, 0.0,
       0.0, 1.0, 0.0,
       0.0, 0.0, 1.0
    } ;

    DrawPrimitive3( GL_TRIANGLES, vertices, colors );
}
// -----------------------------------------------------------------------------

void DrawTrianglesDepthTest()
{
    //
    const std::vector<float> vertices1 =
    {  -0.5, -0.5, 0.0,
        0.5, -0.5, 0.0,
       -0.5,  0.5, 0.0
    } ;

    const std::vector<float> color1 = {  1.0, 0.0, 0.0 } ;

    const std::vector<float> vertices2 =
    {   -0.7, -0.7,  0.5,
         0.5,  0.0, -0.5,
         0.0,  0.5, -0.5
    } ;
    const std::vector<float> color2 = {  0.0, 0.0, 1.0 } ;

    DrawPrimitive3( GL_TRIANGLES, vertices1, color1 );
    DrawPrimitive3( GL_TRIANGLES, vertices2, color2 );
}
// -----------------------------------------------------------------------------

void Redraw1( void )
{
   cout << "redraw 1" << endl << flush ;

   static bool primera = true ;
   if ( primera )
      OpenGLReport() ;
   primera = false ;

   logt1("begins: Redraw1" );



   glClearColor(1.0, 1.0, 1.0, 0.0 );
   glClear(GL_COLOR_BUFFER_BIT  | GL_DEPTH_BUFFER_BIT );

   // smooth/flat shading test
   //glShadeModel( GL_SMOOTH );
   //DrawTriangleDA() ;

   // depth test
   glEnable( GL_DEPTH_TEST );
   DrawTrianglesDepthTest() ;

   glutSwapBuffers() ;
   logt1("ends  : Redraw1" );

}
// -----------------------------------------------------------------------------

void Keyboard1( unsigned char key, int x, int y )
{
   logt1("begins: 'Keyboard1'") ;

   if ( isalnum(key) )
      logt1("            key (u. char) == " << key );
   else
      logt1("            key (u. char) == " << "(not alpha num.)" );
   logt1("            key (int)     == " << ((int)key) );

   if ( key == 27 ) // close window on escape key
   {
      glutDestroyWindow( glutGetWindow() );
      closed1 = true ;
      if ( closed2 )
         exit(0);
   }
}
// -----------------------------------------------------------------------------

void Redraw2( void )
{

      cout << "redraw 2" << endl << flush ;
   logt1("begins: Redraw2") ;

   static bool primera = true ;
   if ( primera )
      OpenGLReport() ;
   primera = false ;

   glClearColor( 1.0, 1.0, 1.0, 0.0 );

   glClear(GL_COLOR_BUFFER_BIT  | GL_DEPTH_BUFFER_BIT );

   glMatrixMode( GL_MODELVIEW );
   glPushMatrix() ;
      glRotatef( ang, 0.0, 0.0, 1.0 );

      // smooth/flat shading test
      //glShadeModel( GL_FLAT );
      //DrawTriangleDA() ;
      // depth test test
      glDisable( GL_DEPTH_TEST );
      DrawTrianglesDepthTest() ;

   glPopMatrix();

   glutSwapBuffers() ;
   logt1("ends  : Redraw2") ;

}
// -----------------------------------------------------------------------------

void IdleFunc2( void )
{
    if ( closed2 )
    {
      glutIdleFunc( NULL );
      return ;
    }

    glutSetWindow( win2 );
    logt1("begins: IdleFunc2()" ) ;
    ang = ang + dang ;
    logt1("begins:         ang == " ) ;
    glutPostRedisplay() ;

    logt1("ends  : IdleFunc2()") ;
}
// -----------------------------------------------------------------------------

void Keyboard2( unsigned char key, int x, int y )
{
   logt1("begins: Keyboard2");

   if ( isalnum(key) )
      logt1("            key (u. char) == " << key );
   else
      logt1("            key (u. char) == " << "(not alpha num.)" );
   logt1("            key (int)     == " << ((int)key) );


   if ( key == 27 ) // close window on escape key
   {
      glutDestroyWindow( glutGetWindow() );
      closed2 = true ;
      if ( closed1 )
         exit(0);
   }
   else if ( key == 'r' || key == 'R' )
   {
      ang = ang + dang ;
      glutPostRedisplay() ;
   }
   else if ( key == 'i' || key == 'I' )
   {
      idleIsActived = ! idleIsActived ;
      if ( idleIsActived )
      {
          glutIdleFunc( IdleFunc2 );
      }
      else
      {
          glutIdleFunc( NULL );
      }
   }

}
// -----------------------------------------------------------------------------

void Reshape( int ancho, int alto )
{
   logt1("begins: Reshape(" << ancho << "," << alto << ")" ) ;


   //int min = ancho < alto ? ancho : alto ;
   //glViewport( (ancho-min)/2, (alto-min/2), min, min ) ;

   glViewport( 0,0, ancho, alto ) ;
   glMatrixMode( GL_MODELVIEW ) ;
   glLoadIdentity() ;

   glMatrixMode( GL_PROJECTION );
   glLoadIdentity() ;


   logt1("ends  : Reshape" );
}
// ---------------------------------------------------------------------

void Motion( int x, int y )
{
   logt1("called: Motion(" << x << "," << y << ")" ) ;

}
// -----------------------------------------------------------------------------

void menuFunc1( int value )
{
   cout << "called: menuFunc1(" << value << ")" << endl << flush ;
}
// -----------------------------------------------------------------------------

void menuFunc2( int value )
{
   cout << "called: menuFunc2(" << value << ")" << endl << flush ;
}
// -----------------------------------------------------------------------------

int main( int argc, char * argv[] )
{
   logt1("begins: main.");

   glutInit( &argc, argv ) ;

   glutInitDisplayMode( CCG_OPENGL_2 );
   glutInitWindowPosition( 100, 100 );
   win1 = glutCreateWindow("cocoglut ventana 1" ) ;
   glutDisplayFunc( Redraw1 );
   glutKeyboardFunc( Keyboard1 ) ;
   glutReshapeFunc( Reshape );
   glutMotionFunc( Motion );

   int subm1 = glutCreateMenu( menuFunc1 );
   glutAddMenuEntry("m1 submenu 1 --11",11);
   glutAddMenuEntry("m1 submenu 2 --12",12);
   glutAddMenuEntry("m1 submenu 3 --13",13);

   glutCreateMenu( menuFunc1 );
   glutAddMenuEntry("m1 -item 1",1);
   glutAddMenuEntry("m1 -item 2",2);
   glutAddMenuEntry("m1 -item 3",3);
   glutAddSubMenu  ("m1 -item 4- sub",subm1);
   glutAttachMenu( GLUT_RIGHT_BUTTON );

   glutChangeToMenuEntry( 2, "m1 -item 2, modificado --2", 2 );
   glutChangeToMenuEntry( 4, "m1 -item 4, sub quitado --4", 4 );

   glutAddSubMenu( "m1 -item 5 - sub aniadido",subm1 );


   int subm2 = glutCreateMenu( menuFunc2 );
   glutAddMenuEntry("m2 submenu 1 -21",21);
   glutAddMenuEntry("m2 submenu 2 -22",22);
   glutAddMenuEntry("m2 submenu 3 -23",23);

   glutInitWindowPosition( 200, 200 );
   win2 = glutCreateWindow("cocoglut ventana 2");
   glutDisplayFunc( Redraw2 ) ;
   glutKeyboardFunc( Keyboard2 ) ;
   glutReshapeFunc( Reshape );
   glutMotionFunc( Motion );


   glutCreateMenu( menuFunc2 );
   glutAddMenuEntry("m2 -item 1 -- 4",4);
   glutAddMenuEntry("m2 -item 2 -- 5",5);
   glutAddMenuEntry("m2 -item 3 -- 6",6);



   glutAttachMenu( GLUT_RIGHT_BUTTON );

   glutChangeToSubMenu( 2, " m2 -item 2 --changed to sub",subm2);

   glutMainLoop() ;

   logt1("begins: main.");
   return 0 ;

}
