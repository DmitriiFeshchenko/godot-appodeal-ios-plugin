//
//  AppodealMrecViewGodot.mm
//
//  Created by Dmitrii Feshchenko on 03/12/2022.
//

#import "AppodealMrecViewGodot.h"

#import "core/version.h"

#if VERSION_MAJOR == 4
#import "platform/ios/app_delegate.h"
#import "platform/ios/view_controller.h"
#else
#import "platform/iphone/app_delegate.h"
#import "platform/iphone/view_controller.h"
#endif

@implementation AppodealMrecViewGodot

#pragma mark - Static

+ (instancetype)sharedInstance {
    static AppodealMrecViewGodot *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

#pragma mark - Public

- (void)setDelegate:(id<APDBannerViewDelegate>)delegate {
    [self.mrecView setDelegate:delegate];
}

- (BOOL)showMrecView:(CGFloat)xAxis
                 yAxis:(CGFloat)yAxis
             placement:(NSString *)placement {
    [self hideMrecView];

    [self setSharedMrecFrame:xAxis yAxis:yAxis];
    self.mrecView.placement = placement;

    [self.mrecView.rootViewController.view addSubview:self.mrecView];
    [self.mrecView.rootViewController.view bringSubviewToFront:self.mrecView];

    [self.mrecView loadAd];

    return self.mrecView.isReady;
}

- (void)hideMrecView {
    if(self.mrecView) {
        [self.mrecView removeFromSuperview];
    }
}

#pragma mark - Private

- (UIViewController *)getRootViewController {
    return (UIViewController *)((AppDelegate *)[[UIApplication sharedApplication] delegate]).window.rootViewController;
}

- (id)init {
    self = [super init];
    if(self) {
        [self initAPDMrecView];
    }
    return self;
}

- (void)initAPDMrecView {
    self.mrecView = [[APDMRECView alloc] initWithSize:kAPDAdSize300x250 rootViewController:[self getRootViewController]];
    self.mrecView.usesSmartSizing = NO;
}

- (void)setSharedMrecFrame:(CGFloat)xAxis yAxis:(CGFloat)yAxis {
    UIViewAutoresizing mask = UIViewAutoresizingNone;

    UIView *superView = [self getRootViewController].view;
    CGSize  superviewSize = [self getRootViewController].view.bounds.size;
    CGFloat screenScale = [[UIScreen mainScreen] scale];

    CGFloat mrecHeight    = self.mrecView.frame.size.height;
    CGFloat mrecWidth     = self.mrecView.frame.size.width;

    CGFloat xOffset = .0f;
    CGFloat yOffset = .0f;

    // Calculate X offset

    if (xAxis == X_AXIS_LEFT_POS) {
        mask |= UIViewAutoresizingFlexibleRightMargin;
    } else if (xAxis == X_AXIS_RIGHT_POS) {
        mask |= UIViewAutoresizingFlexibleLeftMargin;
        xOffset = superviewSize.width - mrecWidth;
    } else if (xAxis == X_AXIS_CENTER_POS) {
        xOffset = (superviewSize.width - mrecWidth) / 2;
        mask |= UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
    } else if (xAxis / screenScale > superviewSize.width - mrecWidth) {
        NSLog(@"[Appodeal Banner view][error] Banner view x offset cannot be more than Screen width - actual banner width");
        xOffset = superviewSize.width - mrecWidth;
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
            yOffset = superviewSize.height - mrecHeight - superView.safeAreaInsets.bottom;
        } else {
            yOffset = superviewSize.height - mrecHeight;
        }
    } else if (yAxis < -2) {
        NSLog(@"[Appodeal Banner view][error] Banner view y offset cannot be less than 0");
        yOffset = 0;
    } else if (yAxis / screenScale > superviewSize.height - mrecHeight) {
        NSLog(@"[Appodeal Banner view][error] Banner view y offset cannot be more than Screen height - actual banner height");
        mask |= UIViewAutoresizingFlexibleTopMargin;
        yOffset = superviewSize.height - mrecHeight;
    } else if (yAxis == .0f) {
        mask |= UIViewAutoresizingFlexibleBottomMargin;
    } else {
        yOffset = yAxis / screenScale;
        mask |= UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    }

    NSLog(@"Creating banner frame with parameters: xOffset = %f, yOffset = %f", xOffset, yOffset);
    CGRect mrecRect = CGRectMake(xOffset, yOffset, mrecWidth, mrecHeight);
    [self.mrecView setAutoresizingMask:mask];
    [self.mrecView setFrame:mrecRect];
    [self.mrecView layoutSubviews];
}

@end
