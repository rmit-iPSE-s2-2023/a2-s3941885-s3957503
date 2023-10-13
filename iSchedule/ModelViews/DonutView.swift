import SwiftUI
/**
 A view that visually represents a donut (or pie) chart. Each slice of the donut is represented by a tuple containing a value and a color. The view dynamically generates the donut slices based on the provided data.
 
 ## Usage:
 To use this view, initialize it with the slices array. For instance:
 ```swift
 DonutView(slices: [(0.25, Color.red), (0.5, Color.green), (0.25, Color.blue)])
```
 
 The primary use case of this view is to visually display proportional data, where each segment represents a portion of the whole. In this case: the amount of tasks is in a list of the database and how they are distributed.

 ## Features:
 - Accepts an array of slices where each slice contains a value and a color.
 - Adjusts the size of each slice based on the value it represents.
 - Displays a gap between slices when a specific condition is met (e.g., for "inProgress" tasks).

 ```swift
 struct DonutView: View {
     var slices: [(Double, Color)]
     var body: some View {
         Canvas { context, size in
             let donut = Path { p in
                 p.addEllipse(in: CGRect(origin: .zero, size: size))
                 p.addEllipse(in: CGRect(x: size.width * 0.25, y: size.height * 0.25, width: size.width * 0.5, height: size.height * 0.5))
             }
             context.clip(to: donut, style: .init(eoFill: true))
             
             let total = slices.reduce(0) { $0 + $1.0 }
             context.translateBy(x: size.width * 0.5, y: size.height * 0.5)
             var pieContext = context
             pieContext.rotate(by: .degrees(-90))
             let radius = min(size.width, size.height) * 0.48
             
             // Check for inProgress tasks and adjust gapSize accordingly
             let inProgressValue = slices.first(where: { _, color in color == Color.blue })?.0 ?? 0
             let gapSize = inProgressValue == 0 ? Angle(degrees: 0) : Angle(degrees: 0)
             
             var startAngle = Angle.zero
             for (value, color) in slices {
                 let angle = Angle(degrees: 360 * (value / total))
                 let endAngle = startAngle + angle - gapSize / 2
                 let path = Path { p in
                     p.move(to: .zero)
                     p.addArc(center: .zero, radius: radius, startAngle: startAngle + gapSize / 2, endAngle: endAngle, clockwise: false)
                     p.closeSubpath()
                 }
                 pieContext.fill(path, with: .color(color))
                 startAngle = endAngle + gapSize
             }
         }
         .aspectRatio(1, contentMode: .fit)
     }
 }
 ```
 ## Note:
 This was referenced from "Build Pie Charts in SwiftUI", Nazar Ilamanov, Published in Better Programming. The implementation of this view relies on the SwiftUI Canvas to draw the slices, which provides more flexibility compared to using basic shapes. Furthermore, the logic to compute the starting and ending angles of each slice ensures that the slices are proportionally sized based on their values.
 */

struct DonutView: View {
    var slices: [(Double, Color)]
    var body: some View {
        //Reference: "Build Pie Charts in SwiftUI", Nazar Ilamanov, Published in Better Programming
        Canvas { context, size in
            let donut = Path { p in
                p.addEllipse(in: CGRect(origin: .zero, size: size))
                p.addEllipse(in: CGRect(x: size.width * 0.25, y: size.height * 0.25, width: size.width * 0.5, height: size.height * 0.5))
            }
            context.clip(to: donut, style: .init(eoFill: true))
            
            let total = slices.reduce(0) { $0 + $1.0 }
            context.translateBy(x: size.width * 0.5, y: size.height * 0.5)
            var pieContext = context
            pieContext.rotate(by: .degrees(-90))
            let radius = min(size.width, size.height) * 0.48
            
            // Check for inProgress tasks and adjust gapSize accordingly
            let inProgressValue = slices.first(where: { _, color in color == Color.blue })?.0 ?? 0
            let gapSize = inProgressValue == 0 ? Angle(degrees: 0) : Angle(degrees: 0)
            
            var startAngle = Angle.zero
            for (value, color) in slices {
                let angle = Angle(degrees: 360 * (value / total))
                let endAngle = startAngle + angle - gapSize / 2
                let path = Path { p in
                    p.move(to: .zero)
                    p.addArc(center: .zero, radius: radius, startAngle: startAngle + gapSize / 2, endAngle: endAngle, clockwise: false)
                    p.closeSubpath()
                }
                pieContext.fill(path, with: .color(color))
                startAngle = endAngle + gapSize
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

