require_relative 'questions_database'

class ModelBase
  TABLE_CIPHER = {
  User => users,
  Question => questions,
  Reply => replies,
  QuestionFollows => question_follows,
  QuestionLikes => question_likes
  }
  def find_by_id(target_id)
    data = QuestionsDatabase.instance.get_first_row(<<-SQL, target_id)
    SELECT
      *
    FROM
      #{TABLE_CIPHER[self]}
    WHERE
      #{TABLE_CIPHER[self]}.id = ?
    SQL
    self.new(data)
  end
end
