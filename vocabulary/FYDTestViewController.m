//
//  FYDDetailViewController.m
//  vocabulary
//
//  Created by Florian Kaiser on 23.05.13.
//  Copyright (c) 2013 Floyd UG (haftungsbeschränkt). All rights reserved.
//

#import "FYDTestViewController.h"

#import "FYDVocable.h"
#import "FYDStage.h"
#import "FYDVocabularyTest.h"

#import "FYDTabBarController.h"

@interface FYDTestViewController ()

@property (weak, nonatomic) IBOutlet UIView *cardView;
@property (weak, nonatomic) IBOutlet UILabel *wordLabel;
@property (weak, nonatomic) IBOutlet UILabel *exampleLabel;
@property (weak, nonatomic) IBOutlet UIButton *correctButton;
@property (weak, nonatomic) IBOutlet UIButton *wrongButton;
@property (weak, nonatomic) IBOutlet UITapGestureRecognizer *labelGestureRecognizer;
@property (weak, nonatomic) IBOutlet UIButton *speakerButton;

@property (strong, nonatomic) ISSpeechSynthesis *speechSynthesis;

@end

@implementation FYDTestViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.speechSynthesis = [[ISSpeechSynthesis alloc] init];
    self.speechSynthesis.delegate = self;
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(waitForSync:)
                                                name:FYDTabBarControllerWaitForSync
                                              object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(applicationWillResignActiveNotification:)
                                                name:UIApplicationWillResignActiveNotification
                                              object:nil];

    [self showForeignNative];
}

- (void)showForeign
{
    self.wordLabel.text = self.vocableTest.currentVocable.foreign;
    self.exampleLabel.text = self.vocableTest.currentVocable.foreign_example;
    
    self.speechSynthesis.text = self.vocableTest.currentVocable.foreign;
    self.speechSynthesis.voice = ISVoiceUSEnglishFemale;
}

- (void)showNative
{
    self.wordLabel.text = self.vocableTest.currentVocable.native;
    self.exampleLabel.text = @"";
    
    self.speechSynthesis.text = self.vocableTest.currentVocable.native;
    self.speechSynthesis.voice = ISVoiceEURGermanFemale;
}

- (void)showForeignNative
{
    if (drand48() > 0.5)
    {
        [self showForeign];
    }
    else
    {
        [self showNative];
    }
}

- (void)toggelForeignNative
{
    if ([self.wordLabel.text isEqualToString:self.vocableTest.currentVocable.native])
    {
        [self showForeign];
    }
    else
    {
        [self showNative];
    }
}

- (void)waitForSync:(NSNotification*)notification
{
    [self abort];
}

- (void)abort
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)endTest:(BOOL)animated
{
    [self.vocableTest.stage incTestCount];
    
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

    [self setSpeakerButton:nil];
    [self setExampleLabel:nil];
    [self setCardView:nil];
    [super viewDidUnload];
}

- (IBAction)speakerButtonClick:(UIButton *)sender
{
    [self.speechSynthesis speak:nil];
}

- (void)nextVocable
{
    if (![self.vocableTest nextVocable])
    {
        [self endTest:YES];
    }
    else
    {
        [self showForeignNative];
        
        self.correctButton.hidden = YES;
        self.wrongButton.hidden = YES;
        self.labelGestureRecognizer.enabled = YES;
    }
}
- (IBAction)stopButtonClick:(UIButton *)sender
{
    [self endTest:YES];
}

- (IBAction)trashButtonClick:(UIButton *)sender
{
    [self.vocableTest deleteCurrent];
    [self nextVocable];
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

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (CGRectContainsPoint(self.cardView.frame, [touch locationInView:self.view]) && !CGRectContainsPoint(self.speakerButton.frame, [touch locationInView:self.view]) )
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (IBAction)handleTap:(UITapGestureRecognizer *)sender
{
    self.labelGestureRecognizer.enabled = NO;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(wordAnimationDidStop)];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.cardView cache:YES];
    [self toggelForeignNative];
    [UIView commitAnimations];
}

@end
