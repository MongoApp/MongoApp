//
//  AppDelegate.m
//  MongoApp
//
//  Created by Pavel Kozlov on 19.02.14.
//  Copyright (c) 2014 Pavel Kozlov. All rights reserved.
//

#import "AppDelegate.h"
#import "MongoServer.h"

@implementation AppDelegate

-(void)applicationWillFinishLaunching:(NSNotification *)notification {
	
//	[[NSUserDefaults standardUserDefaults] registerDefaults:@{
//                                                              
//                                                              }];
}


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}

-(void)awakeFromNib{
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [statusItem setMenu:statusMenu];
    [statusItem setTitle:@"Status"];
    [statusItem setHighlightMode:YES];
    
    MongoServer *server = [MongoServer getInstance];
    
}

@end
