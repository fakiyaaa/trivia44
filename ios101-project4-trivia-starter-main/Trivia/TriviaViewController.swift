//
//  ViewController.swift
//  Trivia
//
//  Created by Mari Batilando on 4/6/23.
//

import UIKit

class TriviaViewController: UIViewController {

    @IBOutlet weak var currentQuestionNumberLabel: UILabel!
    @IBOutlet weak var questionContainerView: UIView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var answerButton0: UIButton!
    @IBOutlet weak var answerButton1: UIButton!
    @IBOutlet weak var answerButton2: UIButton!
    @IBOutlet weak var answerButton3: UIButton!

    private var questions = [TriviaQuestion]()
    private var currQuestionIndex = 0
    private var numCorrectQuestions = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        addGradient()
        questionContainerView.layer.cornerRadius = 8.0
        fetchTriviaQuestions()
    }

    private func fetchTriviaQuestions() {
        TriviaQuestionService.fetchQuestion(amount: 10) { [weak self] response in
            self?.questions = response.results
            self?.updateQuestion(withQuestionIndex: 0)
        }
    }

    private func updateQuestion(withQuestionIndex questionIndex: Int) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            guard !self.questions.isEmpty else {
                print("No questions available")
                return
            }
            
            guard questionIndex >= 0 && questionIndex < self.questions.count else {
                print("Invalid question index")
                return
            }

            let question = self.questions[questionIndex]
            self.currentQuestionNumberLabel.text = "Question: \(questionIndex + 1)/\(self.questions.count)"
            self.questionLabel.text = question.question.convertHTMLEntities()
            questionLabel.numberOfLines = 0
            questionLabel.lineBreakMode = .byTruncatingTail
            self.categoryLabel.text = question.category.convertHTMLEntities()
            let answers = ([question.correctAnswer] + question.incorrectAnswers).shuffled()
            if answers.count > 0 {
                self.answerButton0.setTitle(answers[0], for: .normal)
                self.answerButton1.isHidden = true
                self.answerButton2.isHidden = true
                self.answerButton3.isHidden = true
            }
            if answers.count > 1 {
                self.answerButton1.setTitle(answers[1], for: .normal)
                self.answerButton1.isHidden = false
            }
            if answers.count > 2 {
                self.answerButton2.setTitle(answers[2], for: .normal)
                self.answerButton2.isHidden = false
            }
            if answers.count > 3 {
                self.answerButton3.setTitle(answers[3], for: .normal)
                self.answerButton3.isHidden = false
            }
        }
    }


    private func updateToNextQuestion(answer: String) {
        if isCorrectAnswer(answer) {
            numCorrectQuestions += 1
        }
        currQuestionIndex += 1
        guard currQuestionIndex < questions.count else {
            showFinalScore()
            return
        }
        updateQuestion(withQuestionIndex: currQuestionIndex)
    }

    private func isCorrectAnswer(_ answer: String) -> Bool {
        return answer == questions[currQuestionIndex].correctAnswer
    }

    private func showFinalScore() {
        let alertController = UIAlertController(title: "Game over!",
                                                message: "Final score: \(numCorrectQuestions)/\(questions.count)",
                                                preferredStyle: .alert)
        let resetAction = UIAlertAction(title: "Restart", style: .default) { [unowned self] _ in
            currQuestionIndex = 0
            numCorrectQuestions = 0
            self.questions.removeAll()
            self.fetchTriviaQuestions()
        }
        alertController.addAction(resetAction)
        present(alertController, animated: true, completion: nil)
    }

    private func addGradient() {
        let gradientLayer =
CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor(red: 0.54, green: 0.88, blue: 0.99, alpha: 1.00).cgColor,
                                UIColor(red: 0.51, green: 0.81, blue: 0.97, alpha: 1.00).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        view.layer.insertSublayer(gradientLayer, at: 0)
    }

    @IBAction func didTapAnswerButton0(_ sender: UIButton) {
        updateToNextQuestion(answer: sender.titleLabel?.text ?? "")
    }

    @IBAction func didTapAnswerButton1(_ sender: UIButton) {
        updateToNextQuestion(answer: sender.titleLabel?.text ?? "")
    }

    @IBAction func didTapAnswerButton2(_ sender: UIButton) {
        updateToNextQuestion(answer: sender.titleLabel?.text ?? "")
    }

    @IBAction func didTapAnswerButton3(_ sender: UIButton) {
        updateToNextQuestion(answer: sender.titleLabel?.text ?? "")
    }
}
