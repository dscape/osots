class ExamSessions < ActiveRecord::Base
  belongs_to :user
  belongs_to :exam
  has_many :answers
end
