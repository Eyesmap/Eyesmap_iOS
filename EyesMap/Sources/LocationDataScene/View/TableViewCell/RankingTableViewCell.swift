import UIKit
import SnapKit
import SDWebImage

class RankingTableViewCell: UITableViewCell {
    static let top3Identifier = "Top3RankingTableViewCell"
    static let otherIdentifier = "OtherRankingTableViewCell"
    
    var top3Model: Top3Data? {
        didSet {
            top3Configure()
        }
    }
    var theOtherModel: TheOthersData? {
        didSet {
            theOtherConfigure()
        }
    }
    
    //MARK: - Properties
    private let ranking: UILabel = {
        let label = UILabel()
        label.text = "4"
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    private let medalImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    private let name: UILabel = {
        let label = UILabel()
        label.text = "종로구"
        return label
    }()
    private let cnt: UILabel = {
        let label = UILabel()
        label.text = "총 18회"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor(red: 90/255, green: 89/255, blue: 90/255, alpha: 1)
        return label
    }()
    public var gu_id: Int = 0
    
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
        contentView.addSubview(name)
        contentView.addSubview(cnt)
        
        switch type {
        case .top3:
            contentView.addSubview(medalImageView)
            name.font = UIFont.boldSystemFont(ofSize: 16)
            
            medalImageView.snp.makeConstraints { make in
                make.leading.equalToSuperview().inset(6)
                make.centerY.equalToSuperview()
                make.height.width.equalTo(20)
            }
            name.snp.makeConstraints { (make) in
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
                make.centerY.equalToSuperview()
                make.leading.equalTo(ranking.snp.trailing).offset(24)
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
        name.text = "\(model.guName)구"
        cnt.text = "총 \(model.reportCount) 회"
        gu_id = model.guNum
    }
    
    private func theOtherConfigure() {
        guard let model = theOtherModel else { return }
        
        ranking.text = "\(model.rank)"
        name.text = "\(model.guName)구"
        cnt.text = "총 \(model.reportCount) 회"
        gu_id = model.guNum
    }
}
