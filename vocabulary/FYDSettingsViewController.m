//
//  FYDSettingsViewController.m
//  vocabulary
//
//  Created by Florian Kaiser on 24.05.13.
//  Copyright (c) 2013 Floyd UG (haftungsbeschränkt). All rights reserved.
//

#import "FYDSettingsViewController.h"

#import <Dropbox/Dropbox.h>

@interface FYDSettingsViewController ()

@property (weak, nonatomic) IBOutlet UITableViewCell *dropboxCell;

@end

@implementation FYDSettingsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if ([[DBAccountManager sharedManager] linkedAccount] != nil)
    {
        self.dropboxCell.textLabel.enabled = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)doneButtonClick:(UIBarButtonItem *)sender
{
    [self.delegate settingsViewControllerDidFinish];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.tableView cellForRowAtIndexPath:indexPath].reuseIdentifier isEqualToString:@"dropbox"] && [[DBAccountManager sharedManager] linkedAccount] == nil)
    {
        [[DBAccountManager sharedManager] linkFromController:self];
    }
}

- (NSIndexPath*)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.tableView cellForRowAtIndexPath:indexPath].reuseIdentifier isEqualToString:@"dropbox"] && [[DBAccountManager sharedManager] linkedAccount] != nil)
    {
        return nil;
    }
    else
    {
        return indexPath;
    }
}

- (void)viewDidUnload
{
    [self setDropboxCell:nil];
    [super viewDidUnload];
}

@end
