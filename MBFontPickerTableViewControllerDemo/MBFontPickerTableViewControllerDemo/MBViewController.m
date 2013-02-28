//
//  MBViewController.m
//  MBFontPickerTableViewControllerDemo
//
//  Created by Matthias Bauch on 2/28/13.
//  Copyright (c) 2013 Matthias Bauch. All rights reserved.
//

#import "MBViewController.h"
#import "MBFontPickerTableViewController.h"

@interface MBViewController () <MBFontPickerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *displayNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *fontNameLabel;

@property (weak, nonatomic) IBOutlet UIButton *selectFontButton;

- (IBAction)buttonPressed:(UIButton *)sender;

@end

@implementation MBViewController

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

- (IBAction)buttonPressed:(UIButton *)sender {
    if (sender == self.selectFontButton) {
        MBFontPickerTableViewController *fontPickerTableView = [[MBFontPickerTableViewController alloc] initWithStyle:UITableViewStylePlain];
        fontPickerTableView.delegate = self;
        fontPickerTableView.title = @"Select Font";
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:fontPickerTableView];
        [self presentViewController:navController animated:YES completion:nil];
    }
}

#pragma mark - MBFontPickerDelegate

- (void)fontPicker:(MBFontPickerTableViewController *)fontPicker didSelectFontWithName:(NSString *)fontName {
    UIFont *font = [UIFont fontWithName:fontName size:15];
    self.displayNameLabel.font = font;
    self.displayNameLabel.text = [fontPicker displayNameForFontName:fontName];
    self.fontNameLabel.font = font;
    self.fontNameLabel.text = fontName;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)fontPickerDidCancel:(MBFontPickerTableViewController *)fontPicker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
