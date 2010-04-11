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

#include "../hbqt.h"

/*----------------------------------------------------------------------*/
#if QT_VERSION >= 0x040500
/*----------------------------------------------------------------------*/

/*
 *  class Tab
 *  enum Flag { IncludeTrailingSpaces, ShowTabsAndSpaces, ShowLineAndParagraphSeparators, AddSpaceForLineAndParagraphSeparators, SuppressColors }
 *  flags Flags
 *  enum TabType { LeftTab, RightTab, CenterTab, DelimiterTab }
 *  enum WrapMode { NoWrap, WordWrap, ManualWrap, WrapAnywhere, WrapAtWordBoundaryOrAnywhere }
 */

/*
 *  Constructed[ 12/16 [ 75.00% ] ]
 *
 *  *** Unconvered Prototypes ***
 *  -----------------------------
 *
 *  void setTabArray ( QList<qreal> tabStops )
 *  void setTabs ( QList<Tab> tabStops )
 *  QList<qreal> tabArray () const
 *  QList<Tab> tabs () const
 */

#include <QtCore/QPointer>

#include <QtGui/QTextOption>


/* QTextOption ()
 * QTextOption ( Qt::Alignment alignment )
 * QTextOption ( const QTextOption & other )
 * ~QTextOption ()
 */

typedef struct
{
   void * ph;
   bool bNew;
   QT_G_FUNC_PTR func;
} QGC_POINTER_QTextOption;

QT_G_FUNC( hbqt_gcRelease_QTextOption )
{
   QGC_POINTER * p = ( QGC_POINTER * ) Cargo;

   if( p && p->bNew )
   {
      if( p->ph )
      {
         HB_TRACE( HB_TR_DEBUG, ( "ph=%p    _rel_QTextOption   /.\\", p->ph ) );
         delete ( ( QTextOption * ) p->ph );
         HB_TRACE( HB_TR_DEBUG, ( "ph=%p YES_rel_QTextOption   \\./", p->ph ) );
         p->ph = NULL;
      }
      else
      {
         HB_TRACE( HB_TR_DEBUG, ( "ph=%p DEL_rel_QTextOption    :     Object already deleted!", p->ph ) );
         p->ph = NULL;
      }
   }
   else
   {
      HB_TRACE( HB_TR_DEBUG, ( "ph=%p PTR_rel_QTextOption    :    Object not created with new=true", p->ph ) );
      p->ph = NULL;
   }
}

void * hbqt_gcAllocate_QTextOption( void * pObj, bool bNew )
{
   QGC_POINTER * p = ( QGC_POINTER * ) hb_gcAllocate( sizeof( QGC_POINTER ), hbqt_gcFuncs() );

   p->ph = pObj;
   p->bNew = bNew;
   p->func = hbqt_gcRelease_QTextOption;

   if( bNew )
   {
      HB_TRACE( HB_TR_DEBUG, ( "ph=%p    _new_QTextOption", pObj ) );
   }
   else
   {
      HB_TRACE( HB_TR_DEBUG, ( "ph=%p NOT_new_QTextOption", pObj ) );
   }
   return p;
}

HB_FUNC( QT_QTEXTOPTION )
{
   void * pObj = NULL;

   pObj = new QTextOption() ;

   hb_retptrGC( hbqt_gcAllocate_QTextOption( pObj, true ) );
}

/*
 * Qt::Alignment alignment () const
 */
HB_FUNC( QT_QTEXTOPTION_ALIGNMENT )
{
   hb_retni( ( Qt::Alignment ) hbqt_par_QTextOption( 1 )->alignment() );
}

/*
 * Flags flags () const
 */
HB_FUNC( QT_QTEXTOPTION_FLAGS )
{
   hb_retni( ( QTextOption::Flags ) hbqt_par_QTextOption( 1 )->flags() );
}

/*
 * void setAlignment ( Qt::Alignment alignment )
 */
HB_FUNC( QT_QTEXTOPTION_SETALIGNMENT )
{
   hbqt_par_QTextOption( 1 )->setAlignment( ( Qt::Alignment ) hb_parni( 2 ) );
}

/*
 * void setFlags ( Flags flags )
 */
HB_FUNC( QT_QTEXTOPTION_SETFLAGS )
{
   hbqt_par_QTextOption( 1 )->setFlags( ( QTextOption::Flags ) hb_parni( 2 ) );
}

/*
 * void setTabStop ( qreal tabStop )
 */
HB_FUNC( QT_QTEXTOPTION_SETTABSTOP )
{
   hbqt_par_QTextOption( 1 )->setTabStop( hb_parnd( 2 ) );
}

/*
 * void setTextDirection ( Qt::LayoutDirection direction )
 */
HB_FUNC( QT_QTEXTOPTION_SETTEXTDIRECTION )
{
   hbqt_par_QTextOption( 1 )->setTextDirection( ( Qt::LayoutDirection ) hb_parni( 2 ) );
}

/*
 * void setUseDesignMetrics ( bool enable )
 */
HB_FUNC( QT_QTEXTOPTION_SETUSEDESIGNMETRICS )
{
   hbqt_par_QTextOption( 1 )->setUseDesignMetrics( hb_parl( 2 ) );
}

/*
 * void setWrapMode ( WrapMode mode )
 */
HB_FUNC( QT_QTEXTOPTION_SETWRAPMODE )
{
   hbqt_par_QTextOption( 1 )->setWrapMode( ( QTextOption::WrapMode ) hb_parni( 2 ) );
}

/*
 * qreal tabStop () const
 */
HB_FUNC( QT_QTEXTOPTION_TABSTOP )
{
   hb_retnd( hbqt_par_QTextOption( 1 )->tabStop() );
}

/*
 * Qt::LayoutDirection textDirection () const
 */
HB_FUNC( QT_QTEXTOPTION_TEXTDIRECTION )
{
   hb_retni( ( Qt::LayoutDirection ) hbqt_par_QTextOption( 1 )->textDirection() );
}

/*
 * bool useDesignMetrics () const
 */
HB_FUNC( QT_QTEXTOPTION_USEDESIGNMETRICS )
{
   hb_retl( hbqt_par_QTextOption( 1 )->useDesignMetrics() );
}

/*
 * WrapMode wrapMode () const
 */
HB_FUNC( QT_QTEXTOPTION_WRAPMODE )
{
   hb_retni( ( QTextOption::WrapMode ) hbqt_par_QTextOption( 1 )->wrapMode() );
}


/*----------------------------------------------------------------------*/
#endif             /* #if QT_VERSION >= 0x040500 */
/*----------------------------------------------------------------------*/
