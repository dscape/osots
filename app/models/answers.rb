class Answers < ActiveRecord::Base
  belongs_to :exam_session
  
  validates_presence_of :option
  validates_length_of   :option,    :maximum => 15
end
