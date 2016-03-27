//
//  CooPServer.swift
//  CooP
//  Broadcasts the screen captures.
//  Created by Iain Munro on 26/03/16.
//  Copyright © 2016 Iain Munro. All rights reserved.
//

import Foundation
import AppKit
import CocoaAsyncSocket

public class CooPServer {
    
    private var socket: UDPClient?
    
    var screenRecorder: ScreenRecorder!
    private var running:Bool = false
    
    public init() {
        screenRecorder = ScreenRecorder(callback: self.send);
    }
    
    public func start() {
        self.stop()
        socket = UDPClient(addr: "localhost", port: 8080)
        print("Server started sending")
        screenRecorder.start()
    }
    
    public func stop() {
        if(socket != nil) {
            print("Server stopped sending")
            socket!.close();
            socket = nil
        }
        screenRecorder.stop()
    }
    
    //Callback from ScreenRecorder if we have a frame worth sending.
    private func send(image: NSData) {
        print(socket?.send(data: image))
    }
    
}