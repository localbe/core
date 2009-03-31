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


#include 'hbclass.ch'


CLASS QWebPage INHERIT QObject

   DATA    pPtr

   METHOD  New()

   METHOD  action( nWebAction )                INLINE  Qt_QWebPage_action( ::pPtr, nWebAction )
   METHOD  createStandardContextMenu()         INLINE  Qt_QWebPage_createStandardContextMenu( ::pPtr )
   METHOD  currentFrame()                      INLINE  Qt_QWebPage_currentFrame( ::pPtr )
   METHOD  findText( cSubString, nFindFlags )  INLINE  Qt_QWebPage_findText( ::pPtr, cSubString, nFindFlags )
   METHOD  focusNextPrevChild( lNext )         INLINE  Qt_QWebPage_focusNextPrevChild( ::pPtr, lNext )
   METHOD  forwardUnsupportedContent()         INLINE  Qt_QWebPage_forwardUnsupportedContent( ::pPtr )
   METHOD  history()                           INLINE  Qt_QWebPage_history( ::pPtr )
   METHOD  isContentEditable()                 INLINE  Qt_QWebPage_isContentEditable( ::pPtr )
   METHOD  isModified()                        INLINE  Qt_QWebPage_isModified( ::pPtr )
   METHOD  linkDelegationPolicy()              INLINE  Qt_QWebPage_linkDelegationPolicy( ::pPtr )
   METHOD  mainFrame()                         INLINE  Qt_QWebPage_mainFrame( ::pPtr )
   METHOD  networkAccessManager()              INLINE  Qt_QWebPage_networkAccessManager( ::pPtr )
   METHOD  pluginFactory()                     INLINE  Qt_QWebPage_pluginFactory( ::pPtr )
   METHOD  selectedText()                      INLINE  Qt_QWebPage_selectedText( ::pPtr )
   METHOD  setContentEditable( lEditable )     INLINE  Qt_QWebPage_setContentEditable( ::pPtr, lEditable )
   METHOD  setForwardUnsupportedContent( lForward )  INLINE  Qt_QWebPage_setForwardUnsupportedContent( ::pPtr, lForward )
   METHOD  setLinkDelegationPolicy( nLinkDelegationPolicy )  INLINE  Qt_QWebPage_setLinkDelegationPolicy( ::pPtr, nLinkDelegationPolicy )
   METHOD  setNetworkAccessManager( pManager )  INLINE  Qt_QWebPage_setNetworkAccessManager( ::pPtr, pManager )
   METHOD  setPluginFactory( pFactory )        INLINE  Qt_QWebPage_setPluginFactory( ::pPtr, pFactory )
   METHOD  setView( pView )                    INLINE  Qt_QWebPage_setView( ::pPtr, pView )
   METHOD  setViewportSize( aSizeSize )        INLINE  Qt_QWebPage_setViewportSize( ::pPtr, aSizeSize )
   METHOD  settings()                          INLINE  Qt_QWebPage_settings( ::pPtr )
   METHOD  supportsExtension( nExtension )     INLINE  Qt_QWebPage_supportsExtension( ::pPtr, nExtension )
   METHOD  swallowContextMenuEvent( pEvent )   INLINE  Qt_QWebPage_swallowContextMenuEvent( ::pPtr, pEvent )
   METHOD  triggerAction( nWebAction, lChecked )  INLINE  Qt_QWebPage_triggerAction( ::pPtr, nWebAction, lChecked )
   METHOD  undoStack()                         INLINE  Qt_QWebPage_undoStack( ::pPtr )
   METHOD  updatePositionDependentActions( aPointPos )  INLINE  Qt_QWebPage_updatePositionDependentActions( ::pPtr, aPointPos )
   METHOD  view()                              INLINE  Qt_QWebPage_view( ::pPtr )
   METHOD  viewportSize()                      INLINE  Qt_QWebPage_viewportSize( ::pPtr )

   ENDCLASS

/*----------------------------------------------------------------------*/

METHOD New( pParent ) CLASS QWebPage

   ::pPtr := Qt_QWebPage( pParent )

   RETURN Self

/*----------------------------------------------------------------------*/

