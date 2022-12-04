//
//  AppodealBannerViewGodot.h
//
//  Created by Dmitrii Feshchenko on 03/12/2022.
//

#import "AppodealPluginDefines.h"

#import <Appodeal/Appodeal.h>

@interface AppodealBannerViewGodot : NSObject

+ (instancetype)sharedInstance;

- (void)setDelegate:(id<APDBannerViewDelegate>)delegate;
- (void)setTabletBanners:(BOOL)enabled;
- (BOOL)showBannerView:(CGFloat)xAxis yAxis:(CGFloat)yAxis placement:(NSString *)placement;
- (void)hideBannerView;

@property(nonatomic, strong) APDBannerView *bannerView;
@property(nonatomic, assign) BOOL isTabletBannersEnabled;

@end
