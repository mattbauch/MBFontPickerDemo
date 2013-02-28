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
@property (strong, nonatomic) NSString *selectedFontFamily;
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

- (void)setSelectedFont:(NSString *)selectedFont {
    _selectedFont = [selectedFont copy];
    _selectedFontFamily = nil;
    for (NSString *fontFamilyName in [UIFont familyNames]) {
        NSArray *fontNames = [UIFont fontNamesForFamilyName:fontFamilyName];
        if ([fontNames containsObject:selectedFont]) {
            _selectedFontFamily = fontFamilyName;
            break;
        }
    }
    [self.tableView reloadData];
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
        NSString *displayName = [[self class] displayNameForFontName:fontName];
        if (!displayName) {
            // display name not found in plist. use font name
            displayName = fontName;
        }
        cell.textLabel.text = displayName;
        cell.textLabel.font = [UIFont fontWithName:fontName size:20.f];
        
        if ([fontName isEqualToString:self.selectedFont]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    else {
        NSString *fontFamilyName = self.fontNames[indexPath.row];
        NSString *defaultFontName = [[self class] defaultFontNameForFamilyName:fontFamilyName];
        if (!defaultFontName) {
            // default font not found in plist. use first font
            defaultFontName = [UIFont fontNamesForFamilyName:fontFamilyName][0];
        }
        cell.textLabel.text = fontFamilyName;
        cell.textLabel.font = [UIFont fontWithName:defaultFontName size:20.f];
        
        if ([[UIFont fontNamesForFamilyName:fontFamilyName] count] > 1) {
            // if there are at least two fonts show accessory button so we can choose them
            cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        if ([fontFamilyName isEqualToString:self.selectedFontFamily]) {
            cell.imageView.image = [UIImage imageNamed:@"checkmark"];
        }
        else {
            cell.imageView.image = nil;
        }
    }
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
        fontName = [[self class] defaultFontNameForFamilyName:fontFamilyName];
    }
    [self.delegate fontPicker:self didSelectFontWithName:fontName];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    NSString *fontFamilyName = self.fontNames[indexPath.row];
    
    MBFontPickerTableViewController *fontPicker = [[MBFontPickerTableViewController alloc] initWithStyle:self.tableView.style];
    fontPicker.fontFamilyName = fontFamilyName;
    fontPicker.delegate = self.delegate;
    fontPicker.title = self.title;
    fontPicker.selectedFont = self.selectedFont;
    [self.navigationController pushViewController:fontPicker animated:YES];
}

#pragma mark - Font Names

+ (NSDictionary *)displayNamesDictionary {
    static NSDictionary *displayNamesDictionary;
    if (!displayNamesDictionary) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"displayNameForFontName" ofType:@"plist"];
        if (path) {
            NSDictionary *displayNamesOnDisc = [NSDictionary dictionaryWithContentsOfFile:path];
            
            NSMutableDictionary *temp = [NSMutableDictionary dictionaryWithCapacity:200];
            for (NSString *fontFamilyName in displayNamesOnDisc) {
                NSDictionary *fontFamilyDictionary = displayNamesOnDisc[fontFamilyName];
                for (NSString *fontName in fontFamilyDictionary) {
                    [temp setObject:fontFamilyDictionary[fontName] forKey:fontName];
                }
            }
            displayNamesDictionary = [temp copy];
        }
    }
    return displayNamesDictionary;
}


+ (NSString *)displayNameForFontName:(NSString *)fontName {
    return [self.displayNamesDictionary objectForKey:fontName];;
}

#pragma mark - Main Font for Family Name


+ (NSDictionary *)defaultFontsDictionary {
    static NSDictionary *defaultFontsDictionary;
    if (!defaultFontsDictionary) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"defaultFontForFamilyName" ofType:@"plist"];
        if (path) {
            defaultFontsDictionary = [NSDictionary dictionaryWithContentsOfFile:path];
        }
    }
    return defaultFontsDictionary;
}

+ (NSString *)defaultFontNameForFamilyName:(NSString *)familyName {
    return [self.defaultFontsDictionary objectForKey:familyName];
}

@end
