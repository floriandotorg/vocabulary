//
//  FYDAddWordViewController.m
//  vocabulary
//
//  Created by Florian Kaiser on 25.05.13.
//  Copyright (c) 2013 Floyd UG (haftungsbeschränkt). All rights reserved.
//

#import "FYDAddWordViewController.h"

@interface FYDAddWordViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nativeTextField;
@property (weak, nonatomic) IBOutlet UITextField *foreignTextField;

@end

@implementation FYDAddWordViewController

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doneButtonClick:(UIBarButtonItem *)sender
{
    [self.delegate addWordControllerDidFinishNative:self.nativeTextField.text Foreign:self.foreignTextField.text];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelButtonClick:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidUnload {
    [self setNativeTextField:nil];
    [self setForeignTextField:nil];
    [super viewDidUnload];
}
@end
