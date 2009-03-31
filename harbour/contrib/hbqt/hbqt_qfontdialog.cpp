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


/*
 *  Constructed[ 5/8 [ 62.50% ] ]
 *  
 *  *** Unconvered Prototypes ***
 *  -----------------------------
 *  
 *  QFont currentFont () const
 *  QFont selectedFont () const
 *  void setCurrentFont ( const QFont & font )
 */ 


#include <QtGui/QFontDialog>


/*
 * QFontDialog ( QWidget * parent = 0 )
 * QFontDialog ( const QFont & initial, QWidget * parent = 0 )
 */
HB_FUNC( QT_QFONTDIALOG )
{
   hb_retptr( ( QFontDialog * ) new QFontDialog( hbqt_par_QWidget( 1 ) ) );
}

/*
 * void open ( QObject * receiver, const char * member )
 */
HB_FUNC( QT_QFONTDIALOG_OPEN )
{
   hbqt_par_QFontDialog( 1 )->open( hbqt_par_QObject( 2 ), hbqt_par_char( 3 ) );
}

/*
 * FontDialogOptions options () const
 */
HB_FUNC( QT_QFONTDIALOG_OPTIONS )
{
   hb_retni( hbqt_par_QFontDialog( 1 )->options(  ) );
}

/*
 * void setOption ( FontDialogOption option, bool on = true )
 */
HB_FUNC( QT_QFONTDIALOG_SETOPTION )
{
   hbqt_par_QFontDialog( 1 )->setOption( ( QFontDialog::FontDialogOption ) hb_parni( 2 ), hb_parl( 3 ) );
}

/*
 * void setOptions ( FontDialogOptions options )
 */
HB_FUNC( QT_QFONTDIALOG_SETOPTIONS )
{
   hbqt_par_QFontDialog( 1 )->setOptions( ( QFontDialog::FontDialogOptions ) hb_parni( 2 ) );
}

/*
 * bool testOption ( FontDialogOption option ) const
 */
HB_FUNC( QT_QFONTDIALOG_TESTOPTION )
{
   hb_retl( hbqt_par_QFontDialog( 1 )->testOption( ( QFontDialog::FontDialogOption ) hb_parni( 2 ) ) );
}


/*----------------------------------------------------------------------*/
#endif             /* #if QT_VERSION >= 0x040500 */
/*----------------------------------------------------------------------*/

