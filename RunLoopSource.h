//
//  RunLoopSource.h
//  TestRunLoopDemo
//
//  Created by zhangjiacheng on 16-1-29.
//  Copyright (c) 2016年 zhangjiacheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RunLoopSource : NSObject
{
    CFRunLoopSourceRef runLoopSource;
    NSMutableArray *commands;
}
- (id)init;
- (void)addToCurrentRunLoop;
//handle method
- (void)sourceFired;

//client interface for registering commands to process
- (void)addCommand:(NSInteger)command withData:(id)data;
- (void)fireAllCommandsOnRunLoop:(CFRunLoopRef)runloop;
- (void)invalildate;
@end
