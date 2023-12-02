INSERT INTO locations (name, latitude, longitude, description, thumbnail, distance_threshold, ar_file)
VALUES
  ('Law Quadrangle', 42.27369391068188, -83.73936207520023, 'Nestled in the heart of the University of Michigan''s campus, the Law Quad is a picturesque enclave of Gothic architecture, where aspiring legal minds engage in intellectual pursuits. Surrounded by historic buildings like Hutchins Hall and the Legal Research Building, the Quad exudes an atmosphere of academic excellence and legal scholarship, making it a revered center for law education and discourse.', 'http://3.142.74.134/media/Law_lib.jpeg', 2000, 'gavel.scn'),
  ('The Cube', 42.275990032021554, -83.7418726463647, 'A distinctive symbol of artistic expression, The Cube stands proudly on the Regents'' Plaza, inviting passersby to explore the creative spirit of the University of Michigan. This iconic, interactive sculpture, officially named "Endover," is a magnet for students and visitors alike who partake in the tradition of spinning it for good luck or simply appreciating the dynamic fusion of art and communal engagement at the heart of the Ann Arbor campus.', 'http://3.142.74.134/media/cube.jpeg', 100, 'cube.scn'),
  ('The Big House', 42.26600320423827, -83.74881362122562, 'Reverberating with the roars of Wolverines fans, Michigan Stadium, affectionately known as The Big House, is an epicenter of college football passion and tradition. With a seating capacity that rivals any in the nation, this colossal venue hosts unforgettable moments for the University of Michigan''s football team, creating an electrifying atmosphere where the maize and blue faithful unite to cheer on their beloved Wolverines.', 'http://3.142.74.134/media/big_house.jpg', 8000, 'football.scn'),
  ('The Union', 42.27519206435546, -83.74172927704801, 'Nestled at the crossroads of student life, The Michigan Union is a vibrant hub of social, cultural, and recreational activities. Serving as a gathering place for students and alumni, this historic building houses diverse spaces, including lounges, eateries, and meeting rooms, fostering a sense of community and connection among the University of Michigan''s diverse student body.', 'http://3.142.74.134/media/michigan_union.jpg', 2000, 'blockM.scn'),
  ('Lurie Bell Tower', 42.29223992589584, -83.71629344821156, 'Piercing the sky with its timeless elegance, the Lurie Bell Tower graces the North Campus of the University of Michigan, standing as a melodic symbol of academic achievement and innovation. Named in honor of engineering pioneers Peter and Clara Lurie, the tower not only marks the passage of time with its carillon chimes but also symbolizes the enduring spirit of excellence that defines the university''s commitment to engineering and technology.', 'http://3.142.74.134/media/bell_tower.jpeg', 500, 'blockM.scn'),
  ('South Quad Dining Hall', 42.27362160663896, -83.74195810218781, 'A culinary haven in the heart of South Campus, the South Quad Dining Hall is a gastronomic delight for University of Michigan students. Boasting a diverse array of dining options, from comfort food to international cuisine, the hall is a bustling gathering spot where students come together to savor delicious meals, forge friendships, and fuel their academic journeys in a warm and inviting atmosphere.', 'http://3.142.74.134/media/south_quad.jpeg', 2000), 'pizza.scn';

INSERT INTO location_tag (location_id, tag_id)
VALUES
  (25, 56),
  (25, 57),  
  (25, 58),
  (26, 59),
  (26, 60),
  (26, 61),
  (27, 62),
  (27, 63),
  (27, 64),
  (28, 65),
  (28, 66),
  (28, 67),
  (29, 68),
  (29, 69),
  (29, 70),
  (30, 71),
  (30, 72),
  (30, 73);   


INSERT INTO quest_locations (quest_id, location_id, points)
VALUES
  (3, 26, 100),
  (3, 27, 100),
  (3, 28, 100),
  (3, 29, 100),
  (3, 30, 100),
  (3, 31, 100);

INSERT INTO tags (name)
VALUES
  ('legal scholarship'),
  ('gothic architecture'),
  ('academic excellence'),

  ('interactive art'),
  ('ann arbor landmark'),
  ('creative expression'),

  ('college football'),
  ('wolverines spirit'),
  ('game day experience'),

  ('student life'),
  ('community hub'),
  ('historic meeting place'),

  ('engineering excellence'),
  ('carillon chimes'),
  ('innovation symbol'),

  ('culinary delights'),
  ('social gathering'),
  ('diverse cuisine');