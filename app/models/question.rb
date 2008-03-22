class Question < ActiveRecord::Base
  has_and_belongs_to_many :exams
  
  validates_presence_of     :document
  validates_length_of       :document, :minimum => 10
  validates_xml             :document
end