//
//  ConsoleView.swift
//  netcat-client
//
//  Created by vgm on 12/17/16.
//  Copyright © 2016 vgmoose. All rights reserved.
//

import Foundation
import UIKit


class ConsoleView: UITextView, StreamDelegate {

    // the current command that will be sent
    var command: String = ""
    
    // input and output streams for the socket
    var inputStream: InputStream?
    var outputStream: OutputStream?
    
    override func insertText(_ text: String) {
        
        // move cursor to the end of the box
        self.selectedRange = NSMakeRange(self.text.characters.count, 0);

        // insert text into this buffer
        super.insertText(text)
        
        // append incoming text to the current command
        command += text
        
        // if it's a newline, send it
        if (text == "\n") {
            
            // must be cast to a byte array to send
            let bytes: [UInt8] = Array(command.utf8)
            outputStream!.write(bytes, maxLength: bytes.count)
            
            // clear command for next time
            command = ""
        }
        
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
        
        log("Connecting to \(host):\(port)...")
        
        // connect
        Stream.getStreamsToHost(withName: host, port: port, inputStream: &inputStream, outputStream: &outputStream)
        
        // set delegates and schedule output stream on the main run thread
        // (see: http://stackoverflow.com/a/28717153 )
        inputStream!.delegate = self
        inputStream!.schedule(in: .main, forMode: RunLoopMode.defaultRunLoopMode)
        
        // attempt to open streams, when done the delegate's sync's method is invoked
        outputStream!.open()
        inputStream!.open()

//        var buffer = [UInt8](repeating: 0, count: 4096)
//        inputStream!.read(&buffer, maxLength: 100)
//        log(String(describing: buffer))

    }
    
    override func deleteBackward() {
        // delete back a character (may not always be the right character
        // if input has been received since then, but that's ok)
        super.deleteBackward()
        
        // delete one character from the current command
        // http://stackoverflow.com/a/24122445
        command.remove(at: command.index(before: command.endIndex))
    }
    
    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        print("EV \(eventCode)")

        switch eventCode {
        case Stream.Event.errorOccurred:
            log("Error: \(aStream.streamError?.localizedDescription)")
            break
        case Stream.Event.openCompleted:
            log("Connection successful!")
            
            // run on the main thread
            OperationQueue.main.addOperation {
                
                // pop up keyboard
                self.becomeFirstResponder()
            }
            break
        case Stream.Event.hasBytesAvailable:
//            log("input: HasBytesAvailable")
            break
        default:
            break
        }
    }
}
