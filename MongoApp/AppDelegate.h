//
//  AppDelegate.h
//  MongoApp
//
//  Created by Pavel Kozlov on 19.02.14.
//  Copyright (c) 2014 Pavel Kozlov. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate> {
//    NSWindow *window;
    IBOutlet NSMenu *statusMenu;
    NSStatusItem *statusItem;
    
    IBOutlet NSMenuItem *statusMenuItem;
}

//@property (assign) IBOutlet NSWindow *window;
- (IBAction) openPreferences:(id)sender;
- (IBAction) openAbout:(id)sender;
- (IBAction)openAdmin:(id)sender;
- (IBAction) openLogfile:(id)sender;
@end
