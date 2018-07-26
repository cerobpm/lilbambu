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
-- Data for Name: TopicCategoryCV; Type: TABLE DATA; Schema: public; Owner: jbianchi
--

COPY public."TopicCategoryCV" ("Term", "Definition") FROM stdin;
biota	Data associated with biological organisms
boundaries	Data associated with boundaries
climatology/meteorology/atmosphere	Data associated with climatology, meteorology, or the atmosphere
economy	Data associated with the economy
elevation	Data associated with elevation
environment	Data associated with the environment
farming	Data associated with agricultural production
geoscientificInformation	Data associated with geoscientific information
health	Data associated with health
imageryBaseMapsEarthCover	Data associated with imagery, base maps, or earth cover
inlandWaters	Data associated with inland waters
intelligenceMilitary	Data associated with intelligence or the military
location	Data associated with location
oceans	Data associated with oceans
planningCadastre	Data associated with planning or cadestre
society	Data associated with society
structure	Data associated with structure
transportation	Data associated with transportation
Unknown	The topic category is unknown
utilitiesCommunication	Data associated with utilities or communication
\.


--
-- PostgreSQL database dump complete
--

