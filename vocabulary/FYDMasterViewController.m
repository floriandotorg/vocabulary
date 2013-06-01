//
//  FYDMasterViewController.m
//  vocabulary
//
//  Created by Florian Kaiser on 23.05.13.
//  Copyright (c) 2013 Floyd UG (haftungsbeschränkt). All rights reserved.
//

#import "FYDMasterViewController.h"

#import "DejalActivityView.h"
#import <Dropbox/Dropbox.h>

#import "FYDTestViewController.h"

#import "FYDStageCell.h"
#import "FYDStage.h"
#import "FYDVocable.h"
#import "FYDVocabularyBox.h"
#import "FYDVocabularyTest.h"

@interface FYDMasterViewController ()

@property (strong, nonatomic) FYDVocabularyBox *vocabularyBox;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *plusBotton;
@property (strong, nonatomic) DBFile *file;
@property (weak, nonatomic) FYDTestViewController *currentTest;

@end

@implementation FYDMasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (BOOL)updateActivityView
{
    [self updateDropbox];
    
    if ([[DBFilesystem sharedFilesystem] status] != DBSyncStatusOnline)
    {
        if ([DejalBezelActivityView currentActivityView] == nil)
        {
            [DejalBezelActivityView activityViewForView:self.view withLabel:@"Syncing .."];
        }
        
        self.plusBotton.enabled = NO;
        
        return NO;
    }
    else
    {
        if ([DejalBezelActivityView currentActivityView] != nil)
        {
            [DejalBezelActivityView removeView];
        }
        
        self.plusBotton.enabled = YES;
        
        return YES;
    }
}

- (void)waitForSync
{
    if (self.currentTest != nil)
    {
        [self.currentTest abort];
    }
    
    if ([self updateActivityView] && [self.file update:nil])
    {
        [self loadVocabularyBox];
    }
    else
    {
        [self performSelector:@selector(waitForSync) withObject:self afterDelay:0.5];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self updateDropbox];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(applicationDidBecomeActive:)
                                                name:UIApplicationDidBecomeActiveNotification
                                              object:nil];
    [self waitForSync];
}

- (void)viewDidUnload
{
    [self.file removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self setPlusBotton:nil];
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
    [self updateActivityView];
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
    self.currentTest = nil;
    [self saveVocabularyBox];
    [self.tableView reloadData];
}

- (void)addWordNewWordNative:(NSString*)native Foreign:(NSString*)foreign Example:(NSString*)example
{
    [[self.vocabularyBox stageAt:0]  createVocableWithNative:native AndForeign:foreign AndExample:example];
}

- (void)addWordViewControllerDidFinish
{
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
        
        self.currentTest = viewController;
        
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
        
        if (self.file == nil)
        {
            self.file = [[DBFilesystem sharedFilesystem] openFile:self.vocabularyBoxPath error:nil];
            
            if (self.file == nil)
            {
                self.file = [[DBFilesystem sharedFilesystem] createFile:self.vocabularyBoxPath error:nil];
            }
            
            __block FYDMasterViewController *block_self = self;
            [self.file addObserver:self block:^
                {
                    [block_self waitForSync];
                }];
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

    self.vocabularyBox = [NSKeyedUnarchiver unarchiveObjectWithData:[self.file readData:nil]];
    
    [self.tableView reloadData];
}

- (void) saveVocabularyBox
{
    [self updateDropbox];
    
    [self.file writeData:[NSKeyedArchiver archivedDataWithRootObject:self.vocabularyBox] error:nil];
}

@end
