//
//  AppodealBannerDelegateGodot.mm
//
//  Created by Dmitrii Feshchenko on 03/12/2022.
//

#import "AppodealPlugin.h"
#import "AppodealBannerDelegateGodot.h"

@implementation AppodealBannerDelegateGodot

- (void)bannerDidLoadAdIsPrecache:(BOOL)precache {
    if (AppodealPlugin::get_singleton()) {
        int height = (int)Appodeal.banner.bounds.size.height;
        AppodealPlugin::get_singleton()->emit_signal("on_banner_loaded", height, precache);
    }
}

- (void)bannerDidFailToLoadAd {
    if (AppodealPlugin::get_singleton()) {
        AppodealPlugin::get_singleton()->emit_signal("on_banner_failed_to_load");
    }
}

- (void)bannerDidShow {
    if (AppodealPlugin::get_singleton()) {
        AppodealPlugin::get_singleton()->emit_signal("on_banner_shown");
    }
}

- (void)bannerDidFailToPresentWithError:(nonnull NSError *)error {
    if (AppodealPlugin::get_singleton()) {
        AppodealPlugin::get_singleton()->emit_signal("on_banner_show_failed");
    }
}

- (void)bannerDidClick {
    if (AppodealPlugin::get_singleton()) {
        AppodealPlugin::get_singleton()->emit_signal("on_banner_clicked");
    }
}

- (void)bannerDidExpired {
    if (AppodealPlugin::get_singleton()) {
        AppodealPlugin::get_singleton()->emit_signal("on_banner_expired");
    }
}

@end
