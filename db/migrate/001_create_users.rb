class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table "users", :force => true do |t|
      t.string   :first_name
      t.string   :last_name
      t.text     :about
      t.string   :homepage
      t.string   :login
      t.string   :email
      t.string   :crypted_password,         :limit => 40
      t.string   :salt,                     :limit => 40
      t.string   :remember_token
      t.datetime :remember_token_expires_at
      t.datetime :last_login_at
      t.string   :activation_code,          :limit => 40
      t.string   :password_reset_code,      :limit => 40
      t.datetime :activated_at
      t.string   :state,                    :null => :no, :default => 'passive'
      t.datetime :deleted_at
      t.timestamps
    end
  end

  def self.down
    drop_table "users"
  end
end
