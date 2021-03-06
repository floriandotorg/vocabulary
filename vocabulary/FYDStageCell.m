//
//  FYDStageCell.m
//  vocabulary
//
//  Created by Florian Kaiser on 23.05.13.
//  Copyright (c) 2013 Floyd UG (haftungsbeschränkt). All rights reserved.
//

#import "FYDStageCell.h"

#import "FYDStage.h"

@interface FYDStageCell ()

@property (weak, nonatomic) IBOutlet UILabel *stageTitelLabel;
@property (weak, nonatomic) IBOutlet UILabel *stageWordsLabel;
@property (weak, nonatomic) IBOutlet UILabel *recommandedLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end

@implementation FYDStageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setStage:(FYDStage*)stage;
{
    self.stageTitelLabel.text = [NSString stringWithFormat:@"Stage %ld", stage.no];
    self.stageWordsLabel.text = [NSString stringWithFormat:@"%ld words", stage.vocabularyCount];
    
    if (stage.recommanded)
    {
        self.recommandedLabel.hidden = NO;
    }
    else
    {
        self.recommandedLabel.hidden = YES;
    }
    
    self.countLabel.text = [NSString stringWithFormat:@"%ld", stage.testCount];
    
    if (stage.vocabularyCount < 1)
    {
        self.userInteractionEnabled = NO;
        self.stageTitelLabel.enabled = NO;
        self.stageWordsLabel.enabled = NO;
    }
    else
    {
        self.userInteractionEnabled = YES;
        self.stageTitelLabel.enabled = YES;
        self.stageWordsLabel.enabled = YES;
    }
}

@end
