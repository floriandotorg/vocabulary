//
//  FYDStage.h
//  vocabulary
//
//  Created by Florian Kaiser on 23.05.13.
//  Copyright (c) 2013 Floyd UG (haftungsbeschränkt). All rights reserved.
//

#import <Foundation/Foundation.h>

@class FYDVocable;
@class FYDVocabularyTest;
@class FYDVocabularyBox;

@interface FYDStage : NSObject

@property (readonly,nonatomic) int no;

- (id)initWithNo:(int)no;

- (NSInteger)vocabularyCount;

- (void)createVocableWithNative:(NSString*)native AndForeign:(NSString*)foreign;

- (void)addVocable:(FYDVocable*)vocable;
- (void)removeVocable:(FYDVocable*)vocable;

- (FYDVocabularyTest*)vocabularyTestWithBox:(FYDVocabularyBox*)box;

@end
