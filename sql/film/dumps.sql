
----------------------------- DB DUMP START -----------------------------------------

INSERT INTO genres (name) 
VALUES  ('Action'),
		('Adventure'), 
		('Animation'), 
		('Comedy'), 
		('Fantasy'),
		('Horror'), 
		('Mystery'),
		('Sci-Fi'),
		('Thriller');

SELECT insert_film(
	title:='New Movie', 
	release_date:='2021-01-01',
	film_type:='movie',
	production_country:='Nepal', 
	minimum_age:=18, 
	persons:= ARRAY [1,3,4],
	genres:= ARRAY [1,3]
)


----------------------------- DB DUMP END -------------------------------------------

