//
//  AddEditWEmojiViewController.swift
//  mindfulness
//
//  Created by Andrew Higbee on 4/29/24.
//

import UIKit

class AddEditWEmojiViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var bodyTextView: UITextView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    let imagePicker = UIImagePickerController()
    
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
            
            title = "Edit Post"
        } else {
            
            title = "Add Post"
        }
        if let emoji {
            titleTextField.text = "\(emoji) "
        }
        titleTextField!.layer.borderWidth = 1
        bodyTextView!.layer.borderWidth = 1
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "saveUnwind" else { return }
        
        guard let titleTextField = titleTextField.text, let bodyTextView = bodyTextView.text else { return }
        
        if let journalEntry = self.journalEntry {
            EntryManager.shared.updateEntry(journalEntry, title: titleTextField, body: bodyTextView)
        } else {
            if let photo = self.photo {
                let pngImageData  = photo.pngData()
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
//        imagePickerController(imagePicker, didFinishPickingMediaWithInfo: [:])
        
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
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        let image = info[UIImagePickerController.InfoKey.originalImage.rawValue] as! UIImage
//        //create and NSTextAttachment and add your image to it.
//        let attachment = NSTextAttachment()
//        attachment.image = image
//        //calculate new size.  (-20 because I want to have a litle space on the right of picture)
//        let newImageWidth = (bodyTextView.bounds.size.width - 20 )
//        let scale = newImageWidth/image.size.width
//        let newImageHeight = image.size.height * scale
//        //resize this
//        attachment.bounds = CGRect.init(x: 0, y: 0, width: newImageWidth, height: newImageHeight)
//        //put your NSTextAttachment into and attributedString
//        let attString = NSAttributedString(attachment: attachment)
//        //add this attributed string to the current position.
//        bodyTextView.textStorage.insert(attString, at: bodyTextView.selectedRange.location)
//        picker.dismiss(animated: true, completion: nil)
//    }
}
