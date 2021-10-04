import Foundation

extension Int {
  /// Format adjusts based on the number of length: X / XX / XXX / X,XXXX / XX.Xk / XXX.xk / X.XM.
  /// Orignal source: https://gist.github.com/gbitaudeau/daa4d6dc46517b450965e9c7e13706a3
  func abbreviate() -> String {
    typealias Abbrevation = (threshold: Double, divisor: Double, suffix: String)
    
    let abbreviations: [Abbrevation] = [
      (0, 1, ""),
      (10_000.0, 1_000.0, "K"),
      (100_000.0, 1_000_000.0, "M"),
      (100_000_000.0, 1_000_000_000.0, "B"),
      (100_000_000_000.0, 1_000_000_000_000.0, "T")
    ]
    
    let startValue = Double (abs(self))
    
    let abbreviation: Abbrevation = {
      var prevAbbreviation = abbreviations[0]
      
      for tmpAbbreviation in abbreviations {
        if (startValue < tmpAbbreviation.threshold) {
          break
        }
        
        prevAbbreviation = tmpAbbreviation
      }
      
      return prevAbbreviation
    }()
    
    let formatter = NumberFormatter()
    formatter.positiveSuffix = abbreviation.suffix
    formatter.negativeSuffix = abbreviation.suffix
    formatter.allowsFloats = true
    formatter.minimumIntegerDigits = 1
    formatter.minimumFractionDigits = 0
    formatter.maximumFractionDigits = 1
    
    let value = Double(self) / abbreviation.divisor
    
    if value >= 1_000 && value < 10_000 {
      formatter.numberStyle = .decimal
    }
    
    return formatter.string(from: NSNumber(value: value))!
  }
}

let testValues: [Int] = [
  -999,
   -1_284,
   598,
   1_000,
   9_940,
   9_980,
   10_500,
   39_900,
   99_880,
   399_880,
   999_898,
   999_999,
   1_456_384,
   12_383_474
]

testValues.forEach() {
  print("Value : \($0) -> \($0.abbreviate())")
}
