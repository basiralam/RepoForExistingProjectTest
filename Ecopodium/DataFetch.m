//

//  DataFetch.m

//  JsonDemo

//

//  Created by MacMini3 on 2015-12-09.

//  Copyright © 2015 MacMini3. All rights reserved.

//



#import "DataFetch.h"



@implementation DataFetch

{
    
    NSMutableData *_responseData;
    
//    UINavigationController *nav;
    
    NSString *JsonFor;
    
    NSString *JsonType;
    
    
    
}



-(id)init {
    
    self = [super init];
    
    return self;
    
}



-(void)request:(NSString *)URL :(NSString *)Method :(NSDictionary *)Method_Parameter :(NSString *)From :(NSString *)Type;

{
    
    
    
    JsonFor = From;
    
    JsonType = Type;
    
    
    
    NSError *error;
    
    
    
    // Create the request.
    
    NSString *urlString = URL;
    
    
    
    
    
    //This is sample webservice url. Please replace it with your own and pass your valid parameters.
    
    
    
    if ([Method isEqual:@"GET"]) {
        
        /*****************************************************************************************/
        
        //Using GET method
        
        /****************************************************************************************/
        
        
        
        
        
        
        
        NSURL *url = [NSURL URLWithString:urlString];
        
        
        
        NSLog(@"%@",url);
        
        NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
        
        
        
        [theRequest addValue: @"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        
        [theRequest setHTTPMethod:@"GET"];
        
        
        
        
        
        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
        
        if( connection )
            
        {
            
            _responseData = [[NSMutableData alloc] init];
            
        }
        
        
        
    }
    
    
    
    else
        
    {
        
        /**************************************************************************************/
        
        //Using POST method
        
        /****************************************************************************************/
        
        
        
        
        
        
        
        NSData *parameterData = [NSJSONSerialization dataWithJSONObject:Method_Parameter options:kNilOptions error:&error];
        
        
        
        NSLog(@"%@",Method_Parameter);
        
        
        
        NSURL *url = [NSURL URLWithString:urlString];
        
        
        
        NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
        
        [theRequest setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
        
        [theRequest addValue: @"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        
        [theRequest setHTTPMethod:@"POST"];
        
        [theRequest setHTTPBody:parameterData];
        
        
        
        
        
        
        
        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
        
        if( connection )
            
        {
            
            _responseData = [[NSMutableData alloc] init];
            
        }
        
        
        
        
        
        
        
        /*****************************************************************************************************/
        
    }
    
    
    
    
    
    
    
    
    
    
    
}



#pragma mark NSURLConnection Delegate Methods



- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    
    
    _responseData = [[NSMutableData alloc] init];
    
}



- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    
    
    [_responseData appendData:data];
    
}



- (NSCachedURLResponse *)connection:(NSURLConnection *)connection

                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    
    
    
    return nil;
    
}



- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    // The request is complete and data has been received
    
    // You can parse the stuff in your instance variable now
    
    
    
    
    
    
    
    
    
    if (connection) {
        
        NSError *error;
        
        
        
        
        
        if ([JsonType isEqual:@"json"]) {
            
            [[self delegate] processSuccessful:[NSJSONSerialization JSONObjectWithData:_responseData options:kNilOptions error:&error] :JsonFor];
            
        }
        
        else if ([JsonType isEqual:@"string"])
            
        {
            
            
            
            NSDictionary *temp = [[NSDictionary alloc]initWithObjectsAndKeys:[[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding],@"data", nil];
            
            
            
            [[self delegate] processSuccessful:temp :JsonFor];
            
        }
        
        
        
        
        
    }
    
    
    
    
    
    
    
    else
        
    {
        
//        UIAlertView *Alert = [[UIAlertView alloc]initWithTitle:@"ADAP" message:@"Internet not available, Cross check your internet connectivity and try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        
//        
//        
//        [Alert show];
//        
        
        
    }
    
    
    
}



//- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {

//    

//    UIAlertView *Alert = [[UIAlertView alloc]initWithTitle:@"ADAP" message:@"1There are something error. Please try after sometime." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];

//    

//    [Alert show];

//    

//}









@end