//
//  TimelineViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TimelineViewController.h"
#import "APIManager.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "Tweet.h"
#import "TweetCell.h"
#import "ComposeViewController.h"
#import "DetailsViewController.h"

@interface TimelineViewController () <ComposeViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *arrayOfTweets;
@property (nonatomic, strong) UIRefreshControl* refreshControl;

// TODO : Create outlets of the different views in the cell
@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self getTimeline];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(getTimeline) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
}


- (void) getTimeline {
    // Get timeline
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            self.arrayOfTweets = (NSMutableArray*) tweets;
            NSLog(@"😎😎😎 Successfully loaded home timeline");
            for (Tweet *tweet in tweets) {
                NSString *text = tweet.text;
                 NSLog(@"%@", text);
            }
            [self.tableView reloadData];
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
        [self.refreshControl endRefreshing];
    }];
}

- (IBAction)didTapLogout:(id)sender {
    // TimelineViewController.m
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    
    // clearing access tokens
    [[APIManager shared] logout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    // TODO : Configure the TweetCell
    Tweet *tweet = self.arrayOfTweets[indexPath.row];
    cell.tweet = tweet;
    cell.name.text = tweet.user.name;
    cell.screenName.text = tweet.user.screenName;
    cell.createdAt.text = tweet.date.shortTimeAgoSinceNow;
    cell.text.text = tweet.text;
    // cell.retweetCount.text = [NSString stringWithFormat:@"%d", tweet.retweetCount];
    // cell.favoriteCount.text = [NSString stringWithFormat:@"%d", tweet.favoriteCount];
    
    if (tweet.retweeted == true) {
        [cell.retweetButton setImage:[UIImage imageNamed:@"retweet-icon-green.png"]  forState:UIControlStateNormal];
        // [cell.favoriteButton setSelected:YES];
    } else {
        [cell.retweetButton setImage:[UIImage imageNamed:@"retweet-icon.png"]  forState:UIControlStateNormal];
    }
    
    cell.retweetCount.text = [NSString stringWithFormat:@"%d", tweet.retweetCount];
    
    if (tweet.favorited == true) {
        [cell.favoriteButton setImage:[UIImage imageNamed:@"favor-icon-red.png"]  forState:UIControlStateNormal];
        // [cell.favoriteButton setSelected:YES];
    } else {
        [cell.favoriteButton setImage:[UIImage imageNamed:@"favor-icon.png"]  forState:UIControlStateNormal];
    }
    
    cell.favoriteCount.text = [NSString stringWithFormat:@"%d", tweet.favoriteCount];
    
    cell.replyCount.text = [NSString stringWithFormat:@"%d", tweet.replyCount];
    
    NSString *URLString = tweet.user.profilePicture;
    NSURL *url = [NSURL URLWithString:URLString];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    
    cell.profilePicture.image = [[UIImage alloc]initWithData:urlData];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrayOfTweets.count;
}

/* - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"detailsSegue" sender:cell];
}*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"composeSegue"]) {
       UINavigationController *navigationController = [segue destinationViewController];
       ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
       composeController.delegate = self;
    } else if ([[segue identifier] isEqualToString:@"detailsSegue"]) {
        UINavigationController *navigationController = [segue destinationViewController];
        DetailsViewController *detailsViewController = (DetailsViewController*)navigationController.topViewController;
        Tweet *dataToPass = self.arrayOfTweets[[self.tableView indexPathForCell:sender].row];
        detailsViewController.passedTweet = dataToPass;
    }
}

- (void)didTweet:(Tweet *)tweet {
    [self.arrayOfTweets insertObject:tweet atIndex:0];
    [self.tableView reloadData];
}

@end
