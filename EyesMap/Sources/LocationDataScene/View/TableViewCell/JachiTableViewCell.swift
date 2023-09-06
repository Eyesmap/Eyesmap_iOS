import UIKit
import SnapKit
import SDWebImage

enum DataCellType: CaseIterable {
    case top3
    case other
}

class JachiTableViewCell: UITableViewCell {
    static let top3Identifier = "Top3JachiTableViewCell"
    static let otherIdentifier = "OtherJachiTableViewCell"
    
    var top3Model: JachiTop3Data? {
        didSet {
            top3Configure()
        }
    }
    var theOtherModel: JachiTheOthersData? {
        didSet {
            theOtherConfigure()
        }
    }
    
    //MARK: - Properties
    
    private let ranking: UILabel = {
        let label = UILabel()
        label.text = "1"
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    private let medalImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    private let nameLocationStackView: UIStackView = {
        let stView = UIStackView()
        stView.axis = .vertical
        stView.spacing = 0.5
        stView.alignment = .leading
        return stView
    }()
    private let name: UILabel = {
        let label = UILabel()
        label.text = "점자블록 파손"
        return label
    }()
    private let location: UILabel = {
        let label = UILabel()
        label.text = "서울 중구 세종대로 지하 2"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.rgb(red: 85, green: 131, blue: 236)
        return label
    }()
    private let cnt: UILabel = {
        let label = UILabel()
        label.text = "101"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor(red: 90/255, green: 89/255, blue: 90/255, alpha: 1)
        return label
    }()
    
    var type: DataCellType? {
        didSet {
            setUI()
        }
    }
    
    //MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none

        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - set UI
    func setUI() {
        
        contentView.addSubview(nameLocationStackView)
        nameLocationStackView.addArrangedSubview(name)
        nameLocationStackView.addArrangedSubview(location)
        contentView.addSubview(cnt)
        
        switch type {
        case .top3:
            contentView.addSubview(medalImageView)
            name.font = UIFont.boldSystemFont(ofSize: 18)
            
            medalImageView.snp.makeConstraints { make in
                make.leading.equalToSuperview().inset(6)
                make.centerY.equalToSuperview()
                make.height.width.equalTo(20)
            }
            nameLocationStackView.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.leading.equalTo(medalImageView.snp.trailing).offset(19)
            }
        case .other:
            contentView.addSubview(ranking)
            name.font = UIFont.systemFont(ofSize: 13)
            
            ranking.snp.makeConstraints { (make) in
                make.centerY.equalToSuperview()
                make.leading.equalToSuperview().inset(12)
            }
            name.snp.makeConstraints { (make) in
                make.top.equalToSuperview()
                make.leading.equalTo(ranking.snp.trailing).offset(19)
            }
            location.snp.makeConstraints { make in
                make.top.equalTo(name.snp.bottom).inset(-3)
                make.leading.equalTo(medalImageView.snp.trailing).offset(19)
            }
        case .none:
            // 초기 값 none
            break
        }
        
        cnt.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }
        
    //MARK: - Configure
    private func top3Configure() {
        guard let model = top3Model else { return }
        
        let medalUrl = URL(string: model.medal)
        
        medalImageView.sd_setImage(with: medalUrl)
        name.text = "\(model.title)"
        location.text = "\(model.address)"
        cnt.text = "\(model.count) 개"
        
    }
    
    private func theOtherConfigure() {
        guard let model = theOtherModel else { return }
        
        ranking.text = "\(model.rank)"
        name.text = "\(model.title)"
        location.text = "\(model.address)"
        cnt.text = "\(model.count) 개"
    }
}
