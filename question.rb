require_relative 'questions_database'
require_relative 'reply'
require_relative 'question_follows'
require_relative 'model_base'

class Question < ModelBase
  attr_accessor :id, :author_id, :title, :body

  # def self.find_by_id(target_id)
  #   data = QuestionsDatabase.instance.get_first_row(<<-SQL, target_id)
  #   SELECT
  #     *
  #   FROM
  #     questions
  #   WHERE
  #     questions.id = ?
  #   SQL
  #   Question.new(data)
  # end

  def self.find_by_author_id(target_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, target_id)
    SELECT
      *
    FROM
      questions
    WHERE
      questions.author_id = ?
    SQL

    data.map do |question|
      Question.new(question)
    end
  end

  def initialize(options_hash)
    @id = options_hash['id']
    @title = options_hash['title']
    @body = options_hash['body']
    @author_id = options_hash['author_id']
  end

  def author
    author_details = QuestionsDatabase.instance.get_first_row(<<-SQL, @author_id)
    SELECT
      *
    FROM
      users
    WHERE
      users.id = ?
    SQL

    User.new(author_details)
  end

  def replies
    Reply.find_by_subject_question_id(@id)
  end

  def followers
    QuestionFollows.followers_for_question_id(@id)
  end

  def self.most_followed(n)
    QuestionFollows.most_followed_questions(n)
  end

  def likers
    QuestionLikes.likers_for_question(@id)
  end

  def num_likes
    QuestionLikes.num_likes_for_question(@id)
  end

  def self.most_liked(n)
    QuestionLikes.most_liked_questions(n)
  end

  def save
    raise "already saved" if @id
    QuestionsDatabase.instance.execute(<<-SQL, @title, @body, @author_id)
      INSERT INTO
        questions (title, body, author_id)
      VALUES
        (?, ?, ?)
    SQL
    @id = QuestionsDatabase.instance.last_insert_row_id
  end

  def update
    raise "#{@title}, not in database" unless @id
    QuestionsDatabase.instance.execute(<<-SQL, @title, @body, @author_id, @id)
      UPDATE
        questions
      SET
        title = ?, body = ?, author_id = ?
      WHERE
        id = ?
    SQL
  end

end
