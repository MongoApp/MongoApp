//
//  AppDelegate.m
//  MongoApp
//
//  Created by Pavel Kozlov on 19.02.14.
//  Copyright (c) 2014 Pavel Kozlov. All rights reserved.
//

#import "AppDelegate.h"
#import "MongoServer.h"
#import "NSFileManager+DirectoryLocations.h"
#import "Constants.h"
#import "PreferencesWindow.h"

@implementation AppDelegate

-(void)applicationWillFinishLaunching:(NSNotification *)notification {
	NSString *path = [[NSFileManager defaultManager] applicationSupportDirectory];
    NSLog(@"%@", path);
    valueDataDirectory = [path stringByAppendingString:@"/data"];
    valueLogFile = [path stringByAppendingString:@"/mongod.log"];
    
	[[NSUserDefaults standardUserDefaults] registerDefaults:@{
                                                              keyDefaultPort: @(valueDefaultPort),
                                                              keyEnableRest: @(valueEnableRest),
                                                              keyDataDirectory: valueDataDirectory,
                                                              keyLogFile: valueLogFile
                                                              }];
}


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}

- (void)awakeFromNib
{
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [statusItem setMenu:statusMenu];
    [statusItem setTitle:@"Status"];
    [statusItem setHighlightMode:YES];
    
    MongoServer *server = [MongoServer getInstance];
}

- (IBAction)openPreferences:(id)sender
{
    [NSApp activateIgnoringOtherApps:YES];
	[[PreferencesWindow getInstance] showWindow:nil];
}

- (IBAction)openAbout:(id)sender
{
    [NSApp activateIgnoringOtherApps:YES];
    [NSApp orderFrontStandardAboutPanel:nil];
}

@end
