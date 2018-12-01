

#import <QuartzCore/QuartzCore.h>
#import "ALToastView.h"


// Set visibility duration
static const CGFloat kDuration = 2;


// Static toastview queue variable
static NSMutableArray *toasts;




@interface ALToastView ()

@property (nonatomic, readonly) UILabel *textLabel;

- (void)fadeToastOut;
+ (void)nextToastInView:(UIView *)parentView;

@end





@implementation ALToastView

@synthesize textLabel = _textLabel;


#pragma mark - NSObject

- (id)initWithText:(NSString *)text {
	if ((self = [self initWithFrame:CGRectZero])) {
		// Add corner radius
		self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.6];
		self.layer.cornerRadius = 5;
		self.autoresizingMask = UIViewAutoresizingNone;
		self.autoresizesSubviews = NO;
		
		// Init and add label
		_textLabel = [[UILabel alloc] init];
		_textLabel.text = text;
        _textLabel.numberOfLines = 0;
        _textLabel.textAlignment = NSTextAlignmentCenter;
		_textLabel.font = [UIFont systemFontOfSize:14];
		_textLabel.textColor = [UIColor whiteColor];
		_textLabel.adjustsFontSizeToFitWidth = NO;
		_textLabel.backgroundColor = [UIColor clearColor];
		[_textLabel sizeToFit];
		
		[self addSubview:_textLabel];
		_textLabel.frame = CGRectOffset(_textLabel.frame, 0, 0);
        
        if (_textLabel.frame.size.width > [UIScreen mainScreen].bounds.size.width - 40) {
            _textLabel.frame = CGRectMake(0, 5, [UIScreen mainScreen].bounds.size.width - 40, 40);
        }else{
            _textLabel.frame = CGRectOffset(_textLabel.frame, 10, 5);
        }
        
        
	}
	
	return self;
}



#pragma mark - Public

+ (void)toastInView:(UIView *)parentView withText:(NSString *)text {
	// Add new instance to queue
	ALToastView *view = [[ALToastView alloc] initWithText:text];
  
	CGFloat lWidth = view.textLabel.frame.size.width;
	CGFloat lHeight = view.textLabel.frame.size.height;
	CGFloat pWidth = parentView.frame.size.width;
	CGFloat pHeight = parentView.frame.size.height;
	
	// Change toastview frame
	view.frame = CGRectMake((pWidth - lWidth - 20) / 2., pHeight - lHeight - 300, lWidth + 20, lHeight + 10);
	view.alpha = 0.0f;
	
//    if (toasts != 0) {
//        return;
//    }
    
	if (toasts == nil) {
		toasts = [[NSMutableArray alloc] initWithCapacity:1];
		[toasts addObject:view];
		[ALToastView nextToastInView:parentView];
	}
	else {
		[toasts addObject:view];
	}
  }


#pragma mark - Private

- (void)fadeToastOut {
	// Fade in parent view
  [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionAllowUserInteraction
   
                   animations:^{
                     self.alpha = 0.f;
                   } 
                   completion:^(BOOL finished){
                     UIView *parentView = self.superview;
                     [self removeFromSuperview];
                     
                     // Remove current view from array
                     [toasts removeObject:self];
                     if ([toasts count] == 0) {
                    
                       toasts = nil;
                     }
                     else
                       [ALToastView nextToastInView:parentView];
                   }];
}


+ (void)nextToastInView:(UIView *)parentView {
	if ([toasts count] > 0) {
    ALToastView *view = [toasts objectAtIndex:0];
    
		// Fade into parent view
		[parentView addSubview:view];
    [UIView animateWithDuration:.5  delay:0 options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
      view.alpha = 1.0;
                     } completion:^(BOOL finished){}];
    
    // Start timer for fade out
    [view performSelector:@selector(fadeToastOut) withObject:nil afterDelay:kDuration];
  }
}

//图片压缩到指定大小
+ (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize image:(UIImage*)image
{
    UIImage *sourceImage = image;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth= width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor < heightFactor)
        {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width= scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil)
        NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}



@end
