import UIKit

class DisplayTVShowDetailsTableViewCell: UITableViewCell {
    static let cellReuseIdentifier = "DisplayTVShowDetailsTableViewCell"
    private let containerView = UIView()
    private let tvShowImageView = UIImageView()
    private let tvShowNameLabel = UILabel()
    private let tvShowLanguageLabel = UILabel()
    private let containerStackView = UIStackView()
    private let statusLabel = UILabel()
    private let estimatedImageViewHeight = 100

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(appDetails: DisplayTVShow) {
        tvShowNameLabel.text = appDetails.show.name

        if let image = appDetails.show.image?.original,
            let url = URL(string: image) {
            tvShowImageView.af_setImage(withURL: url, placeholderImage: #imageLiteral(resourceName: "imageNotFound"))
        } else {
            tvShowImageView.image = #imageLiteral(resourceName: "imageNotFound")
        }
        tvShowLanguageLabel.text = appDetails.show.language

        guard let status = appDetails.show.status else {
            statusLabel.text = "Not available"
            return
        }
        statusLabel.text = status
    }

    private func setupView() {
        contentView.addSubview(containerView)
        containerView.backgroundColor = Colors.white.value
        containerView.layer.cornerRadius = Margins.x1.rawValue
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.5
        containerView.layer.shadowOffset = CGSize.zero
        containerView.layer.shadowRadius = 2

        containerView.addSubview(tvShowImageView)
        tvShowImageView.contentMode = .scaleAspectFill
        tvShowImageView.layer.cornerRadius = 50
        tvShowImageView.clipsToBounds = true

        containerView.addSubview(containerStackView)
        containerStackView.distribution = .fill
        containerStackView.axis = .vertical
        containerStackView.alignment = .fill
        containerStackView.spacing = Margins.x1.rawValue

        containerStackView.addArrangedSubview(tvShowNameLabel)
        tvShowNameLabel.font = Fonts.title
        tvShowNameLabel.numberOfLines = 0
        tvShowNameLabel.textAlignment = .left
        tvShowNameLabel.textColor = Colors.black.value

        containerStackView.addArrangedSubview(tvShowLanguageLabel)
        tvShowLanguageLabel.font = Fonts.value
        tvShowLanguageLabel.textColor = Colors.navBarTintColor.value
        tvShowLanguageLabel.textAlignment = .left
        tvShowLanguageLabel.numberOfLines = 0

        containerStackView.addArrangedSubview(statusLabel)
        statusLabel.font = Fonts.subtitleValue
        statusLabel.textColor = Colors.black.value
        statusLabel.textAlignment = .left
        statusLabel.numberOfLines = 0
    }

    private func setupConstraints() {
        containerView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview().inset(Margins.x1.rawValue)
            make.leading.trailing.equalToSuperview().inset(Margins.x2.rawValue)
        }

        tvShowImageView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview().inset(Margins.x1.rawValue)
            make.leading.equalToSuperview().offset(Margins.x2.rawValue)
            make.width.height.equalTo(estimatedImageViewHeight)
        }

        containerStackView.snp.makeConstraints { (make) in
            make.top.greaterThanOrEqualToSuperview().inset(Margins.x1.rawValue)
            make.leading.equalTo(tvShowImageView.snp.trailing).offset(Margins.x2.rawValue)
            make.centerY.equalTo(tvShowImageView.snp.centerY)
            make.trailing.lessThanOrEqualToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
