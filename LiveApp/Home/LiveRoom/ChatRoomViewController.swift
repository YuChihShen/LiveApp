//
//  ChatRoomViewController.swift
//  LiveApp
//
//  Created by Class on 2022/4/13.
//

import UIKit
import FirebaseAuth
import RxCocoa
import RxSwift


class ChatRoomViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UITextViewDelegate,UIScrollViewDelegate {
    
    @IBOutlet weak var LeaveButton: UIButton!
    @IBOutlet weak var Leave: UIImageView!
    @IBOutlet weak var LeaveBackground: UILabel!
    @IBOutlet weak var SendBackground: UILabel!
    @IBOutlet weak var SendButton: UIButton!
    @IBOutlet weak var Send: UIImageView!
    @IBOutlet weak var inputText: UITextView!
    @IBOutlet weak var OutputText: UITableView!
    @IBOutlet weak var inputTextConstraintY: NSLayoutConstraint!
    
    var keyboardHeight: CGFloat = 0
    let offset = UIScreen.main.bounds.height * 0.065
    var nickName = NSLocalizedString("VISITOR", comment: "")
    var isAVplayerShouldTurnOff = false
    var messageStore:[message] = []
    var webSocketTask:URLSessionWebSocketTask? = nil
    let inputTextHolder = NSLocalizedString("LET'S PARTY DAY", comment: "")
    override func viewDidLoad() {
        super.viewDidLoad()
        if Auth.auth().currentUser != nil {
            self.nickName = Auth.auth().currentUser?.displayName ?? ""
        }
        
        
        self.modalPresentationStyle = .overCurrentContext
        self.inputText.delegate = self
        // 設定UI元件
        LeaveButton.setTitle("", for: .normal)
        self.setImageBG(background:SendBackground)
        self.setImageBG(background:LeaveBackground)
        self.SendButton.setTitle("", for: .normal)
        self.setInputText(inputText: inputText)
        self.OutputText.delegate = self
        self.OutputText.dataSource = self
        self.OutputText.backgroundView?.alpha = 0
        self.OutputText.backgroundColor = UIColor.clear

        self.OutputText.separatorStyle = .none
       
        // 註冊監聽鍵盤 frame 改變的事件
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        // 註冊監聽鍵盤出現的事件
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        // 註冊監聽鍵盤消失的事件
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // 設定websocket連線（URLSessionWebSocketTask ）
        let websocketURL = self.urlTrans(nickname: nickName)
        let request = URLRequest(url: websocketURL)
        webSocketTask = URLSession.shared.webSocketTask(with: request)
        webSocketTask?.resume()
        self.receive(webSocketTask: webSocketTask!)
        
    }
    
    // 點擊任意處取消編輯
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // 元件設定function
    func setImageBG(background:UILabel){
        background.layer.cornerRadius = background.frame.height / 2
        background.clipsToBounds = true
    }
    func setInputText(inputText:UITextView){
        inputText.backgroundColor = .secondaryLabel
        inputText.layer.cornerRadius = inputText.frame.height / 2
        inputText.textColor = .white
        inputText.isScrollEnabled = false
    }
    // Tableview 設定
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageStore.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 設置cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatOuputTableViewCell
        // 設置對話框
        cell.stackView.clipsToBounds = true
        cell.stackView.layer.cornerRadius = 5
        // 設置對話顯示順序
        self.OutputText.transform = CGAffineTransform(scaleX: 1, y: -1)
        cell.transform = CGAffineTransform(scaleX: 1, y: -1)
        
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        if messageStore.count != 0{
            cell.UserNameText.text = messageStore[indexPath.row].userText
            cell.ContentText.text = messageStore[indexPath.row].contentText
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableViewFadeOut(){
        let topCell = self.OutputText.visibleCells
        for cell in topCell{
            if cell.center.y >= self.OutputText.bounds.maxY * 0.9{
                cell.alpha = 0.3
            }else if cell.center.y >= self.OutputText.bounds.maxY * 0.85{
                cell.alpha = 0.6
            }
            else{
                cell.alpha = 1
            }
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.tableViewFadeOut()
    }
    
    // 離開房間
    func leaveRoom() {
        self.isAVplayerShouldTurnOff = true
        self.messageStore = []
        webSocketTask?.cancel(with: .goingAway, reason: nil)
        dismiss(animated: false)
    }
    
    // 發送訊息
    @IBAction func sentMessage(_ sender: Any) {
        let emp = self.inputText.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if !(emp.isEmpty){
            let text = "{\"action\":\"N\",\"content\":\"\(self.inputText.text ?? "")\"}"
            webSocketTask?.send(.string("\(text)")) { error in
                if let error = error {
                    print("WebSocket sending error: \(error)")
                }
            }
        }else{
            let alertMessage = message( userText: NSLocalizedString("NOTICE", comment: ""), contentText: NSLocalizedString("inhibit blank strings", comment: "") )
            self.messageStore.insert(alertMessage, at: 0)
            self.OutputText.reloadData()
            self.tableViewFadeOut()
        }
        self.inputText.text = ""
    }
    // websocket URL Trans
    func urlTrans(nickname:String) -> URL{
        var urlComponent = URLComponents()
        // wss://client-dev.lottcube.asia
         urlComponent.scheme = "wss"
         urlComponent.host = "client-dev.lottcube.asia"
         urlComponent.path = "/ws/chat/chat:app_test"
         urlComponent.queryItems = [
         URLQueryItem(name: "nickname", value: nickname)
         ]
        return urlComponent.url!
    }
    
    // websocket URLSession 接收訊息
    private func receive(webSocketTask:URLSessionWebSocketTask) {
        webSocketTask.receive { result in
            switch result {
            case .success(let message):
                switch message {
                case .string(let text):
                    self.messageStore.insert(self.decode(text: text), at: 0)
                case .data(let data):
                    print("websocket Received Data: \(data)")
                @unknown default:
                    fatalError()
                }
            case .failure(let error):
                print(error)
            }
            DispatchQueue.main.async {
                self.OutputText.reloadData()
                self.tableViewFadeOut()
            }
            self.receive(webSocketTask: webSocketTask)
        }
    }
    // JSON 解析訊息
    func decode(text:String) -> message{
        var messsageText:message = message(userText: "", contentText: "")
        let data = """
        \(text)
        """.data(using: .utf8)
        let result = try? JSONDecoder().decode(RoomEvent.self, from: data!)
        switch result?.event ?? ""{
            // 系統廣播
            case "admin_all_broadcast":
            
                let notification = try? JSONDecoder().decode(admin_all_broadcast.self, from: data!)
                messsageText.userText = NSLocalizedString("system broadcast", comment: "")
                messsageText.contentText = notification?.body?.content?.tw ?? ""
            // 聊天訊息
            case "default_message":
                let notification = try? JSONDecoder().decode(default_message.self, from: data!)
            messsageText.userText = "\(notification?.body?.nickname ?? "")"
            messsageText.contentText = notification?.body?.text ?? ""
            // 房間訊息
            case "sys_updateRoomStatus":
                let notification = try? JSONDecoder().decode(sys_updateRoomStatus.self, from: data!)
                let userName = notification?.body?.entry_notice?.username ?? ""
                var userAction = ""
                switch notification?.body?.entry_notice?.action ?? ""{
                    case "enter":
                        userAction = NSLocalizedString("ENTER", comment: "")
                    case "leave":
                        userAction = NSLocalizedString("LEAVE", comment: "")
                    default:
                        break
                }
            messsageText.userText = NSLocalizedString("room information", comment: "")
            messsageText.contentText = "\(userName) \(userAction)\(NSLocalizedString("ROOM", comment: ""))"
            // 關閉房間
            case "sys_room_endStream":
                let notification = try? JSONDecoder().decode(sys_room_endStream.self, from: data!)
            messsageText.userText = ""
            messsageText.contentText = notification?.body?.text ?? ""
            default:
                print("text")
        }
        return messsageText
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
//        print("textViewDidBeginEditing:\(self.keyboardHeight)")
        self.inputTextConstraintY.constant = 0 - self.keyboardHeight + self.offset
        UIView.animate(withDuration: 0.2, delay: 0.01, animations: {
            self.inputText.center =
            CGPoint(x: self.inputText.center.x, y: self.inputText.center.y - self.keyboardHeight + self.offset)
            self.Send.center =
            CGPoint(x: self.Send.center.x, y: self.Send.center.y - self.keyboardHeight + self.offset)
            self.SendButton.center =
            CGPoint(x: self.SendButton.center.x, y: self.SendButton.center.y - self.keyboardHeight + self.offset)
            self.SendBackground.center =
            CGPoint(x: self.SendBackground.center.x, y: self.SendBackground.center.y - self.keyboardHeight + self.offset)
            self.OutputText.center =
            CGPoint(x: self.OutputText.center.x, y: self.OutputText.center.y - self.keyboardHeight + self.offset)
        })
        if self.inputText.text == self.inputTextHolder {
            self.inputText.text = ""
            }
//        print("color:\(self.inputText.textColor)")
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        self.inputText.center =
        CGPoint(x: self.inputText.center.x, y:self.inputText.center.y + self.keyboardHeight - self.offset )
        self.Send.center =
        CGPoint(x: self.Send.center.x, y: self.Send.center.y + self.keyboardHeight - self.offset)
        self.SendButton.center =
        CGPoint(x: self.SendButton.center.x, y: self.SendButton.center.y + self.keyboardHeight - self.offset)
        self.SendBackground.center =
        CGPoint(x: self.SendBackground.center.x, y: self.SendBackground.center.y + self.keyboardHeight - self.offset)
        self.OutputText.center =
        CGPoint(x: self.OutputText.center.x, y: self.OutputText.center.y + self.keyboardHeight - self.offset)
        self.inputTextConstraintY.constant = 0
        if self.inputText.text.count == 0 {
            self.inputText.text = self.inputTextHolder
        }
    }
    
        /// 監聽鍵盤開啟事件(鍵盤切換時總會觸發，不管是不是相同 type 的....例如：預設鍵盤 → 數字鍵盤)
        @objc func keyboardWillShow(_ notification: Notification) {
            if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
//                print("keyboardWillShow:\(self.keyboardHeight)")
                self.keyboardHeight = keyboardFrame.cgRectValue.height
            }
        }
        @objc func keyboardWillChangeFrame(_ notification: Notification) {
       }
        /// 監聽鍵盤關閉事件(鍵盤關掉時才會觸發)
        @objc func keyboardWillHide(_ notification: Notification) {
//            print("keyboardWillHide:\(self.keyboardHeight)")
        }
    
    @IBAction func tap(_ sender: Any) {
        self.view.endEditing(true)
    }
}
