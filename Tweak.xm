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
		_cameraOpen = NO;
		[[UIScreen mainScreen] setBrightness:_originalBrightness];
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
	CBCameraWillDisappear();
}

%end

%ctor
{
	if (![[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"com.apple.springboard"]) {
		[[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {
			CBCameraWillDisappear();
		}];
	}
}
