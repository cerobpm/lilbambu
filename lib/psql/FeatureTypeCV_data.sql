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
-- Data for Name: FeatureTypeCV; Type: TABLE DATA; Schema: public; Owner: jbianchi
--

COPY public."FeatureTypeCV" ("FeatureTypeID", "FeatureTypeName", "Description") FROM stdin;
1	point	\N
2	area	\N
3	line	\N
4	grid	\N
\.


--
-- Name: FeatureTypeCV_FeatureTypeID_seq; Type: SEQUENCE SET; Schema: public; Owner: jbianchi
--

SELECT pg_catalog.setval('public."FeatureTypeCV_FeatureTypeID_seq"', 1, false);


--
-- PostgreSQL database dump complete
--

