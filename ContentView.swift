import SwiftUI

@main
struct NetCheckApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    @State private var resultText: String? = nil
    @State private var isChecking = false

    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()

            VStack(spacing: 24) {
                Button(action: checkConnection) {
                    Text(isChecking ? "Проверяю..." : "Проверить инет")
                        .font(.title3.bold())
                        .frame(width: 220, height: 56)
                }
                .buttonStyle(.borderedProminent)
                .disabled(isChecking)

                if let resultText {
                    Text(resultText)
                        .font(.title2.bold())
                        .foregroundColor(resultText == "Есть инет" ? .green : .red)
                }
            }
        }
    }

    private func checkConnection() {
        guard let url = URL(string: "https://1.1.1.1/cdn-cgi/trace") else { return }

        isChecking = true
        resultText = nil

        var request = URLRequest(url: url)
        request.timeoutInterval = 5
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData

        URLSession.shared.dataTask(with: request) { _, response, error in
            DispatchQueue.main.async {
                isChecking = false

                if error == nil,
                   let http = response as? HTTPURLResponse,
                   (200...299).contains(http.statusCode) {
                    resultText = "Есть инет"
                } else {
                    resultText = "Нету инета"
                }
            }
        }.resume()
    }
}
