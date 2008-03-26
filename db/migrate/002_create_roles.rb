################################################################################
# osots: create roles migration                                            002 #
# author: nunojobpinto[at]gmail[dot]com                                        #    
################################################################################
class CreateRoles < ActiveRecord::Migration
  ##############################################################################
  # version: UP                                                                #
  ##############################################################################
  def self.up
    ############################################################################
    # create: roles table                                                      #
    ############################################################################
    create_table :roles do |t|
      t.string :name,            :limit => 40,  :null => false
      t.timestamps
    end

    ############################################################################
    # create: rights table                                                     #
    ############################################################################
    create_table :rights do |t|
      t.string :name,           :limit => 40,  :null => false
      t.string :controller
      t.string :action
      t.timestamps
    end

    ############################################################################
    # create: roles users joint table                                          #
    ############################################################################
    create_table :roles_users, :id => false do |t|
      t.integer :role_id
      t.integer :user_id
      t.timestamps
    end

    ############################################################################
    # create: rights roles joint table                                         #
    ############################################################################
    create_table :rights_roles, :id => false do |t|
      t.integer :right_id
      t.integer :role_id
      t.timestamps
    end

    ############################################################################
    # create indexes for tables roles and rights                               #
    ############################################################################
    add_index :'ots_schema.roles',  :name
    add_index :'ots_schema.rights', :name
    
    ############################################################################
    # populate database                                                        #
    ############################################################################
      ##########################################################################
      # table: roles                                                           #
      ##########################################################################
      root        = Role.create(:name => 'root')
      contributor = Role.create(:name => 'contributor')
      ambassador  = Role.create(:name => 'ambassador')
    
      ##########################################################################
      # table: rights                                                          #
      ##########################################################################
      
        ########################################################################
        # rights for the root role                                             #
        ########################################################################
        # Has all rights hardcoded.
      
        ########################################################################
        # rights for the contributor role                                      #
        ########################################################################
        # Can access all the seven rest actions in questions.
        q1 = Right.create(:name => 'questions_index',
                          :controller => 'questions',
                          :action => 'index' )
        q2 = Right.create(:name => 'questions_show',
                          :controller => 'questions',
                          :action => 'show' )
        q3 = Right.create(:name => 'questions_edit',
                          :controller => 'questions',
                          :action => 'edit' )
        q4 = Right.create(:name => 'questions_update',
                          :controller => 'questions',
                          :action => 'update' )
        q5 = Right.create(:name => 'questions_destroy',
                          :controller => 'questions',
                          :action => 'destroy' )
        q6 = Right.create(:name => 'questions_new',
                          :controller => 'questions',
                          :action => 'new' )
        q7 = Right.create(:name => 'questions_create',
                          :controller => 'questions',
                          :action => 'create' )

        contributor.rights << q1 << q2 << q3 << q4 << q5 << q6 << q7

        ########################################################################
        # rights for the ambassador role                                       #
        ########################################################################
        # Defines what a ambassador can do.
      
  end
  
  ##############################################################################
  # version: DOWN                                                                #
  ##############################################################################
  def self.down
    ############################################################################
    # drop: roles, rights, roles_users, roles_rights tables                    #
    ############################################################################
    drop_table :roles_users
    drop_table :roles
    drop_table :rights
    drop_table :rights_roles
  end
end
