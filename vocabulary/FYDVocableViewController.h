//
//  FYDAddWordViewController.h
//  vocabulary
//
//  Created by Florian Kaiser on 25.05.13.
//  Copyright (c) 2013 Floyd UG (haftungsbeschränkt). All rights reserved.
//

#import <UIKit/UIKit.h>

@class FYDVocableViewController;
@class FYDVocable;

@protocol FYDVocableViewControllerDelegate<NSObject>

- (void)vocableViewController:(FYDVocableViewController*)viewController addVocableNative:(NSString*)native Foreign:(NSString*)foreign Example:(NSString*)example;
- (void)vocableViewController:(FYDVocableViewController*)viewController removeVocable:(FYDVocable*)vocable;
- (void)vocableViewController:(FYDVocableViewController*)viewController didFinishAndEdited:(BOOL)edited;

@end

@interface FYDVocableViewController : UITableViewController

@property (strong, nonatomic) FYDVocable *vocable;
@property (weak, nonatomic) id<FYDVocableViewControllerDelegate> delegate;

@end
