//
//  FYDVocableCell.m
//  vocabulary
//
//  Created by Florian Kaiser on 22.06.13.
//  Copyright (c) 2013 Floyd UG (haftungsbeschränkt). All rights reserved.
//

#import "FYDVocableCell.h"

@interface FYDVocableCell ()

@property (weak, nonatomic) IBOutlet UILabel *foreignLabel;
@property (weak, nonatomic) IBOutlet UILabel *nativeLabel;
@property (weak, nonatomic) IBOutlet UILabel *exampleLabel;

@end

@implementation FYDVocableCell

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

    // Configure the view for the selected state
}

- (void)setVocable:(FYDVocable*)vocable
{
    self.foreignLabel.text = vocable.foreign;
    self.nativeLabel.text = vocable.native;
    self.exampleLabel.text = vocable.foreign_example;
}

@end
