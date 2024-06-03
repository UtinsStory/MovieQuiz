import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate, AlertPresenterDelegate {
    // MARK: - Lifecycle
    @IBOutlet private var questionTitleLabel: UILabel!
    @IBOutlet private var indexLabel: UILabel!
    @IBOutlet private var questionLabel: UILabel!
    @IBOutlet private var noButton: UIButton!
    @IBOutlet private var yesButton: UIButton!
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else { return }
        let givenAnswer = false
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else { return }
        let givenAnswer = true
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    @IBOutlet private var imageView: UIImageView!
    
    private let questionsAmount: Int = 10
    
    private var questionFactory: QuestionFactoryProtocol = QuestionFactory()
    
    private var alertPresenter: AlertPresenterProtocol?
    
    private var currentQuestion: QuizQuestion?
    
    private var currentQuestionIndex = 0
    
    private var correctAnswers = 0
    
    private var statisticService: StatisticServiceProtocol?
    
    
    
    private func convert(model:QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        return questionStep
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        questionLabel.text = step.question
        indexLabel.text = step.questionNumber
        imageView.layer.borderColor = UIColor.ypBlack.cgColor
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        noButton.isEnabled = false
        yesButton.isEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            
            self.showNextQuestionOrResults()
            
            noButton.isEnabled = true
            yesButton.isEnabled = true
        }
    }
    
    private func showNextQuestionOrResults() {
        
        if currentQuestionIndex == questionsAmount - 1 {
            
            statisticService?.store(correct: correctAnswers, total: questionsAmount)
            let currentRecord = "\(statisticService?.bestGame.correct ?? 0)/\(statisticService?.bestGame.total ?? 10)"
            let totalCount = "\(statisticService?.gamesCount ?? 0)"
            let recordTime = statisticService?.bestGame.date.dateTimeString
            let accuracy = String(format: "%.2f", statisticService?.totalAccuracy ?? 0)
            let text = """
                Ваш результат: \(correctAnswers)/\(questionsAmount)
                Количество сыгранных квизов: \(totalCount)
                Рекорд: \(currentRecord) (\(recordTime ?? Date().dateTimeString))
                Средняя точность: \(accuracy)%
                """
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть ещё раз")
            show(quiz: viewModel)
        } else {
            currentQuestionIndex += 1
            
            
            questionFactory.requestNextQuestion()
            
        }
    }
    
    
    
    private func show(quiz result: QuizResultsViewModel) {
        
        let alertModel = AlertModel(title: result.title, message: result.text, buttonText: result.buttonText, completion: {
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            self.questionFactory.requestNextQuestion()
        })
        alertPresenter?.showAlert(model: alertModel)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let questionFactory = QuestionFactory()
        questionFactory.setup(delegate: self)
        self.questionFactory = questionFactory
        
        questionFactory.requestNextQuestion()
        
        alertPresenter = AlertPresenter(delegate: self)
        
        statisticService = StatisticServiceImplementation()
        
        questionTitleLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        
        indexLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        
        questionLabel.font = UIFont(name: "YSDisplay-Bold", size: 23)
        
        noButton.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
        
        yesButton.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
        
        noButton.layer.cornerRadius = 15
        
        yesButton.layer.cornerRadius = 15
        
        imageView.layer.cornerRadius = 20
        
//        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//        let top250MoviesIMDBPath = documentsURL.appendingPathComponent("top250MoviesIMDB")
//        let jsonStringTop250MoviesIMDB = try? String(contentsOf: top250MoviesIMDBPath)
//        let dataTop250MoviesIMDB = jsonStringTop250MoviesIMDB?.data(using: .utf8)
//        
//        guard let dataTop250MoviesIMDB = dataTop250MoviesIMDB else { return }
//        
//        var returnedMovieTest: [Movie] = []
//        
//        do {
//                    let jsonTop250Movies = try JSONSerialization.jsonObject(with: dataTop250MoviesIMDB, options: []) as? [String: Any]
//                    guard let jsonTop250Movies = jsonTop250Movies,
//                          let items = jsonTop250Movies["items"] as? [[String: String]],
//                          let result = try? JSONDecoder().decode(Top.self, from: dataTop250MoviesIMDB) else {
//                        return
//                    }
//
//                    var movieTest: [Movie] = []
//                    returnedMovieTest = movieTest
//                    for item in result.items {
//                        movieTest.append(item)
//                    }
//
//                } catch {
//                    print("Failed to parse: \(jsonStringTop250MoviesIMDB)")
//                }
        
        
    }
    
   //MARK: -QuestionFactoryDelegate
    
    func didRecieveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    func didShowAlert(controller: UIAlertController?) {
        guard let controller = controller else {
            return
        }
        present(controller, animated: true, completion: nil)
    }
    
    
}
    
    
/*
 Mock-данные
 
 
 Картинка: The Godfather
 Настоящий рейтинг: 9,2
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Dark Knight
 Настоящий рейтинг: 9
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Kill Bill
 Настоящий рейтинг: 8,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Avengers
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Deadpool
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Green Knight
 Настоящий рейтинг: 6,6
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Old
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: The Ice Age Adventures of Buck Wild
 Настоящий рейтинг: 4,3
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: Tesla
 Настоящий рейтинг: 5,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: Vivarium
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
*/
