class CreateExams < ActiveRecord::Migration
  def self.up
    create_table :exams do |t|
      t.integer :total_time
      t.integer :per_question
      t.integer :nr_questions
      t.timestamps
    end
    
    create_table :exams_questions, :id => false do |t|
      t.integer :exam_id
      t.integer :question_id
      t.timestamps
    end
  end

  def self.down
    drop_table :exams
    drop_table :exams_questions
  end
end
