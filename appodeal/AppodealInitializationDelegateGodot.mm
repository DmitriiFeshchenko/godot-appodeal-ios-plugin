//
//  AppodealInitializationDelegateGodot.mm
//
//  Created by Dmitrii Feshchenko on 26/11/2022.
//

#import "AppodealPlugin.h"
#import "AppodealInitializationDelegateGodot.h"

@implementation AppodealInitializationDelegateGodot

- (void)appodealSDKDidInitialize {
    if (AppodealPlugin::get_singleton()) {
        AppodealPlugin::get_singleton()->emit_signal("on_initialization_finished", "");
    }
}

@end
