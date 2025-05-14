import SwiftUI
import Combine

// MARK: - Model
struct OnboardingItem: Identifiable, Hashable {
    let id = UUID()
    let imageName: String
    let title: String
    let description: String
}

// MARK: - Single Slide View
struct OnboardingSlide: View {
    let item: OnboardingItem

    var body: some View {
        VStack {
            Spacer()

            Image(item.imageName)
                .resizable()
                .scaledToFit()
                .frame(
                  width: UIScreen.main.bounds.width * 0.65,
                  height: UIScreen.main.bounds.width * 0.65
                )

            Text(item.title)
                .font(.title2).bold()
                .padding(.top, 42)

            Text(item.description)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.top, 12)
                .padding(.horizontal, 62)
                .foregroundColor(.gray)

            Spacer()
        }
        .navigationBarHidden(true)
    }
}

// MARK: - Container View
struct OnboardingView: View {
    @State private var activeSlide = 0
    @State private var timerCancellable: AnyCancellable?
    @State private var navigateToSignIn = false

    private let slides: [OnboardingItem] = [
        .init(
          imageName: "onboarding_slide_1",
          title: "Explore Destinations",
          description: "Discover the places for your trip in the world and feel great."
        ),
        .init(
          imageName: "onboarding_slide_2",
          title: "Choose a Destination",
          description: "Select a place for your trip easily and know the exact cost of the tour."
        ),
        .init(
          imageName: "onboarding_slide_3",
          title: "Fly to Destination",
          description: "Finally, get ready for the tour and go to your desired destination."
        )
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                // The paging TabView
                TabView(selection: $activeSlide) {
                    ForEach(Array(slides.enumerated()), id: \.offset) { idx, item in
                        OnboardingSlide(item: item)
                            .tag(idx)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .ignoresSafeArea()

                VStack {
                    Spacer()

                    // Page Indicators
                    HStack(spacing: 8) {
                        ForEach(0..<slides.count, id: \.self) { idx in
                            RoundedRectangle(cornerRadius: 6)
                                .frame(
                                  width: activeSlide == idx ? 62 : 26,
                                  height: 8
                                )
                                .foregroundColor(
                                  activeSlide == idx
                                    ? Color("green")
                                    : Color("grey")
                                )
                                .animation(.easeInOut, value: activeSlide)
                        }
                    }

                    Spacer().frame(height: 16)

                    // Manual “Next” button
                    Button(action: advance) {
                        Image(systemName: "arrow.right")
                            .resizable().scaledToFit()
                            .frame(width: 20, height: 20)
                            .padding()
                            .background(Color("green"))
                            .foregroundColor(.white)
                            .clipShape(Circle())
                            .shadow(radius: 4)
                    }
                }
                .padding(.bottom, 60)

                // Trigger navigation when timer or manual reaches end
            }
            .navigationDestination(isPresented: $navigateToSignIn) {
                SignInView()
            }
            .onAppear(perform: startTimer)
            .onDisappear { timerCancellable?.cancel() }
        }
    }

    // MARK: - Timer
    private func startTimer() {
        timerCancellable = Timer
            .publish(every: 5, on: .main, in: .common)
            .autoconnect()
            .sink { _ in advance() }
    }

    private func advance() {
        if activeSlide < slides.count - 1 {
            withAnimation { activeSlide += 1 }
        } else {
            timerCancellable?.cancel()
            navigateToSignIn = true
        }
    }
}

// MARK: - Preview
struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
