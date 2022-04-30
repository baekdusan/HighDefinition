import Foundation
import UIKit
import Photos
import NVActivityIndicatorView

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        PHPhotoLibrary.requestAuthorization( { status in })
    }
    
    @IBAction func uploadPhoto(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.modalPresentationStyle = .fullScreen
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
//        imagePicker.allowsEditing = true

        present(imagePicker, animated: true)
    }
    @IBAction func highDefinitionTransition(_ sender: UIButton) {
        let loadingView = NVActivityIndicatorView(frame: CGRect(x: view.frame.width / 2 - 60, y: view.frame.height / 2 - 60, width: 120, height: 120))
        loadingView.type = .ballRotate
        loadingView.color = .systemIndigo
        view.addSubview(loadingView)
        
        loadingView.startAnimating()
        view.isUserInteractionEnabled = false
        imageView.alpha = 0.4
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
            loadingView.stopAnimating()
            self.view.isUserInteractionEnabled = true
            self.imageView.alpha = 1
        })
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var newImage: UIImage? = nil // update 할 이미지
        
        if let possibleImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            newImage = possibleImage // 수정된 이미지가 있을 경우
        } else if let possibleImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            newImage = possibleImage // 원본 이미지가 있을 경우
        }
        
        self.imageView.image = newImage // 받아온 이미지를 update
        picker.dismiss(animated: true, completion: nil) // picker를 닫아줌
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
