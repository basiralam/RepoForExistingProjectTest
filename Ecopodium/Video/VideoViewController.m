//
//  VideoViewController.m
//  Ecopodium
//
//  Created by Micronixtraining on 1/18/16.
//  Copyright © 2016 Amit Poreli. All rights reserved.
//

#import "VideoViewController.h"

@interface VideoViewController ()
{
    MPMoviePlayerController *mpc;
    IBOutlet UIView *movieView;
    
}
@end

@implementation VideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    NSString *stringPath=[[NSBundle mainBundle]pathForResource:@"ecoPodium" ofType:@"mp4"];
    NSLog(@"%@",stringPath);
    NSURL *url=[NSURL fileURLWithPath:stringPath];
    mpc = [[MPMoviePlayerController alloc]initWithContentURL:url];
    mpc.backgroundView.backgroundColor = [UIColor colorWithRed:39.0/255 green:39.0/255 blue:39.0/255 alpha:1];
    [mpc setMovieSourceType:MPMovieSourceTypeFile];
    [movieView addSubview:mpc.view];
    mpc.controlStyle = MPMovieControlStyleNone;
//    [mpc setFullscreen:YES animated:YES];
    mpc.view.frame = self.view.frame;
    [mpc setFullscreen:YES];
    //[mpc setShouldAutoplay:YES];
    [mpc play];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onStop)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:mpc];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deviceOrientationDidChangeNotification:) name:UIDeviceOrientationDidChangeNotification object:nil];
    

}





- (void)deviceOrientationDidChangeNotification:(NSNotification*)note
{
    
    NSLog(@"%@",note);
    
    [mpc setFullscreen:YES animated:YES];
    mpc.view.frame = self.view.frame;
    
    
}



-(void)onStop
{
    [mpc.view removeFromSuperview];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
 }

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
