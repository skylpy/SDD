//
//  AnswerCell.h
//  SDD
//
//  Created by mac on 15/7/23.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnswerLabel.h"

@interface AnswerCell : UITableViewCell

@property (retain,nonatomic)UILabel * contentLabel;
@property (retain,nonatomic)UILabel * timeLabel;
@property (retain,nonatomic)UILabel * numLabel;

//@property (retain,nonatomic)UILabel * answerLabel;
@property (retain,nonatomic)AnswerLabel * answerLabel;
@property (retain,nonatomic)UILabel * CoinLabel;

@end
