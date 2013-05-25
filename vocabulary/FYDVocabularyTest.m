//
//  FYDVocableTest.m
//  vocabulary
//
//  Created by Florian Kaiser on 23.05.13.
//  Copyright (c) 2013 Floyd UG (haftungsbeschränkt). All rights reserved.
//

#import "FYDVocabularyTest.h"

#import "NSMutableArray+Shuffle.h"

#import "FYDVocable.h"
#import "FYDVocabularyBox.h"

@interface FYDVocabularyTest ()

@property (weak,nonatomic) FYDVocabularyBox *vocabularyBox;
@property (strong,nonatomic) NSArray *vocabularies;
@property (strong,nonatomic) NSEnumerator *enumerator;
@property (strong,nonatomic) FYDVocable *currentVocable;

@end

@implementation FYDVocabularyTest

- (id)initWithVocabularies:(NSArray*)vocabularies AndVocabularyBox:(FYDVocabularyBox*)box
{
    if (self = [super init])
    {
        self.vocabularyBox = box;
        self.vocabularies = [[vocabularies mutableCopy] shuffle];
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
    [self.vocabularyBox putIntoFirstStage:self.currentVocable];
}

- (void)currentCorrect
{
    [self.vocabularyBox putIntoNextStage:self.currentVocable];
}

@end
