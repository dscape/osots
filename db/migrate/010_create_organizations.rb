class CreateOrganizations < ActiveRecord::Migration
  def self.up
    create_table :organizations do |t|
      t.string :name
      t.integer :type_id
      t.timestamps
    end

   add_column :users, :organization_id, :integer

   student      = Type.find_by_name 'Student'
   faculty      = Type.find_by_name 'Faculty'
   professional = Type.find_by_name 'Professional'

    Organization.create(:name => 'Universidade do Minho',
                        :type_id => student.id)

    Organization.create(:name => 'Universidade do Minho',
                        :type_id => faculty.id)

    Organization.create(:name => 'IBM',
                        :type_id => professional.id)
  end

  def self.down
    drop_table :organizations
  end
end
