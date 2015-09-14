//
//  vocabularyTests.m
//  vocabularyTests
//
//  Created by Florian Kaiser on 23.05.13.
//  Copyright (c) 2013 Floyd UG (haftungsbeschränkt). All rights reserved.
//

#import "vocabularyTests.h"

#import "FYDVocabularyBox.h"
#import "FYDStage.h"

@interface vocabularyTests ()

@property (strong, nonatomic) FYDVocabularyBox *vocabularyBox;

@end

@implementation vocabularyTests

- (void)setUp
{
    [super setUp];
    
    self.vocabularyBox = [[FYDVocabularyBox alloc] init];
    [self.vocabularyBox addStage];
    [self.vocabularyBox addStage];
    [self.vocabularyBox addStage];
}

- (void)tearDown
{
    self.vocabularyBox = nil;
    
    [super tearDown];
}

- (void)testExample
{
    XCTAssertEqual(self.vocabularyBox.recommandedStage, [self.vocabularyBox stageAt:0], @"self.box.recommandedStage == [self.box stageAt:0]");
    
    [[self.vocabularyBox stageAt:0] incTestCount];
    
    XCTAssertEqual(self.vocabularyBox.recommandedStage, [self.vocabularyBox stageAt:0], @"self.box.recommandedStage == [self.box stageAt:0]");
    
    [[self.vocabularyBox stageAt:0] incTestCount];
    [[self.vocabularyBox stageAt:0] incTestCount];
    
    XCTAssertEqual(self.vocabularyBox.recommandedStage, [self.vocabularyBox stageAt:1], @"self.box.recommandedStage == [self.box stageAt:1]");
    
    [[self.vocabularyBox stageAt:1] incTestCount];
    
    XCTAssertEqual(self.vocabularyBox.recommandedStage, [self.vocabularyBox stageAt:0], @"self.box.recommandedStage == [self.box stageAt:0]");
    
    [[self.vocabularyBox stageAt:0] incTestCount];
    [[self.vocabularyBox stageAt:0] incTestCount];
    [[self.vocabularyBox stageAt:0] incTestCount];
    
    XCTAssertEqual(self.vocabularyBox.recommandedStage, [self.vocabularyBox stageAt:1], @"self.box.recommandedStage == [self.box stageAt:1]");
    
    [[self.vocabularyBox stageAt:1] incTestCount];
    
    XCTAssertEqual(self.vocabularyBox.recommandedStage, [self.vocabularyBox stageAt:0], @"self.box.recommandedStage == [self.box stageAt:0]");
    
    [[self.vocabularyBox stageAt:0] incTestCount];
    [[self.vocabularyBox stageAt:0] incTestCount];
    [[self.vocabularyBox stageAt:0] incTestCount];
    
    XCTAssertEqual(self.vocabularyBox.recommandedStage, [self.vocabularyBox stageAt:1], @"self.box.recommandedStage == [self.box stageAt:1]");
    
    [[self.vocabularyBox stageAt:1] incTestCount];
    
    XCTAssertEqual(self.vocabularyBox.recommandedStage, [self.vocabularyBox stageAt:2], @"self.box.recommandedStage == [self.box stageAt:2]");
    
    [[self.vocabularyBox stageAt:2] incTestCount];
    
    XCTAssertEqual(self.vocabularyBox.recommandedStage, [self.vocabularyBox stageAt:0], @"self.box.recommandedStage == [self.box stageAt:0]");
    
    [[self.vocabularyBox stageAt:0] incTestCount];
    [[self.vocabularyBox stageAt:0] incTestCount];
    [[self.vocabularyBox stageAt:0] incTestCount];
    [[self.vocabularyBox stageAt:1] incTestCount];
    [[self.vocabularyBox stageAt:0] incTestCount];
    [[self.vocabularyBox stageAt:0] incTestCount];
    [[self.vocabularyBox stageAt:0] incTestCount];
    [[self.vocabularyBox stageAt:1] incTestCount];
    [[self.vocabularyBox stageAt:0] incTestCount];
    [[self.vocabularyBox stageAt:0] incTestCount];
    [[self.vocabularyBox stageAt:0] incTestCount];
    [[self.vocabularyBox stageAt:1] incTestCount];
    
    XCTAssertEqual(self.vocabularyBox.recommandedStage, [self.vocabularyBox stageAt:2], @"self.box.recommandedStage == [self.box stageAt:2]");
    
    [[self.vocabularyBox stageAt:2] incTestCount];
    
    [[self.vocabularyBox stageAt:0] incTestCount];
    [[self.vocabularyBox stageAt:0] incTestCount];
    [[self.vocabularyBox stageAt:0] incTestCount];
    [[self.vocabularyBox stageAt:1] incTestCount];
    [[self.vocabularyBox stageAt:0] incTestCount];
    [[self.vocabularyBox stageAt:0] incTestCount];
    [[self.vocabularyBox stageAt:0] incTestCount];
    [[self.vocabularyBox stageAt:1] incTestCount];
    [[self.vocabularyBox stageAt:0] incTestCount];
    [[self.vocabularyBox stageAt:0] incTestCount];
    [[self.vocabularyBox stageAt:0] incTestCount];
    [[self.vocabularyBox stageAt:1] incTestCount];
    
    XCTAssertEqual(self.vocabularyBox.recommandedStage, [self.vocabularyBox stageAt:2], @"self.box.recommandedStage == [self.box stageAt:2]");
    
    [[self.vocabularyBox stageAt:2] incTestCount];
    
    XCTAssertEqual(self.vocabularyBox.recommandedStage, [self.vocabularyBox stageAt:0], @"self.box.recommandedStage == [self.box stageAt:0]");
    
    [[self.vocabularyBox stageAt:0] incTestCount];
    [[self.vocabularyBox stageAt:0] incTestCount];
    [[self.vocabularyBox stageAt:0] incTestCount];
    
    XCTAssertEqual(self.vocabularyBox.recommandedStage, [self.vocabularyBox stageAt:1], @"self.box.recommandedStage == [self.box stageAt:1]");
}

@end
