import UIKit

class AddEditWEmojiViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    let gradientLayer = CAGradientLayer()
    
    var emoji: String?
    var journalEntry: JournalEntry?
    var photo: UIImage?
    
    init?(coder: NSCoder, journalEntry: JournalEntry?) {
        super.init(coder: coder)
        self.journalEntry = journalEntry
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true

        if let journalEntry = self.journalEntry {
            titleTextField.text = journalEntry.title
            bodyTextView.text = journalEntry.body
            if let photo = journalEntry.photo {
                imageView.image = UIImage(data: journalEntry.photo!)
            }
            title = "Edit Entry"
        } else {
            title = "Add Entry"
        }

        if let emoji = emoji {
            titleTextField.text = "\(emoji) "
        }
        titleTextField.layer.borderWidth = 1
        bodyTextView.layer.borderWidth = 1
        
        self.hideKeyboardWhenTappedAround()
        
        setupGradientBackground()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "saveUnwind" else { return }
        guard let titleTextField = titleTextField.text, let bodyTextView = bodyTextView.text else { return }
        
        if let journalEntry = self.journalEntry {
            if let photo = self.photo {
                let pngImageData = photo.pngData()
                EntryManager.shared.updateEntry(journalEntry, title: titleTextField, body: bodyTextView, photo: pngImageData)
            } else {
                EntryManager.shared.updateEntry(journalEntry, title: titleTextField, body: bodyTextView, photo: nil)
            }
        } else {
            if let photo = self.photo {
                let pngImageData = photo.pngData()
                EntryManager.shared.createNewEntryWPhoto(title: titleTextField, body: bodyTextView, photo: pngImageData!)
            } else {
                EntryManager.shared.createNewEntry(title: titleTextField, body: bodyTextView)
            }
        }
    }
    
    @IBAction func cancelTapped(_ sender: UIBarButtonItem) {
        navigationController?.dismiss(animated: true)
    }

    @IBAction func smileyTapped(_ sender: UIButton) {
        titleTextField.text = titleTextField.text! + "😀 "
    }
    
    @IBAction func concernedTapped(_ sender: UIButton) {
        titleTextField.text = titleTextField.text! + "🫤 "
    }

    @IBAction func neutralTapped(_ sender: UIButton) {
        titleTextField.text = titleTextField.text! + "😐 "
    }

    @IBAction func sleepyTapped(_ sender: UIButton) {
        titleTextField.text = titleTextField.text! + "😴 "
    }

    @IBAction func angryTapped(_ sender: UIButton) {
        titleTextField.text = titleTextField.text! + "🤬 "
    }

    @IBAction func sadTapped(_ sender: UIButton) {
        titleTextField.text = titleTextField.text! + "☹️ "
    }

    @IBAction func surprisedTapped(_ sender: UIButton) {
        titleTextField.text = titleTextField.text! + "😯 "
    }

    @IBAction func cameraButtonTapped(_ sender: UIButton) {
        present(imagePicker, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            imageView.image = image
            photo = image
        }
        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func setupGradientBackground() {
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            UIColor(hex: "#8F549D")?.cgColor,
            UIColor(hex: "983765")?.cgColor,
            UIColor(hex: "#8D331F")?.cgColor,
        ].compactMap { $0 }
        gradientLayer.locations = [0.0, 0.8, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
}
