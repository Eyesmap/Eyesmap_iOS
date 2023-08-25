import UIKit
import SnapKit

class RankingTableViewCell: UITableViewCell {
    static let identifier = "RankingTableViewCell"
    
    //MARK: - Properties
    private let ranking: UILabel = {
        let label = UILabel()
        label.text = "1"
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    private let name: UILabel = {
        let label = UILabel()
        label.text = "종로구"
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    private let cnt: UILabel = {
        let label = UILabel()
        label.text = "총 18회"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor(red: 90/255, green: 89/255, blue: 90/255, alpha: 1)
        return label
    }()
    
    
    
    //MARK: - init
    override init(style: RankingTableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        ranking.translatesAutoresizingMaskIntoConstraints = false
        name.translatesAutoresizingMaskIntoConstraints = false
        cnt.translatesAutoresizingMaskIntoConstraints = false
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

    
    
    // MARK: - settUI
    func setUI() {
        contentView.addSubview(ranking)
        contentView.addSubview(name)
        contentView.addSubview(cnt)
        
        ranking.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.leading.equalTo(contentView.snp.leading).inset(6)
        }
        name.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.leading.equalTo(ranking.snp.trailing).offset(19)
        }
        cnt.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.trailing.equalTo(contentView.snp.trailing)
        }
    }
}
