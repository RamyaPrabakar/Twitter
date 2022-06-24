//
//  ComposeViewController.m
//  twitter
//
//  Created by Ramya Prabakar on 6/21/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "ComposeViewController.h"
#import "APIManager.h"

@interface ComposeViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *characterCount;
@property (weak, nonatomic) IBOutlet UILabel *alertLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *tweetButton;
@end

@implementation ComposeViewController

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)tweet:(id)sender {
    [[APIManager shared] postStatusWithText:self.textView.text completion:^(Tweet *tweet, NSError *error) {
        if (tweet) {
            [self dismissViewControllerAnimated:YES completion:nil];
            [self.delegate didTweet:tweet];
        } else {
            NSLog(@"😫😫😫 Error with tweeting: %@", error.localizedDescription);
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[self.textView layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[self.textView layer] setBorderWidth:2.3];
    [[self.textView layer] setCornerRadius:15];
    // Do any additional setup after loading the view.
}

- (void)textViewDidChange:(UITextView *)textView {
    NSString *substring = [NSString stringWithString:textView.text];
    
    if (substring.length > 0) {
        self.characterCount.hidden = NO;
        self.characterCount.text = [NSString stringWithFormat:@"%lu", substring.length];
    }
    
    if (substring.length == 0) {
        self.characterCount.hidden = YES;
    }
    
    if (substring.length > 280) {
        /* UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Tweet too long"
                                                                                   message:@"Your tweet cannot be longer than 280 characters"
                                                                            preferredStyle:(UIAlertControllerStyleAlert)];
        // create an OK action
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                                 // handle response here.
                                                         }];
        // add the OK action to the alert controller
        [alert addAction:okAction];
        
        [self presentViewController:alert animated:YES completion:^{
            // optional code for what happens after the alert controller has finished presenting
            
        }]; */
        
        self.alertLabel.text = @"Character count (280) exceeded";
        [[self.navigationItem.rightBarButtonItems objectAtIndex:0] setEnabled:NO];
    } else {
        self.alertLabel.text = nil;
        [[self.navigationItem.rightBarButtonItems objectAtIndex:0] setEnabled:YES];
    }
    
    
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
