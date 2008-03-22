class CreateAnswers < ActiveRecord::Migration
  def self.up
    create_table :answers do |t|
      t.integer :exam_session_id
      t.integer :question_id
      t.string  :option, :limit => 15
      t.timestamps
    end
  end

  def self.down
    drop_table :answers
  end
end
