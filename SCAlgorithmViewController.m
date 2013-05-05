//
//  SCF2LViewController.m
//  SolveTheCube2
//
//  Created by Tianyu Liu on 2/14/13.
//  Copyright (c) 2013 Tianyu Liu. All rights reserved.
//

#import "SCAlgorithmViewController.h"
#import "MCSwipeTableViewCell.h"
#import "MBProgressHUD.h"
#import "Algorithm.h"

@interface SCAlgorithmViewController () <MCSwipeTableViewCellDelegate,MBProgressHUDDelegate>

@end

@implementation SCAlgorithmViewController{
    NSString *algorithmType;
    NSUserDefaults *standardUserDefaults;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)loadAlgorithms{
    standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [self.tableView reloadData];
    NSLog(@"Clas");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor],UITextAttributeTextColor,nil] forState:UIControlStateNormal];
    
    self.view.backgroundColor = [UIColor colorWithRed:233.0 / 255.0 green:234.0 / 255.0 blue:236.0 / 255.0 alpha:1.0];
        
    algorithmType = self.tabBarItem.title;
    
    UIImage *tabBarItemImg = [UIImage imageNamed:[NSString stringWithFormat: @"%@-icon-gray.png",algorithmType]];
    [self.tabBarItem setFinishedSelectedImage:tabBarItemImg withFinishedUnselectedImage:tabBarItemImg];

    NSString *path = [[NSBundle mainBundle] pathForResource:algorithmType ofType:@"plist"];
    NSArray *data =[[NSArray alloc] initWithContentsOfFile:path];
    
    //initilize sushi property
    NSMutableArray *tempList = [[NSMutableArray alloc]init];

    for (int i = 0; i < data.count; i++) {
        Algorithm *newAlgorithm =
        [[Algorithm alloc]initWithString:data[i]
                               imageName:[NSString stringWithFormat:@"%@-%d%@",algorithmType, i+1, @".gif"]];
        
        [tempList addObject:newAlgorithm];
    }
    self.algorithmList = [[NSArray alloc]initWithArray:tempList];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadAlgorithms)
                                                 name:@"bookmarkDeleted"
                                               object:nil];
    
    [self loadAlgorithms];
    
    NSLog(@"%u",self.algorithmList.count);
    NSLog(@"This is%@",algorithmType);
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.algorithmList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"algorithmCell";
    
    MCSwipeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[MCSwipeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [cell setDelegate:self];
    [cell setFirstStateIconName:@"bookmark.png"
                     firstColor:[UIColor colorWithRed:206.0 / 255.0 green:149.0 / 255.0 blue:98.0 / 255.0 alpha:1.0]
            secondStateIconName:nil
                    secondColor:nil
                  thirdIconName:@"bookmark.png"
                     thirdColor:[UIColor colorWithRed:206.0 / 255.0 green:149.0 / 255.0 blue:98.0 / 255.0 alpha:1.0]
                 fourthIconName:nil
                    fourthColor:nil];
    [cell setMode:MCSwipeTableViewCellModeSwitch];
    
    [cell.contentView setBackgroundColor:[UIColor colorWithRed:233.0 / 255.0 green:234.0 / 255.0 blue:236.0 / 255.0 alpha:1.0]];
    cell.textLabel.backgroundColor = [UIColor colorWithRed:233.0 / 255.0 green:234.0 / 255.0 blue:236.0 / 255.0 alpha:1.0];
    cell.textLabel.text = [self.algorithmList[indexPath.row] algorithmString];
    
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.imageView.image = [UIImage imageNamed:[self.algorithmList[indexPath.row] imageName]];
    
    UIImageView *bookmarkview = [[UIImageView alloc]initWithFrame:CGRectMake(280,0, 20, 20)];
    bookmarkview.image = [UIImage imageNamed:@"brown-bookmark"];
    
    if ([self algoorithmBookmarked:self.algorithmList[indexPath.row]]) {
        cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"brown-bar"]];
        NSLog(@"BOOKMARED");
    } else {
        NSLog(@"NOT");
    }
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
 // Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (BOOL) algoorithmBookmarked:(Algorithm *)anAlgorithm{
    standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *tempBookmark =
    [[NSMutableArray alloc]initWithArray:[standardUserDefaults arrayForKey:@"bookmark"]];
    
    NSDictionary *algorthmDict = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[anAlgorithm imageName], [anAlgorithm algorithmString], nil] forKeys:[NSArray arrayWithObjects:@"imageName",@"algorithmString",nil]];
    
    return [tempBookmark containsObject:algorthmDict];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma mark - MCSwipeTableViewCellDelegate

- (void)swipeTableViewCell:(MCSwipeTableViewCell *)cell didTriggerState:(MCSwipeTableViewCellState)state withMode:(MCSwipeTableViewCellMode)mode
{
    //grab the standardUserDefault to change bookmark array
    standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *tempBookmark =
    [[NSMutableArray alloc]initWithArray:[standardUserDefaults arrayForKey:@"bookmark"]];
    
    Algorithm *thisAlgorithm = self.algorithmList[[[self.tableView indexPathForCell:cell] row]];
    NSDictionary *algorthmDict = [Algorithm convertToDictionary:thisAlgorithm];
    
    NSLog(@"%@",thisAlgorithm.algorithmString);
    
    UIImageView *bookmarkview = [[UIImageView alloc]initWithFrame:CGRectMake(280,0, 20, 20)];
    bookmarkview.image=[UIImage imageNamed:@"brown-bookmark"];

    if (![tempBookmark containsObject: algorthmDict]) {
        //if algorithm is not bookmarked, add it to the bookmark array
        [tempBookmark addObject:algorthmDict];
        [standardUserDefaults setObject:tempBookmark forKey:@"bookmark"];
        [self showWithCustomView:@"Bookmarked"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"bookmarkAdded" object:nil];
        cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"brown-bar"]];
        //[self showWithCustomView:@"Liked"];
        
    } else {
        
        [self showWithCustomView:@"Already bookmarked"];
        //if sushi is stared, remove it from the array, change the star to empty and pop notification
        //        [tempFav removeObject:self.sushi.name];
        //        [standardUserDefaults setObject:tempFav forKey:@"favourite"];
        //        UIImage *starImage = [UIImage imageNamed:@"empty-star-icon"];
        //        [self.star setImage:starImage forState:UIControlStateNormal];
        //        [self showWithCustomView:@"Unliked"];

    }
    
    //post a notification to FavController and CollectionViewController to update collection view
    NSLog(@"IndexPath : %@ - MCSwipeTableViewCellState : %d - MCSwipeTableViewCellMode : %d", [self.tableView indexPathForCell:cell], state, mode);
}

//pop up a notification of bookmark
- (void)showWithCustomView:(NSString *)message {
	
	MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.tabBarController.view];
	[self.tabBarController.view addSubview:HUD];
	
	HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bookmark.png"]];
	
	// Set custom view mode
	HUD.mode = MBProgressHUDModeCustomView;
	HUD.delegate = self;
	HUD.labelText = message;
	[HUD show:YES];
	[HUD hide:YES afterDelay:0.6];
}

@end
