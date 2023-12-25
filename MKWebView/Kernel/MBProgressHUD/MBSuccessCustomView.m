//
//  MBSuccessCustomView.m
//  DongFuWang
//
//  Created by Ye.Sir on 2020/11/19.
//

#import "MBSuccessCustomView.h"

@interface MBSuccessCustomView ()


@end
@implementation MBSuccessCustomView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:0.75];
        [self addSubview:self.iconImgView];
        [self addSubview:self.titleLabel];
        
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 8;
    }
    return self;
}
- (CGSize)intrinsicContentSize{
    CGRect rect = [self.titleLabel.text boundingRectWithSize:CGSizeMake(300, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15 weight:UIFontWeightRegular],NSFontAttributeName, nil] context:nil];
    if (rect.size.width > 300) {
        rect.size.width = 300;
    }else if(rect.size.width < 80){
        rect.size.width = 80;
    }
    return  CGSizeMake(rect.size.width+40, 120);
}
- (void)layoutSubviews{
    CGPoint point = self.center;
    point.x = self.center.x - 17;
    point.y = 45;
    self.iconImgView.center = point;
    self.titleLabel.frame = CGRectMake(0, 80, self.frame.size.width, 15);
}
- (UIImageView *)iconImgView{
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 30, 34, 34)];
        
    }
    return _iconImgView;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.frame = CGRectMake(0, 80, 300, 15);
        _titleLabel.textColor = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1];
        _titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    return  _titleLabel;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
