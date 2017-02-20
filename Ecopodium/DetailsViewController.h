//
//  DetailsViewController.h
//  Ecopodium
//
//  Created by Micronixtraining on 8/18/16.
//  Copyright © 2016 Amit Poreli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailsViewController : UIViewController<UITextViewDelegate>
{
    IBOutlet UITextView *comentTypingTextVw;
}
- (IBAction)btnSendComment:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIView *commentBgVw;
@property (strong, nonatomic) IBOutlet UIView *tableBgVw;
@property(nonatomic,strong) NSString *loc_id;
@property (nonatomic, assign) NSUInteger index;


@end
