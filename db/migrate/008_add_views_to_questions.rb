class AddViewsToQuestions < ActiveRecord::Migration
  def self.up
    sql_v = %(CREATE VIEW questions_v (id, difficulty, topic, language, author,
                                       minutes_allocated, question_text, 
                                       choice_a, choice_b, choice_c, choice_d, 
                                       choice_e, correct_choice) 
               AS
                 SELECT E.id, X.* 
                 FROM ots_schema.questions E,
                   XMLTABLE ('$d/question' passing document as "d"
                     COLUMNS 
       difficulty        VARCHAR(20)  PATH '@difficulty',
       topic             VARCHAR(40)  PATH '@topic',
       language          VARCHAR(20)  PATH '@language',
       author            VARCHAR(40)  PATH 'fn:normalize-space(author/user_ID)',
       minutes_allocated INTEGER      PATH 'minutes_allocated',
       question_text     VARCHAR(200) PATH 'fn:normalize-space(question_text)',
       choice_a          VARCHAR(150) PATH 'fn:normalize-space(answer/choiceA)',
       choice_b          VARCHAR(150) PATH 'fn:normalize-space(answer/choiceB)',
       choice_c          VARCHAR(150) PATH 'fn:normalize-space(answer/choiceC)',
       choice_d          VARCHAR(150) PATH 'fn:normalize-space(answer/choiceD)',
       choice_e          VARCHAR(150) PATH 'fn:normalize-space(answer/choiceE)',
       correct_choice    VARCHAR(10)  PATH 'name(answer/*[@type])'
                   ) as X)

    # execute the create view
    execute sql_v
  end

  def self.down
    # drop the view
    execute 'drop view ots_schema.questions_v'
  end
end
