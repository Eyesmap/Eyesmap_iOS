//
//  CustomToggleButton.swift
//  EyesMap
//
//  Created by 박현준 on 2023/08/15.
//

import UIKit
import SnapKit

protocol CustomToggleButtonDelegate: AnyObject {
    func isOnValueChange(isOn: Bool)
}

class CustomToggleButton: UIButton {
    //MARK: - Properties
    typealias SwitchColor = (bar: UIColor, circle: UIColor)
    
    var barViewTopBottomMargin: CGFloat = 5
    var animationDuration: TimeInterval = 0.25
    private var isAnimated: Bool = false
    weak var delegate: CustomToggleButtonDelegate?
    
    var isOn: Bool = false {
        didSet {
            self.changeState()
        }
    }
    
    // on 상태의 스위치 색상
    var onColor: SwitchColor = (UIColor.rgb(red: 93, green: 241, blue: 115), UIColor.rgb(red: 13, green: 221, blue: 95)) {
        didSet {
            if isOn {
                self.barView.backgroundColor = self.onColor.bar
                self.circleView.backgroundColor = self.onColor.circle
            }
        }
    }
    
    // off 상태의 스위치 색상
    var offColor: SwitchColor = (#colorLiteral(red: 0.9098039216, green: 0.9098039216, blue: 0.9098039216, alpha: 1), #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)) {
        didSet {
            if isOn == false {
                self.barView.backgroundColor = self.offColor.bar
                self.circleView.backgroundColor = self.offColor.circle
            }
        }
    }
    
    private var barView = UIView()
    
    private var circleView = UIView()
    
    
    //MARK: - Life Cycles
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.buttonInit(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)

    }
    
    //MARK: - set UI
    private func buttonInit(frame: CGRect) {
        let barViewHeight = frame.height - (barViewTopBottomMargin * 2)
        barView = UIView(frame: CGRect(x: 0, y: barViewTopBottomMargin, width: frame.width, height: barViewHeight))
        barView.backgroundColor = self.offColor.bar
        barView.layer.masksToBounds = true
        barView.layer.cornerRadius = barViewHeight / 2
        
        self.addSubview(barView)
        
        circleView = UIView(frame: CGRect(x: 0, y: 0, width: frame.height, height: frame.height))
        circleView.backgroundColor = self.offColor.circle
        circleView.layer.masksToBounds = true
        circleView.layer.cornerRadius = frame.height / 2
        
        self.addSubview(circleView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleTap))
        self.addGestureRecognizer(tapGesture)
    }
    
    //MARK: - 터치 입력 끝냈을 때 상태 변환
    @objc func toggleTap() {
        VoiceNetworkManager.shared.voiceOnOffRequest { [weak self] (error, model) in
            if let error = error {
                print("on/off Error: \(error.localizedDescription)")
            }
            
            if let model = model {
                print("on/off Network isOn - \(model.result)")
                self?.setOn(on: model.result, animated: true)
            }
        }
    }
    
    func setOn(on: Bool, animated: Bool) {
        if isAnimated {
            return
        }
        
        self.isAnimated = animated
        self.isOn = on
    }
    
    //MARK: - 상태 변경
    private func changeState() {
        print("DEBUG: 상태 변경")
        
        var circleCenter: CGFloat = 0
        var barViewColor: UIColor = .clear
        var circleViewColor: UIColor = .clear
        
        if self.isOn {
            circleCenter = self.barView.frame.width - (self.circleView.frame.width / 2)
            barViewColor = self.onColor.bar
            circleViewColor = self.onColor.circle
        } else {
            circleCenter = self.circleView.frame.width - (self.circleView.frame.width / 2)
            barViewColor = self.offColor.bar
            circleViewColor = self.offColor.circle
        }
        
        let duration = self.isAnimated ? self.animationDuration : 0
        
        UIView.animate(withDuration: duration, animations: { [weak self] in
            guard let self = self else { return }
            
            self.circleView.center.x = circleCenter
            self.barView.backgroundColor = barViewColor
            self.circleView.backgroundColor = circleViewColor
        }) { [weak self] _ in
            guard let self = self else { return }
            
            self.delegate?.isOnValueChange(isOn: self.isOn)
            self.isAnimated = false
        }
    }
}

