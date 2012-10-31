/*
 * $Id$
 */

/*
 * Harbour Project source code:
 * OSLib emulation for Harbour
 *    http://www.davep.org/clipper/OSLib/
 *
 * Copyright 2011 Viktor Szakats (harbour syenar.net)
 * www - http://harbour-project.org
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

#include "hbgtinfo.ch"

FUNCTION OL_95AppTitle( cValue )
   RETURN hb_gtInfo( HB_GTI_WINTITLE, cValue )

FUNCTION OL_95VMTitle( cValue )
   RETURN hb_gtInfo( HB_GTI_WINTITLE, cValue )

FUNCTION OL_AutoYield()
   RETURN .T.

FUNCTION OL_IsMSWin()
   RETURN hb_osIsWinNT() .OR. hb_osIsWin9x()

FUNCTION OL_IsNT()
   RETURN hb_osIsWinNT()

FUNCTION OL_IsOS2()

#if defined( __PLATFORM__OS2 )
   RETURN .T.
#else

   RETURN .F. /* TODO: detect OS/2 in MS-DOS builds */
#endif

FUNCTION OL_IsOS2Win()
   RETURN hb_gtInfo( HB_GTI_ISFULLSCREEN )

FUNCTION OL_OsVerMaj()
   RETURN iif( hb_osIsWin9x(), 7, 5 )

FUNCTION OL_OsVerMin()
   RETURN iif( hb_osIsWin9x(), 1, 0 )

FUNCTION OL_WinCBCopy()
   RETURN hb_gtInfo( HB_GTI_CLIPBOARDDATA )

FUNCTION OL_WinCBPaste( cText )

   IF HB_ISSTRING( cText )
      hb_gtInfo( HB_GTI_CLIPBOARDDATA, cText )
      RETURN .T.
   ENDIF

   RETURN .F.

FUNCTION OL_WinFullScreen()
   RETURN hb_gtInfo( HB_GTI_ISFULLSCREEN, .T. )

FUNCTION OL_Yield()
   RETURN hb_ReleaseCPU()
