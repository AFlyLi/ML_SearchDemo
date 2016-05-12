//
//  UIView+Frame.h
//  
//
//  Created by 马文星 on 15/10/24.
//
//    view的尺寸、Frame

#import <UIKit/UIKit.h>

@interface UIView (Frame)

@property (assign, nonatomic) CGFloat    top;
@property (assign, nonatomic) CGFloat    bottom;
@property (assign, nonatomic) CGFloat    left;
@property (assign, nonatomic) CGFloat    right;

@property (assign, nonatomic) CGFloat    x;
@property (assign, nonatomic) CGFloat    y;
@property (assign, nonatomic) CGPoint    origin;

@property (assign, nonatomic) CGFloat    centerX;
@property (assign, nonatomic) CGFloat    centerY;

@property (assign, nonatomic) CGFloat    width;
@property (assign, nonatomic) CGFloat    height;
@property (assign, nonatomic) CGSize    size;


///按照点(x,y)移动
- (void) moveBy: (CGPoint) delta;

///缩放比例
- (void) scaleBy: (CGFloat) scaleFactor;


@end

/*
     UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
     self.myView = myView;
     myView.backgroundColor = [UIColor redColor];
     [self.view addSubview:myView];
     
     self.myView.y = 100;

 */