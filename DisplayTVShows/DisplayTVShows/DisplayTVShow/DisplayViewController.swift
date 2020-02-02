import UIKit
import SVProgressHUD

private struct Strings {
    static let placeholder = NSLocalizedString(
        "Enter your favorite TV Shows",
        comment: "Text for searchbar textfield placeholder")

    static let cancel = NSLocalizedString(
        "Cancel", comment: "Button text for alert")
}

/*
 Displays list of tv shows searched by user
 */
class DisplayViewController: UITableViewController {
    var searchController = UISearchController(searchResultsController: nil)

    weak var delegate: DisplayServiceDelegate?

    var service = DisplayService()

    var tvShows: [DisplayTVShow] = []

    var activateSearch = false

    var searchedText: String?

    private let searchNoResultView = DisplayNoResultView()

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        service.delegate = self
        self.delegate = service

        setupView()
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.barTintColor = Colors.white.value
        navigationController?.navigationBar.tintColor = Colors.navBarTintColor.value
        navigationController?.isNavigationBarHidden = false
        if !activateSearch {
            searchController.searchBar.text = searchedText
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if activateSearch {
            activatedSearch()
            activateSearch = false
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        deactivateSearch()
        view.endEditing(true)
        searchController.searchBar.endEditing(true)
    }

    private func setupView() {
        setupSearchBar()
        searchNoResultView.isResultFound = true

        tableView.register(
            DisplayTVShowDetailsTableViewCell.self,
            forCellReuseIdentifier: DisplayTVShowDetailsTableViewCell.cellReuseIdentifier)
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = Colors.white.value
        tableView.backgroundView = searchNoResultView
        tableView.showsVerticalScrollIndicator = false
        tableView.bounces = false
    }

    func activatedSearch() {
        self.searchController.isActive = true
        DispatchQueue.main.async {
            self.searchController.searchBar.becomeFirstResponder()
        }
    }

    private func deactivateSearch() {
        searchController.searchBar.resignFirstResponder()
        view.endEditing(true)
        searchController.isActive = false
    }

    func setupSearchBar() {
        self.tableView.tableHeaderView = self.searchController.searchBar
        self.searchController.searchBar.delegate = self
        self.searchController.searchBar.placeholder = Strings.placeholder
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.keyboardType = .asciiCapable
        searchController.hidesNavigationBarDuringPresentation = false
    }

    override func tableView(
        _ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tvShows.count
    }

    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: DisplayTVShowDetailsTableViewCell.cellReuseIdentifier,
            for: indexPath) as? DisplayTVShowDetailsTableViewCell else {
                return UITableViewCell()
        }

        cell.update(appDetails: tvShows[indexPath.row])
        cell.backgroundColor = Colors.tableViewBackgroundColor.value
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        deactivateSearch()
        tableView.deselectRow(at: indexPath, animated: true)

        let controller = DisplayDetailedTVShowViewController(
            showDetails: tvShows[indexPath.row])
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension DisplayViewController: DisplayViewDelegate {
    func displayTVShowList() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.tableView.backgroundColor = Colors.tableViewBackgroundColor.value
            self.tableView.backgroundView = UIView()
            SVProgressHUD.dismiss()
        }
    }

    func displayError(errorMessage: String) {
        self.deactivateSearch()
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
            let alertController = UIAlertController(
                title: errorMessage, message: "", preferredStyle: .alert)
            let cancelAction = UIAlertAction(
                title: Strings.cancel, style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true)
            self.showNoResultFound()
        }
    }

    func showNoResultFound() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.searchNoResultView.isResultFound = false
            let noResultsImageView = self.searchNoResultView
            self.tableView.backgroundColor = Colors.white.value
            self.tableView.backgroundView = noResultsImageView
            SVProgressHUD.dismiss()
        }
    }
}

extension DisplayViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchedString = searchBar.text {
            SVProgressHUD.show()
            delegate?.getTVShowList(searchString: searchedString.removingWhitespaces)
        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(
            withTarget: self, selector: #selector(self.reload(_:)), object: searchBar)
        perform(#selector(self.reload(_:)), with: searchBar, afterDelay: 0.75)

    }

    @objc func reload(_ searchBar: UISearchBar) {
        if let searchedString = searchBar.text ,
            searchedString != "" {
            SVProgressHUD.show()
            searchedText = searchedString
            delegate?.getTVShowList(searchString: searchedString.removingWhitespaces)
        }
    }

    func searchBar(
        _ searchBar: UISearchBar,
        shouldChangeTextIn range: NSRange,
        replacementText text: String) -> Bool {
        if searchBar.searchTextField.isFirstResponder {
            let validString = CharacterSet(
                charactersIn: "!@#$%^&*()_+{}[]|\"<>,.~`/:;?-=\\¥'£•¢")
            if text.rangeOfCharacter(from: validString) != nil {
                return false
            }
        }
        return true
    }
}
