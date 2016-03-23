require_relative 'questions_database'
require_relative 'user'

class QuestionFollows
  attr_accessor :question_id, :user_id

  def self.find_by_question_id(target_id)
    data = QuestionsDatabase.instance.get_first_row(<<-SQL, target_id)
    SELECT
      *
    FROM
      question_follows
    WHERE
      question_follows.question_id = ?
    SQL
    QuestionFollows.new(data)
  end


  def self.find_by_user_id(target_id)
    data = QuestionsDatabase.instance.get_first_row(<<-SQL, target_id)
    SELECT
      *
    FROM
      question_follows
    WHERE
      question_follows.user_id = ?
    SQL
    QuestionFollows.new(data)
  end

  def self.followers_for_question_id(question_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, question_id)
    SELECT
      users.*
    FROM
      question_follows
    JOIN
      users
    ON
      users.id = question_follows.user_id
    JOIN
      questions
    ON
      questions.id = question_follows.question_id
    WHERE
      questions.id = ?
    SQL
    data.map do |user_data|
      User.new(user_data)
    end
  end

  def self.followed_questions_for_user_id(user_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, user_id)
    SELECT
      questions.*
    FROM
      question_follows
    JOIN
      users
    ON
      users.id = question_follows.user_id
    JOIN
      questions
    ON
      questions.id = question_follows.question_id
    WHERE
      users.id = ?
    SQL
    data.map do |question_data|
      Question.new(question_data)
    end
  end

  def initialize(options)
    @question_id = options['question_id']
    @user_id = options['user_id']
  end

  def self.most_followed_questions(n)
    data = QuestionsDatabase.instance.execute(<<-SQL, n)
    SELECT
      questions.*
    FROM
      questions
    JOIN
      question_follows
    ON
      questions.id = question_follows.question_id
    GROUP BY
      question_follows.question_id
    ORDER BY
      COUNT(question_follows.question_id)
    LIMIT
      ?
    SQL
    data.map do |question|
      Question.new(question)
    end
  end

end
