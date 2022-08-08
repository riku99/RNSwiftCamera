import Foundation
import UIKit
import AVFoundation

class CameraView: UIView {
  // デバイスからの入力と出力を管理
  var captureSession = AVCaptureSession()
  
  // デバイス管理
  var currentDevice: AVCaptureDevice?
  var mainCamera: AVCaptureDevice?
  
  // Sessionの出力を指定するためのオブジェクト
  var photoOutput: AVCapturePhotoOutput?
  
  // カメラのプレビュー管理
  var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
  
  @objc var flash = false
  
  override public init(frame: CGRect) {
    super.init(frame: frame)
    setupCaptureSession()
    setupDevice()
    setupInputOutput()
    setupPreviewLayer()
    captureSession.startRunning()
  }
  
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) is not implemented.")
  }
  
  func capture() {
    let settings = AVCapturePhotoSettings()
    settings.flashMode = flash ? .on : .off
    self.photoOutput?.capturePhoto(with: settings, delegate: self as AVCapturePhotoCaptureDelegate)
  }
  
  // カメラのプレビューを表示するレイヤの設定
  func setupPreviewLayer() {
    // frameをネイティブ側で指定しないとプレビュー画面表示されない(?)
    self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
    
    cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
    cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
    cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
    cameraPreviewLayer?.frame = layer.bounds
    
    self.layer.insertSublayer(cameraPreviewLayer!, at: 0)
  }
  
  // 入出力データの設定
  func setupInputOutput() {
    do {
      // CaptureDeviceからCaptureSessionに向けてデータを提供するInputを初期化
      let caputureDeviceInput = try AVCaptureDeviceInput(device: currentDevice!)
      
      // 入力をセッションに追加
      captureSession.addInput(caputureDeviceInput)
      
      // 出力データを受け取るオブジェクト
      photoOutput = AVCapturePhotoOutput()
      
      let outPutPhotoSettings = [AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])]
      
      // 出力の設定。ここではフォーマットを指定。
      photoOutput!.setPreparedPhotoSettingsArray(outPutPhotoSettings, completionHandler: nil)
      
      captureSession.addOutput(photoOutput!)
    } catch {
      print(error)
    }
  }
  
  // デバイスの設定
  func setupDevice() {
    // カメラデバイスのプロパティ設定。どの種類のデバイスをどのメディアのために使うかなど設定。
    let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
    
    //　discoverySessionで指定した基準に満たしたデバイスを取得
    let devices = deviceDiscoverySession.devices
    
    for device in devices {
      if device.position == AVCaptureDevice.Position.back {
        mainCamera = device
      }
    }
    
    currentDevice = mainCamera
  }
  
  func setupCaptureSession() {
    // 解像度設定
    captureSession.sessionPreset = AVCaptureSession.Preset.photo
  }
}

extension CameraView: AVCapturePhotoCaptureDelegate {
  func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
    if let imageData = photo.fileDataRepresentation() {
      let uiImage = UIImage(data: imageData)
      // ライブラリに画像を保存
      UIImageWriteToSavedPhotosAlbum(uiImage!, nil, nil, nil)
    }
  }
}
