DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS leaderboard;
DROP TABLE IF EXISTS locations;
DROP TABLE IF EXISTS quests;
DROP TABLE IF EXISTS quest_locations;
DROP TABLE IF EXISTS user_quest_locations_status;

CREATE TABLE users (
  id serial PRIMARY KEY,
  first_name varchar NOT NULL,
  last_name varchar NOT NULL,
  email varchar NOT NULL,
  password_hash varchar NOT NULL
);

CREATE TABLE leaderboard (
  user_id int NOT NULL REFERENCES users(id),
  points int NOT NULL DEFAULT 0

  PRIMARY KEY (user_id)
);

CREATE TABLE locations (
  id serial PRIMARY KEY,
  latitude decimal NOT NULL,
  longitude decimal NOT NULL,
  description text NOT NULL,
  thumbnail text NOT NULL
);

CREATE TABLE quests (
  id serial PRIMARY KEY,
  name varchar NOT NULL,
  thumnail text NOT NULL
);

CREATE TABLE quest_locations (
  quest_id int NOT NULL REFERENCES quests(id),
  location_id int NOT NULL REFERENCES locations(id),
  points decimal NOT NULL

  PRIMARY KEY (quest_id, location_id)
);

CREATE TYPE location_status ('active', 'complete');

CREATE TABLE user_quest_locations_status (
  user_id int NOT NULL REFERENCES users(id),
  quest_id int NOT NULL REFERENCES quests(id),
  location_id int NOT NULL REFERENCES locations(id),
  status location_status NOT NULL DEFAULT 'active'

  PRIMARY KEY (user_id, quest_id, location_id)
);

