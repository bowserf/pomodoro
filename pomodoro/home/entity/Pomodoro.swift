import Foundation

class Pomodoro: NSObject, NSCoding {

    let id: String
    let name: String

    init(id: String, name: String) {
        self.id = id
        self.name = name
    }

    required init(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeObject(forKey: "id") as! String
        self.name = aDecoder.decodeObject(forKey: "name") as! String
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.id, forKey: "id")
        aCoder.encode(self.name, forKey: "name")
    }
}
