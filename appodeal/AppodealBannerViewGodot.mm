//
//  AppodealBannerViewGodot.mm
//
//  Created by Dmitrii Feshchenko on 03/12/2022.
//

#import "AppodealBannerViewGodot.h"

#import "core/version.h"

#if VERSION_MAJOR == 4
#import "platform/ios/app_delegate.h"
#import "platform/ios/view_controller.h"
#else
#import "platform/iphone/app_delegate.h"
#import "platform/iphone/view_controller.h"
#endif

@implementation AppodealBannerViewGodot

#pragma mark - Static

+ (instancetype)sharedInstance {
    static AppodealBannerViewGodot *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

#pragma mark - Public

- (void)setDelegate:(id<APDBannerViewDelegate>)delegate {
    [self.bannerView setDelegate:delegate];
}

- (void)setTabletBanners:(BOOL)enabled {
    self.isTabletBannersEnabled = enabled;
    [self initAPDBannerView];
}

- (BOOL)showBannerView:(CGFloat)xAxis
                 yAxis:(CGFloat)yAxis
             placement:(NSString *)placement {
    [self hideBannerView];

    [self setSharedBannerFrame:xAxis yAxis:yAxis];
    self.bannerView.placement = placement;

    [self.bannerView.rootViewController.view addSubview:self.bannerView];
    [self.bannerView.rootViewController.view bringSubviewToFront:self.bannerView];

    [self.bannerView loadAd];

    return self.bannerView.isReady;
}

- (void)hideBannerView {
    if(self.bannerView) {
        [self.bannerView removeFromSuperview];
    }
}

#pragma mark - Private

- (UIViewController *)getRootViewController {
    return (UIViewController *)((AppDelegate *)[[UIApplication sharedApplication] delegate]).window.rootViewController;
}

- (id)init {
    self = [super init];
    // self.isTabletBannersEnabled = YES; ??
    [self initAPDBannerView];
    return self;
}

- (void)initAPDBannerView {
    BOOL isTabletSize = self.isTabletBannersEnabled && [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad;
    CGSize size = isTabletSize ? kAPDAdSize728x90 : kAPDAdSize320x50;
    self.bannerView = [[APDBannerView alloc] initWithSize:size rootViewController:[self getRootViewController]];
}

- (void)setSharedBannerFrame:(CGFloat)xAxis yAxis:(CGFloat)yAxis {
    UIViewAutoresizing mask = UIViewAutoresizingNone;

    UIView *superView = [self getRootViewController].view;
    CGSize  superviewSize = [self getRootViewController].view.bounds.size;
    CGFloat screenScale = [[UIScreen mainScreen] scale];

    CGFloat bannerHeight = self.bannerView.frame.size.height;
    CGFloat bannerWidth = self.bannerView.frame.size.width;

    CGFloat xOffset = .0f;
    CGFloat yOffset = .0f;

    // Calculate X offset

    if (xAxis == X_AXIS_SMART_POS) {
        mask |= UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
        self.bannerView.usesSmartSizing = YES;
        bannerWidth = superviewSize.width;
    } else if (xAxis == X_AXIS_LEFT_POS) {
        mask |= UIViewAutoresizingFlexibleRightMargin;
    } else if (xAxis == X_AXIS_RIGHT_POS) {
        mask |= UIViewAutoresizingFlexibleLeftMargin;
        xOffset = superviewSize.width - bannerWidth;
    } else if (xAxis == X_AXIS_CENTER_POS) {
        xOffset = (superviewSize.width - bannerWidth) / 2;
        mask |= UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
    } else if (xAxis / screenScale > superviewSize.width - bannerWidth) {
        NSLog(@"[Appodeal Banner view][error] Banner view x offset cannot be more than Screen width - actual banner width");
        xOffset = superviewSize.width - bannerWidth;
        mask |= UIViewAutoresizingFlexibleLeftMargin;
    } else if (xAxis < -4) {
        NSLog(@"[Appodeal Banner view][error] Banner view x offset cannot be less than 0");
        xOffset = 0;
    } else {
        mask |= UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
        xOffset = xAxis / screenScale;
    }

    // Calculate Y offset

    if (yAxis == Y_AXIS_TOP_POS) {
        mask |= UIViewAutoresizingFlexibleBottomMargin;
        if (@available(iOS 11.0, *)) {
            yOffset = superView.safeAreaInsets.top;
        }
    } else if (yAxis == Y_AXIS_BOTTOM_POS) {
        mask |= UIViewAutoresizingFlexibleTopMargin;
        if (@available(iOS 11.0, *)) {
            yOffset = superviewSize.height - bannerHeight - superView.safeAreaInsets.bottom;
        } else {
            yOffset = superviewSize.height - bannerHeight;
        }
    } else if (yAxis < -2) {
        NSLog(@"[Appodeal Banner view][error] Banner view y offset cannot be less than 0");
        yOffset = 0;
    } else if (yAxis / screenScale > superviewSize.height - bannerHeight) {
        NSLog(@"[Appodeal Banner view][error] Banner view y offset cannot be more than Screen height - actual banner height");
        mask |= UIViewAutoresizingFlexibleTopMargin;
        yOffset = superviewSize.height - bannerHeight;
    } else if (yAxis == .0f) {
        mask |= UIViewAutoresizingFlexibleBottomMargin;
    } else {
        yOffset = yAxis / screenScale;
        mask |= UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    }

    NSLog(@"Creating banner frame with parameters: xOffset = %f, yOffset = %f", xOffset, yOffset);
    CGRect bannerRect = CGRectMake(xOffset, yOffset, bannerWidth, bannerHeight);
    [self.bannerView setAutoresizingMask:mask];
    [self.bannerView setFrame:bannerRect];
    [self.bannerView layoutSubviews];
}

@end
