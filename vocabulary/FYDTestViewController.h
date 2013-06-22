//
//  FYDDetailViewController.h
//  vocabulary
//
//  Created by Florian Kaiser on 23.05.13.
//  Copyright (c) 2013 Floyd UG (haftungsbeschränkt). All rights reserved.
//

#import <UIKit/UIKit.h>

#import "iSpeechSDK.h"

@class FYDVocabularyTest;

@protocol FYDTestViewControllerDelegate<NSObject>

- (void)testViewControllerDidFinish;

@end

@interface FYDTestViewController : UIViewController<ISSpeechSynthesisDelegate>

@property (strong,nonatomic) FYDVocabularyTest *vocableTest;
@property (weak,nonatomic) id<FYDTestViewControllerDelegate> delegate;

@end
