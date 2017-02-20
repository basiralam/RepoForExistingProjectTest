//
//  MessageViewController.m
//  Ecopodium
//
//  Created by Amit Poreli on 31/08/15.
//  Copyright (c) 2015 Amit Poreli. All rights reserved.
//

#import "MessageViewController.h"
#import "URL.h"
#import "HUD.h"
#import "PostListViewController.h"
#import "DataFetch.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "BFCropInterface.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"


@interface MessageViewController ()<ProcessDataDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    
    MessageStore *MessageClassObj;
    DataFetch *_dataFetch;
  
    //properties for cropView
    IBOutlet UIButton *btnImageProp;
    IBOutlet UIView *cropView;
    IBOutlet UIImageView *cropImageView;
    UIActivityIndicatorView *activity;
    UIImage *croppedImage;
    NSString* picStr;


}
@property (nonatomic, strong) BFCropInterface *cropper;
@property BOOL newMedia;

@end

@implementation MessageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    _dataFetch = [[DataFetch alloc]init];
    _dataFetch.delegate = self;

    self.title=@"Post Messages";
    
    locationBackView.layer.cornerRadius = 5.0f;
    messageBackView.layer.cornerRadius = 5.0f;
    _messageTextView.dataDetectorTypes = UIDataDetectorTypeLink;
    _messageTextView.text = @"What can you share?";
    _messageTextView.textColor = [UIColor lightGrayColor];
    self.locationText.delegate=self;
    self.messageTextView.delegate=self;
    MessageClassObj=[MessageStore MessageClassObj];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    // Do any additional setup after loading the view.
    //[_messageTextView becomeFirstResponder];
    
}

//- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
//{
//    _messageTextView.text = @"";
//    _messageTextView.textColor = [UIColor blackColor];
//    return YES;
//}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    

    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{

    [self.view setFrame:CGRectMake(0,-200,self.view.frame.size.width,self.view.frame.size.height)];
    if ([_messageTextView.text isEqualToString:@"What can you share?"]) {
        _messageTextView.text = @"";
        _messageTextView.textColor = [UIColor blackColor]; //optional
        
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([_messageTextView.text isEqualToString:@""]) {
        _messageTextView.text = @"What can you share?";
        _messageTextView.textColor = [UIColor lightGrayColor]; //optional
    }
    [self.view setFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
    [textView resignFirstResponder];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{

    [_messageTextView becomeFirstResponder];
    return NO;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_messageTextView resignFirstResponder];
    [_locationText resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)btnPostBack:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)postActionBtn:(id)sender
{
    [self MessagePost];
}

-(void)MessagePost
{
    if (_locationText.text.length == 0) {
        
        [self alertmethod1];
        
    }
    else if (_messageTextView.text.length == 0)
    {
        [self alertmethod2];
    }
    
    else
    {
        

        if (picStr == (id)[NSNull null] || picStr.length == 0 ){
            picStr = @"";
        }

        NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"userData"]);
        [HUD showUIBlockingIndicatorWithText:@"Loading.."];
        //NSString *savedValue;
        NSMutableDictionary *messageDic = [[NSMutableDictionary alloc] init];
        NSString *url = @"http://www.appsforcompany.com/ecopodium/app/post.php";
        NSString *str=@"send_message";
        [messageDic setObject:str forKey:@"actiontype"];
        [messageDic setObject:_messageTextView.text forKey:@"message"];
        [messageDic setObject:_locationText.text forKey:@"location"];
        [messageDic setObject:picStr forKey:@"imageName"];
        [messageDic setObject:[[NSUserDefaults standardUserDefaults] valueForKeyPath:@"userData.user_id"] forKey:@"u_id"];
        
        NSLog(@"%@",messageDic);
        
        [_dataFetch request:url :@"POST" :messageDic :@"RegDetails" :@"json"];

    }
    
}

- (void)fetchedData:(NSData *)responseData {
    //parse out the json data+
    
    
    
    NSDictionary  *Dic =[[NSDictionary alloc]init];
    
    NSError *error;
    
    
    
    Dic= [NSJSONSerialization
          
          JSONObjectWithData:responseData
          
          
          
          options:kNilOptions
          
          error:&error];
    
//    NSLog(@"%@",Dic);
    
    
    
    if([[Dic valueForKey:@"status" ] isEqualToString:@"Thank you!"])
    {
        UIAlertView *regSuccess =[[UIAlertView alloc]initWithTitle:@"ecoPodium App" message:[NSString stringWithFormat:@"%@",[Dic valueForKey:@"status" ]] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [regSuccess show];
    }
    
    
    
    [self Post];
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}



-(void)Post
{
    [self.deligate reloadMyTable];
}





-(void) alertmethod1
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry,your post is blank."
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
    
//    [[NSUserDefaults standardUserDefaults] setValue: [[data1 valueForKey:@"data1"] valueForKey:@"massage"] forKey: @"massageSaved"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"massageSaved"]);
//    NSLog(@"%@",data1);
//    data =     {
//        status = "Message saved succesfully";
//    };
    
    
    NSLog(@"%@",data1);
    if ([[[data1  valueForKey:@"data"]valueForKey:@"status"] isEqual:@"Message saved succesfully"]) {
        [self.navigationController popViewControllerAnimated:YES];

    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ecoPodium App"
                                                        message:@"Something went wrong please try again..!!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];

    }
    [HUD hideUIBlockingIndicator];
}
- (IBAction)btnUploadImageAction:(id)sender {
    [self imageTapped];
}

-(void)imageTapped
{
    UIAlertController * view=   [UIAlertController
                                 alertControllerWithTitle:@"ecoPodium"
                                 message:@"Select A Photo Source"
                                 preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* camera = [UIAlertAction
                             actionWithTitle:@"From Camera"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 
                                 
                                 
                                 
                                 
                                 
                                 //Do some thing here
                                 if ([UIImagePickerController isSourceTypeAvailable:
                                      UIImagePickerControllerSourceTypeCamera])
                                 {
                                     UIImagePickerController *imagePicker =
                                     [[UIImagePickerController alloc] init];
                                     imagePicker.delegate = self;
                                     imagePicker.sourceType =
                                     UIImagePickerControllerSourceTypeCamera;
                                     imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
                                     imagePicker.allowsEditing = NO;
                                     [self presentViewController:imagePicker
                                                        animated:YES completion:nil];
                                     //                                     _newMedia = YES;
                                     //                                     Savebtn.enabled = NO;
                                     //                                     bbtnBack.enabled = NO;
                                     
                                 }
                                 
                                 
                             }];
    UIAlertAction* cameraRoll = [UIAlertAction
                                 actionWithTitle:@"From Camera Roll"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     if ([UIImagePickerController isSourceTypeAvailable:
                                          UIImagePickerControllerSourceTypeSavedPhotosAlbum])
                                     {
                                         UIImagePickerController *imagePicker =
                                         [[UIImagePickerController alloc] init];
                                         imagePicker.delegate = self;
                                         imagePicker.sourceType =
                                         UIImagePickerControllerSourceTypePhotoLibrary;
                                         imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
                                         imagePicker.allowsEditing = NO;
                                         [self presentViewController:imagePicker
                                                            animated:YES completion:nil];
                                         //                                         _newMedia = NO;
                                         //                                         Savebtn.enabled = NO;
                                         //                                         bbtnBack.enabled = NO;
                                     }
                                     
                                 }];
    UIAlertAction* Cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleCancel
                             handler:^(UIAlertAction * action)
                             {
                                 
                             }];
    
    
    [view addAction:camera];
    [view addAction:cameraRoll];
    [view addAction:Cancel];
    
    [self presentViewController:view animated:YES completion:nil];
    
}
#pragma mark -
#pragma mark UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    cropView.hidden = NO;
    
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        
        
        self.cropper = [[BFCropInterface alloc]initWithFrame:cropImageView.frame andImage:image];
        
        NSLog(@"%f %f",self.cropper.bounds.size.width,self.cropper.bounds.size.height);
        
        
        self.cropper.contentMode = UIViewContentModeScaleAspectFit;
        if (_newMedia)
            UIImageWriteToSavedPhotosAlbum(image,
                                           self,
                                           @selector(image:finishedSavingWithError:contextInfo:),
                                           nil);
    }
    else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie])
    {
        // Code here to support video if enabled
    }
    
    
    
    // must have user interaction enabled on view that will hold crop interface
    //cropimgVw.contentMode = UIViewContentModeScaleAspectFit;
    
    cropImageView.userInteractionEnabled = YES;
    
    // ** this is where the magic happens
    
    // allocate crop interface with frame and image being cropped
    //    self.cropper = [[BFCropInterface alloc]initWithFrame:cropimgVw.bounds andImage:image];
    // this is the default color even if you don't set it
    //  self.cropper.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.60];
    // white is the default border color.
    self.cropper.borderColor = [UIColor whiteColor];
    // add interface to superview. here we are covering the main image view.
    [cropImageView addSubview:self.cropper];
    
    
}

-(void)image:(UIImage *)image
finishedSavingWithError:(NSError *)error
 contextInfo:(void *)contextInfo
{
    if (error) {
        UIAlertView *Failedalert = [[UIAlertView alloc]
                                    initWithTitle: @"Save failed"
                                    message: @"Failed to save image"
                                    delegate: nil
                                    cancelButtonTitle:@"OK"
                                    otherButtonTitles:nil];
        [Failedalert show];
    }
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelcrop:(UIBarButtonItem *)sender {
    
    // [cropview removeFromSuperview];
    
    cropView.hidden = YES;
    
    //    Savebtn.enabled = YES;
    //    bbtnBack.enabled = YES;
}

-(void)uploadImage
{
    [NSThread detachNewThreadSelector:@selector(threadStartAnimating) toTarget:self withObject:nil];
    
    
    UIImage *image = croppedImage;
    CGSize size = CGSizeMake(400, 250);
    
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // UIImage *profileimg=[UIImage imageNamed:@"Linux-Tux-small.jpg"];
    NSData *imageData = UIImageJPEGRepresentation(destImage, 90);
    
    NSString *imagePostUrl = [NSString stringWithFormat:@"http://www.appsforcompany.com/ecopodium/app/upload_image.php"];
    
    NSString *imageString =  [imageData base64EncodedStringWithOptions:0];
    NSError* error;
    NSDictionary *parameters = @{@"imageName": imageString};
    NSMutableURLRequest *req=[[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:imagePostUrl parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
                              {
                                  [formData appendPartWithFileData:imageData name:@"image" fileName:@"image" mimeType:@"image/jpeg"];
                              }error:&error];
    
    
    AFHTTPRequestOperation *op = [manager HTTPRequestOperationWithRequest:req success: ^(AFHTTPRequestOperation *operation, id responseObject) {
        // NSLog(@"response: %@", responseObject);
        
        self.view.userInteractionEnabled = YES;
        [activity stopAnimating];
        
        //  NSError* error;
        NSString *convertedString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"string: %@",convertedString);
        
        // NSLog(@"dic: %@",json);
        
        NSRange result1 = [convertedString rangeOfString:@".jpg"];
        if (result1.length>0) {
            picStr=[NSString stringWithFormat:@"http://www.appsforcompany.com/ecopodium/app/%@",convertedString];
            NSLog(@"%@",picStr);
            [HUD hideUIBlockingIndicator];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //  NSLog(@"Error: %@", error);
        
        self.view.userInteractionEnabled = YES;
        [activity stopAnimating];
    }];
    op.responseSerializer = [AFHTTPResponseSerializer serializer];
    [[NSOperationQueue mainQueue] addOperation:op];
    
}

-(void)threadStartAnimating
{
    [activity startAnimating];
}
- (IBAction)btnCropAction:(id)sender {
    croppedImage = [self.cropper getCroppedImage];
    
    
    // remove crop interface from superview
    [self.cropper removeFromSuperview];
    self.cropper = nil;
    
    // display new cropped image
    
    [btnImageProp setImage:croppedImage forState:UIControlStateNormal];
    
    cropView.hidden = YES;
    //[cropview removeFromSuperview];
    //    Savebtn.enabled = YES;
    //    bbtnBack.enabled = YES;
    [HUD showUIBlockingIndicatorWithText:@"Loading Image..."];
    [self uploadImage];
    
}
- (IBAction)btnCancelCropAction:(id)sender {
    cropView.hidden = YES;
    
    //    Savebtn.enabled = YES;
    //    bbtnBack.enabled = YES;
    
}


@end
