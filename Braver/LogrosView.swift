import SwiftUI

struct LogrosView: View {
    let grouped: [(AchievementCategory, [Achievement])]

    var totalUnlocked: Int { grouped.flatMap(\.1).filter(\.isUnlocked).count }
    var total: Int         { grouped.flatMap(\.1).count }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text("Logros")
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundColor(BraverTheme.textPrimary)
                Spacer()
                Text("\(totalUnlocked) de \(total)")
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundColor(BraverTheme.textTertiary)
            }

            ForEach(grouped, id: \.0.rawValue) { category, achievements in
                VStack(alignment: .leading, spacing: 10) {
                    Text(category.rawValue.uppercased())
                        .font(.system(size: 11, weight: .semibold, design: .rounded))
                        .foregroundColor(BraverTheme.textTertiary)
                        .kerning(1)

                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                        ForEach(achievements) { achievement in
                            AchievementBadge(achievement: achievement)
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Badge

struct AchievementBadge: View {
    let achievement: Achievement

    var accentColor: Color {
        switch achievement.category {
        case .racha:      return BraverTheme.bravura
        case .retos:      return BraverTheme.accent
        case .dificultad: return BraverTheme.warning
        case .categorias: return BraverTheme.success
        case .momentos:   return Color(hex: "A78BFA")
        }
    }

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(achievement.isUnlocked ? accentColor.opacity(0.15) : BraverTheme.surfaceElevated)
                    .frame(width: 48, height: 48)
                Image(systemName: achievement.icon)
                    .font(.system(size: 18))
                    .foregroundColor(achievement.isUnlocked ? accentColor : BraverTheme.textTertiary)
            }
            Text(achievement.title)
                .font(.system(size: 10, weight: .semibold, design: .rounded))
                .foregroundColor(achievement.isUnlocked ? BraverTheme.textPrimary : BraverTheme.textTertiary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
            Text(achievement.description)
                .font(.system(size: 9, design: .rounded))
                .foregroundColor(BraverTheme.textTertiary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 6)
        .frame(maxWidth: .infinity)
        .background(achievement.isUnlocked ? BraverTheme.surfaceElevated : BraverTheme.surfaceElevated.opacity(0.4))
        .cornerRadius(BraverTheme.radiusMedium)
        .overlay(
            RoundedRectangle(cornerRadius: BraverTheme.radiusMedium)
                .stroke(achievement.isUnlocked ? accentColor.opacity(0.25) : BraverTheme.surfaceBorder, lineWidth: 1)
        )
        .opacity(achievement.isUnlocked ? 1 : 0.5)
    }
}
