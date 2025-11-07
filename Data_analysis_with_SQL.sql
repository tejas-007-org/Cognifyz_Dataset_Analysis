use py_sql_project;

CREATE TABLE restaurants (
  restaurant_id INT,
  restaurant_name VARCHAR(255),
  country_code INT,
  city VARCHAR(100),
  address VARCHAR(255),
  locality VARCHAR(255),
  locality_verbose VARCHAR(255),
  longitude FLOAT,
  latitude FLOAT,
  cuisines TEXT,
  average_cost_for_two FLOAT,
  currency VARCHAR(50),
  has_table_booking VARCHAR(10),
  has_online_delivery VARCHAR(10),
  is_delivering_now VARCHAR(10),
  switch_to_order_menu VARCHAR(10),
  price_range INT,
  aggregate_rating FLOAT,
  rating_color VARCHAR(20),
  rating_text VARCHAR(50),
  votes INT
);

SELECT * FROM restaurants;


# TOP-3 CUISINES
SELECT cuisines, COUNT(cuisines) AS total
FROM restaurants
GROUP BY cuisines
ORDER BY total DESC
LIMIT 4;

# PERCENTAGE OF RESTAURANT THAT SERVE EACH OF THE TOP CUISINES
SELECT cuisines,COUNT(restaurant_id) AS total_restaurants,ROUND(100 * COUNT(*) / (SELECT COUNT(*) FROM restaurants), 2) AS percentage
FROM restaurants
GROUP BY cuisines
ORDER BY total_restaurants DESC
LIMIT 5;

# CITY WITH HIGHEST NUMBER OF RESTAURANTS
SELECT city,COUNT(restaurant_id) AS TOTAL_RESTAURANTS
FROM restaurants 
GROUP BY city
ORDER BY TOTAL_RESTAURANTS DESC
LIMIT 1;

# AVG RATING FOR RESTAURANT FOR EACH CITY
SELECT city,ROUND(AVG(aggregate_rating),2) AS AVG_RATING 
FROM restaurants 
GROUP BY city
order by AVG_RATING;

# CITY WITH HIGHEST RATING
SELECT city,ROUND(AVG(aggregate_rating),2) AS AVG_RATING 
FROM restaurants 
GROUP BY city
order by AVG_RATING DESC
LIMIT 1;

# PERCENTAGE OF RESTAURANT IN EACH PRICE RANGE CATEGORY
SELECT price_range,ROUND(100 * COUNT(*) / (SELECT COUNT(*) FROM restaurants), 2) AS restaurant_percentage
FROM restaurants
GROUP BY price_range
ORDER BY restaurant_percentage DESC;


# PERCENTAGE OF RESTAURANTS OFFERING ONLINE DELIEVERY
SELECT  has_online_delivery,ROUND(100 * COUNT(*) / (SELECT COUNT(*) FROM restaurants), 2) AS restaurant_percentage
FROM restaurants
WHERE  has_online_delivery="yes"
group by  has_online_delivery;

# COMPAIRING THE AVG RATING OF RESTAURANTS WITH AND WITHOUT ONLINE DELIEVERY
SELECT has_online_delivery,ROUND(AVG(aggregate_rating),2) AS avg_rating
FROM restaurants
GROUP BY has_online_delivery;


# Distribution of aggregate ratings
SELECT CASE
         WHEN aggregate_rating BETWEEN 0 AND 1 THEN '0-1'
         WHEN aggregate_rating BETWEEN 1 AND 2 THEN '1-2'
         WHEN aggregate_rating BETWEEN 2 AND 3 THEN '2-3'
         WHEN aggregate_rating BETWEEN 3 AND 4 THEN '3-4'
         WHEN aggregate_rating BETWEEN 4 AND 5 THEN '4-5'
       END AS rating_range, COUNT(aggregate_rating) AS total_rating
FROM restaurants
GROUP BY rating_range
ORDER BY total_rating DESC
LIMIT 1;


# AVERAGE NUMBER OF VOTES RECEIVED BY THE RESTAURANTS
SELECT ROUND(AVG(votes),2) AS AVG_VOTES,restaurant_name
FROM restaurants
GROUP BY restaurant_name
ORDER BY AVG_VOTES DESC;

# THE MOST COMMON COMBINATION OF CUISINES
SELECT cuisines,COUNT(*) AS total_restaurants
FROM restaurants
GROUP BY cuisines
ORDER BY total_restaurants DESC
LIMIT 10;


# Average rating for each cuisine combination
SELECT ROUND(AVG(aggregate_rating), 2) AS avg_rating ,cuisines
FROM restaurants
GROUP BY cuisines
ORDER BY avg_rating DESC
LIMIT 10;


# Identifying restaurant chains
SELECT restaurant_name,COUNT(restaurant_id) AS total_branches
FROM restaurants
GROUP BY restaurant_name
HAVING total_branches > 1
ORDER BY total_branches DESC
LIMIT 10;


# Average rating of each chain
SELECT restaurant_name, COUNT(restaurant_id) AS total_branches, ROUND(AVG(aggregate_rating), 2) AS avg_rating
FROM restaurants
GROUP BY restaurant_name
HAVING total_branches > 1
ORDER BY avg_rating DESC
LIMIT 10;

#  PRICE RANGE VS ONLINE DELIEVERY VS TABLE BOOKING 
SELECT price_range,
       ROUND(100 * SUM(CASE WHEN has_online_delivery = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS pct_online_delivery,
       ROUND(100 * SUM(CASE WHEN has_table_booking = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS pct_table_booking
FROM restaurants
GROUP BY price_range
ORDER BY price_range;




