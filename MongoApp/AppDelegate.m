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
    valuePidFile = [path stringByAppendingString:@"/mongod.pid"];
    
	[[NSUserDefaults standardUserDefaults] registerDefaults:@{
                                                              keyDefaultPort: @(valueDefaultPort),
                                                              keyEnableRest: @(valueEnableRest),
                                                              keyDataDirectory: valueDataDirectory,
                                                              keyLogFile: valueLogFile,
                                                              keyPidFile: valuePidFile
                                                              }];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    [statusMenuItem setTitle:@"Starting server..."];
    
    MongoServer *server = [MongoServer getInstance];
    
    [server startWithTerminationHandler:^(NSUInteger status) {
        if (status == 0) {
            [statusMenuItem setTitle:[NSString stringWithFormat:NSLocalizedString(@"Running on port %u", nil), valueDefaultPort]];
			
        } else {
            [statusMenuItem setTitle:[NSString stringWithFormat:NSLocalizedString(@"Could not start on port %u", nil), valueDefaultPort]];
        }
    }];
}

- (void)awakeFromNib
{
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [statusItem setMenu:statusMenu];
    [statusItem setTitle:@"Status"];
    [statusItem setHighlightMode:YES];

}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender {
	// make sure preferences are saved before quitting
	PreferencesWindow *prefController = [PreferencesWindow getInstance];
	if (prefController.isWindowLoaded && prefController.window.isVisible && ![prefController windowShouldClose:prefController.window]) {
		return NSTerminateCancel;
	}
	
	if (![[MongoServer getInstance] isRunning]) {
		return NSTerminateNow;
	}
	
    [[MongoServer getInstance] stopWithTerminationHandler:^(NSUInteger status) {
        [sender replyToApplicationShouldTerminate:YES];
    }];
    
    // Set a timeout interval for postgres shutdown
    static NSTimeInterval const kTerminationTimeoutInterval = 3.0;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, kTerminationTimeoutInterval * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
        [sender replyToApplicationShouldTerminate:YES];
    });
    
    return NSTerminateLater;
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

- (IBAction)openAdmin:(id)sender {
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://127.0.0.1:28017/"]];
}

- (IBAction)openLogfile:(id)sender {
    MongoServer *server = [MongoServer getInstance];
	NSString *s = [NSString stringWithFormat:
                   @"tell application \"Console\"\n    open \"%@\"\n    activate\nend tell", server.logFile];
    
    NSAppleScript *as = [[NSAppleScript alloc] initWithSource: s];
    [as executeAndReturnError:nil];
}

- (IBAction)openMongo:(id)sender {
    MongoServer *server = [MongoServer getInstance];
    NSString *mongoPath = [server.binPath stringByAppendingString:@"/mongo"];
    
	NSString *s = [NSString stringWithFormat:
                   @"tell application \"Terminal\"\n    do script \"%@\"\n    activate\nend tell", mongoPath];
    
    NSAppleScript *as = [[NSAppleScript alloc] initWithSource: s];
    [as executeAndReturnError:nil];
}

@end
