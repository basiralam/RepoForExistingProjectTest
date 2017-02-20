//
//  PostListViewController.m
//  Ecopodium
//
//  Created by Amit Poreli on 31/08/15.
//  Copyright (c) 2015 Amit Poreli. All rights reserved.
//

#import "PostListViewController.h"
#import "CustomCommentsCell.h"
#import "DetailsViewController.h"
#import <Social/Social.h>
#import "HUD.h"
#import "DataFetch.h"
#import "UIImageView+WebCache.h"
#import "URL.h"


@interface PostListViewController ()<ProcessDataDelegate>
{
   IBOutlet UITableView *myTblView;
    NSMutableArray *tableArry;

    CustomCommentsCell *commentCell;
    DetailsViewController *despView;
    DataFetch *_dataFetch;
    NSDictionary *messageListDic;
    IBOutlet UIImageView *postImage;
}

@end

@implementation PostListViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _dataFetch = [[DataFetch alloc]init];
    _dataFetch.delegate = self;

    
    self.title=@"Messages";
    messageListDic = [[NSDictionary alloc]init];
    tableArry=[[NSMutableArray alloc]init];
    myTblView.delegate=self;
    myTblView.dataSource=self;
    
}


- (void)viewWillAppear:(BOOL)animated {
    self.navigationItem.hidesBackButton = YES;
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    
    [self loadData];

}
-(void)loadData{
    [HUD showUIBlockingIndicatorWithText:@"Loading.."];
    NSMutableDictionary *msgListDic = [[NSMutableDictionary alloc] init];
    NSString *url = @"http://www.appsforcompany.com/ecopodium/app/post.php";
    NSString *str=@"message_listing";
    [msgListDic setObject:str forKey:@"actiontype"];
    
//    NSLog(@"%@",msgListDic);
    
    [_dataFetch request:url :@"POST" :msgListDic :@"messagesList" :@"json"];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [[[messageListDic valueForKey:@"data"]  valueForKey:@"location"] count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    commentCell=(CustomCommentsCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (commentCell==nil)
    {
        commentCell=[[CustomCommentsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    
    commentCell.titleLbl.text = [[[messageListDic valueForKey:@"data"] objectAtIndex:indexPath.row] valueForKey:@"location"];
    commentCell.lblPostedBy.text = [NSString stringWithFormat:@"ecoPodium\n-By %@",[[[messageListDic valueForKey:@"data"] objectAtIndex:indexPath.row] valueForKey:@"name"]];
    commentCell.commentsLBl.text = [[[messageListDic valueForKey:@"data"] objectAtIndex:indexPath.row] valueForKey:@"message"];

    NSLog(@"%@",[[[messageListDic valueForKey:@"data"] objectAtIndex:indexPath.row] valueForKey:@"post_image"]);
    [commentCell.postImage sd_setImageWithURL:[NSURL URLWithString:[[[messageListDic valueForKey:@"data"] objectAtIndex:indexPath.row] valueForKey:@"post_image"]]];

    
    
    [[[messageListDic valueForKey:@"data"] objectAtIndex:indexPath.row] valueForKey:@"message"];
                [commentCell.commentsBtn addTarget:self action:@selector(commentBtnPressedAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [commentCell.commentsBtn setTag:indexPath.row];

    [commentCell.shareBtn addTarget:self action:@selector(facebookBtnPressedAction:) forControlEvents:UIControlEventTouchUpInside];
    [commentCell.shareBtn setTag:indexPath.row];

    [commentCell.twitrBtnActn addTarget:self action:@selector(twiterBtnPressedAction:) forControlEvents:UIControlEventTouchUpInside];
    [commentCell.twitrBtnActn setTag:indexPath.row];

    [commentCell.reportBtn addTarget:self action:@selector(reportBtnPressedAction:) forControlEvents:UIControlEventTouchUpInside];
    [commentCell.reportBtn setTag:indexPath.row];
    
    
    
    return commentCell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@",[[[messageListDic valueForKey:@"data"] objectAtIndex:indexPath.row] valueForKey:@"post_image"]);
    if ([[[[messageListDic valueForKey:@"data"] objectAtIndex:indexPath.row] valueForKey:@"post_image"] isEqual:@""]) {
        return 120;
    }
    else{
        //iphone 7+ , 6+
        if (IS_IPHONE_6P) {
            return 370;
            
        }
        //iphone 7 , 6
        else if(IS_IPHONE_6){
            return 345;
        }
        else if(IS_IPHONE_5){
            return 315;
        }
        else{
            return 290;
        }
        return 290;
    }


}

- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath
{
    if(indexPath.row % 2 == 0)
        cell.backgroundColor = [UIColor whiteColor];
    else{
        UIColor *colour = [[UIColor alloc]initWithRed:215.0/255.0 green:215.0/255.0 blue:215.0/255.0 alpha:1.0];

        cell.backgroundColor = colour;
    }
}

-(void)commentBtnPressedAction:(id)sender{

    despView = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailsViewController"];
    despView.loc_id = [[[messageListDic valueForKey:@"data"] objectAtIndex:[sender tag]] valueForKey:@"loc_id"];
    despView.index = [sender tag];
    [self.navigationController pushViewController:despView animated:YES];

    
}

-(void)facebookBtnPressedAction:(id)sender{
    

    NSLog(@"%ld",[sender tag]);
    NSString *postStr = [[[messageListDic valueForKey:@"data"] objectAtIndex:[sender tag]] valueForKey:@"message"];
    
    SLComposeViewController *fbController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    [fbController setInitialText:postStr];
    [self presentViewController:fbController animated:YES completion:nil];

    
    
}

-(void)twiterBtnPressedAction:(id)sender{
    
    SLComposeViewController *twitterController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [twitterController setInitialText:[[[messageListDic valueForKey:@"data"] objectAtIndex:[sender tag]] valueForKey:@"message"]];
    [self presentViewController:twitterController animated:YES completion:nil];
    
}

-(void)reportBtnPressedAction:(id)sender{

    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Report this post!"
                                                                   message:@"You have clicked on the report button. Are you sure you want to report this post?"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              
                                                              NSLog(@"%@",messageListDic);
                                                              NSMutableDictionary *reportDic = [[NSMutableDictionary alloc] init];
                                                              NSString *url = @"http://www.appsforcompany.com/ecopodium/app/post.php";
                                                              NSString *str=@"report";
                                                              [reportDic setObject:str forKey:@"actiontype"];
                                                              [reportDic setObject:[[NSUserDefaults standardUserDefaults] valueForKeyPath:@"userData.user_id"] forKey:@"user_id"];
                                                              [reportDic setObject:[[[messageListDic valueForKey:@"data"] objectAtIndex:[sender tag]] valueForKey:@"loc_id"] forKey:@"message_id"];
                                                              
                                                              NSLog(@"%@",reportDic);
                                                              
                                                              [_dataFetch request:url :@"POST" :reportDic :@"reportComment" :@"json"];
                                                              
                                                              
                                                          }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];

}

-(void)reportSetup
{
    
}
#pragma mark - Push with seague identifier

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    
    return NO;
}


- (IBAction)webPostAction:(id)sender
{
    MessageViewController *jsonParseObj = [self.storyboard instantiateViewControllerWithIdentifier:@"MessageViewController"];
    jsonParseObj.deligate = self;
    
    [self.navigationController pushViewController:jsonParseObj animated:YES];
}

- (void) processSuccessful :(NSDictionary *)data1 :(NSString *)JsonFor{
    
    NSLog(@"%@",data1);

    if ([JsonFor isEqual:@"reportComment"]) {
        
        if ([[[data1 valueForKey:@"data"] valueForKey:@"status"] isEqual:@"Ok"]) {
            UIAlertView *Alert = [[UIAlertView alloc]initWithTitle:@"ecoPodium App" message:@"You have successfully reported the post, we will remove the post if we found it objectionable. " delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [Alert show];

        }
        else if ([[[data1 valueForKey:@"data"] valueForKey:@"status"] isEqual:@"You have already blocked this message"]){
            UIAlertView *Alert = [[UIAlertView alloc]initWithTitle:@"ecoPodium App" message:@"You have already reported this post, please wait till we review. " delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [Alert show];

        }
        else{
            UIAlertView *Alert = [[UIAlertView alloc]initWithTitle:@"ecoPodium App" message:@"Something went wrong please try again..!! " delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [Alert show];

        }

    }
    else
    {
        [HUD hideUIBlockingIndicator];
        messageListDic = data1;
        [myTblView reloadData];

    }
    
}

@end
