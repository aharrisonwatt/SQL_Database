require_relative 'questions_database'

class QuestionLikes

  def self.find_by_question_id(target_id)
    data = QuestionsDatabase.instance.get_first_row(<<-SQL, target_id)
    SELECT
      *
    FROM
      question_likes
    WHERE
      question_likes.question_id = ?
    SQL
    QuestionLikes.new(data)
  end

  def self.find_by_liker_id(target_id)
    data = QuestionsDatabase.instance.get_first_row(<<-SQL, target_id)
    SELECT
      *
    FROM
      question_likes
    WHERE
      question_likes.liker_id = ?
    SQL
    QuestionLikes.new(data)
  end

  def initialize(options)
    @liker_id = options['liker_id']
    @question_id = options['question_id']
  end

  def self.likers_for_question(question_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, question_id)
    SELECT
      users.*
    FROM
      question_likes
    JOIN
      users
    ON
      users.id = question_likes.liker_id
    JOIN
      questions
    ON
      questions.id = question_likes.question_id
    WHERE
      questions.id = ?
    SQL
    data.map do |user_data|
      User.new(user_data)
    end
  end

  def self.num_likes_for_question(question_id)
    count_hash = QuestionsDatabase.instance.get_first_row(<<-SQL, question_id)
    SELECT
      COUNT(*)
    FROM
      questions
    JOIN
      question_likes
    ON
      questions.id = question_likes.question_id
    WHERE
      questions.id = ?
    SQL
    count_hash.values[0]
  end

  def self.liked_questions_for_user_id(user_id)
    question_data = QuestionsDatabase.instance.execute(<<-SQL, user_id)
    SELECT
      questions.*
    FROM
      question_likes
    JOIN
      users
    ON
      users.id = question_likes.liker_id
    JOIN
      questions
    ON
      questions.id = question_likes.question_id
    WHERE
      users.id = ?
    SQL

    question_data.map do |question|
      Question.new(question)
    end
  end

  def self.most_liked_questions(n)
    data = QuestionsDatabase.instance.execute(<<-SQL, n)
    SELECT
      questions.*
    FROM
      questions
    JOIN
      question_likes
    ON
      questions.id = question_likes.question_id
    GROUP BY
      question_likes.question_id
    ORDER BY
      COUNT(question_likes.question_id)
    LIMIT
      ?
    SQL
    data.map do |question|
      Question.new(question)
    end
  end


end
