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

//What does it do?
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
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:233.0 / 255.0 green:234.0 / 255.0 blue:236.0 / 255.0 alpha:1.0];
    
    //TODO: Hacky way to offset status bar height
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f,1.0f , 20.0f)];
        
    algorithmType = self.tabBarItem.title;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:algorithmType ofType:@"plist"];
    NSArray *data =[[NSArray alloc] initWithContentsOfFile:path];
    
    //initilize algorithm property
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
    
    NSLog(@"%lu",(unsigned long)self.algorithmList.count);
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
    
    void (^testBlock)(MCSwipeTableViewCell*, MCSwipeTableViewCellState,MCSwipeTableViewCellMode ) =
    ^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
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
        }
        
        NSLog(@"IndexPath : %@ - MCSwipeTableViewCellState : %d - MCSwipeTableViewCellMode : %d", [self.tableView indexPathForCell:cell], state, mode);
    };
    
    UIImage *image = [UIImage imageNamed:@"bookmark.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    UIColor *brownColor = [UIColor colorWithRed:206.0 / 255.0 green:149.0 / 255.0 blue:98.0 / 255.0 alpha:1.0];
    
    // Setting the default inactive state color to the tableView background color.
    [cell setDefaultColor:[UIColor colorWithRed:233.0 / 255.0 green:234.0 / 255.0 blue:236.0 / 255.0 alpha:1.0]];
    
    // Adding gestures per state basis.
    [cell setSwipeGestureWithView:(UIView*)imageView color:brownColor mode:MCSwipeTableViewCellModeSwitch state:MCSwipeTableViewCellState1 completionBlock:testBlock];
    
    [cell setSwipeGestureWithView:(UIView*)imageView color:brownColor mode:MCSwipeTableViewCellModeSwitch state:MCSwipeTableViewCellState3 completionBlock:testBlock];
    
    cell.modeForState1 = MCSwipeTableViewCellModeSwitch;
    cell.modeForState3 = MCSwipeTableViewCellModeSwitch;
    
    
    
    cell.textLabel.backgroundColor = [UIColor colorWithRed:233.0 / 255.0 green:234.0 / 255.0 blue:236.0 / 255.0 alpha:1.0];
    cell.textLabel.text = [self.algorithmList[indexPath.row] algorithmString];
    
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.imageView.image = [UIImage imageNamed:[self.algorithmList[indexPath.row] imageName]];
    
    UIImageView *bookmarkview = [[UIImageView alloc]initWithFrame:CGRectMake(280,0, 20, 20)];
    bookmarkview.image = [UIImage imageNamed:@"brown-bookmark"];
    
    if ([self algoorithmBookmarked:self.algorithmList[indexPath.row]]) {
        cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"brown-bar"]];
    } else {
        cell.contentView.backgroundColor = [UIColor colorWithRed:233.0 / 255.0 green:234.0 / 255.0 blue:236.0 / 255.0 alpha:1.0];
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
