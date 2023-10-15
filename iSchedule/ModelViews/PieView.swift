import SwiftUI
/**
 A view that displays a pie chart based on the provided slices. Each slice in the pie chart represents a segment with a specific value and color.
 
 The chart scales automatically to fit its container, preserving its aspect ratio. The pie chart's visual breakdown is determined by the relative values of the provided slices.
 
 ## Usage:
 To use this view, you need to provide an array of slices. For example:
 ```swift
 PieView(slices: [(0.4, .red), (0.3, .blue), (0.3, .yellow)])
 ```

 ```swift
 struct PieSlice: View {
     let startAngle: Angle
     let endAngle: Angle
     let color: Color

     var body: some View {
         GeometryReader { geometry in
             Path { path in
                 let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
                 let radius = min(geometry.size.width, geometry.size.height) / 2
                 path.move(to: center)
                 path.addArc(center: center, radius: radius, startAngle: self.startAngle, endAngle: self.endAngle, clockwise: false)
             }
             .fill(self.color)
         }
     }
 }

 struct PieView: View {
     var slices: [(Double, Color)]
     
     var body: some View {
         ZStack {
             ForEach(0..<slices.count, id: \.self) { idx in
                 PieSlice(
                     startAngle: self.angle(for: self.startingValue(at: idx)),
                     endAngle: self.angle(for: self.startingValue(at: idx) + slices[idx].0),
                     color: slices[idx].1
                 )
             }
         }
         .aspectRatio(1, contentMode: .fit)
     }
 }
 ```
 ## Note:
 This component was referenced from  "Build Pie Charts in SwiftUI" by Nazar Ilamanov, published in Better Programming.
 */

//Reference: "Build Pie Charts in SwiftUI", Nazar Ilamanov, Published in Better Programming
struct PieSlice: View {
    let startAngle: Angle
    let endAngle: Angle
    let color: Color

    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
                let radius = min(geometry.size.width, geometry.size.height) / 2
                path.move(to: center)
                path.addArc(center: center, radius: radius, startAngle: self.startAngle, endAngle: self.endAngle, clockwise: false)
            }
            .fill(self.color)
        }
    }
}

struct PieView: View {
    var slices: [(Double, Color)]
    
    var body: some View {
        ZStack {
            ForEach(0..<slices.count, id: \.self) { idx in
                PieSlice(
                    startAngle: self.angle(for: self.startingValue(at: idx)),
                    endAngle: self.angle(for: self.startingValue(at: idx) + slices[idx].0),
                    color: slices[idx].1
                )
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
    
    private func angle(for value: Double) -> Angle {
        return .degrees(360 * value)
    }

    private func startingValue(at idx: Int) -> Double {
        slices[..<idx].reduce(0) { $0 + $1.0 }
    }
}



