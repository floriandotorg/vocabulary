//
//  FYDTabBarController.m
//  vocabulary
//
//  Created by Florian Kaiser on 21.06.13.
//  Copyright (c) 2013 Floyd UG (haftungsbeschränkt). All rights reserved.
//

#import "FYDTabBarController.h"

#import <Dropbox/Dropbox.h>
#import "DejalActivityView.h"

NSString *const FYDTabBarControllerVocableBoxChanged = @"FYDTabBarControllerVocableBoxChanged";
NSString *const FYDTabBarControllerWaitForSync = @"FYDTabBarControllerWaitForSync";

@interface FYDTabBarController ()

@property (strong, nonatomic) DBFile *file;
@property (strong, nonatomic) UIAlertView *alertView;

@end

@implementation FYDTabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.delegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    srand48(time(0));
    
    [self updateDropbox];
    
    self.selectedIndex = 1;
    
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)updateActivityView
{
    [self updateDropbox];
    
    if ([DBFilesystem sharedFilesystem].status.anyInProgress)
    {
        if ([DejalBezelActivityView currentActivityView] == nil)
        {
             [[NSNotificationCenter defaultCenter] postNotificationName:FYDTabBarControllerWaitForSync object:self];
            
            [DejalBezelActivityView activityViewForView:self.view withLabel:@"Syncing .."];
        }
        
        return NO;
    }
    else
    {
        if ([DejalBezelActivityView currentActivityView] != nil)
        {
            [DejalBezelActivityView removeView];
        }
        
        return YES;
    }
}

- (void)waitForSync
{
    if ([DBAccountManager sharedManager].linkedAccount == nil)
    {
        if (self.alertView == nil || !self.alertView.visible)
        {
            self.alertView = [[UIAlertView alloc] initWithTitle:@"Dropbox"
                                                            message:@"You need to link your Dropbox account to use this app."
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"Goto Settings",nil];
            [self.alertView show];
        }
    }
    else
    {
        if ([self updateActivityView] && [self.file update:nil])
        {
            [self loadVocabularyBox];
        }
        else
        {
            [self performSelector:@selector(waitForSync) withObject:self afterDelay:0.5];
        }
    }
}

- (void)applicationDidBecomeActive:(NSNotification*)notification
{
    [self waitForSync];
}

#pragma mark - Persistent State

- (void)updateDropbox
{
    DBAccount *account = [DBAccountManager sharedManager].linkedAccount;

    if ([DBFilesystem sharedFilesystem] == nil)
    {
        DBFilesystem *filesystem = [[DBFilesystem alloc] initWithAccount:account];
        [DBFilesystem setSharedFilesystem:filesystem];
    }
    
    if (self.file == nil)
    {
        NSError *error;
        self.file = [[DBFilesystem sharedFilesystem] openFile:self.vocabularyBoxPath error:&error];
        
        if (error) {
            NSLog(@"%@", error.localizedDescription);
        }
        
        if (self.file == nil)
        {
            NSError *error;
            self.file = [[DBFilesystem sharedFilesystem] createFile:self.vocabularyBoxPath error:&error];
            if (error) {
                NSLog(@"%@", error.localizedDescription);
            }
        }
        
        __block FYDTabBarController *block_self = self;
        [self.file addObserver:self block:^
         {
             [block_self waitForSync];
         }];
    }
}

- (DBPath*)vocabularyBoxPath
{
    return [[DBPath root] childPath:@"VocabularyBox.plist"];
}

- (void)loadVocabularyBox
{
    [self updateDropbox];
    
    self.vocabularyBox = [NSKeyedUnarchiver unarchiveObjectWithData:[self.file readData:nil]];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:FYDTabBarControllerVocableBoxChanged object:self];
}

- (void)saveVocabularyBox
{
    [self updateDropbox];
    
    [self.file writeData:[NSKeyedArchiver archivedDataWithRootObject:self.vocabularyBox] error:nil];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    self.selectedIndex = 3;
}

@end
