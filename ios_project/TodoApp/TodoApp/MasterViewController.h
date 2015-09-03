//
//  MasterViewController.h
//  TodoApp
//
//  Created by Stephen Spann on 9/2/15.
//  Copyright (c) 2015 My Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController

@property (strong, nonatomic) DetailViewController *detailViewController;


@end

