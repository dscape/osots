class CreateTypes < ActiveRecord::Migration
  def self.up
    create_table :types do |t|
      t.string :name

      t.timestamps
    end
    
    add_column :users, :type_id, :integer
    
    Type.create(:name => 'Faculty')
    Type.create(:name => 'Student')
    Type.create(:name => 'Professional')
  end

  def self.down
    drop_table :types
  end
end
