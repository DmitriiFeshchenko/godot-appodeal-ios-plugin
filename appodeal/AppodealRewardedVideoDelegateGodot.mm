//
//  AppodealRewardedVideoDelegateGodot.mm
//
//  Created by Dmitrii Feshchenko on 03/12/2022.
//

#import "AppodealPlugin.h"
#import "AppodealRewardedVideoDelegateGodot.h"

@implementation AppodealRewardedVideoDelegateGodot

- (void)rewardedVideoDidLoadAdIsPrecache:(BOOL)precache {
    if (AppodealPlugin::get_singleton()) {
        AppodealPlugin::get_singleton()->emit_signal("on_rewarded_video_loaded", precache);
    }
}

- (void)rewardedVideoDidFailToLoadAd {
    if (AppodealPlugin::get_singleton()) {
        AppodealPlugin::get_singleton()->emit_signal("on_rewarded_video_failed_to_load");
    }
}

- (void)rewardedVideoDidPresent {
    if (AppodealPlugin::get_singleton()) {
        AppodealPlugin::get_singleton()->emit_signal("on_rewarded_video_shown");
    }
}

- (void)rewardedVideoDidFailToPresentWithError:(nonnull NSError *)error {
    if (AppodealPlugin::get_singleton()) {
        AppodealPlugin::get_singleton()->emit_signal("on_rewarded_video_show_failed");
    }
}

- (void)rewardedVideoDidClick {
    if (AppodealPlugin::get_singleton()) {
        AppodealPlugin::get_singleton()->emit_signal("on_rewarded_video_clicked");
    }
}

- (void)rewardedVideoDidFinish:(float)rewardAmount name:(nullable NSString *)rewardName {
    if (AppodealPlugin::get_singleton()) {
        AppodealPlugin::get_singleton()->emit_signal("on_rewarded_video_finished", [[[NSNumber numberWithFloat:rewardAmount] stringValue] UTF8String], [rewardName UTF8String]);
    }
}

- (void)rewardedVideoWillDismissAndWasFullyWatched:(BOOL)wasFullyWatched {
    if (AppodealPlugin::get_singleton()) {
        AppodealPlugin::get_singleton()->emit_signal("on_rewarded_video_closed", wasFullyWatched);
    }
}

- (void)rewardedVideoDidExpired {
    if (AppodealPlugin::get_singleton()) {
        AppodealPlugin::get_singleton()->emit_signal("on_rewarded_video_expired");
    }
}

@end
