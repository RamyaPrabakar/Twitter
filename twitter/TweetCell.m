//
//  TweetCell.m
//  twitter
//
//  Created by Ramya Prabakar on 6/20/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "APIManager.h"

@implementation TweetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)didTapFavorite:(id)sender {
    
    if (self.tweet.favorited) { // unliking
        // [sender setSelected:NO];
        self.tweet.favorited = NO;
        self.tweet.favoriteCount -= 1;
        
        [[APIManager shared] unfavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                 NSLog(@"Error unfavoriting tweet: %@", error.localizedDescription);
            } else{
                NSLog(@"Successfully unfavorited the following Tweet: %@", tweet.text);
                [self.favoriteButton setImage:[UIImage imageNamed:@"favor-icon.png"] forState:UIControlStateNormal];
                self.favoriteCount.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
            }
        }];
     } else { // liking
        // [sender setSelected:YES];
        self.tweet.favorited = YES;
        self.tweet.favoriteCount += 1;
         
         [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
             if(error){
                  NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
             } else{
                 NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
                 [self.favoriteButton setImage:[UIImage imageNamed:@"favor-icon-red.png"]  forState:UIControlStateNormal];
                 self.favoriteCount.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
             }
         }];
     }
}

// retweeting
- (IBAction)didTapRetweet:(id)sender {
    if (self.tweet.retweeted) { // unretweeting
        // [sender setSelected:NO];
        self.tweet.retweeted = NO;
        self.tweet.retweetCount -= 1;
        
        [[APIManager shared] unretweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                 NSLog(@"Error unretweeting tweet: %@", error.localizedDescription);
            } else{
                NSLog(@"Successfully unretweeted the following Tweet: %@", tweet.text);
                [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon.png"] forState:UIControlStateNormal];
                self.retweetCount.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
            }
        }];
     } else { // retweeting
        // [sender setSelected:YES];
        self.tweet.retweeted = YES;
        self.tweet.retweetCount += 1;
         
         [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
             if(error){
                  NSLog(@"Error retweeting tweet: %@", error.localizedDescription);
             } else{
                 NSLog(@"Successfully retweeted the following Tweet: %@", tweet.text);
                 [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon-green.png"]  forState:UIControlStateNormal];
                 self.retweetCount.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
             }
         }];
     }
}

@end
