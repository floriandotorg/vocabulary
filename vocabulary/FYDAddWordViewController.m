//
//  FYDAddWordViewController.m
//  vocabulary
//
//  Created by Florian Kaiser on 25.05.13.
//  Copyright (c) 2013 Floyd UG (haftungsbeschränkt). All rights reserved.
//

#import "FYDAddWordViewController.h"

#import "NSString+Empty.h"

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

- (void)newWord
{
    if (![self.nativeTextField.text isEmpty] && ![self.foreignTextField.text isEmpty])
    {
        [self.delegate addWordNewWordNative:self.nativeTextField.text Foreign:self.foreignTextField.text];
        self.nativeTextField.text = @"";
        self.foreignTextField.text = @"";
    }
}

- (IBAction)nextButtonClick:(UIBarButtonItem *)sender
{
    [self newWord];
}

- (IBAction)doneButtonClick:(UIBarButtonItem *)sender
{
    [self newWord];
    
    [self.delegate addWordViewControllerDidFinish];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidUnload {
    [self setNativeTextField:nil];
    [self setForeignTextField:nil];
    [super viewDidUnload];
}
@end
