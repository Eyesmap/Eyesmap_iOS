//
//  MapView.swift
//  EyesMap
//
//  Created by 곽민섭 on 2023/08/24.
//

import UIKit
import SnapKit

class MapView: UIImageView {
    static var jachiArray: Array<UIButton> = [MapView.DobongBtn, MapView.NowonBtn, MapView.GangbukBtn, MapView.EunpyeongBtn, MapView.SeongbukBtn, MapView.JungnangBtn, MapView.JongnoBtn, MapView.DongdaemunBtn, MapView.SeodaemunBtn, MapView.GangdongBtn, MapView.JungBtn, MapView.GangseoBtn, MapView.MapoBtn, MapView.SeongdongBtn, MapView.YongsanBtn, MapView.GwangjinBtn, MapView.YeongdeungpoBtn, MapView.YangcheonBtn, MapView.DongjakBtn, MapView.SongpaBtn, MapView.GangnamBtn, MapView.SeochoBtn, MapView.GwanakBtn, MapView.GeumcheonBtn, MapView.GuroBtn]
    
    //MARK: - Properties
    static let DobongBtn: UIButton = {
        let btn = UIButton()
        btn.jachiguBtn(text: "도봉구", cnt: "18")
        return btn
    }()
    static let NowonBtn: UIButton = {
        let btn = UIButton()
        btn.jachiguBtn(text: "노원구", cnt: "18")
        return btn
    }()
    static let GangbukBtn: UIButton = {
        let btn = UIButton()
        btn.jachiguBtn(text: "강북구", cnt: "18")
        return btn
    }()
    static let EunpyeongBtn: UIButton = {
        let btn = UIButton()
        btn.jachiguBtn(text: "은평구", cnt: "18")
        return btn
    }()
    static let SeongbukBtn: UIButton = {
        let btn = UIButton()
        btn.jachiguBtn(text: "성북구", cnt: "18")
        return btn
    }()
    static let JungnangBtn: UIButton = {
        let btn = UIButton()
        btn.jachiguBtn(text: "중랑구", cnt: "18")
        return btn
    }()
    static let JongnoBtn: UIButton = {
        let btn = UIButton()
        btn.jachiguBtn(text: "종로구", cnt: "18")
        return btn
    }()
    static let DongdaemunBtn: UIButton = {
        let btn = UIButton()
        btn.jachiguBtn(text: "동대문구", cnt: "18")
        return btn
    }()
    static let SeodaemunBtn: UIButton = {
        let btn = UIButton()
        btn.jachiguBtn(text: "서대문구", cnt: "18")
        return btn
    }()
    static let GangdongBtn: UIButton = {
        let btn = UIButton()
        btn.jachiguBtn(text: "강동구", cnt: "18")
        return btn
    }()
    static let JungBtn: UIButton = {
        let btn = UIButton()
        btn.jachiguBtn(text: "중구", cnt: "18")
        return btn
    }()
    static let GangseoBtn: UIButton = {
        let btn = UIButton()
        btn.jachiguBtn(text: "강서구", cnt: "18")
        return btn
    }()
    static let MapoBtn: UIButton = {
        let btn = UIButton()
        btn.jachiguBtn(text: "마포구", cnt: "18")
        return btn
    }()
    static let SeongdongBtn: UIButton = {
        let btn = UIButton()
        btn.jachiguBtn(text: "성동구", cnt: "18")
        return btn
    }()
    static let YongsanBtn: UIButton = {
        let btn = UIButton()
        btn.jachiguBtn(text: "용산구", cnt: "18")
        return btn
    }()
    static let GwangjinBtn: UIButton = {
        let btn = UIButton()
        btn.jachiguBtn(text: "광진구", cnt: "18")
        return btn
    }()
    static let YeongdeungpoBtn: UIButton = {
        let btn = UIButton()
        btn.jachiguBtn(text: "영등포구", cnt: "18")
        return btn
    }()
    static let YangcheonBtn: UIButton = {
        let btn = UIButton()
        btn.jachiguBtn(text: "양천구", cnt: "18")
        return btn
    }()
    static let DongjakBtn: UIButton = {
        let btn = UIButton()
        btn.jachiguBtn(text: "동작구", cnt: "18")
        return btn
    }()
    static let SongpaBtn: UIButton = {
        let btn = UIButton()
        btn.jachiguBtn(text: "송파구", cnt: "18")
        return btn
    }()
    static let GangnamBtn: UIButton = {
        let btn = UIButton()
        btn.jachiguBtn(text: "강남구", cnt: "18")
        return btn
    }()
    static let SeochoBtn: UIButton = {
        let btn = UIButton()
        btn.jachiguBtn(text: "서초구", cnt: "18")
        return btn
    }()
    static let GwanakBtn: UIButton = {
        let btn = UIButton()
        btn.jachiguBtn(text: "관악구", cnt: "18")
        return btn
    }()
    static let GeumcheonBtn: UIButton = {
        let btn = UIButton()
        btn.jachiguBtn(text: "금천구", cnt: "18")
        return btn
    }()
    static let GuroBtn: UIButton = {
        let btn = UIButton()
        btn.jachiguBtn(text: "구로구", cnt: "18")
        return btn
    }()
    
    
    
    //MARK: - Life Cycles
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //MARK: - Set Target
    func addTarget() {
        MapView.DobongBtn.addTarget(self, action: #selector(selectFunc(_:)), for: .touchUpInside)
        MapView.NowonBtn.addTarget(self, action: #selector(selectFunc(_:)), for: .touchUpInside)
        MapView.GangbukBtn.addTarget(self, action: #selector(selectFunc(_:)), for: .touchUpInside)
        MapView.EunpyeongBtn.addTarget(self, action: #selector(selectFunc(_:)), for: .touchUpInside)
        MapView.SeongbukBtn.addTarget(self, action: #selector(selectFunc(_:)), for: .touchUpInside)
        MapView.JungnangBtn.addTarget(self, action: #selector(selectFunc(_:)), for: .touchUpInside)
        MapView.JongnoBtn.addTarget(self, action: #selector(selectFunc(_:)), for: .touchUpInside)
        MapView.DongdaemunBtn.addTarget(self, action: #selector(selectFunc(_:)), for: .touchUpInside)
        MapView.SeodaemunBtn.addTarget(self, action: #selector(selectFunc(_:)), for: .touchUpInside)
        MapView.GangdongBtn.addTarget(self, action: #selector(selectFunc(_:)), for: .touchUpInside)
        MapView.JungBtn.addTarget(self, action: #selector(selectFunc(_:)), for: .touchUpInside)
        MapView.GangseoBtn.addTarget(self, action: #selector(selectFunc(_:)), for: .touchUpInside)
        MapView.MapoBtn.addTarget(self, action: #selector(selectFunc(_:)), for: .touchUpInside)
        MapView.SeongdongBtn.addTarget(self, action: #selector(selectFunc(_:)), for: .touchUpInside)
        MapView.YongsanBtn.addTarget(self, action: #selector(selectFunc(_:)), for: .touchUpInside)
        MapView.GwangjinBtn.addTarget(self, action: #selector(selectFunc(_:)), for: .touchUpInside)
        MapView.YeongdeungpoBtn.addTarget(self, action: #selector(selectFunc(_:)), for: .touchUpInside)
        MapView.YangcheonBtn.addTarget(self, action: #selector(selectFunc(_:)), for: .touchUpInside)
        MapView.DongjakBtn.addTarget(self, action: #selector(selectFunc(_:)), for: .touchUpInside)
        MapView.SongpaBtn.addTarget(self, action: #selector(selectFunc(_:)), for: .touchUpInside)
        MapView.GangnamBtn.addTarget(self, action: #selector(selectFunc(_:)), for: .touchUpInside)
        MapView.SeochoBtn.addTarget(self, action: #selector(selectFunc(_:)), for: .touchUpInside)
        MapView.GwanakBtn.addTarget(self, action: #selector(selectFunc(_:)), for: .touchUpInside)
        MapView.GeumcheonBtn.addTarget(self, action: #selector(selectFunc(_:)), for: .touchUpInside)
        MapView.GuroBtn.addTarget(self, action: #selector(selectFunc(_:)), for: .touchUpInside)
    }

    
    
    //MARK: - @objc func
    @objc func selectFunc(_ sender: UIButton) {
        for name in MapView.jachiArray {
            if (name.backgroundColor == UIColor(red: 250/255, green: 207/255, blue: 6/255, alpha: 1) && name != sender) {
                name.backgroundColor = UIColor(red: 37/255, green: 38/255, blue: 42/255, alpha: 1)
                name.setTitleColor(UIColor.white, for: .normal)
            }
        }
        if(sender.backgroundColor == UIColor(red: 250/255, green: 207/255, blue: 6/255, alpha: 1)) {
            sender.backgroundColor = UIColor(red: 37/255, green: 38/255, blue: 42/255, alpha: 1)
            sender.setTitleColor(UIColor.white, for: .normal)
            
            LocationDataViewController.jachiDetail.alpha = 0
        } else {
            sender.backgroundColor = UIColor(red: 250/255, green: 207/255, blue: 6/255, alpha: 1)
            sender.setTitleColor(UIColor.black, for: .normal)
            LocationDataViewController.jachiDetail.alpha = 1
            LocationDataViewController.jachiDetail.titleLabel.text = (sender.titleLabel?.text)?.components(separatedBy: " ")[0]
        }
    }

    
    
    //MARK: - Set UI
    func setUI() {
        self.image = UIImage(named: "seoul-map")
        self.contentMode = .scaleToFill
        
        addSubview(MapView.DobongBtn)
        addSubview(MapView.NowonBtn)
        addSubview(MapView.GangbukBtn)
        addSubview(MapView.EunpyeongBtn)
        addSubview(MapView.SeongbukBtn)
        addSubview(MapView.JungnangBtn)
        addSubview(MapView.JongnoBtn)
        addSubview(MapView.DongdaemunBtn)
        addSubview(MapView.SeodaemunBtn)
        addSubview(MapView.GangdongBtn)
        addSubview(MapView.JungBtn)
        addSubview(MapView.GangseoBtn)
        addSubview(MapView.MapoBtn)
        addSubview(MapView.SeongdongBtn)
        addSubview(MapView.YongsanBtn)
        addSubview(MapView.GwangjinBtn)
        addSubview(MapView.YeongdeungpoBtn)
        addSubview(MapView.YangcheonBtn)
        addSubview(MapView.DongjakBtn)
        addSubview(MapView.SongpaBtn)
        addSubview(MapView.GangnamBtn)
        addSubview(MapView.SeochoBtn)
        addSubview(MapView.GwanakBtn)
        addSubview(MapView.GeumcheonBtn)
        addSubview(MapView.GuroBtn)
        
        MapView.DobongBtn.snp.makeConstraints { (make) in
            make.width.equalTo(61)
            make.height.equalTo(20)
            make.top.equalTo(self.snp.top).inset(30)
            make.leading.equalTo(self.snp.leading).inset(206)
        }
        MapView.NowonBtn.snp.makeConstraints { (make) in
            make.width.equalTo(61)
            make.height.equalTo(20)
            make.top.equalTo(self.snp.top).inset(58)
            make.leading.equalTo(self.snp.leading).inset(260)
        }
        MapView.GangbukBtn.snp.makeConstraints { (make) in
            make.width.equalTo(61)
            make.height.equalTo(20)
            make.top.equalTo(self.snp.top).inset(62)
            make.leading.equalTo(self.snp.leading).inset(185)
        }
        MapView.EunpyeongBtn.snp.makeConstraints { (make) in
            make.width.equalTo(61)
            make.height.equalTo(20)
            make.top.equalTo(self.snp.top).inset(85)
            make.leading.equalTo(self.snp.leading).inset(99)
        }
        MapView.SeongbukBtn.snp.makeConstraints { (make) in
            make.width.equalTo(61)
            make.height.equalTo(20)
            make.top.equalTo(self.snp.top).inset(97)
            make.leading.equalTo(self.snp.leading).inset(207)
        }
        MapView.JungnangBtn.snp.makeConstraints { (make) in
            make.width.equalTo(61)
            make.height.equalTo(20)
            make.top.equalTo(self.snp.top).inset(105)
            make.leading.equalTo(self.snp.leading).inset(269)
        }
        MapView.JongnoBtn.snp.makeConstraints { (make) in
            make.width.equalTo(61)
            make.height.equalTo(20)
            make.top.equalTo(self.snp.top).inset(107)
            make.leading.equalTo(self.snp.leading).inset(154)
        }
        MapView.DongdaemunBtn.snp.makeConstraints { (make) in
            make.width.equalTo(61)
            make.height.equalTo(20)
            make.top.equalTo(self.snp.top).inset(126)
            make.leading.equalTo(self.snp.leading).inset(228)
        }
        MapView.SeodaemunBtn.snp.makeConstraints { (make) in
            make.width.equalTo(61)
            make.height.equalTo(20)
            make.top.equalTo(self.snp.top).inset(130)
            make.leading.equalTo(self.snp.leading).inset(122)
        }
        MapView.GangdongBtn.snp.makeConstraints { (make) in
            make.width.equalTo(61)
            make.height.equalTo(20)
            make.top.equalTo(self.snp.top).inset(143)
            make.leading.equalTo(self.snp.leading).inset(312)
        }
        MapView.JungBtn.snp.makeConstraints { (make) in
            make.width.equalTo(61)
            make.height.equalTo(20)
            make.top.equalTo(self.snp.top).inset(146)
            make.leading.equalTo(self.snp.leading).inset(176)
        }
        MapView.GangseoBtn.snp.makeConstraints { (make) in
            make.width.equalTo(61)
            make.height.equalTo(20)
            make.top.equalTo(self.snp.top).inset(148)
            make.leading.equalTo(self.snp.leading).inset(17)
        }
        MapView.MapoBtn.snp.makeConstraints { (make) in
            make.width.equalTo(61)
            make.height.equalTo(20)
            make.top.equalTo(self.snp.top).inset(153)
            make.leading.equalTo(self.snp.leading).inset(102)
        }
        MapView.SeongdongBtn.snp.makeConstraints { (make) in
            make.width.equalTo(61)
            make.height.equalTo(20)
            make.top.equalTo(self.snp.top).inset(161)
            make.leading.equalTo(self.snp.leading).inset(222)
        }
        MapView.YongsanBtn.snp.makeConstraints { (make) in
            make.width.equalTo(61)
            make.height.equalTo(20)
            make.top.equalTo(self.snp.top).inset(179)
            make.leading.equalTo(self.snp.leading).inset(165)
        }
        MapView.GwangjinBtn.snp.makeConstraints { (make) in
            make.width.equalTo(61)
            make.height.equalTo(20)
            make.top.equalTo(self.snp.top).inset(179)
            make.leading.equalTo(self.snp.leading).inset(268)
        }
        MapView.YeongdeungpoBtn.snp.makeConstraints { (make) in
            make.width.equalTo(61)
            make.height.equalTo(20)
            make.top.equalTo(self.snp.top).inset(193)
            make.leading.equalTo(self.snp.leading).inset(98)
        }
        MapView.YangcheonBtn.snp.makeConstraints { (make) in
            make.width.equalTo(61)
            make.height.equalTo(20)
            make.top.equalTo(self.snp.top).inset(196)
            make.leading.equalTo(self.snp.leading).inset(37)
        }
        MapView.DongjakBtn.snp.makeConstraints { (make) in
            make.width.equalTo(61)
            make.height.equalTo(20)
            make.top.equalTo(self.snp.top).inset(213)
            make.leading.equalTo(self.snp.leading).inset(138)
        }
        MapView.SongpaBtn.snp.makeConstraints { (make) in
            make.width.equalTo(61)
            make.height.equalTo(20)
            make.top.equalTo(self.snp.top).inset(208)
            make.leading.equalTo(self.snp.leading).inset(280)
        }
        MapView.GangnamBtn.snp.makeConstraints { (make) in
            make.width.equalTo(61)
            make.height.equalTo(20)
            make.top.equalTo(self.snp.top).inset(223)
            make.leading.equalTo(self.snp.leading).inset(233)
        }
        MapView.SeochoBtn.snp.makeConstraints { (make) in
            make.width.equalTo(61)
            make.height.equalTo(20)
            make.top.equalTo(self.snp.top).inset(233)
            make.leading.equalTo(self.snp.leading).inset(182)
        }
        MapView.GwanakBtn.snp.makeConstraints { (make) in
            make.width.equalTo(61)
            make.height.equalTo(20)
            make.top.equalTo(self.snp.top).inset(252)
            make.leading.equalTo(self.snp.leading).inset(133)
        }
        MapView.GeumcheonBtn.snp.makeConstraints { (make) in
            make.width.equalTo(61)
            make.height.equalTo(20)
            make.top.equalTo(self.snp.top).inset(259)
            make.leading.equalTo(self.snp.leading).inset(76)
        }
        MapView.GuroBtn.snp.makeConstraints { (make) in
            make.width.equalTo(61)
            make.height.equalTo(20)
            make.top.equalTo(self.snp.top).inset(223)
            make.leading.equalTo(self.snp.leading).inset(26)
        }
    }
}
