import UIKit

private struct Strings {
    static let noResults = NSLocalizedString(
        "Sorry, No results found",
        comment: "Text for Description Label")
}

class DisplayNoResultView: UIView {
    private let descriptionLabel = UILabel()
    private let searchImageView = UIImageView(image: #imageLiteral(resourceName: "MarketingResources_Thumbnail_Search.width-1200"))

    init(isResultFound: Bool) {
        super.init(frame: .zero)
        if !isResultFound {
            descriptionLabel.isHidden = false
        } else {
            descriptionLabel.isHidden = true
        }

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
            make.width.height.equalTo(200)
        }

        descriptionLabel.snp.makeConstraints { (make) in
            make.top.lessThanOrEqualTo(searchImageView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.lessThanOrEqualToSuperview()
        }
    }
}
