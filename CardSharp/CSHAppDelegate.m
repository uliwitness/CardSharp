//
//  CSHAppDelegate.m
//  CardSharp
//
//  Created by Uli Kusterer on 2013-12-01.
//  Copyright (c) 2013 Uli Kusterer. All rights reserved.
//

#import "CSHAppDelegate.h"

@implementation CSHAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	// Insert code here to initialize your application
}


-(BOOL)	saveImageForCardInRect: (NSRect)cardBox baseName: (NSString*)baseName atH: (NSInteger)h v: (NSInteger)v ofImage: (NSImage*)fullPageImage
{
	NSSize	cardBorder = { 10, 10 };
	
	NSRect		cardBoxWithBorder = NSInsetRect(cardBox,-cardBorder.width,-cardBorder.height);
	NSImage*	cardImage = [[NSImage alloc] initWithSize: cardBoxWithBorder.size];
	[cardImage lockFocus];
		if( [baseName rangeOfString: @"_black"].location != NSNotFound )
			[NSColor.blackColor set];
		else
			[NSColor.whiteColor set];
		cardBoxWithBorder.origin = NSZeroPoint;
		[NSBezierPath fillRect: cardBoxWithBorder];
		[fullPageImage drawAtPoint: NSMakePoint(cardBorder.width, cardBorder.height) fromRect: cardBox operation:NSCompositeCopy fraction: 1.0];
		NSBitmapImageRep	*	thisCard = [[NSBitmapImageRep alloc] initWithFocusedViewRect: cardBoxWithBorder];
	[cardImage unlockFocus];
	
	NSData	*	theData = [thisCard representationUsingType: NSPNGFileType properties: @{}];
	BOOL success = [theData writeToFile: [NSString stringWithFormat: @"%@_%ldx%ld.png", baseName, h, v] atomically: YES];
	
	[cardImage addRepresentation: thisCard];
	self.cardPreview.image = cardImage;
	[self.window display];
	
	return success;
}


-(BOOL)	application: (NSApplication*)sender openFile:(NSString *)filename
{
	NSString	*	baseName = [filename stringByDeletingPathExtension];
	
	NSImage		*	fullPageImage = [[NSImage alloc] initWithContentsOfFile: filename];
	
	self.pagePreview.image = fullPageImage;
	[self.window display];
	
	NSImage		*	debugImage = [fullPageImage copy];
	
	NSEdgeInsets	marginSizes = { 22, 36, 24, 36 };
	NSSize			cardInsets = { 2, 2 };
	NSInteger		numHCards = 3, numVCards = 3;
	NSSize			pageSize = fullPageImage.size;
	NSRect			pageBox = { { 0, 0 }, pageSize };
	NSRect			cardBox = NSZeroRect;
	
	pageBox.origin.x += marginSizes.left;
	pageBox.size.width -= marginSizes.left +marginSizes.right;
	pageBox.origin.y += marginSizes.bottom;
	pageBox.size.height -= marginSizes.top +marginSizes.bottom;
	
	cardBox = pageBox;
	cardBox.size.width = truncf(pageBox.size.width / numHCards);
	cardBox.size.height = truncf(pageBox.size.height / numVCards);

	[debugImage lockFocus];
		[[NSColor redColor] set];
		[NSBezierPath strokeRect: pageBox];
	[debugImage unlockFocus];
	self.pagePreview.image = debugImage;
	[self.window display];
	
	for( NSInteger h = 0; h < numHCards; h++ )
	{
		cardBox.origin.y = pageBox.origin.y;
		
		for( NSInteger v = 0; v < numVCards; v++ )
		{
			if( ![self saveImageForCardInRect: NSInsetRect(cardBox,cardInsets.width,cardInsets.height) baseName: baseName atH: h v: v ofImage: fullPageImage] )
				return NO;
			
			[debugImage lockFocus];
				[[NSColor blueColor] set];
				[NSBezierPath strokeRect: NSInsetRect(cardBox,cardInsets.width,cardInsets.height)];
			[debugImage unlockFocus];
			self.pagePreview.image = debugImage;
			[self.window display];
			
			cardBox.origin.y += cardBox.size.height;
		}
		
		cardBox.origin.x += cardBox.size.width;
	}
	
//	NSData	*	theData = debugImage.TIFFRepresentation;
//	return [theData writeToFile: [NSString stringWithFormat: @"%@_cutmarks.tiff", baseName] atomically: YES];
	
	return YES;
}


@end
