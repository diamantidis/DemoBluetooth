import UIKit

class BluetoothViewController: UIViewController {

    init(bluetoothManager: BluetoothManager) {
        self.bluetoothManager = bluetoothManager
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setup()
    }

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()

        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var textFieldContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "Device name", attributes: [.foregroundColor: UIColor.lightGray])

        textField.backgroundColor = .white
        textField.borderStyle = .roundedRect
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 8
        textField.textColor = .black
        textField.keyboardType = .default
        textField.returnKeyType = .done
        textField.clearButtonMode = .whileEditing
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private lazy var advertisingButtonContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private lazy var advertisingButton: UIButton = {
        let button = UIButton()
        button.setTitle("Start Advertising", for: .normal)
        button.backgroundColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(startAdvertising(sender:)), for: .touchUpInside)

        button.layer.cornerRadius = 8

        return button
    }()

    private lazy var scanningButtonContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private lazy var scanningButton: UIButton = {
        let button = UIButton()
        button.setTitle("Start Scanning", for: .normal)
        button.backgroundColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(startScanning(sender:)), for: .touchUpInside)

        button.layer.cornerRadius = 8

        return button
    }()

    private var bluetoothManager: BluetoothManager

    @objc private func startAdvertising(sender: UIButton!) {
        nameTextField.resignFirstResponder()
        guard let name = nameTextField.text?.trimmingCharacters(in: .whitespaces), !name.isEmpty else {
            let alert = UIAlertController(title: "Invalid name", message: "Device name should not be empty", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))

            self.present(alert, animated: true)
            return
        }

        bluetoothManager.startAdvertising(with: name)
    }

    @objc private func startScanning(sender: UIButton) {
        bluetoothManager.delegate = self
        bluetoothManager.startScanning()
    }


}

extension BluetoothViewController {
    private func setup() {
        setupViews()
        setupConstraints()
    }

    private func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)

        stackView.addArrangedSubview(textFieldContainer)
        stackView.setCustomSpacing(16, after: textFieldContainer)
        stackView.addArrangedSubview(advertisingButtonContainer)
        stackView.setCustomSpacing(16, after: advertisingButtonContainer)
        stackView.addArrangedSubview(scanningButtonContainer)

        textFieldContainer.addSubview(nameTextField)
        advertisingButtonContainer.addSubview(advertisingButton)
        scanningButtonContainer.addSubview(scanningButton)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor)
        ])

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 32),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])

        NSLayoutConstraint.activate([
            nameTextField.leadingAnchor.constraint(equalTo: textFieldContainer.leadingAnchor, constant: 32),
            nameTextField.trailingAnchor.constraint(equalTo: textFieldContainer.trailingAnchor, constant: -32),
            nameTextField.topAnchor.constraint(equalTo: textFieldContainer.topAnchor),
            nameTextField.bottomAnchor.constraint(equalTo: textFieldContainer.bottomAnchor)
        ])

        NSLayoutConstraint.activate([
            advertisingButton.leadingAnchor.constraint(equalTo: advertisingButtonContainer.leadingAnchor, constant: 32),
            advertisingButton.trailingAnchor.constraint(equalTo: advertisingButtonContainer.trailingAnchor, constant: -32),
            advertisingButton.topAnchor.constraint(equalTo: advertisingButtonContainer.topAnchor),
            advertisingButton.bottomAnchor.constraint(equalTo: advertisingButtonContainer.bottomAnchor)
        ])

        NSLayoutConstraint.activate([
            scanningButton.leadingAnchor.constraint(equalTo: scanningButtonContainer.leadingAnchor, constant: 32),
            scanningButton.trailingAnchor.constraint(equalTo: scanningButtonContainer.trailingAnchor, constant: -32),
            scanningButton.topAnchor.constraint(equalTo: scanningButtonContainer.topAnchor),
            scanningButton.bottomAnchor.constraint(equalTo: scanningButtonContainer.bottomAnchor)
        ])
    }
}

extension BluetoothViewController: BluetoothManagerDelegate {
    func peripheralsDidUpdate() {
        print(bluetoothManager.peripherals.mapValues{$0.name})
    }
}
