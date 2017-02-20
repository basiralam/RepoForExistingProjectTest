//
//  CommentsTableViewCell.h
//  Ecopodium
//
//  Created by Micronixtraining on 8/18/16.
//  Copyright © 2016 Amit Poreli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentsTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblComment;
@property (strong, nonatomic) IBOutlet UILabel *lblCommentedBy;
@property (strong, nonatomic) IBOutlet UIImageView *commentImage;

@end
