-- How to Run:
-- sudo -u postgres psql
-- \c scavangardb
-- \i arscavhunt/db/seed.sql


DROP TABLE IF EXISTS users CASCADE;

DROP TABLE IF EXISTS quests CASCADE;
DROP TABLE IF EXISTS quest_locations CASCADE;

DROP TABLE IF EXISTS locations CASCADE;
DROP TABLE IF EXISTS tags CASCADE;
DROP TABLE IF EXISTS location_tag CASCADE;

DROP TABLE IF EXISTS teams CASCADE;
DROP TABLE IF EXISTS team_users CASCADE;
DROP TABLE IF EXISTS team_quest_locations_status CASCADE;

CREATE TABLE users (
  id serial PRIMARY KEY NOT NULl,
  first_name varchar NOT NULL,
  last_name varchar NOT NULL,
  username varchar NOT NULL,
  avatar_url text NOT NULL
);

INSERT INTO users (first_name, last_name, username, avatar_url)
VALUES
  ('Janice', 'Liu', 'janliu', 'https://3.142.74.134/media/users/1.jpg'),
  ('Rohan', 'Nagavardhan', 'rnagavar', 'https://3.142.74.134/media/users/2.jpg'),
  ('Shaan', 'Patel', 'pshaan', 'https://3.142.74.134/media/users/3.jpg'),
  ('Zach', 'Weiss', 'zjweiss', 'https://3.142.74.134/media/users/4.jpg'),
  ('Abbie', 'Tooman', 'atooman', 'https://3.142.74.134/media/users/5.jpg');

INSERT INTO users (id, first_name, last_name, username, avatar_url)
VALUES
  (0, 'demo', 'demo', 'demo', '');

CREATE TABLE locations (
  id serial PRIMARY KEY,
  name varchar NOT NULL,
  latitude decimal NOT NULL,
  longitude decimal NOT NULL,
  description text NOT NULL,
  thumbnail text NOT NULL,
  ar_file text NOT NULL DEFAULT '',
  distance_threshold decimal NOT NULL -- meters
);


-- CAMPUS STUDY SPOTS

INSERT INTO locations (name, latitude, longitude, description, thumbnail, ar_file, distance_threshold)
VALUES
	('The Duderstadt Center', 42.2912, -83.7157, 'The Duderstat Center is a great place to study on campus, with its many quiet spaces, group study rooms, access to the library, and cafe. For your scavenger hunt, check out the Duderstat Courtyard, where you can enjoy the outdoors while studying, the Learning Commons, a large open space with plenty of seating and resources, and the Technology Lending and Support Center, where you can borrow laptops, chargers, and other technology.', 'https://3.142.74.134/media/duderstat1699761280.8239608.jpeg', '', 100),
	  ('Hatcher Graduate Library', 42.2763, -83.7380, 'Hatcher Graduate Library is the largest library on campus and a popular study spot for graduate students. The library features a variety of study spaces, including quiet reading areas, group study rooms, and computer labs. Hatcher also has a cafe and a terrace overlooking the Diag, which is a great place to relax and take a break from studying.', 'https://3.142.74.134/media/hatcher1699761180.9576178.jpeg', '', 100),
	  ('Law Library', 42.2738, -83.7391, 'The University of Michigan Law Library is a world-renowned law library and a popular study spot for students of all disciplines. The library features a vast collection of legal resources, including books, journals, and databases, as well as a variety of study spaces, including quiet reading areas, group study rooms, and computer labs. The Law Library also has a cafe and a terrace overlooking the Diag, making it a great place to study, relax, and people-watch.', 'https://3.142.74.134/media/law-library1699761226.5702388.jpeg', '', 100),
	  ('LSA Building', 42.275720, -83.740760, 'The LSA Building is a prime spot on campus to find a study space. Head to the 2th floor for panoramic views of the State street and beyond. The 2nd floor offers quiet study rooms, perfect for group collaboration. Dont forget to check out the LSA Career Center, which has a wide selection of resources to help you find a job.', 'https://3.142.74.134/media/lsa-building1699761329.5195441.jpeg', '', 100),
	  ('UGLI', 42.2756, -83.7372, 'Embark on a scholarly adventure at the University of Michigans UGLI (Undergraduate Library). Nestled in the heart of campus, the UGLI is a haven for studious minds, offering a diverse array of study spaces ranging from cozy nooks to collaborative work areas. Discover this iconic academic sanctuary as you explore this scavenger hunt, where knowledge meets comfort in the vibrant halls of the UGLI.', 'https://3.142.74.134/media/ugli1699761434.0139413.jpeg', '', 150),
	  ('The Fishbowl', 42.2767, -83.7396, 'Nestled within the heart of the campus, The Fishbowl is a renowned study haven where students immerse themselves in academic pursuits under the iconic glass dome. Uncover this vibrant academic sanctuary, witness collaborative learning in action, and capture the essence of scholarly camaraderie at one of Michigans most cherished study spots.', 'https://3.142.74.134/media/fishbowl1699761463.5285528.jpeg', '', 100),
	  ('Kinesiology Building', 42.274880, -83.740110, 'Discover the University of Michigans Kinesiology Building, a sleek haven for focused study. Its modern design and ample natural light create a serene atmosphere in the atrium, while the rooftop terrace offers inspiring panoramic views. With state-of-the-art labs and collaborative spaces, this building is a unique and innovative addition to your Campus Study Spots scavenger hunt.', 'https://3.142.74.134/media/kines1699761375.7118528.jpeg', '', 100);

CREATE TABLE tags (
  id serial PRIMARY KEY,
  name varchar NOT NULL
);

INSERT INTO tags (name)
VALUES
  ('Central Campus'),
  ('North Campus'),
  ('CSE');

CREATE TABLE location_tag (
  location_id int NOT NULL REFERENCES locations(id),
  tag_id int NOT NULL REFERENCES tags(id),

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


CREATE TABLE quests (
  id serial PRIMARY KEY,
  name varchar NOT NULL,
  thumbnail text NOT NULL,
  description text NOT NULL,
  rating decimal NOT NULL,
  estimated_time decimal NOT NULL -- stored in seconds
);

INSERT INTO quests (name, thumbnail, description, rating, estimated_time)
VALUES
  ('Campus Study Spots', 'https://3.142.74.134/media/campus-study-spots-main1699759724.7242055.jpeg', 'Uncover the hidden gems of the University of Michigans study spots on this mysterious scavenger hunt! Solve cryptic clues, explore secret locations, and take creative photos to win prizes. But be warned: these study spots are well-hidden, and only the most resourceful scavengers will find them all.', 4.8, 5400),
  ('Campus Art & Murals', 'https://3.142.74.134/media/campus-art-murals-main1699759825.0103273.jpeg', 'Embark on a journey to discover the vibrant art and murals that adorn the University of Michigan campus! From hidden gems to iconic landmarks, this scavenger hunt will take you on a tour of the universitys rich artistic heritage. Find hidden landmars and complete challenges to reveal the hidden stories behind these stunning works of art. But be prepared for a surprise or two along the way...', 4.0, 3000),
  ('Campus Highlights', 'https://3.142.74.134/media/umich.png', 'Embark on an exhilarating scavenger hunt through the iconic University of Michigan campus, where teams will navigate the hallowed halls of the Law Quad, unravel the mysteries of the historic Michigan Stadium, and decode clues leading to the spinning cube, creating unforgettable memories while exploring the heart of Wolverines territory.', 4.3, 3000);


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



-- CAMPUS MURALS

INSERT INTO tags (name)
VALUES
  ('creativity'),
  ('inspiration'),
  ('community'),

  ('icons'),
  ('portraits'),
  ('literature'),

  ('joyful'),
  ('colorful'),
  ('imaginative'),

  ('folk art'),
  ('playful'),
  ('mischievous'),

  ('abstract'),
  ('geometric'),
  ('colorful'),

  ('landscape'),
  ('vernacular'),
  ('environment'),

  ('art'),
  ('downtown'),
  ('original'),

  ('taylor white'),
  ('a2ac murals'),
  ('art'),

  ('jacob dwyer'),
  ('native michigan birds'),
  ('red-bellied woodpecker'),

  ('truth-seeking'),
  ('love in art'),
  ('hopeful creations'),

  ('acclaimed artist'),
  ('art and activism'),
  ('social impact art'),

  ('diverse experiences'),
  ('punk musician'),
  ('traveler'),

  ('grand rapids'),
  ('itinerant work'),
  ('writing and observation in art'),

  ('focused art piece'),
  ('visual impact'),
  ('celebrated artist'),

  ('spatial storytelling'),
  ('unique artistic approach'),
  ('honoring water'),

  ('creative exploration'),
  ('artistic precision'),
  ('abstract expressionism'),

  ('historic building'),
  ('creative city enhancement'),
  ('public art support');

INSERT INTO locations (name, latitude, longitude, description, thumbnail, distance_threshold)
VALUES
  ('Challenge Everything. Create Anything',	42.2811408716837, -83.74752358, 'Behold the captivating "Challenge Everything. Create Anything." mural, a testament to the dynamic collaboration between Destination Ann Arbor, Wickfield Properties, and esteemed local artists Mary Thiefels and Danijel Matanic. Adorning the 10-story wall of Courthouse Square at 100 South 4th Avenue, this vibrant masterpiece, completed in the summer of 2019, radiates Ann Arbor''s spirited essence and tight-knit community spirit. The mural invites onlookers to embrace human creativity, ingenuity, and curiosity through its playful and illustrative depiction, earning widespread acclaim and becoming a cherished symbol of the city''s cultural vitality.', 'https://3.142.74.134/media/1.png', 50),
  ('Bookstore Mural',	42.277980252844955, -83.74215417808378, 'The Bookstore Mural is a large outdoor mural measuring approximately 60 feet by 20 feet that features the portraits of five cultural icons: Woody Allen, Edgar Allan Poe, Hermann Hesse, Franz Kafka, and Anais Nin. It has also been known as the Poet Mural, Liberty Street Mural, and East Liberty Street Wall Mural. The mural was painted in 1984 by artist Richard Wolk and has since become an iconic landmark in Ann Arbor.', 'https://3.142.74.134/media/2.jpg', 50),
  ('Not Afraid to Dance',	42.28017185472255, -83.75112929260827, 'The mural by Gary Horton, titled "Not Afraid to Dance," depicts several bright figures dancing together and was commissioned in March 2020, just as the world was shutting down due to the COVID-19 pandemic. The artist created it as a reminder of how he and his wife found comfort through continuing their small, weekly dance parties at home during the scary early days of restrictions and lockdowns. Commissioned by Circ Bar, it commemorates finding joy in simple acts during difficult times.', 'https://3.142.74.134/media/3.jpeg', 50),
  ('Dokebi',	42.28030056817844, -83.75116013186488, 'The mural features a dokkaebi, a goblin-like trickster from Korean folklore known for playing pranks on humans. The artist Chris "Dokebi" Sammons, who takes his moniker from this creature, brings it to life through his painting in vivid colors and playful composition. His distinctive interpretation of the folklore character embodies its spirit of fun and mischief through an animated scene that will engage and entertain viewers.', 'https://3.142.74.134/media/4.jpeg', 50),
  ('Pride in Patterns',	42.278932232589604, -83.74928717116414, 'Metro Detroit artist Joey Salamon''s mural combines eye-catching patterns of repeating geometric shapes in a rainbow of colors, with dimensions added by the use of different hues and tones. His signature style exhibits vibrant abstract forms and clean lines that enhance the graphic feel of the artwork. The piece aims to exude joyfulness and pride for the community through dimensional space and a pop of vibrant colors.', 'https://3.142.74.134/media/5.jpeg', 50),
  ('Coyotes in the City',	42.27974790760839, -83.74960379816177, 'Rendered in a style mirroring the artist''s wall installations, the mural depicts typical suburban motifs like houses and fences alongside an urbanized coyote. Along with other modern icons, these images have been translated from Dylan Strzynski''s usual works to the concrete canvas in a manner reflective of how wildlife adjusts to city life. Viewers familiar with the artist''s focus on architecture and nature will recognize references adapted here for their downtown setting.', 'https://3.142.74.134/media/6.jpeg', 50),
  ('Community Connections', 42.27912648435359, -83.75194659814942, 'Featuring large insects and plants representing the interconnected relationships between Ann Arbor and Ypsilanti. Artist Yen Azzaro depicted the local agriculture and ecosystems binding the communities through bright colors, whimsical details, and symbolic butterflies and bees. Through visual and written metaphor, the mural celebrated regional bounty, diversity, and the thriving network of partnerships across communities.', 'https://3.142.74.134/media/7.jpeg', 50),
  ('Humanity and Technology', 42.280612367464414, -83.75115402698519, 'Featuring hands exploring the relationship between people and digital devices against a backdrop of horizontal lines cutting through the composition. The artist Taylor White used figurative imagery and technology as themes to represent how humanity is inherently intertwined with advancing tools. Scanners and code peek out from between the fingers to symbolize how social media can both connect and threaten civilization.', 'https://3.142.74.134/media/8.jpg', 50),
  ('Symbiosis Of The Red Bellied Woodpecker and the Eastern Bluebird',	42.28237381560644, -83.7511685423284, 'Dive into the vibrant depiction of the interconnected tale of a red-bellied woodpecker and an Eastern bluebird. This expansive artwork unfolds the woodpecker''s role in providing a nest cavity in an oak tree, emphasizing the captivating dance of local wildlife and their interwoven destinies.', 'https://3.142.74.134/media/9.png', 50),
  ('Midnight Olive',	42.28197400393415, -83.7507180460296, 'Created by Detroit-based artist Olivia Guterson, who goes by the name Midnight Olive. Deeply influenced by her Jewish and Black heritage, her works accentuate the balance of black and white, busy and still areas through an interwoven network of lines and shapes. Guterson''s instinctive linework in this piece is meant to embed feelings of love, hope, and joy in the places she leaves her mark. She describes her artistic process as "art as a moving meditation" that facilitates her own healing and truth-seeking. Visitors to the site will be struck by the complexity and balance achieved through Guterson''s interdisciplinary approach to composition and structure in this large-scale public artwork.', 'https://3.142.74.134/media/10.jpg', 50),
  ('May Her Memory Be Our Innermost Revolution', 42.28226903959532, -83.750133755821, 'The vibrantly colored mural depicts a larger-than-life portrait of Ann Lewis, a multidisciplinary Detroit artist known for using public murals, installations and participatory performances to bring attention to topics like gentrification, women''s rights, and police brutality. Her distinctive graphic style is evident in the repetitive geometric patterns that form the background behind her image. Lewis'' thought-provoking gaze engages viewers as her message of empowerment and intersectional social justice advocacy shines through. Created in collaboration with members of the local community, the mural highlights the shared humanity in all people, especially those who are often marginalized like women transitioning from incarceration back into society. Visitors will be struck by the mural''s aesthetically pleasing design and moved by the important issues it illuminates through Lewis'' inspiring artwork.', 'https://3.142.74.134/media/11.jpg', 50),
  ('WC Bevan',	42.28248307674222, -83.7495937711642, 'W. C. Bevan, a Detroit-based painter and muralist, draws inspiration from his unconventional upbringing and diverse experiences as a punk musician, traveler, graffiti artist, and construction worker in Memphis, TN. His A2AC Mural in Ann Arbor focuses on high-contrast visual movement, architectural extensions, and rhythms rooted in free-associative practices, incorporating shapes sourced from local youth in collaboration with the Community Action Network (CAN) of Ann Arbor. This partnership with CAN allowed students from the Bryant community to actively contribute to the mural''s creative process, aligning with CAN''s mission to empower under-resourced communities in Washtenaw County.', 'https://3.142.74.134/media/12.jpg', 50),
  ('Pat Perry',	42.28095411564499, -83.74956765582102, 'Pat Perry, a Detroit-based artist originally from Grand Rapids, MI, is known for his itinerant work that combines writing and careful observation in pictures. Primarily a painter and illustrator, Perry''s outdoor murals span various locations globally, including New Zealand, Iraq, Finland, Zurich, Cleveland, New York, Canada, Berlin, Washington D.C., Detroit, and Ann Arbor. With an impressive client list, including The New York Times and Twitter, Perry has been awarded residencies in Katmai National Park and has spoken at notable events like OFFF Barcelona, OFFF Montreal, University of Michigan, and Domestika''s MAD in Madrid. The Ann Arbor project was made possible by the support of 3Mission Design and Development, Ann Arbor Downtown Development Authority, First Martin Co., Bank of Ann Arbor, and passionate individuals dedicated to art in public spaces.', 'https://3.142.74.134/media/13.png', 50),
  ('Drifts',	42.28059389456204, -83.74990334047781, 'Louise Jones, known as Ouizi, is a Santa Monica-born artist based in Detroit, celebrated for her large-scale floral murals found in public spaces across the U.S. Her unique installations, influenced by her background in drawing and printmaking, depict site-specific plants and animals. Inspired by a visit to the Nichols Arboretum and Matthaei Botanical Gardens, Ouizi''s Ann Arbor mural, titled "Drifts," features Echinacea and Rudbeckia hirta, creating an immersive experience reminiscent of being a small bug in the grass. This focused piece stands out among her works, emphasizing only two flower varieties for a captivating visual impact.', 'https://3.142.74.134/media/14.jpeg', 50),
  ('Nina Shahin',	42.279848496533994, -83.74782372513464, 'Conceptual painter Nina Shahin, with a focus on color, space, and shape, creates memory scapes challenging traditional storytelling narratives. Inspired by the oral history custodians in their lineage, especially their father, Nina studied Fine Arts at Eastern Michigan University. Their mural in downtown Ann Arbor is part of the ongoing ROOM series, honoring water''s capacity to hold memory and emotion. An abstracted map of the Huron River from Gallup Park to Barton Pond, the mural was completed freehand in the fall of 2020, showcasing Nina''s unique approach to spatial storytelling.', 'https://3.142.74.134/media/15.png', 50),
  ('Mike Ross',	42.279578573199444, -83.74782499999999, 'Mike Ross, a full-time painter for the past 10 years, specializes in color and pattern, creating predominantly abstract works with occasional figurative elements. Since 2018, he has been delving into mural painting, having completed around a dozen projects, each more ambitious than the last, from local areas to as far as Santiago, Chile. Known for his tidy graphic style, Mike meticulously maps out his murals, allowing for some room for improvisation in the ideal situation. His work features eye-catching yet subtle color combinations, with a seamless flow between colors through pattern and repetition, as you can no doubt see in this mural', 'https://3.142.74.134/media/16.jpeg', 50),
  ('The Glass Beads',	42.27700135727122, -83.748233188358, 'Detroit-based artist Jesse Kassel created a mural on the west-facing wall of the historic Pretzel Bell Building at 120 East Liberty Street. Commissioned by the Ann Arbor Art Center’s Art in Public Initiative on behalf of Shaffran Companies, Ltd., the project received generous support from Shaffran Companies, the Ann Arbor Downtown Development Authority, and private donors passionate about public art in Ann Arbor. The mural is part of the vibrant cultural landscape of Ann Arbor, contributing to the city''s public art initiative.', 'https://3.142.74.134/media/last.jpeg', 50);



INSERT INTO location_tag (location_id, tag_id)
VALUES
  (7, 4),
  (7, 5),
  (7, 6),
  (8, 7),
  (8, 8),
  (8, 9),
  (9, 10),
  (9, 11),
  (9, 12),
  (10, 13),
  (10, 14),
  (10, 15),
  (11, 16),
  (11, 17),
  (11, 18),
  (12, 19),
  (12, 20),
  (12, 21),
  (13, 22),
  (13, 23),
  (13, 24),
  (14, 25),
  (14, 26),
  (14, 27),
  (15, 28),
  (15, 29),
  (15, 30),
  (16, 31),
  (16, 32),
  (16, 33),
  (17, 34),
  (17, 35),
  (17, 36),
  (18, 37),
  (18, 38),
  (18, 39),
  (19, 40),
  (19, 41),
  (19, 42),
  (20, 43),
  (20, 44),
  (20, 45),
  (21, 46),
  (21, 47),
  (21, 48),
  (22, 49),
  (22, 50),
  (22, 51),
  (23, 52),
  (23, 53),
  (23, 54);




INSERT INTO quest_locations (quest_id, location_id, points)
VALUES
  (2, 8, 50),
  (2, 9, 50),
  (2, 10, 50),
  (2, 11, 50),
  (2, 12, 50),
  (2, 13, 50),
  (2, 14, 50),
  (2, 15, 50),
  (2, 16, 50),
  (2, 17, 50),
  (2, 18, 50),
  (2, 19, 50),
  (2, 20, 50),
  (2, 21, 50),
  (2, 22, 50),
  (2, 23, 50),
  (2, 24, 50);


-- CAMPUS HIGHLIGHTS

INSERT INTO locations (name, latitude, longitude, description, thumbnail, distance_threshold, ar_file)
VALUES
  ('Law Quadrangle', 42.27369391068188, -83.73936207520023, 'Nestled in the heart of the University of Michigan''s campus, the Law Quad is a picturesque enclave of Gothic architecture, where aspiring legal minds engage in intellectual pursuits. Surrounded by historic buildings like Hutchins Hall and the Legal Research Building, the Quad exudes an atmosphere of academic excellence and legal scholarship, making it a revered center for law education and discourse.', 'https://3.142.74.134/media/Law_lib.jpeg', 300, 'gavel.scn'),
  ('The Cube', 42.275990032021554, -83.7418726463647, 'A distinctive symbol of artistic expression, The Cube stands proudly on the Regents'' Plaza, inviting passersby to explore the creative spirit of the University of Michigan. This iconic, interactive sculpture, officially named "Endover," is a magnet for students and visitors alike who partake in the tradition of spinning it for good luck or simply appreciating the dynamic fusion of art and communal engagement at the heart of the Ann Arbor campus.', 'https://3.142.74.134/media/cube.jpeg', 100, 'cube.scn'),
  ('The Big House', 42.26600320423827, -83.74881362122562, 'Reverberating with the roars of Wolverines fans, Michigan Stadium, affectionately known as The Big House, is an epicenter of college football passion and tradition. With a seating capacity that rivals any in the nation, this colossal venue hosts unforgettable moments for the University of Michigan''s football team, creating an electrifying atmosphere where the maize and blue faithful unite to cheer on their beloved Wolverines.', 'https://3.142.74.134/media/big_house.jpg', 800, 'football.scn'),
  ('The Union', 42.27519206435546, -83.74172927704801, 'Nestled at the crossroads of student life, The Michigan Union is a vibrant hub of social, cultural, and recreational activities. Serving as a gathering place for students and alumni, this historic building houses diverse spaces, including lounges, eateries, and meeting rooms, fostering a sense of community and connection among the University of Michigan''s diverse student body.', 'https://3.142.74.134/media/michigan_union.jpg', 300, 'blockM.scn'),
  ('Lurie Bell Tower', 42.29223992589584, -83.71629344821156, 'Piercing the sky with its timeless elegance, the Lurie Bell Tower graces the North Campus of the University of Michigan, standing as a melodic symbol of academic achievement and innovation. Named in honor of engineering pioneers Peter and Clara Lurie, the tower not only marks the passage of time with its carillon chimes but also symbolizes the enduring spirit of excellence that defines the university''s commitment to engineering and technology.', 'https://3.142.74.134/media/bell_tower.jpeg', 300, 'blockM.scn'),
  ('South Quad Dining Hall', 42.27362160663896, -83.74195810218781, 'A culinary haven in the heart of South Campus, the South Quad Dining Hall is a gastronomic delight for University of Michigan students. Boasting a diverse array of dining options, from comfort food to international cuisine, the hall is a bustling gathering spot where students come together to savor delicious meals, forge friendships, and fuel their academic journeys in a warm and inviting atmosphere.', 'https://3.142.74.134/media/south_quad.jpeg', 300, 'pizza.scn');


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
  (30, 69);


INSERT INTO quest_locations (quest_id, location_id, points)
VALUES
  (3, 25, 100),
  (3, 26, 100),
  (3, 27, 100),
  (3, 28, 100),
  (3, 29, 100),
  (3, 30, 100);







CREATE TYPE location_status AS ENUM ('active', 'complete');

CREATE TABLE teams (
  id serial PRIMARY KEY NOT NULL,
  code varchar(8) NOT NULL
);

CREATE TABLE team_users (
  team_id int NOT NULL REFERENCES teams(id),
  user_id int NOT NULL REFERENCES users(id),

  PRIMARY KEY (team_id, user_id)
);

CREATE TABLE team_quest_locations_status (
  team_id int NOT NULL REFERENCES teams(id),
  quest_id int NOT NULL REFERENCES quests(id),
  location_id int NOT NULL REFERENCES locations(id),
  status location_status NOT NULL DEFAULT 'active',

  PRIMARY KEY (team_id, quest_id, location_id)
);

GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO arscav;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO arscav;
