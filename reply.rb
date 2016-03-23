require_relative 'questions_database'

class Reply

  def self.find_by_id(target_id)
    data = QuestionsDatabase.instance.get_first_row(<<-SQL, target_id)
    SELECT
      *
    FROM
      replies
    WHERE
      replies.id = ?
    SQL
    Reply.new(data)
  end

  def self.find_by_subject_question_id(target_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, target_id)
    SELECT
      *
    FROM
      replies
    WHERE
      replies.subject_question_id = ?
    SQL
    data.map do |reply|
      Reply.new(reply)
    end
  end

  def self.find_by_parent_reply_id(target_id)
    data = QuestionsDatabase.instance.get_first_row(<<-SQL, target_id)
    SELECT
      *
    FROM
      replies
    WHERE
      replies.parent_reply_id = ?
    SQL
    Reply.new(data)
  end

  def self.find_by_replier_id(target_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, target_id)
    SELECT
      *
    FROM
      replies
    WHERE
      replies.replier_id = ?
    SQL

    data.map do |reply|
      Reply.new(reply)
    end
  end

  def author
    author_details = QuestionsDatabase.instance.get_first_row(<<-SQL, @replier_id)
    SELECT
      *
    FROM
      users
    WHERE
      users.id = ?
    SQL

    User.new(author_details)
  end

  def question
    question_details = QuestionsDatabase.instance.get_first_row(<<-SQL, @subject_question_id)
    SELECT
      *
    FROM
      questions
    WHERE
      questions.id = ?
    SQL

    Question.new(question_details)
  end

  def parent_reply
    parent_details = QuestionsDatabase.instance.get_first_row(<<-SQL, @parent_reply_id)
    SELECT
      *
    FROM
      replies
    WHERE
      replies.id = ?
    SQL

    Reply.new(parent_details)
  end

  def child_reply
    child_details = QuestionsDatabase.instance.get_first_row(<<-SQL, @id)
    SELECT
      *
    FROM
      replies
    WHERE
      replies.parent_reply_id = ?
    SQL
    Reply.new(child_details)
  end

  def initialize(options)
    @id = options['id']
    @subject_question_id = options['subject_question_id']
    @parent_reply_id = options['parent_reply_id']
    @replier_id = options['replier_id']
    @body = options['body']
  end

  def save
    raise "already saved" if @id
    QuestionsDatabase.instance.execute(<<-SQL, @subject_question_id, @parent_reply_id, @replier_id, @body)
      INSERT INTO
        replies (subject_question_id, parent_reply_id, replier_id, body)
      VALUES
        (?, ?, ?, ?)
    SQL
    @id = QuestionsDatabase.instance.last_insert_row_id
  end

  def update
    raise "Reply not in database" unless @id
    QuestionsDatabase.instance.execute(<<-SQL, @subject_question_id, @parent_reply_id, @replier_id, @body, @id)
      UPDATE
        replies
      SET
        subject_question_id = ?, parent_reply_id = ?, replier_id = ?, body = ?
      WHERE
        id = ?
    SQL
  end

end
