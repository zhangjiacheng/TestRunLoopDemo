//
//  MasterViewController.m
//  TestRunLoopDemo
//
//  Created by zhangjiacheng on 16-1-27.
//  Copyright (c) 2016年 zhangjiacheng. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"

@interface MasterViewController ()

@property NSMutableArray *objects;
@end

@implementation MasterViewController

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender {
    if (!self.objects) {
        self.objects = [[NSMutableArray alloc] init];
    }
    [self.objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = self.objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
}

#pragma mark - runloop demo
void myRunLoopObserver(){
//    CFRunLoopRef cfRunloop = CFRunLoopGetCurrent();
//    NSLog(@"runloop_observer activity == %@",cfRunloop);
}
- (void)doFireTimer:(NSDictionary *)timerDic {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSLog(@"doFireTimer date == %@",[dateFormatter stringFromDate:[NSDate date]]);
}
- (void)threadMain
{
    
}

/*
 
 // The application uses garbage collection, so no autorelease pool is needed.
 NSRunLoop* myRunLoop = [NSRunLoop currentRunLoop];
 // Create a run loop observer and attach it to the run loop.
 CFRunLoopObserverContext context = {0, (__bridge void *)(self), NULL, NULL, NULL};CFRunLoopObserverRef observer = CFRunLoopObserverCreate(kCFAllocatorDefault,
 kCFRunLoopAllActivities, YES, 0, &myRunLoopObserver, &context);
 if (observer)
 {
 CFRunLoopRef    cfLoop = [myRunLoop getCFRunLoop];
 CFRunLoopAddObserver(cfLoop, observer, kCFRunLoopDefaultMode);
 }
 // Create and schedule the timer.
 [NSTimer scheduledTimerWithTimeInterval:0.1 target:self
 selector:@selector(doFireTimer:) userInfo:nil repeats:YES];
 
 NSInteger    loopCount = 10;
 do
 {
 // Run the run loop 10 times to let the timer fire.
 [myRunLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
 
 NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
 dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
 NSLog(@"do while loop -loopCount == %ld",(long)loopCount);
 
 loopCount--;
 }
 while (loopCount);
 
 */

- (void)lauchThread {
    NSPort *myPort = [NSMachPort port];
    if (myPort) {
        // This class handles incoming port messages.
        [myPort setDelegate:self];
        // Install the port as an input source on the current run loop.
        [[NSRunLoop currentRunLoop] addPort:myPort forMode:NSDefaultRunLoopMode];
        // Detach the thread. Let the worker release the port.
    }
}

#pragma mark - 
- (void)handlePortMessage:(NSPortMessage *)portMessage {
    
//    unsigned int message = [portMessage ];
//    NSPort* distantPort = nil;
//    if (message == kCheckinMessage)
//    {
//        // Get the worker thread’s communications port.
//        //distantPort = [portMessage sendPort];
//        
//        // Retain and save the worker port for later use.
//        //[self storeDistantPort:distantPort];
//    }
//    else {
//        // Handle other messages.
//    }
}

//- (void)storeDistantPort:

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    NSDate *object = self.objects[indexPath.row];
    cell.textLabel.text = [object description];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

@end
