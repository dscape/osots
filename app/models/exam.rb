class Exam < ActiveRecord::Base
  has_and_belongs_to_many :questions
  has_many :exam_sessions
  
  validates_presence_of :total_time, :per_question, :nr_questions
  validates_numericality_of :total_time, :per_question, :nr_questions

  def self.find_questions_by_exam_id(id)
     query = %(SELECT questions_v.id AS id,
                      difficulty,
                      topic,
                      language,
                      author,
                      minutes_allocated,
                      question_text,
                      choice_a,
                      choice_b,
                      choice_c,
                      choice_d,
                      choice_e,
                      correct_choice
               FROM exams 
                 LEFT OUTER JOIN exams_questions 
                   ON exams_questions.exam_id = exams.id 
                 LEFT OUTER JOIN questions_v
                   ON questions_v.id = exams_questions.question_id 
                   WHERE (exams.id = #{id}))
    find_by_sql query
  end
end
