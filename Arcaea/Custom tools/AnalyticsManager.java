import android.content.Context;
import android.os.Bundle;
import com.google.firebase.analytics.FirebaseAnalytics;
import low.moe.AnalyticsManager;
import org.cocos2dx.lib.Cocos2dxActivity;

public class AnalyticsManager {
  private static AnalyticsManager instance;
  
  private FirebaseAnalytics firebaseAnalytics;
  
  public AnalyticsManager() {
    instance = this;
    Context context = Cocos2dxActivity.getContext();
    instance.firebaseAnalytics = FirebaseAnalytics.getInstance(context);
    instance.firebaseAnalytics.setAnalyticsCollectionEnabled(true);
  }
  
  public static void logEvent(String paramString) {
    Bundle bundle = new Bundle();
    instance.firebaseAnalytics.logEvent(paramString, bundle);
  }
  
  public static void logEvent(String paramString1, String paramString2, String paramString3) {
    Bundle bundle = new Bundle();
    bundle.putString(paramString2, paramString3);
    instance.firebaseAnalytics.logEvent(paramString1, bundle);
  }
  
  public static void logEvent(String paramString1, String paramString2, String paramString3, String paramString4, String paramString5) {
    Bundle bundle = new Bundle();
    bundle.putString(paramString2, paramString3);
    bundle.putString(paramString4, paramString5);
    instance.firebaseAnalytics.logEvent(paramString1, bundle);
  }
  
  public static void setUserId(String paramString) {
    instance.firebaseAnalytics.setUserId(paramString);
  }
  
  public static void trackABTestPerformed(String paramString) {
    logEvent("abtest_performed", "testid", paramString);
  }
  
  public static void trackABTestTarget(String paramString) {
    logEvent("abtest_selected", "testid", paramString);
  }
  
  public static void trackLogin() {
    logEvent("login", "method", "email");
  }
  
  public static void trackMemoryPurchase(int paramInt) {
    logEvent("purchase_complete", "value", String.valueOf(paramInt));
  }
  
  public static void trackPackPurchase(String paramString) {
    logEvent("track_packpurchase", "packid", paramString, "virtual_currency_name", "memory");
  }
  
  public static void trackRegister() {
    logEvent("sign_up", "method", "email");
  }
  
  public static void trackSinglePurchase(String paramString) {
    logEvent("track_singlepurchase", "songid", paramString, "virtual_currency_name", "memory");
  }
  
  public static void trackSongComplete(String paramString1, String paramString2) {
    logEvent("play_finish", "songid_difficulty", paramString1, "cleartype", paramString2);
  }
  
  public static void trackSongStart(String paramString) {
    logEvent("play_start", "songid_difficulty", paramString);
  }
  
  public static void trackStaminaConvert() {
    logEvent("staminaconvert", "count", "6");
  }
  
  public static void trackStaminaPurchase() {
    logEvent("itempurchase", "itemid", "stamina_6", "virtual_currency_name", "memory");
  }
  
  public static void trackTutorialComplete() {
    logEvent("tutorial_complete");
  }
  
  public static void trackTutorialStart() {
    logEvent("tutorial_begin");
  }
  
  public static void trackUnlock(String paramString) {
    logEvent("track_unlock", "songid_difficulty", paramString);
  }
}


/* Location:              C:\Users\stary\Desktop\!\AnalyticsManager.class
 * Java compiler version: 6 (50.0)
 * JD-Core Version:       1.1.3
 */