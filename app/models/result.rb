class Result < ActiveRecord::Base
  belong_to :user
  
  validates_presence_of :passed
end
