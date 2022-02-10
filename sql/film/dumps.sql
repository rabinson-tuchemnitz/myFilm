
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
	title:='Movie 1', 
	release_date:='2022-02-01',
	film_type:='movie',
	production_country:='Germany', 
	minimum_age:=21, 
	persons:= ARRAY [6,7,9],
	genres:= ARRAY [4,5],
	duration:= '02:30:00',
	description:= 'The movie is a fantastic movie based on real story.'
)

SELECT insert_film(
	title:='Movie 2', 
	release_date:='2021-01-01',
	film_type:='movie',
	production_country:='Germany', 
	minimum_age:=21, 
	persons:= ARRAY [6,7,9],
	genres:= ARRAY [1,3],
	duration:= '02:12:00',
	description:= 'The movie is a fantastic movie based on real story.'
)


SELECT insert_film(
	title:='Movie 2', 
	release_date:='2021-01-01',
	film_type:='movie',
	production_country:='Germany', 
	minimum_age:=21, 
	persons:= ARRAY [6,7,9],
	genres:= ARRAY [1,3],
	duration:= '02:12:00',
	description:= 'The movie is a fantastic movie based on real story.'
)


SELECT insert_film(
	title:='Movie 2', 
	release_date:='2021-01-01',
	film_type:='movie',
	production_country:='Germany', 
	minimum_age:=21, 
	persons:= ARRAY [6,7,9],
	genres:= ARRAY [1,3],
	duration:= '02:12:00',
	description:= 'The movie is a fantastic movie based on real story.'
)


----------------------------- DB DUMP END -------------------------------------------

