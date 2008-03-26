class Right < ActiveRecord::Base
  has_and_belongs_to_many :roles
  
  validates_presence_of :name, :controller, :action
  validates_uniqueness_of :name

  def set_name=(name)
    self.name = name.downcase
  end
  
  def set_controller=(controller)
    self.controller = controller.downcase
  end
  
  def set_action=(action)
    self.action = action.downcase
  end
end
