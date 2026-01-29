

-- SPOTIFY SQL Project -- 

DROP TABLE IF EXISTS spotify
CREATE TABLE spotify 
(        Artist	VARCHAR(255),
         Track	VARCHAR(255),
		 Album	VARCHAR(255),
		 Album_type	VARCHAR(60),
		 Danceability FLOAT,	
		 Energy	FLOAT, 
		 Loudness FLOAT,
		 Speechiness FLOAT,
		 Acousticness FLOAT,
		 Instrumentalness FLOAT,
		 Liveness FLOAT,
		 Valence FLOAT,
		 Tempo FLOAT,
		 Duration_min FLOAT,	
		 Title	VARCHAR(255),
		 Channel VARCHAR(255),
		 Views	BIGINT,
		 Likes	BIGINT,
		 Comments BIGINT,
		 Licensed	VARCHAR(30),
		 official_video	BOOLEAN,
		 Stream	BIGINT,
		 EnergyLiveness FLOAT,	
		 most_playedon VARCHAR(50)

)


-- EDA 

SELECT COUNT (DISTINCT Artist) FROM spotify;

SELECT COUNT(DISTINCT Album) FROM spotify;

SELECT DISTINCT Album_type FROM spotify;

SELECT MAX(Duration_min) FROM spotify;

SELECT MIN(Duration_min) FROM spotify;

DELETE  FROM spotify 
WHERE 
   Duration_min = 0;

SELECT DISTINCT Channel from spotify;


SELECT DISTINCT most_playedon FROM spotify;


----------------------------------------------
-- Data Analysis - Easy Level
----------------------------------------------


-- Q1. Retrieve the names of all tracks that have more than 1 billion streams.


SELECT 
     track 
FROM spotify 
WHERE
   stream > 1000000000


-- Q2. List all albums along with their respective artists.

SELECT 
    DISTINCT album,
	artist
FROM spotify
ORDER BY 1



-- Q3.Get the total number of comments for tracks where licensed = TRUE 

SELECT 
    COUNT(Comments)
FROM spotify 
WHERE 
   licensed = 'TRUE'; 


-- Q4. Find all tracks that belong to the album type single.

SELECT 
    track
FROM spotify 
WHERE 
  Album_type = 'single'


-- Q5. Count the total number of tracks by each artist.

SELECT 
   DISTINCT artist,
   COUNT(track) AS Total_track
FROM spotify
GROUP BY 1


--------------------------------
--- Medium Level 
--------------------------------

-- Q6. Calculate the average danceability of tracks in each album.

SELECT 
     album,
     AVG(danceability)
FROM spotify
GROUP BY 1
ORDER by 2 DESC;



--Q7. Find the top 5 tracks with the highest energy values.

SELECT 
    track,
	Energy
FROM spotify 
GROUP BY 1,2
ORDER BY 2 DESC
LIMIT 5;


--Q8. List all tracks along with their views and likes where official_video = TRUE.


SELECT 
    track,
	SUM(views) AS Total_views,
	SUM(likes) AS Total_likes
FROM spotify 
WHERE official_video = 'TRUE'
GROUP BY 1
ORDER BY 2 DESC



  
--Q9. For each album, calculate the total views of all associated tracks.

SELECT 
   album,
   track,
   SUM(views)
FROM spotify
GROUP BY 1, 2
ORDER BY 3 DESC



--Q10. Retrieve the track names that have been streamed on Spotify more than YouTube.


SELECT * FROM
(SELECT 
    track,
	COALESCE(SUM(CASE WHEN most_playedon = 'Spotify' THEN stream END),0) AS streamed_on_spotify,
	COALESCE(SUM(CASE WHEN most_playedon = 'Youtube' THEN stream END),0) AS streamed_on_youtube
FROM spotify
GROUP BY 1
) AS T1
WHERE 
    streamed_on_spotify > streamed_on_youtube
    AND 
	streamed_on_youtube <> 0




--------------------------------
--- Advanced Level 
--------------------------------


--Q11. Find the top 3 most-viewed tracks for each artist using window functions.

DROP TABLE IF EXISTS ranking
CREATE TABLE ranking
AS
(
SELECT 
     artist,
	 Track,
	 SUM(views) AS Total_Views,
	 DENSE_RANK() OVER (PARTITION BY artist ORDER BY SUM(views) DESC) AS rank
FROM spotify
GROUP BY 1, 2 
ORDER BY 1, 3 DESC   
)
SELECT * FROM ranking
WHERE rank <= 3



-- Q12. Write a query to find tracks where the liveness score is above the average.


SELECT
    track,
	artist,
	liveness
FROM spotify
WHERE liveness > (SELECT AVG(liveness) FROM spotify)



--Q13. Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.

CREATE TABLE cte
AS
(SELECT
    album,
	MAX(energy) AS highest_energy,
	MIN(energy) AS lowest_energy
FROM spotify
GROUP BY 1
)
SELECT 
    album,
	highest_energy - lowest_energy AS energy_diff
FROM cte
ORDER BY 2 DESC


--Q14. Find tracks where the energy-to-liveness ratio is greater than 1.2.

CREATE TABLE ratio_t1
AS
(SELECT 
    track,
    energy/liveness AS ratio
	
FROM spotify
group by 1,2
)
SELECT 
    track,
	ratio
FROM ratio_t1
WHERE ratio > 1.2




--Q15. Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions.


SELECT 
    track,
    views,
    likes,
    SUM(likes) OVER (
        ORDER BY views
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_likes
FROM spotify
ORDER BY 2 DESC;






                                                      -- END --






