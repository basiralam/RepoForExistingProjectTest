//
//  ViewController.h
//  Ecopodium
//
//  Created by Amit Poreli on 31/08/15.
//  Copyright (c) 2015 Amit Poreli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginStore.h"
#import <MediaPlayer/MediaPlayer.h>



@interface ViewController : UIViewController<UITextFieldDelegate>

{
    LoginStore *logObj;
    
    IBOutlet UIView *MoviewView;
    
    IBOutlet UIImageView *firstLogo;
    
    IBOutlet UIButton *btnSkip;
    IBOutlet UIView *bottomView;
    IBOutlet UIImageView *topLogo;
    
    IBOutlet UIView *nameBackView;
    
    IBOutlet UIView *passwordBackView;
    
     IBOutlet UIButton *okBtnProperty;
   IBOutlet UIView *eulaView;
    
    
}
@property (strong, nonatomic) IBOutlet UITextField *userNameText;
@property (strong, nonatomic) IBOutlet UITextField *passText;
- (IBAction)signUpBtn:(id)sender;
- (IBAction)loginBtn:(id)sender;
- (IBAction)btnSkip:(UIButton *)sender;
- (IBAction)checkBoxBtn:(UIButton *)sender;
- (IBAction)okBtnActn:(UIButton *)sender;



@end

