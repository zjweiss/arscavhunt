DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS locations CASCADE;
DROP TABLE IF EXISTS quests CASCADE;
DROP TABLE IF EXISTS quest_locations CASCADE;
DROP TABLE IF EXISTS user_quest_locations_status CASCADE;

CREATE TABLE user (
  id serial PRIMARY KEY NOT NULl,
  first_name varchar NOT NULL,
  last_name varchar NOT NULL,
  username varchar NOT NULL,
);

INSERT INTO user (first_name, last_name, username)
VALUES
  ('Janice', 'Liu', 'jliu'),
  ('Rohan', 'Nagavardhan', 'rnagavar'),
  ('Shaan', 'Patel', 'pshaan'),
  ('Zach', 'Weiss', 'zjweiss'),
  ('Abbie', 'Tooman', 'atooman');


CREATE TABLE location (
  id serial PRIMARY KEY,
  name varchar NOT NULL,
  latitude decimal NOT NULL,
  longitude decimal NOT NULL,
  description text NOT NULL,
  thumbnail text NOT NULL, -- base64 encoded
  ar_enabled boolean NOT NULL,
  distance_threshold decimal NOT NULL -- meters
);

INSERT INTO location (name, latitude, longitude, description, thumbnail, ar_enabled, distance_threshold)
VALUES
  ('The Duderstadt Center', 42.2912, -83.7157, '', '', true, 100),
  ('Hatcher Graduate Library', 42.2763, -83.7380, '', '', false, 10),
  ('Law Library', 42.2738, -83.7391, '', '', true, 10),
  ('LSA Building', 42.275720, -83.740760, '', '', false, 30),
  ('Kinesiology Building', 42.274880, -83.740110, '', '', true, 10);
  ('UGLI', 42.2756, -83.7372, '', '', true, 10),
  ('The Fishbowl', 42.2767, -83.7396, '', '', true, 50),

CREATE TABLE tag (
  id serial PRIMARY KEY,
  name varchar NOT NULL
);

INSERT INTO tag (name)
VALUES
  ('Central Campus'),
  ('North Campus'),
  ('CSE');

CREATE TABLE location_tag (
  location_id int NOT NULL REFERENCES location(id),
  tag_id int NOT NULL REFERENCES tag(id)

  PRIMARY KEY (location_id, tag_id)
);

INSERT INTO location_tag (location_id, tag_id)
VALUES
  (1, 2),
  (2, 1),
  (3, 1),
  (4, 1),
  (5, 1),
  (6, 1),
  (7, 1);

CREATE TABLE quest (
  id serial PRIMARY KEY,
  name varchar NOT NULL,
  thumbnail text NOT NULL, -- base64 encoded
  description text NOT NULL,
  rating decimal NOT NULL,
  estimated_time decimal NOT NULL -- stored in seconds
);

INSERT INTO quest (name, thumbnail, description, rating, estimated_time)
VALUES
  ('Campus Study Spots', '', '', 4.8, 5400),
  ('Campus Art & Murals', '', '', 4.0, 3000);

CREATE TABLE quest_location (
  quest_id int NOT NULL REFERENCES quest(id),
  location_id int NOT NULL REFERENCES location(id),
  points decimal NOT NULL,

  PRIMARY KEY (quest_id, location_id)
);

INSERT INTO quest_location (quest_id, location_id, points)
VALUES
  (1, 1, 50),
  (1, 2, 90),
  (1, 3, 150),
  (1, 4, 115),
  (1, 5, 20),
  (1, 6, 230),
  (1, 7, 220);

CREATE TYPE location_status AS ENUM ('active', 'complete');

CREATE TABLE user_quest_location_status (
  user_id int NOT NULL REFERENCES user(id),
  quest_id int NOT NULL REFERENCES quest(id),
  location_id int NOT NULL REFERENCES location(id),
  status location_status NOT NULL DEFAULT 'active',

  PRIMARY KEY (user_id, quest_id, location_id)
);

INSERT INTO user_quest_location_status (user_id, quest_id, location_id)
VALUES
  (1, 1, 1),
  (1, 1, 2),
  (1, 1, 3),
  (1, 1, 4),
  (1, 1, 5),
  (1, 1, 6),
  (1, 1, 7);
