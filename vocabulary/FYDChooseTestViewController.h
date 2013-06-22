//
//  FYDMasterViewController.h
//  vocabulary
//
//  Created by Florian Kaiser on 23.05.13.
//  Copyright (c) 2013 Floyd UG (haftungsbeschränkt). All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FYDTestViewController.h"
#import "FYDSettingsViewController.h"
#import "FYDVocableViewController.h"

@interface FYDChooseTestViewController : UITableViewController<FYDTestViewControllerDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) FYDTestViewController *detailViewController;

@end
