//
//  PreferencesWindow.m
//  Mongo
//
//  Created by Pavel Kozlov on 06.03.14.
//  Copyright (c) 2014 Pavel Kozlov. All rights reserved.
//

#import "PreferencesWindow.h"
#import "Constants.h"

@interface PreferencesWindow ()

@end

@implementation PreferencesWindow

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
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

-(IBAction)chooseDataDirectory:(id)sender;
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

-(IBAction)chooseLogFile:(id)sender;
{
	NSOpenPanel* dataDirPanel = [NSOpenPanel openPanel];
	dataDirPanel.canChooseDirectories = YES;
	dataDirPanel.canChooseFiles = YES;
	dataDirPanel.canCreateDirectories = YES;
	dataDirPanel.directoryURL = [NSURL fileURLWithPath:[[NSUserDefaults standardUserDefaults] stringForKey:keyLogFile]];
	[dataDirPanel beginSheetModalForWindow:self.window completionHandler:^(NSInteger result) {
		if (result==NSFileHandlingPanelOKButton) {
			[[NSUserDefaults standardUserDefaults] setObject:dataDirPanel.URL.path forKey:keyLogFile];
		}
	}];
}

@end
