import SwiftUI
/**
 A view that presents a tab bar interface with animated icon movement based on user selection.

 The tab bar displays a set of icons that the user can tap to switch between different views or sections of the app. The currently selected tab's icon animates upward slightly and changes color for differentiation.

 ##Usage:
 ```swift
 CustomTabBar(selectedTab: $currentTab, xAxis: $currentXAxis, animation: namespace)
```
 
```swift
 var body: some View {
     VStack(alignment: .center) {
         HStack {
             ForEach(tabs, id: \.self) { image in
                 GeometryReader { reader in
                     Button {
                         withAnimation(Animation.interactiveSpring(dampingFraction: 2)) {
                             selectedTab = image
                             xAxis = reader.frame(in: .global).midX
                         }
                     } label: {
                         Image(systemName: image)
                             .resizable()
                             .renderingMode(.template)
                             .aspectRatio(contentMode: .fit)
                             .foregroundColor(image == selectedTab ? getIconColor(image: image) : Color.black)
                             .matchedGeometryEffect(id: image, in: animation)
                             .offset(x: 0 , y: selectedTab == image ? -20 : 0)
                             .foregroundStyle(.blue)
                     }
                     .onAppear {
                         if image == tabs.first {
                             xAxis = reader.frame(in: .global).midX
                         }
                     }
                 }
                 .frame(width: 40, height: 40)

                 if image != tabs.last {
                     Spacer(minLength: 0)
                 }
             }
         }
         .padding(.horizontal, 50)
         .padding(.vertical, 30)
         .background(Color.white.cornerRadius(25).shadow(radius: 5))
     }
     .frame(maxWidth: .infinity)
     .background(Color.white.clipShape(CustomTabBarShape(xAxis: xAxis)))
 }
 ```
 
 ## Notes:
 - This implementation was referenced from 'https://github.com/Mobile-Apps-Academy/TabBarSwiftUI/blob/main/TabBar.swift'
 - The CustomTabBarShape is responsible for creating the visual effect where the selected tab appears to "rise" from the tab bar.
 - Customize the getIconColor(image:) function to define unique colors for other icons.
 - Ensure the necessary namespace is provided for the matchedGeometryEffect to work.
 */
struct CustomTabBar: View {
    @Binding var selectedTab: String
    @Binding var xAxis: CGFloat
    var animation: Namespace.ID

    var tabs = ["house.fill", "chart.bar.fill"]

    var body: some View {
        VStack(alignment: .center) {
            HStack {
                ForEach(tabs, id: \.self) { image in
                    GeometryReader { reader in
                        Button {
                            withAnimation(Animation.interactiveSpring(dampingFraction: 2)) {
                                selectedTab = image
                                xAxis = reader.frame(in: .global).midX
                            }
                        } label: {
                            Image(systemName: image)
                                .resizable()
                                .renderingMode(.template)
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(image == selectedTab ? getIconColor(image: image) : Color.black)
                                .matchedGeometryEffect(id: image, in: animation)
                                .offset(x: 0 , y: selectedTab == image ? -20 : 0)
                                .foregroundStyle(.blue)
                        }
                        .onAppear {
                            if image == tabs.first {
                                xAxis = reader.frame(in: .global).midX
                            }
                        }
                    }
                    .frame(width: 40, height: 40)

                    if image != tabs.last {
                        Spacer(minLength: 0)
                    }
                }
            }
            .padding(.horizontal, 50)
            .padding(.vertical, 30)
            .background(Color.white.cornerRadius(25).shadow(radius: 5))
        }
        .frame(maxWidth: .infinity)
        .background(Color.white.clipShape(CustomTabBarShape(xAxis: xAxis)))
    }

    func getIconColor(image: String) -> Color {
        switch image {
        case "house.fill":
            return Color.red
        case "chart.bar.fill":
            return Color.cyan
        default:
            return Color.black
        }
    }
}

//Reference from https://github.com/Mobile-Apps-Academy/TabBarSwiftUI/blob/main/TabBar.swift
struct CustomTabBarShape: Shape {
    var xAxis: CGFloat
    var curveHeight: CGFloat = 20
    var curveWidth: CGFloat = 60

    func path(in rect: CGRect) -> Path {
        return Path { path in
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: xAxis - curveWidth, y: 0))
            path.addQuadCurve(to: CGPoint(x: xAxis + curveWidth, y: 0), control: CGPoint(x: xAxis, y: -curveHeight))
            path.addLine(to: CGPoint(x: rect.width, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
        }
    }
}
