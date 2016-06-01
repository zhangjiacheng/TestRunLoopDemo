//
//  DetailViewController.h
//  TestRunLoopDemo
//
//  Created by zhangjiacheng on 16-1-27.
//  Copyright (c) 2016年 zhangjiacheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

