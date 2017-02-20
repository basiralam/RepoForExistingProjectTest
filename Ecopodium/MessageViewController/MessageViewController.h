//
//  MessageViewController.h
//  Ecopodium
//
//  Created by Amit Poreli on 31/08/15.
//  Copyright (c) 2015 Amit Poreli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageStore.h"

@protocol MyJsonParseProtocall;

@protocol MyJsonParseProtocall <NSObject>

-(void)reloadMyTable;

@end

@interface MessageViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate>
{
    
    IBOutlet UIView *locationBackView;

    IBOutlet UIView *messageBackView;
}
@property (nonatomic, strong) id<MyJsonParseProtocall> deligate;


@property (strong, nonatomic) IBOutlet UITextField *locationText;
@property (strong, nonatomic) IBOutlet UITextView *messageTextView;
@property (strong, nonatomic) IBOutlet UIButton *postBtn;
- (IBAction)btnPostBack:(UIButton *)sender;


- (IBAction)postActionBtn:(id)sender;


@end
