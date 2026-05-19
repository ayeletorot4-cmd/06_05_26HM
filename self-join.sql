CREATE TABLE flights (
  id             INTEGER PRIMARY KEY,
  flight_no      TEXT    NOT NULL,
  origin         TEXT    NOT NULL,
  destination    TEXT    NOT NULL,
  prev_flight_id INTEGER,
  FOREIGN KEY (prev_flight_id) REFERENCES flights(id)
);

INSERT INTO flights VALUES
  (1,'TK101','NYC','London',NULL),
  (2,'TK102','London','Dubai',1),
  (3,'TK103','Dubai','Tokyo',2),
  (4,'TK104','Tokyo','Seoul',3),
  (5,'TK105','Tokyo','Sydney',3),
  (6,'AA201','LA','Chicago',NULL),
  (7,'AA202','Chicago','NYC',6),
  (8,'AA203','NYC','Miami',7),
  (9,'AA204','NYC','Boston',7),
  (10,'BA301','Paris','Rome',NULL),
  (11,'LH401','Frankfurt','Berlin',NULL),
  (12,'LH402','Amsterdam','London',11);

--1)Show every flight with its predecessor flight number — use LEFT JOIN so origin flights (no predecessor) appear with NULL
SELECT
      f.flight_no AS flight,
      p.flight_no AS predecessor_flight 

FROM   flights f
LEFT JOIN flights p ON f.prev_flight_id = p.id;

--2)Show only flights that directly follow 'TK101' (i.e. where the predecessor flight is TK101)
SELECT
      f.flight_no AS flight,
      p.flight_no AS predecessor_flight 

FROM   flights f
LEFT JOIN flights p ON f.prev_flight_id = p.id
WHERE p.flight_no Like 'TK101';

--3)Count how many onward connections each flight has (how many flights list it as predecessor), sorted descending
SELECT
      p.flight_no AS flight,
      COUNT(f.id) AS onward_connections

FROM   flights f
LEFT JOIN flights p ON f.prev_flight_id = p.id
WHERE p.flight_no IS NOT NULL
GROUP BY p.flight_no
ORDER BY onward_connections DESC;

--4)Find flights where the predecessor's destination doesn't match the current flight's origin — a data-inconsistency check
SELECT
      f.flight_no AS flight,
	  f.origin AS     flight_origin,
      p.flight_no AS predecessor_flight,
	  p.destination AS predecessor_destination 

FROM   flights f
INNER JOIN flights p ON f.prev_flight_id = p.id
WHERE f.origin <> p.destination ;
