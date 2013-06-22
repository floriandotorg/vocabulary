//
//  FYDTabBarController.h
//  vocabulary
//
//  Created by Florian Kaiser on 21.06.13.
//  Copyright (c) 2013 Floyd UG (haftungsbeschränkt). All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FYDVocabularyBox.h"

extern NSString *const FYDTabBarControllerVocableBoxChanged;
extern NSString *const FYDTabBarControllerWaitForSync;

@interface FYDTabBarController : UITabBarController<UITabBarControllerDelegate>

@property (strong, nonatomic) FYDVocabularyBox *vocabularyBox;

- (void)loadVocabularyBox;
- (void)saveVocabularyBox;

@end
