package kr.sejiwork.cordova.shareutil;

import java.io.PrintWriter;
import java.io.StringWriter;

import org.json.JSONArray;
import org.json.JSONException;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;

import android.content.Intent;

public class Shareutil extends CordovaPlugin {
	@Override
	public boolean execute(String action, JSONArray data, CallbackContext callbackContext) throws JSONException {
		if ("shareText".equals(action)) {
			String text = data.getString(0);
		} else if ("shareImg".equals(action)) {
			String base64 = data.getString(0);
			String mimeType = data.getString(1);
		} else {
			return false;
		}
	}

	private void share(String text, CallbackContext callbackContext) {
		try {
			Intent sendIntent = new Intent();
			sendIntent.setAction(Intent.ACTION_SEND);
			sendIntent.putExtra(Intent.EXTRA_TEXT, text);
			sendIntent.setType("plain/text");
			cordova.getActivity().startActivity(Intent.createChooser(sendIntent, text));
			callbackContext.success();
		} catch (Error e) {
			callbackContext.error(getPrintStackTrace(e));
		}
	}

	private void share(String base64, String mimeType, CallbackContext callbackContext) {
		try {
			Intent sendIntent = new Intent();
			sendIntent.setAction(Intent.ACTION_SEND);
			sendIntent.putExtra(Intent.EXTRA_STREAM, base64);
			sendIntent.setType(mimeType);
			cordova.getActivity().startActivity(Intent.createChooser(sendIntent, "Share Image"));
			callbackContext.success();
		} catch (Error e) {
			callbackContext.error(getPrintStackTrace(e));
		}
	}


  private static String getPrintStackTrace(Exception e) {
    StringWriter errors = new StringWriter();
    e.printStackTrace(new PrintWriter(errors));

    return errors.toString();
  }
}
