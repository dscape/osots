class Result < ActiveRecord::Base
  belongs_to :user
  
  validates_presence_of :passed
end
