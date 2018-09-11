//
//  AppDelegate.m
//  DouFM
//
//  Created by cissu on 2018/8/16.
//  Copyright © 2018年 cissu. All rights reserved.
//

#import "AppDelegate.h"
#import "DouFM-Swift.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSMenu *MainMenu;
@property (nonatomic, strong) FMWindowController * controller;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    (void)StatusBarController.sharedInstance;
    
    _controller = FMWindowController.sharedInstance;
    [_controller showWindow:nil];
    [_controller close];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [NSApp activateIgnoringOtherApps:YES];
    });
}

- (IBAction)showHelp:(id)sender {
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://clipber.com"]];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)sender hasVisibleWindows:(BOOL)flag
{
    return NO;
//    if (flag) {
//        return NO;
//    }
//    else {
//        [_controller showWindow:nil];
//        return YES;
//    }
}


@end
