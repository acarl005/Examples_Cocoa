#include <Cocoa/Cocoa.h>
#include <Carbon/Carbon.h>

OSStatus HotkeyPressedHandler(EventHandlerCallRef _inCaller __unused, EventRef inEvent, void *inUserData);
OSStatus HotkeyPressedHandler(EventHandlerCallRef _inCaller __unused, EventRef inEvent, void *inUserData) {
    EventHotKeyID hotKeyID;

    // Get the hotKeyID corresponding to the pressed hot key.
    if (GetEventParameter(inEvent, kEventParamDirectObject, typeEventHotKeyID, nil,
                          sizeof(EventHotKeyID), nil, &hotKeyID)) {
        return eventNotHandledErr;
    }

    if (hotKeyID.id == 0) {
        NSLog(@"activating app...");
        [[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
        return 0;
    }

    return eventNotHandledErr;
}

@interface MyDelegate : NSObject <NSApplicationDelegate>
@end

@implementation MyDelegate {}

- (id)init {
    [super init];

    EventTypeSpec eventType = {kEventClassKeyboard, kEventHotKeyPressed};
    InstallApplicationEventHandler(HotkeyPressedHandler, 1, &eventType, self, NULL);
    
    EventHotKeyRef hotKeyRef = NULL;
    EventHotKeyID hotKeyID = {0, 0};

    // ctrl-g is the hotkey
    RegisterEventHotKey(5, 4096, hotKeyID, GetEventDispatcherTarget(), 0, &hotKeyRef);

    return self;
}

@end

@interface MyWindow : NSWindow {
  NSTextField* label;
}
- (instancetype)init;
- (BOOL)windowShouldClose:(id)sender;
@end

@implementation MyWindow
- (instancetype)init {
  label = [[[NSTextField alloc] initWithFrame:NSMakeRect(5, 100, 290, 100)] autorelease];
  [label setStringValue:@"Hello, World!"];
  [label setBezeled:NO];
  [label setDrawsBackground:NO];
  [label setEditable:NO];
  [label setSelectable:NO];
  [label setTextColor:[NSColor colorWithSRGBRed:0.0 green:0.5 blue:0.0 alpha:1.0]];
  [label setFont:[[NSFontManager sharedFontManager] convertFont:[[NSFontManager sharedFontManager] convertFont:[NSFont fontWithName:[[label font] fontName] size:45] toHaveTrait:NSFontBoldTrait] toHaveTrait:NSFontItalicTrait]];

  [super initWithContentRect:NSMakeRect(0, 0, 300, 300) styleMask:NSWindowStyleMaskTitled | NSWindowStyleMaskClosable | NSWindowStyleMaskMiniaturizable | NSWindowStyleMaskResizable backing:NSBackingStoreBuffered defer:NO];
  [self setTitle:@"Hello world (label)"];
  [[self contentView] addSubview:label];
  [self center];
  [self setIsVisible:YES];
  return self;
}

- (BOOL)windowShouldClose:(id)sender {
  [NSApp terminate:sender];
  return YES;
}
@end

int main(int argc, char* argv[]) {
  NSApplication *app = [NSApplication sharedApplication];
  MyDelegate *delegate = [[MyDelegate alloc] init];
  [app setDelegate:delegate];
  [[[[MyWindow alloc] init] autorelease] makeMainWindow];
  [NSApp run];
}
