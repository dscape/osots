class CreateExamSessions < ActiveRecord::Migration
  def self.up
    create_table :exam_sessions do |t|
      t.integer :user_id
      t.integer :exam_id
      t.integer :current_question, :default => 1
      t.timestamps
    end
  end

  def self.down
    drop_table :exam_sessions
  end
end