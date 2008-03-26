################################################################################
# osots: create users migration                                            001 #
# author: nunojobpinto[at]gmail[dot]com                                        #    
################################################################################
class CreateUsers < ActiveRecord::Migration
  ##############################################################################
  # version: UP                                                                #
  ##############################################################################
  def self.up
    ############################################################################
    # create: users table                                                      #
    ############################################################################
    create_table :users do |t|
      t.string   :login,                        :limit => 40,  :null => false
      t.string   :email,                        :limit => 100, :null => false
      t.string   :first_name,                   :limit => 30 
      t.string   :last_name,                    :limit => 30
      t.text     :about
      t.string   :homepage,                     :limit => 125
      t.string   :crypted_password,             :limit => 40
      t.string   :salt,                         :limit => 40
      t.string   :remember_token
      t.datetime :remember_token_expires_at
      t.datetime :last_login_at
      t.string   :activation_code,              :limit => 40
      t.string   :password_reset_code,          :limit => 40
      t.datetime :activated_at
      t.string   :state, :default => 'passive', :limit => 30, :null => false
      t.datetime :deleted_at
      t.timestamps
    end

    ############################################################################
    # create indexes for table users                                           #
    ############################################################################
    # Once again fixing IBM_DB bugs the ugly way
    # with_scope anyone?
    add_index :'ots_schema.users', :login
    add_index :'ots_schema.users', :email
  end

  ##############################################################################
  # version: DOWN                                                              #
  ##############################################################################
  def self.down
    ############################################################################
    # drop: users table                                                        #
    ############################################################################
    drop_table :users
  end
end
