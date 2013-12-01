//
//  CSHAppDelegate.h
//  CardSharp
//
//  Created by Uli Kusterer on 2013-12-01.
//  Copyright (c) 2013 Uli Kusterer. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface CSHAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSImageView *pagePreview;
@property (assign) IBOutlet NSImageView *cardPreview;

@end
