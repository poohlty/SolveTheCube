//
//  SCMarkViewController.m
//  SolveTheCube2
//
//  Created by Tianyu Liu on 5/4/13.
//  Copyright (c) 2013 Tianyu Liu. All rights reserved.
//

#import "SCBookmarkViewController.h"
#import "MCSwipeTableViewCell.h"
#import "MBProgressHUD.h"

@interface SCBookmarkViewController () <MCSwipeTableViewCellDelegate,MBProgressHUDDelegate>

@end

@implementation SCBookmarkViewController{
    NSUserDefaults *standardUserDefaults;
    NSInteger rowCount;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:233.0 / 255.0 green:234.0 / 255.0 blue:236.0 / 255.0 alpha:1.0];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadAlgorithms)
                                                 name:@"bookmarkAdded"
                                               object:nil];
    [self loadAlgorithms];

    UIImage *tabBarItemImg = [UIImage imageNamed:[NSString stringWithFormat: @"Bookmark-icon.png"]];
    [self.tabBarItem setFinishedSelectedImage:tabBarItemImg withFinishedUnselectedImage:tabBarItemImg];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)loadAlgorithms{
    standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *tempBookmark = [standardUserDefaults arrayForKey:@"bookmark"];
    
    self.algorithmList = tempBookmark;
    rowCount = self.algorithmList.count;
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return rowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"bookmarkCell";
    
    MCSwipeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[MCSwipeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [cell setDelegate:self];
    [cell setFirstStateIconName:@"check.png"
                     firstColor:[UIColor colorWithRed:85.0 / 255.0 green:213.0 / 255.0 blue:80.0 / 255.0 alpha:1.0]
            secondStateIconName:nil
                    secondColor:nil
                  thirdIconName:@"check.png"
                     thirdColor:[UIColor colorWithRed:85.0 / 255.0 green:213.0 / 255.0 blue:80.0 / 255.0 alpha:1.0]
                 fourthIconName:nil
                    fourthColor:nil];
    
    [cell.contentView setBackgroundColor:[UIColor lightGrayColor]];
    [cell setMode:MCSwipeTableViewCellModeExit];
    
    [cell.contentView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"brown-bar"]]];

    cell.textLabel.backgroundColor = [UIColor colorWithRed:233.0 / 255.0 green:234.0 / 255.0 blue:236.0 / 255.0 alpha:1.0];
    cell.textLabel.text = self.algorithmList[indexPath.row][@"algorithmString"];
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.imageView.image = [UIImage imageNamed:self.algorithmList[indexPath.row][@"imageName"]];
    
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (void)swipeTableViewCell:(MCSwipeTableViewCell *)cell didTriggerState:(MCSwipeTableViewCellState)state withMode:(MCSwipeTableViewCellMode)mode
{
    //grab the standardUserDefault to change bookmark array
    NSMutableArray *tempBookmark =
    [[NSMutableArray alloc]initWithArray:[standardUserDefaults arrayForKey:@"bookmark"]];
    NSDictionary *thisAlgorithm = self.algorithmList[[[self.tableView indexPathForCell:cell] row]];
    
    NSLog(@"%@",thisAlgorithm[@"algorithmString"]);
    
    [tempBookmark removeObject:thisAlgorithm];
    [standardUserDefaults setObject:tempBookmark forKey:@"bookmark"];
    
    rowCount--;
    [self.tableView deleteRowsAtIndexPaths:@[[self.tableView indexPathForCell:cell]] withRowAnimation:UITableViewRowAnimationFade];
    //post a notification to FavController and CollectionViewController to update collection view
    [[NSNotificationCenter defaultCenter] postNotificationName:@"bookmarkDeleted" object:nil];
    
    [self showWithCustomView:@"Remembered"];
    
    NSLog(@"IndexPath : %@ - MCSwipeTableViewCellState : %d - MCSwipeTableViewCellMode : %d", [self.tableView indexPathForCell:cell], state, mode);
}

- (void)showWithCustomView:(NSString *)message {
	
	MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.tabBarController.view];
	[self.tabBarController.view addSubview:HUD];
	
	HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check.png"]];
	
	// Set custom view mode
	HUD.mode = MBProgressHUDModeCustomView;
	HUD.delegate = self;
	HUD.labelText = message;
	[HUD show:YES];
	[HUD hide:YES afterDelay:0.6];
}


@end
