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
    
    // keep track of if the client is connected or not
    var connected: Bool = false
    var connecting: Bool = true
    
    // input and output streams for the socket
    var inputStream: InputStream?
    var outputStream: OutputStream?
    
    override func insertText(_ text: String) {
        adjustCursor()

        // insert text into this buffer
        super.insertText(text)
        
        // append incoming text to the current command
        command += text
        
        // if it's a newline, send it
        if (text == "\n") {
            
            // if disconnected, try to reconnect here (when enter is hit)
            if (!connected) {
                let controller: ViewController = UIApplication.shared.keyWindow?.rootViewController as! ViewController
                
                if (!connecting) {
                    // reprompt connection
                    connecting = true
                    controller.viewDidAppear(true)
                }
                
                return
            }
            
            // must be cast to a byte array to send
            let bytes: [UInt8] = Array(command.utf8)
            outputStream!.write(bytes, maxLength: bytes.count)
            
            // clear command for next time
            command = ""
        }
        
    }
    
    func recvText() {
        // start a new thread to listen for incoming text
        DispatchQueue.global(qos: .userInitiated).async {

            // loop forever, so after receving some text, more can be received
            while (true) {
                
                // create receving buffer (caps at 10KB at a time)
                var buffer = [UInt8](repeating: 0, count: 10000)
                
                // read from socket
                let bytesRead:Int = self.inputStream!.read(&buffer, maxLength: 10000)
                
                // if it's disconnected, exit this loop
                if (!self.connected || bytesRead <= 0) {
                    return
                }
                
                // convert to String and output it with no delimiter (comes with \n)
                self.log(NSString(bytes: buffer,  length: bytesRead, encoding: String.Encoding.utf8.rawValue) as! String, terminator: "")
                
            }
        }

    }
    
    func log(_ text: String, terminator:String = "\n") {
        print(text)
        
        // run on the main thread
        OperationQueue.main.addOperation {
            self.adjustCursor()
            
            // insert the log message
            super.insertText("\(text)\(terminator)")
        }
    }
    
    func connect(host: String, port: Int) {
        
        command = ""
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

    }
    
    override func deleteBackward() {
        adjustCursor()
        
        // delete back a character (may not always be the right character
        // if input has been received since then, but that's ok)
        super.deleteBackward()
        
        // delete one character from the current command
        // http://stackoverflow.com/a/24122445
        if (command.characters.count > 0) {
            command.remove(at: command.index(before: command.endIndex))
        }
    }
    
    func adjustCursor() {
        // move cursor to the end of the text field
        self.selectedRange = NSMakeRange(self.text.characters.count, 0);
    }
    
    override func paste(_ any: Any?) {
        adjustCursor()

        // do paste
        super.paste(any)
        
        // update current command (newlines won't trigger a send)
        command += UIPasteboard.general.string!
    }
    
    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        print("EV \(eventCode)")

        switch eventCode {
        case Stream.Event.endEncountered:
            log("Server disconnected\nPress [Enter] to reconnect")
            self.connected = false
            break
        case Stream.Event.errorOccurred:
            log("Error: \(aStream.streamError?.localizedDescription)\nPress [Enter] to reconnect")
            self.connected = false
            break
        case Stream.Event.openCompleted:
            log("Connection successful!")
            
            // run on the main thread
            OperationQueue.main.addOperation {
                // set as connected
                self.connected = true
                self.connecting = false
                
                // clear command
                self.command = ""
                
                // start receiving loop
                self.recvText()
                
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
