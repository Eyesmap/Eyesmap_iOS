import UIKit
import SnapKit

class Top3View: UIView {
    
    //MARK: - Properties
    private var img = UIImageView()
    private var title: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.text = "서대문구"
        return label
    }()
    private var cnt: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor(red: 90/255, green: 89/255, blue: 90/255, alpha: 1)
        label.text = "1"
        return label
    }()
    private var addressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor(red: 85/255, green: 131/255, blue: 236, alpha: 1)
        label.text = "주소"
        return label
    }()
    
    
    
    //MARK: - Life Cycles
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    init(frame: CGRect, imgName: String, title: String, cnt: String, address: String? = nil) {
        super.init(frame: frame)
        
        self.img.image = UIImage(named: imgName)!
        self.title.text = title
       
        setUI()
        
        guard let address = address else {
            self.heightAnchor.constraint(equalToConstant: 25).isActive = true
            self.cnt.text = "총 " + cnt + "회"
            self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:))))
            return
        }
        
        setUI2()
        
        self.heightAnchor.constraint(equalToConstant: 41).isActive = true
        self.cnt.text = cnt
        self.addressLabel.text = address
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //MARK: - Set UI
    func setUI() {
        self.widthAnchor.constraint(equalToConstant: 285).isActive = true
        
        self.addSubview(img)
        self.addSubview(title)
        self.addSubview(cnt)
        
        img.snp.makeConstraints { (make) in
            make.leading.equalTo(self.snp.leading)
            make.top.equalTo(self.snp.top).inset(1)
        }
        title.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top).inset(1)
            make.leading.equalTo(img.snp.trailing).offset(13.38)
        }
        cnt.snp.makeConstraints { (make) in
            make.trailing.equalTo(self.snp.trailing)
            make.top.equalTo(self.snp.top).inset(5)

        }
    }
    func setUI2() {
        self.addSubview(addressLabel)
        
        addressLabel.snp.makeConstraints { (make) in
            make.top.equalTo(title.snp.bottom)
            make.leading.equalTo(title.snp.leading)
        }
    }
    
    //MARK: - @objc func
    @objc func handleTap(sender: UITapGestureRecognizer) {
        for name in MapView.jachiArray {
            // 자치구 배열에 있는 객체의 text와 title이 같을 때
            if (name.titleLabel?.text?.components(separatedBy: " ")[0] == title.text) {
                name.backgroundColor = UIColor(red: 250/255, green: 207/255, blue: 6/255, alpha: 1)
                name.setTitleColor(UIColor.black, for: .normal)
                LocationDataViewController.jachiDetail.alpha = 1
            }
        }
    }
}
