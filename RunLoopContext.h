//
//  RunLoopContext.h
//  TestRunLoopDemo
//
//  Created by zhangjiacheng on 16-1-29.
//  Copyright (c) 2016年 zhangjiacheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RunLoopSource.h"

// These are the CFRunLoopSourceRef callback functions.
void RunLoopSourceScheduleRoutine (void *info, CFRunLoopRef rl, CFStringRef mode);
void RunLoopSourcePerformRoutine (void *info);
void RunLoopSourceCancelRoutine (void *info, CFRunLoopRef rl, CFStringRef mode);

@interface RunLoopContext : NSObject
{
    CFRunLoopRef runLoop;
    RunLoopSource *source;
}
@property (readonly) CFRunLoopRef runLoop;
@property (readonly) RunLoopSource *source;
- (id)initWithSource:(RunLoopSource *)src andLoop:(CFRunLoopRef)loop;
@end
