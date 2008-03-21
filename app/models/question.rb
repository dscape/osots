class Question < ActiveRecord::Base
  validates_presence_of     :document
  validates_length_of       :document, :minimum => 10
  validates_xml             :document
end