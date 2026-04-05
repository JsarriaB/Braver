import SwiftUI

struct EveningCheckInView: View {
    @Binding var isPresented: Bool
    @StateObject private var service = EveningCheckInService.shared

    @State private var selectedMood: Int? = nil
    @State private var note: String = ""
    @State private var saved = false

    let moods = [("😌", "Bien"), ("😬", "Regular"), ("😤", "Mal")]

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 28) {

                    // Header
                    VStack(spacing: 8) {
                        Text("🌙")
                            .font(.system(size: 48))
                        Text("¿Cómo fue tu día?")
                            .font(.system(size: 26, weight: .bold, design: .rounded))
                            .foregroundColor(BraverTheme.textPrimary)
                        Text("30 segundos — todo con botones")
                            .font(.system(size: 14, design: .rounded))
                            .foregroundColor(BraverTheme.textSecondary)
                    }
                    .padding(.top, 12)

                    // Mood selector
                    VStack(spacing: 14) {
                        Text("¿Cómo te sientes?")
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                            .foregroundColor(BraverTheme.textPrimary)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        HStack(spacing: 12) {
                            ForEach(Array(moods.enumerated()), id: \.offset) { i, mood in
                                Button {
                                    withAnimation(.spring(response: 0.2)) {
                                        selectedMood = i
                                    }
                                } label: {
                                    VStack(spacing: 8) {
                                        Text(mood.0)
                                            .font(.system(size: 38))
                                            .scaleEffect(selectedMood == i ? 1.2 : 1)
                                        Text(mood.1)
                                            .font(.system(size: 13, weight: .semibold, design: .rounded))
                                            .foregroundColor(selectedMood == i ? BraverTheme.accent : BraverTheme.textTertiary)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                                    .background(selectedMood == i ? BraverTheme.accent.opacity(0.12) : BraverTheme.surfaceElevated)
                                    .cornerRadius(BraverTheme.radiusMedium)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: BraverTheme.radiusMedium)
                                            .stroke(
                                                selectedMood == i ? BraverTheme.accent.opacity(0.4) : BraverTheme.surfaceBorder,
                                                lineWidth: 1
                                            )
                                    )
                                }
                                .animation(.spring(response: 0.2), value: selectedMood)
                            }
                        }
                    }
                    .padding(BraverTheme.cardPadding)
                    .braverCard()

                    // Optional note
                    VStack(alignment: .leading, spacing: 10) {
                        Text("¿Algo que destacar? (opcional)")
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                            .foregroundColor(BraverTheme.textPrimary)
                        TextField("Un momento del día, un reto, un pensamiento...", text: $note, axis: .vertical)
                            .font(.system(size: 14, design: .rounded))
                            .foregroundColor(BraverTheme.textPrimary)
                            .lineLimit(3...5)
                            .padding(14)
                            .background(BraverTheme.surfaceElevated)
                            .cornerRadius(BraverTheme.radiusSmall)
                    }
                    .padding(BraverTheme.cardPadding)
                    .braverCard()

                    // Save button
                    Button {
                        guard let idx = selectedMood else { return }
                        service.save(
                            mood: moods[idx].0,
                            moodLabel: moods[idx].1,
                            note: note.isEmpty ? nil : note
                        )
                        withAnimation { saved = true }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                            isPresented = false
                        }
                    } label: {
                        if saved {
                            Label("Guardado", systemImage: "checkmark")
                        } else {
                            Text("Guardar diario")
                        }
                    }
                    .buttonStyle(BraverPrimaryButton(color: selectedMood != nil ? BraverTheme.accent : BraverTheme.textTertiary))
                    .disabled(selectedMood == nil)
                    .padding(.top, 4)
                }
                .padding(.horizontal, BraverTheme.screenPadding)
                .padding(.bottom, 40)
            }
            .background(BraverTheme.background.ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isPresented = false
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(BraverTheme.textTertiary)
                            .font(.system(size: 20))
                    }
                }
            }
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
        .preferredColorScheme(.dark)
    }
}
