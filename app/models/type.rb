class Type < ActiveRecord::Base
  has_many :organizations
  has_many :users
end
