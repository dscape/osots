class Exam < ActiveRecord::Base
  has_and_belongs_to_many :questions
  has_many :exam_sessions
  
  validates_presence_of :total_time, :per_question, :nr_questions
  validates_numericality_of :total_time, :per_question, :nr_questions
end
