//
//  QSCubeInterface.m
//  QSCubeInterfacePlugIn
//
//  Created by Nicholas Jitkoff on 6/14/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "QSCubeInterface.h"

#import "QSShadowView.h"

@implementation QSCubeInterface

- (id)init {
  return [self initWithWindowNibName:@"QSCubeInterface"];
}


- (void)resignKeyWindow {
  [[self shadowWindow] orderOut:nil];
  
  [[self backdropWindow] orderOut:nil];
  [super resignKeyWindow];
}

- (NSWindow *)shadowWindow {
	if (!shadowWindow) {
		NSRect windowRect = NSMakeRect(0, 0, 300, 300);
		NSWindow *window = [[NSWindow alloc] initWithContentRect:windowRect styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO];
		[window setIgnoresMouseEvents:YES];
		[window setBackgroundColor: [NSColor clearColor]];
		[window setOpaque:NO];
		[window setHasShadow:NO];
		[window setContentView:[[[QSShadowView alloc] init] autorelease]];
		[window setReleasedWhenClosed:YES];
		[window setAlphaValue:0.0]; 					
		shadowWindow = window;
		
		[[shadowWindow contentView] setTargetView:[[self window] contentView]];
		
		[[shadowWindow contentView] bind:@"color"
                                    toObject:[NSUserDefaultsController sharedUserDefaultsController]
                                withKeyPath:@"values.interface.shadowColor"
                                     options:[NSDictionary dictionaryWithObject:NSUnarchiveFromDataTransformerName
                                                                                          forKey:@"NSValueTransformerName"]];
		
		
		[[shadowWindow contentView] bind:@"distance"
                                    toObject:[NSUserDefaultsController sharedUserDefaultsController]
                                withKeyPath:@"values.interface.shadowDistance"
                                     options:nil];
		[[shadowWindow contentView] bind:@"angle"
                                    toObject:[NSUserDefaultsController sharedUserDefaultsController]
                                withKeyPath:@"values.interface.shadowDirection"
                                     options:nil];
		[[shadowWindow contentView] bind:@"expand"
                                    toObject:[NSUserDefaultsController sharedUserDefaultsController]
                                withKeyPath:@"values.interface.shadowSize"
                                     options:nil];
		[[shadowWindow contentView] bind:@"blur"
                                    toObject:[NSUserDefaultsController sharedUserDefaultsController]
                                withKeyPath:@"values.interface.shadowBlur"
                                     options:nil];
		
    
		
	}
	return shadowWindow;
	
}

- (NSWindow *)backdropWindow {
  
	if (!backdropWindow && [self useBackdrop]) {
		NSRect windowRect = [[NSScreen mainScreen] frame];
		NSWindow *window = [[NSWindow alloc] initWithContentRect:windowRect styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO];
		[window setIgnoresMouseEvents:YES];
		[window setBackgroundColor: [NSColor blueColor]];
    
		[window setOpaque:NO];
		[window setHasShadow:NO];
		[window setReleasedWhenClosed:YES];
		[window setAlphaValue:0.0]; 					
		backdropWindow = window;
		
		
		[backdropWindow bind:@"backgroundColor"
                     toObject:[NSUserDefaultsController sharedUserDefaultsController]
                 withKeyPath:@"values.interface.backdropColor"
                      options:[NSDictionary dictionaryWithObject:NSUnarchiveFromDataTransformerName
                                                                        forKey:@"NSValueTransformerName"]];
    [window display];
		[[NSUserDefaultsController sharedUserDefaultsController] addObserver:self forKeyPath:@"values.interface.backdropColor" options:0 context:backdropWindow];
	}
	return backdropWindow;
	
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
  if (context == backdropWindow) {
    [[self backdropWindow] display];
  } else {
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
  }
}


- (IBAction)customize:(id)sender {
	[[NSClassFromString(@"QSPreferencesController") sharedInstance] showPaneWithIdentifier:@"QSCubeInterfacePrefPane"];
}
- (void)windowDidLoad {
	
	if (![[self window] setFrameUsingName:@"CubeInterfaceWindow"])
		[[self window] center];
	[[self window] setFrameAutosaveName:@"CubeInterfaceWindow"];
  [[self window] setFrame:constrainRectToRect([[self window] frame] , [[[self window] screen] visibleFrame]) display:NO];
  [(QSObjectCell *)[dSelector cell] setIconSize:NSMakeSize(512,512)];
	standardRect = centerRectInRect([[self window] frame] , [[NSScreen mainScreen] frame]);
	positionC = [dSelector frame];
	positionL = [aSelector frame];
	positionR = [iSelector frame];
	
  //	[[NSNotificationCenter defaultCenter] addObserver:self
  //											selector:windowDidExpose name:<#(NSString *)aName#> object:<#(id)anObject#>
  //	
	[[self window] setDelegate:self];
	[dSelector setResultsPadding:positionC.origin.y];
	[iSelector setResultsPadding:positionC.origin.y];
	[aSelector setResultsPadding:positionC.origin.y];
	
	
	
	positionO = NSOffsetRect(positionC, 500, 0);
	
	
  [super windowDidLoad];
	QSWindow *window = (QSWindow *)[self window];
	[window setLevel:kCGDraggingWindowLevel-1];
	
	[[self shadowWindow] setLevel:kCGDraggingWindowLevel-2];
	[[self backdropWindow] setLevel:kCGDraggingWindowLevel-3];
  [window setBackgroundColor:[NSColor clearColor]];
  
  [window setHideOffset:NSMakePoint(0, 0)];
	[window setShowOffset:NSMakePoint(0, 0)];
	[window setHasShadow:NO];
  
  
  [window setShowEffect:[NSDictionary dictionaryWithObjectsAndKeys:@"show", @"type", [NSNumber numberWithFloat:0.15] , @"duration", nil]];
  //	
	[window setWindowProperty:[NSDictionary dictionaryWithObjectsAndKeys:@"QSExplodeEffect", @"transformFn", @"hide", @"type", [NSNumber numberWithFloat:0.2] , @"duration", nil]
                          forKey:kQSWindowExecEffect];
	
	[window setWindowProperty:[NSDictionary dictionaryWithObjectsAndKeys:@"hide", @"type", [NSNumber numberWithFloat:0.15] , @"duration", nil]
                          forKey:kQSWindowFadeEffect];
	
  
  [[[self window] contentView] bind:@"highlightColor"
                                   toObject:[NSUserDefaultsController sharedUserDefaultsController]
                               withKeyPath:@"values.interface.glassColor"
                                    options:[NSDictionary dictionaryWithObject:NSUnarchiveFromDataTransformerName
                                                                                         forKey:@"NSValueTransformerName"]];
  
  [[[self window] contentView] bind:@"startColor"
                                   toObject:[NSUserDefaultsController sharedUserDefaultsController]
                               withKeyPath:@"values.interface.topColor"
                                    options:[NSDictionary dictionaryWithObject:NSUnarchiveFromDataTransformerName
                                                                                         forKey:@"NSValueTransformerName"]];
  
  [[[self window] contentView] bind:@"endColor"
                                   toObject:[NSUserDefaultsController sharedUserDefaultsController]
                               withKeyPath:@"values.interface.bottomColor"
                                    options:[NSDictionary dictionaryWithObject:NSUnarchiveFromDataTransformerName
                                                                                         forKey:@"NSValueTransformerName"]];
  [[[self window] contentView] bind:@"borderColor"
                                   toObject:[NSUserDefaultsController sharedUserDefaultsController]
                               withKeyPath:@"values.interface.borderColor"
                                    options:[NSDictionary dictionaryWithObject:NSUnarchiveFromDataTransformerName
                                                                                         forKey:@"NSValueTransformerName"]];
  [[[self window] contentView] bind:@"glassType"
                                   toObject:[NSUserDefaultsController sharedUserDefaultsController]
                               withKeyPath:@"values.interface.glassType"
                                    options:nil];
  [[[self window] contentView] bind:@"borderWidth"
                                   toObject:[NSUserDefaultsController sharedUserDefaultsController]
                               withKeyPath:@"values.interface.borderWidth"
                                    options:nil];

	
	
  NSArray *theControls = [NSArray arrayWithObjects:dSelector, aSelector, iSelector, nil];
  for(QSSearchObjectView *theControl in theControls) {
		//NSCell *theCell = [[[QSFancyObjectCell alloc] init] autorelease];
		//[theControl setCell:theCell];
		
		NSCell *theCell = [theControl cell];
		[theCell setAlignment:NSCenterTextAlignment];
		[theControl setPreferredEdge:NSMinYEdge];
		[theControl setResultsPadding:NSMinY([dSelector frame])];
		[theControl setPreferredEdge:NSMinYEdge];
		[(QSWindow *)[((QSSearchObjectView *)theControl)->resultController window] setHideOffset:NSMakePoint(0, NSMinY([iSelector frame]))];
		[(QSWindow *)[((QSSearchObjectView *)theControl)->resultController window] setShowOffset:NSMakePoint(0, NSMinY([dSelector frame]))];
		
		
    [(QSObjectCell *)theCell setShowDetails:NO];
			[theCell unbind:@"highlightColor"];
		[(QSObjectCell *)theCell setHighlightColor:[NSColor clearColor]];
			[theCell bind:@"textColor"
            toObject:[NSUserDefaultsController sharedUserDefaultsController]
        withKeyPath:@"values.interface.textColor"
             options:[NSDictionary dictionaryWithObject:NSUnarchiveFromDataTransformerName forKey:@"NSValueTransformerName"]];
	}
  
	[[detailsTextField cell] bind:@"textColor"
                             toObject:[NSUserDefaultsController sharedUserDefaultsController]
                         withKeyPath:@"values.interface.textColor"
                              options:[NSDictionary dictionaryWithObject:NSUnarchiveFromDataTransformerName forKey:@"NSValueTransformerName"]];
	[[commandField cell] bind:@"textColor"
                         toObject:[NSUserDefaultsController sharedUserDefaultsController]
                     withKeyPath:@"values.interface.textColor"
                          options:[NSDictionary dictionaryWithObject:NSUnarchiveFromDataTransformerName forKey:@"NSValueTransformerName"]];
	
	
	[self updateSearchViewsForTarget:dSelector];
  
}

- (NSSize) maxIconSize {
  return NSMakeSize(128, 128);
}
- (BOOL)useBackdrop {
	return [[NSUserDefaults standardUserDefaults] boolForKey:@"interface.useBackdrop"];
}
- (void)showMainWindow:(id)sender {
	//	[[self window] setFrame:[self rectForState:[self expanded]]  display:YES];
	if ([[self window] isVisible]) [[self window] pulse:self];
	
	[[[self shadowWindow] contentView] updatePosition];
	//		[[self shadowWindow] setFrame:frame display:YES];
  
	[[self shadowWindow] setAlphaValue:0.0];
	[[self backdropWindow] setAlphaValue:0.0];
	
	if ([self useBackdrop]) {
    [[self backdropWindow] orderFront:nil];
		NSRect windowRect = [[NSScreen mainScreen] frame];
		[[self backdropWindow] setFrame:windowRect display:NO];
		[[self window] addChildWindow:[self backdropWindow] ordered:NSWindowBelow];
	} else {
		[[self shadowWindow] orderFront:nil];
		[[self window] addChildWindow:[self shadowWindow] ordered:NSWindowBelow];
		
	}
	
  [super showMainWindow:sender];
	[[self window] removeChildWindow:[self backdropWindow]];
	
	[[[self window] contentView] setNeedsDisplay:YES];
}

- (void)hideMainWindowWithEffect:(id)effect {
	if ([self useBackdrop])
		[[self window] addChildWindow:[self backdropWindow] ordered:NSWindowBelow];
  
	[super hideMainWindowWithEffect:effect];
	
	[[self window] removeChildWindow:[self backdropWindow]];
}
- (void)expandWindow:(id)sender { 
  //    if (![self expanded])
  //        [[self window] setFrame:[self rectForState:YES] display:YES animate:YES];
  [super expandWindow:sender];
}
- (void)contractWindow:(id)sender {
  //	if ([self expanded])
  //        [[self window] setFrame:[self rectForState:NO] display:YES animate:YES]; 	
  [super contractWindow:sender];
}


- (NSRect) rectForState:(BOOL)shouldExpand { 
  NSRect newRect = standardRect;
  NSRect screenRect = [[NSScreen mainScreen] frame];
  if (!shouldExpand) {
		//	NSLog(@"should");
    newRect.size.width -= NSMaxX([iSelector frame]) -NSMaxX([aSelector frame]);
    newRect = centerRectInRect(newRect, [[NSScreen mainScreen] frame]);
  }
  newRect = centerRectInRect(newRect, screenRect);
  newRect = NSOffsetRect(newRect, 0, NSHeight(screenRect) /8);
	return newRect;
}


- (NSRect) window:(NSWindow *)window willPositionSheet:(NSWindow *)sheet usingRect:(NSRect)rect {
	return NSOffsetRect(NSInsetRect(rect, 8, 0), 0, -21);
}


- (void)updateDetailsString {
    NSString *commandName = [[self currentCommand] name];
    if (!commandName) commandName = @"";
    [commandView setStringValue:([dSelector objectValue] ? commandName : @"Quicksilver")];
  	NSString *command = [[self currentCommand] description];
  	if (command) 	[commandField setStringValue:command?command:@""];
}

- (void)firstResponderChanged:(NSResponder *)aResponder {
	//	logRect([[self window] frame]);
	[super firstResponderChanged:aResponder];
	[self updateDetailsString];
	
	if (aResponder == dSelector || aResponder == aSelector || aResponder == iSelector) {
		[[[self window] contentView] setNeedsDisplay:YES];
	
		//if (aResponder == dSelector && last
		//NSLog(@"last %@ %@ %@", lastSearchField, aResponder, dSelector);
		if ((aResponder == aSelector && lastSearchField == dSelector)
        || (aResponder == iSelector && lastSearchField == aSelector)
        || (aResponder == iSelector && lastSearchField == dSelector) ) {//forward rotation
			
			QSCGSTransition *transition = [QSCGSTransition transitionWithWindow:[self window] type:CGSCube option:CGSLeft];
			[self updateSearchViewsForTarget:(QSSearchObjectView *)aResponder];
			[[self window] display];
			[transition runTransition:0.3];
			
		} else if ((aResponder == dSelector && lastSearchField == aSelector)
               || (aResponder == aSelector && lastSearchField == iSelector)
               || (aResponder == dSelector && lastSearchField == iSelector) ) {
			
			BOOL extraRotation = (aResponder == dSelector && lastSearchField == iSelector);
			if (extraRotation) { // extra rotation
				QSCGSTransition *transition = [QSCGSTransition transitionWithWindow:[self window] type:CGSCube option:CGSRight];
				
				[self updateSearchViewsForTarget:aSelector];
				[[self window] display];
				[transition runTransition:0.15];
        
			}
			
			[self updateSearchViewsForTarget:(QSSearchObjectView *)aResponder];
			
			QSCGSTransition *transition = [QSCGSTransition transitionWithWindow:[self window] type:CGSCube option:CGSRight];
			[[self window] display];
			[transition runTransition:extraRotation?0.15:0.3];
			
		} else {
      //	NSLog(@"else!");
			[self updateSearchViewsForTarget:(QSSearchObjectView *)aResponder];
		}
		//usleep(200000); 	
		lastSearchField = (QSSearchObjectView *)aResponder;
	}
	
	if (!aResponder)
		lastSearchField = nil;
}
- (void)updateSearchViewsForTarget:(NSView *)responder {
	
	NSControl *fieldL = nil;
	NSControl *fieldR = nil;
	NSControl *fieldC = nil;
	NSControl *fieldO = nil;
	
	if (responder == dSelector) {
		fieldC = dSelector;
		fieldR = aSelector;
		fieldO = iSelector;
	} else if (responder == aSelector) {
		fieldL = dSelector;
		fieldC = aSelector;
		fieldR = iSelector;
	} else if (responder == iSelector) {
		fieldR = aSelector;
		fieldL = dSelector;
		fieldC = iSelector;
	}
	
	[fieldC setFrame:positionC];
	[fieldR setFrame:positionR];
	[fieldO setFrame:positionO];
	[fieldL setFrame:positionL];
	
	[fieldC setFont:[NSFont systemFontOfSize:11]];
	[fieldR setFont:[NSFont systemFontOfSize:8]];
	[fieldL setFont:[NSFont systemFontOfSize:8]];
	
	[[fieldC superview] addSubview:fieldC
                            positioned:NSWindowBelow relativeTo:nil];
	
	
}


- (void)searchObjectChanged:(NSNotification*)notif {
	[super searchObjectChanged:notif]; 	
	[self updateDetailsString];
}

- (void)searchView:(QSSearchObjectView *)view changedString:(NSString *)string {
	//	NSLog(@"string %@ %@", string, view); 	
	
	if (string) {
		if (view == dSelector) {
			[searchTextField setStringValue:string];
			//[searchTextField setAttributedStringValue:[self fancyStringForView:view]];
		} else if (view == aSelector) {
			[searchTextField setStringValue:string];
		} else if (view == iSelector) {
			[searchTextField setStringValue:string];
		}
	}
}
@end
