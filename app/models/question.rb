class Question < ActiveRecord::Base
  has_and_belongs_to_many :exams
  
  validates_presence_of     :document
  validates_length_of       :document, :minimum => 10
  validates_xml             :document
  
  def self.find_all_and_return_xml_table
    # with scope please
    # see code for creating views in the migration
    find_by_sql('select * from questions_v')
  end

  def self.find_by_id_and_return_xml_table(id)
    find_by_sql("select * from questions_v where questions_v.id = #{id}" +
                " fetch first 1 rows only").first
  end
end
