class Option < ApplicationRecord
  has_many :question_options
  has_many :questions, through: :question_options
end
