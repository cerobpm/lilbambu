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
-- Data for Name: CensorCodeCV; Type: TABLE DATA; Schema: public; Owner: jbianchi
--

COPY public."CensorCodeCV" ("Term", "Definition") FROM stdin;
gt	greater than
lt	less than
nc	not censored
nd	non-detect
pnq	present but not quantified
\.


--
-- PostgreSQL database dump complete
--

