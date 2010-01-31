/*
 * $Id$
 */

/* -------------------------------------------------------------------- */
/* WARNING: Automatically generated source file. DO NOT EDIT!           */
/*          Instead, edit corresponding .qth file,                      */
/*          or the generator tool itself, and run regenarate.           */
/* -------------------------------------------------------------------- */

/*
 * Harbour Project source code:
 * QT wrapper main header
 *
 * Copyright 2009-2010 Pritpal Bedi <pritpal@vouchcac.com>
 *
 * Copyright 2009 Marcos Antonio Gambeta <marcosgambeta at gmail dot com>
 * www - http://www.harbour-project.org
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2, or (at your option)
 * any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this software; see the file COPYING.  If not, write to
 * the Free Software Foundation, Inc., 59 Temple Place, Suite 330,
 * Boston, MA 02111-1307 USA (or visit the web site http://www.gnu.org/).
 *
 * As a special exception, the Harbour Project gives permission for
 * additional uses of the text contained in its release of Harbour.
 *
 * The exception is that, if you link the Harbour libraries with other
 * files to produce an executable, this does not by itself cause the
 * resulting executable to be covered by the GNU General Public License.
 * Your use of that executable is in no way restricted on account of
 * linking the Harbour library code into it.
 *
 * This exception does not however invalidate any other reasons why
 * the executable file might be covered by the GNU General Public License.
 *
 * This exception applies only to the code released by the Harbour
 * Project under the name Harbour.  If you copy code from other
 * Harbour Project or Free Software Foundation releases into a copy of
 * Harbour, as the General Public License permits, the exception does
 * not apply to the code that you add in this way.  To avoid misleading
 * anyone as to the status of such modified files, you must delete
 * this exception notice from them.
 *
 * If you write modifications of your own for Harbour, it is your choice
 * whether to permit this exception to apply to your modifications.
 * If you do not wish that, delete this exception notice.
 *
 */
/*----------------------------------------------------------------------*/

#include "hbapi.h"
#include "../hbqt.h"

/*----------------------------------------------------------------------*/
#if QT_VERSION >= 0x040500
/*----------------------------------------------------------------------*/

#include <QtCore/QPointer>

#include <QtGui/QMenu>


/*
 * QMenu ( QWidget * parent = 0 )
 * QMenu ( const QString & title, QWidget * parent = 0 )
 * ~QMenu ()
 */

typedef struct
{
   void * ph;
   bool bNew;
   QT_G_FUNC_PTR func;
   QPointer< QMenu > pq;
} QGC_POINTER_QMenu;

QT_G_FUNC( hbqt_gcRelease_QMenu )
{
   QGC_POINTER_QMenu * p = ( QGC_POINTER_QMenu * ) Cargo;

   if( p && p->bNew )
   {
      if( p->ph && p->pq )
      {
         const QMetaObject * m = ( ( QObject * ) p->ph )->metaObject();
         if( ( QString ) m->className() != ( QString ) "QObject" )
         {
            HB_TRACE( HB_TR_DEBUG, ( "YES_rel_QMenu   /.\\   ph=%p pq=%p", p->ph, (void *)(p->pq) ) );
            delete ( ( QMenu * ) p->ph );
            HB_TRACE( HB_TR_DEBUG, ( "YES_rel_QMenu   \\./   ph=%p pq=%p", p->ph, (void *)(p->pq) ) );
            p->ph = NULL;
         }
         else
         {
            HB_TRACE( HB_TR_DEBUG, ( "NO__rel_QMenuph=%p pq=%p", p->ph, (void *)(p->pq) ) );
         }
      }
      else
      {
         HB_TRACE( HB_TR_DEBUG, ( "DEL_rel_QMenu    :     Object already deleted!" ) );
      }
   }
   else
   {
      HB_TRACE( HB_TR_DEBUG, ( "PTR_rel_QMenu    :    Object not created with new()" ) );
      p->ph = NULL;
   }
}

void * hbqt_gcAllocate_QMenu( void * pObj, bool bNew )
{
   QGC_POINTER_QMenu * p = ( QGC_POINTER_QMenu * ) hb_gcAllocate( sizeof( QGC_POINTER_QMenu ), hbqt_gcFuncs() );

   p->ph = pObj;
   p->bNew = bNew;
   p->func = hbqt_gcRelease_QMenu;

   if( bNew )
   {
      new( & p->pq ) QPointer< QMenu >( ( QMenu * ) pObj );
      HB_TRACE( HB_TR_DEBUG, ( "   _new_QMenu                      ph=%p %i B %i KB", pObj, ( int ) hb_xquery( 1001 ), hbqt_getmemused() ) );
   }
   return p;
}

HB_FUNC( QT_QMENU )
{
   void * pObj = NULL;

   if( hb_pcount() >= 1 && HB_ISCHAR( 1 ) )
   {
      pObj = ( QMenu* ) new QMenu( hbqt_par_QString( 1 ), hbqt_par_QWidget( 2 ) ) ;
   }
   else
   {
      pObj = ( QMenu* ) new QMenu( hbqt_par_QWidget( 1 ) ) ;
   }

   hb_retptrGC( hbqt_gcAllocate_QMenu( pObj, true ) );
}

/*
 * QAction * actionAt ( const QPoint & pt ) const
 */
HB_FUNC( QT_QMENU_ACTIONAT )
{
   hb_retptrGC( hbqt_gcAllocate_QAction( hbqt_par_QMenu( 1 )->actionAt( *hbqt_par_QPoint( 2 ) ), false ) );
}

/*
 * QRect actionGeometry ( QAction * act ) const
 */
HB_FUNC( QT_QMENU_ACTIONGEOMETRY )
{
   hb_retptrGC( hbqt_gcAllocate_QRect( new QRect( hbqt_par_QMenu( 1 )->actionGeometry( hbqt_par_QAction( 2 ) ) ), true ) );
}

/*
 * QAction * activeAction () const
 */
HB_FUNC( QT_QMENU_ACTIVEACTION )
{
   hb_retptrGC( hbqt_gcAllocate_QAction( hbqt_par_QMenu( 1 )->activeAction(), false ) );
}

/*
 * QAction * addAction ( const QString & text )
 */
HB_FUNC( QT_QMENU_ADDACTION )
{
   hb_retptrGC( hbqt_gcAllocate_QAction( hbqt_par_QMenu( 1 )->addAction( QMenu::tr( hb_parc( 2 ) ) ), false ) );
}

/*
 * QAction * addAction ( const QIcon & icon, const QString & text )
 */
HB_FUNC( QT_QMENU_ADDACTION_1 )
{
   hb_retptrGC( hbqt_gcAllocate_QAction( hbqt_par_QMenu( 1 )->addAction( QIcon( hbqt_par_QString( 2 ) ), QMenu::tr( hb_parc( 3 ) ) ), false ) );
}

/*
 * QAction * addAction ( const QString & text, const QObject * receiver, const char * member, const QKeySequence & shortcut = 0 )
 */
HB_FUNC( QT_QMENU_ADDACTION_2 )
{
   hb_retptrGC( hbqt_gcAllocate_QAction( hbqt_par_QMenu( 1 )->addAction( QMenu::tr( hb_parc( 2 ) ), hbqt_par_QObject( 3 ), hbqt_par_char( 4 ), *hbqt_par_QKeySequence( 5 ) ), false ) );
}

/*
 * QAction * addAction ( const QIcon & icon, const QString & text, const QObject * receiver, const char * member, const QKeySequence & shortcut = 0 )
 */
HB_FUNC( QT_QMENU_ADDACTION_3 )
{
   hb_retptrGC( hbqt_gcAllocate_QAction( hbqt_par_QMenu( 1 )->addAction( QIcon( hbqt_par_QString( 2 ) ), QMenu::tr( hb_parc( 3 ) ), hbqt_par_QObject( 4 ), hbqt_par_char( 5 ), *hbqt_par_QKeySequence( 6 ) ), false ) );
}

/*
 * void addAction ( QAction * action )
 */
HB_FUNC( QT_QMENU_ADDACTION_4 )
{
   hbqt_par_QMenu( 1 )->addAction( hbqt_par_QAction( 2 ) );
}

/*
 * QAction * addMenu ( QMenu * menu )
 */
HB_FUNC( QT_QMENU_ADDMENU )
{
   hb_retptrGC( hbqt_gcAllocate_QAction( hbqt_par_QMenu( 1 )->addMenu( hbqt_par_QMenu( 2 ) ), false ) );
}

/*
 * QMenu * addMenu ( const QString & title )
 */
HB_FUNC( QT_QMENU_ADDMENU_1 )
{
   hb_retptrGC( hbqt_gcAllocate_QMenu( hbqt_par_QMenu( 1 )->addMenu( QMenu::tr( hb_parc( 2 ) ) ), false ) );
}

/*
 * QMenu * addMenu ( const QIcon & icon, const QString & title )
 */
HB_FUNC( QT_QMENU_ADDMENU_2 )
{
   hb_retptrGC( hbqt_gcAllocate_QMenu( hbqt_par_QMenu( 1 )->addMenu( QIcon( hbqt_par_QString( 2 ) ), QMenu::tr( hb_parc( 3 ) ) ), false ) );
}

/*
 * QAction * addSeparator ()
 */
HB_FUNC( QT_QMENU_ADDSEPARATOR )
{
   hb_retptrGC( hbqt_gcAllocate_QAction( hbqt_par_QMenu( 1 )->addSeparator(), false ) );
}

/*
 * void clear ()
 */
HB_FUNC( QT_QMENU_CLEAR )
{
   hbqt_par_QMenu( 1 )->clear();
}

/*
 * QAction * defaultAction () const
 */
HB_FUNC( QT_QMENU_DEFAULTACTION )
{
   hb_retptrGC( hbqt_gcAllocate_QAction( hbqt_par_QMenu( 1 )->defaultAction(), false ) );
}

/*
 * QAction * exec ()
 */
HB_FUNC( QT_QMENU_EXEC )
{
   hb_retptrGC( hbqt_gcAllocate_QAction( hbqt_par_QMenu( 1 )->exec(), false ) );
}

/*
 * QAction * exec ( const QPoint & p, QAction * action = 0 )
 */
HB_FUNC( QT_QMENU_EXEC_1 )
{
   hb_retptrGC( hbqt_gcAllocate_QAction( hbqt_par_QMenu( 1 )->exec( *hbqt_par_QPoint( 2 ), hbqt_par_QAction( 3 ) ), false ) );
}

/*
 * void hideTearOffMenu ()
 */
HB_FUNC( QT_QMENU_HIDETEAROFFMENU )
{
   hbqt_par_QMenu( 1 )->hideTearOffMenu();
}

/*
 * QIcon icon () const
 */
HB_FUNC( QT_QMENU_ICON )
{
   hb_retptrGC( hbqt_gcAllocate_QIcon( new QIcon( hbqt_par_QMenu( 1 )->icon() ), true ) );
}

/*
 * QAction * insertMenu ( QAction * before, QMenu * menu )
 */
HB_FUNC( QT_QMENU_INSERTMENU )
{
   hb_retptrGC( hbqt_gcAllocate_QAction( hbqt_par_QMenu( 1 )->insertMenu( hbqt_par_QAction( 2 ), hbqt_par_QMenu( 3 ) ), false ) );
}

/*
 * QAction * insertSeparator ( QAction * before )
 */
HB_FUNC( QT_QMENU_INSERTSEPARATOR )
{
   hb_retptrGC( hbqt_gcAllocate_QAction( hbqt_par_QMenu( 1 )->insertSeparator( hbqt_par_QAction( 2 ) ), false ) );
}

/*
 * bool isEmpty () const
 */
HB_FUNC( QT_QMENU_ISEMPTY )
{
   hb_retl( hbqt_par_QMenu( 1 )->isEmpty() );
}

/*
 * bool isTearOffEnabled () const
 */
HB_FUNC( QT_QMENU_ISTEAROFFENABLED )
{
   hb_retl( hbqt_par_QMenu( 1 )->isTearOffEnabled() );
}

/*
 * bool isTearOffMenuVisible () const
 */
HB_FUNC( QT_QMENU_ISTEAROFFMENUVISIBLE )
{
   hb_retl( hbqt_par_QMenu( 1 )->isTearOffMenuVisible() );
}

/*
 * QAction * menuAction () const
 */
HB_FUNC( QT_QMENU_MENUACTION )
{
   hb_retptrGC( hbqt_gcAllocate_QAction( hbqt_par_QMenu( 1 )->menuAction(), false ) );
}

/*
 * void popup ( const QPoint & p, QAction * atAction = 0 )
 */
HB_FUNC( QT_QMENU_POPUP )
{
   hbqt_par_QMenu( 1 )->popup( *hbqt_par_QPoint( 2 ), hbqt_par_QAction( 3 ) );
}

/*
 * bool separatorsCollapsible () const
 */
HB_FUNC( QT_QMENU_SEPARATORSCOLLAPSIBLE )
{
   hb_retl( hbqt_par_QMenu( 1 )->separatorsCollapsible() );
}

/*
 * void setActiveAction ( QAction * act )
 */
HB_FUNC( QT_QMENU_SETACTIVEACTION )
{
   hbqt_par_QMenu( 1 )->setActiveAction( hbqt_par_QAction( 2 ) );
}

/*
 * void setDefaultAction ( QAction * act )
 */
HB_FUNC( QT_QMENU_SETDEFAULTACTION )
{
   hbqt_par_QMenu( 1 )->setDefaultAction( hbqt_par_QAction( 2 ) );
}

/*
 * void setIcon ( const QIcon & icon )
 */
HB_FUNC( QT_QMENU_SETICON )
{
   hbqt_par_QMenu( 1 )->setIcon( QIcon( hbqt_par_QString( 2 ) ) );
}

/*
 * void setSeparatorsCollapsible ( bool collapse )
 */
HB_FUNC( QT_QMENU_SETSEPARATORSCOLLAPSIBLE )
{
   hbqt_par_QMenu( 1 )->setSeparatorsCollapsible( hb_parl( 2 ) );
}

/*
 * void setTearOffEnabled ( bool )
 */
HB_FUNC( QT_QMENU_SETTEAROFFENABLED )
{
   hbqt_par_QMenu( 1 )->setTearOffEnabled( hb_parl( 2 ) );
}

/*
 * void setTitle ( const QString & title )
 */
HB_FUNC( QT_QMENU_SETTITLE )
{
   hbqt_par_QMenu( 1 )->setTitle( QMenu::tr( hb_parc( 2 ) ) );
}

/*
 * QString title () const
 */
HB_FUNC( QT_QMENU_TITLE )
{
   hb_retc( hbqt_par_QMenu( 1 )->title().toAscii().data() );
}


/*----------------------------------------------------------------------*/
#endif             /* #if QT_VERSION >= 0x040500 */
/*----------------------------------------------------------------------*/
