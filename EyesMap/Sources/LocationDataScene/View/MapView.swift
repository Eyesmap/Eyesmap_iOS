//
//  MapView.swift
//  EyesMap
//
//  Created by 곽민섭 on 2023/08/24.
//

import UIKit
import SnapKit

protocol MapViewDelegate: AnyObject {
    func jachiViewAppear(isHidden: Bool, title: String)
}

class MapView: UIImageView {
    static var jachiArray: [UIButton] = []
    weak var delegate: MapViewDelegate?
    
    //MARK: - Properties
    lazy var DobongBtn: UIButton = {
        let btn = UIButton()
        btn.jachiguBtn(text: "도봉구", cnt: "18")
        return btn
    }()
    lazy var NowonBtn: UIButton = {
        let btn = UIButton()
        btn.jachiguBtn(text: "노원구", cnt: "18")
        return btn
    }()
    lazy var GangbukBtn: UIButton = {
        let btn = UIButton()
        btn.jachiguBtn(text: "강북구", cnt: "18")
        return btn
    }()
    lazy var EunpyeongBtn: UIButton = {
        let btn = UIButton()
        btn.jachiguBtn(text: "은평구", cnt: "18")
        return btn
    }()
    lazy var SeongbukBtn: UIButton = {
        let btn = UIButton()
        btn.jachiguBtn(text: "성북구", cnt: "18")
        return btn
    }()
    lazy var JungnangBtn: UIButton = {
        let btn = UIButton()
        btn.jachiguBtn(text: "중랑구", cnt: "18")
        return btn
    }()
    lazy var JongnoBtn: UIButton = {
        let btn = UIButton()
        btn.jachiguBtn(text: "종로구", cnt: "18")
        return btn
    }()
    lazy var DongdaemunBtn: UIButton = {
        let btn = UIButton()
        btn.jachiguBtn(text: "동대문구", cnt: "18")
        return btn
    }()
    lazy var SeodaemunBtn: UIButton = {
        let btn = UIButton()
        btn.jachiguBtn(text: "서대문구", cnt: "18")
        return btn
    }()
    lazy var GangdongBtn: UIButton = {
        let btn = UIButton()
        btn.jachiguBtn(text: "강동구", cnt: "18")
        return btn
    }()
    lazy var JungBtn: UIButton = {
        let btn = UIButton()
        btn.jachiguBtn(text: "중구", cnt: "18")
        return btn
    }()
    lazy var GangseoBtn: UIButton = {
        let btn = UIButton()
        btn.jachiguBtn(text: "강서구", cnt: "18")
        return btn
    }()
    lazy var MapoBtn: UIButton = {
        let btn = UIButton()
        btn.jachiguBtn(text: "마포구", cnt: "18")
        return btn
    }()
    lazy var SeongdongBtn: UIButton = {
        let btn = UIButton()
        btn.jachiguBtn(text: "성동구", cnt: "18")
        return btn
    }()
    lazy var YongsanBtn: UIButton = {
        let btn = UIButton()
        btn.jachiguBtn(text: "용산구", cnt: "18")
        return btn
    }()
    lazy var GwangjinBtn: UIButton = {
        let btn = UIButton()
        btn.jachiguBtn(text: "광진구", cnt: "18")
        return btn
    }()
    lazy var YeongdeungpoBtn: UIButton = {
        let btn = UIButton()
        btn.jachiguBtn(text: "영등포구", cnt: "18")
        return btn
    }()
    lazy var YangcheonBtn: UIButton = {
        let btn = UIButton()
        btn.jachiguBtn(text: "양천구", cnt: "18")
        return btn
    }()
    lazy var DongjakBtn: UIButton = {
        let btn = UIButton()
        btn.jachiguBtn(text: "동작구", cnt: "18")
        return btn
    }()
    lazy var SongpaBtn: UIButton = {
        let btn = UIButton()
        btn.jachiguBtn(text: "송파구", cnt: "18")
        return btn
    }()
    lazy var GangnamBtn: UIButton = {
        let btn = UIButton()
        btn.jachiguBtn(text: "강남구", cnt: "18")
        return btn
    }()
    lazy var SeochoBtn: UIButton = {
        let btn = UIButton()
        btn.jachiguBtn(text: "서초구", cnt: "18")
        return btn
    }()
    lazy var GwanakBtn: UIButton = {
        let btn = UIButton()
        btn.jachiguBtn(text: "관악구", cnt: "18")
        return btn
    }()
    lazy var GeumcheonBtn: UIButton = {
        let btn = UIButton()
        btn.jachiguBtn(text: "금천구", cnt: "18")
        return btn
    }()
    lazy var GuroBtn: UIButton = {
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
        DobongBtn.addTarget(self, action: #selector(selectFunc(_:)), for: .touchUpInside)
        NowonBtn.addTarget(self, action: #selector(selectFunc(_:)), for: .touchUpInside)
        GangbukBtn.addTarget(self, action: #selector(selectFunc(_:)), for: .touchUpInside)
        EunpyeongBtn.addTarget(self, action: #selector(selectFunc(_:)), for: .touchUpInside)
        SeongbukBtn.addTarget(self, action: #selector(selectFunc(_:)), for: .touchUpInside)
        JungnangBtn.addTarget(self, action: #selector(selectFunc(_:)), for: .touchUpInside)
        JongnoBtn.addTarget(self, action: #selector(selectFunc(_:)), for: .touchUpInside)
        DongdaemunBtn.addTarget(self, action: #selector(selectFunc(_:)), for: .touchUpInside)
        SeodaemunBtn.addTarget(self, action: #selector(selectFunc(_:)), for: .touchUpInside)
        GangdongBtn.addTarget(self, action: #selector(selectFunc(_:)), for: .touchUpInside)
        JungBtn.addTarget(self, action: #selector(selectFunc(_:)), for: .touchUpInside)
        GangseoBtn.addTarget(self, action: #selector(selectFunc(_:)), for: .touchUpInside)
        MapoBtn.addTarget(self, action: #selector(selectFunc(_:)), for: .touchUpInside)
        SeongdongBtn.addTarget(self, action: #selector(selectFunc(_:)), for: .touchUpInside)
        YongsanBtn.addTarget(self, action: #selector(selectFunc(_:)), for: .touchUpInside)
        GwangjinBtn.addTarget(self, action: #selector(selectFunc(_:)), for: .touchUpInside)
        YeongdeungpoBtn.addTarget(self, action: #selector(selectFunc(_:)), for: .touchUpInside)
        YangcheonBtn.addTarget(self, action: #selector(selectFunc(_:)), for: .touchUpInside)
        DongjakBtn.addTarget(self, action: #selector(selectFunc(_:)), for: .touchUpInside)
        SongpaBtn.addTarget(self, action: #selector(selectFunc(_:)), for: .touchUpInside)
        GangnamBtn.addTarget(self, action: #selector(selectFunc(_:)), for: .touchUpInside)
        SeochoBtn.addTarget(self, action: #selector(selectFunc(_:)), for: .touchUpInside)
        GwanakBtn.addTarget(self, action: #selector(selectFunc(_:)), for: .touchUpInside)
        GeumcheonBtn.addTarget(self, action: #selector(selectFunc(_:)), for: .touchUpInside)
        GuroBtn.addTarget(self, action: #selector(selectFunc(_:)), for: .touchUpInside)
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
            
            self.delegate?.jachiViewAppear(isHidden: true, title: "")
        } else {
            sender.backgroundColor = UIColor(red: 250/255, green: 207/255, blue: 6/255, alpha: 1)
            sender.setTitleColor(UIColor.black, for: .normal)
            
            self.delegate?.jachiViewAppear(isHidden: false, title: (sender.titleLabel?.text)?.components(separatedBy: " ")[0] ?? "")
        }
    }

    
    
    //MARK: - Set UI
    func setUI() {
        self.image = UIImage(named: "seoul-map")
        self.contentMode = .scaleToFill
        MapView.jachiArray = [self.DobongBtn, self.NowonBtn, self.GangbukBtn, self.EunpyeongBtn, self.SeongbukBtn, self.JungnangBtn, self.JongnoBtn, self.DongdaemunBtn, self.SeodaemunBtn, self.GangdongBtn, self.JungBtn, self.GangseoBtn, self.MapoBtn, self.SeongdongBtn, self.YongsanBtn, self.GwangjinBtn, self.YeongdeungpoBtn, self.YangcheonBtn, self.DongjakBtn, self.SongpaBtn, self.GangnamBtn, self.SeochoBtn, self.GwanakBtn, self.GeumcheonBtn, self.GuroBtn]
        
        addSubview(DobongBtn)
        addSubview(NowonBtn)
        addSubview(GangbukBtn)
        addSubview(EunpyeongBtn)
        addSubview(SeongbukBtn)
        addSubview(JungnangBtn)
        addSubview(JongnoBtn)
        addSubview(DongdaemunBtn)
        addSubview(SeodaemunBtn)
        addSubview(GangdongBtn)
        addSubview(JungBtn)
        addSubview(GangseoBtn)
        addSubview(MapoBtn)
        addSubview(SeongdongBtn)
        addSubview(YongsanBtn)
        addSubview(GwangjinBtn)
        addSubview(YeongdeungpoBtn)
        addSubview(YangcheonBtn)
        addSubview(DongjakBtn)
        addSubview(SongpaBtn)
        addSubview(GangnamBtn)
        addSubview(SeochoBtn)
        addSubview(GwanakBtn)
        addSubview(GeumcheonBtn)
        addSubview(GuroBtn)
        
        DobongBtn.snp.makeConstraints { (make) in
            make.width.equalTo(61)
            make.height.equalTo(20)
            make.top.equalTo(self.snp.top).inset(30)
            make.leading.equalTo(self.snp.leading).inset(206)
        }
        NowonBtn.snp.makeConstraints { (make) in
            make.width.equalTo(61)
            make.height.equalTo(20)
            make.top.equalTo(self.snp.top).inset(58)
            make.leading.equalTo(self.snp.leading).inset(260)
        }
        GangbukBtn.snp.makeConstraints { (make) in
            make.width.equalTo(61)
            make.height.equalTo(20)
            make.top.equalTo(self.snp.top).inset(62)
            make.leading.equalTo(self.snp.leading).inset(185)
        }
        EunpyeongBtn.snp.makeConstraints { (make) in
            make.width.equalTo(61)
            make.height.equalTo(20)
            make.top.equalTo(self.snp.top).inset(85)
            make.leading.equalTo(self.snp.leading).inset(99)
        }
        SeongbukBtn.snp.makeConstraints { (make) in
            make.width.equalTo(61)
            make.height.equalTo(20)
            make.top.equalTo(self.snp.top).inset(97)
            make.leading.equalTo(self.snp.leading).inset(207)
        }
        JungnangBtn.snp.makeConstraints { (make) in
            make.width.equalTo(61)
            make.height.equalTo(20)
            make.top.equalTo(self.snp.top).inset(105)
            make.leading.equalTo(self.snp.leading).inset(269)
        }
        JongnoBtn.snp.makeConstraints { (make) in
            make.width.equalTo(61)
            make.height.equalTo(20)
            make.top.equalTo(self.snp.top).inset(107)
            make.leading.equalTo(self.snp.leading).inset(154)
        }
        DongdaemunBtn.snp.makeConstraints { (make) in
            make.width.equalTo(61)
            make.height.equalTo(20)
            make.top.equalTo(self.snp.top).inset(126)
            make.leading.equalTo(self.snp.leading).inset(228)
        }
        SeodaemunBtn.snp.makeConstraints { (make) in
            make.width.equalTo(61)
            make.height.equalTo(20)
            make.top.equalTo(self.snp.top).inset(130)
            make.leading.equalTo(self.snp.leading).inset(122)
        }
        GangdongBtn.snp.makeConstraints { (make) in
            make.width.equalTo(61)
            make.height.equalTo(20)
            make.top.equalTo(self.snp.top).inset(143)
            make.leading.equalTo(self.snp.leading).inset(312)
        }
        JungBtn.snp.makeConstraints { (make) in
            make.width.equalTo(61)
            make.height.equalTo(20)
            make.top.equalTo(self.snp.top).inset(146)
            make.leading.equalTo(self.snp.leading).inset(176)
        }
        GangseoBtn.snp.makeConstraints { (make) in
            make.width.equalTo(61)
            make.height.equalTo(20)
            make.top.equalTo(self.snp.top).inset(148)
            make.leading.equalTo(self.snp.leading).inset(17)
        }
        MapoBtn.snp.makeConstraints { (make) in
            make.width.equalTo(61)
            make.height.equalTo(20)
            make.top.equalTo(self.snp.top).inset(153)
            make.leading.equalTo(self.snp.leading).inset(102)
        }
        SeongdongBtn.snp.makeConstraints { (make) in
            make.width.equalTo(61)
            make.height.equalTo(20)
            make.top.equalTo(self.snp.top).inset(161)
            make.leading.equalTo(self.snp.leading).inset(222)
        }
        YongsanBtn.snp.makeConstraints { (make) in
            make.width.equalTo(61)
            make.height.equalTo(20)
            make.top.equalTo(self.snp.top).inset(179)
            make.leading.equalTo(self.snp.leading).inset(165)
        }
        GwangjinBtn.snp.makeConstraints { (make) in
            make.width.equalTo(61)
            make.height.equalTo(20)
            make.top.equalTo(self.snp.top).inset(179)
            make.leading.equalTo(self.snp.leading).inset(268)
        }
        YeongdeungpoBtn.snp.makeConstraints { (make) in
            make.width.equalTo(61)
            make.height.equalTo(20)
            make.top.equalTo(self.snp.top).inset(193)
            make.leading.equalTo(self.snp.leading).inset(98)
        }
        YangcheonBtn.snp.makeConstraints { (make) in
            make.width.equalTo(61)
            make.height.equalTo(20)
            make.top.equalTo(self.snp.top).inset(196)
            make.leading.equalTo(self.snp.leading).inset(37)
        }
        DongjakBtn.snp.makeConstraints { (make) in
            make.width.equalTo(61)
            make.height.equalTo(20)
            make.top.equalTo(self.snp.top).inset(213)
            make.leading.equalTo(self.snp.leading).inset(138)
        }
        SongpaBtn.snp.makeConstraints { (make) in
            make.width.equalTo(61)
            make.height.equalTo(20)
            make.top.equalTo(self.snp.top).inset(208)
            make.leading.equalTo(self.snp.leading).inset(280)
        }
        GangnamBtn.snp.makeConstraints { (make) in
            make.width.equalTo(61)
            make.height.equalTo(20)
            make.top.equalTo(self.snp.top).inset(223)
            make.leading.equalTo(self.snp.leading).inset(233)
        }
        SeochoBtn.snp.makeConstraints { (make) in
            make.width.equalTo(61)
            make.height.equalTo(20)
            make.top.equalTo(self.snp.top).inset(233)
            make.leading.equalTo(self.snp.leading).inset(182)
        }
        GwanakBtn.snp.makeConstraints { (make) in
            make.width.equalTo(61)
            make.height.equalTo(20)
            make.top.equalTo(self.snp.top).inset(252)
            make.leading.equalTo(self.snp.leading).inset(133)
        }
        GeumcheonBtn.snp.makeConstraints { (make) in
            make.width.equalTo(61)
            make.height.equalTo(20)
            make.top.equalTo(self.snp.top).inset(259)
            make.leading.equalTo(self.snp.leading).inset(76)
        }
        GuroBtn.snp.makeConstraints { (make) in
            make.width.equalTo(61)
            make.height.equalTo(20)
            make.top.equalTo(self.snp.top).inset(223)
            make.leading.equalTo(self.snp.leading).inset(26)
        }
    }
}
