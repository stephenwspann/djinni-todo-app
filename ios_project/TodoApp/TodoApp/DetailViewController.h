//
//  DetailViewController.h
//  TodoApp
//
//  Created by Stephen Spann on 9/2/15.
//  Copyright (c) 2015 My Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

