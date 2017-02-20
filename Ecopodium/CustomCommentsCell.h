//
//  CustomCommentsCell.h
//  Ecopodium
//
//  Created by Micronixtraining on 8/18/16.
//  Copyright © 2016 Amit Poreli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCommentsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *commentsLBl;
@property (weak, nonatomic) IBOutlet UIButton *commentsBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIButton *reportBtn;
@property (weak, nonatomic) IBOutlet UIButton *twitrBtnActn;
@property (strong, nonatomic) IBOutlet UILabel *lblPostedBy;
@property (strong, nonatomic) IBOutlet UIImageView *postImage;

@end
