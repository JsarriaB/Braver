import SwiftUI
import UIKit

struct ContentView: View {
    @State private var selectedTab = 0

    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(Color(hex: "050507"))
        appearance.shadowColor = .clear

        // Unselected
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(Color(hex: "3D5068"))
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor(Color(hex: "3D5068")),
            .font: UIFont.systemFont(ofSize: 10, weight: .medium)
        ]

        // Selected
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(BraverTheme.accent)
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(BraverTheme.accent),
            .font: UIFont.systemFont(ofSize: 10, weight: .semibold)
        ]

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some View {
        ZStack {
            // Fondo negro base
            Color(hex: "050507").ignoresSafeArea()

            // Ambient glows
            GeometryReader { geo in
                // Blob teal arriba-derecha — el más grande y visible
                Circle()
                    .fill(Color(hex: "0E9090").opacity(0.45))
                    .frame(width: 560, height: 560)
                    .offset(x: geo.size.width - 140, y: -180)
                    .blur(radius: 80)
                    .allowsHitTesting(false)

                // Blob teal centro-izquierda
                Circle()
                    .fill(Color(hex: "0B7A8A").opacity(0.35))
                    .frame(width: 460, height: 460)
                    .offset(x: -130, y: geo.size.height * 0.36)
                    .blur(radius: 90)
                    .allowsHitTesting(false)

                // Blob teal abajo-centro
                Circle()
                    .fill(Color(hex: "14B8A6").opacity(0.28))
                    .frame(width: 340, height: 340)
                    .offset(x: geo.size.width * 0.25, y: geo.size.height * 0.68)
                    .blur(radius: 70)
                    .allowsHitTesting(false)
            }
            .ignoresSafeArea()

            // Degradado teal en la parte baja
            VStack {
                Spacer()
                LinearGradient(
                    colors: [
                        Color.clear,
                        Color(hex: "0D6060").opacity(0.5),
                        Color(hex: "0A4A4A").opacity(0.7)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 320)
                .allowsHitTesting(false)
            }
            .ignoresSafeArea()

            TabView(selection: $selectedTab) {

                HoyView()
                    .tabItem {
                        Label("Hoy", systemImage: selectedTab == 0 ? "house.fill" : "house")
                    }
                    .tag(0)

                RetosView()
                    .tabItem {
                        Label("Retos", systemImage: selectedTab == 1 ? "list.star" : "list.bullet")
                    }
                    .tag(1)

                MomentoView()
                    .tabItem {
                        Label("Braver", systemImage: "bolt.fill")
                    }
                    .tag(2)

                ProgresoView()
                    .tabItem {
                        Label("Progreso", systemImage: selectedTab == 3 ? "chart.line.uptrend.xyaxis" : "chart.line.uptrend.xyaxis")
                    }
                    .tag(3)
            }
            .tint(selectedTab == 2 ? BraverTheme.bravura : BraverTheme.accent)
        }
    }
}

#Preview {
    ContentView()
}
