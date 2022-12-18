//
//  AppodealPlugin.mm
//
//  Created by Dmitrii Feshchenko on 26/11/2022.
//

#import "AppodealPlugin.h"

#import "AppodealMrecViewGodot.h"
#import "AppodealBannerViewGodot.h"

#import "AppodealAdRevenueDelegateGodot.h"
#import "AppodealInitializationDelegateGodot.h"

#import "AppodealBannerDelegateGodot.h"
#import "AppodealMrecViewDelegateGodot.h"
#import "AppodealBannerViewDelegateGodot.h"
#import "AppodealInterstitialDelegateGodot.h"
#import "AppodealRewardedVideoDelegateGodot.h"

AppodealPlugin *AppodealPlugin::instance = NULL;

AppodealMrecViewGodot *mrecView = nil;
AppodealBannerViewGodot *bannerView = nil;

AppodealAdRevenueDelegateGodot *adRevenueDelegate = nil;
AppodealInitializationDelegateGodot *initializationDelegate = nil;

AppodealBannerDelegateGodot *bannerDelegate = nil;
AppodealMrecViewDelegateGodot *mrecViewDelegate = nil;
AppodealBannerViewDelegateGodot *bannerViewDelegate = nil;
AppodealInterstitialDelegateGodot *interstitialDelegate = nil;
AppodealRewardedVideoDelegateGodot *rewardedVideoDelegate = nil;

AppodealPlugin::AppodealPlugin() {
    ERR_FAIL_COND(instance != NULL);
    instance = this;

    bannerView = [AppodealBannerViewGodot sharedInstance];
    mrecView = [AppodealMrecViewGodot sharedInstance];

    adRevenueDelegate = [[AppodealAdRevenueDelegateGodot alloc] init];
    initializationDelegate = [[AppodealInitializationDelegateGodot alloc] init];

    bannerDelegate = [[AppodealBannerDelegateGodot alloc] init];
    mrecViewDelegate = [[AppodealMrecViewDelegateGodot alloc] init];
    bannerViewDelegate =  [[AppodealBannerViewDelegateGodot alloc] init];
    interstitialDelegate = [[AppodealInterstitialDelegateGodot alloc] init];
    rewardedVideoDelegate = [[AppodealRewardedVideoDelegateGodot alloc] init];
}

AppodealPlugin::~AppodealPlugin() {
    if (mrecView) {
        mrecView = nil;
    }
    if (bannerView) {
        bannerView = nil;
    }
    if (adRevenueDelegate) {
        adRevenueDelegate = nil;
    }
    if (initializationDelegate) {
        initializationDelegate = nil;
    }
    if (bannerDelegate) {
        bannerDelegate = nil;
    }
    if (mrecViewDelegate) {
        mrecViewDelegate = nil;
    }
    if (bannerViewDelegate) {
        bannerViewDelegate = nil;
    }
    if (interstitialDelegate) {
        interstitialDelegate = nil;
    }
    if (rewardedVideoDelegate) {
        rewardedVideoDelegate = nil;
    }

    instance = NULL;
}

AppodealPlugin *AppodealPlugin::get_singleton() {
    return instance;
}

void AppodealPlugin::_bind_methods() {
    ADD_SIGNAL(MethodInfo("on_ad_revenue_received", PropertyInfo(Variant::DICTIONARY, "params")));
    ADD_SIGNAL(MethodInfo("on_initialization_finished", PropertyInfo(Variant::STRING, "errors")));

    ADD_SIGNAL(MethodInfo("on_inapp_purchase_validate_success", PropertyInfo(Variant::STRING, "json")));
    ADD_SIGNAL(MethodInfo("on_inapp_purchase_validate_fail", PropertyInfo(Variant::STRING, "reason")));

    ADD_SIGNAL(MethodInfo("on_mrec_loaded", PropertyInfo(Variant::BOOL, "is_precache")));
    ADD_SIGNAL(MethodInfo("on_mrec_failed_to_load"));
    ADD_SIGNAL(MethodInfo("on_mrec_shown"));
    ADD_SIGNAL(MethodInfo("on_mrec_show_failed"));
    ADD_SIGNAL(MethodInfo("on_mrec_clicked"));
    ADD_SIGNAL(MethodInfo("on_mrec_expired"));

    ADD_SIGNAL(MethodInfo("on_banner_loaded", PropertyInfo(Variant::INT, "height"), PropertyInfo(Variant::BOOL, "is_precache")));
    ADD_SIGNAL(MethodInfo("on_banner_failed_to_load"));
    ADD_SIGNAL(MethodInfo("on_banner_shown"));
    ADD_SIGNAL(MethodInfo("on_banner_show_failed"));
    ADD_SIGNAL(MethodInfo("on_banner_clicked"));
    ADD_SIGNAL(MethodInfo("on_banner_expired"));

    ADD_SIGNAL(MethodInfo("on_interstitial_loaded", PropertyInfo(Variant::BOOL, "is_precache")));
    ADD_SIGNAL(MethodInfo("on_interstitial_failed_to_load"));
    ADD_SIGNAL(MethodInfo("on_interstitial_shown"));
    ADD_SIGNAL(MethodInfo("on_interstitial_show_failed"));
    ADD_SIGNAL(MethodInfo("on_interstitial_clicked"));
    ADD_SIGNAL(MethodInfo("on_interstitial_closed"));
    ADD_SIGNAL(MethodInfo("on_interstitial_expired"));

    ADD_SIGNAL(MethodInfo("on_rewarded_video_loaded", PropertyInfo(Variant::BOOL, "is_precache")));
    ADD_SIGNAL(MethodInfo("on_rewarded_video_failed_to_load"));
    ADD_SIGNAL(MethodInfo("on_rewarded_video_shown"));
    ADD_SIGNAL(MethodInfo("on_rewarded_video_show_failed"));
    ADD_SIGNAL(MethodInfo("on_rewarded_video_clicked"));
    ADD_SIGNAL(MethodInfo("on_rewarded_video_finished", PropertyInfo(Variant::STRING, "amount"), PropertyInfo(Variant::STRING, "name")));
    ADD_SIGNAL(MethodInfo("on_rewarded_video_closed", PropertyInfo(Variant::BOOL, "finished")));
    ADD_SIGNAL(MethodInfo("on_rewarded_video_expired"));

    ClassDB::bind_method(D_METHOD("initialize", "app_key", "ad_types"), &AppodealPlugin::initialize);
    ClassDB::bind_method(D_METHOD("isInitialized", "ad_type"), &AppodealPlugin::isInitialized);
    ClassDB::bind_method(D_METHOD("updateGDPRUserConsent", "consent"), &AppodealPlugin::updateGDPRUserConsent);
    ClassDB::bind_method(D_METHOD("updateCCPAUserConsent", "consent"), &AppodealPlugin::updateCCPAUserConsent);
    ClassDB::bind_method(D_METHOD("isAutoCacheEnabled", "ad_type"), &AppodealPlugin::isAutoCacheEnabled);
    ClassDB::bind_method(D_METHOD("cache", "ad_types"), &AppodealPlugin::cache);
    ClassDB::bind_method(D_METHOD("show", "show_style"), &AppodealPlugin::show);
    ClassDB::bind_method(D_METHOD("showForPlacement", "show_style", "placement"), &AppodealPlugin::showForPlacement);
    ClassDB::bind_method(D_METHOD("showBannerView", "x_axis", "y_axis", "placement"), &AppodealPlugin::showBannerView);
    ClassDB::bind_method(D_METHOD("showMrecView", "x_axis", "y_axis", "placement"), &AppodealPlugin::showMrecView);
    ClassDB::bind_method(D_METHOD("hideBanner"), &AppodealPlugin::hideBanner);
    ClassDB::bind_method(D_METHOD("hideBannerView"), &AppodealPlugin::hideBannerView);
    ClassDB::bind_method(D_METHOD("hideMrecView"), &AppodealPlugin::hideMrecView);
    ClassDB::bind_method(D_METHOD("setAutoCache", "ad_types", "auto_cache"), &AppodealPlugin::setAutoCache);
    ClassDB::bind_method(D_METHOD("isLoaded", "ad_types"), &AppodealPlugin::isLoaded);
    ClassDB::bind_method(D_METHOD("isPrecache", "ad_type"), &AppodealPlugin::isPrecache);
    ClassDB::bind_method(D_METHOD("setSmartBanners", "enabled"), &AppodealPlugin::setSmartBanners);
    ClassDB::bind_method(D_METHOD("isSmartBannersEnabled"), &AppodealPlugin::isSmartBannersEnabled);
    ClassDB::bind_method(D_METHOD("set728x90Banners", "enabled"), &AppodealPlugin::set728x90Banners);
    ClassDB::bind_method(D_METHOD("setBannerAnimation", "animate"), &AppodealPlugin::setBannerAnimation);
    ClassDB::bind_method(D_METHOD("setBannerRotation", "left_bannner_rotation", "right_bannner_rotation"), &AppodealPlugin::setBannerRotation);
    ClassDB::bind_method(D_METHOD("setUseSafeArea", "use_safe_area"), &AppodealPlugin::setUseSafeArea);
    ClassDB::bind_method(D_METHOD("trackInAppPurchase", "amount", "currency"), &AppodealPlugin::trackInAppPurchase);
    ClassDB::bind_method(D_METHOD("getNetworks", "ad_type"), &AppodealPlugin::getNetworks);
    ClassDB::bind_method(D_METHOD("disableNetwork", "network"), &AppodealPlugin::disableNetwork);
    ClassDB::bind_method(D_METHOD("disableNetworkForAdTypes", "network", "ad_types"), &AppodealPlugin::disableNetworkForAdTypes);
    ClassDB::bind_method(D_METHOD("setUserId", "user_id"), &AppodealPlugin::setUserId);
    ClassDB::bind_method(D_METHOD("getUserId"), &AppodealPlugin::getUserId);
    ClassDB::bind_method(D_METHOD("getVersion"), &AppodealPlugin::getVersion);
    ClassDB::bind_method(D_METHOD("getPluginVersion"), &AppodealPlugin::getPluginVersion);
    ClassDB::bind_method(D_METHOD("getSegmentId"), &AppodealPlugin::getSegmentId);
    ClassDB::bind_method(D_METHOD("setTesting", "test_mode"), &AppodealPlugin::setTesting);
    ClassDB::bind_method(D_METHOD("setLogLevel", "log_level"), &AppodealPlugin::setLogLevel);
    ClassDB::bind_method(D_METHOD("setFramework", "plugin_version", "engine_version"), &AppodealPlugin::setFramework);
    ClassDB::bind_method(D_METHOD("setCustomFilterBool", "name", "value"), &AppodealPlugin::setCustomFilterBool);
    ClassDB::bind_method(D_METHOD("setCustomFilterInt", "name", "value"), &AppodealPlugin::setCustomFilterInt);
    ClassDB::bind_method(D_METHOD("setCustomFilterFloat", "name", "value"), &AppodealPlugin::setCustomFilterFloat);
    ClassDB::bind_method(D_METHOD("setCustomFilterString", "name", "value"), &AppodealPlugin::setCustomFilterString);
    ClassDB::bind_method(D_METHOD("resetCustomFilter", "name"), &AppodealPlugin::resetCustomFilter);
    ClassDB::bind_method(D_METHOD("canShow", "ad_type"), &AppodealPlugin::canShow);
    ClassDB::bind_method(D_METHOD("canShowForPlacement", "ad_type", "placement"), &AppodealPlugin::canShowForPlacement);
    ClassDB::bind_method(D_METHOD("getRewardAmount", "placement_name"), &AppodealPlugin::getRewardAmount);
    ClassDB::bind_method(D_METHOD("getRewardCurrency", "placement_name"), &AppodealPlugin::getRewardCurrency);
    ClassDB::bind_method(D_METHOD("muteVideosIfCallsMuted", "is_muted"), &AppodealPlugin::muteVideosIfCallsMuted);
    ClassDB::bind_method(D_METHOD("disableWebViewCacheClear"), &AppodealPlugin::disableWebViewCacheClear);
    ClassDB::bind_method(D_METHOD("startTestActivity"), &AppodealPlugin::startTestActivity);
    ClassDB::bind_method(D_METHOD("setChildDirectedTreatment", "value"), &AppodealPlugin::setChildDirectedTreatment);
    ClassDB::bind_method(D_METHOD("destroy", "ad_types"), &AppodealPlugin::destroy);
    ClassDB::bind_method(D_METHOD("setExtraDataBool", "key", "value"), &AppodealPlugin::setExtraDataBool);
    ClassDB::bind_method(D_METHOD("setExtraDataInt", "key", "value"), &AppodealPlugin::setExtraDataInt);
    ClassDB::bind_method(D_METHOD("setExtraDataFloat", "key", "value"), &AppodealPlugin::setExtraDataFloat);
    ClassDB::bind_method(D_METHOD("setExtraDataString", "key", "value"), &AppodealPlugin::setExtraDataString);
    ClassDB::bind_method(D_METHOD("resetExtraData", "key"), &AppodealPlugin::resetExtraData);
    ClassDB::bind_method(D_METHOD("getPredictedEcpm", "ad_type"), &AppodealPlugin::getPredictedEcpm);
    ClassDB::bind_method(D_METHOD("logEvent", "event_name", "params"), &AppodealPlugin::logEvent);
    ClassDB::bind_method(D_METHOD("validatePlayStoreInAppPurchase", "payload"), &AppodealPlugin::validatePlayStoreInAppPurchase);
    ClassDB::bind_method(D_METHOD("validateAppStoreInAppPurchase", "payload"), &AppodealPlugin::validateAppStoreInAppPurchase);
}

void AppodealPlugin::initialize(const String &appKey, int adTypes) {
    _setCallbacks();
    [Appodeal initializeWithApiKey:_convertFromString(appKey) types:_getNativeAdTypes(adTypes)];
}

bool AppodealPlugin::isInitialized(int adType) {
    return [Appodeal isInitializedForAdType:_getNativeAdType(adType)];
}

void AppodealPlugin::updateGDPRUserConsent(int consent) {
    switch (consent) {
        case 0:
            [Appodeal updateUserConsentGDPR:APDGDPRUserConsentPersonalized];
            break;
        case 1:
            [Appodeal updateUserConsentGDPR:APDGDPRUserConsentNonPersonalized];
            break;
        case 2:
        default:
            [Appodeal updateUserConsentGDPR:APDGDPRUserConsentUnknown];
    }
}

void AppodealPlugin::updateCCPAUserConsent(int consent) {
    switch (consent) {
        case 0:
            [Appodeal updateUserConsentCCPA:APDCCPAUserConsentOptIn];
            break;
        case 1:
            [Appodeal updateUserConsentCCPA:APDCCPAUserConsentOptOut];
            break;
        case 2:
        default:
            [Appodeal updateUserConsentCCPA:APDCCPAUserConsentUnknown];
    }
}

bool AppodealPlugin::isAutoCacheEnabled(int adType) {
    return [Appodeal isAutocacheEnabled:_getNativeAdType(adType)];
}

void AppodealPlugin::cache(int adTypes) {
    [Appodeal cacheAd:_getNativeAdType(adTypes)];
}

bool AppodealPlugin::show(int showStyle) {
    return [Appodeal showAd:_getNativeShowStyle(showStyle) rootViewController:_getRootViewController()];
}

bool AppodealPlugin::showForPlacement(int showStyle, const String &placement) {
    return [Appodeal showAd:_getNativeShowStyle(showStyle) forPlacement: _convertFromString(placement) rootViewController: _getRootViewController()];
}

bool AppodealPlugin::showBannerView(int xAxis, int yAxis, const String &placement) {
    return [bannerView showBannerView:xAxis yAxis:yAxis placement:_convertFromString(placement)];
}

bool AppodealPlugin::showMrecView(int xAxis, int yAxis, const String &placement) {
    return [mrecView showMrecView:xAxis yAxis:yAxis placement:_convertFromString(placement)];
}

void AppodealPlugin::hideBanner() {
    [Appodeal hideBanner];
}

void AppodealPlugin::hideBannerView() {
    [bannerView hideBannerView];
}

void AppodealPlugin::hideMrecView() {
    [mrecView hideMrecView];
}

void AppodealPlugin::setAutoCache(int adTypes, bool autoCache) {
    [Appodeal setAutocache:autoCache types:_getNativeAdTypes(adTypes)];
}

bool AppodealPlugin::isLoaded(int adTypes) {
    return [Appodeal isReadyForShowWithStyle:_getNativeStyleForIsReady(adTypes)];
}

bool AppodealPlugin::isPrecache(int adType) {
    return [Appodeal isPrecacheAd:_getNativeAdType(adType)];
}

void AppodealPlugin::setSmartBanners(bool enabled) {
    [Appodeal setSmartBannersEnabled:enabled];
}

bool AppodealPlugin::isSmartBannersEnabled() {
    return [Appodeal isSmartBannersEnabled];
}

void AppodealPlugin::set728x90Banners(bool enabled) {
    if (enabled) {
        [Appodeal setPreferredBannerAdSize:kAppodealUnitSize_728x90];
    } else {
        [Appodeal setPreferredBannerAdSize:kAppodealUnitSize_320x50];
    }

    [bannerView setTabletBanners:enabled];
}

void AppodealPlugin::setBannerAnimation(bool animate) {
    [Appodeal setBannerAnimationEnabled:animate];
}

void AppodealPlugin::setBannerRotation(int left, int right) {
    [Appodeal setBannerLeftRotationAngleDegrees:left rightRotationAngleDegrees:right];
}

void AppodealPlugin::setUseSafeArea(bool useSafeArea) {
    NSLog(@"setUseSafeArea method is not supported on iOS platform");
}

void AppodealPlugin::trackInAppPurchase(float amount, const String &currency) {
    [Appodeal trackInAppPurchase:[NSNumber numberWithFloat:amount] currency:_convertFromString(currency)];
}

GodotStringArray AppodealPlugin::getNetworks(int adType) {
    NSArray<NSString *> *networksArray = [Appodeal registeredNetworkNamesForAdType:_getNativeAdType(adType)];
    GodotStringArray networks;
    for (NSString* el in networksArray) {
        networks.push_back(String::utf8([el UTF8String]));
    }
    return networks;
}

void AppodealPlugin::disableNetwork(const String &network) {
    [Appodeal disableNetwork:_convertFromString(network)];
}

void AppodealPlugin::disableNetworkForAdTypes(const String &network, int adTypes) {
    [Appodeal disableNetworkForAdType:_getNativeAdTypes(adTypes) name:_convertFromString(network)];
}

void AppodealPlugin::setUserId(const String &userId) {
    [Appodeal setUserId:_convertFromString(userId)];
}

String AppodealPlugin::getUserId() {
    return String::utf8([[Appodeal userId] UTF8String]);
}

String AppodealPlugin::getVersion() {
    return String::utf8([[Appodeal getVersion] UTF8String]);
}

String AppodealPlugin::getPluginVersion() {
    return String::utf8([[Appodeal pluginVersion] UTF8String]);
}

int AppodealPlugin::getSegmentId() {
    return [[Appodeal segmentId] intValue];
}

void AppodealPlugin::setTesting(bool testMode) {
    [Appodeal setTestingEnabled:testMode];
}

void AppodealPlugin::setLogLevel(int logLevel) {
    switch (logLevel) {
        case 0:
            [Appodeal setLogLevel:APDLogLevelVerbose];
            break;
        case 1:
            [Appodeal setLogLevel:APDLogLevelDebug];
            break;
        case 2:
        default:
            [Appodeal setLogLevel:APDLogLevelOff];
    }
}

void AppodealPlugin::setFramework(const String &pluginVersion, const String &engineVersion) {
    // [Appodeal setFramework:APDFrameworkGodot version:_convertFromString(engineVersion)];
    [Appodeal setPluginVersion:_convertFromString(pluginVersion)];
}

void AppodealPlugin::setCustomFilterBool(const String &name, bool value) {
    [Appodeal setCustomStateValue:[NSNumber numberWithBool:value] forKey:_convertFromString(name)];
}

void AppodealPlugin::setCustomFilterInt(const String &name, int value) {
    [Appodeal setCustomStateValue:[NSNumber numberWithInt:value] forKey:_convertFromString(name)];
}

void AppodealPlugin::setCustomFilterFloat(const String &name, float value) {
    [Appodeal setCustomStateValue:[NSNumber numberWithFloat:value] forKey:_convertFromString(name)];
}

void AppodealPlugin::setCustomFilterString(const String &name, const String &value) {
    [Appodeal setCustomStateValue:_convertFromString(name) forKey:_convertFromString(name)];
}

void AppodealPlugin::resetCustomFilter(const String &name) {
    [Appodeal setCustomStateValue:nil forKey:_convertFromString(name)];
}

bool AppodealPlugin::canShow(int adType) {
    return [Appodeal canShow:_getNativeAdType(adType) forPlacement:@"default"];
}

bool AppodealPlugin::canShowForPlacement(int adType, const String &placement) {
    return [Appodeal canShow:_getNativeAdType(adType) forPlacement:_convertFromString(placement)];
}

float AppodealPlugin::getRewardAmount(const String &placementName) {
    return [[Appodeal rewardForPlacement:_convertFromString(placementName)] amount];
}

String AppodealPlugin::getRewardCurrency(const String &placementName) {
    return String::utf8([[[Appodeal rewardForPlacement:_convertFromString(placementName)] currencyName] UTF8String]);
}

void AppodealPlugin::muteVideosIfCallsMuted(bool isMuted) {
    NSLog(@"muteVideosIfCallsMuted method is not supported on iOS platform");
}

void AppodealPlugin::disableWebViewCacheClear() {
    NSLog(@"disableWebViewCacheClear method is not supported on iOS platform");
}

void AppodealPlugin::startTestActivity() {
    NSLog(@"startTestActivity method is not supported on iOS platform");
}

void AppodealPlugin::setChildDirectedTreatment(bool value) {
    [Appodeal setChildDirectedTreatment:value];
}

void AppodealPlugin::destroy(int adTypes) {
    NSLog(@"destroy method is not supported on iOS platform");
}

void AppodealPlugin::setExtraDataBool(const String &key, bool value) {
    [Appodeal setExtrasValue:[NSNumber numberWithBool:value] forKey:_convertFromString(key)];
}

void AppodealPlugin::setExtraDataInt(const String &key, int value) {
    [Appodeal setExtrasValue:[NSNumber numberWithInt:value] forKey:_convertFromString(key)];
}

void AppodealPlugin::setExtraDataFloat(const String &key, float value) {
    [Appodeal setExtrasValue:[NSNumber numberWithFloat:value] forKey:_convertFromString(key)];
}

void AppodealPlugin::setExtraDataString(const String &key, const String &value) {
    [Appodeal setExtrasValue:_convertFromString(value) forKey:_convertFromString(key)];
}

void AppodealPlugin::resetExtraData(const String &key) {
    [Appodeal setExtrasValue:nil forKey:_convertFromString(key)];
}

float AppodealPlugin::getPredictedEcpm(int adType) {
    return [Appodeal predictedEcpmForAdType:_getNativeAdType(adType)];
}

void AppodealPlugin::logEvent(const String &eventName, Dictionary params) {
    [Appodeal trackEvent:_convertFromString(eventName) customParameters:_convertFromDictionary(params)];
}

void AppodealPlugin::validatePlayStoreInAppPurchase(Dictionary payload) {
    NSLog(@"validatePlayStoreInAppPurchase method is not supported on iOS platform");
}

void AppodealPlugin::validateAppStoreInAppPurchase(Dictionary payload) {
    int purchaseType = -1;
    NSString *productId = @"";
    NSString *transactionId = @"";
    NSString *price = @"";
    NSString *currency = @"";
    NSDictionary *additionalParameters = nil;

    for (int i = 0; i < payload.size(); i++) {
        NSString *key = _convertFromString((String)payload.get_key_at_index(i));
        Variant value = payload.get_value_at_index(i);

        if ([key isEqual:@"purchase_type"]) {
            purchaseType = (int)value;
        } else if ([key isEqual:@"product_id"]) {
            productId = _convertFromString((String)value);
        } else if ([key isEqual:@"transaction_id"]) {
            transactionId = _convertFromString((String)value);
        } else if ([key isEqual:@"price"]) {
            price = _convertFromString((String)value);
        } else if ([key isEqual:@"currency"]) {
            currency = _convertFromString((String)value);
        } else if ([key isEqual:@"additional_parameters"]) {
            additionalParameters = _convertFromDictionary((Dictionary)value);
        }
    }

    [Appodeal validateAndTrackInAppPurchase:productId
                                       type:(APDPurchaseType)purchaseType
                                      price:price
                                   currency:[currency substringWithRange:NSMakeRange(0, MIN(5,currency.length))]
                              transactionId:transactionId
                       additionalParameters:additionalParameters

                                    success:^(NSDictionary *data) {
        NSData *jsonData;
        NSError *jsonError;
        jsonData = [NSJSONSerialization dataWithJSONObject:data
                                                   options:0
                                                     error:&jsonError];
        if (jsonError) {
            emit_signal("on_inapp_puchase_validate_fail", "Invalid response");
        } else {
            NSString *jsonString = [[NSString alloc] initWithBytes:jsonData.bytes
                                                            length:jsonData.length
                                                          encoding:NSUTF8StringEncoding];
            emit_signal("on_inapp_purchase_validate_success", [jsonString UTF8String]);
        }
    }
                                    failure:^(NSError *error) {
        NSString *errorString = (!error) ? @"unknown" : [NSString stringWithFormat:@"error: %@", error.localizedDescription];
        emit_signal("on_inapp_puchase_validate_fail", [errorString UTF8String]);
    }];
}

ViewController* AppodealPlugin::_getRootViewController() {
    return (ViewController *)((AppDelegate *)[[UIApplication sharedApplication] delegate]).window.rootViewController;
}

NSString* AppodealPlugin::_convertFromString(const String &str) {
    return [NSString stringWithCString:str.utf8().get_data() encoding: NSUTF8StringEncoding];
}

NSDictionary* AppodealPlugin::_convertFromDictionary(Dictionary godotDict) {
    NSMutableDictionary <NSString *, id> *outputDict = [NSMutableDictionary dictionaryWithCapacity:godotDict.size()];
    for (int i = 0; i < godotDict.size(); i++) {
        NSString *key = _convertFromString((String)godotDict.get_key_at_index(i));
        Variant value = godotDict.get_value_at_index(i);
        if (Variant::get_type_name(value.get_type()) == "bool") {
            outputDict[key] = [NSNumber numberWithBool:(bool)value];
        } else if (Variant::get_type_name(value.get_type()) == "int") {
            outputDict[key] = [NSNumber numberWithInt:(int)value];
        } else if (Variant::get_type_name(value.get_type()) == "float") {
            outputDict[key] = [NSNumber numberWithFloat:(float)value];
        } else if (Variant::get_type_name(value.get_type()) == "String") {
            outputDict[key] = _convertFromString((String)value);
        }
    }
    return outputDict;
}

AppodealAdType AppodealPlugin::_getNativeAdTypes(int adTypes) {
    AppodealAdType nativeAdTypes = 0;
    if ((adTypes & 1) > 0) {
        nativeAdTypes |= AppodealAdTypeInterstitial;
    }
    if ((adTypes & 2) > 0) {
        nativeAdTypes |= AppodealAdTypeBanner;
    }
    if ((adTypes & 4) > 0) {
        nativeAdTypes |= AppodealAdTypeRewardedVideo;
    }
    if ((adTypes & 8) > 0) {
        nativeAdTypes |= AppodealAdTypeMREC;
    }
    return nativeAdTypes;
}

AppodealAdType AppodealPlugin::_getNativeAdType(int adType) {
    if (adType == 1) {
        return AppodealAdTypeInterstitial;
    } else if (adType == 2) {
        return AppodealAdTypeBanner;
    } else if (adType == 4) {
        return AppodealAdTypeRewardedVideo;
    } else if (adType == 8) {
        return AppodealAdTypeMREC;
    } else {
        return 0;
    }
}

AppodealShowStyle AppodealPlugin::_getNativeShowStyle(int showStyle) {
    if (showStyle == 1) {
        return AppodealShowStyleInterstitial;
    } else if (showStyle == 2) {
        return AppodealShowStyleBannerBottom;
    } else if (showStyle == 4) {
        return AppodealShowStyleBannerTop;
    } else if (showStyle == 8) {
        return AppodealShowStyleBannerLeft;
    } else if (showStyle == 16) {
        return AppodealShowStyleBannerRight;
    } else if (showStyle == 32) {
        return AppodealShowStyleRewardedVideo;
    } else {
        return 0;
    }
}

AppodealShowStyle AppodealPlugin::_getNativeStyleForIsReady(int adTypes) {
    if ((adTypes & 1) > 0) {
        return AppodealShowStyleInterstitial;
    } else if ((adTypes & 2) > 0) {
        return AppodealShowStyleBannerBottom;
    } else if ((adTypes & 4) > 0) {
        return AppodealShowStyleRewardedVideo;
    } else {
        return 0;
    }
}

void AppodealPlugin::_setCallbacks() {
    [Appodeal setInitializationDelegate:initializationDelegate];
    [Appodeal setAdRevenueDelegate:adRevenueDelegate];
    [Appodeal setRewardedVideoDelegate:rewardedVideoDelegate];
    [Appodeal setInterstitialDelegate:interstitialDelegate];
    [Appodeal setBannerDelegate:bannerDelegate];
    [bannerView setDelegate:bannerViewDelegate];
    [mrecView setDelegate:mrecViewDelegate];
}
