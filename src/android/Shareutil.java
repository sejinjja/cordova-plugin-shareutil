package kr.sejiwork.cordova.shareutil;

import java.util.Locale;
import java.util.ArrayList;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;

import org.json.JSONArray;
import org.json.JSONException;

import org.apache.cordova.BuildHelper;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;

import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Build;
import android.os.Environment;
import android.support.v4.content.FileProvider;
import android.util.Log;


public class Shareutil extends CordovaPlugin {
  private String applicationId;
  private String curLang;



	@Override
	public boolean execute(String action, JSONArray data, CallbackContext callbackContext) throws JSONException {
        this.applicationId = (String) BuildHelper.getBuildConfigValue(cordova.getActivity(), "APPLICATION_ID");
        this.applicationId = preferences.getString("applicationId", this.applicationId);
        this.curLang = Locale.getDefault().getLanguage();
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
			Intent shareIntent = new Intent();
			shareIntent.setAction(Intent.ACTION_SEND);
			shareIntent.putExtra(Intent.EXTRA_TEXT, text);
			shareIntent.setType("text/plain");
			cordova.getActivity().startActivity(Intent.createChooser(shareIntent, text));
			callbackContext.success();
		} catch (Exception e) {
			callbackContext.error(getPrintStackTrace(e));
		}
	}

	private void share(String base64, String mimeType, CallbackContext callbackContext) {
		try {
			Intent shareIntent = new Intent();
		    ArrayList<Uri> imageUris = new ArrayList<Uri>();
            File decodedBase64File = this.saveImage(cordova.getActivity().getApplicationContext(), base64);
            shareIntent.setAction(Intent.ACTION_SEND_MULTIPLE);

			Uri contentUri = FileProvider.getUriForFile(cordova.getActivity(), applicationId + ".provider", decodedBase64File);
            imageUris.add(this.getCorrectUri(contentUri));
            shareIntent.putParcelableArrayListExtra(Intent.EXTRA_STREAM, imageUris);
			shareIntent.setType(mimeType);

			cordova.getActivity().startActivity(Intent.createChooser(shareIntent, null));
			callbackContext.success();
		} catch (Exception e) {
			callbackContext.error(getPrintStackTrace(e));
		}
	}

	private File saveImage(final Context context, final String imageData) throws IOException {
      final byte[] imgBytesData = android.util.Base64.decode(imageData, android.util.Base64.DEFAULT);

      final File file = File.createTempFile("shareImg", null, new File(this.getTempDirectoryPath()));
      final FileOutputStream fileOutputStream = new FileOutputStream(file);

      final BufferedOutputStream bufferedOutputStream = new BufferedOutputStream(fileOutputStream);
      boolean isSuccess = true;
      try {
        bufferedOutputStream.write(imgBytesData);
      } catch (IOException e) {
        this.getPrintStackTrace(e);
        isSuccess = false;
      }
      bufferedOutputStream.close();
      if(!isSuccess) {
        throw new IOException();
      }
      return file;
  }

	private static String getPrintStackTrace(Exception e) {
		StringWriter errors = new StringWriter();
		e.printStackTrace(new PrintWriter(errors));
		Log.e("cordova-plugin-shareutil", errors.toString());

		return errors.toString();
	}

  private String getTempDirectoryPath() {
      File cache = null;

      if (Environment.getExternalStorageState().equals(Environment.MEDIA_MOUNTED)) {
          cache = cordova.getActivity().getExternalCacheDir();
      } else {
          cache = cordova.getActivity().getCacheDir();
      }
      cache.mkdirs();
      return cache.getAbsolutePath();
  }

  private Uri getCorrectUri(Uri uri) {
    if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
        return uri;
    }
    return Uri.parse("file://" + this.getFileNameFromUri(uri));
  }

  private String getFileNameFromUri(Uri uri) {
    String fullUri = uri.toString();
    String partial_path = fullUri.split("external_files")[1];
    File external_storage = Environment.getExternalStorageDirectory();
    String path = external_storage.getAbsolutePath() + partial_path;
    return path;
  }

}
