//
//  main.m
//  FontDisplayNameCreator
//
//  Created by Matthias Bauch on 2/28/13.
//  Copyright (c) 2013 Matthias Bauch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>
int main(int argc, const char * argv[])
{

    @autoreleasepool {
        NSDictionary *iphoneFonts = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"displayNameForFontName" ofType:@"plist"]];

        NSLog(@"%@", [NSBundle mainBundle]);
        NSMutableDictionary *displayNamedFonts = [NSMutableDictionary dictionaryWithCapacity:[iphoneFonts count]];

        for (NSString *fontFamilyName in iphoneFonts) {
            NSDictionary *fontFamilyDictionary = iphoneFonts[fontFamilyName];
            
            NSMutableDictionary *dict = [fontFamilyDictionary mutableCopy];
            for (NSString *fontName in fontFamilyDictionary) {
                
                NSFont *font = [NSFont fontWithName:fontName size:20.0];
                if ([font displayName]) {
                    [dict setObject:[font displayName] forKey:fontName];
                }
                else {
                    NSLog(@"Can't get display name for font %@", fontName);
                }
            }
            [displayNamedFonts setObject:dict forKey:fontFamilyName];
        }
        
        [displayNamedFonts writeToFile:@"/tmp/displayNameForFontName.plist" atomically:YES];
    }
    return 0;
}

