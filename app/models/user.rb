require 'digest/sha1'

################################################################################
# osots: user model                                                            #
# author: nunojobpinto[at]gmail[dot]com                                        #    
################################################################################
class User < ActiveRecord::Base
  ##############################################################################
  # database relationships                                                     #
  ##############################################################################
  belongs_to :organization
  belongs_to :type
  has_and_belongs_to_many :roles
  has_many :exam_sessions
  has_many :results, :through => :exam_sessions

  ##############################################################################
  # attributes                                                                 #
  ##############################################################################
  attr_accessor :password, :old_password
  attr_accessible :login, :email#, :only => create
  attr_accessible :old_password, :password, :type_id, :organization_id,
                  :password_confirmation, :name, :homepage, :about, :country

  ##############################################################################
  # validations                                                                #
  ##############################################################################
  # indexes: login, email
  validates_presence_of     :login, :type_id, :country
                         #, :only => create
  validates_length_of       :login,    :within => 3..100
                         #, :only => create

  validates_uniqueness_of   :login, :case_sensitive => false
                         #, :only => create
  validates_format_of       :login, 
                            :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
                         #, :only => create

  # password  
  validates_presence_of     :password,                :if => :password_required?
  validates_presence_of     :password_confirmation,   :if => :password_required?
  validates_length_of       :password, :within => 4..40, 
                                                      :if => :password_required?
  validates_confirmation_of :password,                :if => :password_required?

  # name
  validates_presence_of     :name,                        :if => :name_required?
  
  # homepage
  validates_length_of     :homepage, :maximum => 125, :if => :homepage_required?
  validates_format_of       :homepage,
 :with => /(^$)|(^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$)/ix,
                      :if => :homepage_required?

  ##############################################################################
  # before filters                                                             #
  ##############################################################################
  before_create :make_activation_code 
  before_save :encrypt_password

  ##############################################################################
  # acts_as_state_machine                                                      #
  ##############################################################################
  acts_as_state_machine :initial => :pending
  state :passive
  state :pending, :enter => :make_activation_code
  state :active,  :enter => :do_activate
  state :suspended
  state :deleted, :enter => :do_delete

  event :register do
    transitions :from => :passive, :to => :pending, 
    :guard => Proc.new {|u| !(u.crypted_password.blank? && u.password.blank?) }
  end
  
  event :activate do
    transitions :from => :pending, :to => :active 
  end
  
  event :suspend do
    transitions :from => [:passive, :pending, :active], :to => :suspended
  end
  
  event :delete do
    transitions :from => [:passive, :pending, :active, :suspended], 
                :to => :deleted
  end

  event :unsuspend do
    transitions :from => :suspended, :to => :active,  
    :guard => Proc.new {|u| !u.activated_at.blank? }
    transitions :from => :suspended, :to => :pending, 
    :guard => Proc.new {|u| !u.activation_code.blank? }
    transitions :from => :suspended, :to => :passive
  end
  
  ##############################################################################
  # name                                                                       #
  ##############################################################################  
  def name
    [first_name, last_name].join(' ')
  end

  def name=(name)
    split = name.split(' ')
    unless split.size < 2
      self.first_name = split.first
      self.last_name = split.last
    else
      self.first_name = name
      self.last_name  = ""
    end
  end
  
  ##############################################################################
  # restful_authetication stuff                                                #
  ##############################################################################
  def self.authenticate(login, password)
    u = find_in_state :first, :active, :conditions => {:login => login} 
    u && u.authenticated?(password) ? u : nil
  end

  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at 
  end

  def remember_me
    remember_me_for 2.weeks
  end

  def remember_me_for(time)
    remember_me_until time.from_now.utc
  end

  def remember_me_until(time)
    self.remember_token_expires_at = time
    self.remember_token     = encrypt("#{email}--#{remember_token_expires_at}")
    save(false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(false)
  end
  
  ##############################################################################
  # protected methods                                                          #
  ##############################################################################
  protected

  def encrypt_password
    return if password.blank?
    self.salt = 
         Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--") if new_record?
    self.crypted_password = encrypt(password)
  end

  def make_activation_code
    self.deleted_at = nil
    self.activation_code = 
           Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
  end

  def do_delete
    self.deleted_at = Time.now
  end

  def do_activate
    self.activated_at = Time.now
    self.deleted_at = self.activation_code = nil
  end
      
  def password_required?
    crypted_password.blank? || !password.blank?
  end

  def name_required?
    !name.blank?
  end
      
  def homepage_required?
    !homepage.blank?
  end
end
