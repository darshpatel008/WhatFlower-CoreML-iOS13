//
//
//import Foundation
//
//
//struct WikipediaManager
//{
//    let url = "https://www.mediawiki.org/w/api.php?format=json&action=query&prop=extracts&exintro=&explaintext=&titles"
//    
//    func flowername(name: String)
//    {
//        let urlString = "\(url)"+"=\(name)&indexpageids&redirects=1"
//        perform(for: urlString)
//    }
//    
//    func perform(for urlString: String)
//    {
//       if let url = URL(string: urlString)
//        {
//            let urlsession = URLSession(configuration: .default)
//            
//           let task = urlsession.dataTask(with: url){ (data,response,error) in
//               
//               if error != nil
//               {
//                   
//               }
//               
//               if let safeData = data
//               {
//                  parseJSON(encodedData: safeData)
//               }
//           }
//           task.resume()
//        }
//    }
//    
//    
//    func parseJSON(encodedData: Data)
//    {
//        let decoder = JSONDecoder()
//        
//        let decodedData = try decoder.decode( , from: encodedData)
//        
//        
//    }
//}
