DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS locations CASCADE;
DROP TABLE IF EXISTS quests CASCADE;
DROP TABLE IF EXISTS quest_locations CASCADE;
DROP TABLE IF EXISTS user_quest_locations_status CASCADE;

CREATE TABLE users (
  id serial PRIMARY KEY NOT NULl,
  first_name varchar NOT NULL,
  last_name varchar NOT NULL,
  username varchar NOT NULL,
);

INSERT INTO users (first_name, last_name, username)
VALUES
  ('Janice', 'Liu', 'jliu'),
  ('Rohan', 'Nagavardhan', 'rnagavar'),
  ('Shaan', 'Patel', 'pshaan'),
  ('Zach', 'Weiss', 'zjweiss'),
  ('Abbie', 'Tooman', 'atooman');


CREATE TABLE locations (
  id serial PRIMARY KEY,
  name varchar NOT NULL,
  latitude decimal NOT NULL,
  longitude decimal NOT NULL,
  description text NOT NULL,
  thumbnail text NOT NULL, -- base64 encoded
  ar_enabled boolean NOT NULL,
  distance_threshold decimal NOT NULL -- meters
);

INSERT INTO locations (name, latitude, longitude, description, thumbnail, ar_enabled, distance_threshold)
VALUES
  ('The Duderstadt Center', 42.2912, -83.7157, 'The Duderstat Center is a great place to study on campus, with its many quiet spaces, group study rooms, access to the library, and cafe. For your scavenger hunt, check out the Duderstat Courtyard, where you can enjoy the outdoors while studying, the Learning Commons, a large open space with plenty of seating and resources, and the Technology Lending and Support Center, where you can borrow laptops, chargers, and other technology.', 'https://3.142.74.134/media/duderstat1699761280.8239608.jpeg', true, 100),
  ('Hatcher Graduate Library', 42.2763, -83.7380, 'Hatcher Graduate Library is the largest library on campus and a popular study spot for graduate students. The library features a variety of study spaces, including quiet reading areas, group study rooms, and computer labs. Hatcher also has a cafe and a terrace overlooking the Diag, which is a great place to relax and take a break from studying.', 'https://3.142.74.134/media/hatcher1699761180.9576178.jpeg', false, 100),
  ('Law Library', 42.2738, -83.7391, 'The University of Michigan Law Library is a world-renowned law library and a popular study spot for students of all disciplines. The library features a vast collection of legal resources, including books, journals, and databases, as well as a variety of study spaces, including quiet reading areas, group study rooms, and computer labs. The Law Library also has a cafe and a terrace overlooking the Diag, making it a great place to study, relax, and people-watch.', 'https://3.142.74.134/media/law-library1699761226.5702388.jpeg', true, 100),
  ('LSA Building', 42.275720, -83.740760, 'The LSA Building is a prime spot on campus to find a study space. Head to the 2th floor for panoramic views of the State street and beyond. The 2nd floor offers quiet study rooms, perfect for group collaboration. Dont forget to check out the LSA Career Center, which has a wide selection of resources to help you find a job.', 'https://3.142.74.134/media/lsa-building1699761329.5195441.jpeg', false, 100),
  ('Kinesiology Building', 42.274880, -83.740110, 'Discover the University of Michigans Kinesiology Building, a sleek haven for focused study. Its modern design and ample natural light create a serene atmosphere in the atrium, while the rooftop terrace offers inspiring panoramic views. With state-of-the-art labs and collaborative spaces, this building is a unique and innovative addition to your Campus Study Spots scavenger hunt.', 'https://3.142.74.134/media/kines1699761375.7118528.jpeg', true, 100);
  ('UGLI', 42.2756, -83.7372, 'Embark on a scholarly adventure at the University of Michigans UGLI (Undergraduate Library). Nestled in the heart of campus, the UGLI is a haven for studious minds, offering a diverse array of study spaces ranging from cozy nooks to collaborative work areas. Discover this iconic academic sanctuary as you explore this scavenger hunt, where knowledge meets comfort in the vibrant halls of the UGLI.', 'https://3.142.74.134/media/ugli1699761434.0139413.jpeg', true, 150),
  ('The Fishbowl', 42.2767, -83.7396, 'Nestled within the heart of the campus, The Fishbowl is a renowned study haven where students immerse themselves in academic pursuits under the iconic glass dome. Uncover this vibrant academic sanctuary, witness collaborative learning in action, and capture the essence of scholarly camaraderie at one of Michigans most cherished study spots.', 'https://3.142.74.134/media/fishbowl1699761463.5285528.jpeg', true, 100),

CREATE TABLE quests (
  id serial PRIMARY KEY,
  name varchar NOT NULL,
  thumbnail text NOT NULL, -- base64 encoded
  description text NOT NULL,
  rating decimal NOT NULL,
  estimated_time decimal NOT NULL -- stored in seconds
);

INSERT INTO quests (name, thumbnail, description, rating, estimated_time)
VALUES
  ('Campus Study Spots', 'https://3.142.74.134/media/campus-study-spots-main1699759724.7242055.jpeg', 'Uncover the hidden gems of the University of Michigans study spots on this mysterious scavenger hunt! Solve cryptic clues, explore secret locations, and take creative photos to win prizes. But be warned: these study spots are well-hidden, and only the most resourceful scavengers will find them all.', 4.8, 5400),
  ('Campus Art & Murals', 'https://3.142.74.134/media/campus-art-murals-main1699759825.0103273.jpeg', 'Embark on a journey to discover the vibrant art and murals that adorn the University of Michigan campus! From hidden gems to iconic landmarks, this scavenger hunt will take you on a tour of the universitys rich artistic heritage. Find hidden landmars and complete challenges to reveal the hidden stories behind these stunning works of art. But be prepared for a surprise or two along the way...', 4.0, 3000);

CREATE TABLE quest_locations (
  quest_id int NOT NULL REFERENCES quests(id),
  location_id int NOT NULL REFERENCES locations(id),
  points decimal NOT NULL,

  PRIMARY KEY (quest_id, location_id)
);

INSERT INTO quest_locations (quest_id, location_id, points)
VALUES
  (1, 1, 50),
  (1, 2, 90),
  (1, 3, 150),
  (1, 4, 115),
  (1, 5, 20),
  (1, 6, 230),
  (1, 7, 220);

CREATE TYPE location_status AS ENUM ('active', 'complete');

CREATE TABLE user_quest_locations_status (
  user_id int NOT NULL REFERENCES users(id),
  quest_id int NOT NULL REFERENCES quests(id),
  location_id int NOT NULL REFERENCES locations(id),
  status location_status NOT NULL DEFAULT 'active',

  PRIMARY KEY (user_id, quest_id, location_id)
);

INSERT INTO user_quest_locations_status (user_id, quest_id, location_id)
VALUES
  (1, 1, 1),
  (1, 1, 2),
  (1, 1, 3),
  (1, 1, 4),
  (1, 1, 5),
  (1, 1, 6),
  (1, 1, 7);
