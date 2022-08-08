import Foundation
import UIKit

@objc(CameraManager)
class CameraManager: RCTViewManager {
  override func view() -> UIView! {
    return CameraView()
  }
  
  override static func requiresMainQueueSetup() -> Bool {
    return true
  }
  
  @objc
  func capture(_ node: NSNumber) {
    let component = getCameraView(tag: node)
    component.capture()
  }
  
  func getCameraView(tag: NSNumber) -> CameraView {
    return bridge.uiManager.view(forReactTag: tag) as! CameraView
  }
}
