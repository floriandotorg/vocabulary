//
//  FYDVocabularyBox.m
//  vocabulary
//
//  Created by Florian Kaiser on 23.05.13.
//  Copyright (c) 2013 Floyd UG (haftungsbeschränkt). All rights reserved.
//

#import "FYDVocabularyBox.h"

#import "FYDStage.h"
#import "FYDVocable.h"

#ifndef FYD_NO_VOCABULARY_TEST
#import "FYDVocabularyTest.h"
#endif

@interface FYDVocabularyBox ()

@property (assign,nonatomic) NSInteger lastStageNo;
@property (strong,nonatomic) NSMutableArray *stages;
@property (strong,nonatomic) NSMutableArray *learned;

@end

@implementation FYDVocabularyBox

- (id)init
{
    if (self = [super init])
    {
        self.lastStageNo = 0;
        self.stages = [[NSMutableArray alloc] init];
    }
    return self;
}

- (FYDStage*)recommandedStage
{
    for (NSInteger n = 0; n < self.stageCount; ++n)
    {
        if ([self stageAt:n].testCount < 2)
        {
            return self.stages[n];
        }
    }
    
    return self.stages[self.stageCount - 1];
}

- (FYDStage*)addStage
{
    FYDStage *stage = [[FYDStage alloc] initWithNo:++self.lastStageNo inVocabularyBox:self];
    [self.stages addObject:stage];
    return stage;
}

- (NSInteger)stageCount
{
    return self.stages.count;
}

- (FYDStage*)stageAt:(NSInteger)stageNo
{
    return self.stages[stageNo];
}

#ifndef FYD_NO_VOCABULARY_TEST
- (FYDVocabularyTest*)vocabularyTestForStage:(NSInteger)stageNo AndPractice:(BOOL)practice
{
    return [[self stageAt:stageNo] vocabularyTestWithBox:self AndPractice:practice];
}
#endif

- (void)putIntoFirstStage:(FYDVocable*)vocable
{
    if (vocable.stage != self.stages[0])
    {
        [vocable.stage removeVocable:vocable];
        [self.stages[0] addVocable:vocable];
    }
}

- (void)putIntoNextStage:(FYDVocable*)vocable
{
    NSUInteger nextStageNo = [self.stages indexOfObject:vocable.stage] + 1;
    
    [vocable.stage removeVocable:vocable];
    
    if (nextStageNo < self.stages.count)
    {
        [self.stages[nextStageNo] addVocable:vocable];
    }
    else
    {
        [self.learned addObject:vocable];
    }
}

#pragma mark - Persistent State

-(void)encodeWithCoder:(NSCoder *)aCoder
{    
    [aCoder encodeInteger:self.lastStageNo forKey:@"lastStageNo"];
    [aCoder encodeObject:self.stages forKey:@"stages"];
    [aCoder encodeObject:self.learned forKey:@"learned"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        self.lastStageNo = [aDecoder decodeIntegerForKey:@"lastStageNo"];
        self.stages = [aDecoder decodeObjectForKey:@"stages"];
        self.learned = [aDecoder decodeObjectForKey:@"learned"];
        
        for (FYDStage *stage in self.stages)
        {
            stage.vocabularyBox = self;
        }
    }
    
    return self;
}

@end
