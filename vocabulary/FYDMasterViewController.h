//
//  FYDMasterViewController.h
//  vocabulary
//
//  Created by Florian Kaiser on 23.05.13.
//  Copyright (c) 2013 Floyd UG (haftungsbeschränkt). All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FYDTestViewController.h"

@interface FYDMasterViewController : UITableViewController<FYDTestViewControllerDelegate>

@property (strong, nonatomic) FYDTestViewController *detailViewController;

@end
