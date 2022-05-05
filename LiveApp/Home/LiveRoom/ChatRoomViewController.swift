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


class ChatRoomViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UITextViewDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate ,UIPopoverPresentationControllerDelegate{
    
    @IBOutlet weak var HeartBtn: UIButton!
    @IBOutlet weak var heartFill: UIImageView!
    @IBOutlet weak var heart: UIImageView!
    @IBOutlet weak var LeaveButton: UIButton!
    @IBOutlet weak var Leave: UIImageView!
    @IBOutlet weak var LeaveBackground: UILabel!
    @IBOutlet weak var SendBackground: UILabel!
    @IBOutlet weak var SendButton: UIButton!
    @IBOutlet weak var Send: UIImageView!
    @IBOutlet weak var inputText: UITextView!
    @IBOutlet weak var OutputText: UITableView!
    @IBOutlet weak var inputTextConstraintY: NSLayoutConstraint!
    @IBOutlet weak var hostInfo: UIImageView!
    
    @IBOutlet weak var hostInfoBtn: UIButton!
    @IBOutlet weak var hostInfoNickname: UILabel!
    @IBOutlet weak var hostInfoBG: UILabel!
    @IBOutlet weak var InfoView: UIView!
    @IBOutlet weak var chatView: UIView!
    let firebaseSupport = FireBaseSupport()
    var isLiked = false
    var streamer_id = ""
    var keyboardHeight: CGFloat = 0
    let offset = UIScreen.main.bounds.height * 0.05
    var nickName = NSLocalizedString("VISITOR", comment: "")
    var isAVplayerShouldTurnOff = false
    var messageStore:[message] = []
    var webSocketTask:URLSessionWebSocketTask? = nil
    let inputTextHolder = NSLocalizedString("LET'S PARTY DAY", comment: "")
    var isChatViewExist = true
    let animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut)
    var roomNum = 0
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        if Auth.auth().currentUser != nil {
            self.nickName = Auth.auth().currentUser?.displayName ?? ""
        }
        self.modalPresentationStyle = .overCurrentContext
        self.inputText.delegate = self
        // 設定UI元件
        hostInfo.clipsToBounds = true
        hostInfo.layer.cornerRadius = hostInfo.bounds.width / 2
        LeaveButton.setTitle("", for: .normal)
        HeartBtn.setTitle("", for: .normal)
        self.setImageBG(background:SendBackground)
        self.setImageBG(background:LeaveBackground)
        self.SendButton.setTitle("", for: .normal)
        self.setInputText(inputText: inputText)
        self.OutputText.delegate = self
        self.OutputText.dataSource = self
        self.OutputText.backgroundView?.alpha = 0
        self.OutputText.backgroundColor = UIColor.clear

        self.OutputText.separatorStyle = .none
       
        // 註冊監聽鍵盤出現的事件
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        //設定websocket連線（URLSessionWebSocketTask ）
//        let websocketURL = self.urlTrans(nickname: nickName)
//        let request = URLRequest(url: websocketURL)
//        webSocketTask = URLSession.shared.webSocketTask(with: request)
//        webSocketTask?.resume()
//        self.receive(webSocketTask: webSocketTask!)
        
        //接收 mediaView 資訊
        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        let window = sceneDelegate?.window
        let mediaView = window?.rootViewController!.presentedViewController! as! MediaAVViewController
        streamer_id = String(mediaView.streamer_id )
        heart.isHidden = true
        heartFill.isHidden = true
        self.firebaseSupport.isDataExist(streamer_id:streamer_id,vc: self)
        hostInfoBG.layer.cornerRadius = 20
        hostInfoNickname.text = mediaView.roomHostNickname
        hostInfo.image = mediaView.roomHostPhoto
        hostInfoBtn.setTitle("", for: .normal)
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
        cell.stackView.layer.cornerRadius = 13
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
        let tableViewY = self.OutputText.bounds.maxY
        for cell in topCell{
            if cell.center.y >= tableViewY * 0.96{
                cell.alpha = 0.2
            }else if cell.center.y >= tableViewY * 0.92{
                cell.alpha = 0.5
            }
            else if cell.center.y >= tableViewY * 0.88{
                cell.alpha = 0.8
            }else{
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
    
    // 監聽鍵盤開啟事件(鍵盤切換時總會觸發，不管是不是相同 type 的....例如：預設鍵盤 → 數字鍵盤)
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            self.keyboardHeight = keyboardFrame.cgRectValue.height
        }
    }
    @IBAction func tap(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func removeChatFrame(_ sender: UIPanGestureRecognizer) {
        let width = self.view.frame.width
        let ratio = abs(sender.translation(in: self.view).x) / width
        let transX = sender.translation(in: self.view).x
        switch sender.state {
        case .changed:
            if isChatViewExist == true{
                self.chatView.center.x = self.view.center.x + transX
                if transX > 0{
                    self.chatView.alpha = 1 - pow(ratio, 2)
                    self.InfoView.alpha = 1 - pow(ratio, 2)
                }
            }else if transX < 0{
                self.chatView.center.x = self.view.center.x + transX + width
                self.chatView.alpha =  ratio
                self.InfoView.alpha = ratio
            }
        case .ended:
            let startpoint = self.chatView.center.x
            var endpoint = self.view.center.x
            var alpha = CGFloat(1)
            if ((isChatViewExist == true) && (transX < 0))||((isChatViewExist == false) && (transX > 0))||ratio < 0.6{
                if isChatViewExist == false{
                    endpoint += width
                    alpha = 0
                }
                self.moveChatFrame(startpoint: startpoint, endpoint: endpoint,alpha: alpha)
                animator.startAnimation()
            }else{
                if isChatViewExist == true{
                    endpoint += width
                    alpha = 0
                }
                self.moveChatFrame(startpoint: startpoint, endpoint: endpoint,alpha: alpha)
                animator.addCompletion { _ in
                    self.isChatViewExist.toggle()
                }
                animator.startAnimation()
                
            }
        default:
            ()
        }
    }
    func moveChatFrame(startpoint:CGFloat,endpoint:CGFloat,alpha:CGFloat){
        self.chatView.center.x = startpoint
        animator.addAnimations {
            self.chatView.center.x = endpoint
            self.chatView.alpha = alpha
            self.InfoView.alpha = alpha
        }
        
    }
    override func prepare (for segue: UIStoryboardSegue, sender: Any?) {
        let popoverCtrl = segue.destination.popoverPresentationController
        
        if sender is UIButton {
            popoverCtrl?.sourceRect = (sender as! UIButton).bounds
        }
        popoverCtrl?.delegate = self
    }
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
    // 追蹤功能
    @IBAction func likeEvent(_ sender: Any) {
        // 判斷有無登入
        let isUserExist = self.firebaseSupport.isUserExist()
        if isUserExist{
            // 儲存<->刪除 streamer_id
            switch isLiked{
            case true:
                self.firebaseSupport.deleteData(streamer_id: streamer_id)
            case false:
                self.firebaseSupport.addData(streamer_id: streamer_id)
            }
            // 切換圖案
            heart.isHidden.toggle()
            heartFill.isHidden.toggle()
            isLiked.toggle()
            // 播放動畫
            if isLiked == true{
                self.likeAnimate()
            }

        }else{
            // 登入提示 ＆ 跳轉畫面
            let alertController = UIAlertController(
                    title: NSLocalizedString("NO SIGNIN", comment: ""),
                    message: NSLocalizedString("PRESENT TO SIGNIN PAGE", comment: ""),
                    preferredStyle: .alert)
            let cancelAction = UIAlertAction(
                 title: NSLocalizedString("CANCEL", comment: ""),
                 style: .cancel,
                 handler: nil)
               alertController.addAction(cancelAction)
            let signIn = UIAlertAction(
                 title: NSLocalizedString("SIGNIN", comment: ""),
                 style: .default){_ in 
                     let signInOPage = self.storyboard?.instantiateViewController(withIdentifier: "LogInView") as! LogInViewController
                     signInOPage.isChatRoomPresent = true
                     self.present(signInOPage, animated: true)
                 }
               alertController.addAction(signIn)
            self.present(
                  alertController,
                  animated: true,
                  completion: nil)
            
        }
        
    }
    func likeAnimate(){
        let emitterCell = CAEmitterCell()
        let image = UIImage(named: "heart")
        emitterCell.contents = image?.cgImage
        
        emitterCell.birthRate = 24
        emitterCell.lifetime = 4
        emitterCell.lifetimeRange = 1.0
        
        emitterCell.yAcceleration = -150.0
        emitterCell.xAcceleration = 5.0
        emitterCell.velocity = -70.0
        emitterCell.velocityRange = 20.0
        
        emitterCell.scale = 0.05
        emitterCell.scaleRange = 0.02
        emitterCell.scaleSpeed = -0.01
        emitterCell.alphaRange = 0.3
        emitterCell.alphaSpeed = -0.2
        emitterCell.emissionRange = CGFloat.pi
        
        // init emitter
        let emitter = CAEmitterLayer()
        emitter.emitterCells = [emitterCell]
        // appear way
        emitter.emitterShape = .sphere
        emitter.emitterPosition = CGPoint(x: view.bounds.width/2, y: view.bounds.height * 1.5)
        emitter.emitterSize = CGSize(width:  view.bounds.width, height: view.bounds.height )
        
        view.layer.addSublayer(emitter)
        DispatchQueue.main.asyncAfter(deadline: .now()+0.8){
            emitter.removeFromSuperlayer()
        }
    }
    
    
}
