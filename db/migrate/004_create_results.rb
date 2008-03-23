class CreateResults < ActiveRecord::Migration
  def self.up
    create_table :results do |t|
      t.integer :user_id
      t.integer :exam_session_id
      t.integer :score
      t.boolean :passed, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :results
  end
end