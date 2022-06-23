//
//  DetailsViewController.m
//  twitter
//
//  Created by Ramya Prabakar on 6/22/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "DetailsViewController.h"
#import "APIManager.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *screenName;
@property (weak, nonatomic) IBOutlet UILabel *retweetCount;
@property (weak, nonatomic) IBOutlet UILabel *favoriteCount;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UILabel *createdAt;
@property (weak, nonatomic) IBOutlet UITextView *text;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.name.text = self.passedTweet.user.name;
    NSString *screenNameWithAt = [@"@" stringByAppendingString:self.passedTweet.user.screenName];
    self.screenName.text = screenNameWithAt;
    self.text.text = self.passedTweet.text;
    
    NSString *URLString = self.passedTweet.user.profilePicture;
    NSURL *url = [NSURL URLWithString:URLString];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    self.profilePicture.image = [[UIImage alloc]initWithData:urlData];
    
    self.favoriteCount.text = [NSString stringWithFormat:@"%d", self.passedTweet.favoriteCount];
    self.retweetCount.text = [NSString stringWithFormat:@"%d", self.passedTweet.retweetCount];
    self.createdAt.text = self.passedTweet.createdAtString;
    
    if (self.passedTweet.retweeted == true) {
        [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon-green.png"]  forState:UIControlStateNormal];
    } else {
        [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon.png"]  forState:UIControlStateNormal];
    }
    
    if (self.passedTweet.favorited == true) {
        [self.favoriteButton setImage:[UIImage imageNamed:@"favor-icon-red.png"]  forState:UIControlStateNormal];
    } else {
        [self.favoriteButton setImage:[UIImage imageNamed:@"favor-icon.png"]  forState:UIControlStateNormal];
    }
}


- (IBAction)goHome:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)didTapRetweet:(id)sender {
    if (self.passedTweet.retweeted) { // unretweeting
        // [sender setSelected:NO];
        self.passedTweet.retweeted = NO;
        self.passedTweet.retweetCount -= 1;
        
        [[APIManager shared] unretweet:self.passedTweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                 NSLog(@"Error unretweeting tweet: %@", error.localizedDescription);
            } else{
                NSLog(@"Successfully unretweeted the following Tweet: %@", tweet.text);
                [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon.png"] forState:UIControlStateNormal];
                self.retweetCount.text = [NSString stringWithFormat:@"%d", self.passedTweet.retweetCount];
                [self.delegate didChangeInDetailsView];
            }
        }];
     } else { // retweeting
        // [sender setSelected:YES];
        self.passedTweet.retweeted = YES;
        self.passedTweet.retweetCount += 1;
         
         [[APIManager shared] retweet:self.passedTweet completion:^(Tweet *tweet, NSError *error) {
             if(error){
                  NSLog(@"Error retweeting tweet: %@", error.localizedDescription);
             } else{
                 NSLog(@"Successfully retweeted the following Tweet: %@", tweet.text);
                 [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon-green.png"]  forState:UIControlStateNormal];
                 self.retweetCount.text = [NSString stringWithFormat:@"%d", self.passedTweet.retweetCount];
                 [self.delegate didChangeInDetailsView];
             }
         }];
     }
}

- (IBAction)didTapFavorite:(id)sender {
    if (self.passedTweet.favorited) { // unliking
        // [sender setSelected:NO];
        self.passedTweet.favorited = NO;
        self.passedTweet.favoriteCount -= 1;
        
        [[APIManager shared] unfavorite:self.passedTweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                 NSLog(@"Error unfavoriting tweet: %@", error.localizedDescription);
            } else{
                NSLog(@"Successfully unfavorited the following Tweet: %@", tweet.text);
                [self.favoriteButton setImage:[UIImage imageNamed:@"favor-icon.png"] forState:UIControlStateNormal];
                self.favoriteCount.text = [NSString stringWithFormat:@"%d", self.passedTweet.favoriteCount];
                [self.delegate didChangeInDetailsView];
            }
        }];
     } else { // liking
        // [sender setSelected:YES];
        self.passedTweet.favorited = YES;
        self.passedTweet.favoriteCount += 1;
         
         [[APIManager shared] favorite:self.passedTweet completion:^(Tweet *tweet, NSError *error) {
             if(error){
                  NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
             } else{
                 NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
                 [self.favoriteButton setImage:[UIImage imageNamed:@"favor-icon-red.png"]  forState:UIControlStateNormal];
                 self.favoriteCount.text = [NSString stringWithFormat:@"%d", self.passedTweet.favoriteCount];
                 [self.delegate didChangeInDetailsView];
             }
         }];
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
