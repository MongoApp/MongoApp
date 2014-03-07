//
//  PreferencesWindow.m
//  Mongo
//
//  Created by Pavel Kozlov on 06.03.14.
//  Copyright (c) 2014 Pavel Kozlov. All rights reserved.
//

#import <ServiceManagement/ServiceManagement.h>
#import "PreferencesWindow.h"
#import "Constants.h"
#import "NSFileManager+DirectoryLocations.h"

@interface PreferencesWindow ()

@end

@implementation PreferencesWindow


+ (PreferencesWindow*)getInstance {
	static PreferencesWindow* instance = nil;
	static dispatch_once_t predicate;
	dispatch_once(&predicate, ^{
		instance = [[PreferencesWindow alloc] initWithWindowNibName:@"PreferencesWindow"];
	});
	return instance;
}

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    BOOL loginItemEnabled = NO;
	NSArray *jobs = (__bridge_transfer NSArray *)SMCopyAllJobDictionaries(kSMDomainUserLaunchd);
	for (NSDictionary *job in jobs) {
		if ([[job valueForKey:@"Label"] isEqualToString:@"com.postgresapp.PostgresHelper"]) {
			loginItemEnabled = YES;
			break;
		}
	}
	[chkStartAtLogin setState: loginItemEnabled ? NSOnState : NSOffState];
	
	BOOL loginItemSupported = [[NSBundle mainBundle].bundlePath isEqualToString:@"/Applications/Mongo.app"];
	if (loginItemSupported) {
		chkStartAtLogin.target = self;
		chkStartAtLogin.action = @selector(toggleStartAtLogin:);
	} else {
		chkStartAtLogin.enabled = NO;
	}
}

- (IBAction) chooseDataDirectory:(id)sender;
{
	NSOpenPanel* dataDirPanel = [NSOpenPanel openPanel];
	dataDirPanel.canChooseDirectories = YES;
	dataDirPanel.canChooseFiles = NO;
	dataDirPanel.canCreateDirectories = YES;
	dataDirPanel.directoryURL = [NSURL fileURLWithPath:[[NSUserDefaults standardUserDefaults] stringForKey:keyDataDirectory]];
	[dataDirPanel beginSheetModalForWindow:self.window completionHandler:^(NSInteger result) {
		if (result==NSFileHandlingPanelOKButton) {
			[[NSUserDefaults standardUserDefaults] setObject:dataDirPanel.URL.path forKey:keyDataDirectory];
		}
	}];
}

- (IBAction) chooseLogFile:(id)sender;
{
	NSOpenPanel* dataDirPanel = [NSOpenPanel openPanel];
	dataDirPanel.canChooseDirectories = NO;
	dataDirPanel.canChooseFiles = YES;
	dataDirPanel.canCreateDirectories = YES;
	dataDirPanel.directoryURL = [NSURL fileURLWithPath:[[NSUserDefaults standardUserDefaults] stringForKey:keyLogFile]];
	[dataDirPanel beginSheetModalForWindow:self.window completionHandler:^(NSInteger result) {
		if (result==NSFileHandlingPanelOKButton) {
			[[NSUserDefaults standardUserDefaults] setObject:dataDirPanel.URL.path forKey:keyLogFile];
		}
	}];
}

- (IBAction) toggleStartAtLogin:(id)sender
{
	BOOL loginItemEnabled = (chkStartAtLogin.state == NSOnState);
    
    NSURL *helperApplicationURL = [[NSBundle mainBundle].bundleURL URLByAppendingPathComponent:@"Contents/Library/LoginItems/MongoHelper.app"];
    if (LSRegisterURL((__bridge CFURLRef)helperApplicationURL, true) != noErr) {
        NSLog(@"LSRegisterURL Failed");
    }
    
    BOOL stateChangeSuccessful = SMLoginItemSetEnabled(CFSTR("ru.pkozlov.MongoHelper"), loginItemEnabled);
	if (!stateChangeSuccessful) {
        NSError *error = [NSError errorWithDomain:@"ru.pkozlov.Mongo" code:1 userInfo:@{ NSLocalizedDescriptionKey: @"Failed to set login item."}];
		[self presentError:error modalForWindow:self.window delegate:nil didPresentSelector:NULL contextInfo:NULL];
		chkStartAtLogin.state = loginItemEnabled ? NSOffState : NSOnState;
    }
}

- (IBAction)setDefaults:(id)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:valueDataDirectory forKey:keyDataDirectory];
//    [defaults setObject:valueLogFile forKey:keyLogFile];
//    [defaults setInteger:valueDefaultPort forKey:keyDefaultPort];
//    [defaults setBool:valueEnableRest forKey:keyEnableRest];
    
    [defaults synchronize];
}

@end
