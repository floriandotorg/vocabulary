//
//  FYDEditViewController.m
//  vocabulary
//
//  Created by Florian Kaiser on 21.06.13.
//  Copyright (c) 2013 Floyd UG (haftungsbeschränkt). All rights reserved.
//

#import "FYDEditViewController.h"

#import "FYDTabBarController.h"
#import "FYDVocableCell.h"
#import "FYDVocable.h"
#import "FYDVocabularyBox.h"
#import "FYDStage.h"

@interface FYDEditViewController ()

@property (strong, nonatomic) NSMutableArray *sortedVocabularyMap;

@end

@implementation FYDEditViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    self.sortedVocabularyMap = [[NSMutableArray alloc] init];
    [self updateSortedVocabularyMap];
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)vocableBoxChanged:(NSNotification*)notification
{
    [self reloadData];
}

#pragma mark - Helper

- (FYDVocabularyBox*)vocabularyBox
{
    return [(FYDTabBarController*)self.tabBarController vocabularyBox];
}

- (void)updateSortedVocabularyMap
{
    [self.sortedVocabularyMap removeAllObjects];
    
    for (NSInteger n = 0; n < self.vocabularyBox.stageCount; ++n)
    {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        
        FYDStage *stage = [self.vocabularyBox stageAt:n];
        
        for (NSInteger m = 0; m < stage.vocabularyCount; ++m)
        {
            [array addObject:[NSNumber numberWithInteger:m]];
        }
        
        [array sortUsingComparator:^NSComparisonResult(id obj1, id obj2)
         {             
             return [[stage vocableAt:[array indexOfObject:obj1]].foreign localizedCaseInsensitiveCompare:[stage vocableAt:[array indexOfObject:obj2]].foreign];
         }];
        
        [self.sortedVocabularyMap addObject:array];
    }
}

- (void)reloadData
{
    [self updateSortedVocabularyMap];
    [self.tableView reloadData];
}

- (FYDVocable*)vocableForIndexPath:(NSIndexPath*)indexPath
{
    return [[self.vocabularyBox stageAt:indexPath.section] vocableAt:[self.sortedVocabularyMap[indexPath.section][indexPath.row] integerValue]];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.vocabularyBox.stageCount;
}

- (NSInteger)vocableCount
{
    NSInteger result = 0;
    
    for (NSInteger n = 0; n < self.vocabularyBox.stageCount; ++n)
    {
        result += [self.vocabularyBox stageAt:n].vocabularyCount;
    }
    
    return result;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.vocabularyBox stageAt:section].vocabularyCount;
}

- (FYDVocable*)vocableAt:(NSInteger)no
{
    NSInteger vocableCount = 0;
    
    for (NSInteger n = 0; n < self.vocabularyBox.stageCount; ++n)
    {
        FYDStage *stage = [self.vocabularyBox stageAt:n];
        
        if (no < vocableCount + stage.vocabularyCount)
        {
            return [stage vocableAt:no - vocableCount];
        }
        
        vocableCount += stage.vocabularyCount;
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FYDVocableCell *cell = nil;
    
    if ([tableView respondsToSelector:@selector(dequeueReusableCellWithIdentifier:forIndexPath:)])
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"VocableCell" forIndexPath:indexPath];
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"VocableCell"];
    }
    
    [cell setVocable:[self vocableForIndexPath:indexPath]];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"Stage %ld", section + 1];
}

#pragma mark - Vocable View Controller

- (void)vocableViewController:(FYDVocableViewController *)viewController didFinishAndEdited:(BOOL)edited
{
    if (edited == YES)
    {
        [(FYDTabBarController*)self.tabBarController saveVocabularyBox];
        [self reloadData];
    }
}

- (void)vocableViewController:(FYDVocableViewController *)viewController addVocableNative:(NSString *)native Foreign:(NSString *)foreign Example:(NSString *)example
{
    [[self.vocabularyBox stageAt:0]  createVocableWithNative:native AndForeign:foreign AndExample:example];
    [(FYDTabBarController*)self.tabBarController saveVocabularyBox];
}

- (void)vocableViewController:(FYDVocableViewController *)viewController removeVocable:(FYDVocable *)vocable
{
    [vocable.stage removeVocable:vocable];
}

#pragma mark - Prepare For Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"modalToNewVocable"])
    {
        FYDVocableViewController *viewController = [[segue.destinationViewController viewControllers] objectAtIndex:0];
        viewController.delegate = self;
    }
    else if ([[segue identifier] isEqualToString:@"pushToVocable"])
    {
        FYDVocableViewController *viewController = segue.destinationViewController;
        viewController.delegate = self;
        viewController.vocable = [self vocableForIndexPath:self.tableView.indexPathForSelectedRow];
    }
}

@end
