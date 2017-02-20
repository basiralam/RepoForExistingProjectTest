//
//  ViewController.m
//  Ecopodium
//
//  Created by Amit Poreli on 31/08/15.
//  Copyright (c) 2015 Amit Poreli. All rights reserved.
//

#import "ViewController.h"
#import "URL.h"
#import "PostListViewController.h"
#import "SignUpViewController.h"
#import "HUD.h"
#import "DataFetch.h"

@interface ViewController ()<ProcessDataDelegate>

{
    
    
        DataFetch *_dataFetch;
        PostListViewController *post;
    NSString *encodeUnameStr;
    
    NSString *encodepasswordStr;
    MPMoviePlayerController *mpc;
    
    BOOL isFirstAppearance,chkClicked;
}

@end

@implementation ViewController

-(void)viewWillAppear:(BOOL)animated{
    
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"Accepted"]);
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"userData"]);
    
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"Accepted"] isEqual:@"Yes"]) {
        //[eulaView removeFromSuperview];
        eulaView.hidden = YES;
    }
//    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"login"] isEqual:@"Yes"]) {
//        //[eulaView removeFromSuperview];
//        post =[self.storyboard instantiateViewControllerWithIdentifier:@"PostListViewController"];
//        [self.navigationController pushViewController:post animated:NO];
//
//    }
    
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"userData"]);
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    chkClicked = NO;
    self.userNameText.delegate=self;
    self.passText.delegate=self;
    okBtnProperty.enabled = NO;

    logObj=[LoginStore LoginClassObj];
    // Do any additional setup after loading the view, typically from a nib.
    
    nameBackView.layer.cornerRadius=5.0f;
    passwordBackView.layer.cornerRadius=5.0f;
    
    self.userNameText.text=[[NSUserDefaults standardUserDefaults]objectForKey:@"userNameKey"];
    self.passText.text=[[NSUserDefaults standardUserDefaults]objectForKey:@"passwordKey"];
    
    
    //******* Sowing Video at First ************//
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    
    //mpc.view.backgroundColor = [UIColor whiteColor];
    isFirstAppearance = YES;
//    [[NSUserDefaults standardUserDefaults]valueForKey:@"Accepted"];
//    [[NSUserDefaults standardUserDefaults]synchronize];
    
    _dataFetch = [[DataFetch alloc]init];
    _dataFetch.delegate = self;

    
    NSString *stringPath=[[NSBundle mainBundle]pathForResource:@"ecoPodium" ofType:@"mp4"];
    NSLog(@"%@",stringPath);
    NSURL *url=[NSURL fileURLWithPath:stringPath];
    mpc = [[MPMoviePlayerController alloc]initWithContentURL:url];
    [mpc setMovieSourceType:MPMovieSourceTypeFile];
    //mpc.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:mpc.view];
    mpc.controlStyle = MPMovieControlStyleEmbedded;
    [mpc setFullscreen:YES animated:YES];
    //[MoviewView addSubview:mpc.view];
    [self.view addSubview:mpc.view];
    mpc.view.frame = self.view.frame;
    mpc.backgroundView.backgroundColor = [UIColor colorWithRed:39.0/255 green:39.0/255 blue:39.0/255 alpha:1];
    [mpc setFullscreen:YES];
    
    //[mpc play];
    [mpc stop];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onStop)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:mpc];

    

}

//-(void)viewWillAppear:(BOOL)animated
//{
//    
//    
//    NSString *stringPath=[[NSBundle mainBundle]pathForResource:@"ecoPodium" ofType:@"mp4"];
//    NSLog(@"%@",stringPath);
//    NSURL *url=[NSURL fileURLWithPath:stringPath];
//    mpc = [[MPMoviePlayerController alloc]initWithContentURL:url];
//    [mpc setMovieSourceType:MPMovieSourceTypeFile];
//    //mpc.view.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:mpc.view];
//    mpc.controlStyle = MPMovieControlStyleNone;
//    [mpc setFullscreen:YES animated:YES];
//    //[MoviewView addSubview:mpc.view];
//    [self.view addSubview:mpc.view];
//    mpc.view.frame = self.view.frame;
//     //mpc.view.backgroundColor = [UIColor whiteColor];
//    [mpc setFullscreen:YES];
//    
//    //[mpc play];
//    [mpc stop];
//    
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(onStop)
//                                                 name:MPMoviePlayerPlaybackDidFinishNotification
//                                               object:mpc];
//    
//    
//
//}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (isFirstAppearance) {
        NSLog(@"root view controller is moving to parent");
        isFirstAppearance = NO;
    }else{
        [self onStop];
        btnSkip.hidden = NO;
        [[self navigationController] setNavigationBarHidden:YES animated:YES];
//        [mpc stop];
//        [mpc.view removeFromSuperview];
//        [topLogo setFrame:CGRectMake(0,70,topLogo.frame.size.width,topLogo.frame.size.height)];
//        [bottomView setFrame:CGRectMake(0,(MoviewView.frame.size.height-bottomView.frame.size.height)-70,bottomView.frame.size.width,bottomView.frame.size.height)];
        
        NSLog(@"root view controller, not moving to parent");
    }
}


-(void)onStop
{
//    NSLog(@"%f",(MoviewView.frame.size.height-bottomView.frame.size.height)-70);
    [mpc stop];
//    [mpc.view removeFromSuperview];
//    
//    [topLogo setFrame:CGRectMake(((self.view.frame.size.width-topLogo.frame.size.width)/2), 120, topLogo.frame.size.width, topLogo.frame.size.height)];
//    
//    [bottomView setFrame:CGRectMake(0,(MoviewView.frame.size.height-bottomView.frame.size.height)-70,bottomView.frame.size.width,bottomView.frame.size.height)];
//    btnSkip.hidden = YES;
    
    

    
    
    //[[self navigationController] setNavigationBarHidden:NO animated:YES];
}

//- (BOOL)isMovingToParentViewController
//{
//    [mpc stop];
//    return YES;
//}


 //******* Sowing Video at First ********Closed****//

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    return YES;
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    [self.view endEditing:YES];
    return YES;
}

- (void)keyboardDidShow:(NSNotification *)notification
{
    // Assign new frame to your view
    [self.view setFrame:CGRectMake(0,-210,self.view.frame.size.width,self.view.frame.size.height)]; //here taken -20 for example i.e. your view will be scrolled to -20. change its value according to your requirement.
    
}

-(void)keyboardDidHide:(NSNotification *)notification
{
    [self.view setFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [_userNameText resignFirstResponder];
    [_passText resignFirstResponder];
    
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signUpBtn:(id)sender
{
    SignUpViewController *signVC=[self.storyboard instantiateViewControllerWithIdentifier:@"SignUpViewController"];
    [self.navigationController pushViewController:signVC animated:YES];
    
    self.userNameText.text=[[NSUserDefaults standardUserDefaults]objectForKey:@"userNameKey"];
    _passText.text=[[NSUserDefaults standardUserDefaults]objectForKey:@"passwordKey"];
    [self onStop];
}


- (IBAction)loginBtn:(id)sender
{
    if (_userNameText.text.length == 0) {
        
        [self alertmethod1];
        
    }
    else if (_passText.text.length == 0)
    {
        [self alertmethod2];
    }
    else
        
    logObj.username= _userNameText.text;
    logObj.password=_passText.text;
    
    [[NSUserDefaults standardUserDefaults] setObject:logObj.username forKey:@"userNameKey"];
    [[NSUserDefaults standardUserDefaults] setObject:logObj.password forKey:@"passwordKey"];
    
    //NSLog(@"User Name: %@ \n Password: %@",_userNameText.text,_passText.text);
    NSLog(@"User Name: %@ \n Password: %@",logObj.username,logObj.password);
    //[self LogInDetail];
    [self loginMethod];
    [mpc stop];
    
    
    [_passText resignFirstResponder];
    [_userNameText resignFirstResponder];
}

- (IBAction)btnSkip:(UIButton *)sender {
    //[self onStop];
    //[btnSkip removeFromSuperview];
    btnSkip.hidden = YES;
    [mpc play];
}

- (IBAction)checkBoxBtn:(UIButton *)sender {
    
    if (chkClicked==YES) {
        [sender setImage:[UIImage imageNamed:@"checkbox_1.png"]
                forState:UIControlStateNormal];
        
        okBtnProperty.enabled = NO;
        //[OkBtn removeFromSuperview];
        
        chkClicked=NO;
    }
    else
    {
        [sender setImage:[UIImage imageNamed:@"checkbox_tick_1.png"]
                forState:UIControlStateNormal];
        
        okBtnProperty.enabled = YES;
        chkClicked=YES;
    }
}

- (IBAction)okBtnActn:(UIButton *)sender {
    
    [[NSUserDefaults standardUserDefaults] setValue: @"Yes" forKey: @"Accepted"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [eulaView removeFromSuperview];
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"Accepted"]);
    
}

-(void)loginMethod{

    [HUD showUIBlockingIndicatorWithText:@"Loading..."];
    //NSString *savedValue;
    NSMutableDictionary *loginDic = [[NSMutableDictionary alloc] init];

    NSString *url = @"http://www.appsforcompany.com/ecopodium/app/post.php";
    NSString *str=@"login";
    [loginDic setObject:str forKey:@"actiontype"];
    [loginDic setObject:_userNameText.text forKey:@"email"];
    [loginDic setObject:_passText.text forKey:@"password"];

    
    NSLog(@"%@",loginDic);
    
    [_dataFetch request:url :@"POST" :loginDic :@"LoginMethod" :@"json"];

}

-(void)LogInDetail
{
    
    
    
    if (_userNameText.text.length>0&&_passText.text.length>0)
        
    {
        
        
        encodeUnameStr=[logObj.username stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        encodepasswordStr=[logObj.password stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

        NSLog(@"%@",encodeUnameStr);
        NSLog(@"%@",encodepasswordStr);
        
        NSString *LoginData =[[NSString alloc]initWithFormat:@"email=%@&password=%@",encodeUnameStr,encodepasswordStr];
        
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@&apikey=micronix_03_2015_ecopodium_proj",Login1,LoginData]];
        
        NSLog(@"%@",url);
        
        dispatch_async
        
        (kBgQueue, ^
         
         {
             NSData* data1 = [NSData dataWithContentsOfURL:url];
             
             NSLog(@"%@",data1);
             [self performSelectorOnMainThread:@selector(fetchedData:)withObject:data1 waitUntilDone:YES];
         });
        
        
        
    }
    
}

- (void)fetchedData:(NSData *)responseData
{
    //parse out the json data+
    
    NSDictionary  *Dic =[[NSDictionary alloc]init];
    
    NSError *error;
    
    
    
    Dic= [NSJSONSerialization
          
          JSONObjectWithData:responseData
          
          
          
          options:kNilOptions
          
          error:&error];
    
    NSLog(@"%@",Dic);
    if([[Dic valueForKey:@"status"] isEqualToString:@"Username Password Incorrect."])
    {
        
        UIAlertView *loginfail =[[UIAlertView alloc]initWithTitle:@"ecoPodium App" message:@"Invalid emailid or Password or Please try registration" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [loginfail show];
    }
    else
        //([[Dic valueForKey:@"status"] isEqualToString:@"You have successfully login"])
    {
        
        UIAlertView *loginsucess =[[UIAlertView alloc]initWithTitle:@"ecoPodium App" message:@"Share your environment by posting your news. Go deeper by clicking \"More\" to elaborate your details,comments or add a photo. Enjoy!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [loginsucess show];
        
        PostListViewController *postVC=[self.storyboard instantiateViewControllerWithIdentifier:@"PostListViewController"];
        [self.navigationController pushViewController:postVC animated:YES];
        
        _userNameText.text=@"";
         _passText.text=@"";
        
    }
}




-(void) alertmethod1
{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Fill Your Email Id"
                                                    message:nil
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles: nil];
    [alert show];
    
    
}

-(void) alertmethod2
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Fill Your Password"
                                                    message:nil
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles: nil];
    [alert show];
    
    
}
- (void) processSuccessful :(NSDictionary *)data1 :(NSString *)JsonFor{
    
    
    NSLog(@"%@",data1);
    [HUD hideUIBlockingIndicator];
    NSLog(@"%@",[[data1 valueForKey:@"data"] valueForKey:@"loginstatus"]);
    if([[[data1 valueForKey:@"data"] valueForKey:@"loginstatus"] isEqualToString:@"log in credentials are wrong"])
    {
        
        UIAlertView *loginfail =[[UIAlertView alloc]initWithTitle:@"ecoPodium App" message:@"Invalid emailid or Password or Please try registration" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [loginfail show];
    }
    else
        //([[Dic valueForKey:@"status"] isEqualToString:@"You have successfully login"])
    {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"Yes" forKey:@"login"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        [[NSUserDefaults standardUserDefaults] setObject:[data1 valueForKey:@"data"] forKey:@"userData"];
        [[NSUserDefaults standardUserDefaults] synchronize];

        
        UIAlertView *loginsucess =[[UIAlertView alloc]initWithTitle:@"ecoPodium App" message:@"Share your environment by posting your news. Go deeper by clicking \"More\" to elaborate your details,comments or add a photo. Enjoy!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [loginsucess show];
        
        PostListViewController *postVC=[self.storyboard instantiateViewControllerWithIdentifier:@"PostListViewController"];
        [self.navigationController pushViewController:postVC animated:YES];
        
        _userNameText.text=@"";
        _passText.text=@"";
        
    }

}

@end
