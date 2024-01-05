//
//  AppodealPlugin.h
//
//  Created by Dmitrii Feshchenko on 26/11/2022.
//

#ifndef APPODEAL_PLUGIN_H
#define APPODEAL_PLUGIN_H

#import "core/version.h"

#if VERSION_MAJOR == 4
#import "core/object/class_db.h"
#else
#import "core/object.h"
#endif

#ifdef __OBJC__

#if VERSION_MAJOR == 4
#import "platform/ios/app_delegate.h"
#import "platform/ios/view_controller.h"
typedef PackedStringArray GodotStringArray;
#else
#import "platform/iphone/app_delegate.h"
#import "platform/iphone/view_controller.h"
typedef PoolStringArray GodotStringArray;
#endif

#import <Foundation/Foundation.h>
#import <Appodeal/Appodeal.h>

typedef NSString GodotNSString;
typedef NSDictionary GodotNSDictionary;
typedef AppodealAdType GodotAppodealAdType;
typedef AppodealShowStyle GodotAppodealShowStyle;
typedef ViewController GodotViewController;

#else

typedef void GodotStringArray;
typedef void GodotNSString;
typedef void GodotNSDictionary;
typedef void GodotAppodealAdType;
typedef void GodotAppodealShowStyle;
typedef void GodotViewController;

#endif

class AppodealPlugin : public Object {
    GDCLASS(AppodealPlugin, Object);

    static AppodealPlugin *instance;

protected:
    static void _bind_methods();

public:
    static AppodealPlugin *get_singleton();

    void initialize(const String &appKey, int adTypes);
    bool isInitialized(int adType);
    void updateGDPRUserConsent(int consent);
    void updateCCPAUserConsent(int consent);
    bool isAutoCacheEnabled(int adType);
    void cache(int adTypes);
    bool show(int showStyle);
    bool showForPlacement(int showStyle, const String &placement);
    bool showBannerView(int xAxis, int yAxis, const String &placement);
    bool showMrecView(int xAxis, int yAxis, const String &placement);
    void hideBanner();
    void hideBannerView();
    void hideMrecView();
    void setAutoCache(int adTypes, bool autoCache);
    bool isLoaded(int adTypes);
    bool isPrecache(int adType);
    void setSmartBanners(bool enabled);
    bool isSmartBannersEnabled();
    void set728x90Banners(bool enabled);
    void setBannerAnimation(bool animate);
    void setBannerRotation(int left, int right);
    void setUseSafeArea(bool useSafeArea);
    void trackInAppPurchase(float amount, const String &currency);
    GodotStringArray getNetworks(int adType);
    void disableNetwork(const String &network);
    void disableNetworkForAdTypes(const String &network, int adTypes);
    void setUserId(const String &userId);
    String getUserId();
    String getVersion();
    String getPluginVersion();
    int getSegmentId();
    void setTesting(bool testMode);
    void setLogLevel(int logLevel);
    void setFramework(const String &pluginVersion, const String &engineVersion);
    void setCustomFilterBool(const String &name, bool value);
    void setCustomFilterInt(const String &name, int value);
    void setCustomFilterFloat(const String &name, float value);
    void setCustomFilterString(const String &name, const String &value);
    void resetCustomFilter(const String &name);
    bool canShow(int adType);
    bool canShowForPlacement(int adType, const String &placement);
    float getRewardAmount(const String &placementName);
    String getRewardCurrency(const String &placementName);
    void muteVideosIfCallsMuted(bool isMuted);
    void startTestActivity();
    void setChildDirectedTreatment(bool value);
    void destroy(int adTypes);
    void setExtraDataBool(const String &key, bool value);
    void setExtraDataInt(const String &key, int value);
    void setExtraDataFloat(const String &key, float value);
    void setExtraDataString(const String &key, const String &value);
    void resetExtraData(const String &key);
    float getPredictedEcpm(int adType);
    void logEvent(const String &eventName, Dictionary params);
    void validatePlayStoreInAppPurchase(Dictionary payload);
    void validateAppStoreInAppPurchase(Dictionary payload);

    AppodealPlugin();
    ~AppodealPlugin();

private:
    GodotViewController* _getRootViewController();
    GodotNSString* _convertFromString(const String &str);
    GodotNSDictionary* _convertFromDictionary(Dictionary godotDict);
    GodotAppodealAdType _getNativeAdTypes(int adTypes);
    GodotAppodealAdType _getNativeAdType(int adType);
    GodotAppodealShowStyle _getNativeShowStyle(int showStyle);
    GodotAppodealShowStyle _getNativeStyleForIsReady(int adTypes);
    void _setCallbacks();

};

#endif /* APPODEAL_PLUGIN_H */
