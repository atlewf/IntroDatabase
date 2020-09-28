SELECT ROUND(AVG(U.Review_count), 2) AS average
FROM Users U;

SELECT COUNT (DISTINCT B.Business_ID) as business_count
FROM Businesses B, Locations L
WHERE B.Business_ID = L.Business_ID AND L.State IN ('QC', 'AB');

SELECT B.Business_ID, COUNT(*) as count
FROM Businesses B, Categories C
WHERE B.Business_ID = C.Business_ID
GROUP BY C.Business_ID, B.Business_ID
ORDER BY COUNT(*) DESC
FETCH FIRST 1 ROWS ONLY;

SELECT COUNT(DISTINCT C.Business_ID) as count
FROM Categories C
WHERE C.Categorie IN ('Dry Cleaners', 'Dry Cleaning');

SELECT SUM(Review_Count) as Overall_review_count
FROM (
    SELECT DISTINCT B.Business_ID, B.Review_Count as Review_Count
    FROM Businesses B
    WHERE B.Review_Count >= 150 AND B.Business_ID IN (	
        
        SELECT DR.Business_ID
        FROM DietaryRestrictionsAttributes DR
        GROUP BY DR.Business_ID
        HAVING COUNT(*) > 1
        )
    );

SELECT F.User1_id as user_id, COUNT(*) AS Friends
FROM Friendships F
GROUP BY F.User1_ID
ORDER BY Friends DESC
FETCH FIRST 10 ROWS ONLY;

SELECT B.Name, B.Stars, B.Review_Count
FROM Businesses B, Locations L
WHERE B.Business_ID = L.Business_ID AND L.City = 'San Diego' AND B.Is_Open = 1
ORDER BY B.Review_Count DESC
FETCH FIRST 5 ROWS ONLY;

SELECT L.State, COUNT(*) as count
FROM Locations L, Businesses B
WHERE L.Business_ID =  B.Business_ID
GROUP BY L.State
ORDER BY COUNT(*) DESC
FETCH FIRST 1 ROWS ONLY;

SELECT E.year, ROUND(AVG(U.Average_stars),2) as average_stars
FROM Elite E, Users U
WHERE U.User_ID = E.User_ID
GROUP BY E.year
ORDER BY E.year DESC;

SELECT B.name
FROM Locations L, Businesses B
WHERE L.Business_ID = B.Business_ID AND B.Is_Open = 1 AND L.City = 'New York'
ORDER BY B.Stars DESC
FETCH FIRST 10 ROWS ONLY;

SELECT MIN(count) as min , MAX(count) as max, ROUND(AVG(count),1) as mean, MEDIAN(count) as median
FROM ( SELECT COUNT(*) as count
    FROM Categories C 
    GROUP BY C.Business_ID 
    );

SELECT B.Name, B.Stars, B.Review_Count
FROM BusinessParkingAttributes P, Locations L, Hours H, Businesses B, IsOpen IO
WHERE IO.Hour_ID = H.Hour_ID AND IO.Business_ID = B.Business_ID AND L.Business_ID = B.Business_ID AND P.Business_ID = B.Business_ID
    AND P.BusinessParking = 'valet'
    AND L.City = 'Las Vegas' 
    AND H.day = 'Friday'
    AND ( TO_NUMBER(SUBSTR(H.opening, 0,2)) < 19 OR SUBSTR(H.opening, 0,4) = '19:00' )
    AND ( TO_NUMBER(SUBSTR(H.closing, 0,2)) >= 23);
    
    
/* 
DELIVERABLE 3
*/
SELECT COUNT(*) as count
FROM Businesses B, Locations L
WHERE B.business_id = L.business_id AND L.state = 'ON'
		 AND B.review_count > 5 AND B.stars > 4.2;
        
    
WITH first1 as (SELECT B.business_id as id, B.stars as stars
    FROM Businesses B, Goodformealattributes G
    WHERE B.business_id = G.business_id AND G.goodformeal = 'dinner')
SELECT ROUND((SELECT AVG(F1.stars) FROM first1 F1, Noiselevelattributes N1 WHERE F1.id = N1.business_id AND N1.noiselevel IN ('loud', 'very_loud')) - 
(SELECT AVG(F2.stars) FROM first1 F2, Noiselevelattributes N2 WHERE F2.id = N2.business_id AND N2.noiselevel IN ('average', 'quiet')), 2)as difference
FROM DUAL;

SELECT B.name, B.stars, B.review_count
FROM Businesses B, Categories C, Musicattributes M
WHERE B.business_id = C.business_id AND B.business_id = M.business_id AND M.music = 'live' AND C.Categorie = 'Irish Pub';

SELECT ( SELECT ROUND( AVG(U1.useful),2) FROM Users U1 WHERE U1.average_stars>=2 AND U1.average_stars < 4 AND U1.user_id NOT IN (SELECT user_id FROM Elite)) as regular_24 ,
    (SELECT ROUND( AVG(U2.useful),2) FROM Users U2 WHERE (U2.average_stars BETWEEN 4 AND 5) AND U2.user_id NOT IN (SELECT user_id FROM Elite)) as regular_45,
    (SELECT ROUND( AVG(U3.useful),2) FROM Users U3, Elite E WHERE U3.average_stars>=2 AND U3.average_stars < 4 AND U3.user_id = E.user_id) as elite_24,
    (SELECT ROUND( AVG(U4.useful),2) FROM Users U4, Elite E WHERE (U4.average_stars BETWEEN 4 AND 5) AND U4.user_id = E.user_id) as elite_45 FROM DUAL; 
    
SELECT ROUND(AVG(B.stars),2) as average_stars, ROUND(AVG(B.review_count),2) as average_reviewcount
FROM Businesses B, ( SELECT C.business_id as id FROM Categories C GROUP BY C.business_id HAVING COUNT(*) >= 2) C1, ( SELECT P.business_id as id FROM BusinessParkingAttributes P GROUP BY P.business_id HAVING COUNT(*) >=2) P1
WHERE B.business_id = C1.id AND B.business_id = P1.id;

SELECT ROUND((SELECT COUNT(DISTINCT B.business_id)
FROM Businesses B, GoodForMealAttributes G
WHERE B.business_id = G.business_id AND G.goodformeal = 'latenight') / (SELECT COUNT(*) FROM Businesses B),4) as Fraction
FROM DUAL;

SELECT DISTINCT L1.City 
FROM Locations L1
MINUS 
SELECT DISTINCT L2.City
FROM Locations L2
WHERE L2.business_id IN (SELECT B.business_id
	FROM Businesses B, Hours H
	WHERE B.business_id = H.hour_id AND H.day = 'sunday');

SELECT rev.business_id
FROM (SELECT business_id, COUNT (DISTINCT user_id) as number1
	FROM Reviews
	GROUP BY business_id) rev
WHERE rev.number1 > 1030;

SELECT B.name, B.stars
FROM Businesses B, Locations L
WHERE B.business_id = L.business_id AND L.state = 'CA'
ORDER BY B.stars DESC
FETCH FIRST 10 ROWS ONLY;

SELECT ranks.id, ranks.stars, ranks.state 
FROM (	SELECT B.business_id as id,
	B.stars as stars,
	L.state as state,
	ROW_NUMBER() over (PARTITION BY L.state ORDER BY B.stars DESC) AS rating
	FROM Locations L, Businesses B
	WHERE B.business_id = L.business_id
	) ranks
WHERE ranks.rating <=10;

SELECT DISTINCT L1.City
FROM Locations L1
MINUS 
SELECT DISTINCT L2.City
FROM Locations L2, ( SELECT R.business_id as id
	FROM Reviews R
	GROUP BY R.business_id
	HAVING COUNT(*) < 2
	) counter
WHERE L2.business_id = counter.id;

    
SELECT COUNT(DISTINCT business_id) as count FROM tips t1
WHERE LOWER(text) LIKE '%awesome%' AND user_id IN
(SELECT user_id FROM tips t2 WHERE LOWER(text) LIKE '%awesome%' AND t2.business_id != t1.business_id AND t2.tipdate < t1.tipdate AND t2.tipdate+0 BETWEEN t1.tipdate-1 AND t1.tipdate+0);

SELECT MAX(COUNT(DISTINCT R.business_id)) as count
	FROM Reviews R
	GROUP By R.user_id;

SELECT ROUND( ( SELECT AVG(R1.useful)
	FROM Reviews R1
	WHERE R1.user_id IN (SELECT user_id FROM Elite))
- (SELECT AVG(R2.useful)
    FROM Reviews R2
    WHERE R2.user_id NOT IN (SELECT user_id FROM Elite)),2) as difference
FROM DUAL;

SELECT DISTINCT B.name
FROM Businesses B, Hours H, GoodformealAttributes G, IsOpen IO
WHERE H.hour_id = IO.hour_id AND B.business_id = IO.business_ID AND G.business_id = B.business_id AND B.stars >= 4.5 
AND lower(G.GoodForMeal) = 'brunch' AND lower(H.day) = 'saturday' AND IO.business_id IN 
 (SELECT IO2.business_id FROM IsOpen IO2, Hours H2 WHERE H2.hour_id = IO2.hour_id AND lower(H2.day) = 'sunday');


SELECT B.name, B.stars, ROUND(AVG(R.stars),2) as average_stars
FROM DietaryRestrictionsAttributes D, Businesses B, Locations L, Hours H, IsOpen IO, Reviews R
WHERE IO.hour_ID = H.hour_id AND L.City = 'Los Angeles' AND IO.business_id = B.business_id AND B.business_id = L.business_id AND R.business_id = B.business_id
AND B.business_id = D.business_id AND LOWER(D.Dietaryrestrictions) = 'vegetarian' AND D.business_id IN 
(SELECT D2.business_ID FROM DietaryRestrictionsAttributes D2 WHERE LOWER(D2.Dietaryrestrictions)='vegan')
AND ( TO_NUMBER(SUBSTR(H.opening, 0,2)) < 14 OR SUBSTR(H.opening, 0,4) = '16:00' )
    AND ( TO_NUMBER(SUBSTR(H.closing, 0,2)) >= 16)
GROUP BY (B.name, B.stars)
ORDER BY AVG(R.stars) DESC
FETCH FIRST 5 ROWS ONLY;

SELECT ROUND( ( SELECT AVG(R.stars)
	FROM Reviews R, ( SELECT G.business_id as id
			FROM GoodForMealAttributes G
			WHERE G.Goodformeal = 'dinner') dinner, Ambienceattributes A
	WHERE R.business_id = dinner.id AND A.business_id = dinner.id AND  A.ambience = 'upscale')
- (SELECT AVG(R2.stars)
	FROM Reviews R2, ( SELECT G2.business_id as id
			FROM GoodForMealAttributes G2
			WHERE G2.goodformeal = 'dinner') dinner2, Ambienceattributes A2
	WHERE R2.business_id = dinner2.id AND A2.business_id = dinner2.id AND A2.ambience = 'divey'),2) as difference
FROM DUAL;

SELECT COUNT(*) as count
FROM ( SELECT L2.City
	FROM Businesses B, Locations L2
	WHERE B.review_count >= 100 AND B.business_id = L2.business_id and L2.City IN (SELECT L.city
		FROM Locations L
		GROUP by L.city
		HAVING COUNT(*) >=5 )
	GROUP BY L2.City
	HAVING COUNT(*) > 5) subquery;

WITH ranks AS ( SELECT L.City as city, B.review_count as review_count,
    ROW_NUMBER() over (PARTITION BY L.City ORDER BY B.review_count DESC) AS rating
	FROM Locations L, Businesses B
	WHERE B.business_id = L.business_id)
SELECT trim(r1.City) as City
FROM (SELECT R1.city, SUM(R1.review_count) as rev_count FROM ranks R1 WHERE R1.rating<=100 GROUP BY R1.city) r1,
	 (SELECT R2.city, SUM(R2.review_count) as rev_count FROM ranks R2 WHERE R2.rating>100 GROUP BY R2.city) r2
WHERE r1.City = r2.City AND r1.rev_count >= (2*r2.rev_count);


WITH topten AS (SELECT business_id, review_count FROM businesses ORDER BY review_count DESC FETCH FIRST 10 ROWS ONLY)
SELECT TRIM(B.name) as business, ranks.user_id, ranks.review_count
FROM (SELECT r.business_id,
    u.user_id,
    u.review_count,
    ROW_NUMBER() over (PARTITION BY T.business_id ORDER BY U.review_count DESC) as rating
    FROM Users U, Reviews R, topten T
    WHERE R.business_id = T.business_id AND U.user_id = R.user_id) ranks,
    Businesses B
WHERE B.business_id = ranks.business_id AND ranks.rating <= 3
ORDER BY B.name, review_count DESC;

SELECT city
FROM Locations
WHERE city LIKE '%Phoenix%';
