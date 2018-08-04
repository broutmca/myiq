class Question < ApplicationRecord
  belongs_to :subject
  belongs_to :user
  has_many :question_answers
  has_many :answers, through: :question_answers
  has_many :question_options
  has_many :options, through: :question_options
end
