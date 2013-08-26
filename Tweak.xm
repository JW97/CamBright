#import <UIKit/UIKit.h>

float _originalBrightness = 0;
BOOL _cameraOpen = NO;

void CBCameraWillAppear() {
	_originalBrightness = [[UIScreen mainScreen] brightness];
	_cameraOpen = YES;
	[[UIScreen mainScreen] setBrightness:1.0f];
}

void CBCameraWillDisappear() {
	if (_cameraOpen && [[UIScreen mainScreen] brightness] == 1.0f) {
NSLog(@".........yes %f",_originalBrightness);
		_cameraOpen = NO;
		//dispatch_after(NSEC_PER_SEC, dispatch_get_main_queue(), ^{
			[[UIScreen mainScreen] setBrightness:_originalBrightness];
		//});
	}
}

%hook PLCameraViewController

- (void)viewWillAppear:(BOOL)animated
{
	%orig;
	CBCameraWillAppear();
}

- (void)viewWillDisappear:(BOOL)animated
{
	%orig;
NSLog(@"will disappear");
	CBCameraWillDisappear();
}

%end

%ctor
{
	if (![[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"com.apple.springboard"]) {
		[[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {
NSLog(@"okies");
			CBCameraWillDisappear();
		}];
	}
}
