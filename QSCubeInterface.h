//
//  QSCubeInterface.h
//  QSCubeInterfacePlugIn
//
//  Created by Nicholas Jitkoff on 6/14/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface QSCubeInterface : QSResizingInterfaceController <NSWindowDelegate> {
	NSRect standardRect;
	IBOutlet NSTextField *detailsTextField;
	IBOutlet NSTextField *searchTextField;
	IBOutlet NSTextField *commandField;
	NSView *lastSearchField;
	NSRect positionC,positionL,positionR,positionO; //Center, left, right, out positions
	NSControl *currentControl;
	NSWindow *shadowWindow;
	NSWindow *backdropWindow;
}

- (NSRect)rectForState:(BOOL)expanded;
@end
