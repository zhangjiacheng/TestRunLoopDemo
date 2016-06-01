//
//  RunLoopContext.m
//  TestRunLoopDemo
//
//  Created by zhangjiacheng on 16-1-29.
//  Copyright (c) 2016年 zhangjiacheng. All rights reserved.
//

#import "RunLoopContext.h"
#import "RunLoopSource.h"
#import "AppDelegate.h"

void RunLoopSourceScheduleRoutine (void *info, CFRunLoopRef rl, CFStringRef mode)
{
    RunLoopSource* obj = (__bridge RunLoopSource *)(info);
    AppDelegate*   del = [AppDelegate sharedAppDelegate];
    RunLoopContext* theContext = [[RunLoopContext alloc] initWithSource:obj
                                                                andLoop:rl];
    [del performSelectorOnMainThread:@selector(registerSource:)
                          withObject:theContext waitUntilDone:NO];
}

void RunLoopSourcePerformRoutine (void *info)
{
    RunLoopSource*  obj = (__bridge RunLoopSource *)(info);
    [obj sourceFired];
}

void RunLoopSourceCancelRoutine (void *info, CFRunLoopRef rl, CFStringRef mode)
{
    RunLoopSource* obj = (__bridge RunLoopSource *)(info);
    AppDelegate* del = [AppDelegate sharedAppDelegate];
    RunLoopContext* theContext = [[RunLoopContext alloc] initWithSource:obj
                                                                andLoop:rl];
    [del performSelectorOnMainThread:@selector(removeSource:)
                          withObject:theContext waitUntilDone:YES];
}

@implementation RunLoopContext

@synthesize  source;
@synthesize runLoop;

- (id)initWithSource:(RunLoopSource *)src andLoop:(CFRunLoopRef)loop {
    self = [super init];
    if (self) {
        source = src;
        runLoop = loop;
    }
    return self;
}
@end
