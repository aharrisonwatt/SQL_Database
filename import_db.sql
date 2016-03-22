CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL,
);

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  body VARCHAR(255) NOT NULL,
  author_id INTEGER NOT NULL,
  FOREIGN KEY (author_id) REFERENCES users(id)
);

#what is the correct style code for placing foeign key
CREATE TABLE question_follows (
  question_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,
  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (user_id) REFERENCES users(id),
);

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  subject_question_id INTEGER NOT NULL,
  parent_reply_id INTEGER,
  replier_id INTEGER NOT NULL,
  body VARCHAR(255) NOT NULL,
  FOREIGN KEY (subject_question_id) REFERENCES questions(id),
  FOREIGN KEY (parent_reply_id) REFERENCES replies(id),
  FOREIGN KEY (replier_id) REFERENCES users(id)
);

CREATE TABLE question_likes (
  liker_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
  FOREIGN KEY (liker_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

INSERT INTO
  users (fname, lname)
VALUES
  ('F1', 'L1'), ('F2', 'L2'), ('F3', 'L3'), ('F4', 'L4')

INSERT INTO
  questions (title, body, author_id)
VALUES
  ('T1', 'B1', 1), ('T2', 'B2', 2), ('T3', 'B3', 3), ('T4', 'B4', 4)

INSERT INTO
  question_follows (question_id, user_id)

INSERT INTO
  replies (subject_question_id, parent_reply_id, replier_id, body)
VALUES
  (1, NULL, 1, 'BR1'), (2, 1, 2, 'BR2'), (3, NULL, 3, 'BR3'), (4, NULL, 4, 'BR4')
