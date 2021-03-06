//
//  FYDVocableTest.h
//  vocabulary
//
//  Created by Florian Kaiser on 23.05.13.
//  Copyright (c) 2013 Floyd UG (haftungsbeschränkt). All rights reserved.
//

#import <Foundation/Foundation.h>

@class FYDVocable;
@class FYDVocabularyBox;
@class FYDStage;

@interface FYDVocabularyTest : NSObject

- (id)initWithVocabularies:(NSArray*)stage AndVocabularyBox:(FYDVocabularyBox*)box andPractice:(BOOL)practice;

- (BOOL)nextVocable;

- (void)currentWrong;
- (void)currentCorrect;

- (void)deleteCurrent;

- (FYDStage*)stage;

@property (nonatomic, readonly) FYDVocable *currentVocable;
@property (nonatomic, readonly) BOOL practice;

@end
