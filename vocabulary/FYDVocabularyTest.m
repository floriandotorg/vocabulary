//
//  FYDVocableTest.m
//  vocabulary
//
//  Created by Florian Kaiser on 23.05.13.
//  Copyright (c) 2013 Floyd UG (haftungsbeschränkt). All rights reserved.
//

#import "FYDVocabularyTest.h"

#import "NSMutableArray+Shuffle.h"

#import "FYDStage.h"
#import "FYDVocable.h"
#import "FYDVocabularyBox.h"

@interface FYDVocabularyTest ()

@property (nonatomic, assign) BOOL practice;

@property (strong,nonatomic) FYDVocabularyBox *vocabularyBox;
@property (strong,nonatomic) NSArray *vocabularies;
@property (strong,nonatomic) NSEnumerator *enumerator;
@property (strong,nonatomic) FYDVocable *currentVocable;

@end

@implementation FYDVocabularyTest

- (id)initWithVocabularies:(NSArray*)vocabularies AndVocabularyBox:(FYDVocabularyBox*)box andPractice:(BOOL)practice
{
    if (self = [super init])
    {
        self.practice = practice;
        self.vocabularyBox = box;

        NSMutableArray *voc = [vocabularies mutableCopy];
        [voc shuffle];
        self.vocabularies = voc;
        self.enumerator = [self.vocabularies objectEnumerator];
        
        [self nextVocable];
    }
    return self;
}

- (BOOL)nextVocable
{
    return (self.currentVocable = [self.enumerator nextObject]) != nil;
}

- (void)currentWrong
{
    if (!self.practice)
    {
        NSAssert(self.vocabularyBox != nil, @"currentWrong vocabularyBox == nil");
        [self.vocabularyBox putIntoFirstStage:self.currentVocable];
    }
}

- (void)currentCorrect
{
    if (!self.practice)
    {
        NSAssert(self.vocabularyBox != nil, @"currentCorrect vocabularyBox == nil");
        [self.vocabularyBox putIntoNextStage:self.currentVocable];
    }
}

- (void)deleteCurrent
{
    [self.currentVocable.stage removeVocable:self.currentVocable];
}

- (FYDStage*)stage
{
    return [self.vocabularies[0] stage];
}

@end
