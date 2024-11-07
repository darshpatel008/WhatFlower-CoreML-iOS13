import UIKit
import CoreML
import Vision
import Social
import Alamofire
import SwiftyJSON
import SDWebImage

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let wikipediaURl = "https://en.wikipedia.org/w/api.php"
    
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let userSelectedImage = info[.originalImage] as? UIImage {
            guard let ciImage = CIImage(image: userSelectedImage) else {
                fatalError("Error in ciimage")
            }
            detect(flowerImage: ciImage)
        }
        imagePicker.dismiss(animated: true)
    }
    
    func detect(flowerImage: CIImage) {
        
        let config = MLModelConfiguration()
        guard let coremodel = try?
                FlowerClassifier(configuration: config).model else {
            fatalError("Error in coremodel")
        }
        
        guard let model = try? VNCoreMLModel(for: coremodel) else {
            fatalError("Error in model")
        }
        
        let request = VNCoreMLRequest(model: model) { request, error in
            guard let initialresult = request.results?.first as? VNClassificationObservation else {
                fatalError("error in result")
            }
            print(request.results)
            print(initialresult.identifier)
            self.navigationItem.title = initialresult.identifier.capitalized
            self.requestinfo(flowerName: initialresult.identifier.capitalized)
        }
        
        let handler = VNImageRequestHandler(ciImage: flowerImage)
        
        do 
        {
            try handler.perform([request])
        } 
        catch
        {
            print("Error in image request")
        }
    }
    
    func requestinfo(flowerName: String) {
        let parameters: [String: String] = [
            "format": "json",
            "action": "query",
            "prop": "extracts|pageimages",
            "exintro": "",
            "explaintext": "",
            "titles": flowerName,
            "pithumbsize": "500",
            "indexpageids": "",
            "redirects": "1",
        ]

        AF.request(wikipediaURl, method: .get, parameters: parameters).responseData { response in
            if let data = response.data, response.error == nil {
                print("Got wikipedia info")
                
                let flowerJSON: JSON = JSON(data)
                let pageid = flowerJSON["query"]["pageids"][0].stringValue
                let flowerDescription = flowerJSON["query"]["pages"][pageid]["extract"].stringValue
                let flowerImageURL = flowerJSON["query"]["pages"][pageid]["thumbnail"]["source"].stringValue
                
                self.imageView.sd_setImage(with: URL(string: flowerImageURL))
                self.label.text = flowerDescription
            } else {
                print("Error in getting Wikipedia info: \(String(describing: response.error))")
            }
        }
    }

    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true)
    }
}

