//
//  WatchService.swift
//  lindale-watch Extension
//
//  Created by Jie Wu on 2018/09/13.
//  Copyright © 2018年 lindelin. All rights reserved.
//

import WatchKit
import WatchConnectivity

class WatchSession: NSObject, WCSessionDelegate {
    // 静态单例
    static let main = WatchSession()
    
    // 初始化
    private override init()
    {
        super.init()
    }
    
    // 连接机制
    private let session:WCSession? = WCSession.isSupported() ? WCSession.default : nil
    
    // 激活机制
    func startSession(){
        session?.delegate=self
        session?.activate()
    }
    
    // 检测到iPhone的父应用
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }
    
//    // 通信完成会话对象开始闲置
//    func sessionDidBecomeInactive(_ session: WCSession) {
//    }
//
//    // 通信完成会话对象释放
//    func sessionDidDeactivate(_ session: WCSession) {
//    }
    
    // 接收到iPhone端发送过来的信息
    // message: iPhone端发送过来的信息
    // replyHandler: watch端回复给iPhone的内容
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        // 这里也可以通过通知中心发送通知给InterfaceController，进行页面操作，至于用什么方法大家随意。注意事项iPhone的代码里提到了，一样的性质，这里就不写了。
    }
    
    // 向iPhone侧发送信息
    func sendMessage(key:String, value:Any, handler: @escaping ([String : Any]) -> Void){
        session?.sendMessage([key : value], replyHandler: { (reply: [String : Any]) in
            handler(reply)
        }, errorHandler: { (Error) in
            print(Error)
        })
    }
}
