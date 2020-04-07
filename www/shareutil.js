module.exports = {
  rect: null,
  shareText( text ) {
    return new Promise( ( resolve, reject ) => {
      cordova.exec( resolve, reject, 'Shareutil', 'shareText', [text] )
    } )
  },
  shareImg( base64, mimeType ) {
    return new Promise( ( resolve, reject ) => {
      cordova.exec( resolve, reject, 'Shareutil', 'shareImg', [base64, mimeType] )
    } )
  },
  rememberRect() {
    return new Promise( ( resolve, reject ) => {
      cordova.exec( resolve, reject, 'Shareutil', 'rememberRect' )
    } ).then( res => {
      this.rect = res
      return res
    } )
  },
  resetRect() {
    if( this.rect ) {
      const {frameSizeHeight, frameSizeWidth, frameOriginX, frameOriginY, boundSizeHeight, boundSizeWidth, boundOriginX, boundOriginY} = this.rect
      cordova.exec( resolve, reject, 'Shareutil', 'resetRect', [frameSizeHeight, frameSizeWidth, frameOriginX, frameOriginY, boundSizeHeight, boundSizeWidth, boundOriginX, boundOriginY] )
    } else {
      return Promise.reject( 'rect is not found' )
    }
  }
}
