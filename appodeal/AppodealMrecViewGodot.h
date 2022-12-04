//
//  AppodealMrecViewGodot.h
//
//  Created by Dmitrii Feshchenko on 03/12/2022.
//

#import "AppodealPluginDefines.h"

#import <Appodeal/Appodeal.h>

@interface AppodealMrecViewGodot : NSObject

+ (instancetype)sharedInstance;

- (void)setDelegate:(id<APDBannerViewDelegate>)delegate;
- (BOOL)showMrecView:(CGFloat)xAxis yAxis:(CGFloat)yAxis placement:(NSString *)placement;
- (void)hideMrecView;

@property(nonatomic, strong) APDMRECView *mrecView;

@end
