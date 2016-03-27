//
//  CooPClient.swift
//  CooP
//  Receives the broadcasts screen captures.
//  Created by Iain Munro on 26/03/16.
//  Copyright © 2016 Iain Munro. All rights reserved.
//

import Foundation
import AppKit
import CocoaAsyncSocket

public class CooPClient {
    
    var socket:UDPServer?
    var callback:(NSImage) -> Void
    private var running:Bool = false
    
    public init(callback: (NSImage) -> Void) {
        self.callback = callback;
    }
    
    public func listen() {
        self.stop()
        socket = UDPServer(addr: "localhost", port: 8080)
        print("Client started listening")
        self.receive()
    }
    
    public func stop() {
        if(socket != nil) {
            print("Client stopped listening")
            socket!.close();
            socket = nil
        }
    }
    
    private func receive() {
        if(self.running) {
            stop();
        }
        
        self.running = true;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), { () -> Void in
            while self.socket != nil {
                print("Receiving...")
                let (data, remoteip, remoteport,length) = self.socket!.recv(4048)
                print("receive\(remoteip):\(remoteport) size=\(length)")
                if (data != nil) {
                    
                    print(data)
                    
//                    let _data: NSData = NSData(bytes: data!, length: data!.count)
//                    let image:NSImage = NSImage(data: _data)!
//                    self.callback(image)
                }
                print(remoteip)
            }
            print("Done.")
            self.stop()
            self.running = false;
        })
    }
}