//
//  FYDMasterViewController.m
//  vocabulary
//
//  Created by Florian Kaiser on 23.05.13.
//  Copyright (c) 2013 Floyd UG (haftungsbeschränkt). All rights reserved.
//

#import "FYDChooseTestViewController.h"
#import "FYDTabBarController.h"
#import "FYDTestViewController.h"

#import "FYDStageCell.h"
#import "FYDStage.h"
#import "FYDVocable.h"
#import "FYDVocabularyBox.h"
#import "FYDVocabularyTest.h"

@interface FYDChooseTestViewController ()

@property (strong, nonatomic) FYDVocabularyBox *vocabularyBox;

@end

@implementation FYDChooseTestViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(vocableBoxChanged:)
                                                name:FYDTabBarControllerVocableBoxChanged
                                              object:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)vocableBoxChanged:(NSNotification*)notification
{
    [self.tableView reloadData];
}

- (FYDVocabularyBox*)vocabularyBox
{
    return [(FYDTabBarController*)self.tabBarController vocabularyBox];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Delegate

- (void)testViewControllerDidFinish
{
    [(FYDTabBarController*)self.tabBarController saveVocabularyBox];
    [self.tableView reloadData];
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
    FYDStageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    [cell setStage:[self.vocabularyBox stageAt:indexPath.row]];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

#pragma mark - Prepare For Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"startTest"])
    {
        FYDTestViewController *viewController = [[segue.destinationViewController viewControllers] objectAtIndex:0];
        
        viewController.vocableTest = [self.vocabularyBox vocabularyTestForStage:[self.tableView indexPathForSelectedRow].row AndPractice:NO];
        
        viewController.delegate = self;
    }
}

@end
