import SwiftUI
import SpriteKit
import LinkPresentation

// MARK: - GameManager (Centralized Game Logic)
class GameManager: ObservableObject {
    @Published var score: Int = 0
    @Published var coinCount: Int = 0
    @Published var gameTime: Int = 0 // Time in seconds

    func awardPoints(forCorrectAnswer: Bool) {
        if forCorrectAnswer {
            score += 1
            gameTime += 10 // Add 10 seconds for each correct answer
        }
    }

    func collectCoin() {
        coinCount += 1
    }
}

// MARK: - Define the Color Scheme
extension Color {
    static let galaxyBackground = Color(red: 0.05, green: 0.05, blue: 0.15) // Dark blue background
    static let galaxyText = Color.white // White text
    static let galaxyButton = Color(red: 0.2, green: 0.6, blue: 1.0) // Bright blue buttons
    static let galaxyAccent = Color(red: 1.0, green: 0.8, blue: 0.0) // Yellow accent
}

// MARK: - ContentView (Main Menu)
struct ContentView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color.galaxyBackground
                    .edgesIgnoringSafeArea(.all) // Set background color

                VStack(spacing: 20) {
                    Text("Grammar Galaxy")
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                        .foregroundColor(.galaxyText)
                        .padding(.top, 40)

                    Spacer()

                    NavigationLink(destination: GameView()) {
                        Text("Start Mission")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.galaxyButton)
                            .foregroundColor(.galaxyText)
                            .cornerRadius(15)
                            .shadow(color: .galaxyAccent, radius: 5, x: 0, y: 5)
                    }
                    .padding(.horizontal, 40)

                    NavigationLink(destination: ProgressView()) {
                        Text("View Progress")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.galaxyButton)
                            .foregroundColor(.galaxyText)
                            .cornerRadius(15)
                            .shadow(color: .galaxyAccent, radius: 5, x: 0, y: 5)
                    }
                    .padding(.horizontal, 40)

                    NavigationLink(destination: ShopView()) {
                        Text("Shop")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.galaxyButton)
                            .foregroundColor(.galaxyText)
                            .cornerRadius(15)
                            .shadow(color: .galaxyAccent, radius: 5, x: 0, y: 5)
                    }
                    .padding(.horizontal, 40)

                    Spacer()

                    Text("Presented by: Venkat and Muhaimin")
                        .font(.footnote)
                        .foregroundColor(.galaxyText.opacity(0.7))
                        .padding(.bottom, 20)
                }
            }
        }
    }
}

// MARK: - GameView (Grammar Questions)
struct GameView: View {
    @EnvironmentObject private var gameManager: GameManager
    @State private var questionIndex = 0
    @State private var correctAnswers = 0
    @State private var isGameOver = false // Track if the game is over

    let questions = [
           (question: "Choose the correct sentence:",
            options: ["She go to the store.", "She goes to the store."],
            answer: 1),
           
           (question: "Select the correct word: The cat ___ on the mat.",
            options: ["sit", "sits"],
            answer: 1),
           
           (question: "Which sentence is correct?",
            options: ["We is going to the park.", "We are going to the park."],
            answer: 1),
           
           (question: "Choose the proper past tense:",
            options: ["I eated dinner", "I ate dinner"],
            answer: 1),
           
           (question: "Select the correct article:",
            options: ["an university", "a university"],
            answer: 1),
           
           (question: "Which is the correct plural?",
            options: ["childs", "children"],
            answer: 1),
           
           (question: "Identify the correct preposition:",
            options: ["She's good in math", "She's good at math"],
            answer: 1),
           
           (question: "Choose the proper adjective form:",
            options: ["quickly runner", "quick runner"],
            answer: 1),
           
           (question: "Which sentence uses correct punctuation?",
            options: ["Let's eat, grandma!", "Let's eat grandma!"],
            answer: 0),
           
           (question: "Select the correct conjunction:",
            options: ["I want ice cream but I'm allergic.", "I want ice cream and I'm allergic."],
            answer: 0),
           
           (question: "Which is the comparative form?",
            options: ["more happy", "happier"],
            answer: 1),
           
           (question: "Identify the correct tense:",
            options: ["I have did my homework", "I have done my homework"],
            answer: 1),
           
           (question: "Choose the proper pronoun:",
            options: ["Me and John went", "John and I went"],
            answer: 1),
           
           (question: "Which is a complete sentence?",
            options: ["Although it was raining.", "It was raining heavily."],
            answer: 1),
           
           (question: "Select the correct adverb:",
            options: ["He ran quick", "He ran quickly"],
            answer: 1)
       ]

    var body: some View {
        ZStack {
            Color.galaxyBackground
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                Text(questions[questionIndex].question)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.galaxyText)
                    .padding(.top, 20)

                ForEach(0..<questions[questionIndex].options.count, id: \.self) { index in
                    Button(action: {
                        if index == questions[questionIndex].answer {
                            gameManager.awardPoints(forCorrectAnswer: true)
                            correctAnswers += 1
                        }
                        if questionIndex < questions.count - 1 {
                            questionIndex += 1
                        }
                    }) {
                        Text(questions[questionIndex].options[index])
                            .font(.title2)
                            .fontWeight(.medium)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.galaxyButton)
                            .foregroundColor(.galaxyText)
                            .cornerRadius(10)
                            .shadow(color: .galaxyAccent, radius: 3, x: 0, y: 3)
                    }
                    .padding(.horizontal, 40)
                }

                Spacer()

                Text("Score: \(gameManager.score)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.galaxyText)
                    .padding(.bottom, 20)

                if correctAnswers >= 5 && !isGameOver {
                    NavigationLink(destination: SpaceInvadersGameView(gameTime: gameManager.gameTime, onGameOver: {
                        isGameOver = true
                        correctAnswers = 0 // Reset correct answers
                    })) {
                        Text("Play Space Invaders")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.galaxyButton)
                            .foregroundColor(.galaxyText)
                            .cornerRadius(15)
                            .shadow(color: .galaxyAccent, radius: 5, x: 0, y: 5)
                    }
                    .padding(.horizontal, 40)
                    .padding(.bottom, 20)
                } else {
                    Text("Answer \(5 - correctAnswers) more questions to unlock the game!")
                        .font(.title3)
                        .fontWeight(.medium)
                        .foregroundColor(.galaxyText)
                        .padding(.bottom, 20)
                }
            }
        }
    }
}

// MARK: - SpaceInvadersGameView
struct SpaceInvadersGameView: View {
    let gameTime: Int
    var onGameOver: () -> Void // Callback for game over
    @EnvironmentObject private var gameManager: GameManager // Access GameManager

    var body: some View {
        SpriteView(scene: SpaceInvadersScene(gameTime: gameTime, gameManager: gameManager, onGameOver: onGameOver))
            .edgesIgnoringSafeArea(.all)
    }
}

class SpaceInvadersScene: SKScene, SKPhysicsContactDelegate {
    let player = SKSpriteNode(color: .white, size: CGSize(width: 40, height: 20))
    var gameTimer: Timer?
    var coinTimer: Timer?
    var gameTime: Int
    var remainingTime: Int
    var gameManager: GameManager // Use the shared GameManager
    var timeLabel: SKLabelNode! // Add a time label
    var onGameOver: () -> Void // Callback for game over

    init(gameTime: Int, gameManager: GameManager, onGameOver: @escaping () -> Void) {
        self.gameTime = gameTime
        self.remainingTime = gameTime
        self.gameManager = gameManager
        self.onGameOver = onGameOver
        super.init(size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMove(to view: SKView) {
        backgroundColor = .black
        physicsWorld.contactDelegate = self

        // Add player
        player.position = CGPoint(x: size.width / 2, y: 100)
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.isDynamic = false
        player.physicsBody?.categoryBitMask = 4
        player.physicsBody?.contactTestBitMask = 3 | 1
        player.physicsBody?.collisionBitMask = 0
        addChild(player)

        // Add time label (positioned lower)
        timeLabel = SKLabelNode(text: "Time: \(remainingTime)")
        timeLabel.fontName = "Arial"
        timeLabel.fontSize = 30
        timeLabel.fontColor = .white
        timeLabel.position = CGPoint(x: size.width / 2, y: size.height - 100) // Moved lower
        addChild(timeLabel)

        // Start timers
        gameTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(spawnEnemies), userInfo: nil, repeats: true)
        coinTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(spawnCoin), userInfo: nil, repeats: true)

        // Game countdown
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            self.remainingTime -= 1
            self.timeLabel.text = "Time: \(self.remainingTime)" // Update time label
            if self.remainingTime <= 0 {
                timer.invalidate()
                self.gameOver()
            }
        }
    }

    @objc func spawnEnemies() {
        let enemy = SKSpriteNode(color: .red, size: CGSize(width: 30, height: 30))
        enemy.position = CGPoint(x: CGFloat.random(in: 0...size.width), y: size.height - 50)
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy.physicsBody?.categoryBitMask = 1
        enemy.physicsBody?.contactTestBitMask = 2 | 4
        enemy.physicsBody?.collisionBitMask = 0
        addChild(enemy)

        let moveAction = SKAction.moveTo(y: 0, duration: 5)
        let removeAction = SKAction.removeFromParent()
        enemy.run(SKAction.sequence([moveAction, removeAction]))
    }

    @objc func spawnCoin() {
        let coin = SKSpriteNode(color: .yellow, size: CGSize(width: 20, height: 20))
        coin.position = CGPoint(x: CGFloat.random(in: 0...size.width), y: size.height - 50)
        coin.physicsBody = SKPhysicsBody(rectangleOf: coin.size)
        coin.physicsBody?.categoryBitMask = 3
        coin.physicsBody?.contactTestBitMask = 4
        coin.physicsBody?.collisionBitMask = 0
        addChild(coin)

        let moveAction = SKAction.moveTo(y: 0, duration: 5)
        let removeAction = SKAction.removeFromParent()
        coin.run(SKAction.sequence([moveAction, removeAction]))
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let newPosition = CGPoint(x: location.x, y: player.position.y)

        if newPosition.x - player.size.width / 2 > 0 && newPosition.x + player.size.width / 2 < size.width {
            player.position = newPosition
        }
    }

    func shootBullet() {
        let bullet = SKSpriteNode(color: .white, size: CGSize(width: 5, height: 10))
        bullet.position = player.position
        bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size)
        bullet.physicsBody?.isDynamic = true
        bullet.physicsBody?.categoryBitMask = 2
        bullet.physicsBody?.contactTestBitMask = 1
        bullet.physicsBody?.collisionBitMask = 0
        bullet.physicsBody?.usesPreciseCollisionDetection = true
        addChild(bullet)

        let moveAction = SKAction.moveTo(y: size.height, duration: 1)
        let removeAction = SKAction.removeFromParent()
        bullet.run(SKAction.sequence([moveAction, removeAction]))
    }

    func didBegin(_ contact: SKPhysicsContact) {
        if let nodeA = contact.bodyA.node, let nodeB = contact.bodyB.node {
            // Player collects a coin
            if (nodeA == player && nodeB.physicsBody?.categoryBitMask == 3) ||
               (nodeB == player && nodeA.physicsBody?.categoryBitMask == 3) {
                if nodeA.physicsBody?.categoryBitMask == 3 {
                    nodeA.removeFromParent()
                } else {
                    nodeB.removeFromParent()
                }
                gameManager.collectCoin() // Update coin count
            }

            // Bullet hits an enemy
            if (nodeA.physicsBody?.categoryBitMask == 2 && nodeB.physicsBody?.categoryBitMask == 1) ||
               (nodeB.physicsBody?.categoryBitMask == 2 && nodeA.physicsBody?.categoryBitMask == 1) {
                nodeA.removeFromParent()
                nodeB.removeFromParent()
            }

            // Player hits an enemy
            if (nodeA == player && nodeB.physicsBody?.categoryBitMask == 1) ||
               (nodeB == player && nodeA.physicsBody?.categoryBitMask == 1) {
                gameOver()
            }
        }
    }

    func gameOver() {
        gameTimer?.invalidate()
        coinTimer?.invalidate()
        let gameOverLabel = SKLabelNode(text: "Game Over!")
        gameOverLabel.fontSize = 40
        gameOverLabel.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(gameOverLabel)

        // Trigger the callback to reset the game
        onGameOver()
    }
}

// MARK: - ProgressView
struct ProgressView: View {
    @EnvironmentObject private var gameManager: GameManager
    @State private var isSharing = false

    var body: some View {
        ZStack {
            Color.galaxyBackground
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                Text("Your Progress")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.galaxyText)
                    .padding(.top, 40)

                VStack(spacing: 15) {
                    Text("Total Score: \(gameManager.score)")
                        .font(.title2)
                        .fontWeight(.medium)
                        .foregroundColor(.galaxyText)

                    Text("Coins: \(gameManager.coinCount)")
                        .font(.title2)
                        .fontWeight(.medium)
                        .foregroundColor(.galaxyText)
                }
                .padding()
                .background(Color.galaxyButton.opacity(0.2))
                .cornerRadius(15)
                .shadow(color: .galaxyAccent, radius: 5, x: 0, y: 5)

                Button(action: {
                    isSharing = true
                }) {
                    Text("Share Progress")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.galaxyButton)
                        .foregroundColor(.galaxyText)
                        .cornerRadius(15)
                        .shadow(color: .galaxyAccent, radius: 5, x: 0, y: 5)
                }
                .padding(.horizontal, 40)
                .sheet(isPresented: $isSharing) {
                    ActivityView(activityItems: ["I scored \(gameManager.score) points and collected \(gameManager.coinCount) coins in Grammar Galaxy! 🚀"])
                }

                Spacer()
            }
        }
    }
}

// MARK: - ActivityView for Sharing
struct ActivityView: UIViewControllerRepresentable {
    var activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

// MARK: - ShopView
struct ShopView: View {
    @EnvironmentObject private var gameManager: GameManager
    @AppStorage("unlockedSkins") private var unlockedSkinsData: String = "[]"

    private var unlockedSkins: [String] {
        if let data = unlockedSkinsData.data(using: .utf8),
           let decoded = try? JSONDecoder().decode([String].self, from: data) {
            return decoded
        }
        return []
    }

    private func updateUnlockedSkins(with newSkins: [String]) {
        if let encoded = try? JSONEncoder().encode(newSkins) {
            unlockedSkinsData = String(data: encoded, encoding: .utf8) ?? "[]"
        }
    }

    let skins = ["Red Skin", "Blue Skin", "Gold Skin"]

    var body: some View {
        ZStack {
            Color.galaxyBackground
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                Text("Shop")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.galaxyText)
                    .padding(.top, 40)

                Text("Coins: \(gameManager.coinCount)")
                    .font(.title2)
                    .fontWeight(.medium)
                    .foregroundColor(.galaxyText)

                ForEach(skins, id: \.self) { skin in
                    Button(action: {
                        if gameManager.coinCount >= 100 && !unlockedSkins.contains(skin) {
                            gameManager.coinCount -= 100
                            var updatedSkins = unlockedSkins
                            updatedSkins.append(skin)
                            updateUnlockedSkins(with: updatedSkins)
                        }
                    }) {
                        Text("Buy \(skin) - 100 Coins")
                            .font(.title2)
                            .fontWeight(.medium)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(unlockedSkins.contains(skin) ? Color.gray : Color.galaxyButton)
                            .foregroundColor(.galaxyText)
                            .cornerRadius(10)
                            .shadow(color: .galaxyAccent, radius: 3, x: 0, y: 3)
                    }
                    .padding(.horizontal, 40)
                }

                Spacer()
            }
        }
    }
}
