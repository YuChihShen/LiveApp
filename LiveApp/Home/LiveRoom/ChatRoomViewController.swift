//
//  ChatRoomViewController.swift
//  LiveApp
//
//  Created by Class on 2022/4/13.
//

import UIKit
import Starscream
import RxCocoa
import RxSwift

class ChatRoomViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UITextViewDelegate {
    
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
    var nickName = "訪客"
    var isAVplayerShouldTurnOff = false
    var messageStore:[message] = []
    var webSocketTask:URLSessionWebSocketTask? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatOuputTableViewCell
        
        cell.stackView.clipsToBounds = true
        cell.stackView.layer.cornerRadius = 5
        
//        let testString = "測試測試測試測試測試測試jjjjjjjjjjjjjjjjjjjjjjjjj測試測試測試測試測試測試"
//        let testString2 = "測試測試測試"
//        var testStore = [testString]
//        testStore.insert("0\(testString)", at: 0)
//        testStore.insert("1\(testString2)", at: 0)
//        testStore.insert("2\(testString)", at: 0)
//        testStore.insert("3\(testString2)", at: 0)
//        testStore.insert("4\(testString)", at: 0)
//        testStore.insert("5\(testString2)", at: 0)
//        testStore.insert("6\(testString)", at: 0)
//        cell.ContentText.text = "\(testStore[indexPath.row])"
//        cell.UserNameText.text = "\(testString2)"
        
        self.OutputText.transform = CGAffineTransform(scaleX: 1, y: -1)
        cell.transform = CGAffineTransform(scaleX: 1, y: -1)
        
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        
        if messageStore.count != 0{
            cell.UserNameText.text = messageStore[indexPath.row].userText
            cell.ContentText.text = messageStore[indexPath.row].contentText
        }
//        cell.alpha
        
//        for cellbg in 0... cells{
//            self.OutputText.visibleCells[cellbg].layer.opacity = 1 - Float(cellbg) * 0.1
//        }
//        self.OutputText.visibleCells[0].layer.opacity = 1
//        self.OutputText.visibleCells[self.OutputText.visibleCells.count].layer.opacity = 0.3
//        print("cells\(self.OutputText.visibleCells)")
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
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
        if self.inputText.text.count > 0 {
            let text = "{\"action\":\"N\",\"content\":\"\(self.inputText.text ?? "")\"}"
            webSocketTask?.send(.string("\(text)")) { error in
                if let error = error {
                    print("WebSocket sending error: \(error)")
                }
            }
        }
    }
    // websocket URL Trans
    func urlTrans(nickname:String) -> URL{
        var urlComponent = URLComponents()
         urlComponent.scheme = "wss"
         urlComponent.host = "lott-dev.lottcube.asia"
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
//                let cells = self.OutputText.visibleCells.count
//                self.OutputText.visibleCells[cells].alpha = 0.3
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
                messsageText.userText = "系統廣播"
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
                        userAction = "進入"
                    case "leave":
                        userAction = "離開"
                    default:
                        break
                }
            messsageText.userText = "房間訊息"
            messsageText.contentText = "\(userName) \(userAction)房間"
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
        print("textViewDidBeginEditing:\(self.keyboardHeight)")
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
        print("center:\(self.inputText.center)")
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        print("textViewDidEndEditing:\(self.keyboardHeight)")
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
        print("center:\(self.inputText.center)")
        self.inputTextConstraintY.constant = 0
    }
    
        /// 監聽鍵盤開啟事件(鍵盤切換時總會觸發，不管是不是相同 type 的....例如：預設鍵盤 → 數字鍵盤)
        @objc func keyboardWillShow(_ notification: Notification) {
            if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                print("keyboardWillShow:\(self.keyboardHeight)")
                self.keyboardHeight = keyboardFrame.cgRectValue.height
            }
        }
        @objc func keyboardWillChangeFrame(_ notification: Notification) {
       }
        /// 監聽鍵盤關閉事件(鍵盤關掉時才會觸發)
        @objc func keyboardWillHide(_ notification: Notification) {
            print("keyboardWillHide:\(self.keyboardHeight)")
        }
    
    @IBAction func tap(_ sender: Any) {
        self.view.endEditing(true)
    }
}


//extension ChatRoomViewController: URLSessionWebSocketDelegate {
//    public func urlSession(_ session: URLSession,
//                           webSocketTask: URLSessionWebSocketTask,
//                           didOpenWithProtocol protocol: String?) {
//        print("URLSessionWebSocketTask is connected")
//    }
//    public func urlSession(_ session: URLSession,
//                           webSocketTask: URLSessionWebSocketTask,
//                           didCloseWith closeCode: URLSessionWebSocketTask.CloseCode,
//                           reason: Data?) {
//        let reasonString: String
//        if let reason = reason, let string = String(data: reason, encoding: .utf8) {
//            reasonString = string
//        } else {
//            reasonString = ""
//        }
//        print("URLSessionWebSocketTask is closed: code=\(closeCode), reason=\(reasonString)")
//    }
//}
