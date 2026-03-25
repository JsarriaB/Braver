import SwiftUI

struct SplashView: View {
    let onFinished: () -> Void

    @State private var typedText = ""
    @State private var logoOpacity: Double = 0
    @State private var logoScale: CGFloat = 0.85

    let fullPhrase = "Feel the fear. Do it anyway."
    let typingSpeed: Double = 0.045  // segundos por carácter

    var body: some View {
        ZStack {
            // Fondo negro
            Color(hex: "050507").ignoresSafeArea()

            // Blobs teal — mismo estilo que ContentView
            GeometryReader { geo in
                Circle()
                    .fill(Color(hex: "0E9090").opacity(0.20))
                    .frame(width: 500, height: 500)
                    .offset(x: geo.size.width - 160, y: -160)
                    .blur(radius: 90)

                Circle()
                    .fill(Color(hex: "0B7A8A").opacity(0.14))
                    .frame(width: 400, height: 400)
                    .offset(x: -100, y: geo.size.height * 0.55)
                    .blur(radius: 100)
            }
            .ignoresSafeArea()

            // Contenido central
            VStack(spacing: 24) {
                // Logo — orbe con el color de la app
                ZStack {
                    Circle()
                        .fill(Color(hex: "0E9090").opacity(0.15))
                        .frame(width: 100, height: 100)
                        .blur(radius: 20)

                    BraverOrb(streak: 30, size: 72)
                }

                // Nombre
                Text("BRAVER")
                    .font(.system(size: 48, weight: .heavy, design: .rounded))
                    .foregroundColor(Color(hex: "F1F5F9"))
                    .tracking(6)

                // Frase con efecto typewriter
                Text(typedText)
                    .font(.system(size: 17, weight: .medium, design: .rounded))
                    .foregroundColor(Color(hex: "94A3B8"))
                    .frame(height: 24)          // altura fija para no saltar el layout
                    .animation(nil, value: typedText)
            }
            .opacity(logoOpacity)
            .scaleEffect(logoScale)
        }
        .onAppear {
            // Fade in del logo
            withAnimation(.easeOut(duration: 0.5)) {
                logoOpacity = 1
                logoScale = 1
            }

            // Typewriter — empieza 0.4s después del fade
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                typeNextCharacter(index: 0)
            }
        }
    }

    private func typeNextCharacter(index: Int) {
        let chars = Array(fullPhrase)
        guard index <= chars.count else {
            // Frase completa — espera un poco y sale
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                withAnimation(.easeInOut(duration: 0.4)) {
                    logoOpacity = 0
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    onFinished()
                }
            }
            return
        }

        typedText = String(chars.prefix(index))

        DispatchQueue.main.asyncAfter(deadline: .now() + typingSpeed) {
            typeNextCharacter(index: index + 1)
        }
    }
}
