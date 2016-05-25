#include <iostream>
#include <cocoglut-api.hpp>
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

// -----------------------------------------------------------------------------

void InformeOpenGL(  )
{

   static bool noprimera = false ;
   if ( noprimera )
      return ;
   noprimera = true ;

   GLint acc_r, acc_g, acc_b ;
   glGetIntegerv( GL_ACCUM_RED_BITS,   &acc_r );
   glGetIntegerv( GL_ACCUM_GREEN_BITS, &acc_g );
   glGetIntegerv( GL_ACCUM_BLUE_BITS,  &acc_b );

   using namespace std ;
   cout  << "OpenGL implementation info:" << endl
         << "    implementation vendor     == " << glGetString(GL_VENDOR)  << endl
         << "    hardware                  == " << glGetString(GL_RENDERER) << endl
         << "    OpenGL version            == " << glGetString(GL_VERSION) << endl
         << "    GLSL version              == " << glGetString(GL_SHADING_LANGUAGE_VERSION) << endl
         << "    accum buffer bits (r,g,b) == " << "(" << acc_r << "," << acc_g << "," << acc_b << ")" << endl
         << flush ;

}

// -----------------------------------------------------------------------------
void Redraw1( void )
{
   logt1("begins: Redraw1" );
   InformeOpenGL() ;

   glClearColor(0.2, 0.2, 0.3, 0);
   glClear(GL_COLOR_BUFFER_BIT);

   glColor3f( 0.2, 0.5, 1.0 );
   glBegin(GL_TRIANGLES);
      glVertex3f(  0.0,  0.9, 0.0);
      glVertex3f( -0.9, -0.9, 0.0);
      glVertex3f( +0.9, -0.9 ,0.0);
   glEnd();

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
   logt1("begins: Redraw2") ;
   InformeOpenGL() ;

   glClearColor(0.3, 0.2, 0.2, 0);
   glClear(GL_COLOR_BUFFER_BIT);

   glMatrixMode( GL_MODELVIEW );
   glPushMatrix() ;
      glRotatef( ang, 0.0, 0.0, 1.0 );
      glColor3f( 1.0, 0.2, 0.2 );
      glBegin(GL_TRIANGLES);
         glVertex3f(  0.0,  0.9, 0.0);
         glVertex3f( -0.9, -0.9, 0.0);
         glVertex3f( +0.9, -0.9 ,0.0);
      glEnd();
   glPopMatrix();


   glutSwapBuffers() ;
   logt1("ends  : Redraw2") ;

}
// -----------------------------------------------------------------------------

bool idleActivado = false ;

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
      idleActivado = ! idleActivado ;
      if ( idleActivado )
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

void menuFunc1( int value )
{
   cout << "called: menuFunc1(" << value << ")" << endl << flush ;
}

void menuFunc2( int value )
{
   cout << "called: menuFunc2(" << value << ")" << endl << flush ;
}


// -----------------------------------------------------------------------------

int main( int argc, char * argv[] )
{
   logt1("begins: main.");

   glutInit( &argc, argv ) ;

   glutInitWindowPosition( 100, 100 );
   win1 = glutCreateWindow("cocoglut ventana 1" ) ;
   glutDisplayFunc( Redraw1 );
   glutKeyboardFunc( Keyboard1 ) ;
   glutReshapeFunc( Reshape );
   glutMotionFunc( Motion );

   int subm = glutCreateMenu( menuFunc1 );
   glutAddMenuEntry("m1 submenu 1",11);
   glutAddMenuEntry("m1 submenu 2",12);
   glutAddMenuEntry("m1 submenu 3",13);

   glutCreateMenu( menuFunc1 );
   glutAddMenuEntry(" m1 -item 1",1);
   glutAddMenuEntry(" m1 -item 2",2);
   glutAddMenuEntry(" m1 -item 3",3);
   glutAddSubMenu  (" m1 -item 4- sub",subm);
   glutAttachMenu( GLUT_RIGHT_BUTTON );

   glutChangeToMenuEntry( 2, "m2 -item 2, modificado", 3 );

   glutInitWindowPosition( 200, 200 );
   win2 = glutCreateWindow("cocoglut ventana 2");
   glutDisplayFunc( Redraw2 ) ;
   glutKeyboardFunc( Keyboard2 ) ;
   glutReshapeFunc( Reshape );
   glutMotionFunc( Motion );


   glutCreateMenu( menuFunc2 );
   glutAddMenuEntry(" m2 -item 1",4);
   glutAddMenuEntry(" m2 -item 2",5);
   glutAddMenuEntry(" m2 -item 3",6);
   glutAttachMenu( GLUT_RIGHT_BUTTON );

   glutMainLoop() ;

   logt1("begins: main.");
   return 0 ;

}
