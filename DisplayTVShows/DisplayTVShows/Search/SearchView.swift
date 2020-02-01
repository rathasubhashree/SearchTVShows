import UIKit

private struct Strings {
    static let placeholderText = NSLocalizedString(
        "Enter your favorite TV Shows",
        comment: "Text for Search TextField placeholder")
}

protocol SearchViewDelegate: class {
    func searchButtonTapped()
}
class SearchView: UIView {
    private let searchTextField = UITextField()
    private let searchImageView = UIImageView(image: #imageLiteral(resourceName: "icons8-search-20"))

    weak var delegate: SearchViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        addSubview(searchTextField)
        searchTextField.returnKeyType = .search
        searchTextField.backgroundColor = Colors.white.value
        searchTextField.textAlignment = .left
        searchTextField.placeholder = Strings.placeholderText
        searchTextField.delegate = self
        searchTextField.layer.borderWidth = 1
        searchTextField.layer.borderColor = UIColor.purple.cgColor
        searchTextField.layer.cornerRadius = 10
        searchImageView.contentMode = .right
        searchTextField.leftView = searchImageView
        searchTextField.leftViewMode = .always
    }

    private func setupConstraints() {
        searchTextField.snp.makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(40)
        }
    }

    @objc private func didTapSearch() {
        delegate?.searchButtonTapped()
    }
}

extension SearchView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.searchButtonTapped()
    }
}
