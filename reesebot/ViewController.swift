//
//  ViewController.swift
//  reesebot
//
//  Created by James Hunt on 6/4/18.
//  Copyright © 2018 James Hunt. All rights reserved.
//

import UIKit
import AssistantV1
import DiscoveryV1
import AVFoundation

class ViewController: JSQMessagesViewController {
    
    var messages = [JSQMessage]()
    var text = String()
    var result = String()
    var newText = String()
    var messageValue = String()
    var assistantHelped = Bool()
    var userText = String()
    var player: AVAudioPlayer?

    
    
    override func viewDidLoad() {
        
        
        
        super.viewDidLoad()
        
        
        
        
        
        
        
        
        
        assistantHelped = false
//        let screenSize: CGRect = UIScreen.main.bounds
//        let myView = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width , height: 60))
//        myView.backgroundColor = UIColor.black
//        self.view.addSubview(myView)
        
    
        senderId = "1234"
        senderDisplayName = "James Hunt"
        
        
        inputToolbar.contentView.leftBarButtonItem = nil
        collectionView.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        
        self.addMessage(withId: "3434", name: "Watson", text: "I'm Port City Pulse. What can I help you with?")
        
        
        //messageValue = "What's your name?"
        
        let button = UIButton(frame: CGRect(x: 335, y: 40, width: 20, height: 20))
        button.setTitle("Share", for: .normal)
        if let image  = UIImage(named: "share.png") {
            button.setImage(image, for: UIControlState.normal)
        }
//        if let image  = UIImage(named: "pulse_logo.png") {
//            let imageView = UIImageView(image: image)
//            imageView.frame = CGRect(x: 168, y: 34, width: 30, height: 29)
//            view.addSubview(imageView)
//        }
        button.backgroundColor = .white
        
        button.setTitleColor(UIColor.black, for: .normal)
        button.addTarget(self, action: #selector(self.buttonTapped), for: .touchUpInside)
        self.view.addSubview(button)
        self.view.bringSubview(toFront: button)
        
        
    }
    func playSound() {
        guard let url = Bundle.main.url(forResource: "chat", withExtension: "wav") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            
            
            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            /* iOS 10 and earlier require the following line:
             player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */
            
            guard let player = player else { return }
            
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    @objc func buttonTapped(sender : UIButton) {
        print("share")
        let firstActivityItem = "Checkout Port City Pulse"
        let secondActivityItem : NSURL = NSURL(string: "www.unc.edu")!
        // If you want to put an image
        let image : UIImage = UIImage(named: "unc.png")!
        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: [firstActivityItem, secondActivityItem, image], applicationActivities: nil)
        
        // This lines is for the popover you need to show in iPad
        activityViewController.popoverPresentationController?.sourceView = (sender as! UIButton)
        
        // This line remove the arrow of the popover to show in iPad
        
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
        
        // Anything you want to exclude
        activityViewController.excludedActivityTypes = [
            UIActivityType.postToWeibo,
            UIActivityType.print,
            UIActivityType.assignToContact,
            UIActivityType.saveToCameraRoll,
            UIActivityType.addToReadingList,
            UIActivityType.postToFlickr,
            UIActivityType.postToVimeo,
            UIActivityType.postToTencentWeibo
        ]
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    

    var newURL = String()
    func discover(){
       
        let username = "71dc0668-7297-4500-bd89-9e6da3c60643"
        let password = "pjW0skCcw2Yp"
        let version = "2018-06-05" // use today's date for the most recent version
        let discovery = Discovery(username: username, password: password, version: version)
        
        let failure = { (error: Error) in print("failure") }
        
        
        discovery.query(
            environmentID: "24e532bb-8c78-4f06-ad3f-1e19188d1114",//"24e532bb-8c78-4f06-ad3f-1e19188d1114",//
            collectionID: "5086ef4c-255a-40a1-bf4a-f35b49791bbb",//"aecc486d-0c37-42bb-a959-770a517cee4c",//
            filter: userText,
            query: userText,
            failure: failure)
        {
            queryResponse in
            
            print("query response", queryResponse)
            //var myurl = queryResponse.results?.description[additionalProperties]
            var queryResult = [QueryResult]()
            queryResult = queryResponse.results!
            for eachQueryResult in queryResult {
                print(eachQueryResult)
                let dicitonary: [String : DiscoveryV1.JSON] = eachQueryResult.additionalProperties
                print("new data url ",dicitonary["url"],"end")
                
                
                
            }

            
            print("result is:", queryResponse.results!)
            let qrd = queryResponse.results?.description
            var qrdS =  qrd!
            qrdS.append("no data")
           
            
            
            let arr = qrdS.components(separatedBy: "\"url\": DiscoveryV1.JSON.string(\"")
            let arr3 = qrdS.components(separatedBy: "\"relevance\": DiscoveryV1.JSON.double(")
            
            
                let beforeUrl:String? = arr[0]
                print("arr)",arr[0])
                var incUrlAfter:String?
                if beforeUrl != "[]no data" {
                    incUrlAfter = arr[1]
                }
                let beforeUrl3:String? = arr3[0]
                print("arr)",arr3[0])
                var incUrlAfter3:String?
                if beforeUrl3 != "[]no data" {
                    incUrlAfter3 = arr3[1]
                }
       
            
                    if let incUrlAfter1 = incUrlAfter {
                        print("incUrlAfter1",incUrlAfter1)
                        
                        let incUrlManip = incUrlAfter1.components(separatedBy: "\")")
                        let manipUrl    = incUrlManip[0]
                        let newString = manipUrl
                        if !self.assistantHelped {
                            self.playSound()
                        }
                
                        DispatchQueue.main.async {
                            if !self.assistantHelped{
                                
                                self.addMessage(withId: "3434", name: "Watson", text: "I found this article to help: \(newString)")
                                self.finishReceivingMessage()
                                self.collectionView.reloadData()
                            }
                           
                            
                            
                        }
                        print("manip",manipUrl)
                        
                    }
            if let incUrlAfter3 = incUrlAfter3 {
                print("incUrlAfter3",incUrlAfter3)
                
                let incUrlManip3 = incUrlAfter3.components(separatedBy: "), \"type\"")
                let manipUrl3    = incUrlManip3[0]
                let newString3 = manipUrl3
                
                DispatchQueue.main.async {
                    //self.addMessage(withId: "3434", name: "Watson", text: "My confidence is: \(newString3)")
                    
                    print("my confidence is \(newString3)")
                    self.finishReceivingMessage()
                    self.collectionView.reloadData()
                    
                }
                print("manip",manipUrl3)
                
            }
        }
    }
    func getImageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    // watson
    func assistantExample(message:String)  {
        
        // Assistant credentials
        let username = "124663f7-0eb9-467f-9d1d-e1213e949253"
        let password = "b5apsFpys2tV"
        let workspace = "f9c0012b-372e-47fb-8070-306f73f36b42"
        
        // instantiate service
        let assistant = Assistant(username: username, password: password, version: "2018-03-01")
        
        // start a conversation
        assistant.message(workspaceID: workspace) { response in
            print("Conversation ID: \(response.context.conversationID!)")
            print("Response: \(response.output.text.joined())")
            print("Detailed: \(response.output.text)")
            
            // continue assistant
            
           // let input = InputData(text: "What's happening this weekend")
            let input = InputData(text: message)
            let request = MessageRequest(input: input, context: response.context)
            
                assistant.message(workspaceID: workspace, request: request) { response in
                    
                    print("Response: \(response.output.text.joined())")
                    
                    if response.output.text.joined() != "Come again?" && response.output.text.joined() != "I am not sure." && response.output.text.joined() != "Sorry, I don't know about that one!" {
                   
                    self.assistantHelped = true
                    
                    let assistantText = String((response.output.text.joined()))
                    DispatchQueue.main.async {
                        
                         self.playSound()
                            
                        
                      
                        
                        self.addMessage(withId: "3434", name: "Watson", text: "\(assistantText)")
                                
                                print("assistant helped")
                     
                        self.finishReceivingMessage()
                        self.collectionView.reloadData()
                        
                    }
                    
                    
                    
                }

                
            }
            
        }
        
    }

    func addMessage(withId id: String, name: String, text: String) {
        if let message = JSQMessage(senderId: id, displayName: name, text: text) {
            messages.append(message)
            
        }
        self.finishReceivingMessage()
        collectionView.reloadData()
    }
    override func textViewDidChange(_ textView: UITextView) {
        super.textViewDidChange(textView)
        // If the text is not empty, the user is typing
        print(textView.text)
        messageValue = textView.text!
        
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        let message = messages[indexPath.item]
        
        if message.senderId == senderId {
            cell.textView?.textColor = UIColor.white
        } else {
            cell.textView?.textColor = UIColor.black
        }
        return cell
    }
    // messages code
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData!
    {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return messages.count
    }
    let color1 = UIColor(rgb: 0x49bfff)
    let color2 = UIColor(rgb: 0x0b205d)
    
    lazy var outgoingBubble: JSQMessagesBubbleImage = {
        return JSQMessagesBubbleImageFactory()!.outgoingMessagesBubbleImage(with: color2)
    }()
    
    lazy var incomingBubble: JSQMessagesBubbleImage = {
        return JSQMessagesBubbleImageFactory()!.incomingMessagesBubbleImage(with: color1)
    }()
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource!
    {
        return messages[indexPath.item].senderId == senderId ? outgoingBubble : incomingBubble
    }
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource!
    {
        return nil
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString!
    {
        return messages[indexPath.item].senderId == senderId ? nil : NSAttributedString(string: messages[indexPath.item].senderDisplayName)
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat
    {
        return messages[indexPath.item].senderId == senderId ? 0 : 15
    }
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!)
    {
        
        assistantHelped = false
        addMessage(withId: "1234", name: "James Hunt", text: messageValue)
        assistantExample(message: messageValue)
        self.userText = self.messageValue
        finishSendingMessage()
        self.discover()
        
        
        
        
        
    }
    
}
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

