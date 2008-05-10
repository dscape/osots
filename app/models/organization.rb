class Organization < ActiveRecord::Base
  belongs_to :type
  has_many :users
end
