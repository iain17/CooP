//
//  ScreenRecorder.swift
//  CooP
//
//  Created by Iain Munro on 26/03/16.
//  Copyright © 2016 Iain Munro. All rights reserved.
//

import Foundation
import AVFoundation
import AppKit

public class ScreenRecorder: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    var session: AVCaptureSession!
    var sessionQueue: dispatch_queue_t!
    var input: AVCaptureScreenInput!
    var output: AVCaptureVideoDataOutput!
    var imageOutput: AVCaptureStillImageOutput!
    var callback: (NSData) -> Void!
    
    
    public init(callback : (NSData) -> Void) {
        self.callback = callback;
        super.init()
        
        session = AVCaptureSession()
        session.sessionPreset = AVCaptureSessionPresetMedium
        
        sessionQueue = dispatch_queue_create("ScreenCapture Session", DISPATCH_QUEUE_SERIAL)
        dispatch_async(sessionQueue, {
            self.session.beginConfiguration()
            self.addVideoInput()
            self.addVideoOutput()
            //self.addStillImageOutput()
            self.session.commitConfiguration()
        })
        
    }
    
    private func addVideoInput() {
        
        let displayId: CGDirectDisplayID = CGDirectDisplayID(CGMainDisplayID())
        input = AVCaptureScreenInput(displayID: displayId)
        input.minFrameDuration = CMTimeMake(1, 24);
        input.capturesCursor = true;
        input.capturesMouseClicks = true;
        input.scaleFactor = 0.5;
        
        if ((self.session?.canAddInput(input)) != nil) {
            self.session?.addInput(input)
        }
        
    }
    
    private func addVideoOutput() {
        output = AVCaptureVideoDataOutput()
        
        //output.videoSettings = NSDictionary(object: Int(kCVPixelFormatType_32BGRA), forKey:kCVPixelBufferPixelFormatTypeKey)
        
        output.alwaysDiscardsLateVideoFrames = true
        
        output.setSampleBufferDelegate(self, queue: sessionQueue)
        
        if session.canAddOutput(output) {
            session.addOutput(output)
        }
    }
    
    private func addStillImageOutput() {
        imageOutput = AVCaptureStillImageOutput()
        imageOutput.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
        
        if session.canAddOutput(imageOutput) {
            session.addOutput(imageOutput)
        }
    }
    
    public func start() {
        self.session.startRunning()
    }
    
    public func stop() {
        self.session.stopRunning()
    }
    
    private func imageFromSampleBuffer(sampleBuffer: CMSampleBuffer) {
        
        let imageBuffer: CVImageBufferRef = CMSampleBufferGetImageBuffer(sampleBuffer)!
        CVPixelBufferLockBaseAddress(imageBuffer, 0)
        //let bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer)
        //let width = CVPixelBufferGetWidth(imageBuffer)
        //let height = CVPixelBufferGetHeight(imageBuffer)
        //let src_buff = CVPixelBufferGetBaseAddress(imageBuffer)
        //let colorSpace = CGColorSpaceCreateDeviceRGB()
        //let data: NSData = NSData(bytes: src_buff, length: bytesPerRow * height)
        let cameraImage = CIImage(CVPixelBuffer: imageBuffer)
        
        let bitmapRep = NSBitmapImageRep(CIImage: cameraImage)
        //
        //
        let compressedData: NSData = bitmapRep.representationUsingType( NSBitmapImageFileType.NSJPEGFileType,
                                                                        properties: [
                                                                            NSImageCompressionFactor: Float(0.50),
                                                                            NSImageProgressive: false
            ])!
        //////
        ////
        ////
        //let compressedImage: NSImage = NSImage(data: compressedData)!
        //        print(compressedImage.size.height)
        //        print(compressedImage.size.width)
        //        print(compressedData.length)
        callback(compressedData);
        
    }
    
    public func captureOutput(captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, fromConnection connection: AVCaptureConnection!) {
        if (connection.supportsVideoOrientation){
            //connection.videoOrientation = AVCaptureVideoOrientation.PortraitUpsideDown
            connection.videoOrientation = AVCaptureVideoOrientation.Portrait
        }
        if (connection.supportsVideoMirroring) {
            //connection.videoMirrored = true
            connection.videoMirrored = false
        }
        self.imageFromSampleBuffer(sampleBuffer)
    }
    
}