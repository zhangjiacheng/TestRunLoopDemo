//
//  AppDelegate.m
//  TestRunLoopDemo
//
//  Created by zhangjiacheng on 16-1-27.
//  Copyright (c) 2016年 zhangjiacheng. All rights reserved.
//

#import "AppDelegate.h"
//#import "DetailViewController.h"
#import "RunLoopContext.h"
#import "RunLoopSource.h"

@implementation AppDelegate

+ (AppDelegate *)sharedAppDelegate {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    sourcesToPing = [[NSMutableArray alloc] init];
    commandIndex = 0;
    
    NSMutableDictionary* threadDict = [[NSThread currentThread] threadDictionary];
    [threadDict setValue:@"In_Main_Loop" forKey:@"TheRunLoopKey"];
    
    //spaw an second thread, to test the custom input source for second thread's run loop
    NSThread *secondThread = [[NSThread alloc] initWithTarget:self selector:@selector(threadWithRunloopSourceMainRoutine) object:nil];
    [secondThread start];
    
    //spaw an  thread without RunloopSource on the runloop
    thirdThread = [[NSThread alloc] initWithTarget:self selector:@selector(threadWithoutRunloopSourceMainRoutine) object:nil];
    [thirdThread start];
    
    //
    fourthThread = [[NSThread alloc] initWithTarget:self selector:@selector(fourthThreadWithoutRunloopSourceMainRoutine) object:nil];
    [fourthThread start];
    
    //schdule the repeat timer to the main thread's run loop,
    timer = [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)timerFired {
    
    NSMutableDictionary* threadDict = [[NSThread currentThread] threadDictionary];
    NSLog(@"timer fird in -> %@",[threadDict valueForKey:@"TheRunLoopKey"]);
    
    /* After testing,you will find that the selector doSomethingOnthreadWithoutRunloopSource did not revoked on the thirdThread .
     if you changed the waitUntilDone param to YES,the programe will crash.
     That because 'thirdThread' 没有加入runloopSource的Runloop将很快退出，该thread也随之退出*/
    [self performSelector:@selector(doSomethingOnthreadWithoutRunloopSource) onThread:thirdThread withObject:nil waitUntilDone:NO];
    
    /*After testing,you will find that the selector doSomethingOnFourththreadWithoutRunloopSource did not revoking on the fourthThread .
     if you changed the waitUntilDone param to YES,the programe will  block on this line.
     That because:fourthThread一直在处理一个空的死循环*/
    [self performSelector:@selector(doSomethingOnFourththreadWithoutRunloopSource) onThread:fourthThread withObject:nil waitUntilDone:NO];
    
    if ([sourcesToPing count] > 0) {
        
        commandIndex++;
        
        RunLoopContext *runloopContext = sourcesToPing[0];
        RunLoopSource *runLoopSource = runloopContext.source;
        
        if (commandIndex > 10) {
            [runLoopSource invalildate];
            [timer invalidate];
        }
        else {
            /*send a message to runLoopSource, wake up the thread to do something
             (just log something for this sample )*/
            [runLoopSource addCommand:commandIndex withData:@" <from AppDelegate timer Client> "];
            [runLoopSource fireAllCommandsOnRunLoop:runloopContext.runLoop];
        }
        
    }
    
}

- (void)threadWithRunloopSourceMainRoutine
{
    
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    
    NSMutableDictionary* threadDict = [[NSThread currentThread] threadDictionary];
    [threadDict setValue:@"In_thread_With_RunloopSource" forKey:@"TheRunLoopKey"];

    //create and add an custom run loop source to the current run loop
    RunLoopSource *runLoopSource = [[RunLoopSource alloc] init];
    [runLoopSource addToCurrentRunLoop];
    
    [runLoop run];

}

//没有加入runloopSource的Runloop将很快退出，该thread也随之退出
- (void)threadWithoutRunloopSourceMainRoutine
{
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    
    NSMutableDictionary* threadDict = [[NSThread currentThread] threadDictionary];
    [threadDict setValue:@"In_thread_Without_RunloopSource" forKey:@"TheRunLoopKey"];
    NSLog(@" do something on: %@", [threadDict valueForKey:@"TheRunLoopKey"]);
    
    [runLoop run];
}

- (void)fourthThreadWithoutRunloopSourceMainRoutine {
    
    NSMutableDictionary* threadDict = [[NSThread currentThread] threadDictionary];
    [threadDict setValue:@"In_thread_fourth_Without_RunloopSource" forKey:@"TheRunLoopKey"];
    NSLog(@" do something on: %@", [threadDict valueForKey:@"TheRunLoopKey"]);
    
    while (true) {
        
    }
}

- (void)doSomethingOnthreadWithoutRunloopSource{
    
    NSMutableDictionary* threadDict = [[NSThread currentThread] threadDictionary];
    NSLog(@" do something on:  %@", [threadDict valueForKey:@"TheRunLoopKey"]);
    
}
- (void)doSomethingOnFourththreadWithoutRunloopSource{
    
    NSMutableDictionary* threadDict = [[NSThread currentThread] threadDictionary];
    NSLog(@" do something on:  %@", [threadDict valueForKey:@"TheRunLoopKey"]);
    
}

- (void)registerSource:(RunLoopContext *)sourceInfo {
    [sourcesToPing addObject:sourceInfo];
}
- (void)removeSource:(RunLoopContext *)sourceInfo {
    id objToRemove = nil;
    for (RunLoopContext *context in sourcesToPing) {
        if ([context.source isEqual:sourceInfo.source]) {
            objToRemove = context;
            break;
        }
    }
    if (objToRemove) {
        [sourcesToPing removeObject:objToRemove];
    }
}

//client interface for registering commands to process
//- (void)addCommand:(NSInteger)command withData:(id)data;
//- (void)fireAllCommandsOnRunLoop:(CFRunLoopRef)runloop;

@end
