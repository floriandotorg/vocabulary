//
//  FYDSettingsViewController.h
//  vocabulary
//
//  Created by Florian Kaiser on 24.05.13.
//  Copyright (c) 2013 Floyd UG (haftungsbeschränkt). All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FYDSettingsViewControllerDelegate

- (void)settingsViewControllerDidFinish;

@end

@interface FYDSettingsViewController : UITableViewController

@property (weak,nonatomic) id<FYDSettingsViewControllerDelegate> delegate;

@end
