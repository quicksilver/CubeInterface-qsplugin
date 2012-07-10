//
//  QSShadowView.h
//  QSCubeInterfacePlugIn
//
//  Created by Nicholas Jitkoff on 6/26/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface QSShadowView : NSView {
	NSView *targetView;
	NSColor *color;
	CGFloat blur;
	CGFloat distance;
	CGFloat angle;
	CGFloat expand;
}
- (NSRect)paddedFrameForFrame:(NSRect)frame;

- (NSView *) targetView;
- (void) setTargetView: (NSView *) newTargetView;
- (NSColor *) color;
- (void) setColor: (NSColor *) newColor;
- (CGFloat) blur;
- (void) setBlur: (CGFloat) newBlur;
- (CGFloat) distance;
- (void) setDistance: (CGFloat) newDistance;
- (CGFloat) angle;
- (void) setAngle: (CGFloat) newAngle;
- (CGFloat) expand;
- (void) setExpand: (CGFloat) newExpand;




@end
