require_relative 'questions_database'
require_relative 'question'
require_relative 'question_follows'

class User
  attr_accessor :id, :fname, :lname

  def self.find_by_id(target_id)
    data = QuestionsDatabase.instance.get_first_row(<<-SQL, target_id)
    SELECT
      *
    FROM
      users
    WHERE
      users.id = ?
    SQL
    User.new(data)
  end

  def self.find_by_name(fname, lname)
    data = QuestionsDatabase.instance.get_first_row(<<-SQL, fname, lname)
    SELECT
      *
    FROM
      users
    WHERE
      users.fname = ? AND
      users.lname = ?
    SQL
    User.new(data)
  end

  def authored_questions
    Question.find_by_author_id(@id)
  end

  def authored_replies
    Reply.find_by_replier_id(@id)
  end

  def initialize(options_hash)
    @id = options_hash['id']
    @fname = options_hash['fname']
    @lname = options_hash['lname']
  end

  def followed_questions
    QuestionFollows.followed_questions_for_user_id(@id)
  end

  def average_karma
    n = authored_questions.size
    total_likes = authored_questions.inject(0) {|sum, question| sum += question.num_likes}
    total_likes / n
  end

  def save
    raise "already saved" if @id
    QuestionsDatabase.instance.execute(<<-SQL, @fname, @lname)
      INSERT INTO
        users (fname, lname)
      VALUES
        (?, ?)
    SQL
    @id = QuestionsDatabase.instance.last_insert_row_id
  end

  def update
    raise "#{@fname}, #{@lname} not in database" unless @id
    QuestionsDatabase.instance.execute(<<-SQL, @fname, @lname, @id)
      UPDATE
        users
      SET
        fname = ?, lname = ?
      WHERE
        id = ?
    SQL
  end
end
