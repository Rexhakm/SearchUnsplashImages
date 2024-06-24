import UIKit
import Combine

class ImagesViewController: UITableViewController {
    
    private var viewModel: ImagesViewModel
    private var subscriptions = Set<AnyCancellable>()
    
    let loadingView = UIActivityIndicatorView(style: .large)
    
    let textField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Find your favorite image"
        tf.borderStyle = .roundedRect
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.layer.cornerRadius = 8
        tf.layer.masksToBounds = true
        tf.layer.shadowColor = UIColor.black.cgColor
        tf.layer.shadowOpacity = 0.5
        tf.layer.shadowOffset = CGSize(width: 0, height: 2)
        tf.layer.shadowRadius = 4
        tf.layer.masksToBounds = false
        return tf
    }()
    
    let searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Search", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(ImagesViewController.self, action: #selector(searchImages), for: .touchUpInside)
        return button
    }()
    
    init(service: APIServiceProtocol) {
        self.viewModel = ImagesViewModel(service: service)
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        registerCell()
        bindViewModel()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        subscriptions.forEach { $0.cancel() }
    }
    
    @objc private func searchImages(){
        guard let query = textField.text, !query.isEmpty else { return }
        viewModel.getImagesByQuery(query: query)
    }
    
    private func bindViewModel() {
        viewModel.$images
            .receive(on: DispatchQueue.main)
            .sink { [weak self] images in
                self?.tableView.reloadData()
            }
            .store(in: &subscriptions)
        
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                isLoading ? self?.startLoading() : self?.stopLoading()
            }
            .store(in: &subscriptions)
        
        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                if let message = errorMessage {
                    self?.showErrorDialog(message: message)
                }
            }
            .store(in: &subscriptions)
    }
    
    private func showErrorDialog(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    private func registerCell() {
        tableView.register(ImageTableViewCell.self, forCellReuseIdentifier: "ImageTableViewCell")
    }
    
    func startLoading() {
        loadingView.startAnimating()
        self.tableView.isUserInteractionEnabled = false
    }
    
    func stopLoading() {
        loadingView.stopAnimating()
        self.tableView.isUserInteractionEnabled = true
    }
    
    private func setupLayout() {
        let headerView = UIView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        headerView.addSubview(textField)
        headerView.addSubview(searchButton)
        
        loadingView.hidesWhenStopped = true
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        tableView.addSubview(loadingView)
        
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            textField.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 10),
            textField.trailingAnchor.constraint(equalTo: searchButton.leadingAnchor, constant: -10),
            
            searchButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -40),
            searchButton.centerYAnchor.constraint(equalTo: textField.centerYAnchor),
            searchButton.widthAnchor.constraint(equalToConstant: 80),
            
            loadingView.heightAnchor.constraint(equalToConstant: 60),
            loadingView.widthAnchor.constraint(equalToConstant: 60),
            loadingView.centerYAnchor.constraint(equalTo: tableView.centerYAnchor),
            loadingView.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            
            headerView.bottomAnchor.constraint(equalTo: textField.bottomAnchor, constant: 20),
        ])
        
        loadingView.backgroundColor = .lightGray
        
        tableView.tableHeaderView = headerView
        headerView.setNeedsLayout()
        headerView.layoutIfNeeded()
    }
}

extension ImagesViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.images.count == 0 {
            self.tableView.setEmptyMessage("No Data Available")
        } else {
            self.tableView.restore()
        }
        return viewModel.images.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImageTableViewCell", for: indexPath) as! ImageTableViewCell
        let image = viewModel.images[indexPath.item]
        cell.configure(cell: image)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        textField.resignFirstResponder()
        let image = viewModel.images[indexPath.item]
        let detailVC = ImageDetailsViewController()
        detailVC.configure(with: image)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
