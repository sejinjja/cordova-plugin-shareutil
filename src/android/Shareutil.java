package kr.sejiwork.cordova.shareutil;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.FileNotFoundException;
import java.io.PrintWriter;
import java.io.StringWriter;

import org.json.JSONArray;
import org.json.JSONException;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;

import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.util.Log;

public class Shareutil extends CordovaPlugin {
	@Override
	public boolean execute(String action, JSONArray data, CallbackContext callbackContext) throws JSONException {
		if ("shareText".equals(action)) {
			String text = data.getString(0);
			this.share(text, callbackContext);
			return true;
		} else if ("shareImg".equals(action)) {
			String base64 = data.getString(0);
			String mimeType = data.getString(1);
			this.share(base64, mimeType, callbackContext);
			return true;
		}
		return false;
	}

	private void share(String text, CallbackContext callbackContext) {
		try {
			Intent sendIntent = new Intent();
			sendIntent.setAction(Intent.ACTION_SEND);
			sendIntent.putExtra(Intent.EXTRA_TEXT, text);
			sendIntent.setType("text/plain");
			cordova.getActivity().startActivity(Intent.createChooser(sendIntent, text));
			callbackContext.success();
		} catch (Exception e) {
			callbackContext.error(getPrintStackTrace(e));
		}
	}

	private void share(String base64, String mimeType, CallbackContext callbackContext) {
		try {
		  File decodedBase64File = this.saveImage(cordova.getActivity().getApplicationContext(), base64);
			Intent sendIntent = new Intent();
			sendIntent.setAction(Intent.ACTION_SEND);
			sendIntent.putExtra(Intent.EXTRA_STREAM, Uri.fromFile(decodedBase64File));
			sendIntent.setType(mimeType);
			cordova.getActivity().startActivity(Intent.createChooser(sendIntent, "Share Image"));
			callbackContext.success();
		} catch (Exception e) {
			callbackContext.error(getPrintStackTrace(e));
		}
	}

	private static File saveImage(final Context context, final String imageData) {
      final byte[] imgBytesData = android.util.Base64.decode(imageData, android.util.Base64.DEFAULT);

      final File file = File.createTempFile("tempImageForShare", null, context.getCacheDir());
      final FileOutputStream fileOutputStream;
      try {
          fileOutputStream = new FileOutputStream(file);
      } catch (FileNotFoundException e) {
          e.printStackTrace();
          return null;
      }

      final BufferedOutputStream bufferedOutputStream = new BufferedOutputStream(fileOutputStream);
      try {
          bufferedOutputStream.write(imgBytesData);
      } catch (IOException e) {
          e.printStackTrace();
          return null;
      } finally {
          try {
              bufferedOutputStream.close();
          } catch (IOException e) {
              e.printStackTrace();
          }
      }
      return file;
  }

	private static String getPrintStackTrace(Exception e) {
		StringWriter errors = new StringWriter();
		e.printStackTrace(new PrintWriter(errors));
		Log.e("cordova-plugin-shareutil", errors.toString());

		return errors.toString();
	}
}
