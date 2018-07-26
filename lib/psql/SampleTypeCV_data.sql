--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.13
-- Dumped by pg_dump version 9.5.13

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Data for Name: SampleTypeCV; Type: TABLE DATA; Schema: public; Owner: jbianchi
--

COPY public."SampleTypeCV" ("Term", "Definition") FROM stdin;
Automated	Sample collected using an automated sampler
FD 	 Foliage Digestion
FF 	 Forest Floor Digestion
FL 	 Foliage Leaching
Grab	Grab sample
GW 	 Groundwater
LF 	 Litter Fall Digestion
meteorological	sample type can include a number of measured sample types including temperature, RH, solar radiation, precipitation, wind speed, wind direction.
No Sample	There is no lab sample associated with this measurement
PB  	 Precipitation Bulk
PD 	 Petri Dish (Dry Deposition)
PE 	 Precipitation Event
PI 	 Precipitation Increment
PW 	 Precipitation Weekly
RE 	 Rock Extraction
SE 	 Stemflow Event
SR 	 Standard Reference
SS 	Streamwater Suspended Sediment
SW 	 Streamwater
TE 	 Throughfall Event
TI 	 Throughfall Increment
TW 	 Throughfall Weekly
Unknown	The sample type is unknown
VE 	 Vadose Water Event
VI 	 Vadose Water Increment
VW 	 Vadose Water Weekly
\.


--
-- PostgreSQL database dump complete
--

