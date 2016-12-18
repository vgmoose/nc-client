//
//  ConsoleView.swift
//  netcat-client
//
//  Created by vgm on 12/17/16.
//  Copyright © 2016 vgmoose. All rights reserved.
//

import Foundation
import UIKit


class ConsoleView: UITextView {

//    override var hasText: Bool = true
    var command: String = ""
    
    override func insertText(_ text: String) {
        
        // move cursor to the end of the box
        self.selectedRange = NSMakeRange(self.text.characters.count, 0);

        // insert text into this buffer
        super.insertText(text)
        
        // append incoming text to the current command
        command += text
        
        // if it's a newline, send it
        if (text == "\n") {
            print("sending " + command)
            command = ""
        }
        
        print("Typed " + text)
    }
    
    func log(_ text: String) {
        print(text)
        
        // run on the main thread
        OperationQueue.main.addOperation {
            
            // insert the log message
            super.insertText("\(text)\n")
        }
    }
    
    func connect(host: String, port: Int) {
        
        // stream variables
        var inputStream: InputStream? = InputStream()
        var outputStream: OutputStream? = OutputStream()
        
        log("Connecting to \(host):\(port)...")
        
        // connect
        Stream.getStreamsToHost(withName: host, port: port, inputStream: &inputStream, outputStream: &outputStream)
        
        log("Connection successful!")
        inputStream!.open()
        outputStream!.open()
        
        outputStream!.write("Hello world!", maxLength: 100)
        log("Sent hello world")
        
        
        var buffer = [UInt8](repeating: 0, count: 4096)
        inputStream!.read(&buffer, maxLength: 100)
        log(String(describing: buffer))

    }
    
    override func deleteBackward() {
        print("Typed backspace")
    }
    
}
