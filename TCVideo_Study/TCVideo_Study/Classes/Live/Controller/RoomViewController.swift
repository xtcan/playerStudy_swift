//
//  RoomViewController.swift
//  TCVideo_Study
//
//  Created by tcan on 17/5/27.
//  Copyright © 2017年 tcan. All rights reserved.
//

import UIKit
import IJKMediaFramework


private let kChatToolsViewHeight : CGFloat = 44

class RoomViewController: UIViewController, Emitterable {
    
    //MARK: 对外属性
    //房间信息
    var roomMsgModel : HomePageContentModel?
    
    // MARK: 控件属性
    @IBOutlet weak var bgImageView: UIImageView!
    fileprivate lazy var giftListView : UIView = UIView()
    fileprivate lazy var chatToolsView : ChatToolsView = ChatToolsView.loadFromNib()
    
    // MARK: 其他属性
    fileprivate lazy var roomViewModel : RoomViewModel = RoomViewModel()
    fileprivate var player : IJKFFMoviePlayerController?
    
    // MARK: 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        //请求播放信息
        requestPlayInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        player?.shutdown()
    }
}

// MARK:- 请求播放信息
extension RoomViewController {
    fileprivate func requestPlayInfo() {
        if let roomid = roomMsgModel?.roomid, let uid = roomMsgModel?.uid {
            print(roomid, uid)
            roomViewModel.loadLiveURL(roomid, uid, {
                self.setupPlayerView()
            })
        }
    }

    //设置播放器
    func setupPlayerView() {
        
        //开启硬解码
        let options = IJKFFOptions.byDefault()
        options?.setOptionIntValue(1, forKey: "videotoolbox", of: kIJKFFOptionCategoryPlayer)
        
        // 0.关闭log
        IJKFFMoviePlayerController.setLogReport(false)
        
        // 1.初始化播放器
        let url = URL(string: roomViewModel.liveURL)
        player = IJKFFMoviePlayerController(contentURL: url, with: options)
        
        // 2.设置播放器View的位置和尺寸
        if roomMsgModel?.push == 1 {
            let screenW = UIScreen.main.bounds.width
            player?.view.frame = CGRect(x: 0, y: 150, width: screenW, height: screenW * 3 / 4)
        } else {
            player?.view.frame = view.bounds
        }
        
        // 3.将view添加到控制器的view中
        bgImageView.insertSubview(player!.view, at: 1)
        
        // 4.准备播放
//        DispatchQueue.global().async {
//            self.player?.prepareToPlay()
//            self.player?.play()
//        }
        player?.prepareToPlay()
    }
    
}

// MARK:- 设置UI界面内容
extension RoomViewController {
    fileprivate func setupUI() {
        setupBlurView()
        setupBottomView()
    }
    
    fileprivate func setupBlurView() {
        
        let blur = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        blurView.frame = bgImageView.bounds
        bgImageView.addSubview(blurView)
    }
    
    fileprivate func setupBottomView() {
        // 1.设置chatToolsView
        chatToolsView.frame = CGRect(x: 0, y: view.bounds.height, width: view.bounds.width, height: kChatToolsViewHeight)
        chatToolsView.autoresizingMask = [.flexibleTopMargin, .flexibleWidth]
        chatToolsView.delegate = self
        view.addSubview(chatToolsView)
        
        // 2.设置giftListView
//        giftListView.frame = CGRect(x: 0, y: view.bounds.height, width: view.bounds.width, height: kGiftlistViewHeight)
//        giftListView.autoresizingMask = [.flexibleTopMargin, .flexibleWidth]
//        view.addSubview(giftListView)
//        giftListView.delegate = self
    }
}


// MARK:- 事件监听
extension RoomViewController {
    @IBAction func exitBtnClick() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        chatToolsView.inputTextField.resignFirstResponder()
        
//        UIView.animate(withDuration: 0.25, animations: {
//            self.giftListView.frame.origin.y = kScreenH
//        })
    }
    
    @IBAction func bottomMenuClick(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            print("点击了聊天")
            chatToolsView.inputTextField.becomeFirstResponder()
        case 1:
            print("点击了分享")
        case 2:
            print("点击了礼物")
            sender.isSelected = !sender.isSelected
            
        case 3:
            print("点击了更多")
        case 4:
            sender.isSelected = !sender.isSelected
            let point = CGPoint(x: sender.center.x, y: view.bounds.height - sender.bounds.height * 0.5)
            sender.isSelected ? startEmittering(point) : stopEmittering()
        default:
            fatalError("未处理按钮")
        }
    }
}

extension RoomViewController {
    func presentClick(_ sender : UIButton) {
        if  sender.isSelected{
            
        }else{
            
        }
    }
}


extension RoomViewController {
    
    @objc fileprivate func keyboardWillChangeFrame(_ noti : Notification) {
        let duration = noti.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        let endFrame = (noti.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let inputViewY = endFrame.origin.y - kChatToolsViewHeight
        
        UIView.animate(withDuration: duration, animations: {
            UIView.setAnimationCurve(UIViewAnimationCurve(rawValue: 7)!)
            let endY = inputViewY == (kScreenH - kChatToolsViewHeight) ? kScreenH : inputViewY
            self.chatToolsView.frame.origin.y = endY
        })
    }
}


//Mark: - 输入框代理方法（获得输入内容）
extension RoomViewController : ChatToolsViewDelegate{
    
    func chatToolsView(toolView: ChatToolsView, message: String) {
        print(message)
    }
}







