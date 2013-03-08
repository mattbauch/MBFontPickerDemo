//
//  MBViewController.m
//  MBFontPickerTableViewControllerDemo
//
//  Created by Matthias Bauch on 2/28/13.
//  Copyright (c) 2013 Matthias Bauch. All rights reserved.
//

#import "MBViewController.h"
#import "MBFontPickerTableViewController.h"

static NSString * const MBUDFontKey = @"fontName";

@interface MBViewController () <MBFontPickerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *displayNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *fontNameLabel;

@property (weak, nonatomic) IBOutlet UIButton *selectFontButton;

- (IBAction)buttonPressed:(UIButton *)sender;

@end

@implementation MBViewController {
    NSDictionary *_defaultFontNames;
    NSDictionary *_displayFontNames;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _defaultFontNames = @{ @"Ubuntu" : @"Ubuntu" };
    _displayFontNames = @{ @"Ubuntu" : @"Ubuntu Regular",
                           @"Ubuntu-Medium" : @"Ubuntu Medium",
                           @"Ubuntu-Bold" : @"Ubuntu Bold" };

    NSString *fontName = [[NSUserDefaults standardUserDefaults] objectForKey:MBUDFontKey];
    if (!fontName) {
        fontName = [[UIFont fontWithName:@"Ubuntu-Medium" size:17] fontName];
    }
    [self configureViewForFontName:fontName];
}

- (IBAction)buttonPressed:(UIButton *)sender {
    if (sender == self.selectFontButton) {
        MBFontPickerTableViewController *fontPickerTableView = [[MBFontPickerTableViewController alloc] initWithStyle:UITableViewStylePlain];
        fontPickerTableView.delegate = self;
        fontPickerTableView.title = @"Select Font";
        fontPickerTableView.selectedFont = [self.fontNameLabel.font fontName];
        fontPickerTableView.scrollToFontWhenViewWillAppear = YES;
        
        fontPickerTableView.customDefaultFontNames = _defaultFontNames;
        fontPickerTableView.customDisplayFontNames = _displayFontNames;

        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:fontPickerTableView];
        [self presentViewController:navController animated:YES completion:nil];
    }
}

- (void)configureViewForFontName:(NSString *)fontName {
    UIFont *font = [UIFont fontWithName:fontName size:[self.displayNameLabel.font pointSize]];
    self.displayNameLabel.font = font;
    self.displayNameLabel.text = [MBFontPickerTableViewController displayNameForFontName:fontName customFontList:_displayFontNames];
    self.fontNameLabel.font = font;
    self.fontNameLabel.text = fontName;
}

#pragma mark - MBFontPickerDelegate

- (void)fontPicker:(MBFontPickerTableViewController *)fontPicker didSelectFontWithName:(NSString *)fontName {
    [self configureViewForFontName:fontName];
    [self dismissViewControllerAnimated:YES completion:nil];
    [[NSUserDefaults standardUserDefaults] setObject:fontName forKey:MBUDFontKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
