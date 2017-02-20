//
//  SignUpViewController.m
//  Ecopodium
//
//  Created by Amit Poreli on 31/08/15.
//  Copyright (c) 2015 Amit Poreli. All rights reserved.
//

#import "SignUpViewController.h"
#import "PostListViewController.h"
#import "URL.h"
#import "HUD.h"
#import "DataFetch.h"


@interface SignUpViewController ()<ProcessDataDelegate>

@end

@implementation SignUpViewController

{
    DataFetch *_dataFetch;
    PostListViewController *post;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"Registration";
    nameTextt.delegate=self;
    passTextt.delegate=self;
    _confrmText.delegate=self;
    _emailText.delegate=self;
    _mobileText.delegate=self;
    
    rData=[SignUpStore SignUpClassObj];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
    // Do any additional setup after loading the view.
    
    // [self setScreenSize];
    _dataFetch = [[DataFetch alloc]init];
    _dataFetch.delegate = self;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [nameTextt resignFirstResponder];
    [passTextt resignFirstResponder];
    [_confrmText resignFirstResponder];
    [_emailText resignFirstResponder];
    [_mobileText resignFirstResponder];
    
    return YES;
}


-(void)setScreenSize
{
    
    CGSize result = [[UIScreen mainScreen] bounds].size;
    if(result.height == 667)
    {
        // set frame for iphone 6
        
        scrollContentView.frame = CGRectMake(0, 60, self.view.frame.size.width, scrollContentView.frame.size.height);
        scrollView.contentSize = CGSizeMake(self.view.frame.size.width, scrollContentView.frame.size.height+30);
    }
    else if (result.height == 736)
    {
        // set frame for iphone 6 plus..
        scrollContentView.frame = CGRectMake(0, 80, self.view.frame.size.width, scrollContentView.frame.size.height);
        scrollView.contentSize = CGSizeMake(self.view.frame.size.width, scrollContentView.frame.size.height+60);
    }
    else{
        
        scrollContentView.frame = CGRectMake(0, 0, self.view.frame.size.width, scrollContentView.frame.size.height);
        scrollView.contentSize = CGSizeMake(self.view.frame.size.width, scrollContentView.frame.size.height-20);
    }
    
    [scrollView addSubview:scrollContentView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)signUpBtn:(id)sender
{
    rData.username=nameTextt.text;
    rData.password=passTextt.text;
    rData.confromPass=_confrmText.text;
    rData.email=_emailText.text;
    rData.mobile=_mobileText.text;
    
    [self signUpDetail];
}

- (void)signUpDetail
{
    if (nameTextt.text.length == 0)
    {
        [self alertmethod];
        
    }
    else if (passTextt.text.length == 0)
    {
        [self alertmethod];
    }
    else if (_confrmText.text.length == 0)
    {
        [self alertmethod];
    }
    else if (_emailText.text.length == 0)
    {
        [self alertmethod];
    }
    
    /*Commented After Client request*/
    
    //    else if (_mobileText.text.length == 0)
    //    {
    //        [self alertmethod];
    //    }
    
    if (nameTextt.text.length >0 && passTextt.text.length >0 && _confrmText.text.length>0&& _emailText.text.length>0 )
    {
        if (![passTextt.text isEqualToString:_confrmText.text]) {
            
            UIAlertView *passwordnotmatch =[[UIAlertView alloc]initWithTitle:@"ecoPodium App" message:@"Sorry!!Password is mismatching" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [passwordnotmatch show];
        }
        
        else
        {
            NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
            NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
            if  ([emailTest evaluateWithObject:_emailText.text] != YES && [_emailText.text length]!=0)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ecoPodium App" message:@"Please enter valid email address" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                
            }
            else
            {
                
                //[self signupJsonParse];
                [self regPost];
            }
            
        }
    }
    else
        
    {
        
        [self alertmethod];
        
    }
    
}

-(void)regPost{
    
    [HUD showUIBlockingIndicatorWithText:@"Loading.."];
    //NSString *savedValue;
    NSMutableDictionary *regDic = [[NSMutableDictionary alloc] init];
    NSString *url = @"http://www.appsforcompany.com/ecopodium/app/post.php";
    NSString *str=@"register";
    [regDic setObject:str forKey:@"actiontype"];
    [regDic setObject:nameTextt.text forKey:@"u_name"];
    [regDic setObject:_emailText.text forKey:@"email"];
    [regDic setObject:passTextt.text forKey:@"password"];
    [regDic setObject:_mobileText.text forKey:@"mobile"];
    
    NSLog(@"%@",regDic);
    
    [_dataFetch request:url :@"POST" :regDic :@"RegDetails" :@"json"];
}



-(void) alertmethod
{
    UIAlertView *fillall =[[UIAlertView alloc]initWithTitle:@"ecoPodium App" message:@"Please fill all the fields." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [fillall show];
    
}
- (void) processSuccessful :(NSDictionary *)data1 :(NSString *)JsonFor{
    
    
    NSLog(@"%@",data1);
    [HUD hideUIBlockingIndicator];
    
    
    if([[data1 valueForKeyPath:@"data.status" ] isEqualToString:@"An user is already registered with this mail ID"])
    {
        UIAlertView *regfail =[[UIAlertView alloc]initWithTitle:@"ecoPodium App" message:@"Sorry!! This emailid has been already in use.Please try with another." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [regfail show];
        
    }
    else
    {
        
        NSLog(@"%@",data1);
        UIAlertView *regsucess =[[UIAlertView alloc]initWithTitle:@"ecoPodium App" message:@"Thank you for registration. Share your environment by posting your news. Go deeper by clicking \"More\" to elaborate your details,comments or add a photo. Enjoy!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [regsucess show];
        //[self.navigationController popToRootViewControllerAnimated:YES];
        
        [[NSUserDefaults standardUserDefaults] setObject:rData.email forKey:@"userNameKey"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[NSUserDefaults standardUserDefaults] setObject:rData.password forKey:@"passwordKey"];
        [[NSUserDefaults standardUserDefaults] synchronize];

        
        [[NSUserDefaults standardUserDefaults] setObject:[data1 valueForKey:@"data"] forKey:@"userData"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[NSUserDefaults standardUserDefaults] setObject:@"Yes" forKey:@"login"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        post =[self.storyboard instantiateViewControllerWithIdentifier:@"PostListViewController"];
        [self.navigationController pushViewController:post animated:YES];
    }
    
    //    [self signupJsonParse];
}



@end
