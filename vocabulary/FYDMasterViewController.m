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
    
    [self loadVocabularyBox];
    
    if (self.vocabularyBox == nil)
    {
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

#pragma mark - Vocabulary Test

- (void)testViewControllerDidFinish
{
    [self saveVocabularyBox];
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

#pragma mark - Persistent State

- (NSURL*)applicationDataDirectory
{
    NSFileManager* sharedFM = [NSFileManager defaultManager];
    NSArray* possibleURLs = [sharedFM URLsForDirectory:NSApplicationSupportDirectory
                                             inDomains:NSUserDomainMask];
    NSURL* appSupportDir = nil;
    NSURL* appDirectory = nil;
    
    if ([possibleURLs count] >= 1) {
        // Use the first directory (if multiple are returned)
        appSupportDir = [possibleURLs objectAtIndex:0];
    }
    
    // If a valid app support directory exists, add the
    // app's bundle ID to it to specify the final directory.
    if (appSupportDir) {
        NSString* appBundleID = [[NSBundle mainBundle] bundleIdentifier];
        appDirectory = [appSupportDir URLByAppendingPathComponent:appBundleID];
    }
    
    return appDirectory;
}

- (NSString*) pathToVocabularyBox
{
    NSURL *applicationSupportURL = [self applicationDataDirectory];
    
    if (! [[NSFileManager defaultManager] fileExistsAtPath:[applicationSupportURL path]])
    {
        NSError *error = nil;
        
        [[NSFileManager defaultManager] createDirectoryAtPath:[applicationSupportURL path]
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:&error];
        
        if (error)
        {
            NSLog(@"error creating app support dir: %@", error);
        }
        
    }
    
    NSString *path = [[applicationSupportURL path] stringByAppendingPathComponent:@"VocabularyBox.plist"];
    
    return path;
}

- (void) loadVocabularyBox
{
    self.vocabularyBox = [NSKeyedUnarchiver unarchiveObjectWithFile:[self pathToVocabularyBox]];
}

- (void) saveVocabularyBox
{
    [NSKeyedArchiver archiveRootObject:self.vocabularyBox toFile:[self pathToVocabularyBox]];
}

@end
