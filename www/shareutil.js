module.exports = {
    shareText(text) {
        return new Promise((resolve, reject) => {
            cordova.exec(resolve, reject, "Shareutil", "shareText", [text])
        })
    },
    shareImg(base64, mimeType) {
        return new Promise((resolve, reject) => {
            cordova.exec(resolve, reject, "Shareutil", "shareImg", [base64, mimeType])
        })
    }
}
