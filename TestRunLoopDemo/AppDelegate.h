//
//  AppDelegate.h
//  TestRunLoopDemo
//
//  Created by zhangjiacheng on 16-1-27.
//  Copyright (c) 2016年 zhangjiacheng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RunLoopContext;

/*
 该代码主要演示了:
 1. iOS里面如何使用NSThread，如何在非主线程中开启它的Runloop.
 2. 给该Runloop 添加自定义的 RunLoopSource.
 3. RunLoopSource客户端与RunLoopSource之间的通信机制。
 
 在Thread的NSRunloop中添加RunLoopSource是在Objecttive-C里面获取常驻线程的一个主要方法手段.
 (知名开源项目AFNetworking就是用这种手段获取的常驻线程)。
 
 从该演示代码我们还可以一窥Objective-C是怎样封装C，以提供更加简单便捷的API。
 
the application’s main thread maintains references to the input source, the custom command buffer for that input source, and the run loop on which the input source is installed. When the main thread has a task it wants to hand off to the worker thread, it posts a command to the command buffer along with any information needed by the worker thread to start the task
 */
@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    NSMutableArray *sourcesToPing;
    NSInteger commandIndex;
    NSTimer *timer;
    
    //an thread without a runloopSource adding to its runloop
    NSThread *thirdThread;
    
    //an thread without a runloopSource adding to its runloop， and add a 死循环 to the thread's entry routine
    NSThread *fourthThread;
    
}

@property (strong, nonatomic) UIWindow *window;

+ (AppDelegate *)sharedAppDelegate;
- (void)registerSource:(RunLoopContext *)runLoopContext;
- (void)removeSource:(RunLoopContext *)runLoopContext;
@end

