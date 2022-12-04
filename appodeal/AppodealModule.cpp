//
//  AppodealModule.cpp
//
//  Created by Dmitrii Feshchenko on 26/11/2022.
//

#import "AppodealModule.h"
#import "AppodealPlugin.h"

#if VERSION_MAJOR == 4
#import "core/config/engine.h"
#else
#import "core/engine.h"
#endif

AppodealPlugin *singleton;

void registerAppodealTypes() {
    singleton = memnew(AppodealPlugin);
	Engine::get_singleton()->add_singleton(Engine::Singleton("Appodeal", singleton));
}

void unregisterAppodealTypes() {
	if (singleton) {
		memdelete(singleton);
	}
}
