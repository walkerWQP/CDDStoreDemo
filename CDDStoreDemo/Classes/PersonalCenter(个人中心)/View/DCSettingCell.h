//
//  DCSettingCell.h
//  CDDMall
//
//  Created by apple on 2017/6/4.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DCSettingCell : UITableViewCell

/* title */
@property (strong , nonatomic)UILabel *titleLabel;
/* 内容 */
@property (strong , nonatomic)UILabel *contentLabel;
/* 日期 */
@property (strong , nonatomic)UITextField *birthField;

@end
