

#import "SliderControl.h"

#define kSliderWidth    (int)(self.frame.size.width / numberOfPages)
#define kSliderHeight   self.frame.size.height

#define kLblTag     200

@interface SliderControl()
/**
 *  滑动滑块时的初始位置。
 */
@property (nonatomic, assign) CGPoint beganPoint;


/**
 *  设置背景后为YES，其它状态为NO。
 */
@property (assign, nonatomic, getter = bgColorIsSetted) BOOL bgColorIsSetted;


@end

@implementation SliderControl
@synthesize bgImgView, sliderImgView, numberOfPages, sliderIndex, beganPoint;
@synthesize leftColorView =_leftColorView ;
@synthesize rightColorView = _rightColorView;
@synthesize bgColorIsSetted,touchIsEnd,touchInside;
- (void)dealloc
{
    [self setBgImgView:nil];
    [self setSliderImgView:nil];
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
		[self setBackgroundColor:[UIColor clearColor]];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame andPageNum:(int)pageNum
{
    self = [self initWithFrame:frame];
    
    numberOfPages = pageNum;
    
    bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    [bgImgView setBackgroundColor:[UIColor clearColor]];
    [bgImgView setImage:[[UIImage imageNamed:@"sliderBg.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10]];
    [self addSubview:bgImgView];
    
    [self addBgColorView];
    [self addSlider];
    [self addSliderLabel];
    
    return self;
}

- (void)addBgColorView
{
    CGRect leftRect  = CGRectMake(0, 0, kSliderWidth, kSliderHeight);
    CGRect rightRect = CGRectMake(0, 0, self.bounds.size.width, kSliderHeight);
    
    _rightColorView = [[UIView alloc] initWithFrame:rightRect];
    [self.rightColorView setBackgroundColor:[UIColor colorWithRed:218 / 255.f green:230 / 255.f blue:239 / 255.f alpha:.2]];
    self.rightColorView.layer.cornerRadius = 10;
    self.rightColorView.clipsToBounds = YES;
    [self addSubview:self.rightColorView];
    
    _leftColorView = [[UIView alloc] initWithFrame:leftRect];
    [self.leftColorView setBackgroundColor:[UIColor colorWithRed:0 / 255.f green:56 / 255.f blue:155 / 255.f alpha:.2]];
    self.leftColorView.layer.cornerRadius = 10;
    self.leftColorView.clipsToBounds = YES;
    [self addSubview:self.leftColorView];
}

- (void)addSlider
{
    sliderImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [sliderImgView setBackgroundColor:[UIColor clearColor]];
    [sliderImgView setImage:[[UIImage imageNamed:@"slider.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10]];
    [self addSubview:sliderImgView];
    
	int width = self.frame.size.width / numberOfPages;
	int x = width * sliderIndex;
    
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[sliderImgView setFrame:CGRectMake(x, 0, width, self.frame.size.height)];
	[UIView commitAnimations];
}

- (void)addSliderLabel
{
	for (int i = 0; i < numberOfPages; i++)
	{
        CGRect rect = CGRectMake(i * kSliderWidth, 0, kSliderWidth, kSliderHeight);
        
        UILabel *lbl = [[[UILabel alloc] initWithFrame:rect] autorelease];
        lbl.backgroundColor = [UIColor clearColor];
        lbl.textAlignment = UITextAlignmentCenter;
        lbl.font = [UIFont systemFontOfSize:10];
        lbl.tag = i + kLblTag;
        lbl.textColor = [UIColor colorWithRed:0.0f green:70 / 255.f blue:155 / 255.f alpha:1];
        [self addSubview:lbl];
	}
}


#pragma mark - 

- (void)setSliderLabelTitle:(NSArray *)titles
{
	for (int i = 0; i < numberOfPages; i++)
	{
        UILabel *lbl = (UILabel *)[self viewWithTag:i + kLblTag];
        lbl.text = [titles objectAtIndex:i];
	}
}

- (void)moveSliderToIndex:(int)index animated:(BOOL)animated
{
	sliderIndex = index;
    self.bgColorIsSetted = YES;
	if (animated)
	{
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	}
	
	int width = self.frame.size.width / numberOfPages;
	int x = width * sliderIndex;
	[sliderImgView setFrame:CGRectMake(x, 0, width, self.frame.size.height)];
	if (animated) [UIView commitAnimations];
    
    [self changeBackgroundColor];
}


#pragma mark - touch delegate

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    self.touchIsEnd = NO;

	beganPoint = CGPointMake(sliderImgView.frame.origin.x, sliderImgView.frame.origin.y);
	CGPoint movedPoint = [[touches anyObject] locationInView:self];
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	
	CGRect sliderFrame = [sliderImgView frame];
	float x = movedPoint.x - sliderFrame.size.width / 2;
	if (x < 0)
        x = 0;
	else if (x > self.frame.size.width - sliderFrame.size.width)
        x = self.frame.size.width - sliderFrame.size.width;
	
	sliderFrame.origin.x = x;
    sliderIndex = round(x / kSliderWidth);
	[sliderImgView setFrame:sliderFrame];
	
	[UIView commitAnimations];
    
    [self changeBackgroundColor];
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    self.touchIsEnd = NO;

	CGPoint movedPoint = [[touches anyObject] locationInView:self];
	
	CGRect sliderFrame = [sliderImgView frame];
	float x = movedPoint.x - sliderFrame.size.width / 2;
	if (x < 0)
        x = 0;
	else if (x > self.frame.size.width - sliderFrame.size.width)
        x = self.frame.size.width - sliderFrame.size.width;
	
	sliderFrame.origin.x = x;
	[sliderImgView setFrame:sliderFrame];
    
    [self computeCurrentPage:touches isEnd:NO];
    [self changeBackgroundColor];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.touchIsEnd = NO;
	[self touchesEnded:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{    
    self.touchIsEnd = YES;
    [self computeCurrentPage:touches isEnd:YES];
    
    if (!self.bgColorIsSetted)
    {
        [self changeBackgroundColor];
    }
    NSLog(@"p:%d", sliderIndex);
    [super touchesEnded:touches withEvent:event];
}

-(void)computeCurrentPage:(NSSet *)touches isEnd:(BOOL)isEnd
{
    self.bgColorIsSetted = NO;
    
    float center_x = [sliderImgView frame].origin.x + [sliderImgView frame].size.width/2;
    for (int i = 0; i < numberOfPages; i++)
    {
        float max_x = (i+1) * (self.frame.size.width / numberOfPages);
        if (center_x <= max_x)
        {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            sliderIndex = i;
//            if (isEnd)
            {
                CGRect sliderFrame = [sliderImgView frame];
                sliderFrame.origin.x = (i)*(self.frame.size.width/numberOfPages);
                [sliderImgView setFrame:sliderFrame];
                self.touchIsEnd = YES;
                [self sendActionsForControlEvents:UIControlEventValueChanged];
            }
            [UIView commitAnimations];
            
            break;
        }
    }
}

- (void)changeBackgroundColor
{
    CGRect leftFrame = CGRectMake(0, 0, self.sliderImgView.frame.origin.x + kSliderWidth, kSliderHeight);
    [self.leftColorView setFrame:leftFrame];
    
    CGRect rightFrame = CGRectMake(leftFrame.size.width - kSliderWidth, 0, self.bounds.size.width - leftFrame.size.width + kSliderWidth, kSliderHeight);
    [self.rightColorView setFrame:rightFrame];
    
    for (int i = 0; i < numberOfPages; i++)
    {
        UILabel *lbl = (UILabel *)[self viewWithTag:i + kLblTag];
        
        if (!lbl)   break;
        
        if (i < self.sliderIndex)
        {
            lbl.font = [UIFont systemFontOfSize:10];
            [lbl setTextColor:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1]];
        }
        else if (i > self.sliderIndex)
        {
            lbl.font = [UIFont systemFontOfSize:10];
            [lbl setTextColor:[UIColor colorWithRed:0.0f green:70 / 255.f blue:155 / 255.f alpha:1]];
        }
        else if (i == self.sliderIndex)
        {
            [lbl setTextColor:[UIColor colorWithRed:208 / 255.0f green:25 / 255.f blue:1 / 255.f alpha:1]];
            lbl.font = [UIFont boldSystemFontOfSize:14];
        }
    }
}


@end
