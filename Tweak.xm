#import <UIKit/UIKit.h>

static float _originalBrightness;

%hook PhotosApplication

- (void)_applicationDidBecomeActive:(id)arg1
{
	%orig;
	_originalBrightness = [[UIScreen mainScreen] brightness];
	[[UIScreen mainScreen] setBrightness:1.0f];
}

- (void)applicationDidEnterBackground:(id)arg1
{
	%orig;
	[[UIScreen mainScreen] setBrightness:_originalBrightness];
}

%end