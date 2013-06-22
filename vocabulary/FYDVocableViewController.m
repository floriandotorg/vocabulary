//
//  FYDAddVocableViewController.m
//  vocabulary
//
//  Created by Florian Kaiser on 25.05.13.
//  Copyright (c) 2013 Floyd UG (haftungsbeschränkt). All rights reserved.
//

#import "FYDVocableViewController.h"

#import "NSString+Empty.h"
#import "FYDVocable.h"

@interface FYDVocableViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nativeTextField;
@property (weak, nonatomic) IBOutlet UITextField *foreignTextField;
@property (weak, nonatomic) IBOutlet UITextField *exampleTextField;

@property (assign, nonatomic) BOOL didEdit;

@end

@implementation FYDVocableViewController

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
    
    self.didEdit = NO;

    if (self.vocable != nil)
    {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(trashButtonClick:)];
        
        self.nativeTextField.text = self.vocable.native;
        self.foreignTextField.text = self.vocable.foreign;
        self.exampleTextField.text = self.vocable.foreign_example;
    }
    else
    {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonClick:)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(nextButtonClick:)];
    }
}

- (BOOL)stringEqual:(NSString*)str1 to:(NSString*)str2
{
    return (str1 == nil && str2 == nil) || [str1 isEqualToString:str2];
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (self.vocable != nil)
    {
        if (![self stringEqual:self.vocable.native to:self.nativeTextField.text])
        {
            self.vocable.native = self.nativeTextField.text;
            self.didEdit = YES;
        }
        
        if (![self stringEqual:self.vocable.foreign to:self.foreignTextField.text])
        {
            self.vocable.foreign = self.foreignTextField.text;
            self.didEdit = YES;
        }
        
        if (![self stringEqual:self.vocable.foreign_example to:self.exampleTextField.text])
        {
            self.vocable.foreign_example = self.exampleTextField.text;
            self.didEdit = YES;
        }
    }
    
    [self.delegate vocableViewController:self didFinishAndEdited:self.didEdit];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)newVocable
{
    if (![self.nativeTextField.text isEmpty] && ![self.foreignTextField.text isEmpty])
    {
        [self.delegate vocableViewController:self addVocableNative:self.nativeTextField.text Foreign:self.foreignTextField.text Example:self.exampleTextField.text];
        
        self.nativeTextField.text = @"";
        self.foreignTextField.text = @"";
        self.exampleTextField.text = @"";
        
        self.didEdit = YES;
    }
}

- (void)nextButtonClick:(UIBarButtonItem *)sender
{
    [self newVocable];
}

- (void)doneButtonClick:(UIBarButtonItem *)sender
{
    [self newVocable];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)trashButtonClick:(UIBarButtonItem *)sender
{
    self.didEdit = YES;
    [self.delegate vocableViewController:self removeVocable:self.vocable];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [self setNativeTextField:nil];
    [self setForeignTextField:nil];
    [self setExampleTextField:nil];
    [super viewDidUnload];
}

@end
