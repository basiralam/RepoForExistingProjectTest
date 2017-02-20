//
//  PostListViewController.h
//  Ecopodium
//
//  Created by Amit Poreli on 31/08/15.
//  Copyright (c) 2015 Amit Poreli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageViewController.h"

@interface PostListViewController : UIViewController<MyJsonParseProtocall,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

{

    __weak IBOutlet UIWebView *webView;
  
 
    IBOutlet UIScrollView *scroller;
}
- (IBAction)webPostAction:(id)sender;

@end
