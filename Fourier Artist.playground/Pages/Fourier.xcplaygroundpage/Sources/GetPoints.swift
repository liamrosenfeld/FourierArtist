import Foundation

func points(from file: String) -> [Point] {
    var points = [Point]()
    var jsonString = ""
    
    if let url = Bundle.main.url(forResource: file, withExtension: "json") {
        do {
            jsonString = try String(contentsOfFile: url.path)
        } catch {
            fatalError("Empty Json File")
        }
    } else {
        fatalError("No JSON File at \(file)")
    }
    
    let jsonData = Data(jsonString.utf8)
    let decoder = JSONDecoder()
    do {
        points = try decoder.decode([Point].self, from: jsonData)
    } catch {
        print(error.localizedDescription)
    }
    
    return points
}

public func pointValues(from file: String) -> ([Double], [Double]) {
    let normPoints = points(from: file)
    
    var xValues = [Double]()
    var yValues = [Double]()
    
    for point in normPoints {
        xValues.append(point.x)
        yValues.append(point.y)
    }
    
    return (xValues, yValues)
}
