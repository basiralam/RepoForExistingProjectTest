//
//  DetailsViewController.m
//  Ecopodium
//
//  Created by Micronixtraining on 8/18/16.
//  Copyright © 2016 Amit Poreli. All rights reserved.
//

#import "DetailsViewController.h"
#import "NameLocationCell.h"
#import "DescriptionTableViewCell.h"
#import "CommentsTableViewCell.h"
#import "PostImageTableViewCell.h"
#import "DataFetch.h"
#import "HUD.h"
#import "URL.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "BFCropInterface.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"

@interface DetailsViewController ()<ProcessDataDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    NSMutableArray *nameArry;
    NSMutableArray *depcritionArry;
    NSMutableArray *commentArry;
    NameLocationCell *nameCell;
    DescriptionTableViewCell *descTableViewCell;
    CommentsTableViewCell *commentsTableViewCell;
    PostImageTableViewCell *postImageTableViewCell;
     IBOutlet UITableView *myTbl;
    DataFetch *_dataFetch;
    NSDictionary *commentListDic;
    NSArray * commentArr;
    NSArray * commentImg;
    NSArray * commentedByArr;
    
    IBOutlet UIImageView *cropImageView;
    IBOutlet UIView *cropView;
    
    IBOutlet UIButton *btnImageProp;
    UIImage *croppedImage;
    
    UIActivityIndicatorView *activity;

    NSString* picStr;
}

@property (nonatomic, strong) BFCropInterface *cropper;
@property BOOL newMedia;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Details";
    self.navigationItem.hidesBackButton = NO;
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
    _dataFetch = [[DataFetch alloc]init];
    _dataFetch.delegate = self;

    comentTypingTextVw.text = @"Type your comment...";
    
    NSLog(@" Location id: %@",_loc_id);
    commentListDic = [[NSDictionary alloc]init];

    comentTypingTextVw.delegate = self;
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [myTbl addGestureRecognizer:gestureRecognizer];
    [self reloadTableData];

}

-(void)activitySetting{
    activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activity.color =[UIColor blueColor];
    activity.hidesWhenStopped = YES;
    
    activity.center = self.view.center;
    
    activity.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 100)/2, ([UIScreen mainScreen].bounds.size.height-64 - 100)/2, 100, 100);
    [activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [activity setColor:[UIColor grayColor]];
    
    [self.view addSubview:activity];

}

- (void)viewWillAppear:(BOOL)animated{
    
    
    
}

-(void)reloadTableData
{
    [HUD showUIBlockingIndicatorWithText:@"Loading.."];
    //NSString *savedValue;
    NSMutableDictionary *msgListDic = [[NSMutableDictionary alloc] init];
    NSString *url = @"http://www.appsforcompany.com/ecopodium/app/post.php";
    NSString *str=@"message_listing";
    [msgListDic setObject:str forKey:@"actiontype"];
    [_dataFetch request:url :@"POST" :msgListDic :@"messagesList" :@"json"];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}
-(void)homeButtonPressed:(id)sender{
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    else if (section == 1)
    {
        return 1;
        
    }
    else if (section == 2)
    {
        return 1;
        
    }
    else
    {
        return commentArr.count;

    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
//    NSLog(@"%@",[[[commentListDic valueForKey:@"data"] objectAtIndex:indexPath.row] valueForKey:@"loc_id"]);
//    NSLog(@"%@",commentListDic);
    if (indexPath.section == 0) {
        static NSString *CellIdentifier = @"NLCell";
        nameCell = (NameLocationCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (nameCell==nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:nil options:nil];
            nameCell = (NameLocationCell*)[nib objectAtIndex:0];
        }

            nameCell.namelbl.text =[[[commentListDic valueForKey:@"data"] objectAtIndex:_index] valueForKey:@"name"];

        nameCell.locationLbl.text=[[[commentListDic valueForKey:@"data"] objectAtIndex:_index] valueForKey:@"location"];
        nameCell.myImage.image = [UIImage imageNamed:@"map.png"];
        
        return nameCell;
        
    }
    else if (indexPath.section == 1){
        static NSString* cellIdentifier1 = @"DepCell";
        
        descTableViewCell = (DescriptionTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
        if (descTableViewCell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier1 owner:nil options:nil];
            descTableViewCell = (DescriptionTableViewCell*)[nib objectAtIndex:0];
        }
        descTableViewCell.lblDecription.text = [[[commentListDic valueForKey:@"data"] objectAtIndex:_index] valueForKey:@"message"];
        return descTableViewCell;
        
    }
    else if (indexPath.section == 2){
        static NSString* cellIdentifier1 = @"PostImageTableViewCell";
        
        postImageTableViewCell = (PostImageTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
        if (postImageTableViewCell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier1 owner:nil options:nil];
            postImageTableViewCell = (PostImageTableViewCell*)[nib objectAtIndex:0];
        }
        
        
        NSLog(@"Post Image: %@",[[[commentListDic valueForKey:@"data"] objectAtIndex:_index] valueForKey:@"post_image"]);
   
        [postImageTableViewCell.postImage sd_setImageWithURL:[NSURL URLWithString:[[[commentListDic valueForKey:@"data"] objectAtIndex:_index] valueForKey:@"post_image"]]];

        return postImageTableViewCell;
        
    }

    else {
        
        static NSString* cellIdentifier1 = @"ComCell";
        commentsTableViewCell = (CommentsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
        if (commentsTableViewCell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier1 owner:nil options:nil];
            commentsTableViewCell = (CommentsTableViewCell*)[nib objectAtIndex:0];
        }
        commentsTableViewCell.lblComment.text = [NSString stringWithFormat:@"%@ \n-By %@",[commentArr  objectAtIndex:indexPath.row],[commentedByArr  objectAtIndex:indexPath.row]] ;

        [commentsTableViewCell.commentImage sd_setImageWithURL:[NSURL URLWithString:[commentImg objectAtIndex:indexPath.row]]];
        
        return commentsTableViewCell;

        
    }

}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 34;
    }
    else if (indexPath.section == 1)
    {
        return UITableViewAutomaticDimension;
        

    }
    else{
        tableView.estimatedRowHeight = 200.0;
        tableView.rowHeight = UITableViewAutomaticDimension;
        return UITableViewAutomaticDimension;
        
    }
}

- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath
{
    if (indexPath.section == 0 || indexPath.section == 1) {
        NSLog(@"");
    }
    else{
        if(indexPath.row % 2 == 0)
            cell.backgroundColor = [UIColor whiteColor];
        else{
            UIColor *colour = [[UIColor alloc]initWithRed:215.0/255.0 green:215.0/255.0 blue:215.0/255.0 alpha:1.0];
            
            cell.backgroundColor = colour;
        }

    }
}


- (void)textViewDidBeginEditing:(UITextView *)textView
{
    //_commentBgVw.frame = CGRectMake(0 , self.view.frame.size.height-270-_commentBgVw.frame.size.height, _commentBgVw.frame.size.width, _commentBgVw.frame.size.height);
    
    
    //self.view.frame = CGRectMake(0 , self.view.frame.size.height-270-_commentBgVw.frame.size.height, _commentBgVw.frame.size.width, _commentBgVw.frame.size.height);
    
    //myTbl.frame = CGRectMake(0 , 0, 220 , 30);

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];

    if ([comentTypingTextVw.text isEqualToString:@"Type your comment..."]) {
        comentTypingTextVw.text = @"";
        comentTypingTextVw.textColor = [UIColor blackColor]; //optional
        
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
  //  typingBgView.frame = CGRectMake(0, self.view.frame.size.height+216, typingBgView.frame.size.width, typingBgView.frame.size.height);
 
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidShowNotification object:nil];

    if ([comentTypingTextVw.text isEqualToString:@""]) {
        comentTypingTextVw.text = @"Type your comment...";
        comentTypingTextVw.textColor = [UIColor lightGrayColor]; //optional
    }
    [textView resignFirstResponder];
}
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
    
    if(IS_IPHONE_5)
    {
        // set frame for iphone 5
        [self.view setFrame:CGRectMake(0,-250,self.view.frame.size.width,self.view.frame.size.height)]; //here taken -20 for example i.e. your view will be scrolled to -20. change its value according to your requirement.

    
    }
    
    else if(IS_IPHONE_6)
    {
        // set frame for iphone 6
        [self.view setFrame:CGRectMake(0,-258,self.view.frame.size.width,self.view.frame.size.height)]; //here taken -20 for example i.e. your view will be scrolled to -20. change its value according to your requirement.
    }
        

    else if (IS_IPHONE_6P)
    {
        // set frame for iphone 6 plus..
        [self.view setFrame:CGRectMake(0,-270,self.view.frame.size.width,self.view.frame.size.height)]; //here taken -20 for example i.e. your view will be scrolled to -20. change its value according to your requirement.
    }
    else{
        
        [self.view setFrame:CGRectMake(0,-250,self.view.frame.size.width,self.view.frame.size.height)]; //here taken -20 for example i.e. your view will be scrolled to -20. change its value according to your requirement.
    }
    
    
}

-(void)keyboardDidHide:(NSNotification *)notification
{
    [self.view setFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
}
- (void) hideKeyboard {
    [self.view setFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
    [self.view endEditing:YES];

}
- (IBAction)btnSendComment:(UIButton *)sender {
    if ([comentTypingTextVw.text isEqual:@"Type your comment..."]) {
    
        UIAlertView *regSuccess =[[UIAlertView alloc]initWithTitle:@"ecoPodium App" message:@"Please write somethig to comment." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [regSuccess show];

    }
    else{
        [self sendCommentMethod];

    }
}
-(void)sendCommentMethod{
    
    [HUD showUIBlockingIndicatorWithText:@"Loading..."];
    //NSString *savedValue;
    NSMutableDictionary *sendDic = [[NSMutableDictionary alloc] init];
    
    if (picStr == (id)[NSNull null] || picStr.length == 0 ){
        picStr = @"";
    }
    
    NSString *url = @"http://www.appsforcompany.com/ecopodium/app/post.php";
    NSString *str=@"comment";
    [sendDic setObject:str forKey:@"actiontype"];
    [sendDic setObject:picStr forKey:@"imageName"];
    [sendDic setObject:_loc_id forKey:@"loc_id"];
    [sendDic setObject:comentTypingTextVw.text forKey:@"comments"];
    [sendDic setObject:[[NSUserDefaults standardUserDefaults] valueForKeyPath:@"userData.user_id"] forKey:@"uid"];
    
    
//    NSLog(@"%@",sendDic);
    
    [_dataFetch request:url :@"POST" :sendDic :@"sendCommentMethod" :@"json"];
    
}

- (void) processSuccessful :(NSDictionary *)data1 :(NSString *)JsonFor{
 
    [HUD hideUIBlockingIndicator];
    if ([JsonFor isEqual:@"sendCommentMethod"]) {
        [self hideKeyboard ];
        comentTypingTextVw.text = @"Type your comment...";
        comentTypingTextVw.textColor = [UIColor lightGrayColor]; //optional
        [self reloadTableData];
        picStr = @"";
        [btnImageProp setImage:[UIImage imageNamed:@"camera1.png"] forState:UIControlStateNormal];
        [myTbl reloadData];

    }
    else
    {
        NSLog(@"%@",data1);
        commentListDic = data1;
        commentArr = [[[commentListDic valueForKey:@"data"]  objectAtIndex:_index] valueForKey:@"comment"];
        commentedByArr = [[[commentListDic valueForKey:@"data"]  objectAtIndex:_index] valueForKey:@"user"];
        commentImg = [[[commentListDic valueForKey:@"data"]  objectAtIndex:_index] valueForKey:@"image"];
        
        NSLog(@"%@",commentImg);
        

        
        if ([[[commentListDic valueForKey:@"data"] valueForKey:@"status"] isEqual:@"You have posted comment succesfully"]) {
            comentTypingTextVw.text = @"";
        }
        
        [myTbl reloadData];

    }
    
}
- (void)scrollToBottom
{
    CGPoint bottomOffset = CGPointMake(0, myTbl.contentSize.height - myTbl.bounds.size.height);
    if ( bottomOffset.y > 0 ) {
        [myTbl setContentOffset:bottomOffset animated:YES];
    }
}
- (IBAction)btnUploadImageAction:(id)sender {
    [self imagetapped];
    
}
-(void)imagetapped
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
