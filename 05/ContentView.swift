//
//  ContentView.swift
//  05
//
//  Created by Tamura Lab on 2025/05/21.
//

import SwiftUI
import AVFoundation
struct ContentView: View {
    @State var camera: AVCaptureDevice? // カメラオブジェクト
    @State var session: AVCaptureSession? // 撮影管理オブジェクト
    @State var output: AVCapturePhotoOutput?// 出力用オブジェクト
    var capture_delegate = CaptureDelegate()
    var body: some View {
        VStack {
            Button("Take a photo") {
                do {
                    let dev_session = AVCaptureDevice.DiscoverySession(
                        deviceTypes:
                            [AVCaptureDevice.DeviceType.builtInWideAngleCamera],
                        mediaType: AVMediaType.video,
                        position: AVCaptureDevice.Position.back)
                    camera = dev_session.devices[0]
                    // 撮影管理を行うオブジェクトを取得し設定を開始
                    session = AVCaptureSession()
                    session!.beginConfiguration()
                    let cam_input = try AVCaptureDeviceInput(device: camera!)
                    session!.addInput(cam_input)
                    // JPEG 静止画像を出力として管理オブジェクトに登録
                    output = AVCapturePhotoOutput()
                    output!.setPreparedPhotoSettingsArray([
                        AVCapturePhotoSettings(
                            format: [AVVideoCodecKey: AVVideoCodecType.jpeg]
                        )], completionHandler: nil)
                    session!.addOutput(output!)
                    session!.commitConfiguration()
                    session!.startRunning()
                    // 最後にデフォルト設定で撮影
                    let setting = AVCapturePhotoSettings()
                    output!.capturePhoto(
                        with: setting,
                        delegate: capture_delegate)
                    
                } catch { fatalError("Capturing error") }
            }
            
        }
        
    }
    
}
class CaptureDelegate: NSObject, AVCapturePhotoCaptureDelegate {
        func photoOutput(_ output: AVCapturePhotoOutput,
            didFinishProcessingPhoto
            photo: AVCapturePhoto, error: Error?) {
                let data = photo.fileDataRepresentation() // 撮影データを画像化
            let image = UIImage(data: data!) // アルバムに保存
            UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
            }
}
#Preview {
    ContentView()
}
