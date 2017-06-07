//
//  SettingCell.m
//  DriverProject
//
//  Created by 林镇杰 on 15/10/18.
//  Copyright © 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "SettingCell.h"

@implementation SettingCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (CGFloat)seperateLineIndentationWidth
{
    if ([self.isShow isEqualToString:@"show"]) {
        
        return 0;
    }else{
        return self.textLabel.left;
    }
    
    return 0;
}



@end
