import UIKit
import PlaygroundSupport


// this line tells the Playground to execute indefinitely
PlaygroundPage.current.needsIndefiniteExecution = true

struct StudentLocation: Decodable, StudentLocationCreatable, StudentLocationUpdatable {
    let pinImageName = "icon_pin"
    //    let objectId: String
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Double
    let longitude: Double
    var objectId: String
    var createdAt: Date
    var updatedAt: Date
    //    let createdAt: Date
//        let updatedAt: Date/
    var fullName: String {
        return "\(firstName) \(lastName)"
    }
}

protocol StudentLocationCreatable: Decodable{
    var objectId: String { get }
    var createdAt: Date { get }
}

protocol StudentLocationUpdatable: Decodable{
    var updatedAt: Date { get }
}



struct StudentLocationResult: Decodable {
    let results: [StudentLocation]
}

extension DateFormatter {
    func iso8601() -> DateFormatter {
        calendar = Calendar(identifier: .iso8601)
        locale = Locale(identifier: "en_US_POSIX")
        timeZone = TimeZone(secondsFromGMT: 0)
        dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        return self
    }
}
/// List all student locations

//var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation?limit=100&order=-updatedAt")!)
//request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr",
//                 forHTTPHeaderField: "X-Parse-Application-Id")
//request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY",
//                 forHTTPHeaderField: "X-Parse-REST-API-Key")
//let session = URLSession.shared
//let task = session.dataTask(with: request) { data, response, error in
//    if error != nil { // Handle error...
//        return
//    }
////    print(String(data: data!, encoding: .utf8)!)
//
//    let decoder = JSONDecoder()
//    decoder.dateDecodingStrategy = .formatted(DateFormatter().iso8601())
//
//    let studentLocationDic = try? decoder.decode([String: [StudentLocation]].self, from: data!)
////    dump(studentLocationDic)
//    dump(studentLocationDic?["results"])
//}
//task.resume()



//var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation")!)
//request.httpMethod = "POST"
//request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//request.httpBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"Mountain View, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.386052, \"longitude\": -122.083851}".data(using: .utf8)
//let session = URLSession.shared
//let task = session.dataTask(with: request) { data, response, error in
//    if error != nil { // Handle error…
//        return
//    }
//    print(String(data: data!, encoding: .utf8)!)
//}
//task.resume()

//
// Error
//



//{"code":101,"error":"Object not found."}
//
//let urlString = "https://onthemap-api.udacity.com/v1/StudentLocation/ID48"
//let url = URL(string: urlString)
//var request = URLRequest(url: url!)
//request.httpMethod = "PUT"
//request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//request.httpBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"Cupertino, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.322998, \"longitude\": -122.032182}".data(using: .utf8)
//let session = URLSession.shared
//let task = session.dataTask(with: request) { data, response, error in
//    if error != nil { // Handle error…
//        return
//    }
//    print(String(data: data!, encoding: .utf8)!)
//}
//task.resume()


var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
request.httpMethod = "DELETE"
var xsrfCookie: HTTPCookie? = nil
let sharedCookieStorage = HTTPCookieStorage.shared
for cookie in sharedCookieStorage.cookies! {
    if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
}
if let xsrfCookie = xsrfCookie {
    request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
}
let session = URLSession.shared
let task = session.dataTask(with: request) { data, response, error in
    if error != nil { // Handle error…
        return
    }
    guard var data = data else { return }
    data.removeSubrange(0...4)

    print(String(data: data, encoding: .utf8)!)
}
task.resume()
