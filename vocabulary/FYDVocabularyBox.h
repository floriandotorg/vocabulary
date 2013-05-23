//
//  FYDVocabularyBox.h
//  vocabulary
//
//  Created by Florian Kaiser on 23.05.13.
//  Copyright (c) 2013 Floyd UG (haftungsbeschränkt). All rights reserved.
//

#import <Foundation/Foundation.h>

@class FYDStage;
@class FYDVocable;
@class FYDVocabularyTest;

@interface FYDVocabularyBox : NSObject

- (id) init;

- (FYDStage*) addStage;

- (NSInteger) stageCount;
- (FYDStage*) stageAt:(NSInteger)stageNo;

- (FYDVocabularyTest*) vocabularyTestForStage:(NSInteger)stageNo;

- (void)putIntoFirstStage:(FYDVocable*)vocable;
- (void)putIntoNextStage:(FYDVocable*)vocable;

@end
