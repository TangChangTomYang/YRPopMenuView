//
//  YRPopMenuView.h
//  Demo
//
//  Created by edz on 2020/10/15.
//  Copyright © 2020 WellsCai. All rights reserved.

#define kYRScreenWidth               [UIScreen mainScreen].bounds.size.width
#define kYRScreenHeight              [UIScreen mainScreen].bounds.size.height
#define kYRMainWindow                [UIApplication sharedApplication].keyWindow

#define kYRArrowWidth          15
#define kYRArrowHeight         10
#define kYRDefaultMargin       10
#define kYRAnimationTime       0.25

#import "YRPopMenuView.h"

@interface UIView (YRFrame)
@property (nonatomic, assign) CGFloat yr_x;
@property (nonatomic, assign) CGFloat yr_y;
@property (nonatomic, assign) CGPoint yr_origin;

@property (nonatomic, assign) CGFloat yr_centerX;
@property (nonatomic, assign) CGFloat yr_centerY;

@property (nonatomic, assign) CGFloat yr_width;
@property (nonatomic, assign) CGFloat yr_height;
@property (nonatomic, assign) CGSize  yr_size;
@end

@implementation UIView (YRFrame)

- (CGFloat)yr_x{
    return self.frame.origin.x;
}
-(void)setYr_x:(CGFloat)yr_x{
    CGRect frame = self.frame;
    frame.origin.x = yr_x;
    self.frame = frame;
}

- (CGFloat)yr_y{
    return self.frame.origin.y;
}

-(void)setYr_y:(CGFloat)yr_y{
    CGRect frame = self.frame;
    frame.origin.y = yr_y;
    self.frame = frame;
}

- (CGPoint)yr_origin{
    return self.frame.origin;
}
-(void)setYr_origin:(CGPoint)yr_origin{
    CGRect frame = self.frame;
    frame.origin = yr_origin;
    self.frame = frame;
}


- (CGFloat)yr_centerX{
    return self.center.x;
}
-(void)setYr_centerX:(CGFloat)yr_centerX{
    CGPoint center = self.center;
    center.x = yr_centerX;
    self.center = center;
}

- (CGFloat)yr_centerY{
    return self.center.y;
}

-(void)setYr_centerY:(CGFloat)yr_centerY{
    CGPoint center = self.center;
    center.y = yr_centerY;
    self.center = center;
}

- (CGFloat)yr_width{
    return self.frame.size.width;
}

- (void)setYr_width:(CGFloat)yr_width{
    CGRect frame = self.frame;
    frame.size.width = yr_width;
    self.frame = frame;
}

- (CGFloat)yr_height{
    return self.frame.size.height;
}
- (void)setYr_height:(CGFloat)yr_height{
    CGRect frame = self.frame;
    frame.size.height = yr_height;
    self.frame = frame;
}

- (CGSize)yr_size{
    return self.frame.size;
}

- (void)setYr_size:(CGSize)yr_size{
    CGRect frame = self.frame;
    frame.size = yr_size;
    self.frame = frame;
}
@end





@interface YCMenuCell : UITableViewCell
@property (nonatomic,assign) BOOL         isShowSeparator;
@property (nonatomic,strong) UIColor    * separatorColor;
@end

@implementation YCMenuCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _isShowSeparator = YES;
        _separatorColor = [UIColor lightGrayColor];
    }
    return self;
}

- (void)setSeparatorColor:(UIColor *)separatorColor{
    _separatorColor = separatorColor;
    [self setNeedsDisplay];
}
- (void)setIsShowSeparator:(BOOL)isShowSeparator{
    _isShowSeparator = isShowSeparator;
    [self setNeedsDisplay];
}
- (void)drawRect:(CGRect)rect{
    if (!_isShowSeparator)return;
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, rect.size.height - 0.5, rect.size.width, 0.5)];
    [_separatorColor setFill];
    [path fillWithBlendMode:kCGBlendModeNormal alpha:1.0f];
    [path closePath];
}
@end

 

@interface YRPopMenuView()<UITableViewDelegate,UITableViewDataSource>
{
    CGPoint          _refPoint;
    UIView          *_refView;
    CGFloat          _menuWidth;
    
    CGFloat         _arrowPosition; // 三角底部的起始点x
    CGFloat         _topMargin;
    BOOL            _isReverse; // 是否反向
    BOOL            _needReload; //是否需要刷新
}
@property(nonatomic,copy) NSArray<YRPopMenuMode *> *modeArr;
@property(nonatomic,strong)UITableView              *tableView;
@property(nonatomic,strong)UIView                   *contentView;
@property(nonatomic,strong)UIView                   *bgView;

@end

static NSString *const menuCellID = @"YCMenuCell";
@implementation YRPopMenuView



// 从关联点创建
+ (instancetype)menuWithModeArr:(NSArray<YRPopMenuMode *> *)modeArr width:(CGFloat)width atPoint:(CGPoint)point{
    NSAssert(width>0.0f, @"width要大于0");
    YRPopMenuView *menu = [[YRPopMenuView alloc] initWithModeArr:modeArr width:width atPoint:point];
    return menu;
}

// 从关联视图创建（可以是UIView和UIBarButtonItem）
+ (instancetype)menuWithModeArr:(NSArray<YRPopMenuMode *> *)modeArr width:(CGFloat)width relyonView:(id)view{
    NSAssert(width>0.0f, @"width要大于0");
    NSAssert([view isKindOfClass:[UIView class]]||[view isKindOfClass:[UIBarButtonItem class]], @"relyonView必须是UIView或UIBarButtonItem");
    YRPopMenuView *menu = [[YRPopMenuView alloc] initWithModeArr:modeArr width:width relyonView:view];
    return menu;
}

- (instancetype)initWithModeArr:(NSArray<YRPopMenuMode *> *)modeArr width:(CGFloat)width atPoint:(CGPoint)point{
    if (self = [super init]) {
        _modeArr = modeArr;
        _refPoint = point;
        _menuWidth = width;
        [self defaultConfiguration];
        [self setupSubView];
    }
    return self;
}

- (instancetype)initWithModeArr:(NSArray<YRPopMenuMode *> *)modeArr width:(CGFloat)width relyonView:(id)view{
    if (self = [super init]) {
        // 针对UIBarButtonItem做的处理
        if ([view isKindOfClass:[UIBarButtonItem class]]) {
            UIView *bgView = [view valueForKey:@"_view"];
            _refView = bgView;
        }else{
            _refView = view;
        }
        _modeArr = modeArr;
        _menuWidth = width;
        [self defaultConfiguration];
        [self setupSubView];
    }
    return self;
}

- (void)defaultConfiguration{
    self.alpha = 0.0f;
    [self setDefaultShadow];
    
    _cornerRaius = 5.0f;
    _separatorColor = [UIColor blackColor];
    _menuColor = [UIColor whiteColor];
    _menuCellHeight = 44.0f;
    _maxDisplayCount = 5;
    _isShowShadow = YES;
    _dismissOnselected = YES;
    _dismissOnTouchOutside = YES;
    
    _textColor = [UIColor blackColor];
    _textFont = [UIFont systemFontOfSize:15.0f];
    _offset = 0.0f;
}

- (void)setupSubView{
    [self calculateArrowAndFrame];
    [self setupMaskLayer];
    [self addSubview:self.contentView];
}

- (void)reloadData{
    [self.contentView removeFromSuperview];
    [self.tableView removeFromSuperview];
    self.contentView = nil;
    self.tableView = nil;
    [self setupSubView];
}

- (CGPoint)getRefPoint{
    CGRect absoluteRect = [_refView convertRect:_refView.bounds toView:kYRMainWindow];
    CGPoint refPoint;
    
    if (absoluteRect.origin.y + absoluteRect.size.height + _modeArr.count * _menuCellHeight > kYRScreenHeight - 10) {
        refPoint = CGPointMake(absoluteRect.origin.x + absoluteRect.size.width / 2, absoluteRect.origin.y);
        _isReverse = YES;
    }else{
        refPoint = CGPointMake(absoluteRect.origin.x + absoluteRect.size.width / 2, absoluteRect.origin.y + absoluteRect.size.height);
        _isReverse = NO;
    }
    return refPoint;
}

- (void)show{
    // 自定义设置统一在这边刷新一次
    if (_needReload) [self reloadData];
    
    [kYRMainWindow addSubview: self.bgView];
    [kYRMainWindow addSubview: self];
    self.layer.affineTransform = CGAffineTransformMakeScale(0.1, 0.1);
    [UIView animateWithDuration: kYRAnimationTime animations:^{
        self.layer.affineTransform = CGAffineTransformMakeScale(1.0, 1.0);
        self.alpha = 1.0f;
        self.bgView.alpha = 1.0f;
    }];
}

- (void)dismiss{
    if (!_dismissOnTouchOutside) return;
    [UIView animateWithDuration: kYRAnimationTime animations:^{
        self.layer.affineTransform = CGAffineTransformMakeScale(0.1, 0.1);
        self.alpha = 0.0f;
        self.bgView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.bgView removeFromSuperview];
        self.modeArr = nil;
    }];
}

#pragma mark - Private
- (void)setupMaskLayer{
    CAShapeLayer *layer = [self drawMaskLayer];
    self.contentView.layer.mask = layer;
}

- (void)calculateArrowAndFrame{
    if (_refView) {
        _refPoint = [self getRefPoint];
    }
    
    CGFloat originX;
    CGFloat originY;
    CGFloat width;
    CGFloat height;
    
    width = _menuWidth;
    height = (_modeArr.count > _maxDisplayCount) ? _maxDisplayCount * _menuCellHeight + kYRArrowHeight: _modeArr.count * _menuCellHeight + kYRArrowHeight;
    // 默认在中间
    _arrowPosition = 0.5 * width - 0.5 * kYRArrowWidth;
    
    // 设置出menu的x和y（默认情况）
    originX = _refPoint.x - _arrowPosition - 0.5 * kYRArrowWidth;
    originY = _refPoint.y;
    
    // 考虑向左右展示不全的情况，需要反向展示
    if (originX + width > kYRScreenWidth - 10) {
        originX = kYRScreenWidth - kYRDefaultMargin - width;
    }else if (originX < 10) {
        //向上的情况间距也至少是kDefaultMargin
        originX = kYRDefaultMargin;
    }
    
    //设置三角形的起始点
    if ((_refPoint.x <= originX + width - _cornerRaius) && (_refPoint.x >= originX + _cornerRaius)) {
        _arrowPosition = _refPoint.x - originX - 0.5 * kYRArrowWidth;
    }else if (_refPoint.x < originX + _cornerRaius) {
        _arrowPosition = _cornerRaius;
    }else {
        _arrowPosition = width - _cornerRaius - kYRArrowWidth;
    }
    
    //如果不是根据关联视图，得算一次是否反向
    if (!_refView) {
        _isReverse = (originY + height > kYRScreenHeight - kYRDefaultMargin)?YES:NO;
    }
    
    CGPoint  anchorPoint;
    if (_isReverse) {
        originY = _refPoint.y - height;
        anchorPoint = CGPointMake(fabs(_arrowPosition) / width, 1);
        _topMargin = 0;
    }else{
        anchorPoint = CGPointMake(fabs(_arrowPosition) / width, 0);
        _topMargin = kYRArrowHeight;
    }
    originY += originY >= _refPoint.y ? _offset : -_offset;
    
    //保存原来的frame，防止设置锚点后偏移
    self.layer.anchorPoint = anchorPoint;
    self.frame = CGRectMake(originX, originY, width, height);
}

- (CAShapeLayer *)drawMaskLayer{
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    CGFloat bottomMargin = !_isReverse?0 :kYRArrowHeight;
    
    // 定出四个转角点
    CGPoint topRightArcCenter = CGPointMake(self.yr_width - _cornerRaius, _topMargin + _cornerRaius);
    CGPoint topLeftArcCenter = CGPointMake(_cornerRaius, _topMargin + _cornerRaius);
    CGPoint bottomRightArcCenter = CGPointMake(self.yr_width - _cornerRaius, self.yr_height - bottomMargin - _cornerRaius);
    CGPoint bottomLeftArcCenter = CGPointMake(_cornerRaius, self.yr_height - bottomMargin - _cornerRaius);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    // 从左上倒角的下边开始画
    [path moveToPoint: CGPointMake(0, _topMargin + _cornerRaius)];
    [path addLineToPoint: CGPointMake(0, bottomLeftArcCenter.y)];
    [path addArcWithCenter: bottomLeftArcCenter radius: _cornerRaius startAngle: -M_PI endAngle: -M_PI-M_PI_2 clockwise: NO];
    
    if (_isReverse) {
        [path addLineToPoint: CGPointMake(_arrowPosition, self.yr_height - kYRArrowHeight)];
        [path addLineToPoint: CGPointMake(_arrowPosition + 0.5*kYRArrowWidth, self.yr_height)];
        [path addLineToPoint: CGPointMake(_arrowPosition + kYRArrowWidth, self.yr_height - kYRArrowHeight)];
    }
    [path addLineToPoint: CGPointMake(self.yr_width - _cornerRaius, self.yr_height - bottomMargin)];
    [path addArcWithCenter: bottomRightArcCenter radius: _cornerRaius startAngle: -M_PI-M_PI_2 endAngle: -M_PI*2 clockwise: NO];
    [path addLineToPoint: CGPointMake(self.yr_width, self.yr_height - bottomMargin + _cornerRaius)];
    [path addArcWithCenter: topRightArcCenter radius: _cornerRaius startAngle: 0 endAngle: -M_PI_2 clockwise: NO];
    
    if (!_isReverse) {
        [path addLineToPoint: CGPointMake(_arrowPosition + kYRArrowWidth, _topMargin)];
        [path addLineToPoint: CGPointMake(_arrowPosition + 0.5 * kYRArrowWidth, 0)];
        [path addLineToPoint: CGPointMake(_arrowPosition, _topMargin)];
    }
    
    [path addLineToPoint: CGPointMake(_cornerRaius, _topMargin)];
    [path addArcWithCenter: topLeftArcCenter radius: _cornerRaius startAngle: -M_PI_2 endAngle: -M_PI clockwise: NO];
    [path closePath];
    
    maskLayer.path = path.CGPath;
    return maskLayer;
}
- (void)setDefaultShadow{
    self.layer.shadowOpacity = 0.5;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.layer.shadowRadius = 5.0;
}

#pragma mark - <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _modeArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YCMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:menuCellID forIndexPath:indexPath];
    YRPopMenuMode *mode = _modeArr[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = _textFont;
    cell.textLabel.textColor = _textColor;
    cell.textLabel.text = mode.title;
    cell.separatorColor = _separatorColor;
    cell.imageView.image = mode.image?mode.image:nil;
    
    if (indexPath.row == _modeArr.count - 1) {
        cell.isShowSeparator = NO;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_dismissOnselected) [self dismiss];
    
    YRPopMenuMode *mode = _modeArr[indexPath.row];
    
    if (self.clickCallback) {
        self.clickCallback(indexPath.row, mode);
    }
}

#pragma mark - Setting&&Getting
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _topMargin, self.yr_width, self.yr_height - kYRArrowHeight) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces = _modeArr.count > _maxDisplayCount? YES : NO;
        _tableView.rowHeight = _menuCellHeight;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[YCMenuCell class] forCellReuseIdentifier:menuCellID];
    }
    return _tableView;
}
- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
        _bgView.alpha = 0.0f;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [_bgView addGestureRecognizer:tap];
    }
    return _bgView;
}

- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:self.bounds];
        _contentView.backgroundColor = _menuColor;
        _contentView.layer.masksToBounds = YES;
        [_contentView addSubview:self.tableView];
    }
    return _contentView;
}
#pragma mark - 设置属性
- (void)setCornerRaius:(CGFloat)cornerRaius{
    if (_cornerRaius == cornerRaius)return;
    _cornerRaius = cornerRaius;
    self.contentView.layer.mask = [self drawMaskLayer];
}
- (void)setMenuColor:(UIColor *)menuColor{
    if ([_menuColor isEqual:menuColor]) return;
    _menuColor = menuColor;
    self.contentView.backgroundColor = menuColor;
}
- (void)setBackgroundColor:(UIColor *)backgroundColor{
    if ([_menuColor isEqual:backgroundColor]) return;
    _menuColor = backgroundColor;
    self.contentView.backgroundColor = _menuColor;
}
- (void)setSeparatorColor:(UIColor *)separatorColor{
    if ([_separatorColor isEqual:separatorColor]) return;
    _separatorColor = separatorColor;
    [self.tableView reloadData];
}
- (void)setMenuCellHeight:(CGFloat)menuCellHeight{
    if (_menuCellHeight == menuCellHeight)return;
    _menuCellHeight = menuCellHeight;
    _needReload = YES;
}
- (void)setMaxDisplayCount:(NSInteger)maxDisplayCount{
    if (_maxDisplayCount == maxDisplayCount)return;
    _maxDisplayCount = maxDisplayCount;
    _needReload = YES;
}
- (void)setIsShowShadow:(BOOL)isShowShadow{
    if (_isShowShadow == isShowShadow)return;
    _isShowShadow = isShowShadow;
    if (!_isShowShadow) {
        self.layer.shadowOpacity = 0.0;
        self.layer.shadowOffset = CGSizeMake(0, 0);
        self.layer.shadowRadius = 0.0;
    }else{
        [self setDefaultShadow];
    }
}
- (void)setTextFont:(UIFont *)textFont{
    if ([_textFont isEqual:textFont]) return;
    _textFont = textFont;
    [self.tableView reloadData];
}
- (void)setTextColor:(UIColor *)textColor{
    if ([_textColor isEqual:textColor]) return;
    _textColor = textColor;
    [self.tableView reloadData];
}
- (void)setOffset:(CGFloat)offset{
    if (offset == offset) return;
    _offset = offset;
    if (offset < 0.0f) {
        offset = 0.0f;
    }
    self.yr_y += self.yr_y >= _refPoint.y ? offset : -offset;
}
@end
