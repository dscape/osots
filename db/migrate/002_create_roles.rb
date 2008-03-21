class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table :roles_users, :id => false do |t|
      t.integer :role_id
      t.integer :user_id
      t.timestamps
    end

    create_table :roles do |t|
      t.string :name
      t.timestamps
    end

    create_table :rights_roles, :id => false do |t|
      t.integer :right_id
      t.integer :role_id
      t.timestamps
    end

    create_table :rights do |t|
      t.string :name
      t.string :controller
      t.string :action
      t.timestamps
    end
    
    #########
    # ROLES #
    #########
    Role.create(:name => 'root')
    contributor = Role.create(:name => 'contributor')
    ambassador  = Role.create(:name => 'ambassador')
    
    ##########
    # RIGHTS #
    ##########
      
      ########
      # ROOT #
      ########
      # Has all rights hardcoded.
      
      ###############
      # CONTRIBUTOR #
      ###############
      # Can access all the seven rest actions in questions.
      q1 = Right.create(:name => 'questions_index',   :controller => 'questions', :action => 'index' )
      q2 = Right.create(:name => 'questions_show',    :controller => 'questions', :action => 'show' )
      q3 = Right.create(:name => 'questions_edit',    :controller => 'questions', :action => 'edit' )
      q4 = Right.create(:name => 'questions_update',  :controller => 'questions', :action => 'update' )
      q5 = Right.create(:name => 'questions_destroy', :controller => 'questions', :action => 'destroy' )
      q6 = Right.create(:name => 'questions_new',     :controller => 'questions', :action => 'new' )
      q7 = Right.create(:name => 'questions_create',  :controller => 'questions', :action => 'create' )
      
      contributor.rights << q1 << q2 << q3 << q4 << q5 << q6 << q7

      ###############
      # AMBASSADOR  #
      ###############
      # Defines what a ambassador can do.
      
  end

  def self.down
    drop_table :roles_users
    drop_table :roles
    drop_table :rights
    drop_table :rights_roles
  end
end