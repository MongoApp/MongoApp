//
//  PreferencesWindow.h
//  Mongo
//
//  Created by Pavel Kozlov on 06.03.14.
//  Copyright (c) 2014 Pavel Kozlov. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PreferencesWindow : NSWindowController<NSWindowDelegate> {
    IBOutlet NSButton *chkStartAtLogin;
}

+ (PreferencesWindow*)getInstance;

- (IBAction) toggleStartAtLogin: (id)sender;

- (IBAction) chooseDataDirectory: (id)sender;
- (IBAction) chooseLogFile: (id)sender;
- (IBAction) setDefaults: (id)sender;

@end
