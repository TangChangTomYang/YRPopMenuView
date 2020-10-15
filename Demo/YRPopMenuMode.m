//
//  ViewController.h
//  Demo
//
//  Created by edz on 2020/10/15.
//  Copyright © 2020 WellsCai. All rights reserved.

#import "YRPopMenuMode.h"

@implementation YRPopMenuMode

+(instancetype)modeWithTitle:(NSString *)title image:(UIImage *)image{
   YRPopMenuMode *mode = [[YRPopMenuMode alloc] init];
    mode.title = title;
    mode.image = image;
    return mode;;
    
}
@end
