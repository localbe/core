/*
 * $Id$
   Harbour Project source code

   Copyright(C) 1999 by Jose Lalin.
   http://www.Harbour-Project.org/

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published
   by the Free Software Foundation; either version 2 of the License, or
   (at your option) any later version.

   The exception is that if you link the Harbour Runtime Library (HRL)
   and/or the Harbour Virtual Machine (HVM) with other files to produce
   an executable, this does not by itself cause the resulting executable
   to be covered by the GNU General Public License. Your use of that
   executable is in no way restricted on account of linking the HRL
   and/or HVM code into it.

   This program is distributed in the hope that it will be useful, but
   WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR
   PURPOSE.  See the GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA (or visit
   their web site at http://www.gnu.org/).

   You can contact me at: dezac@corevia.com
*/

#include <extend.h>
#include <init.h>
#include <ctype.h>

#define CHR_HARD1   (char)141
#define CHR_HARD2   (char)10

#define CHR_SOFT1   (char)13
#define CHR_SOFT2   (char)10

HARBOUR HB_MEMOTRAN(void);


HB_INIT_SYMBOLS_BEGIN( Memotran__InitSymbols )
{ "MEMOTRAN", FS_PUBLIC, HB_MEMOTRAN, 0 }
HB_INIT_SYMBOLS_END( Memotran__InitSymbols );
#if ! defined(__GNUC__)
#pragma startup Memotran__InitSymbols
#endif

char *hb_memotran( char *string, char *hardcr, char *softcr )
{
   char *s;

   if( string )
   {
      for( s = string; *s; ++s )
      {
         if( *s == CHR_HARD1 && *(s+1) == CHR_HARD2 )
            *s++ = *hardcr;
         if( *s == CHR_SOFT1 && *(s+1) == CHR_SOFT2 )
            *s++ = *softcr;
      }

      *s = '\0';
   }
   return string;
}

HARBOUR HB_MEMOTRAN( void )
{
   if( ISCHAR( 1 ) )
   {
      char *hardcr  = ISCHAR( 2 ) ? hb_parc( 2 ):";";
      char *softcr  = ISCHAR( 3 ) ? hb_parc( 3 ):" ";

      hb_retc( hb_memotran( hb_parc( 1 ), hardcr, softcr ) );
   }
   else
     hb_retc( "" );
}
