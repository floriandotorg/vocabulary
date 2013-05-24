//
//  FYDDetailViewController.m
//  vocabulary
//
//  Created by Florian Kaiser on 23.05.13.
//  Copyright (c) 2013 Floyd UG (haftungsbeschränkt). All rights reserved.
//

#import "FYDTestViewController.h"

#import "FYDVocable.h"
#import "FYDVocabularyTest.h"

@interface FYDTestViewController ()

@property (weak, nonatomic) IBOutlet UILabel *wordLabel;
@property (weak, nonatomic) IBOutlet UIButton *correctButton;
@property (weak, nonatomic) IBOutlet UIButton *wrongButton;
@property (weak, nonatomic) IBOutlet UITapGestureRecognizer *labelGestureRecognizer;

@end

@implementation FYDTestViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(applicationWillResignActiveNotification:)
                                                name:UIApplicationWillResignActiveNotification
                                              object:nil];
    
    self.wordLabel.text = self.vocableTest.currentVocable.native;
}

- (void)endTest:(BOOL)animated
{
    [self.delegate testViewControllerDidFinish];
    [self dismissViewControllerAnimated:animated completion:nil];
}

- (void)applicationWillResignActiveNotification:(NSNotification*)notification
{
    [self endTest:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self setWordLabel:nil];
    [self setCorrectButton:nil];
    [self setWrongButton:nil];
    [self setLabelGestureRecognizer:nil];

    [super viewDidUnload];
}

- (void)nextVocable
{
    if (![self.vocableTest nextVocable])
    {
        [self endTest:YES];
    }
    else
    {
        self.wordLabel.text = self.vocableTest.currentVocable.native;
        self.correctButton.hidden = YES;
        self.wrongButton.hidden = YES;
        self.labelGestureRecognizer.enabled = YES;
    }
}

- (IBAction)correctButtonClick:(UIButton *)sender
{
    [self.vocableTest currentCorrect];
    [self nextVocable];
}

- (IBAction)wrongButtonClick:(UIButton *)sender
{
    [self.vocableTest currentWrong];
    [self nextVocable];
}

- (void)wordAnimationDidStop
{
    self.correctButton.hidden = NO;
    self.wrongButton.hidden = NO;
}

- (IBAction)handleTap:(UITapGestureRecognizer *)sender
{
    self.labelGestureRecognizer.enabled = NO;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(wordAnimationDidStop)];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.wordLabel cache:YES];
    self.wordLabel.text = self.vocableTest.currentVocable.foreign;
	[UIView commitAnimations];
}

@end
