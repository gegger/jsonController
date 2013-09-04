//
//  ViewController.h
//  jsonController
//
//  Created by gegger on 9/3/13.
//  Copyright (c) 2013 gegger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "URLRequest.h"

@interface ViewController : UIViewController <URLRequestDelegate>{
    IBOutlet UIButton *btnWithDelegate;
    IBOutlet UIButton *btnWithBlock;
    IBOutlet UITextView *textView;
}
-(IBAction)delegateFunction:(id)sender;
-(IBAction)blockFunction:(id)sender;
@end
