//
//  FYDMasterViewController.m
//  vocabulary
//
//  Created by Florian Kaiser on 23.05.13.
//  Copyright (c) 2013 Floyd UG (haftungsbeschränkt). All rights reserved.
//

#import "FYDMasterViewController.h"

#import "FYDTestViewController.h"

#import "FYDStageCell.h"
#import "FYDStage.h"
#import "FYDVocable.h"
#import "FYDVocabularyBox.h"
#import "FYDVocabularyTest.h"

@interface FYDMasterViewController ()

@property (strong,nonatomic) FYDVocabularyBox *vocabularyBox;

@end

@implementation FYDMasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.vocabularyBox = [[FYDVocabularyBox alloc] init];
    
    {
        FYDStage *stage = [self.vocabularyBox addStage];
        [stage createVocableWithNative:@"Haus" AndForeign:@"House"];
        [stage createVocableWithNative:@"Teppich" AndForeign:@"Carpet"];
        [stage createVocableWithNative:@"Auto" AndForeign:@"Car"];
    }
    
    {
        FYDStage *stage = [self.vocabularyBox addStage];
        [stage createVocableWithNative:@"Urlaub" AndForeign:@"Holiday"];
        [stage createVocableWithNative:@"Wohnwagen" AndForeign:@"Camper"];
        [stage createVocableWithNative:@"Handy" AndForeign:@"Cellphone"];
        [stage createVocableWithNative:@"Käfig" AndForeign:@"Cage"];
    }
    
    {
        FYDStage *stage = [self.vocabularyBox addStage];
        [stage createVocableWithNative:@"füttern" AndForeign:@"to feed"];
    }
    
    {
        [self.vocabularyBox addStage];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.vocabularyBox.stageCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FYDStageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];

    [cell setStage:[self.vocabularyBox stageAt:indexPath.row]];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (void)testViewControllerDidFinish
{
    [self.tableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"startTest"])
    {
        FYDTestViewController *viewController = [[segue.destinationViewController viewControllers] objectAtIndex:0];
        
        viewController.vocableTest = [self.vocabularyBox vocabularyTestForStage:[self.tableView indexPathForSelectedRow].row];
        
        viewController.delegate = self;
    }
}

@end
