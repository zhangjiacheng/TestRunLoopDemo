//
//  RunLoopSource.m
//  TestRunLoopDemo
//
//  Created by zhangjiacheng on 16-1-29.
//  Copyright (c) 2016年 zhangjiacheng. All rights reserved.
//

#import "RunLoopSource.h"
#import "RunLoopContext.h"

@implementation RunLoopSource

- (id)init{
    self = [super init];
    if(self){
        /*
         *create 一个 RunLoopSource，在哪个thread里面创建的RunLoopSource（即调用的本函数），就在哪个thread的runloop中把这个RunLoopSource add进来（通过CFRunLoopAddSource函数，见下面）。
         ＊
         ＊CFRunLoopSourceContext中的几个回调函数也非常重要
         ＊1 RunLoopSourceScheduleRoutine 作用: 用来绑定本RunLoopSource的客户端（即发送事件给RunLoopSource的源）
         ＊2 RunLoopSourceCancelRoutine 作用: 取消本RunLoopSource时要做的事情，一般要通知感兴趣的客户端
         ＊3 RunLoopSourcePerformRoutine 作用: RunLoopSource有消息来之后，需要做的事情
         */
        CFRunLoopSourceContext context = {0, (__bridge void *)(self), NULL, NULL, NULL, NULL, NULL,
            &RunLoopSourceScheduleRoutine,
            RunLoopSourceCancelRoutine,
            RunLoopSourcePerformRoutine};
        runLoopSource = CFRunLoopSourceCreate(NULL, 0, &context);
        commands = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)addToCurrentRunLoop
{
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    /*
     if source is a version 0 source, this function calls the schedule callback function specified in the context structure for source
     */
    CFRunLoopAddSource(runLoop, runLoopSource, kCFRunLoopDefaultMode);
}

#pragma mark - client interface for registering commands to process
// the public function for client adding command to the source
- (void)addCommand:(NSInteger)command withData:(id)data {
    if (commands==nil) {
        commands = [[NSMutableArray alloc] init];
    }
    else if ([commands count] > 10){
        [commands removeAllObjects];
    }
    NSString *theCommand = [NSString stringWithFormat:@"--Command %ld--",(long) command];
    [commands addObject:theCommand];

}
//the public function for client signaling the source and waking up the runloop
- (void)fireAllCommandsOnRunLoop:(CFRunLoopRef)runloop
{
    CFRunLoopSourceSignal(runLoopSource);
    CFRunLoopWakeUp(runloop);
}
- (void)invalildate {
    CFRunLoopSourceInvalidate(runLoopSource);
}

#pragma mark - the source fired call_back function
- (void)sourceFired {
    NSString *theCommand = [commands objectAtIndex:[commands count]-1];
    NSMutableDictionary* threadDict = [[NSThread currentThread] threadDictionary];
    NSLog(@"%@ sourceFired in -> %@",theCommand, [threadDict valueForKey:@"TheRunLoopKey"]);
}


@end
