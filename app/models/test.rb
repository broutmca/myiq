class Test < ApplicationRecord
  validates :subject_id, presence: true
  validates :time_required, presence: true
  validates :number_of_questions, presence: true

  belongs_to :subject
  has_many :scores
  
  def update_question_details(q_details)
    questions = Question.joins(:answers).where({subject_id: q_details["subject_id"]}).limit(q_details["number_of_questions"])
    question_details = []
    questions.each_with_index do |q, index|
      answer = q.answers.limit(1)
      options = q.options.where.not(id: answer.first.id).where.not(title: answer.first.title).order("RAND()").limit(3).map(&:id)
      options << answer.first.id
      options.shuffle!
      question_details << {question_number: index+1 , question_id: q.id, option_ids: options, answer_id: answer.first.id}
    end
    self.question_details = question_details
  end
end