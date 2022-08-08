#import <Foundation/Foundation.h>
#import <React/RCTViewManager.h>
#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(CameraManager, RCTViewManager)
RCT_EXPORT_VIEW_PROPERTY(flash, BOOL)

RCT_EXTERN_METHOD(capture:(nonnull NSNumber *)node)
@end
