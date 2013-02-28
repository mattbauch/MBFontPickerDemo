//
//  MBFontPickerTableViewController.m
//  MBFontPickerTableViewControllerDemo
//
//  Created by Matthias Bauch on 2/28/13.
//  Copyright (c) 2013 Matthias Bauch. All rights reserved.
//

#import "MBFontPickerTableViewController.h"

@interface MBFontPickerTableViewController ()
@property (strong, nonatomic) NSArray *fontNames;
@end

@implementation MBFontPickerTableViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)fontNames {
    if (!_fontNames) {
        if (_fontFamilyName) {
            _fontNames = [UIFont fontNamesForFamilyName:_fontFamilyName];
        }
        else {
            _fontNames = [[UIFont familyNames] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        }
    }
    return _fontNames;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.fontNames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSString *fontName = nil;
    if (self.fontFamilyName) {
        fontName = self.fontNames[indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else {
        NSString *fontFamilyName = self.fontNames[indexPath.row];
        NSArray *fontNames = [UIFont fontNamesForFamilyName:fontFamilyName];
        fontName = fontNames[0];
        if ([fontNames count] > 1) {
            cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    cell.textLabel.text = fontName;
    cell.textLabel.font = [UIFont fontWithName:fontName size:20.f];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *fontName = nil;
    if (self.fontFamilyName) {
        fontName = self.fontNames[indexPath.row];
    }
    else {
        NSString *fontFamilyName = self.fontNames[indexPath.row];
        NSArray *fontNames = [UIFont fontNamesForFamilyName:fontFamilyName];
        fontName = fontNames[0];
    }
    [self.delegate fontPicker:self didSelectFontWithName:fontName];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    NSString *fontFamilyName = self.fontNames[indexPath.row];
    
    MBFontPickerTableViewController *fontPicker = [[MBFontPickerTableViewController alloc] initWithStyle:self.tableView.style];
    fontPicker.fontFamilyName = fontFamilyName;
    fontPicker.delegate = self.delegate;
    fontPicker.title = self.title;
    [self.navigationController pushViewController:fontPicker animated:YES];
}

#pragma mark - Font Names

- (NSString *)displayNameForFontName:(NSString *)fontName {
    return nil;
}

#pragma mark - Main Font for Family Name

- (UIFont *)fontForFamilyName:(NSString *)familyName {
    return nil;
}

@end
