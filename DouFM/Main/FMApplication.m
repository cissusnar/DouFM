//
//  FMApplication.m
//  DouFM
//
//  Created by cissu on 2020/3/2.
//  Copyright © 2020 cissu. All rights reserved.
//

#import "FMApplication.h"
#import "DouFM-Swift.h"

@implementation FMApplication

- (void) mediaKeyEvent:(int)key state:(BOOL)state keyRepeat:(BOOL)keyrepeat {
    // Only send events on KeyDown. Without this check, these events will happen twice
    if (state) {
        NSLog(@"%@", @(key));
        switch(key) {
        case NX_KEYTYPE_PLAY:
            // Do work

                break;
        case NX_KEYTYPE_FAST:
            // Do work
                [[FMControlPanelViewController sharedInstance] playNext:nil];
                break;
        case NX_KEYTYPE_REWIND:
            // Do work
                break;
        default:
                break;
        }
    }
}


- (void)sendEvent:(NSEvent *)event
{
    if (event.type == NSEventTypeSystemDefined && event.subtype == 8) {
        int keyCode = ((event.data1 & 0xFFFF0000) >> 16);
        int keyFlags = (event.data1 & 0x0000FFFF);
           // Get the key state. 0xA is KeyDown, OxB is KeyUp
        int keyState = (((keyFlags & 0xFF00) >> 8)) == 0xA;
        int keyRepeat = (keyFlags & 0x1);
        [self mediaKeyEvent:keyCode state:keyState keyRepeat:keyRepeat];
        }

    [super sendEvent:event];
}


@end
