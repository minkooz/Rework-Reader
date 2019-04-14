//
//  RPSettingInputer.m
//  rework-reader
//
//  Created by 张超 on 2019/2/11.
//  Copyright © 2019 orzer. All rights reserved.
//

#import "RPSettingInputer.h"
#import "RRModelItem.h"
@implementation RPSettingInputer

- (NSString *)mvp_identifierForModel:(RRSetting*)model
{
    switch ([model.type intValue]) {
        case RRSettingTypeTitle:
        {
            return @"titleCell";
            break;
        }
        case RRSettingTypeSwitch:
        {
            return @"switchCell";
            break;
        }
        case RRSettingTypeIcon:
        {
            return @"iconCell";
            break;
        }
        default:
            break;
    }
    
    return @"settingBaseCell";
}

@end
