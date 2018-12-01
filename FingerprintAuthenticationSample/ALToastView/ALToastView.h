

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ALToastView : UIView {
@private
	UILabel *_textLabel;
}

+ (void)toastInView:(UIView *)parentView withText:(NSString *)text;

//图片压缩到指定大小
+ (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize image:(UIImage*)image;

@end
