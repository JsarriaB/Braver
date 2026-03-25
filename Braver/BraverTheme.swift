import SwiftUI

// MARK: - Design System

enum BraverTheme {

    // MARK: Colors
    static let background       = Color(hex: "050507")
    static let surface          = Color(hex: "0E0F14")
    static let surfaceElevated  = Color(hex: "161820")
    static let surfaceBorder    = Color.white.opacity(0.07)

    static let accent           = Color(hex: "4C9EEB")   // azul – calma
    static let bravura          = Color(hex: "F97316")   // naranja – valor/acción
    static let success          = Color(hex: "10B981")   // verde
    static let warning          = Color(hex: "F59E0B")   // ámbar
    static let danger           = Color(hex: "EF4444")   // rojo

    static let textPrimary      = Color(hex: "F1F5F9")
    static let textSecondary    = Color(hex: "94A3B8")
    static let textTertiary     = Color(hex: "3D5068")

    // MARK: Spacing
    static let screenPadding: CGFloat  = 24
    static let cardPadding: CGFloat    = 20
    static let itemSpacing: CGFloat    = 12
    static let sectionSpacing: CGFloat = 28

    // MARK: Radius
    static let radiusSmall: CGFloat  = 10
    static let radiusMedium: CGFloat = 16
    static let radiusLarge: CGFloat  = 24
    static let radiusPill: CGFloat   = 100

    // MARK: SUDS helpers
    static func sudsColor(for score: Int) -> Color {
        switch score {
        case 0...30:  return success
        case 31...60: return warning
        case 61...80: return bravura
        default:      return danger
        }
    }

    static func sudsLabel(for score: Int) -> String {
        switch score {
        case 0...20:  return "Fácil"
        case 21...40: return "Moderado"
        case 41...60: return "Difícil"
        case 61...80: return "Muy difícil"
        default:      return "Extremo"
        }
    }

    // MARK: Plant for streak
    static func plantEmoji(for streak: Int) -> String {
        switch streak {
        case 0:       return "🌑"
        case 1...6:   return "🌱"
        case 7...29:  return "🌿"
        case 30...89: return "🌳"
        default:      return "🌲"
        }
    }

    static func plantLabel(for streak: Int) -> String {
        switch streak {
        case 0:       return "Empieza hoy"
        case 1...6:   return "Germinando"
        case 7...29:  return "Creciendo"
        case 30...89: return "Floreciendo"
        default:      return "Plena madurez"
        }
    }
}

// MARK: - Color hex init

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:  (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:  (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:  (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default: (a, r, g, b) = (255, 255, 255, 255)
        }
        self.init(.sRGB,
                  red:     Double(r) / 255,
                  green:   Double(g) / 255,
                  blue:    Double(b) / 255,
                  opacity: Double(a) / 255)
    }
}

// MARK: - Card modifier

struct BraverCardModifier: ViewModifier {
    var elevated: Bool = false
    func body(content: Content) -> some View {
        content
            .background(elevated ? BraverTheme.surfaceElevated : BraverTheme.surface)
            .cornerRadius(BraverTheme.radiusMedium)
            .overlay(
                RoundedRectangle(cornerRadius: BraverTheme.radiusMedium)
                    .stroke(BraverTheme.surfaceBorder, lineWidth: 1)
            )
    }
}

struct BraverCardGlowModifier: ViewModifier {
    var color: Color
    func body(content: Content) -> some View {
        content
            .background(Color(hex: "0E1120"))   // ligeramente más claro y azulado
            .cornerRadius(BraverTheme.radiusMedium)
            .overlay(
                RoundedRectangle(cornerRadius: BraverTheme.radiusMedium)
                    .stroke(color.opacity(0.28), lineWidth: 1)
            )
            .shadow(color: color.opacity(0.08), radius: 12, x: 0, y: 4)
    }
}

extension View {
    func braverCard(elevated: Bool = false) -> some View {
        modifier(BraverCardModifier(elevated: elevated))
    }
    func braverCardGlow(color: Color) -> some View {
        modifier(BraverCardGlowModifier(color: color))
    }
}

// MARK: - Button styles

struct BraverPrimaryButton: ButtonStyle {
    var color: Color = BraverTheme.accent
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 17, weight: .semibold, design: .rounded))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(color)
            .cornerRadius(BraverTheme.radiusPill)
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.spring(response: 0.2, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

struct BraverGhostButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 15, weight: .medium, design: .rounded))
            .foregroundColor(BraverTheme.textSecondary)
            .padding(.vertical, 12)
            .padding(.horizontal, 20)
            .background(BraverTheme.surface)
            .cornerRadius(BraverTheme.radiusPill)
            .overlay(
                RoundedRectangle(cornerRadius: BraverTheme.radiusPill)
                    .stroke(BraverTheme.surfaceBorder, lineWidth: 1)
            )
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.spring(response: 0.2, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

// MARK: - Stat chip

struct StatChip: View {
    let value: String
    let label: String
    let color: Color

    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundColor(color)
            Text(label)
                .font(.system(size: 11, weight: .medium, design: .rounded))
                .foregroundColor(BraverTheme.textTertiary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .braverCard(elevated: true)
    }
}

// MARK: - SUDS pill

struct SUDSPill: View {
    let score: Int
    var body: some View {
        Text("\(score)")
            .font(.system(size: 12, weight: .bold, design: .rounded))
            .foregroundColor(.white)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(BraverTheme.sudsColor(for: score))
            .cornerRadius(BraverTheme.radiusPill)
    }
}

// MARK: - Section header

struct SectionHeader: View {
    let title: String
    var action: String? = nil
    var onAction: (() -> Void)? = nil

    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .foregroundColor(BraverTheme.textPrimary)
            Spacer()
            if let action, let onAction {
                Button(action, action: onAction)
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundColor(BraverTheme.accent)
            }
        }
    }
}

// MARK: - Braver Orb

struct BraverOrb: View {
    let streak: Int
    var size: CGFloat = 130
    var dimmed: Bool = false

    static func stageName(for streak: Int) -> String {
        switch streak {
        case 0...6:   return "Semilla"
        case 7...29:  return "Brote"
        case 30...89: return "Planta"
        default:      return "Árbol"
        }
    }

    static func nextStageName(for streak: Int) -> String {
        switch streak {
        case 0...6:   return "Brote"
        case 7...29:  return "Planta"
        case 30...89: return "Árbol"
        default:      return "Árbol"
        }
    }

    static func nextStageStreak(for streak: Int) -> Int {
        switch streak {
        case 0...6:   return 7
        case 7...29:  return 30
        case 30...89: return 90
        default:      return 90
        }
    }

    static func daysToNext(for streak: Int) -> Int {
        max(0, nextStageStreak(for: streak) - streak)
    }

    private var orbColors: [Color] {
        if dimmed {
            return [Color(hex: "2A2D3E"), Color(hex: "161925")]
        }
        switch streak {
        case 0:    return [Color(hex: "55566E"), Color(hex: "35364E"), Color(hex: "1A1A2E")]  // Cerrado
        case 3:    return [Color(hex: "5A6288"), Color(hex: "384068"), Color(hex: "1A2045")]  // Despertando
        case 7:    return [Color(hex: "4A7CC4"), Color(hex: "2A56A4"), Color(hex: "0F2860")]  // Abriéndote
        case 14:   return [Color(hex: "4C9EEB"), Color(hex: "2D6FBF"), Color(hex: "0F2E5C")]  // En Marcha
        case 21:   return [Color(hex: "38BDF8"), Color(hex: "0EA5E9"), Color(hex: "075985")]  // Más Fuerte
        case 30:   return [Color(hex: "2DD4BF"), Color(hex: "0D9488"), Color(hex: "065E57")]  // Sin Esconderte
        case 45:   return [Color(hex: "34D399"), Color(hex: "10A374"), Color(hex: "065744")]  // Presente
        case 60:   return [Color(hex: "FCD34D"), Color(hex: "F59E0B"), Color(hex: "92400E")]  // Sin Frenos
        default:   return [Color(hex: "F472B6"), Color(hex: "818CF8"), Color(hex: "34D399")]  // Braver
        }
    }

    private var glowColor: Color {
        if dimmed { return .clear }
        switch streak {
        case 0:    return Color(hex: "55566E").opacity(0.3)
        case 3:    return Color(hex: "5A6288").opacity(0.35)
        case 7:    return Color(hex: "4A7CC4").opacity(0.4)
        case 14:   return Color(hex: "4C9EEB").opacity(0.45)
        case 21:   return Color(hex: "38BDF8").opacity(0.45)
        case 30:   return Color(hex: "2DD4BF").opacity(0.45)
        case 45:   return Color(hex: "34D399").opacity(0.45)
        case 60:   return Color(hex: "FCD34D").opacity(0.5)
        default:   return Color(hex: "F472B6").opacity(0.5)
        }
    }

    var body: some View {
        ZStack {
            // Outer glow
            Circle()
                .fill(glowColor)
                .frame(width: size * 1.4, height: size * 1.4)
                .blur(radius: size * 0.28)

            // Base orb with radial gradient
            Circle()
                .fill(
                    RadialGradient(
                        colors: orbColors,
                        center: UnitPoint(x: 0.38, y: 0.32),
                        startRadius: size * 0.04,
                        endRadius: size * 0.7
                    )
                )
                .frame(width: size, height: size)

            // Primary specular highlight (top-left)
            Circle()
                .fill(
                    RadialGradient(
                        colors: [.white.opacity(dimmed ? 0.06 : 0.38), .clear],
                        center: UnitPoint(x: 0.3, y: 0.26),
                        startRadius: 0,
                        endRadius: size * 0.42
                    )
                )
                .frame(width: size, height: size)

            // Secondary rim light (bottom-right)
            Circle()
                .fill(
                    RadialGradient(
                        colors: [.white.opacity(dimmed ? 0.02 : 0.1), .clear],
                        center: UnitPoint(x: 0.72, y: 0.78),
                        startRadius: 0,
                        endRadius: size * 0.3
                    )
                )
                .frame(width: size, height: size)
        }
    }
}
