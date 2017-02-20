//
//  SignUpViewController.h
//  Ecopodium
//
//  Created by Amit Poreli on 31/08/15.
//  Copyright (c) 2015 Amit Poreli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignUpStore.h"

@interface SignUpViewController : UIViewController<UITextFieldDelegate,UIGestureRecognizerDelegate>
{
        NSString *data;
        NSMutableArray *registermessage;
    
    
    
    SignUpStore *rData;
    
    IBOutlet UITextField *nameTextt;
    
    IBOutlet UITextField *passTextt;

    
    __weak IBOutlet UIView *scrollContentView;
    
    __weak IBOutlet UIScrollView *scrollView;
    
}
@property (strong, nonatomic) IBOutlet UITextField *confrmText;
@property (strong, nonatomic) IBOutlet UITextField *emailText;
@property (strong, nonatomic) IBOutlet UITextField *mobileText;

- (IBAction)signUpBtn:(id)sender;

@end
