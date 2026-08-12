import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0

    var body: some View {
        ZStack(alignment: .bottom) {
            // Fondo negro base
            Color(hex: "050508").ignoresSafeArea()

            // Ambient glows — familia azul-índigo
            GeometryReader { geo in
                // Blob primario — azul royal arriba-derecha
                Circle()
                    .fill(BraverTheme.ambientCore.opacity(0.55))
                    .frame(width: 520, height: 520)
                    .offset(x: geo.size.width - 120, y: -200)
                    .blur(radius: 100)
                    .allowsHitTesting(false)

                // Blob secundario — Ellipse orgánica centro-izquierda
                Ellipse()
                    .fill(BraverTheme.ambientMid.opacity(0.32))
                    .frame(width: 400, height: 480)
                    .offset(x: -150, y: geo.size.height * 0.28)
                    .blur(radius: 110)
                    .allowsHitTesting(false)

                // Blob índigo — abajo sutil
                Circle()
                    .fill(BraverTheme.ambientDeep.opacity(0.22))
                    .frame(width: 300, height: 300)
                    .offset(x: geo.size.width * 0.3, y: geo.size.height * 0.65)
                    .blur(radius: 80)
                    .allowsHitTesting(false)
            }
            .ignoresSafeArea()

            // Degradado en la parte baja
            VStack {
                Spacer()
                LinearGradient(
                    colors: [
                        Color.clear,
                        BraverTheme.ambientCore.opacity(0.35),
                        BraverTheme.background.opacity(0.85)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 280)
                .allowsHitTesting(false)
            }
            .ignoresSafeArea()

            // Contenido de la tab seleccionada
            Group {
                switch selectedTab {
                case 0: HoyView()
                case 1: RetosView()
                case 2: MomentoView()
                case 3: GuiaView()
                default: ProgresoView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            // Custom floating tab bar
            FloatingTabBar(selectedTab: $selectedTab)
        }
    }
}

// MARK: - Floating Tab Bar

struct FloatingTabBar: View {
    @Binding var selectedTab: Int

    private let items: [(icon: String, label: String, tag: Int)] = [
        ("house.fill", "Hoy", 0),
        ("list.star", "Retos", 1),
        ("bolt.fill", "Braver", 2),
        ("book.fill", "Guía", 3),
        ("chart.line.uptrend.xyaxis", "Progreso", 4)
    ]

    var body: some View {
        HStack(spacing: 0) {
            ForEach(items, id: \.tag) { item in
                FloatingTabItem(
                    icon: item.icon,
                    label: item.label,
                    tag: item.tag,
                    selectedTab: $selectedTab,
                    isBraver: item.tag == 2
                )
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(
            ZStack {
                Color(hex: "080A12").opacity(0.94)
                BraverTheme.ambientCore.opacity(0.12)
            }
        )
        .overlay(alignment: .top) {
            LinearGradient(
                colors: [BraverTheme.accent.opacity(0.18), Color.clear],
                startPoint: .leading,
                endPoint: .trailing
            )
            .frame(height: 1)
        }
        .cornerRadius(28)
        .overlay(
            RoundedRectangle(cornerRadius: 28)
                .stroke(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.14),
                            Color.white.opacity(0.04),
                            Color.white.opacity(0.10)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
        .shadow(color: Color.black.opacity(0.45), radius: 24, x: 0, y: -4)
        .padding(.horizontal, 16)
        .padding(.bottom, 24)
    }
}

struct FloatingTabItem: View {
    let icon: String
    let label: String
    let tag: Int
    @Binding var selectedTab: Int
    let isBraver: Bool

    var isSelected: Bool { selectedTab == tag }
    var accentColor: Color { BraverTheme.accent }

    var body: some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                selectedTab = tag
            }
        } label: {
            VStack(spacing: 4) {
                if isBraver {
                    ZStack {
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [BraverTheme.bravura, BraverTheme.bravuraDeep],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 52, height: 32)
                            .shadow(color: BraverTheme.bravura.opacity(0.40), radius: 8, x: 0, y: 2)

                        Image(systemName: icon)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                    }
                    Text(label)
                        .font(.system(size: 10, weight: .semibold, design: .rounded))
                        .foregroundColor(isSelected ? BraverTheme.bravura : BraverTheme.textTertiary)
                } else {
                    ZStack {
                        if isSelected {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(accentColor.opacity(0.15))
                                .frame(width: 40, height: 28)
                        }
                        Image(systemName: icon)
                            .font(.system(size: 16, weight: isSelected ? .semibold : .regular))
                            .foregroundColor(isSelected ? accentColor : BraverTheme.textTertiary)
                    }
                    .frame(height: 32)

                    Text(label)
                        .font(.system(size: 10, weight: isSelected ? .semibold : .regular, design: .rounded))
                        .foregroundColor(isSelected ? accentColor : BraverTheme.textTertiary)
                }
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isSelected && !isBraver ? 1.08 : 1.0)
        .animation(.spring(response: 0.25, dampingFraction: 0.65), value: isSelected)
    }
}

#Preview {
    ContentView()
}
