//
//  FYDStage.m
//  vocabulary
//
//  Created by Florian Kaiser on 23.05.13.
//  Copyright (c) 2013 Floyd UG (haftungsbeschränkt). All rights reserved.
//

#import "FYDStage.h"

#import "FYDVocable.h"
#import "FYDVocabularyTest.h"

@interface FYDStage ()

@property (assign,nonatomic) int no;
@property (strong,nonatomic) NSMutableArray *vocabularies;

@end

@implementation FYDStage

- (id)initWithNo:(int)no;
{
    if (self = [super init])
    {
        self.vocabularies = [[NSMutableArray alloc] init];
        self.no = no;
    }
    return self;
}

- (void)createVocableWithNative:(NSString*)native AndForeign:(NSString*)foreign;
{
    [self.vocabularies addObject:[[FYDVocable alloc] initWithNative:native AndForeign:foreign AndStage:self]];
}

- (void)addVocable:(FYDVocable*)vocable
{
    vocable.stage = self;
    [self.vocabularies addObject:vocable];
}

- (void)removeVocable:(FYDVocable*)vocable
{
    vocable.stage = nil;
    [self.vocabularies removeObject:vocable];
}

- (NSInteger)vocabularyCount
{
    return self.vocabularies.count;
}

- (FYDVocabularyTest*)vocabularyTestWithBox:(FYDVocabularyBox*)box
{
    return [[FYDVocabularyTest alloc] initWithVocabularies:self.vocabularies AndVocabularyBox:box];
}

@end
