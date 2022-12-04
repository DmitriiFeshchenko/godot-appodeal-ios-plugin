//
//  AppodealAdRevenueDelegateGodot.mm
//
//  Created by Dmitrii Feshchenko on 03/12/2022.
//

#import "AppodealPlugin.h"
#import "AppodealAdRevenueDelegateGodot.h"

@implementation AppodealAdRevenueDelegateGodot

- (void)didReceiveRevenueForAd:(nonnull id<AppodealAdRevenue>)ad {
    if (AppodealPlugin::get_singleton()) {
        Dictionary params;
        params["ad_type"] = [ad.adTypeString UTF8String];
        params["network_name"] = [ad.networkName UTF8String];
        params["ad_unit_name"] = [ad.adUnitName UTF8String];
        params["demand_source"] = [ad.demandSource UTF8String];
        params["placement"] = [ad.placement UTF8String];
        params["revenue"] = (float)ad.revenue;
        params["currency"] = [ad.currency UTF8String];
        params["revenue_precision"] = [ad.revenuePrecision UTF8String];
        AppodealPlugin::get_singleton()->emit_signal("on_ad_revenue_received", params);
    }
}

@end
