import SwiftUI

struct PledgeView: View {
    let challenge: DailyChallenge
    @Binding var isPresented: Bool
    let onCommit: () -> Void

    @State private var lines: [[CGPoint]] = []
    @State private var currentLine: [CGPoint] = []
    @State private var hasSigned = false

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 28) {

                    // Header
                    VStack(spacing: 8) {
                        Text("✍️")
                            .font(.system(size: 48))
                        Text("Tu compromiso de hoy")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundColor(BraverTheme.textPrimary)
                        Text("Firma abajo para comprometerte con el reto de hoy.")
                            .font(.system(size: 14, design: .rounded))
                            .foregroundColor(BraverTheme.textSecondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 12)

                    // Reto card
                    HStack(spacing: 12) {
                        Text(challenge.categoryEmoji)
                            .font(.system(size: 26))
                            .frame(width: 48, height: 48)
                            .background(BraverTheme.accent.opacity(0.12))
                            .cornerRadius(12)
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Reto de hoy")
                                .font(.system(size: 11, weight: .semibold, design: .rounded))
                                .foregroundColor(BraverTheme.textTertiary)
                            Text(challenge.title)
                                .font(.system(size: 14, weight: .semibold, design: .rounded))
                                .foregroundColor(BraverTheme.textPrimary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        Spacer()
                    }
                    .padding(BraverTheme.cardPadding)
                    .braverCard(elevated: true)

                    // Commitment text
                    Text("\"Me comprometo a intentar este reto hoy, sin importar la incomodidad que sienta.\"")
                        .font(.system(size: 15, weight: .medium, design: .rounded))
                        .foregroundColor(BraverTheme.textSecondary)
                        .multilineTextAlignment(.center)
                        .italic()
                        .padding(.horizontal, 8)

                    // Signature pad
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("Firma aquí con el dedo")
                                .font(.system(size: 13, weight: .medium, design: .rounded))
                                .foregroundColor(BraverTheme.textTertiary)
                            Spacer()
                            if hasSigned {
                                Button("Borrar firma") {
                                    lines = []
                                    currentLine = []
                                    hasSigned = false
                                }
                                .font(.system(size: 12, design: .rounded))
                                .foregroundColor(BraverTheme.danger.opacity(0.8))
                            }
                        }

                        ZStack {
                            RoundedRectangle(cornerRadius: BraverTheme.radiusMedium)
                                .fill(BraverTheme.surfaceElevated)
                                .overlay(
                                    RoundedRectangle(cornerRadius: BraverTheme.radiusMedium)
                                        .stroke(
                                            hasSigned ? BraverTheme.accent.opacity(0.4) : BraverTheme.surfaceBorder,
                                            style: StrokeStyle(lineWidth: 1, dash: hasSigned ? [] : [6, 4])
                                        )
                                )

                            if !hasSigned {
                                Text("Firma aquí")
                                    .font(.system(size: 14, design: .rounded))
                                    .foregroundColor(BraverTheme.textTertiary.opacity(0.5))
                            }

                            Canvas { context, _ in
                                for line in lines + [currentLine] {
                                    guard line.count > 1 else { continue }
                                    var path = Path()
                                    path.move(to: line[0])
                                    for point in line.dropFirst() {
                                        path.addLine(to: point)
                                    }
                                    context.stroke(path, with: .color(BraverTheme.accent), style: StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round))
                                }
                            }
                        }
                        .frame(height: 140)
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { value in
                                    currentLine.append(value.location)
                                    hasSigned = true
                                }
                                .onEnded { _ in
                                    lines.append(currentLine)
                                    currentLine = []
                                }
                        )
                    }
                    .padding(BraverTheme.cardPadding)
                    .braverCard()

                    // CTA
                    Button {
                        isPresented = false
                        onCommit()
                    } label: {
                        Text("Firmar y comprometerse  →")
                    }
                    .buttonStyle(BraverPrimaryButton(color: hasSigned ? BraverTheme.accent : BraverTheme.textTertiary))
                    .disabled(!hasSigned)
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
