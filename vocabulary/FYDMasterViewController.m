//
//  FYDMasterViewController.m
//  vocabulary
//
//  Created by Florian Kaiser on 23.05.13.
//  Copyright (c) 2013 Floyd UG (haftungsbeschränkt). All rights reserved.
//

#import "FYDMasterViewController.h"

#import <Dropbox/Dropbox.h>

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
    
    [self updateDropbox];
    
    [[DBFilesystem sharedFilesystem] addObserver:self forPath:self.vocabularyBoxPath block:^
     {
         [self loadVocabularyBox];
     }];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(applicationDidBecomeActive:)
                                                name:UIApplicationDidBecomeActiveNotification
                                              object:nil];
}

- (void)viewDidUnload
{
    [[DBFilesystem sharedFilesystem] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Delegate

- (void)applicationDidBecomeActive:(NSNotification*)notification
{
    [self loadVocabularyBox];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self performSegueWithIdentifier:@"modalToSettings" sender:self];
}

- (void)settingsViewControllerDidFinish
{
    [self loadVocabularyBox];
}

- (void)testViewControllerDidFinish
{
    [self saveVocabularyBox];
    [self.tableView reloadData];
}

- (void)addWordControllerDidFinishNative:(NSString *)native Foreign:(NSString *)foreign
{
    [[self.vocabularyBox stageAt:0] addVocable:[[FYDVocable alloc] initWithNative:native AndForeign:foreign AndStage:[self.vocabularyBox stageAt:0]]];
    [self saveVocabularyBox];
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
    FYDStageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];

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
        
        viewController.vocableTest = [self.vocabularyBox vocabularyTestForStage:[self.tableView indexPathForSelectedRow].row];
        
        viewController.delegate = self;
    }
    else if ([[segue identifier] isEqualToString:@"modalToSettings"])
    {
        FYDSettingsViewController *viewController = [[segue.destinationViewController viewControllers] objectAtIndex:0];
        viewController.delegate = self;
    }
    else if ([[segue identifier] isEqualToString:@"modalToAddWord"])
    {
        FYDAddWordViewController *viewController = [[segue.destinationViewController viewControllers] objectAtIndex:0];
        viewController.delegate = self;
    }
}

#pragma mark - Persistent State

- (void)updateDropbox
{
    DBAccount *account = [DBAccountManager sharedManager].linkedAccount;
    
    if (account == nil)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Dropbox"
                                                        message:@"You need to link your Dropbox account to use this app."
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"Goto Settings",nil];
        [alert show];
    }
    else
    {
        if ([DBFilesystem sharedFilesystem] == nil)
        {
            DBFilesystem *filesystem = [[DBFilesystem alloc] initWithAccount:account];
            [DBFilesystem setSharedFilesystem:filesystem];
        }
    }
}

- (DBPath*)vocabularyBoxPath
{
    return [[DBPath root] childPath:@"VocabularyBox.plist"];
}

- (void) loadVocabularyBox
{
    [self updateDropbox];
    
    DBFile *file = [[DBFilesystem sharedFilesystem] openFile:self.vocabularyBoxPath error:nil];
    
    if (file != nil)
    {
        self.vocabularyBox = [NSKeyedUnarchiver unarchiveObjectWithData:[file readData:nil]];
    }
    
    [file close];
    
    [self.tableView reloadData];
}

- (void) saveVocabularyBox
{
    [self updateDropbox];
    
    DBFile *file = [[DBFilesystem sharedFilesystem] openFile:self.vocabularyBoxPath error:nil];
    
    if (file == nil)
    {
        [[DBFilesystem sharedFilesystem] createFile:self.vocabularyBoxPath error:nil];
    }
    
    [file writeData:[NSKeyedArchiver archivedDataWithRootObject:self.vocabularyBox] error:nil];
    
    [file close];
}

@end
