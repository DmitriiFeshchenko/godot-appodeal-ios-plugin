//
//  AppodealInterstitialDelegateGodot.mm
//
//  Created by Dmitrii Feshchenko on 03/12/2022.
//

#import "AppodealPlugin.h"
#import "AppodealInterstitialDelegateGodot.h"

@implementation AppodealInterstitialDelegateGodot

- (void)interstitialDidLoadAdIsPrecache:(BOOL)precache {
    if (AppodealPlugin::get_singleton()) {
        AppodealPlugin::get_singleton()->emit_signal("on_interstitial_loaded", precache);
    }
}

- (void)interstitialDidFailToLoadAd {
    if (AppodealPlugin::get_singleton()) {
        AppodealPlugin::get_singleton()->emit_signal("on_interstitial_failed_to_load");
    }
}

- (void)interstitialWillPresent {
    if (AppodealPlugin::get_singleton()) {
        AppodealPlugin::get_singleton()->emit_signal("on_interstitial_shown");
    }
}

- (void)interstitialDidFailToPresent {
    if (AppodealPlugin::get_singleton()) {
        AppodealPlugin::get_singleton()->emit_signal("on_interstitial_show_failed");
    }
}

- (void)interstitialDidClick {
    if (AppodealPlugin::get_singleton()) {
        AppodealPlugin::get_singleton()->emit_signal("on_interstitial_clicked");
    }
}

- (void)interstitialDidDismiss {
    if (AppodealPlugin::get_singleton()) {
        AppodealPlugin::get_singleton()->emit_signal("on_interstitial_closed");
    }
}

- (void)interstitialDidExpired {
    if (AppodealPlugin::get_singleton()) {
        AppodealPlugin::get_singleton()->emit_signal("on_interstitial_expired");
    }
}

@end
