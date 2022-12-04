//
//  AppodealMrecViewDelegateGodot.mm
//
//  Created by Dmitrii Feshchenko on 03/12/2022.
//

#import "AppodealPlugin.h"
#import "AppodealMrecViewDelegateGodot.h"

@implementation AppodealMrecViewDelegateGodot

- (void)bannerViewDidLoadAd:(nonnull APDBannerView *)bannerView isPrecache:(BOOL)precache {
    if (AppodealPlugin::get_singleton()) {
        AppodealPlugin::get_singleton()->emit_signal("on_mrec_loaded", precache);
    }
}

- (void)bannerView:(nonnull APDBannerView *)bannerView didFailToLoadAdWithError:(nonnull NSError *)error {
    if (AppodealPlugin::get_singleton()) {
        AppodealPlugin::get_singleton()->emit_signal("on_mrec_failed_to_load");
    }
}

- (void)bannerViewDidShow:(nonnull APDBannerView *)bannerView {
    if (AppodealPlugin::get_singleton()) {
        AppodealPlugin::get_singleton()->emit_signal("on_mrec_shown");
    }
}

- (void)bannerView:(nonnull APDBannerView *)bannerView didFailToPresentWithError:(nonnull NSError *)error {
    if (AppodealPlugin::get_singleton()) {
        AppodealPlugin::get_singleton()->emit_signal("on_mrec_show_failed");
    }
}

- (void)bannerViewDidInteract:(nonnull APDBannerView *)bannerView {
    if (AppodealPlugin::get_singleton()) {
        AppodealPlugin::get_singleton()->emit_signal("on_mrec_clicked");
    }
}

- (void)bannerViewExpired:(nonnull APDBannerView *)bannerView {
    if (AppodealPlugin::get_singleton()) {
        AppodealPlugin::get_singleton()->emit_signal("on_mrec_expired");
    }
}

@end
