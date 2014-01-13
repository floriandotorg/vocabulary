//
//  PracticeViewController.m
//  vocabulary
//
//  Created by florian on 12.01.14.
//  Copyright (c) 2014 Floyd UG (haftungsbeschränkt). All rights reserved.
//

#import "PracticeViewController.h"

#import "FYDTestViewController.h"
#import "FYDTabBarController.h"

@interface PracticeViewController ()

@end

@implementation PracticeViewController

#pragma mark - Prepare For Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"startPractice"])
    {
        FYDTestViewController *viewController = [[segue.destinationViewController viewControllers] objectAtIndex:0];
        
        viewController.vocableTest = [[(FYDTabBarController*)self.tabBarController vocabularyBox] vocabularyTestForStage:0 AndPractice:YES];
    }
}

@end
