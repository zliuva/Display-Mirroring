#import <Foundation/Foundation.h>

static NSString *plistPath = nil;
static NSAutoreleasePool *pool = nil;

BOOL isEnabled() {
	return [[[[NSDictionary dictionaryWithContentsOfFile:plistPath] objectForKey:@"capabilities"] objectForKey:@"display-mirroring"] boolValue];
}

void setEnabled(BOOL enable) {
	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
	[[dict objectForKey:@"capabilities"] setValue:[NSNumber numberWithBool:enable] forKey:@"display-mirroring"];
	[dict writeToFile:plistPath atomically:YES];
}

int main(int argc, char **argv) {
	if (!plistPath) {
		NSLog(@"This device is not supported!");
		exit(-1);
	}
	
	if (argv[1] && *argv[1]) {
		if (strcmp("yes", argv[1]) == 0 ||
			strcmp("YES", argv[1]) == 0 ||
			strcmp("true", argv[1]) == 0 ||
			strcmp("TRUE", argv[1]) == 0 ||
			strcmp("1", argv[1]) == 0) {
			setEnabled(YES);
		} else if (strcmp("no", argv[1]) == 0 ||
					strcmp("NO", argv[1]) == 0 ||
					strcmp("false", argv[1]) == 0 ||
					strcmp("FALSE", argv[1]) == 0 ||
					strcmp("0", argv[1]) == 0) {
			setEnabled(NO);
		}
	}
	
	NSLog(@"Display Mirroring %@", (isEnabled() ? @"Enabled" : @"Disabled"));
}

__attribute__((constructor)) static void toggle_initializer() {
	pool = [[NSAutoreleasePool alloc] init];
	
	NSArray *plists = [NSArray arrayWithObjects: @"K48AP",		// iPad
												 @"N90AP",		// iPhone 4
												 @"N92AP",		// iPhone 4 (Verizon)
												 @"N81AP",		// iPod Touch 4G
												 nil];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	for (NSString *plist in plists) {
		NSString *path = [NSString stringWithFormat:@"/System/Library/CoreServices/SpringBoard.app/%@.plist", plist];
		if ([fileManager fileExistsAtPath:path isDirectory:NO]) {
			plistPath = [path copy];
			break;
		}
	}
}

__attribute__((destructor)) static void toggle_finalizer() {
	[pool release];
}
