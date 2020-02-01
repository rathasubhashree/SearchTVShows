import UIKit

private struct Strings {
    static let language = NSLocalizedString(
        "Language: \n",
        comment: "Text for language label")

    static let genres = NSLocalizedString(
        "Genres: \n",
        comment: "Text for genres label")

    static let schedule = NSLocalizedString(
        "Schedule: \n", comment: "Text for schedule label")

    static let rating = NSLocalizedString(
        "Rating: \n", comment: "Text for rating label")

    static let status = NSLocalizedString(
        "Status: \n", comment: "Text for status label")

    static let summary = NSLocalizedString(
        "Summary: \n", comment: "Text for summary label")

    static let officialSite = NSLocalizedString(
        "Official Site", comment: "Text for official site Button title")
}

class DisplayDetailedTVShowView: UIView {
    private let scrollView = UIScrollView()
    private let containerView = UIView()
    private let tvShowNameLabel = UILabel()
    private let tvShowImageView = UIImageView()
    private let containerStackView = UIStackView()
    private let languageLabel = UILabel()
    private let genresLabel = UILabel()
    private let scheduleLabel = UILabel()
    private let ratingLabel = UILabel()
    private let tvShowOfficialSiteButton = UIButton()
    private let tvShowDetailLabel = UILabel()
    private let statusLabel = UILabel()

    var officialSiteURL = ""

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }

    func setupAttributedString(
        prefixStringValue: String, suffixStringValue: String) -> NSMutableAttributedString {
        let prefixString = NSMutableAttributedString(
            string: prefixStringValue,
            attributes: [.foregroundColor: UIColor.black,
                         .font: Fonts.title])
        let suffixString = NSMutableAttributedString(
            string: suffixStringValue,
            attributes: [.foregroundColor: UIColor.black,
                         .font: Fonts.value])
        prefixString.append(suffixString)
        return prefixString
    }

    func update(showDetails: DisplayTVShow) {
        tvShowNameLabel.text = showDetails.show.name

        if let image = showDetails.show.image?.original,
            let url = URL(string: image) {
            tvShowImageView.af_setImage(withURL: url, placeholderImage: #imageLiteral(resourceName: "imageNotFound"))
        } else {
            tvShowImageView.isHidden = true
        }

        if let language = showDetails.show.language {
            languageLabel.attributedText =  setupAttributedString(
                prefixStringValue: Strings.language,
                suffixStringValue: language)
        } else {
            languageLabel.isHidden = true
        }

        if let genres = showDetails.show.genres,
            !genres.isEmpty {
            genresLabel.attributedText = setupAttributedString(
                prefixStringValue: Strings.genres,
                suffixStringValue: genres.joined(separator: ", "))
        } else {
            genresLabel.isHidden = true
        }

        if let schedule = showDetails.show.schedule,
            let time = schedule.time,
            let days = schedule.days?.joined(separator: ", "),
            !time.isEmpty || !days.isEmpty {
            scheduleLabel.attributedText = setupAttributedString(
                prefixStringValue: Strings.schedule,
                suffixStringValue: days + " " + time)
        } else {
            scheduleLabel.isHidden = true
        }

        if let rating = showDetails.show.rating?.average {
            ratingLabel.attributedText = setupAttributedString(
                prefixStringValue: Strings.rating,
                suffixStringValue: String(rating) + " / 10")
        } else {
            ratingLabel.isHidden = true
        }

        if let status = showDetails.show.status {
            statusLabel.attributedText = setupAttributedString(
                prefixStringValue: Strings.status,
                suffixStringValue: status)
        } else {
            statusLabel.isHidden = true
        }

        if let officialSite = showDetails.show.officialSite {
            self.officialSiteURL = officialSite
        } else {
            tvShowOfficialSiteButton.isHidden = true
        }

        if let summary = showDetails.show.summary,
            summary != "" {
            let prefixString = NSMutableAttributedString(
                string: Strings.summary,
                attributes: [.foregroundColor: UIColor.black,
                             .font: Fonts.title])
            if let suffixString = summary.htmlAttributedString() {
                prefixString.append(suffixString)
                tvShowDetailLabel.attributedText = prefixString
            } else {
                tvShowDetailLabel.isHidden = true
            }
        } else {
            tvShowDetailLabel.isHidden = true
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backgroundColor = Colors.white.value
        addSubview(scrollView)
        scrollView.showsVerticalScrollIndicator = false

        scrollView.addSubview(containerView)

        containerView.addSubview(tvShowNameLabel)
        tvShowNameLabel.font = Fonts.header
        tvShowNameLabel.numberOfLines = 0
        tvShowNameLabel.textAlignment = .center
        tvShowNameLabel.textColor = Colors.black.value

        containerView.addSubview(containerStackView)
        containerStackView.alignment = .fill
        containerStackView.distribution = .fill
        containerStackView.axis = .vertical
        containerStackView.spacing = 8

        containerStackView.addArrangedSubview(tvShowImageView)
        tvShowImageView.contentMode = .scaleToFill

        containerStackView.addArrangedSubview(genresLabel)
        genresLabel.numberOfLines = 0
        genresLabel.textAlignment = .left

        containerStackView.addArrangedSubview(scheduleLabel)
        scheduleLabel.numberOfLines = 0
        scheduleLabel.textAlignment = .left

        containerStackView.addArrangedSubview(languageLabel)
        languageLabel.numberOfLines = 0
        languageLabel.textAlignment = .left

        containerStackView.addArrangedSubview(ratingLabel)
        ratingLabel.numberOfLines = 0
        ratingLabel.textAlignment = .left

        containerStackView.addArrangedSubview(statusLabel)
        statusLabel.numberOfLines = 0
        statusLabel.textAlignment = .left

        containerView.addSubview(tvShowDetailLabel)
        tvShowDetailLabel.numberOfLines = 0
        tvShowDetailLabel.textAlignment = .left

        containerView.addSubview(tvShowOfficialSiteButton)
        tvShowOfficialSiteButton.setTitle(Strings.officialSite, for: .normal)
        tvShowOfficialSiteButton.setTitleColor(
            Colors.white.value, for: .normal)
        tvShowOfficialSiteButton.titleLabel?.font = Fonts.title
        tvShowOfficialSiteButton.backgroundColor = Colors.tableViewBackgroundColor.value
        tvShowOfficialSiteButton.layer.cornerRadius = 10
        tvShowOfficialSiteButton.addTarget(
            self, action: #selector(officialSiteButtonTapped),
            for: .touchUpInside)
    }

    @objc func officialSiteButtonTapped() {
        guard let url = URL(string: officialSiteURL) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

    private func setupConstraints() {
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        containerView.snp.makeConstraints { (make) in
            make.edges.width.equalToSuperview()
        }

        tvShowNameLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
        }

        containerStackView.snp.makeConstraints { (make) in
            make.top.equalTo(tvShowNameLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
        }

        tvShowImageView.snp.makeConstraints { (make) in
            make.height.equalTo(tvShowImageView.snp.width)
            make.leading.trailing.equalToSuperview()
        }

        tvShowDetailLabel.snp.makeConstraints { (make) in
            make.top.equalTo(containerStackView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
        }

        tvShowOfficialSiteButton.snp.makeConstraints { (make) in
            make.top.equalTo(tvShowDetailLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(80)
            make.centerX.equalToSuperview()
            make.height.equalTo(54)
            make.bottom.equalToSuperview().inset(16)
        }
    }
}

extension String {

    func htmlAttributedString() -> NSMutableAttributedString? {
        guard let data = self.data(
            using: String.Encoding.utf16, allowLossyConversion: false) else { return nil }
        guard let html = try? NSMutableAttributedString(
            data: data,
            options: [.documentType: NSAttributedString.DocumentType.html],
            documentAttributes: nil) else { return nil }
        html.addAttributes(
            [.font: Fonts.value,
             .foregroundColor: Colors.black.value],
            range: NSRange(location: 0, length: html.length))
        return html
    }
}
