//
//  FloatingButtonView.swift
//  travel2
//
//  Created by 吳宗祐 on 2023/6/30.
//

import UIKit

protocol FloatingButtonViewDelegate: AnyObject {
    func btnViewAciton()
}

class FloatingButtonView: UIView {

    var targetView : UIView?
    weak var delegate: FloatingButtonViewDelegate?
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height

    override init(frame: CGRect) {
        super.init(frame: frame)
        selfView()
        setConstraints()
    }

    func selfView() {
        self.frame = CGRect.init(x: screenWidth - (screenWidth * 0.25),
                                 y: screenHeight * 0.8,
                                 width: screenWidth * 0.25,
                                 height: screenWidth * 0.25)

        let panner = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        panner.minimumNumberOfTouches = 1
        self.addGestureRecognizer(panner)
        self.backgroundColor = .systemBlue
        
    }

    lazy var topButton: UIButton = {
        let topButton = UIButton(type: .custom)
        topButton.setImage(UIImage(systemName: "heart"), for: .normal)
        topButton.tintColor = .systemOrange
        topButton.frame = CGRect.init(x: 0, y: 0, width: self.frame.width * 0.4, height: self.frame.width * 0.4)
        topButton.autoresizingMask = []
        topButton.addTarget(self, action: #selector(closeBtn), for: .touchUpInside)
        topButton.backgroundColor = .clear
        topButton.translatesAutoresizingMaskIntoConstraints = false
        return topButton
    }()

    lazy var downButton: UIButton = {
        let downButton = UIButton(type: .custom)
        downButton.frame = CGRect.init(x: 0, y: 0, width: self.frame.width * 0.65, height: self.frame.width * 0.65)
        downButton.autoresizingMask = []
        downButton.addTarget(self, action: #selector(clickBtn), for: .touchUpInside)
        downButton.backgroundColor = .clear
        downButton.setBackgroundImage(UIImage(named: "violet_6"), for: .normal)
        downButton.translatesAutoresizingMaskIntoConstraints = false
        return downButton
    }()

    func setConstraints() {
        self.addSubview(downButton)
        downButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        downButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        downButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.65).isActive = true
        downButton.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.65).isActive = true
        self.addSubview(topButton)
        topButton.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        topButton.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        topButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.4).isActive = true
        topButton.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.4).isActive = true
    }

    /// 拖曳手勢
    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        // 取得手勢位置
        let location = gesture.location(in: targetView)
        // 移動中
        if gesture.state == .changed {
            self.center = location
        // 移動結束
        } else if gesture.state == .ended {
            var lineBtnRect = self.frame
            // 左邊
            if location.x < screenWidth/2 {
                lineBtnRect.origin.x = 0
            // 右邊
            } else {
                lineBtnRect.origin.x = screenWidth - self.frame.width
            }
            // 上邊
            if location.y - self.frame.height/2 < 44 {
                lineBtnRect.origin.y = 44
            // 下邊
            } else if location.y + self.frame.height/2 > screenHeight - 44 {
                lineBtnRect.origin.y = screenHeight - 44 - self.frame.height - 10
            }

            UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                self.frame = lineBtnRect
            }, completion: nil)
        }
    }

    /// 點擊topButton事件
    @objc func closeBtn() {
        removeFloatingButton()
    }

    /// 點擊downButton事件
    @objc func clickBtn() {
        delegate?.btnViewAciton()
    }

    /// 新增浮動FloatingButton按鈕
    func addFloatingButton(target: UIView) {
        let sceneDelegate = UIApplication.shared.connectedScenes
                .first!.delegate as! SceneDelegate
        let window = sceneDelegate.window
        window?.rootViewController?.view.addSubview(self)
        self.targetView = target
    }

    /// 移除浮動FloatingButton按鈕
    func removeFloatingButton() {
        self.removeFromSuperview()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
