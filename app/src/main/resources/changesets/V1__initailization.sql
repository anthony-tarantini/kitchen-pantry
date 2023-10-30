CREATE TABLE pantry_user
(
   id             SERIAL PRIMARY KEY,
   username       VARCHAR(255) NOT NULL,
   user_image_url VARCHAR(255) NOT NULL,
   email          VARCHAR(255) NOT NULL
);

CREATE TABLE item
(
   id   SERIAL PRIMARY KEY,
   name     VARCHAR(255) NOT NULL,
   imageUrl VARCHAR(100),
   tags     JSON
);

CREATE TABLE keyword
(
   id    SERIAL PRIMARY KEY,
   value VARCHAR(255) NOT NULL
);

CREATE TABLE item_keyword
(
   id         SERIAL PRIMARY KEY,
   item_id    INTEGER NOT NULL,
   keyword_id INTEGER NOT NULL
);

CREATE TABLE user_item
(
   id          SERIAL PRIMARY KEY,
   user_id     INTEGER          NOT NULL,
   item_id     INTEGER          NOT NULL,
   measurement VARCHAR(100)     NOT NULL,
   value       DOUBLE PRECISION NOT NULL
);

CREATE UNIQUE INDEX idx_user_email_unique ON pantry_user (email);
CREATE UNIQUE INDEX idx_user_item_unique ON user_item (user_id, item_id);
CREATE INDEX idx_user_item_user ON user_item (user_id);
