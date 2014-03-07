//
//  AppDelegate.m
//  MongoHelper
//
//  Created by Pavel Kozlov on 07.03.14.
//  Copyright (c) 2014 Pavel Kozlov. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [[NSWorkspace sharedWorkspace] launchApplication:@"/Applications/Mongo.app"];
    [NSApp terminate:self];
}

@end
