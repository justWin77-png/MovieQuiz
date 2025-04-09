import Foundation

final class StatisticService {
    private let storage: UserDefaults = .standard
    
    private enum Keys:String {
        case gamesCount
        case bestGameCorrect
        case bestGameTotal
        case bestGameDate
        case totalCorrectAnswers
    }
}
extension StatisticService: StatisticServiceProtocol {
    var totalAccuracy: Double {
        let totalCorrectAnswers = storage.integer(forKey: Keys.totalCorrectAnswers.rawValue)
           let totalGames = gamesCount
           guard totalGames > 0 else {
               return 0.0
           }
           let totalQuestions = Double(totalGames) * 10.0
           let accuracy = (Double(totalCorrectAnswers) / totalQuestions) * 100.0
    
           return (accuracy * 10).rounded() / 10
       }
    var gamesCount: Int {
        get {
            storage.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    var bestGame: GameResult {
        get {
                let correct = storage.integer(forKey: Keys.bestGameCorrect.rawValue)
                let total = storage.integer(forKey: Keys.bestGameTotal.rawValue)
                let date: Date
                if let savedDate = storage.object(forKey: Keys.bestGameDate.rawValue) as? Date {
                    date = savedDate
                } else {
                    date = Date()
                }
                
                return GameResult(correct: correct, total: total, date: date)
            }
            set {
                storage.set(newValue.correct, forKey: Keys.bestGameCorrect.rawValue)
                storage.set(newValue.total, forKey: Keys.bestGameTotal.rawValue)
                storage.set(newValue.date, forKey: Keys.bestGameDate.rawValue)
            }
        }
    func store(correct count: Int, total amount: Int) {
                if count > bestGame.correct {
                    bestGame = GameResult(correct: count, total: amount, date: Date())
                }
                let currentTotalCorrect = storage.integer(forKey: Keys.totalCorrectAnswers.rawValue)
                storage.set(currentTotalCorrect + count, forKey: Keys.totalCorrectAnswers.rawValue)
                gamesCount += 1
    }
}

