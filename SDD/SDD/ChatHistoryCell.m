//
//  ChatHistoryCell.m
//  SDD
//
//  Created by Cola on 15/4/12.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "ChatHistoryCell.h"

@interface ChatHistoryCell(){
    
    UILabel *_unreadLabel;
}

@end

@implementation ChatHistoryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _imageFace = [[UIImageView alloc] init];
        _imageFace.contentMode = UIViewContentModeScaleToFill;
        _imageFace.frame = CGRectMake(10, 10, 40, 40);
        [self addSubview:_imageFace];
        
        _unreadLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        _unreadLabel.center = CGPointMake(_imageFace.frame.size.width, 10);
        _unreadLabel.backgroundColor = [UIColor redColor];
        _unreadLabel.textColor = [UIColor whiteColor];
        _unreadLabel.textAlignment = NSTextAlignmentCenter;
        _unreadLabel.font = midFont;
        _unreadLabel.layer.cornerRadius = 10;
        _unreadLabel.clipsToBounds = YES;
        [self addSubview:_unreadLabel];
        
        UIFont *font = [UIFont fontWithName:@"HelveticaNeue" size:14];
        _userName = [[UILabel alloc] init];
        _userName.numberOfLines = 1;
        _userName.frame = CGRectMake(60, 10, viewWidth/3, font.lineHeight);
        _userName.font = font;
        [self addSubview:_userName];
        
        UIFont *font2 = [UIFont fontWithName:@"HelveticaNeue" size:13];
        _userChat = [[UILabel alloc] init];
        _userChat.numberOfLines = 2;
        _userChat.frame = CGRectMake(60, CGRectGetMaxY(_userName.frame), viewWidth - CGRectGetMaxX(_imageFace.frame) - 20, font2.lineHeight * 2);
        _userChat.font = font2;
        [self addSubview:_userChat];
        
        _postTime = [[UILabel alloc] init];
        _postTime.numberOfLines = 1;
        _postTime.font = font2;
//        _postTime.textAlignment = UITextAlignmentRight;
        [self addSubview:_postTime];

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (![_unreadLabel isHidden]) {
        _unreadLabel.backgroundColor = [UIColor redColor];
    }
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    if (![_unreadLabel isHidden]) {
        _unreadLabel.backgroundColor = [UIColor redColor];
    }
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    if (_unreadCount > 0) {
        
        [_unreadLabel setHidden:NO];
        [self.contentView bringSubviewToFront:_unreadLabel];
        _unreadLabel.text = [NSString stringWithFormat:@"%ld",(long)_unreadCount];
    }else{
        [_unreadLabel setHidden:YES];
    }
}

@end
