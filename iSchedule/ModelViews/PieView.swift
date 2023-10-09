import SwiftUI
//Reference: "Build Pie Charts in SwiftUI", Nazar Ilamanov, Published in Better Programming
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

