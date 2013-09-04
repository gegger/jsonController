//
//  ViewController.m
//  jsonController
//
//  Created by gegger on 9/3/13.
//  Copyright (c) 2013 gegger. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

////////////////////////////////////////////////////////////////////////
#pragma mark Public functions
////////////////////////////////////////////////////////////////////////
-(IBAction)delegateFunction:(id)sender{
    URLRequest *request = [[URLRequest alloc] initWithRequest:[URLRequest getData]];
    [request startWithDelegate:self];
}

-(IBAction)blockFunction:(id)sender{
    URLRequest *request = [[URLRequest alloc] initWithRequest:[URLRequest getData]];
    [request startWithCompletion: ^(URLRequest *request, NSMutableDictionary *result, NSError *error){
        if (!error){
            [textView setText:[NSString stringWithFormat:@"result with block: \nhttp statuscode:%i \n%@",[request httpStatusCode],result]];
        }
        else {
            [textView setText:[NSString stringWithFormat:@"error result with block:%@",error.localizedDescription]];
        }
    }];
}

////////////////////////////////////////////////////////////////////////
#pragma mark URLRequestDelegate
////////////////////////////////////////////////////////////////////////
-(void)requestFailed:(id)request withError:(NSError *)error{
    [textView setText:[NSString stringWithFormat:@"error result with delegate: httpstatuscode:%i\n%@",[request httpStatusCode],error.localizedDescription]];
}

-(void)requestFinished:(id)request withResult:(NSMutableDictionary *)result{
    [textView setText:[NSString stringWithFormat:@"result with delegate: \nhttp statuscode:%i \n%@",[request httpStatusCode],result]];
}

-(void)requestShouldStart:(id)request{
    NSLog(@"Loading...");
}
@end
