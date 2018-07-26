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
-- Data for Name: VerticalDatumCV; Type: TABLE DATA; Schema: public; Owner: jbianchi
--

COPY public."VerticalDatumCV" ("Term", "Definition") FROM stdin;
MSL	Mean Sea Level
NAVD88	North American Vertical Datum of 1988
NGVD29	National Geodetic Vertical Datum of 1929
Unknown	The vertical datum is unknown
\.


--
-- PostgreSQL database dump complete
--

