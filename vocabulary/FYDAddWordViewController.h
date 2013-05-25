//
//  FYDAddWordViewController.h
//  vocabulary
//
//  Created by Florian Kaiser on 25.05.13.
//  Copyright (c) 2013 Floyd UG (haftungsbeschränkt). All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FYDAddWordControllerDelegate<NSObject>

- (void)addWordControllerDidFinishNative:(NSString*)native Foreign:(NSString*)foreign;

@end

@interface FYDAddWordViewController : UITableViewController

@property (weak,nonatomic) id<FYDAddWordControllerDelegate> delegate;

@end
