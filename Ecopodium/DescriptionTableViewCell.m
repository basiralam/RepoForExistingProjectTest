//
//  DescriptionTableViewCell.m
//  Ecopodium
//
//  Created by Micronixtraining on 8/18/16.
//  Copyright © 2016 Amit Poreli. All rights reserved.
//

#import "DescriptionTableViewCell.h"

@implementation DescriptionTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    _lblDecription.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor lightGrayColor]);
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
