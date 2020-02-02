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
    private let estimatedButtonHeight = 54

    var officialSiteURL = ""

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }

    func update(showDetails: ShowDetails) {
        tvShowNameLabel.text = showDetails.name
        updateImage(showDetails.image?.original)
        updateLanguage(showDetails.language)
        updateGenre(showDetails.genres)
        updateSchedule(showDetails.schedule)
        updateRating(showDetails.rating?.average)
        updateStatus(showDetails.status)
        updateOfficialSite(showDetails.officialSite)
        updateSummary(showDetails.summary)
    }

    private func setupAttributedString(
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

    private func updateImage(_ image: String?) {
        if let image = image,
            let url = URL(string: image) {
            tvShowImageView.af_setImage(withURL: url, placeholderImage: #imageLiteral(resourceName: "imageNotFound"))
        } else {
            tvShowImageView.isHidden = true
        }
    }

    private func updateLanguage(_ language: String?) {
        if let language = language {
            languageLabel.attributedText =  setupAttributedString(
                prefixStringValue: Strings.language,
                suffixStringValue: language)
        } else {
            languageLabel.isHidden = true
        }
    }

    private func updateGenre(_ genres: [String]?) {
        if let genres = genres,
            !genres.isEmpty {
            genresLabel.attributedText = setupAttributedString(
                prefixStringValue: Strings.genres,
                suffixStringValue: genres.joined(separator: ", "))
        } else {
            genresLabel.isHidden = true
        }
    }

    private func updateSchedule(_ schedule: ScheduleData?) {
        if let schedule = schedule,
            let time = schedule.time,
            let days = schedule.days?.joined(separator: ", "),
            !time.isEmpty || !days.isEmpty {
            scheduleLabel.attributedText = setupAttributedString(
                prefixStringValue: Strings.schedule,
                suffixStringValue: days + " " + time)
        } else {
            scheduleLabel.isHidden = true
        }
    }

    private func updateRating(_ rating: Double?) {
        if let rating = rating {
            ratingLabel.attributedText = setupAttributedString(
                prefixStringValue: Strings.rating,
                suffixStringValue: String(rating) + " / 10")
        } else {
            ratingLabel.isHidden = true
        }

    }

    private func updateStatus(_ status: String?) {
        if let status = status {
            statusLabel.attributedText = setupAttributedString(
                prefixStringValue: Strings.status,
                suffixStringValue: status)
        } else {
            statusLabel.isHidden = true
        }
    }

    private func updateOfficialSite(_ officialSite: String?) {
        if let officialSite = officialSite {
            self.officialSiteURL = officialSite
        } else {
            tvShowOfficialSiteButton.isHidden = true
        }
    }

    private func updateSummary(_ summary: String?) {
        if let summary = summary,
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
        containerStackView.spacing = Margins.x1.rawValue

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
        tvShowOfficialSiteButton.layer.cornerRadius = Margins.x1.rawValue
        tvShowOfficialSiteButton.contentEdgeInsets = UIEdgeInsets.init(
            top: 0,
            left: Margins.x2.rawValue,
            bottom: 0,
            right: Margins.x2.rawValue)
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
            make.top.equalToSuperview().offset(Margins.x2.rawValue)
            make.leading.trailing.equalToSuperview().inset(Margins.x2.rawValue)
            make.centerX.equalToSuperview()
        }

        containerStackView.snp.makeConstraints { (make) in
            make.top.equalTo(tvShowNameLabel.snp.bottom).offset(Margins.x2.rawValue)
            make.leading.trailing.equalToSuperview().inset(Margins.x2.rawValue)
            make.centerX.equalToSuperview()
        }

        tvShowImageView.snp.makeConstraints { (make) in
            make.height.equalTo(tvShowImageView.snp.width)
            make.leading.trailing.equalToSuperview()
        }

        tvShowDetailLabel.snp.makeConstraints { (make) in
            make.top.equalTo(containerStackView.snp.bottom).offset(Margins.x2.rawValue)
            make.leading.trailing.equalToSuperview().inset(Margins.x2.rawValue)
            make.centerX.equalToSuperview()
        }

        tvShowOfficialSiteButton.snp.makeConstraints { (make) in
            make.top.equalTo(tvShowDetailLabel.snp.bottom).offset(Margins.x1.rawValue)
            make.centerX.equalToSuperview()
            make.height.equalTo(estimatedButtonHeight)
            make.bottom.equalToSuperview().inset(Margins.x2.rawValue)
        }
    }
}
