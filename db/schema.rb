# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 8) do

  create_table "answers", :force => true do |t|
    t.integer   "exam_session_id"
    t.integer   "question_id"
    t.string    "option",          :limit => 15
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "exam_sessions", :force => true do |t|
    t.integer   "user_id"
    t.integer   "exam_id"
    t.integer   "current_question", :default => 1
    t.boolean   "finished",         :default => false
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "exams", :force => true do |t|
    t.integer   "total_time"
    t.integer   "per_question"
    t.integer   "nr_questions"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "exams_questions", :id => false, :force => true do |t|
    t.integer   "exam_id"
    t.integer   "question_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "questions", :force => true do |t|
    t.xml       "document",   :null => false
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "questions_v", :force => true do |t|
    t.string  "difficulty",        :limit => 20
    t.string  "topic",             :limit => 40
    t.string  "language",          :limit => 20
    t.string  "author",            :limit => 40
    t.integer "minutes_allocated"
    t.string  "question_text",     :limit => 200
    t.string  "choice_a",          :limit => 150
    t.string  "choice_b",          :limit => 150
    t.string  "choice_c",          :limit => 150
    t.string  "choice_d",          :limit => 150
    t.string  "choice_e",          :limit => 150
    t.string  "correct_choice",    :limit => 10
  end

  create_table "results", :force => true do |t|
    t.integer   "exam_session_id"
    t.integer   "score"
    t.boolean   "passed",          :default => false
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "rights", :force => true do |t|
    t.string    "name"
    t.string    "controller"
    t.string    "action"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "rights_roles", :id => false, :force => true do |t|
    t.integer   "right_id"
    t.integer   "role_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "roles", :force => true do |t|
    t.string    "name"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  add_index "roles", ["name"], :name => "roles_on_name"

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer   "role_id"
    t.integer   "user_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string    "first_name"
    t.string    "last_name"
    t.text      "about",                     :limit => 1048576
    t.string    "homepage"
    t.string    "login"
    t.string    "email"
    t.string    "crypted_password",          :limit => 40
    t.string    "salt",                      :limit => 40
    t.string    "remember_token"
    t.timestamp "remember_token_expires_at"
    t.timestamp "last_login_at"
    t.string    "activation_code",           :limit => 40
    t.string    "password_reset_code",       :limit => 40
    t.timestamp "activated_at"
    t.string    "state",                                        :default => "passive"
    t.timestamp "deleted_at"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  add_index "users", ["email"], :name => "users_on_email"
  add_index "users", ["login"], :name => "users_on_login"

end
