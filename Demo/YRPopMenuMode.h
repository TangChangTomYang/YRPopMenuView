//
//  YRPopMenuMode.h
//  Demo
//
//  Created by edz on 2020/10/15.
//  Copyright © 2020 WellsCai. All rights reserved.

#import <UIKit/UIKit.h>

 

@interface YRPopMenuMode : NSObject
@property (nonatomic, strong) NSString      *title;
@property (nonatomic, strong) UIImage       *image;


+(instancetype)modeWithTitle:(NSString *)title image:(UIImage *)image;
@end

 
