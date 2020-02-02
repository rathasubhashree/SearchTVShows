import UIKit

private struct Strings {
    static let noResults = NSLocalizedString(
        "Sorry, No results found",
        comment: "Text for Description Label")
}

class DisplayNoResultView: UIView {
    private let descriptionLabel = UILabel()
    private let searchImageView = UIImageView(image: #imageLiteral(resourceName: "MarketingResources_Thumbnail_Search.width-1200"))
    private let estimatedImageViewHeight = 200

    var isResultFound: Bool = true {
        didSet {
            descriptionLabel.isHidden = isResultFound
        }
    }

    init() {
        super.init(frame: .zero)

        setupView()
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backgroundColor = Colors.white.value
        addSubview(searchImageView)
        searchImageView.contentMode = .scaleAspectFill

        descriptionLabel.font = Fonts.title
        descriptionLabel.text = Strings.noResults
        descriptionLabel.textAlignment = .center
        addSubview(descriptionLabel)
    }

    private func setupConstraints() {
        searchImageView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.height.equalTo(estimatedImageViewHeight)
        }

        descriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(searchImageView.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(Margins.x2.rawValue)
            make.centerX.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        }
    }
}
