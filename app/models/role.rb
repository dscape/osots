class Role < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_and_belongs_to_many :rights

  validates_presence_of :name
  validates_uniqueness_of :name

  def set_name=(name)
    self.name = name.downcase
  end
end
