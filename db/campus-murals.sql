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

INSERT INTO location_tag (location_id, tag_id)
VALUES
  (8, 4),
  (8, 5),
  (8, 6),
  (9, 7),
  (9, 8),
  (9, 9),
  (10, 10),
  (10, 11),
  (10, 12),
  (11, 13),
  (11, 14),
  (11, 15),
  (12, 16),
  (12, 17),
  (12, 18),
  (13, 19),
  (13, 20),
  (13, 21),
  (14, 22),
  (14, 23),
  (14, 24),
  (15, 25),
  (15, 26),
  (15, 27),
  (16, 28),
  (16, 29),
  (16, 30),
  (17, 31),
  (17, 32),
  (17, 33),
  (18, 34),
  (18, 35),
  (18, 36),
  (19, 37),
  (19, 38),
  (19, 39),
  (20, 40),
  (20, 41),
  (20, 42),
  (21, 43),
  (21, 44),
  (21, 45),
  (22, 46),
  (22, 47),
  (22, 48),
  (23, 49),
  (23, 50),
  (23, 51),
  (24, 52),
  (24, 53),
  (24, 54),
  (25, 55);

INSERT INTO locations (name, latitude, longitude, description, thumbnail, distance_threshold)
VALUES
  ('Challenge Everything. Create Anything',	42.2811408716837, -83.74752358, 'Behold the captivating "Challenge Everything. Create Anything." mural, a testament to the dynamic collaboration between Destination Ann Arbor, Wickfield Properties, and esteemed local artists Mary Thiefels and Danijel Matanic. Adorning the 10-story wall of Courthouse Square at 100 South 4th Avenue, this vibrant masterpiece, completed in the summer of 2019, radiates Ann Arbor''s spirited essence and tight-knit community spirit. The mural invites onlookers to embrace human creativity, ingenuity, and curiosity through its playful and illustrative depiction, earning widespread acclaim and becoming a cherished symbol of the city''s cultural vitality.', 'http://3.142.74.134/media/1.png', 50),

  ('Bookstore Mural',	42.277980252844955, -83.74215417808378, 'The Bookstore Mural is a large outdoor mural measuring approximately 60 feet by 20 feet that features the portraits of five cultural icons: Woody Allen, Edgar Allan Poe, Hermann Hesse, Franz Kafka, and Anais Nin. It has also been known as the Poet Mural, Liberty Street Mural, and East Liberty Street Wall Mural. The mural was painted in 1984 by artist Richard Wolk and has since become an iconic landmark in Ann Arbor.', 'http://3.142.74.134/media/2.jpg', 50),

  ('Not Afraid to Dance',	42.28017185472255, -83.75112929260827, 'The mural by Gary Horton, titled "Not Afraid to Dance," depicts several bright figures dancing together and was commissioned in March 2020, just as the world was shutting down due to the COVID-19 pandemic. The artist created it as a reminder of how he and his wife found comfort through continuing their small, weekly dance parties at home during the scary early days of restrictions and lockdowns. Commissioned by Circ Bar, it commemorates finding joy in simple acts during difficult times.', 'http://3.142.74.134/media/3.jpeg', 50),

  ('Dokebi'	42.28030056817844, -83.75116013186488, 'The mural features a dokkaebi, a goblin-like trickster from Korean folklore known for playing pranks on humans. The artist Chris "Dokebi" Sammons, who takes his moniker from this creature, brings it to life through his painting in vivid colors and playful composition. His distinctive interpretation of the folklore character embodies its spirit of fun and mischief through an animated scene that will engage and entertain viewers.', 'http://3.142.74.134/media/4.jpeg', 50),

  ('Pride in Patterns',	42.278932232589604, -83.74928717116414, 'Metro Detroit artist Joey Salamon''s mural combines eye-catching patterns of repeating geometric shapes in a rainbow of colors, with dimensions added by the use of different hues and tones. His signature style exhibits vibrant abstract forms and clean lines that enhance the graphic feel of the artwork. The piece aims to exude joyfulness and pride for the community through dimensional space and a pop of vibrant colors.', 'http://3.142.74.134/media/5.jpeg', 50),

  ('Coyotes in the City',	42.27974790760839, -83.74960379816177, 'Rendered in a style mirroring the artist''s wall installations, the mural depicts typical suburban motifs like houses and fences alongside an urbanized coyote. Along with other modern icons, these images have been translated from Dylan Strzynski''s usual works to the concrete canvas in a manner reflective of how wildlife adjusts to city life. Viewers familiar with the artist''s focus on architecture and nature will recognize references adapted here for their downtown setting.', 'http://3.142.74.134/media/6.jpeg', 50),

  ('Community Connections', 42.27912648435359, -83.75194659814942, 'Featuring large insects and plants representing the interconnected relationships between Ann Arbor and Ypsilanti. Artist Yen Azzaro depicted the local agriculture and ecosystems binding the communities through bright colors, whimsical details, and symbolic butterflies and bees. Through visual and written metaphor, the mural celebrated regional bounty, diversity, and the thriving network of partnerships across communities.', 'http://3.142.74.134/media/7.jpeg', 50),

  ('Humanity and Technology', 42.280612367464414, -83.75115402698519, 'Featuring hands exploring the relationship between people and digital devices against a backdrop of horizontal lines cutting through the composition. The artist Taylor White used figurative imagery and technology as themes to represent how humanity is inherently intertwined with advancing tools. Scanners and code peek out from between the fingers to symbolize how social media can both connect and threaten civilization.', 'http://3.142.74.134/media/8.jpg', 50),

  ('Symbiosis Of The Red Bellied Woodpecker and the Eastern Bluebird',	42.28237381560644, -83.7511685423284, 'Dive into the vibrant depiction of the interconnected tale of a red-bellied woodpecker and an Eastern bluebird. This expansive artwork unfolds the woodpecker''s role in providing a nest cavity in an oak tree, emphasizing the captivating dance of local wildlife and their interwoven destinies.', 'http://3.142.74.134/media/9.png', 50),

  ('Midnight Olive',	42.28197400393415, -83.7507180460296, 'Created by Detroit-based artist Olivia Guterson, who goes by the name Midnight Olive. Deeply influenced by her Jewish and Black heritage, her works accentuate the balance of black and white, busy and still areas through an interwoven network of lines and shapes. Guterson''s instinctive linework in this piece is meant to embed feelings of love, hope, and joy in the places she leaves her mark. She describes her artistic process as "art as a moving meditation" that facilitates her own healing and truth-seeking. Visitors to the site will be struck by the complexity and balance achieved through Guterson''s interdisciplinary approach to composition and structure in this large-scale public artwork.', 'http://3.142.74.134/media/10.jpg', 50),

  ('May Her Memory Be Our Innermost Revolution', 42.28226903959532, -83.750133755821, 'The vibrantly colored mural depicts a larger-than-life portrait of Ann Lewis, a multidisciplinary Detroit artist known for using public murals, installations and participatory performances to bring attention to topics like gentrification, women''s rights, and police brutality. Her distinctive graphic style is evident in the repetitive geometric patterns that form the background behind her image. Lewis'' thought-provoking gaze engages viewers as her message of empowerment and intersectional social justice advocacy shines through. Created in collaboration with members of the local community, the mural highlights the shared humanity in all people, especially those who are often marginalized like women transitioning from incarceration back into society. Visitors will be struck by the mural''s aesthetically pleasing design and moved by the important issues it illuminates through Lewis'' inspiring artwork.', 'http://3.142.74.134/media/11.jpg', 50),

  ('WC Bevan',	42.28248307674222, -83.7495937711642, 'W. C. Bevan, a Detroit-based painter and muralist, draws inspiration from his unconventional upbringing and diverse experiences as a punk musician, traveler, graffiti artist, and construction worker in Memphis, TN. His A2AC Mural in Ann Arbor focuses on high-contrast visual movement, architectural extensions, and rhythms rooted in free-associative practices, incorporating shapes sourced from local youth in collaboration with the Community Action Network (CAN) of Ann Arbor. This partnership with CAN allowed students from the Bryant community to actively contribute to the mural''s creative process, aligning with CAN''s mission to empower under-resourced communities in Washtenaw County.', 'http://3.142.74.134/media/12.jpg', 50),

  ('Pat Perry',	42.28095411564499, -83.74956765582102, 'Pat Perry, a Detroit-based artist originally from Grand Rapids, MI, is known for his itinerant work that combines writing and careful observation in pictures. Primarily a painter and illustrator, Perry''s outdoor murals span various locations globally, including New Zealand, Iraq, Finland, Zurich, Cleveland, New York, Canada, Berlin, Washington D.C., Detroit, and Ann Arbor. With an impressive client list, including The New York Times and Twitter, Perry has been awarded residencies in Katmai National Park and has spoken at notable events like OFFF Barcelona, OFFF Montreal, University of Michigan, and Domestika''s MAD in Madrid. The Ann Arbor project was made possible by the support of 3Mission Design and Development, Ann Arbor Downtown Development Authority, First Martin Co., Bank of Ann Arbor, and passionate individuals dedicated to art in public spaces.', 'http://3.142.74.134/media/13.png', 50),

  ('Drifts'	42.28059389456204, -83.74990334047781, 'Louise Jones, known as Ouizi, is a Santa Monica-born artist based in Detroit, celebrated for her large-scale floral murals found in public spaces across the U.S. Her unique installations, influenced by her background in drawing and printmaking, depict site-specific plants and animals. Inspired by a visit to the Nichols Arboretum and Matthaei Botanical Gardens, Ouizi''s Ann Arbor mural, titled "Drifts," features Echinacea and Rudbeckia hirta, creating an immersive experience reminiscent of being a small bug in the grass. This focused piece stands out among her works, emphasizing only two flower varieties for a captivating visual impact.', 'http://3.142.74.134/media/14.jpeg', 50),

  ('Nina Shahin',	42.279848496533994, -83.74782372513464, 'Conceptual painter Nina Shahin, with a focus on color, space, and shape, creates memory scapes challenging traditional storytelling narratives. Inspired by the oral history custodians in their lineage, especially their father, Nina studied Fine Arts at Eastern Michigan University. Their mural in downtown Ann Arbor is part of the ongoing ROOM series, honoring water''s capacity to hold memory and emotion. An abstracted map of the Huron River from Gallup Park to Barton Pond, the mural was completed freehand in the fall of 2020, showcasing Nina''s unique approach to spatial storytelling.', 'http://3.142.74.134/media/15.png', 50),

  ('Mike Ross',	42.279578573199444, -83.74782499999999, 'Mike Ross, a full-time painter for the past 10 years, specializes in color and pattern, creating predominantly abstract works with occasional figurative elements. Since 2018, he has been delving into mural painting, having completed around a dozen projects, each more ambitious than the last, from local areas to as far as Santiago, Chile. Known for his tidy graphic style, Mike meticulously maps out his murals, allowing for some room for improvisation in the ideal situation. His work features eye-catching yet subtle color combinations, with a seamless flow between colors through pattern and repetition, as you can no doubt see in this mural', 'http://3.142.74.134/media/16.jpeg', 50),

  ('The Glass Beads',	42.27700135727122, -83.748233188358, 'Detroit-based artist Jesse Kassel created a mural on the west-facing wall of the historic Pretzel Bell Building at 120 East Liberty Street. Commissioned by the Ann Arbor Art Center’s Art in Public Initiative on behalf of Shaffran Companies, Ltd., the project received generous support from Shaffran Companies, the Ann Arbor Downtown Development Authority, and private donors passionate about public art in Ann Arbor. The mural is part of the vibrant cultural landscape of Ann Arbor, contributing to the city''s public art initiative.', 'http://3.142.74.134/media/last.jpeg', 50);

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
  (2, 24, 50),
  (2, 25, 50);



