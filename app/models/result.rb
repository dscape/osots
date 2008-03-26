class Result < ActiveRecord::Base
  belongs_to :exam_sessions, :class_name => "ExamSessions", :foreign_key => "exam_session_id"
end
