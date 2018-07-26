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
-- Data for Name: GeneralCategoryCV; Type: TABLE DATA; Schema: public; Owner: jbianchi
--

COPY public."GeneralCategoryCV" ("Term", "Definition") FROM stdin;
Biota	Data associated with biological organisms
Climate	Data associated with the climate, weather, or atmospheric processes
Geology	Data associated with geology or geological processes
Hydrology	Data associated with hydrologic variables or processes
Instrumentation	Data associated with instrumentation and instrument properties such as battery voltages, data logger temperatures, often useful for diagnosis.
Unknown	The general category is unknown
Water Quality	Data associated with water quality variables or processes
\.


--
-- PostgreSQL database dump complete
--

