require_relative 'questions_database'
# require_relative 'question'
# require_relative 'question_follows'
# require_relative 'user'
# require_relative 'reply'
# require_relative 'question_likes'
require 'byebug'
#debugger
class ModelBase
  TABLE_CIPHER = {
  'User' => 'users',
  'Question' => 'questions',
  'Reply' => 'replies',
  'QuestionFollows' => 'question_follows',
  'QuestionLikes' => 'question_likes'
  }

  def self.find_by_id(target_id)
    data = QuestionsDatabase.instance.get_first_row(<<-SQL, target_id)
    SELECT
      *
    FROM
      #{TABLE_CIPHER[self.to_s]}
    WHERE
      #{TABLE_CIPHER[self.to_s]}.id = ?
    SQL
    self.new(data)
  end

  def self.all
    data = QuestionsDatabase.instance.execute(<<-SQL)
    SELECT
      *
    FROM
      #{TABLE_CIPHER[self.to_s]}
    SQL
    data.map do |m|
      self.new(m)
    end
  end

  # def save
  #   raise "already saved" if @id
  #   variables = self.instance_variables
  #   variables.delete(@id)
  #   variables.map {|var| self.instance_variable_get(var)}
  #   # hash = {}
  #   # variables.each do |instance|
  #   #   hash[instance] = "@" + instance.to_s
  #   # end
  #
  #   QuestionsDatabase.instance.execute(<<-SQL, *variables)
  #     INSERT INTO
  #       #{TABLE_CIPHER[self]} (#{*variables})
  #     VALUES
  #       (#{(['?']*variables.size).join(', ')})
  #   SQL
  #   @id = QuestionsDatabase.instance.last_insert_row_id
  # end



end
