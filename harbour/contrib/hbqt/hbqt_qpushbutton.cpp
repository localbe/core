/*
 * $Id$
 */
   
/* 
 * Harbour Project source code:
 * QT wrapper main header
 * 
 * Copyright 2009 Marcos Antonio Gambeta <marcosgambeta at gmail dot com>
 * Copyright 2009 Pritpal Bedi <pritpal@vouchcac.com>
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
#include "hbqt.h"

/*----------------------------------------------------------------------*/
#if QT_VERSION >= 0x040500
/*----------------------------------------------------------------------*/



#include <QtGui/QPushButton>


/*
 * QPushButton ( QWidget * parent = 0 )
 * QPushButton ( const QString & text, QWidget * parent = 0 )
 * QPushButton ( const QIcon & icon, const QString & text, QWidget * parent = 0 )
 * ~QPushButton ()
 */
HB_FUNC( QT_QPUSHBUTTON )
{
  if( hb_pcount() >= 2 )
    hb_retptr( ( QPushButton* ) new QPushButton( QIcon( hbqt_par_QString( 2 ) ), hbqt_par_QString( 2 ), hbqt_par_QWidget( 3 ) ) );
  else if( hb_pcount() >= 1 )
    hb_retptr( ( QPushButton* ) new QPushButton( hbqt_par_QString( 1 ), hbqt_par_QWidget( 2 ) ) );
  else
    hb_retptr( ( QPushButton* ) new QPushButton( hbqt_par_QWidget( 1 ) ) );
}

/*
 * bool autoDefault () const
 */
HB_FUNC( QT_QPUSHBUTTON_AUTODEFAULT )
{
   hb_retl( hbqt_par_QPushButton( 1 )->autoDefault(  ) );
}

/*
 * bool isDefault () const
 */
HB_FUNC( QT_QPUSHBUTTON_ISDEFAULT )
{
   hb_retl( hbqt_par_QPushButton( 1 )->isDefault(  ) );
}

/*
 * bool isFlat () const
 */
HB_FUNC( QT_QPUSHBUTTON_ISFLAT )
{
   hb_retl( hbqt_par_QPushButton( 1 )->isFlat(  ) );
}

/*
 * QMenu * menu () const
 */
HB_FUNC( QT_QPUSHBUTTON_MENU )
{
   hb_retptr( ( QMenu* ) hbqt_par_QPushButton( 1 )->menu(  ) );
}

/*
 * void setAutoDefault ( bool )
 */
HB_FUNC( QT_QPUSHBUTTON_SETAUTODEFAULT )
{
   hbqt_par_QPushButton( 1 )->setAutoDefault( hb_parl( 2 ) );
}

/*
 * void setDefault ( bool )
 */
HB_FUNC( QT_QPUSHBUTTON_SETDEFAULT )
{
   hbqt_par_QPushButton( 1 )->setDefault( hb_parl( 2 ) );
}

/*
 * void setFlat ( bool )
 */
HB_FUNC( QT_QPUSHBUTTON_SETFLAT )
{
   hbqt_par_QPushButton( 1 )->setFlat( hb_parl( 2 ) );
}

/*
 * void setMenu ( QMenu * menu )
 */
HB_FUNC( QT_QPUSHBUTTON_SETMENU )
{
   hbqt_par_QPushButton( 1 )->setMenu( hbqt_par_QMenu( 2 ) );
}


/*----------------------------------------------------------------------*/
#endif             /* #if QT_VERSION >= 0x040500 */
/*----------------------------------------------------------------------*/

