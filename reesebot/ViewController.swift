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

class ViewController: JSQMessagesViewController {
    
    var messages = [JSQMessage]()
    var text = String()
    var result = String()
    var newText = String()
    var messageValue = String()
    
    
    
    
    private let greenView = UIView()

    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
    func addViewOnTop() {
        let selectableView = UIView(frame: CGRect(x: 0, y: 60, width: self.view.bounds.width, height: 40))
        
        let randomViewLabel = UILabel(frame: CGRect(x: 20, y: -27, width: 100, height: 16))
        randomViewLabel.text = "Reesebot"
        selectableView.addSubview(randomViewLabel)
        view.addSubview(selectableView)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        
        addViewOnTop()
        discover()
        
        // messages code
        
        senderId = "1234"
        senderDisplayName = "James Hunt"
        
        inputToolbar.contentView.leftBarButtonItem = nil
        collectionView.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        
        addMessage(withId: "1234", name: "James Hunt", text: "What's your name?")
        
        messageValue = "What's your name?"
        self.assistantExample(message: "What's your name?") { () -> () in
           // self.addMessage(withId: "3434", name: "Watson", text: self.newText)
        }
        
    }
    func discover(){
        let username = "71dc0668-7297-4500-bd89-9e6da3c60643"
        let password = "pjW0skCcw2Yp"
        let version = "2018-06-05" // use today's date for the most recent version
        let discovery = Discovery(username: username, password: password, version: version)
        
        let failure = { (error: Error) in print("failure") }
        
        
    
       
        discovery.query(
            environmentID: "24e532bb-8c78-4f06-ad3f-1e19188d1114",
            collectionID: "5086ef4c-255a-40a1-bf4a-f35b49791bbb",
           // query: "enriched_text.concepts.text:\"Cloud computing\"",
            query: "fat man",
            failure: failure)
        {
            
            
            
            queryResponse in
            
            print("qr",queryResponse)
            
            
            
            
            
            
            
//            var text = queryResponse.results![0].
//            var text = queryResponse.ag
//            print("text",text)
//            //print("discover_text:",queryResponse)
//
//               // print("hunt_data: ",queryResponse)
//
//               // var queryR = String(queryResponse.results)
//
//
//
//            var stringToSplit = String(text.metadata)
//
//           // let fullName    = "First Last"
//
//            let stringToSplitArr = stringToSplit.components(separatedBy: "url\": DiscoveryV1.JSON.string(\"")
//
//            let beforeUrl    = stringToSplitArr[0]
//            let afterUrl = stringToSplitArr[1]
//            print("afterUrl ",afterUrl)

            
            
        }
    }
    
    
    // watson
    func assistantExample(message:String, handleComplete:@escaping (()->()))  {
        
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
                
                
                
                self.newText = String((response.output.text.joined()))
                
                if let message = JSQMessage(senderId: "3434", displayName: "Watson", text: self.newText) {
                    self.messages.append(message)
                    
                }
                self.finishReceivingMessage()
                self.collectionView.reloadData()
                
                handleComplete()

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
    
    lazy var outgoingBubble: JSQMessagesBubbleImage = {
        return JSQMessagesBubbleImageFactory()!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
    }()
    
    lazy var incomingBubble: JSQMessagesBubbleImage = {
        return JSQMessagesBubbleImageFactory()!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
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
        addMessage(withId: "1234", name: "James Hunt", text: messageValue)
        assistantExample(message: messageValue) {
            //self.addMessage(withId: "3434", name: "Watson", text: self.newText)
            print("done")
        }
        
    }
    
}

