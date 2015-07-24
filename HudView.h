//
//  HudView.h
//  YumYum2
//
//  Created by Maurice Mickens on 3/25/15.
//  Copyright (c) 2015 Loud Skies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HudView : UIView

+ (instancetype)hudInView:(UIView *)view
                 animated:(BOOL)animated;
@property (nonatomic, strong) NSString *text;

@end
