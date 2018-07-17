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
-- Name: tiger; Type: SCHEMA; Schema: -; Owner: jbianchi
--

CREATE SCHEMA tiger;


ALTER SCHEMA tiger OWNER TO jbianchi;

--
-- Name: tiger_data; Type: SCHEMA; Schema: -; Owner: jbianchi
--

CREATE SCHEMA tiger_data;


ALTER SCHEMA tiger_data OWNER TO jbianchi;

--
-- Name: topology; Type: SCHEMA; Schema: -; Owner: jbianchi
--

CREATE SCHEMA topology;


ALTER SCHEMA topology OWNER TO jbianchi;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: address_standardizer; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS address_standardizer WITH SCHEMA public;


--
-- Name: EXTENSION address_standardizer; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION address_standardizer IS 'Used to parse an address into constituent elements. Generally used to support geocoding address normalization step.';


--
-- Name: address_standardizer_data_us; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS address_standardizer_data_us WITH SCHEMA public;


--
-- Name: EXTENSION address_standardizer_data_us; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION address_standardizer_data_us IS 'Address Standardizer US dataset example';


--
-- Name: fuzzystrmatch; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS fuzzystrmatch WITH SCHEMA public;


--
-- Name: EXTENSION fuzzystrmatch; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION fuzzystrmatch IS 'determine similarities and distance between strings';


--
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry, geography, and raster spatial types and functions';


--
-- Name: postgis_tiger_geocoder; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS postgis_tiger_geocoder WITH SCHEMA tiger;


--
-- Name: EXTENSION postgis_tiger_geocoder; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis_tiger_geocoder IS 'PostGIS tiger geocoder and reverse geocoder';


--
-- Name: postgis_topology; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS postgis_topology WITH SCHEMA topology;


--
-- Name: EXTENSION postgis_topology; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis_topology IS 'PostGIS topology spatial types and functions';


--
-- Name: trg_geom_default(); Type: FUNCTION; Schema: public; Owner: jbianchi
--

CREATE FUNCTION public.trg_geom_default() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN

NEW."Geometry" := st_setsrid(st_point(NEW."Longitude",NEW."Latitude"),4326);

RETURN NEW;

END
$$;


ALTER FUNCTION public.trg_geom_default() OWNER TO jbianchi;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: Categories; Type: TABLE; Schema: public; Owner: jbianchi
--

CREATE TABLE public."Categories" (
    "VariableID" integer NOT NULL,
    "DataValue" real NOT NULL,
    "CategoryDescription" text NOT NULL
);


ALTER TABLE public."Categories" OWNER TO jbianchi;

--
-- Name: CensorCodeCV; Type: TABLE; Schema: public; Owner: jbianchi
--

CREATE TABLE public."CensorCodeCV" (
    "Term" character varying(50) NOT NULL,
    "Definition" text
);


ALTER TABLE public."CensorCodeCV" OWNER TO jbianchi;

--
-- Name: DataTypeCV; Type: TABLE; Schema: public; Owner: jbianchi
--

CREATE TABLE public."DataTypeCV" (
    "Term" character varying(255) NOT NULL,
    "Definition" text
);


ALTER TABLE public."DataTypeCV" OWNER TO jbianchi;

--
-- Name: DataValues; Type: TABLE; Schema: public; Owner: jbianchi
--

CREATE TABLE public."DataValues" (
    "ValueID" integer NOT NULL,
    "DataValue" real NOT NULL,
    "ValueAccuracy" real,
    "LocalDateTime" timestamp without time zone NOT NULL,
    "UTCOffset" real NOT NULL,
    "DateTimeUTC" timestamp without time zone NOT NULL,
    "SiteID" integer NOT NULL,
    "VariableID" integer NOT NULL,
    "OffsetValue" real,
    "OffsetTypeID" integer,
    "CensorCode" character varying(50) DEFAULT 'nc'::character varying NOT NULL,
    "QualifierID" integer,
    "MethodID" integer DEFAULT 0 NOT NULL,
    "SourceID" integer NOT NULL,
    "SampleID" integer,
    "DerivedFromID" integer,
    "QualityControlLevelID" integer DEFAULT 0 NOT NULL
);


ALTER TABLE public."DataValues" OWNER TO jbianchi;

--
-- Name: DataValues_ValueID_seq; Type: SEQUENCE; Schema: public; Owner: jbianchi
--

CREATE SEQUENCE public."DataValues_ValueID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."DataValues_ValueID_seq" OWNER TO jbianchi;

--
-- Name: DataValues_ValueID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jbianchi
--

ALTER SEQUENCE public."DataValues_ValueID_seq" OWNED BY public."DataValues"."ValueID";


--
-- Name: DerivedFrom; Type: TABLE; Schema: public; Owner: jbianchi
--

CREATE TABLE public."DerivedFrom" (
    "DerivedFromID" integer NOT NULL,
    "ValueID" integer NOT NULL
);


ALTER TABLE public."DerivedFrom" OWNER TO jbianchi;

--
-- Name: GeneralCategoryCV; Type: TABLE; Schema: public; Owner: jbianchi
--

CREATE TABLE public."GeneralCategoryCV" (
    "Term" character varying(255) NOT NULL,
    "Definition" text
);


ALTER TABLE public."GeneralCategoryCV" OWNER TO jbianchi;

--
-- Name: GroupDescriptions; Type: TABLE; Schema: public; Owner: jbianchi
--

CREATE TABLE public."GroupDescriptions" (
    "GroupID" integer NOT NULL,
    "GroupDescription" text
);


ALTER TABLE public."GroupDescriptions" OWNER TO jbianchi;

--
-- Name: GroupDescriptions_GroupID_seq; Type: SEQUENCE; Schema: public; Owner: jbianchi
--

CREATE SEQUENCE public."GroupDescriptions_GroupID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."GroupDescriptions_GroupID_seq" OWNER TO jbianchi;

--
-- Name: GroupDescriptions_GroupID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jbianchi
--

ALTER SEQUENCE public."GroupDescriptions_GroupID_seq" OWNED BY public."GroupDescriptions"."GroupID";


--
-- Name: Groups; Type: TABLE; Schema: public; Owner: jbianchi
--

CREATE TABLE public."Groups" (
    "GroupID" integer NOT NULL,
    "ValueID" integer NOT NULL
);


ALTER TABLE public."Groups" OWNER TO jbianchi;

--
-- Name: ISOMetadata; Type: TABLE; Schema: public; Owner: jbianchi
--

CREATE TABLE public."ISOMetadata" (
    "MetadataID" integer NOT NULL,
    "TopicCategory" character varying(255) DEFAULT 'Unknown'::character varying NOT NULL,
    "Title" character varying(255) DEFAULT 'Unknown'::character varying NOT NULL,
    "Abstract" text NOT NULL,
    "ProfileVersion" character varying(255) DEFAULT 'Unknown'::character varying NOT NULL,
    "MetadataLink" text
);


ALTER TABLE public."ISOMetadata" OWNER TO jbianchi;

--
-- Name: ISOMetadata_MetadataID_seq; Type: SEQUENCE; Schema: public; Owner: jbianchi
--

CREATE SEQUENCE public."ISOMetadata_MetadataID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."ISOMetadata_MetadataID_seq" OWNER TO jbianchi;

--
-- Name: ISOMetadata_MetadataID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jbianchi
--

ALTER SEQUENCE public."ISOMetadata_MetadataID_seq" OWNED BY public."ISOMetadata"."MetadataID";


--
-- Name: LabMethods; Type: TABLE; Schema: public; Owner: jbianchi
--

CREATE TABLE public."LabMethods" (
    "LabMethodID" integer NOT NULL,
    "LabName" character varying(255) DEFAULT 'Unknown'::character varying NOT NULL,
    "LabOrganization" character varying(255) DEFAULT 'Unknown'::character varying NOT NULL,
    "LabMethodName" character varying(255) DEFAULT 'Unknown'::character varying NOT NULL,
    "LabMethodDescription" text NOT NULL,
    "LabMethodLink" text
);


ALTER TABLE public."LabMethods" OWNER TO jbianchi;

--
-- Name: LabMethods_LabMethodID_seq; Type: SEQUENCE; Schema: public; Owner: jbianchi
--

CREATE SEQUENCE public."LabMethods_LabMethodID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."LabMethods_LabMethodID_seq" OWNER TO jbianchi;

--
-- Name: LabMethods_LabMethodID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jbianchi
--

ALTER SEQUENCE public."LabMethods_LabMethodID_seq" OWNED BY public."LabMethods"."LabMethodID";


--
-- Name: Methods; Type: TABLE; Schema: public; Owner: jbianchi
--

CREATE TABLE public."Methods" (
    "MethodID" integer NOT NULL,
    "MethodDescription" text NOT NULL,
    "MethodLink" text
);


ALTER TABLE public."Methods" OWNER TO jbianchi;

--
-- Name: Methods_MethodID_seq; Type: SEQUENCE; Schema: public; Owner: jbianchi
--

CREATE SEQUENCE public."Methods_MethodID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Methods_MethodID_seq" OWNER TO jbianchi;

--
-- Name: Methods_MethodID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jbianchi
--

ALTER SEQUENCE public."Methods_MethodID_seq" OWNED BY public."Methods"."MethodID";


--
-- Name: ODMVersion; Type: TABLE; Schema: public; Owner: jbianchi
--

CREATE TABLE public."ODMVersion" (
    "VersionNumber" character varying(50) NOT NULL
);


ALTER TABLE public."ODMVersion" OWNER TO jbianchi;

--
-- Name: OffsetTypes; Type: TABLE; Schema: public; Owner: jbianchi
--

CREATE TABLE public."OffsetTypes" (
    "OffsetTypeID" integer NOT NULL,
    "OffsetUnitsID" integer NOT NULL,
    "OffsetDescription" text NOT NULL
);


ALTER TABLE public."OffsetTypes" OWNER TO jbianchi;

--
-- Name: OffsetTypes_OffsetTypeID_seq; Type: SEQUENCE; Schema: public; Owner: jbianchi
--

CREATE SEQUENCE public."OffsetTypes_OffsetTypeID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."OffsetTypes_OffsetTypeID_seq" OWNER TO jbianchi;

--
-- Name: OffsetTypes_OffsetTypeID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jbianchi
--

ALTER SEQUENCE public."OffsetTypes_OffsetTypeID_seq" OWNED BY public."OffsetTypes"."OffsetTypeID";


--
-- Name: Qualifiers; Type: TABLE; Schema: public; Owner: jbianchi
--

CREATE TABLE public."Qualifiers" (
    "QualifierID" integer NOT NULL,
    "QualifierCode" character varying(50) DEFAULT NULL::character varying,
    "QualifierDescription" text NOT NULL
);


ALTER TABLE public."Qualifiers" OWNER TO jbianchi;

--
-- Name: Qualifiers_QualifierID_seq; Type: SEQUENCE; Schema: public; Owner: jbianchi
--

CREATE SEQUENCE public."Qualifiers_QualifierID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Qualifiers_QualifierID_seq" OWNER TO jbianchi;

--
-- Name: Qualifiers_QualifierID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jbianchi
--

ALTER SEQUENCE public."Qualifiers_QualifierID_seq" OWNED BY public."Qualifiers"."QualifierID";


--
-- Name: QualityControlLevels; Type: TABLE; Schema: public; Owner: jbianchi
--

CREATE TABLE public."QualityControlLevels" (
    "QualityControlLevelID" integer NOT NULL,
    "QualityControlLevelCode" character varying(50) NOT NULL,
    "Definition" character varying(255) NOT NULL,
    "Explanation" text NOT NULL
);


ALTER TABLE public."QualityControlLevels" OWNER TO jbianchi;

--
-- Name: QualityControlLevels_QualityControlLevelID_seq; Type: SEQUENCE; Schema: public; Owner: jbianchi
--

CREATE SEQUENCE public."QualityControlLevels_QualityControlLevelID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."QualityControlLevels_QualityControlLevelID_seq" OWNER TO jbianchi;

--
-- Name: QualityControlLevels_QualityControlLevelID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jbianchi
--

ALTER SEQUENCE public."QualityControlLevels_QualityControlLevelID_seq" OWNED BY public."QualityControlLevels"."QualityControlLevelID";


--
-- Name: SampleMediumCV; Type: TABLE; Schema: public; Owner: jbianchi
--

CREATE TABLE public."SampleMediumCV" (
    "Term" character varying(255) NOT NULL,
    "Definition" text
);


ALTER TABLE public."SampleMediumCV" OWNER TO jbianchi;

--
-- Name: SampleTypeCV; Type: TABLE; Schema: public; Owner: jbianchi
--

CREATE TABLE public."SampleTypeCV" (
    "Term" character varying(255) NOT NULL,
    "Definition" text
);


ALTER TABLE public."SampleTypeCV" OWNER TO jbianchi;

--
-- Name: Samples; Type: TABLE; Schema: public; Owner: jbianchi
--

CREATE TABLE public."Samples" (
    "SampleID" integer NOT NULL,
    "SampleType" character varying(255) DEFAULT 'Unknown'::character varying NOT NULL,
    "LabSampleCode" character varying(50) NOT NULL,
    "LabMethodID" integer DEFAULT 0 NOT NULL
);


ALTER TABLE public."Samples" OWNER TO jbianchi;

--
-- Name: Samples_SampleID_seq; Type: SEQUENCE; Schema: public; Owner: jbianchi
--

CREATE SEQUENCE public."Samples_SampleID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Samples_SampleID_seq" OWNER TO jbianchi;

--
-- Name: Samples_SampleID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jbianchi
--

ALTER SEQUENCE public."Samples_SampleID_seq" OWNED BY public."Samples"."SampleID";


--
-- Name: SeriesCatalog; Type: TABLE; Schema: public; Owner: jbianchi
--

CREATE TABLE public."SeriesCatalog" (
    "SeriesID" integer NOT NULL,
    "SiteID" integer,
    "SiteCode" character varying(50) DEFAULT NULL::character varying,
    "SiteName" character varying(255) DEFAULT NULL::character varying,
    "SiteType" character varying(255) DEFAULT NULL::character varying,
    "VariableID" integer,
    "VariableCode" character varying(50) DEFAULT NULL::character varying,
    "VariableName" character varying(255) DEFAULT NULL::character varying,
    "Speciation" character varying(255) DEFAULT NULL::character varying,
    "VariableUnitsID" integer,
    "VariableUnitsName" character varying(255) DEFAULT NULL::character varying,
    "SampleMedium" character varying(255) DEFAULT NULL::character varying,
    "ValueType" character varying(255) DEFAULT NULL::character varying,
    "TimeSupport" real,
    "TimeUnitsID" integer,
    "TimeUnitsName" character varying(255) DEFAULT NULL::character varying,
    "DataType" character varying(255) DEFAULT NULL::character varying,
    "GeneralCategory" character varying(255) DEFAULT NULL::character varying,
    "MethodID" integer,
    "MethodDescription" text,
    "SourceID" integer,
    "Organization" character varying(255) DEFAULT NULL::character varying,
    "SourceDescription" text,
    "Citation" text,
    "QualityControlLevelID" integer,
    "QualityControlLevelCode" character varying(50) DEFAULT NULL::character varying,
    "BeginDateTime" timestamp without time zone,
    "EndDateTime" timestamp without time zone,
    "BeginDateTimeUTC" timestamp without time zone,
    "EndDateTimeUTC" timestamp without time zone,
    "ValueCount" integer
);


ALTER TABLE public."SeriesCatalog" OWNER TO jbianchi;

--
-- Name: SeriesCatalog_SeriesID_seq; Type: SEQUENCE; Schema: public; Owner: jbianchi
--

CREATE SEQUENCE public."SeriesCatalog_SeriesID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."SeriesCatalog_SeriesID_seq" OWNER TO jbianchi;

--
-- Name: SeriesCatalog_SeriesID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jbianchi
--

ALTER SEQUENCE public."SeriesCatalog_SeriesID_seq" OWNED BY public."SeriesCatalog"."SeriesID";


--
-- Name: Sites; Type: TABLE; Schema: public; Owner: jbianchi
--

CREATE TABLE public."Sites" (
    "SiteID" integer NOT NULL,
    "SiteCode" character varying(50) NOT NULL,
    "SiteName" character varying(255) NOT NULL,
    "Latitude" real NOT NULL,
    "Longitude" real NOT NULL,
    "LatLongDatumID" integer DEFAULT 0 NOT NULL,
    "SiteType" character varying(255) DEFAULT NULL::character varying,
    "Elevation_m" real,
    "VerticalDatum" character varying(255) DEFAULT NULL::character varying,
    "LocalX" real,
    "LocalY" real,
    "LocalProjectionID" integer,
    "PosAccuracy_m" real,
    "State" character varying(255) DEFAULT NULL::character varying,
    "County" character varying(255) DEFAULT NULL::character varying,
    "Comments" text,
    "Country" character varying(255) DEFAULT NULL::character varying,
    "Geometry" public.geometry
);


ALTER TABLE public."Sites" OWNER TO jbianchi;

--
-- Name: SiteInfoXML; Type: VIEW; Schema: public; Owner: jbianchi
--

CREATE VIEW public."SiteInfoXML" AS
 SELECT "Sites"."SiteID",
    XMLELEMENT(NAME "siteInfo", XMLATTRIBUTES("Sites"."SiteID" AS oid), XMLELEMENT(NAME "sr:siteName", "Sites"."SiteName"), XMLELEMENT(NAME "sr:siteCode", XMLATTRIBUTES(true AS "defaultId", "Sites"."SiteID" AS "siteID", 'SAT-CDP INA' AS network, 'INA' AS "agencyCode", 'INA' AS "agencyName"), "Sites"."SiteCode"), XMLELEMENT(NAME "timeZoneInfo", XMLATTRIBUTES(false AS "siteUsesDaylightSavingsTime"), XMLELEMENT(NAME "defaultTimeZone", '-03')), XMLELEMENT(NAME "geoLocation", XMLELEMENT(NAME "geogLocation", XMLATTRIBUTES('LatLonPointType' AS "xsi:type", 'EPSG:4326' AS srs), XMLELEMENT(NAME "sr:latitude", "Sites"."Latitude"), XMLELEMENT(NAME "sr:longitude", "Sites"."Longitude")), XMLELEMENT(NAME "localSiteXY", XMLATTRIBUTES((spatial_ref_sys.auth_name)::text AS "projectionInformation"), XMLELEMENT(NAME "X", public.st_x("Sites"."Geometry")), XMLELEMENT(NAME "Y", public.st_y("Sites"."Geometry")))), XMLELEMENT(NAME "sr:elevation_m", "Sites"."Elevation_m"), XMLELEMENT(NAME "verticalDatum", "Sites"."VerticalDatum"), XMLELEMENT(NAME "sr:siteProperty", XMLATTRIBUTES('Country' AS title), "Sites"."Country"), XMLELEMENT(NAME "sr:siteProperty", XMLATTRIBUTES('State' AS title), "Sites"."State"), XMLELEMENT(NAME "sr:siteProperty", XMLATTRIBUTES('Site Comments' AS title), "Sites"."Comments")) AS "SiteInfoXML"
   FROM public."Sites",
    public.spatial_ref_sys
  WHERE (public.st_srid("Sites"."Geometry") = spatial_ref_sys.srid)
  ORDER BY "Sites"."SiteID";


ALTER TABLE public."SiteInfoXML" OWNER TO jbianchi;

--
-- Name: SiteTypeCV; Type: TABLE; Schema: public; Owner: jbianchi
--

CREATE TABLE public."SiteTypeCV" (
    "Term" character varying(255) NOT NULL,
    "Definition" text
);


ALTER TABLE public."SiteTypeCV" OWNER TO jbianchi;

--
-- Name: Sites_SiteID_seq; Type: SEQUENCE; Schema: public; Owner: jbianchi
--

CREATE SEQUENCE public."Sites_SiteID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Sites_SiteID_seq" OWNER TO jbianchi;

--
-- Name: Sites_SiteID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jbianchi
--

ALTER SEQUENCE public."Sites_SiteID_seq" OWNED BY public."Sites"."SiteID";


--
-- Name: Sources; Type: TABLE; Schema: public; Owner: jbianchi
--

CREATE TABLE public."Sources" (
    "SourceID" integer NOT NULL,
    "Organization" character varying(255) NOT NULL,
    "SourceDescription" text NOT NULL,
    "SourceLink" text,
    "ContactName" character varying(255) DEFAULT 'Unknown'::character varying NOT NULL,
    "Phone" character varying(255) DEFAULT 'Unknown'::character varying NOT NULL,
    "Email" character varying(255) DEFAULT 'Unknown'::character varying NOT NULL,
    "Address" character varying(255) DEFAULT 'Unknown'::character varying NOT NULL,
    "City" character varying(255) DEFAULT 'Unknown'::character varying NOT NULL,
    "State" character varying(255) DEFAULT 'Unknown'::character varying NOT NULL,
    "ZipCode" character varying(255) DEFAULT 'Unknown'::character varying NOT NULL,
    "Citation" text NOT NULL,
    "MetadataID" integer DEFAULT 0 NOT NULL
);


ALTER TABLE public."Sources" OWNER TO jbianchi;

--
-- Name: SourceInfoXML; Type: VIEW; Schema: public; Owner: jbianchi
--

CREATE VIEW public."SourceInfoXML" AS
 SELECT "Sources"."SourceID",
    XMLELEMENT(NAME "sr:source", XMLELEMENT(NAME "sourceID", XMLATTRIBUTES(true AS "default", "Sources"."SourceID" AS "SourceID"), "Sources"."SourceID"), XMLELEMENT(NAME "Organization", "Sources"."Organization"), XMLELEMENT(NAME "SourceDescription", "Sources"."SourceDescription"), XMLELEMENT(NAME "SourceLink", "Sources"."SourceLink")) AS "SourceInfoXML"
   FROM public."Sources";


ALTER TABLE public."SourceInfoXML" OWNER TO jbianchi;

--
-- Name: Sources_SourceID_seq; Type: SEQUENCE; Schema: public; Owner: jbianchi
--

CREATE SEQUENCE public."Sources_SourceID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Sources_SourceID_seq" OWNER TO jbianchi;

--
-- Name: Sources_SourceID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jbianchi
--

ALTER SEQUENCE public."Sources_SourceID_seq" OWNED BY public."Sources"."SourceID";


--
-- Name: SpatialReferences; Type: TABLE; Schema: public; Owner: jbianchi
--

CREATE TABLE public."SpatialReferences" (
    "SpatialReferenceID" integer NOT NULL,
    "SRSID" integer,
    "SRSName" character varying(255) NOT NULL,
    "IsGeographic" boolean,
    "Notes" text
);


ALTER TABLE public."SpatialReferences" OWNER TO jbianchi;

--
-- Name: SpatialReferences_SpatialReferenceID_seq; Type: SEQUENCE; Schema: public; Owner: jbianchi
--

CREATE SEQUENCE public."SpatialReferences_SpatialReferenceID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."SpatialReferences_SpatialReferenceID_seq" OWNER TO jbianchi;

--
-- Name: SpatialReferences_SpatialReferenceID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jbianchi
--

ALTER SEQUENCE public."SpatialReferences_SpatialReferenceID_seq" OWNED BY public."SpatialReferences"."SpatialReferenceID";


--
-- Name: SpeciationCV; Type: TABLE; Schema: public; Owner: jbianchi
--

CREATE TABLE public."SpeciationCV" (
    "Term" character varying(255) NOT NULL,
    "Definition" text
);


ALTER TABLE public."SpeciationCV" OWNER TO jbianchi;

--
-- Name: TopicCategoryCV; Type: TABLE; Schema: public; Owner: jbianchi
--

CREATE TABLE public."TopicCategoryCV" (
    "Term" character varying(255) NOT NULL,
    "Definition" text
);


ALTER TABLE public."TopicCategoryCV" OWNER TO jbianchi;

--
-- Name: Units; Type: TABLE; Schema: public; Owner: jbianchi
--

CREATE TABLE public."Units" (
    "UnitsID" integer NOT NULL,
    "UnitsName" character varying(255) NOT NULL,
    "UnitsType" character varying(255) NOT NULL,
    "UnitsAbbreviation" character varying(255) NOT NULL
);


ALTER TABLE public."Units" OWNER TO jbianchi;

--
-- Name: UnitsXML; Type: VIEW; Schema: public; Owner: jbianchi
--

CREATE VIEW public."UnitsXML" AS
 SELECT "Units"."UnitsName",
    "Units"."UnitsID",
    "Units"."UnitsType",
    "Units"."UnitsAbbreviation",
    XMLELEMENT(NAME unit, XMLATTRIBUTES("Units"."UnitsID" AS "unitsID"), XMLELEMENT(NAME "unitsName", "Units"."UnitsName"), XMLELEMENT(NAME "unitsType", "Units"."UnitsType"), XMLELEMENT(NAME "unitsAbbreviation", "Units"."UnitsAbbreviation")) AS "UnitsXML"
   FROM public."Units"
  ORDER BY "Units"."UnitsID";


ALTER TABLE public."UnitsXML" OWNER TO jbianchi;

--
-- Name: Units_UnitsID_seq; Type: SEQUENCE; Schema: public; Owner: jbianchi
--

CREATE SEQUENCE public."Units_UnitsID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Units_UnitsID_seq" OWNER TO jbianchi;

--
-- Name: Units_UnitsID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jbianchi
--

ALTER SEQUENCE public."Units_UnitsID_seq" OWNED BY public."Units"."UnitsID";


--
-- Name: ValueTypeCV; Type: TABLE; Schema: public; Owner: jbianchi
--

CREATE TABLE public."ValueTypeCV" (
    "Term" character varying(255) NOT NULL,
    "Definition" text
);


ALTER TABLE public."ValueTypeCV" OWNER TO jbianchi;

--
-- Name: Variables; Type: TABLE; Schema: public; Owner: jbianchi
--

CREATE TABLE public."Variables" (
    "VariableID" integer NOT NULL,
    "VariableCode" character varying(50) NOT NULL,
    "VariableName" character varying(255) NOT NULL,
    "Speciation" character varying(255) DEFAULT 'Not Applicable'::character varying NOT NULL,
    "VariableUnitsID" integer NOT NULL,
    "SampleMedium" character varying(255) DEFAULT 'Unknown'::character varying NOT NULL,
    "ValueType" character varying(255) DEFAULT 'Unknown'::character varying NOT NULL,
    "IsRegular" boolean DEFAULT false NOT NULL,
    "TimeSupport" real DEFAULT 0 NOT NULL,
    "TimeUnitsID" integer DEFAULT 0 NOT NULL,
    "DataType" character varying(255) DEFAULT 'Unknown'::character varying NOT NULL,
    "GeneralCategory" character varying(255) DEFAULT 'Unknown'::character varying NOT NULL,
    "NoDataValue" real DEFAULT 0 NOT NULL
);


ALTER TABLE public."Variables" OWNER TO jbianchi;

--
-- Name: VariableInfoXML; Type: VIEW; Schema: public; Owner: jbianchi
--

CREATE VIEW public."VariableInfoXML" AS
 SELECT "Variables"."VariableID",
    "Variables"."VariableCode",
    "Variables"."VariableName",
    "Variables"."Speciation",
    "Variables"."VariableUnitsID",
    "Variables"."SampleMedium",
    "Variables"."ValueType",
    "Variables"."IsRegular",
    "Variables"."TimeSupport",
    "Variables"."TimeUnitsID",
    "Variables"."DataType",
    "Variables"."GeneralCategory",
    "Variables"."NoDataValue",
    XMLELEMENT(NAME "sr:variable", XMLELEMENT(NAME "variableCode", XMLATTRIBUTES(true AS "default", "Variables"."VariableID" AS "variableID"), "Variables"."VariableCode"), XMLELEMENT(NAME "variableName", "Variables"."VariableName"), XMLELEMENT(NAME "variableDescription", ''), XMLELEMENT(NAME "valueType", "Variables"."ValueType"), "UnitsXML"."UnitsXML") AS "VariableInfoXML"
   FROM public."Variables",
    public."UnitsXML"
  WHERE ("Variables"."VariableUnitsID" = "UnitsXML"."UnitsID");


ALTER TABLE public."VariableInfoXML" OWNER TO jbianchi;

--
-- Name: VariableNameCV; Type: TABLE; Schema: public; Owner: jbianchi
--

CREATE TABLE public."VariableNameCV" (
    "Term" character varying(255) NOT NULL,
    "Definition" text
);


ALTER TABLE public."VariableNameCV" OWNER TO jbianchi;

--
-- Name: Variables_VariableID_seq; Type: SEQUENCE; Schema: public; Owner: jbianchi
--

CREATE SEQUENCE public."Variables_VariableID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Variables_VariableID_seq" OWNER TO jbianchi;

--
-- Name: Variables_VariableID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jbianchi
--

ALTER SEQUENCE public."Variables_VariableID_seq" OWNED BY public."Variables"."VariableID";


--
-- Name: VerticalDatumCV; Type: TABLE; Schema: public; Owner: jbianchi
--

CREATE TABLE public."VerticalDatumCV" (
    "Term" character varying(255) NOT NULL,
    "Definition" text
);


ALTER TABLE public."VerticalDatumCV" OWNER TO jbianchi;

--
-- Name: ValueID; Type: DEFAULT; Schema: public; Owner: jbianchi
--

ALTER TABLE ONLY public."DataValues" ALTER COLUMN "ValueID" SET DEFAULT nextval('public."DataValues_ValueID_seq"'::regclass);


--
-- Name: GroupID; Type: DEFAULT; Schema: public; Owner: jbianchi
--

ALTER TABLE ONLY public."GroupDescriptions" ALTER COLUMN "GroupID" SET DEFAULT nextval('public."GroupDescriptions_GroupID_seq"'::regclass);


--
-- Name: MetadataID; Type: DEFAULT; Schema: public; Owner: jbianchi
--

ALTER TABLE ONLY public."ISOMetadata" ALTER COLUMN "MetadataID" SET DEFAULT nextval('public."ISOMetadata_MetadataID_seq"'::regclass);


--
-- Name: LabMethodID; Type: DEFAULT; Schema: public; Owner: jbianchi
--

ALTER TABLE ONLY public."LabMethods" ALTER COLUMN "LabMethodID" SET DEFAULT nextval('public."LabMethods_LabMethodID_seq"'::regclass);


--
-- Name: MethodID; Type: DEFAULT; Schema: public; Owner: jbianchi
--

ALTER TABLE ONLY public."Methods" ALTER COLUMN "MethodID" SET DEFAULT nextval('public."Methods_MethodID_seq"'::regclass);


--
-- Name: OffsetTypeID; Type: DEFAULT; Schema: public; Owner: jbianchi
--

ALTER TABLE ONLY public."OffsetTypes" ALTER COLUMN "OffsetTypeID" SET DEFAULT nextval('public."OffsetTypes_OffsetTypeID_seq"'::regclass);


--
-- Name: QualifierID; Type: DEFAULT; Schema: public; Owner: jbianchi
--

ALTER TABLE ONLY public."Qualifiers" ALTER COLUMN "QualifierID" SET DEFAULT nextval('public."Qualifiers_QualifierID_seq"'::regclass);


--
-- Name: QualityControlLevelID; Type: DEFAULT; Schema: public; Owner: jbianchi
--

ALTER TABLE ONLY public."QualityControlLevels" ALTER COLUMN "QualityControlLevelID" SET DEFAULT nextval('public."QualityControlLevels_QualityControlLevelID_seq"'::regclass);


--
-- Name: SampleID; Type: DEFAULT; Schema: public; Owner: jbianchi
--

ALTER TABLE ONLY public."Samples" ALTER COLUMN "SampleID" SET DEFAULT nextval('public."Samples_SampleID_seq"'::regclass);


--
-- Name: SeriesID; Type: DEFAULT; Schema: public; Owner: jbianchi
--

ALTER TABLE ONLY public."SeriesCatalog" ALTER COLUMN "SeriesID" SET DEFAULT nextval('public."SeriesCatalog_SeriesID_seq"'::regclass);


--
-- Name: SiteID; Type: DEFAULT; Schema: public; Owner: jbianchi
--

ALTER TABLE ONLY public."Sites" ALTER COLUMN "SiteID" SET DEFAULT nextval('public."Sites_SiteID_seq"'::regclass);


--
-- Name: SourceID; Type: DEFAULT; Schema: public; Owner: jbianchi
--

ALTER TABLE ONLY public."Sources" ALTER COLUMN "SourceID" SET DEFAULT nextval('public."Sources_SourceID_seq"'::regclass);


--
-- Name: SpatialReferenceID; Type: DEFAULT; Schema: public; Owner: jbianchi
--

ALTER TABLE ONLY public."SpatialReferences" ALTER COLUMN "SpatialReferenceID" SET DEFAULT nextval('public."SpatialReferences_SpatialReferenceID_seq"'::regclass);


--
-- Name: UnitsID; Type: DEFAULT; Schema: public; Owner: jbianchi
--

ALTER TABLE ONLY public."Units" ALTER COLUMN "UnitsID" SET DEFAULT nextval('public."Units_UnitsID_seq"'::regclass);


--
-- Name: VariableID; Type: DEFAULT; Schema: public; Owner: jbianchi
--

ALTER TABLE ONLY public."Variables" ALTER COLUMN "VariableID" SET DEFAULT nextval('public."Variables_VariableID_seq"'::regclass);


--
-- Data for Name: Categories; Type: TABLE DATA; Schema: public; Owner: jbianchi
--

COPY public."Categories" ("VariableID", "DataValue", "CategoryDescription") FROM stdin;
\.


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
-- Data for Name: DataTypeCV; Type: TABLE DATA; Schema: public; Owner: jbianchi
--

COPY public."DataTypeCV" ("Term", "Definition") FROM stdin;
Average	The values represent the average over a time interval, such as daily mean discharge or daily mean temperature.
Best Easy Systematic Estimator	Best Easy Systematic Estimator BES = (Q1 +2Q2 +Q3)/4.  Q1, Q2, and Q3 are first, second, and third quartiles. See Woodcock, F. and Engel, C., 2005: Operational Consensus Forecasts.Weather and Forecasting, 20, 101-111. (http://www.bom.gov.au/nmoc/bulletins/60/article_by_Woodcock_in_Weather_and_Forecasting.pdf) and Wonnacott, T. H., and R. J. Wonnacott, 1972: Introductory Statistics. Wiley, 510 pp.
Categorical	The values are categorical rather than continuous valued quantities. Mapping from Value values to categories is through the CategoryDefinitions table.
Constant Over Interval	The values are quantities that can be interpreted as constant for all time, or over the time interval to a subsequent measurement of the same variable at the same site.
Continuous	A quantity specified at a particular instant in time measured with sufficient frequency (small spacing) to be interpreted as a continuous record of the phenomenon.
Cumulative	The values represent the cumulative value of a variable measured or calculated up to a given instant of time, such as cumulative volume of flow or cumulative precipitation.
Incremental	The values represent the incremental value of a variable over a time interval, such as the incremental volume of flow or incremental precipitation.
Maximum	The values are the maximum values occurring at some time during a time interval, such as annual maximum discharge or a daily maximum air temperature.
Median	The values represent the median over a time interval, such as daily median discharge or daily median temperature.
Minimum	The values are the minimum values occurring at some time during a time interval, such as 7-day low flow for a year or the daily minimum temperature.
Mode	The values are the most frequent values occurring at some time during a time interval, such as annual most frequent wind direction.
Sporadic	The phenomenon is sampled at a particular instant in time but with a frequency that is too coarse for interpreting the record as continuous.  This would be the case when the spacing is significantly larger than the support and the time scale of fluctuation of the phenomenon, such as for example infrequent water quality samples.
StandardDeviation	The values represent the standard deviation of a set of observations made over a time interval. Standard deviation computed using the unbiased formula SQRT(SUM((Xi-mean)^2)/(n-1)) are preferred. The specific formula used to compute variance can be noted in the methods description.
Unknown	The data type is unknown
Variance	The values represent the variance of a set of observations made over a time interval.  Variance computed using the unbiased formula SUM((Xi-mean)^2)/(n-1) are preferred.  The specific formula used to compute variance can be noted in the methods description.
\.


--
-- Data for Name: DataValues; Type: TABLE DATA; Schema: public; Owner: jbianchi
--

COPY public."DataValues" ("ValueID", "DataValue", "ValueAccuracy", "LocalDateTime", "UTCOffset", "DateTimeUTC", "SiteID", "VariableID", "OffsetValue", "OffsetTypeID", "CensorCode", "QualifierID", "MethodID", "SourceID", "SampleID", "DerivedFromID", "QualityControlLevelID") FROM stdin;
\.


--
-- Name: DataValues_ValueID_seq; Type: SEQUENCE SET; Schema: public; Owner: jbianchi
--

SELECT pg_catalog.setval('public."DataValues_ValueID_seq"', 1, false);


--
-- Data for Name: DerivedFrom; Type: TABLE DATA; Schema: public; Owner: jbianchi
--

COPY public."DerivedFrom" ("DerivedFromID", "ValueID") FROM stdin;
\.


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
-- Data for Name: GroupDescriptions; Type: TABLE DATA; Schema: public; Owner: jbianchi
--

COPY public."GroupDescriptions" ("GroupID", "GroupDescription") FROM stdin;
\.


--
-- Name: GroupDescriptions_GroupID_seq; Type: SEQUENCE SET; Schema: public; Owner: jbianchi
--

SELECT pg_catalog.setval('public."GroupDescriptions_GroupID_seq"', 1, false);


--
-- Data for Name: Groups; Type: TABLE DATA; Schema: public; Owner: jbianchi
--

COPY public."Groups" ("GroupID", "ValueID") FROM stdin;
\.


--
-- Data for Name: ISOMetadata; Type: TABLE DATA; Schema: public; Owner: jbianchi
--

COPY public."ISOMetadata" ("MetadataID", "TopicCategory", "Title", "Abstract", "ProfileVersion", "MetadataLink") FROM stdin;
0	Unknown	Unknown	Unknown	Unknown	\N
\.


--
-- Name: ISOMetadata_MetadataID_seq; Type: SEQUENCE SET; Schema: public; Owner: jbianchi
--

SELECT pg_catalog.setval('public."ISOMetadata_MetadataID_seq"', 1, false);


--
-- Data for Name: LabMethods; Type: TABLE DATA; Schema: public; Owner: jbianchi
--

COPY public."LabMethods" ("LabMethodID", "LabName", "LabOrganization", "LabMethodName", "LabMethodDescription", "LabMethodLink") FROM stdin;
0	Unknown	Unknown	Unknown	Unknown	\N
\.


--
-- Name: LabMethods_LabMethodID_seq; Type: SEQUENCE SET; Schema: public; Owner: jbianchi
--

SELECT pg_catalog.setval('public."LabMethods_LabMethodID_seq"', 1, false);


--
-- Data for Name: Methods; Type: TABLE DATA; Schema: public; Owner: jbianchi
--

COPY public."Methods" ("MethodID", "MethodDescription", "MethodLink") FROM stdin;
0	No method specified	\N
\.


--
-- Name: Methods_MethodID_seq; Type: SEQUENCE SET; Schema: public; Owner: jbianchi
--

SELECT pg_catalog.setval('public."Methods_MethodID_seq"', 1, false);


--
-- Data for Name: ODMVersion; Type: TABLE DATA; Schema: public; Owner: jbianchi
--

COPY public."ODMVersion" ("VersionNumber") FROM stdin;
1.1.1
\.


--
-- Data for Name: OffsetTypes; Type: TABLE DATA; Schema: public; Owner: jbianchi
--

COPY public."OffsetTypes" ("OffsetTypeID", "OffsetUnitsID", "OffsetDescription") FROM stdin;
1	52	Height above ground level
2	52	Depth below ground level
3	52	Depth below water level
\.


--
-- Name: OffsetTypes_OffsetTypeID_seq; Type: SEQUENCE SET; Schema: public; Owner: jbianchi
--

SELECT pg_catalog.setval('public."OffsetTypes_OffsetTypeID_seq"', 3, true);


--
-- Data for Name: Qualifiers; Type: TABLE DATA; Schema: public; Owner: jbianchi
--

COPY public."Qualifiers" ("QualifierID", "QualifierCode", "QualifierDescription") FROM stdin;
\.


--
-- Name: Qualifiers_QualifierID_seq; Type: SEQUENCE SET; Schema: public; Owner: jbianchi
--

SELECT pg_catalog.setval('public."Qualifiers_QualifierID_seq"', 1, false);


--
-- Data for Name: QualityControlLevels; Type: TABLE DATA; Schema: public; Owner: jbianchi
--

COPY public."QualityControlLevels" ("QualityControlLevelID", "QualityControlLevelCode", "Definition", "Explanation") FROM stdin;
-9999	-9999	Unknown	The quality control level is unknown
0	0	Raw data	Raw and unprocessed data and data products that have not undergone quality control.  Depending on the variable, data type, and data transmission system, raw data may be available within seconds or minutes after the measurements have been made. Examples include real time precipitation, streamflow and water quality measurements.
1	1	Quality controlled data	Quality controlled data that have passed quality assurance procedures such as routine estimation of timing and sensor calibration or visual inspection and removal of obvious errors. An example is USGS published streamflow records following parsing through USGS quality control procedures.
2	2	Derived products	Derived products that require scientific and technical interpretation and may include multiple-sensor data. An example is basin average precipitation derived from rain gages using an interpolation procedure.
3	3	Interpreted products	Interpreted products that require researcher driven analysis and interpretation, model-based interpretation using other data and/or strong prior assumptions. An example is basin average precipitation derived from the combination of rain gages and radar return data.
4	4	Knowledge products	Knowledge products that require researcher driven scientific interpretation and multidisciplinary data integration and include model-based interpretation using other data and/or strong prior assumptions. An example is percentages of old or new water in a hydrograph inferred from an isotope analysis.
\.


--
-- Name: QualityControlLevels_QualityControlLevelID_seq; Type: SEQUENCE SET; Schema: public; Owner: jbianchi
--

SELECT pg_catalog.setval('public."QualityControlLevels_QualityControlLevelID_seq"', 1, false);


--
-- Data for Name: SampleMediumCV; Type: TABLE DATA; Schema: public; Owner: jbianchi
--

COPY public."SampleMediumCV" ("Term", "Definition") FROM stdin;
Air	Sample taken from the atmosphere
Flowback water	A mixture of formation water and hydraulic fracturing injectates deriving from oil and gas wells prior to placing wells into production
Groundwater	Sample taken from water located below the surface of the ground, such as from a well or spring
Municipal waste water	Sample taken from raw municipal waste water stream.
Not Relevant	Sample medium not relevant in the context of the measurement
Other	Sample medium other than those contained in the CV
Precipitation	Sample taken from solid or liquid precipitation
Production water	Fluids produced from wells during oil or gas production which may include formation water, injected fluids, oil and gas.
Sediment	Sample taken from the sediment beneath the water column
Snow	Observation in, of or sample taken from snow
Soil	Sample taken from the soil
Soil air	Air contained in the soil pores
Soil water	the water contained in the soil pores
Surface Water	Observation or sample of surface water such as a stream, river, lake, pond, reservoir, ocean, etc.
Tissue	Sample taken from the tissue of a biological organism
Unknown	The sample medium is unknown
\.


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
-- Data for Name: Samples; Type: TABLE DATA; Schema: public; Owner: jbianchi
--

COPY public."Samples" ("SampleID", "SampleType", "LabSampleCode", "LabMethodID") FROM stdin;
\.


--
-- Name: Samples_SampleID_seq; Type: SEQUENCE SET; Schema: public; Owner: jbianchi
--

SELECT pg_catalog.setval('public."Samples_SampleID_seq"', 1, false);


--
-- Data for Name: SeriesCatalog; Type: TABLE DATA; Schema: public; Owner: jbianchi
--

COPY public."SeriesCatalog" ("SeriesID", "SiteID", "SiteCode", "SiteName", "SiteType", "VariableID", "VariableCode", "VariableName", "Speciation", "VariableUnitsID", "VariableUnitsName", "SampleMedium", "ValueType", "TimeSupport", "TimeUnitsID", "TimeUnitsName", "DataType", "GeneralCategory", "MethodID", "MethodDescription", "SourceID", "Organization", "SourceDescription", "Citation", "QualityControlLevelID", "QualityControlLevelCode", "BeginDateTime", "EndDateTime", "BeginDateTimeUTC", "EndDateTimeUTC", "ValueCount") FROM stdin;
\.


--
-- Name: SeriesCatalog_SeriesID_seq; Type: SEQUENCE SET; Schema: public; Owner: jbianchi
--

SELECT pg_catalog.setval('public."SeriesCatalog_SeriesID_seq"', 1, false);


--
-- Data for Name: SiteTypeCV; Type: TABLE DATA; Schema: public; Owner: jbianchi
--

COPY public."SiteTypeCV" ("Term", "Definition") FROM stdin;
Aggregate groundwater use	An Aggregate Groundwater Withdrawal/Return site represents an aggregate of specific sites whe groundwater is withdrawn or returned which is defined by a geographic area or some other common characteristic. An aggregate groundwatergroundwater site type is used when it is not possible or practical to describe the specific sites as springs or as any type of well including 'multiple wells', or when water-use information is only available for the aggregate. Aggregate sites that span multiple counties should be coded with 000 as the county code, or an aggregate site can be created for each county.
Aggregate surface-water-use	An Aggregate Surface-Water Diversion/Return site represents an aggregate of specific sites where surface water is diverted or returned which is defined by a geographic area or some other common characteristic. An aggregate surface-water site type is used when it is not possible or practical to describe the specific sites as diversions, outfalls, or land application sites, or when water-use information is only available for the aggregate. Aggregate sites that span multiple counties should be coded with 000 as the county code, or an aggregate site can be created for each county.
Aggregate water-use establishment	An Aggregate Water-Use Establishment represents an aggregate class of water-using establishments or individuals that are associated with a specific geographic location and water-use category, such as all the industrial users located within a county or all self-supplied domestic users in a county. The aggregate class of water-using establishments is identified using the national water-use category code and optionally classified using the Standard Industrial Classification System Code (SIC code) or North American Classification System Code (NAICS code). An aggregate water-use establishment site type is used when specific information needed to create sites for the individual facilities or users is not available or when it is not desirable to store the site-specific information in the database. Data entry rules that apply to water-use establishments also apply to aggregate water-use establishments. Aggregate sites that span multiple counties should be coded with 000 as the county code, or an aggregate site can be created for each county.
Animal waste lagoon	A facility for storage and/or biological treatment of wastes from livestock operations. Animal-waste lagoons are earthen structures ranging from pits to large ponds, and contain manure which has been diluted with building washwater, rainfall, and surface runoff. In treatment lagoons, the waste becomes partially liquefied and stabilized by bacterial action before the waste is disposed of on the land and the water is discharged or re-used.
Atmosphere	A site established primarily to measure meteorological properties or atmospheric deposition.
Canal	An artificial watercourse designed for navigation, drainage, or irrigation by connecting two or more bodies of water; it is larger than a ditch.
Cave	A natural open space within a rock formation large enough to accommodate a human. A cave may have an opening to the outside, is always underground, and sometimes submerged. Caves commonly occur by the dissolution of soluble rocks, generally limestone, but may also be created within the voids of large-rock aggregations, in openings along seismic faults, and in lava formations.
Cistern	An artificial, non-pressurized reservoir filled by gravity flow and used for water storage. The reservoir may be located above, at, or below ground level. The water may be supplied from diversion of precipitation, surface, or groundwater sources.
Coastal	An oceanic site that is located off-shore beyond the tidal mixing zone (estuary) but close enough to the shore that the investigator considers the presence of the coast to be important. Coastal sites typically are within three nautical miles of the shore.
Collector or Ranney type well	An infiltration gallery consisting of one or more underground laterals through which groundwater is collected and a vertical caisson from which groundwater is removed. Also known as a \\"horizontal well\\". These wells produce large yield with small drawdown.
Combined sewer	An underground conduit created to convey storm drainage and waste products into a wastewater-treatment plant, stream, reservoir, or disposal site.
Ditch	An excavation artificially dug in the ground, either lined or unlined, for conveying water for drainage or irrigation; it is smaller than a canal.
Diversion	A site where water is withdrawn or diverted from a surface-water body (e.g. the point where the upstream end of a canal intersects a stream, or point where water is withdrawn from a reservoir). Includes sites where water is pumped for use elsewhere.
Estuary	A coastal inlet of the sea or ocean; esp. the mouth of a river, where tide water normally mixes with stream water (modified, Webster). Salinity in estuaries typically ranges from 1 to 25 Practical Salinity Units (psu), as compared oceanic values around 35-psu. See also: tidal stream and coastal.
Excavation	An artificially constructed cavity in the earth that is deeper than the soil (see soil hole), larger than a well bore (see well and test hole), and substantially open to the atmosphere. The diameter of an excavation is typically similar or larger than the depth. Excavations include building-foundation diggings, roadway cuts, and surface mines.
Extensometer well	A well equipped to measure small changes in the thickness of the penetrated sediments, such as those caused by groundwater withdrawal or recharge.
Facility	A non-ambient location where environmental measurements are expected to be strongly influenced by current or previous activities of humans. *Sites identified with a \\"facility\\" primary site type must be further classified with one of the applicable secondary site types.
Field, Pasture, Orchard, or Nursery	A water-using facility characterized by an area where plants are grown for transplanting, for use as stocks for budding and grafting, or for sale. Irrigation water may or may not be applied.
Glacier	Body of land ice that consists of recrystallized snow accumulated on the surface of the ground and moves slowly downslope (WSP-1541A) over a period of years or centuries. Since glacial sites move, the lat-long precision for these sites is usually coarse.
Golf course	A place-of-use, either public or private, where the game of golf is played. A golf course typically uses water for irrigation purposes. Should not be used if the site is a specific hydrologic feature or facility; but can be used especially for the water-use sites.
Groundwater drain	An underground pipe or tunnel through which groundwater is artificially diverted to surface water for the purpose of reducing erosion or lowering the water table. A drain is typically open to the atmosphere at the lowest elevation, in contrast to a well which is open at the highest point.
Hydroelectric plant	A facility that generates electric power by converting potential energy of water into kinetic energy. Typically, turbine generators are turned by falling water.
Hyporheic-zone well	A permanent well, drive point, or other device intended to sample a saturated zone in close proximity to a stream.
Interconnected wells	Collector or drainage wells connected by an underground lateral.
Laboratory or sample-preparation area	A site where some types of quality-control samples are collected, and where equipment and supplies for environmental sampling are prepared. Equipment blank samples are commonly collected at this site type, as are samples of locally produced deionized water. This site type is typically used when the data are either not associated with a unique environmental data-collection site, or where blank water supplies are designated by Center offices with unique station IDs.
Lake, Reservoir, Impoundment	An inland body of standing fresh or saline water that is generally too deep to permit submerged aquatic vegetation to take root across the entire body (cf: wetland). This site type includes an expanded part of a river, a reservoir behind a dam, and a natural or excavated depression containing a water body without surface-water inlet and/or outlet.
Land	A location on the surface of the earth that is not normally saturated with water. Land sites are appropriate for sampling vegetation, overland flow of water, or measuring land-surface properties such as temperature. (See also: Wetland).
Landfill	A typically dry location on the surface of the land where primarily solid waste products are currently, or previously have been, aggregated and sometimes covered with a veneer of soil. See also: Wastewater disposal and waste-injection well.
Multiple wells	A group of wells that are pumped through a single header and for which little or no data about the individual wells are available.
Ocean	Site in the open ocean, gulf, or sea. (See also: Coastal, Estuary, and Tidal stream).
Outcrop	The part of a rock formation that appears at the surface of the surrounding land.
Outfall	A site where water or wastewater is returned to a surface-water body, e.g. the point where wastewater is returned to a stream. Typically, the discharge end of an effluent pipe.
Pavement	A surface site where the land surface is covered by a relatively impermeable material, such as concrete or asphalt. Pavement sites are typically part of transportation infrastructure, such as roadways, parking lots, or runways.
Playa	A dried-up, vegetation-free, flat-floored area composed of thin, evenly stratified sheets of fine clay, silt or sand, and represents the bottom part of a shallow, completely closed or undrained desert lake basin in which water accumulates and is quickly evaporated, usually leaving deposits of soluble salts.
Septic system	A site within or in close proximity to a subsurface sewage disposal system that generally consists of: (1) a septic tank where settling of solid material occurs, (2) a distribution system that transfers fluid from the tank to (3) a leaching system that disperses the effluent into the ground.
Shore	The land along the edge of the sea, a lake, or a wide river where the investigator considers the proximity of the water body to be important. Land adjacent to a reservoir, lake, impoundment, or oceanic site type is considered part of the shore when it includes a beach or bank between the high and low water marks.
Sinkhole	A crater formed when the roof of a cavern collapses; usually found in limestone areas. Surface water and precipitation that enters a sinkhole usually evaporates or infiltrates into the ground, rather than draining into a stream.
Soil hole	A small excavation into soil at the top few meters of earth surface. Soil generally includes some organic matter derived from plants. Soil holes are created to measure soil composition and properties. Sometimes electronic probes are inserted into soil holes to measure physical properties, and (or) the extracted soil is analyzed.
Spring	A location at which the water table intersects the land surface, resulting in a natural flow of groundwater to the surface. Springs may be perennial, intermittent, or ephemeral.
Storm sewer	An underground conduit created to convey storm drainage into a stream channel or reservoir. If the sewer also conveys liquid waste products, then the \\"combined sewer\\" secondary site type should be used.
Stream	A body of running water moving under gravity flow in a defined channel. The channel may be entirely natural, or altered by engineering practices through straightening, dredging, and (or) lining. An entirely artificial channel should be qualified with the \\"canal\\" or \\"ditch\\" secondary site type.
Subsurface	A location below the land surface, but not a well, soil hole, or excavation.
Test hole not completed as a well	An uncased hole (or one cased only temporarily) that was drilled for water, or for geologic or hydrogeologic testing. It may be equipped temporarily with a pump in order to make a pumping test, but if the hole is destroyed after testing is completed, it is still a test hole. A core hole drilled as a part of mining or quarrying exploration work should be in this class.
Thermoelectric plant	A facility that uses water in the generation of electricity from heat. Typically turbine generators are driven by steam. The heat may be caused by various means, including combustion, nuclear reactions, and geothermal processes.
Tidal stream	A stream reach where the flow is influenced by the tide, but where the water chemistry is not normally influenced. A site where ocean water typically mixes with stream water should be coded as an estuary.
Tunnel, shaft, or mine	A constructed subsurface open space large enough to accommodate a human that is not substantially open to the atmosphere and is not a well. The excavation may have been for minerals, transportation, or other purposes. See also: Excavation.
Unsaturated zone	A site equipped to measure conditions in the subsurface deeper than a soil hole, but above the water table or other zone of saturation.
Volcanic vent	Vent from which volcanic gases escape to the atmosphere. Also known as fumarole.
Waste injection well	A facility used to convey industrial waste, domestic sewage, brine, mine drainage, radioactive waste, or other fluid into an underground zone. An oil-test or deep-water well converted to waste disposal should be in this category. A well where fresh water is injected to artificially recharge thegroundwaterr supply or to pressurize an oil or gas production zone by injecting a fluid should be classified as a well (not an injection-well facility), with additional information recorded under Use of Site.
Wastewater land application	A site where the disposal of waste water on land occurs. Use \\"waste-injection well\\" for underground waste-disposal sites.
Wastewater sewer	An underground conduit created to convey liquid and semisolid domestic, commercial, or industrial waste into a treatment plant, stream, reservoir, or disposal site. If the sewer also conveys storm water, then the \\"combined sewer\\" secondary site type should be used.
Wastewater-treatment plant	A facility where wastewater is treated to reduce concentrations of dissolved and (or) suspended materials prior to discharge or reuse.
Water-distribution system	A site located somewhere on a networked infrastructure that distributes treated or untreated water to multiple domestic, industrial, institutional, and (or) commercial users. May be owned by a municipality or community, a water district, or a private concern.
Water-supply treatment plant	A facility where water is treated prior to use for consumption or other purpose.
Water-use establishment	A place-of-use (a water using facility that is associated with a specific geographical point location, such as a business or industrial user) that cannot be specified with any other facility secondary type. Water-use place-of-use sites are establishments such as a factory, mill, store, warehouse, farm, ranch, or bank. A place-of-use site is further classified using the national water-use category code (C39) and optionally classified using the Standard Industrial Classification System Code (SIC code) or North American Classification System Code (NAICS code). See also: Aggregate water-use-establishment.
Well	A hole or shaft constructed in the earth intended to be used to locate, sample, or develop groundwater, oil, gas, or some other subsurface material. The diameter of a well is typically much smaller than the depth. Wells are also used to artificially recharge groundwater or to pressurize oil and gas production zones. Additional information about specific kinds of wells should be recorded under the secondary site types or the Use of Site field. Underground waste-disposal wells should be classified as waste-injection wells.
Wetland	Land where saturation with water is the dominant factor determining the nature of soil development and the types of plant and animal communities living in the soil and on its surface (Cowardin, December 1979). Wetlands are found from the tundra to the tropics and on every continent except Antarctica. Wetlands are areas that are inundated or saturated by surface or groundwater at a frequency and duration sufficient to support, and that under normal circumstances do support, a prevalence of vegetation typically adapted for life in saturated soil conditions. Wetlands generally include swamps, marshes, bogs and similar areas. Wetlands may be forested or unforested, and naturally or artificially created.
\.


--
-- Data for Name: Sites; Type: TABLE DATA; Schema: public; Owner: jbianchi
--

COPY public."Sites" ("SiteID", "SiteCode", "SiteName", "Latitude", "Longitude", "LatLongDatumID", "SiteType", "Elevation_m", "VerticalDatum", "LocalX", "LocalY", "LocalProjectionID", "PosAccuracy_m", "State", "County", "Comments", "Country", "Geometry") FROM stdin;
539	red_acumar:872	La Boca	-34.6366653	-58.3580551	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	ARGENTINA	0101000020E6100000000000C0D42D4DC0000000407E5141C0
540	red_acumar:873	MorÃ³n	-34.6608238	-58.6277046	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	ARGENTINA	0101000020E6100000000000A058504DC0000000E0955441C0
541	red_acumar:874	Merlo	-34.6702843	-58.7250175	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	ARGENTINA	0101000020E610000000000060CD5C4DC0000000E0CB5541C0
542	red_acumar:875	Marcos Paz	-34.7833328	-58.835556	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	ARGENTINA	0101000020E610000000000080F36A4DC000000040446441C0
543	red_acumar:876	LanÃºs	-34.6995506	-58.3929558	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	ARGENTINA	0101000020E6100000000000604C324DC0000000E08A5941C0
544	red_acumar:877	Avellaneda	-34.7166824	-58.2933807	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	ARGENTINA	0101000020E6100000000000808D254DC000000040BC5B41C0
545	red_acumar:878	Almirante Brown	-34.7975349	-58.3880959	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	ARGENTINA	0101000020E610000000000020AD314DC0000000A0156641C0
546	red_acumar:879	Esteban EcheverrÃ­a	-34.8222237	-58.4716682	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	ARGENTINA	0101000020E6100000000000A05F3C4DC0000000A03E6941C0
547	red_acumar:880	Lomas de Zamora	-34.7142754	-58.456459	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	ARGENTINA	0101000020E6100000000000406D3A4DC0000000606D5B41C0
548	red_acumar:881	San Vicente	-35.041111	-58.4094429	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	ARGENTINA	0101000020E6100000000000A068344DC000000020438541C0
549	alturas_dinac:160	Fuerte Olimpo	-21.0407066	-57.869133	0	\N	\N	\N	\N	\N	\N	\N	PARAGUAY	\N	\N	PARAGUAY	0101000020E6100000000000C03FEF4CC0000000C06B0A35C0
550	alturas_bdhi:317	Barra do Quarai	-30.2099991	-57.5499992	0	\N	\N	\N	\N	\N	\N	\N	BRASIL	\N	\N	BRASIL	0101000020E61000000000006066C64CC000000080C2353EC0
551	red_acumar:882	Presidente PerÃ³n	-34.9465065	-58.3809471	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	ARGENTINA	0101000020E6100000000000E0C2304DC000000020277941C0
552	red_acumar:883	La Matanza	-34.7930183	-58.6322403	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	ARGENTINA	0101000020E610000000000040ED504DC0000000A0816541C0
553	red_acumar:884	Ezeiza	-34.8551559	-58.5256805	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	ARGENTINA	0101000020E61000000000008049434DC0000000C0756D41C0
554	red_acumar:885	CaÃ±uelas	-35.0999985	-58.7999992	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	ARGENTINA	0101000020E61000000000006066664DC0000000C0CC8C41C0
555	red_acumar:886	SMN Ortuzar	-34.5833321	-58.5	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	ARGENTINA	0101000020E61000000000000000404DC0000000A0AA4A41C0
556	red_inta:803	INTA - Galvez - EMA Galvez	-32.0299988	-61.1599998	0	\N	\N	\N	\N	\N	\N	\N	Santa Fe	\N	\N	ARGENTINA	0101000020E6100000000000E07A944EC000000000D70340C0
557	red_acumar:887	Mercobras	-34.5099983	-58.501667	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	ARGENTINA	0101000020E6100000000000A036404DC0000000A0474141C0
558	red_acumar:888	UNSAM	-34.5786095	-58.5261116	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	ARGENTINA	0101000020E6100000000000A057434DC0000000E00F4A41C0
559	red_acumar:889	FCEN	-34.5419426	-58.4399986	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	ARGENTINA	0101000020E6100000000000E051384DC0000000605E4541C0
560	red_acumar:890	San Isidro Beccar	-34.4686127	-58.5374985	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	ARGENTINA	0101000020E6100000000000C0CC444DC000000080FB3B41C0
561	red_acumar:891	San Isidro CME	-34.4625015	-58.5008316	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	ARGENTINA	0101000020E6100000000000401B404DC000000040333B41C0
562	red_acumar:892	San Isidro Martinez	-34.4988403	-58.5254288	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	ARGENTINA	0101000020E61000000000004041434DC000000000DA3F41C0
563	red_acumar:893	UTN Campana	-34.1786118	-58.9622231	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	ARGENTINA	0101000020E6100000000000202A7B4DC0000000C0DC1641C0
564	red_acumar:894	Aeroclub Chacabuco	-34.5999985	-60.4000015	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	ARGENTINA	0101000020E61000000000004033334EC0000000C0CC4C41C0
565	red_acumar:895	Florencio Varela M	-34.8043709	-58.2799835	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	ARGENTINA	0101000020E610000000000080D6234DC0000000A0F56641C0
566	red_acumar:896	La Capilla (FV)	-34.9286003	-58.2747002	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	ARGENTINA	0101000020E61000000000006029234DC000000060DC7641C0
567	stations:376	MARIANO MORENO AERO                     	-34.5499992	-58.8166656	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	ARGENTINA	0101000020E61000000000008088684DC000000060664641C0
568	stations:377	MONTE CASEROS AERO                      	-30.2700005	-57.6500015	0	\N	\N	\N	\N	\N	\N	\N	CORRIENTES	\N	\N	ARGENTINA	0101000020E61000000000004033D34CC0000000C01E453EC0
569	stations:378	OLAVARRIA AERO                          	-36.8833351	-60.2166672	0	\N	\N	\N	\N	\N	\N	\N	BUENOSAIRES	\N	\N	ARGENTINA	0101000020E6100000000000C0BB1B4EC000000020117142C0
570	red_salado:854	caÃ±ada rosquin	-32.0847206	-61.5736122	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	ARGENTINA	0101000020E6100000000000206CC94EC000000020D80A40C0
571	alturas_dinac:161	Porto Murtinho	-21.6985531	-57.8903694	0	\N	\N	\N	\N	\N	\N	\N	PARAGUAY	\N	\N	PARAGUAY	0101000020E6100000000000A0F7F14CC000000060D4B235C0
572	alturas_varios:149	Zemek	-34.1668625	-58.6381683	0	\N	\N	\N	\N	\N	\N	\N	BUENOSAIRES	\N	\N	ARGENTINA	0101000020E610000000000080AF514DC0000000C05B1541C0
573	red_salado:855	carcaraÃ±a	-32.9283333	-61.1419449	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	ARGENTINA	0101000020E6100000000000402B924EC0000000A0D37640C0
574	red_salado:856	emilia	-31.0572224	-60.7425003	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	ARGENTINA	0101000020E6100000000000400A5F4EC000000020A60E3FC0
575	red_salado:857	fuentes	-33.0652771	-61.1894455	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	ARGENTINA	0101000020E6100000000000C03F984EC0000000005B8840C0
576	red_salado:858	gregoria denis	-28.228611	-61.5186119	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	ARGENTINA	0101000020E6100000000000E061C24EC000000040863A3CC0
577	red_salado:859	helvecia	-31.0905552	-60.0936127	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	ARGENTINA	0101000020E610000000000080FB0B4EC0000000A02E173FC0
578	stations:379	PEHUAJO AERO                            	-35.8666649	-61.9000015	0	\N	\N	\N	\N	\N	\N	\N	BUENOSAIRES	\N	\N	ARGENTINA	0101000020E61000000000004033F34EC0000000E0EEEE41C0
579	stations:380	PILAR OBS.                              	-31.666666	-63.8833351	0	\N	\N	\N	\N	\N	\N	\N	CORDOBA	\N	\N	ARGENTINA	0101000020E61000000000002011F14FC0000000A0AAAA3FC0
580	stations:381	PONTON PRACTICOS RECALADA               	-35.1666679	-56.25	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	ARGENTINA	0101000020E61000000000000000204CC000000060559541C0
581	red_salado:860	humboltd	-31.3888893	-61.0716667	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	ARGENTINA	0101000020E6100000000000602C894EC0000000408E633FC0
582	alturas_bdhi:1094	RP38	-29.7298794	-60.7195358	0	\N	\N	\N	\N	\N	\N	\N	SANTAFE	\N	\N	ARGENTINA	0101000020E6100000000000C0195C4EC000000060D9BA3DC0
583	alturas_prefe:83	Puerto GualeguaychÃº	-33.0166664	-58.5	0	\N	\N	\N	\N	\N	\N	\N	ENTRERIOS	\N	\N	ARGENTINA	0101000020E61000000000000000404DC000000020228240C0
584	alturas_prefe:89	Aporte Salto Grande	-31.2739697	-57.9380112	0	\N	\N	\N	\N	\N	\N	\N	ENTRERIOS	\N	\N	ARGENTINA	0101000020E6100000000000C010F84CC0000000E022463FC0
585	red_salado:861	las rosas	-32.8097229	-61.0716667	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	ARGENTINA	0101000020E6100000000000602C894EC000000000A56740C0
586	stations:382	SAN FERNANDO                            	-34.4500008	-58.5833321	0	\N	\N	\N	\N	\N	\N	\N	BUENOSAIRES	\N	\N	ARGENTINA	0101000020E6100000000000A0AA4A4DC0000000A0993941C0
587	stations:383	SANTA TERESITA AERO                     	-36.5499992	-56.6833344	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	ARGENTINA	0101000020E61000000000008077574CC000000060664642C0
588	stations:384	SAUCE VIEJO AERO                        	-31.7000008	-60.8166656	0	\N	\N	\N	\N	\N	\N	\N	SANTAFE	\N	\N	ARGENTINA	0101000020E61000000000008088684EC00000004033B33FC0
589	stations:385	TANDIL AERO                             	-37.2333336	-59.25	0	\N	\N	\N	\N	\N	\N	\N	BUENOSAIRES	\N	\N	ARGENTINA	0101000020E61000000000000000A04DC0000000E0DD9D42C0
590	stations:386	VILLA GESELL AERO                       	-37.2333336	-57.0166664	0	\N	\N	\N	\N	\N	\N	\N	BUENOSAIRES	\N	\N	ARGENTINA	0101000020E61000000000002022824CC0000000E0DD9D42C0
591	stations:387	VILLA MARIA DEL RIO SECO                	-29.8999996	-63.6833344	0	\N	\N	\N	\N	\N	\N	\N	CORDOBA	\N	\N	ARGENTINA	0101000020E61000000000008077D74FC00000006066E63DC0
592	stations:388	AZUL AERO                               	-36.8333321	-59.8833351	0	\N	\N	\N	\N	\N	\N	\N	BUENOSAIRES	\N	\N	ARGENTINA	0101000020E61000000000002011F14DC0000000A0AA6A42C0
593	stations:389	BAHIA BLANCA AERO                       	-38.7333336	-62.1666679	0	\N	\N	\N	\N	\N	\N	\N	BUENOSAIRES	\N	\N	ARGENTINA	0101000020E61000000000006055154FC0000000E0DD5D43C0
594	stations:390	BOLIVAR AERO                            	-36.2000008	-61.0666656	0	\N	\N	\N	\N	\N	\N	\N	BUENOSAIRES	\N	\N	ARGENTINA	0101000020E61000000000008088884EC0000000A0991942C0
595	stations:391	BUENOS AIRES                            	-34.5833321	-58.4833336	0	\N	\N	\N	\N	\N	\N	\N	CABA	\N	\N	ARGENTINA	0101000020E6100000000000E0DD3D4DC0000000A0AA4A41C0
596	stations:406	ROSARIO AERO                            	-32.9166679	-60.7833328	0	\N	\N	\N	\N	\N	\N	\N	SANTAFE	\N	\N	ARGENTINA	0101000020E61000000000004044644EC000000060557540C0
597	stations:407	SANTA ROSA AERO                         	-36.5666656	-64.2666702	0	\N	\N	\N	\N	\N	\N	\N	LAPAMPA	\N	\N	ARGENTINA	0101000020E610000000000020111150C000000080884842C0
598	stations:408	SANTA ROSA DE CONLARA AERO              	-32.6666679	-65.3166656	0	\N	\N	\N	\N	\N	\N	\N	SANLUIS	\N	\N	ARGENTINA	0101000020E610000000000040445450C000000060555540C0
599	stations:409	TRES ARROYOS                            	-38.3333321	-60.25	0	\N	\N	\N	\N	\N	\N	\N	BUENOSAIRES	\N	\N	ARGENTINA	0101000020E61000000000000000204EC0000000A0AA2A43C0
600	stations:410	VENADO TUERTO                           	-33.6666679	-61.9666672	0	\N	\N	\N	\N	\N	\N	\N	SANTAFE	\N	\N	ARGENTINA	0101000020E6100000000000C0BBFB4EC00000006055D540C0
601	stations:411	VILLA DOLORES AERO                      	-31.9500008	-65.1333313	0	\N	\N	\N	\N	\N	\N	\N	CORDOBA	\N	\N	ARGENTINA	0101000020E610000000000080884850C00000004033F33FC0
602	stations:412	VILLAGUAY AERO                          	-31.8500004	-59.0833321	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	ARGENTINA	0101000020E6100000000000A0AA8A4DC0000000A099D93FC0
603	stations:413	ANGUIL (EMC) - ANGUIL EEA INTA	-36.5	-63.9799995	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	ARGENTINA	0101000020E6100000000000A070FD4FC000000000004042C0
604	stations:414	BALCARCE (EMC) - BALCARCE EEA INTA	-37.75	-58.2999992	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	ARGENTINA	0101000020E61000000000006066264DC00000000000E042C0
605	stations:415	BARROW (EMC) - BARROW CHACRA EXPERIMENTAL INTEGRADA	-38.3199997	-60.25	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	ARGENTINA	0101000020E61000000000000000204EC0000000C0F52843C0
606	stations:417	CASTELAR (EMC) - CASTELAR CNIA INTA	-34.6049995	-58.6710014	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	ARGENTINA	0101000020E610000000000060E3554DC0000000A0704D41C0
607	stations:418	CONCORDIA (EMC) - CONCORDIA EEA INTA	-31.3700008	-58.1199989	0	\N	\N	\N	\N	\N	\N	\N	ENTRERIOS	\N	\N	ARGENTINA	0101000020E6100000000000205C0F4DC000000060B85E3FC0
608	stations:419	CONCEPCIÃN DEL URUGUAY (EMC) - CONC. DEL URUGUAY EEA INTA	-32.4799995	-58.2299995	0	\N	\N	\N	\N	\N	\N	\N	ENTRERIOS	\N	\N	ARGENTINA	0101000020E6100000000000A0701D4DC0000000A0703D40C0
609	stations:420	GRAL VILLEGAS (EMC) - GENERAL VILLEGAS EEA INTA	-34.9199982	-62.7299995	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	ARGENTINA	0101000020E6100000000000A0705D4FC000000080C27541C0
610	stations:435	ITUZAINGO	-27.5799999	-56.6699982	0	\N	\N	\N	\N	\N	\N	\N	CORRIENTES	\N	\N	ARGENTINA	0101000020E610000000000080C2554CC0000000E07A943BC0
611	stations:436	CURUZU CUATIA AERO	-29.7667007	-57.9667015	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	ARGENTINA	0101000020E6100000000000E0BCFB4CC00000008046C43DC0
612	stations:437	SAN LUIS AERO	-33.2667007	-66.3332977	0	\N	\N	\N	\N	\N	\N	\N	SANLUIS	\N	\N	ARGENTINA	0101000020E6100000000000C0549550C00000004023A240C0
613	stations:438	VILLA REYNOLDS AERO	-33.7167015	-65.3666992	0	\N	\N	\N	\N	\N	\N	\N	SANLUIS	\N	\N	ARGENTINA	0101000020E610000000000000785750C0000000E0BCDB40C0
614	stations:439	BARILOCHE AERO	-41.1333008	-71.1667023	0	\N	\N	\N	\N	\N	\N	\N	RIONEGRO	\N	\N	ARGENTINA	0101000020E610000000000040ABCA51C000000000109144C0
615	stations:440	MAQUINCHAO	-41.25	-68.7332993	0	\N	\N	\N	\N	\N	\N	\N	RIONEGRO	\N	\N	ARGENTINA	0101000020E610000000000060EE2E51C00000000000A044C0
616	stations:441	SAN ANTONIO OESTE AERO	-40.75	-65.0333023	0	\N	\N	\N	\N	\N	\N	\N	RIONEGRO	\N	\N	ARGENTINA	0101000020E6100000000000A0214250C000000000006044C0
617	stations:442	VIEDMA AERO	-40.8499985	-63.0167007	0	\N	\N	\N	\N	\N	\N	\N	RIONEGRO	\N	\N	ARGENTINA	0101000020E61000000000004023824FC0000000C0CC6C44C0
618	stations:443	EL BOLSON AERO	-41.9667015	-71.5167007	0	\N	\N	\N	\N	\N	\N	\N	RIONEGRO	\N	\N	ARGENTINA	0101000020E6100000000000A011E151C0000000E0BCFB44C0
619	stations:444	NEUQUEN AERO	-38.9500008	-68.1333008	0	\N	\N	\N	\N	\N	\N	\N	NEUQUÃN	\N	\N	ARGENTINA	0101000020E610000000000000880851C0000000A0997943C0
620	stations:445	SAN RAFAEL AERO	-34.5833015	-68.4000015	0	\N	\N	\N	\N	\N	\N	\N	MENDOZA	\N	\N	ARGENTINA	0101000020E6100000000000A0991951C0000000A0A94A41C0
621	stations:446	 BASE BELGRANO II	-77.5199966	-34.3400002	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	ARGENTINA	0101000020E610000000000020852B41C0000000A0476153C0
622	stations:447	 BASE ESPERANZA	-56.5900002	-63.2400017	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	ARGENTINA	0101000020E610000000000060B89E4FC000000020854B4CC0
623	stations:448	 BASE JUBANY	-58.3800011	-62.1399994	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	ARGENTINA	0101000020E610000000000080EB114FC0000000E0A3304DC0
624	stations:449	 BASE MARAMBIO	-56.4300003	-64.1399994	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	ARGENTINA	0101000020E6100000000000C0F50850C0000000400A374CC0
625	stations:450	 BASE ORCADAS	-60.4500008	-44.4300003	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	ARGENTINA	0101000020E6100000000000400A3746C0000000A099394EC0
626	stations:451	 BASE SAN MARTIN	-67.0800018	-68.0800018	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	ARGENTINA	0101000020E6100000000000C01E0551C0000000C01EC550C0
627	stations:454	 TRENQUE LAUQUEN	-35.5800018	-62.4399986	0	\N	\N	\N	\N	\N	\N	\N	BUENOSAIRES	\N	\N	ARGENTINA	0101000020E6100000000000E051384FC0000000803DCA41C0
628	stations:455	 CATAMARCA AERO	-28.3600006	-65.4599991	0	\N	\N	\N	\N	\N	\N	\N	CATAMARCA	\N	\N	ARGENTINA	0101000020E6100000000000A0705D50C000000000295C3CC0
629	stations:456	 TINOGASTA	-28.0400009	-67.3399963	0	\N	\N	\N	\N	\N	\N	\N	CATAMARCA	\N	\N	ARGENTINA	0101000020E610000000000080C2D550C0000000803D0A3CC0
630	stations:453	 SAN MIGUEL	-34.5499992	-58.7333298	0	\N	\N	\N	\N	\N	\N	\N	BUENOSAIRES	\N	\N	ARGENTINA	0101000020E6100000000000C0DD5D4DC000000060664641C0
631	stations:457	 COMODORO RIVADAVIA AERO	-45.4700012	-67.3000031	0	\N	\N	\N	\N	\N	\N	\N	CHUBUT	\N	\N	ARGENTINA	0101000020E61000000000004033D350C00000000029BC46C0
632	stations:458	 ESQUEL AERO	-42.5600014	-71.0899963	0	\N	\N	\N	\N	\N	\N	\N	CHUBUT	\N	\N	ARGENTINA	0101000020E610000000000080C2C551C000000020AE4745C0
633	stations:459	 PASO DE INDIOS	-43.4900017	-68.5299988	0	\N	\N	\N	\N	\N	\N	\N	CHUBUT	\N	\N	ARGENTINA	0101000020E610000000000080EB2151C000000060B8BE45C0
634	stations:460	 PUERTO MADRYN AERO	-42.4399986	-65.0400009	0	\N	\N	\N	\N	\N	\N	\N	CHUBUT	\N	\N	ARGENTINA	0101000020E6100000000000608F4250C0000000E0513845C0
635	stations:461	 TRELEW AERO	-43.1199989	-65.1600037	0	\N	\N	\N	\N	\N	\N	\N	CHUBUT	\N	\N	ARGENTINA	0101000020E6100000000000803D4A50C0000000205C8F45C0
636	stations:462	 PASO DE LOS LIBRES AERO	-29.6800003	-57.1500015	0	\N	\N	\N	\N	\N	\N	\N	CORRIENTES	\N	\N	ARGENTINA	0101000020E61000000000004033934CC00000008014AE3DC0
637	stations:463	 FORMOSA AERO	-26.1200008	-58.1399994	0	\N	\N	\N	\N	\N	\N	\N	FORMOSA	\N	\N	ARGENTINA	0101000020E610000000000080EB114DC000000060B81E3AC0
638	stations:464	 LAS LOMITAS	-24.4200001	-60.3499985	0	\N	\N	\N	\N	\N	\N	\N	FORMOSA	\N	\N	ARGENTINA	0101000020E6100000000000C0CC2C4EC000000020856B38C0
639	stations:465	 JUJUY AERO	-24.2299995	-65.0500031	0	\N	\N	\N	\N	\N	\N	\N	JUJUY	\N	\N	ARGENTINA	0101000020E610000000000040334350C000000040E13A38C0
640	stations:466	 JUJUY U N	-24.1000004	-65.1100006	0	\N	\N	\N	\N	\N	\N	\N	JUJUY	\N	\N	ARGENTINA	0101000020E6100000000000400A4750C0000000A0991938C0
641	stations:467	 LA QUIACA OBS.	-22.0599995	-65.3600006	0	\N	\N	\N	\N	\N	\N	\N	JUJUY	\N	\N	ARGENTINA	0101000020E6100000000000400A5750C0000000205C0F36C0
642	stations:468	 CHAMICAL AERO	-30.2199993	-66.1699982	0	\N	\N	\N	\N	\N	\N	\N	LARIOJA	\N	\N	ARGENTINA	0101000020E610000000000040E18A50C0000000E051383EC0
643	stations:469	 CHEPES	-31.2000008	-66.3600006	0	\N	\N	\N	\N	\N	\N	\N	LARIOJA	\N	\N	ARGENTINA	0101000020E6100000000000400A9750C00000004033333FC0
644	stations:470	 CHILECITO AERO	-29.1399994	-67.2600021	0	\N	\N	\N	\N	\N	\N	\N	LARIOJA	\N	\N	ARGENTINA	0101000020E6100000000000E0A3D050C000000000D7233DC0
645	stations:474	 MENDOZA OBSERVATORIO	-32.5299988	-68.5100021	0	\N	\N	\N	\N	\N	\N	\N	MENDOZA	\N	\N	ARGENTINA	0101000020E6100000000000E0A32051C000000000D74340C0
646	stations:475	 SAN CARLOS (MZA)	-33.4599991	-69.0199966	0	\N	\N	\N	\N	\N	\N	\N	MENDOZA	\N	\N	ARGENTINA	0101000020E6100000000000A0474151C000000040E1BA40C0
647	stations:476	 SAN MARTIN (MZA)	-33.0499992	-68.25	0	\N	\N	\N	\N	\N	\N	\N	MENDOZA	\N	\N	ARGENTINA	0101000020E610000000000000001051C000000060668640C0
648	stations:477	 USPALLATA	-32.3600006	-69.1999969	0	\N	\N	\N	\N	\N	\N	\N	MENDOZA	\N	\N	ARGENTINA	0101000020E6100000000000C0CC4C51C000000080142E40C0
649	stations:478	 BERNARDO DE IRIGOYEN AERO	-26.25	-53.6500015	0	\N	\N	\N	\N	\N	\N	\N	MISIONES	\N	\N	ARGENTINA	0101000020E61000000000004033D34AC00000000000403AC0
650	stations:479	 IGUAZU AERO	-25.7299995	-54.4700012	0	\N	\N	\N	\N	\N	\N	\N	MISIONES	\N	\N	ARGENTINA	0101000020E610000000000000293C4BC000000040E1BA39C0
651	stations:480	 OBERA AERO	-27.4799995	-55.1300011	0	\N	\N	\N	\N	\N	\N	\N	MISIONES	\N	\N	ARGENTINA	0101000020E6100000000000E0A3904BC000000040E17A3BC0
652	stations:481	 POSADAS AERO	-27.3700008	-55.9700012	0	\N	\N	\N	\N	\N	\N	\N	MISIONES	\N	\N	ARGENTINA	0101000020E61000000000000029FC4BC000000060B85E3BC0
653	stations:482	 CHAPELCO AERO	-40.0499992	-71.0800018	0	\N	\N	\N	\N	\N	\N	\N	NEUQUÃN	\N	\N	ARGENTINA	0101000020E6100000000000C01EC551C000000060660644C0
654	stations:483	 CIPOLLETTI	-38.5699997	-67.5800018	0	\N	\N	\N	\N	\N	\N	\N	RIONEGRO	\N	\N	ARGENTINA	0101000020E6100000000000C01EE550C0000000C0F54843C0
655	stations:484	 RIO COLORADO	-39.0099983	-64.0500031	0	\N	\N	\N	\N	\N	\N	\N	RIONEGRO	\N	\N	ARGENTINA	0101000020E610000000000040330350C0000000A0478143C0
656	stations:485	 METAN	-25.2900009	-64.4800034	0	\N	\N	\N	\N	\N	\N	\N	SALTA	\N	\N	ARGENTINA	0101000020E610000000000060B81E50C0000000803D4A39C0
657	stations:486	 ORAN AERO	-23.0900002	-64.1900024	0	\N	\N	\N	\N	\N	\N	\N	SALTA	\N	\N	ARGENTINA	0101000020E610000000000000290C50C0000000400A1737C0
658	stations:487	 RIVADAVIA	-24.1000004	-62.5400009	0	\N	\N	\N	\N	\N	\N	\N	SALTA	\N	\N	ARGENTINA	0101000020E6100000000000C01E454FC0000000A0991938C0
659	stations:488	 SALTA AERO	-24.5100002	-65.2900009	0	\N	\N	\N	\N	\N	\N	\N	SALTA	\N	\N	ARGENTINA	0101000020E6100000000000608F5250C0000000608F8238C0
660	stations:489	 TARTAGAL AERO	-22.3899994	-63.4900017	0	\N	\N	\N	\N	\N	\N	\N	SALTA	\N	\N	ARGENTINA	0101000020E610000000000060B8BE4FC000000000D76336C0
661	stations:490	 EL CALAFATE AERO	-50.1599998	-72.0299988	0	\N	\N	\N	\N	\N	\N	\N	SANTACRUZ	\N	\N	ARGENTINA	0101000020E610000000000080EB0152C0000000E07A1449C0
662	stations:491	 GOBERNADOR GREGORES AERO	-48.4700012	-70.0999985	0	\N	\N	\N	\N	\N	\N	\N	SANTACRUZ	\N	\N	ARGENTINA	0101000020E610000000000060668651C000000000293C48C0
663	stations:492	 PERITO MORENO AERO	-46.3100014	-71.0100021	0	\N	\N	\N	\N	\N	\N	\N	SANTACRUZ	\N	\N	ARGENTINA	0101000020E6100000000000E0A3C051C000000020AE2747C0
664	stations:493	 PUERTO DESEADO AERO	-47.4399986	-65.5500031	0	\N	\N	\N	\N	\N	\N	\N	SANTACRUZ	\N	\N	ARGENTINA	0101000020E610000000000040336350C0000000E051B847C0
665	stations:494	 RIO GALLEGOS AERO	-51.3699989	-69.1699982	0	\N	\N	\N	\N	\N	\N	\N	SANTACRUZ	\N	\N	ARGENTINA	0101000020E610000000000040E14A51C0000000205CAF49C0
666	stations:495	 SAN JULIAN AERO	-49.1899986	-67.4700012	0	\N	\N	\N	\N	\N	\N	\N	SANTACRUZ	\N	\N	ARGENTINA	0101000020E61000000000008014DE50C0000000E0519848C0
667	stations:496	 RECONQUISTA AERO	-29.1100006	-59.4199982	0	\N	\N	\N	\N	\N	\N	\N	SANTAFE	\N	\N	ARGENTINA	0101000020E610000000000080C2B54DC000000000291C3DC0
668	stations:498	 SUNCHALES AERO	-30.5799999	-61.2000008	0	\N	\N	\N	\N	\N	\N	\N	SANTAFE	\N	\N	ARGENTINA	0101000020E6100000000000A099994EC0000000E07A943EC0
669	stations:499	 JACHAL	-30.1399994	-68.4499969	0	\N	\N	\N	\N	\N	\N	\N	SANJUAN	\N	\N	ARGENTINA	0101000020E6100000000000C0CC1C51C000000000D7233EC0
670	stations:500	 SAN JUAN AERO	-31.3400002	-68.25	0	\N	\N	\N	\N	\N	\N	\N	SANJUAN	\N	\N	ARGENTINA	0101000020E610000000000000001051C0000000400A573FC0
671	stations:502	 TOLHUIN	-67.1500015	-54.4199982	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	ARGENTINA	0101000020E610000000000080C2354BC0000000A099C950C0
672	stations:504	 TUCUMAN AERO	-26.5100002	-65.0599976	0	\N	\N	\N	\N	\N	\N	\N	TUCUMÃN	\N	\N	ARGENTINA	0101000020E610000000000000D74350C0000000608F823AC0
673	stations:506	 MERCEDES AERO (CTES)	-29.2199993	-58.0999985	0	\N	\N	\N	\N	\N	\N	\N	CORRIENTES	\N	\N	ARGENTINA	0101000020E6100000000000C0CC0C4DC0000000E051383DC0
674	stations:507	 VICTORICA	-36.1300011	-65.2600021	0	\N	\N	\N	\N	\N	\N	\N	LAPAMPA	\N	\N	ARGENTINA	0101000020E6100000000000E0A35050C0000000E0A31042C0
675	stations:508	 SANTA CRUZ AERO	-50.0099983	-68.3399963	0	\N	\N	\N	\N	\N	\N	\N	SANTACRUZ	\N	\N	ARGENTINA	0101000020E610000000000080C21551C0000000A0470149C0
676	stations:509	 RAFAELA AERO	-31.1599998	-61.2999992	0	\N	\N	\N	\N	\N	\N	\N	SANTAFE	\N	\N	ARGENTINA	0101000020E61000000000006066A64EC0000000C0F5283FC0
677	stations:471	 LA RIOJA AERO	-29.2299995	-66.4899979	0	\N	\N	\N	\N	\N	\N	\N	LARIOJA	\N	\N	ARGENTINA	0101000020E6100000000000205C9F50C000000040E13A3DC0
678	stations:472	 MALARGUE AERO	-35.2999992	-69.3499985	0	\N	\N	\N	\N	\N	\N	\N	MENDOZA	\N	\N	ARGENTINA	0101000020E610000000000060665651C00000006066A641C0
679	stations:473	 MENDOZA AERO	-32.5	-68.4700012	0	\N	\N	\N	\N	\N	\N	\N	MENDOZA	\N	\N	ARGENTINA	0101000020E610000000000080141E51C000000000004040C0
680	stations:512	Alto Valle INTA	-39.0200005	-67.6699982	0	\N	\N	\N	\N	\N	\N	\N	RIONEGRO	\N	\N	ARGENTINA	0101000020E610000000000040E1EA50C0000000608F8243C0
681	stations:513	Bella Vista INTA	-28.4300003	-58.9199982	0	\N	\N	\N	\N	\N	\N	\N	CORRIENTES	\N	\N	ARGENTINA	0101000020E610000000000080C2754DC000000080146E3CC0
682	stations:514	Canals INTA	-33.5699997	-62.8800011	0	\N	\N	\N	\N	\N	\N	\N	CORDOBA	\N	\N	ARGENTINA	0101000020E6100000000000E0A3704FC0000000C0F5C840C0
683	stations:515	Capilla del Monte INTA	-30.8600006	-64.5199966	0	\N	\N	\N	\N	\N	\N	\N	CORDOBA	\N	\N	ARGENTINA	0101000020E6100000000000A0472150C00000000029DC3EC0
684	stations:516	Chacras de Coria	-32.9799995	-68.8700027	0	\N	\N	\N	\N	\N	\N	\N	MENDOZA	\N	\N	ARGENTINA	0101000020E610000000000020AE3751C0000000A0707D40C0
685	stations:517	Colonia BenÃ­tez INTA	-27.4200001	-58.9300003	0	\N	\N	\N	\N	\N	\N	\N	CHACO	\N	\N	ARGENTINA	0101000020E6100000000000400A774DC000000020856B3BC0
686	stations:518	El Colorado INTA	-26.2999992	-59.3699989	0	\N	\N	\N	\N	\N	\N	\N	FORMOSA	\N	\N	ARGENTINA	0101000020E6100000000000205CAF4DC0000000C0CC4C3AC0
687	stations:519	FamaillÃ¡ INTA	-27.0499992	-65.4199982	0	\N	\N	\N	\N	\N	\N	\N	TUCUMÃN	\N	\N	ARGENTINA	0101000020E610000000000040E15A50C0000000C0CC0C3BC0
688	stations:520	La Consulta INTA	-33.7299995	-69.1200027	0	\N	\N	\N	\N	\N	\N	\N	MENDOZA	\N	\N	ARGENTINA	0101000020E610000000000020AE4751C0000000A070DD40C0
689	stations:521	La MarÃ­a INTA	-28.2299995	-64.1500015	0	\N	\N	\N	\N	\N	\N	\N	SANTIAGODELESTERO	\N	\N	ARGENTINA	0101000020E6100000000000A0990950C000000040E13A3CC0
690	stations:522	Las BreÃ±as INTA	-27.0799999	-61.1199989	0	\N	\N	\N	\N	\N	\N	\N	CHACO	\N	\N	ARGENTINA	0101000020E6100000000000205C8F4EC0000000E07A143BC0
691	stations:524	San Juan INTA	-31.3700008	-68.3199997	0	\N	\N	\N	\N	\N	\N	\N	SANJUAN	\N	\N	ARGENTINA	0101000020E6100000000000E07A1451C000000060B85E3FC0
692	red_salado:862	margarita	-29.6963882	-60.2505569	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	ARGENTINA	0101000020E61000000000004012204EC00000008046B23DC0
693	red_salado:863	monje	-32.3675003	-60.9319458	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	ARGENTINA	0101000020E6100000000000004A774EC0000000400A2F40C0
694	red_salado:864	srrafaela	-31.2099991	-61.4419441	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	ARGENTINA	0101000020E6100000000000A091B84EC000000080C2353FC0
695	red_salado:865	san guillermo	-30.3686104	-61.9236107	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	ARGENTINA	0101000020E6100000000000E038F64EC0000000405D5E3EC0
696	red_salado:866	san javier	-30.5546398	-59.9347229	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	ARGENTINA	0101000020E610000000000000A5F74DC0000000E0FC8D3EC0
697	red_salado:867	san justo	-30.7966671	-60.6002769	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	ARGENTINA	0101000020E6100000000000E0D54C4EC000000060F2CB3EC0
698	red_salado:868	san cristobal	-30.3295841	-61.2351379	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	ARGENTINA	0101000020E610000000000000199E4EC0000000A05F543EC0
699	red_salado:869	venado tuerto	-33.6822205	-61.961113	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	ARGENTINA	0101000020E6100000000000C005FB4EC00000000053D740C0
700	red_salado:870	villa amelia	-32.4797211	-61.5666656	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	ARGENTINA	0101000020E61000000000008088C84EC000000080673D40C0
701	red_salado:871	villa eloisa	-33.6091652	-61.9172211	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	ARGENTINA	0101000020E61000000000008067F54EC000000020F9CD40C0
702	red_inta:798	INTA - Coronel Pringle - Dir. Rem.Vet.	-37.7420006	-61.5250015	0	\N	\N	\N	\N	\N	\N	\N	Buenos Aires	\N	\N	ARGENTINA	0101000020E61000000000004033C34EC0000000E0F9DE42C0
703	red_inta:1261	Las Rosas - EEA Oliveros	-32.4900017	-61.5699997	0	\N	\N	\N	\N	\N	\N	\N	Santa Fe	\N	\N	ARGENTINA	0101000020E6100000000000C0F5C84EC000000060B83E40C0
704	red_inta:815	J.B. Molina - Establecimiento Agropecuario Ponzanessi	-33.4970016	-60.5349998	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	ARGENTINA	0101000020E6100000000000E07A444EC0000000C09DBF40C0
705	red_inta:829	Marcos Juarez - En predio de EEA Marcos Juarez	-32.7190018	-62.105999	0	\N	\N	\N	\N	\N	\N	\N	CÃ³rdoba	\N	\N	ARGENTINA	0101000020E610000000000060910D4FC000000040085C40C0
706	red_inta:816	Juan Jose Castelli - Juan Jose Castelli	-25.9400005	-60.6069984	0	\N	\N	\N	\N	\N	\N	\N	Chaco	\N	\N	ARGENTINA	0101000020E610000000000020B24D4EC0000000E0A3F039C0
707	red_inta:822	Las Marianas - Establecimiento Las Marianas	-27.2740002	-59.144001	0	\N	\N	\N	\N	\N	\N	\N	Chaco	\N	\N	ARGENTINA	0101000020E6100000000000A06E924DC0000000E024463BC0
708	estaciones_salto_grande:1063	MiriÃ±ay RÃ­o	-29.8456364	-57.6744461	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	Unknown	0101000020E61000000000004054D64CC0000000A07BD83DC0
709	red_inta:851	BartolomÃ© de las Casas - EEA Colorado	-25.448	-59.5040016	0	\N	\N	\N	\N	\N	\N	\N	Formosa	\N	\N	ARGENTINA	0101000020E61000000000002083C04DC000000020B07239C0
710	estaciones_salto_grande:1072	Artigas	-30.3925343	-56.4561195	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	Unknown	0101000020E610000000000020623A4CC0000000207D643EC0
711	estaciones_salto_grande:1058	Colonia Palma	-30.5803337	-57.6803169	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	Unknown	0101000020E6100000000000A014D74CC0000000C090943EC0
712	estaciones_salto_grande:1059	BelÃ©n	-30.7872524	-57.7830887	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	Unknown	0101000020E6100000000000403CE44CC00000006089C93EC0
713	estaciones_salto_grande:1016	Puerto Concordia	-31.404213	-58.0025597	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	Unknown	0101000020E6100000000000E053004DC0000000807A673FC0
714	alturas_bdhi:3	Paso Alonso	-33.1006126	-59.2703323	0	\N	\N	\N	\N	\N	\N	\N	ENTRERIOS	\N	\N	ARGENTINA	0101000020E6100000000000409AA24DC0000000E0E08C40C0
715	alturas_bdhi:4	Villaguay	-31.8016109	-59.1259995	0	\N	\N	\N	\N	\N	\N	\N	ENTRERIOS	\N	\N	ARGENTINA	0101000020E6100000000000C020904DC00000006036CD3FC0
716	alturas_bdhi:5	Paso Medina	-30.9236946	-59.5512238	0	\N	\N	\N	\N	\N	\N	\N	ENTRERIOS	\N	\N	ARGENTINA	0101000020E6100000000000808EC64DC00000004077EC3EC0
717	alturas_bdhi:6	Puerto Ruiz	-33.2223282	-59.365097	0	\N	\N	\N	\N	\N	\N	\N	ENTRERIOS	\N	\N	ARGENTINA	0101000020E610000000000080BBAE4DC000000040759C40C0
718	alturas_bdhi:7	Puente JÃ¡uregui	-34.5891457	-59.1785049	0	\N	\N	\N	\N	\N	\N	\N	BUENOSAIRES	\N	\N	ARGENTINA	0101000020E610000000000040D9964DC000000020694B41C0
719	alturas_bdhi:102	Ruta Nacional nÂº 130	-32.1043587	-58.4905663	0	\N	\N	\N	\N	\N	\N	\N	ENTRERIOS	\N	\N	ARGENTINA	0101000020E6100000000000E0CA3E4DC0000000A05B0D40C0
720	alturas_bdhi:127	Moussy	-28.9979172	-59.7526093	0	\N	\N	\N	\N	\N	\N	\N	SANTAFE	\N	\N	ARGENTINA	0101000020E61000000000008055E04DC00000008077FF3CC0
721	alturas_bdhi:128	FortÃ­n Olmos	-29.0655003	-60.4971657	0	\N	\N	\N	\N	\N	\N	\N	SANTAFE	\N	\N	ARGENTINA	0101000020E610000000000020A33F4EC0000000A0C4103DC0
722	alturas_genica:115	Pergamino (Urquiza)	-34.0160141	-60.3913193	0	\N	\N	\N	\N	\N	\N	\N	BUENOSAIRES	\N	\N	ARGENTINA	0101000020E6100000000000C016324EC0000000C00C0241C0
723	alturas_genica:145	Rojas	-34.2126808	-60.7438698	0	\N	\N	\N	\N	\N	\N	\N	BUENOSAIRES	\N	\N	ARGENTINA	0101000020E610000000000020375F4EC000000020391B41C0
724	estaciones_salto_grande:1017	YapeyÃº	-29.4704437	-56.8116684	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	Unknown	0101000020E6100000000000C0E4674CC0000000006F783DC0
725	estaciones_salto_grande:1018	Salto Grande	-31.2727051	-57.9165955	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	Unknown	0101000020E61000000000000053F54CC000000000D0453FC0
726	estaciones_salto_grande:1019	Alvear	-29.112957	-56.5555229	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	Unknown	0101000020E6100000000000601B474CC0000000C0EA1C3DC0
727	red_areco:113	Club de pescadores	-34.2406769	-59.4995308	0	\N	\N	\N	\N	\N	\N	\N	BUENOSAIRES	\N	\N	ARGENTINA	0101000020E6100000000000A0F0BF4DC000000080CE1E41C0
728	red_areco:141	Puente Quemado	-34.2873535	-59.6924057	0	\N	\N	\N	\N	\N	\N	\N	BUENOSAIRES	\N	\N	ARGENTINA	0101000020E6100000000000C0A0D84DC000000000C82441C0
729	red_areco:142	Balneario Carmen de Areco	-34.3520813	-59.8168411	0	\N	\N	\N	\N	\N	\N	\N	BUENOSAIRES	\N	\N	ARGENTINA	0101000020E6100000000000408EE84DC000000000112D41C0
730	estaciones_salto_grande:1021	Paso de los Libres	-29.7217445	-57.0828552	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	Unknown	0101000020E6100000000000009B8A4CC000000040C4B83DC0
731	estaciones_salto_grande:1022	FederaciÃ³n	-30.9921894	-57.9138489	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	Unknown	0101000020E610000000000000F9F44CC00000002000FE3EC0
732	estaciones_salto_grande:1023	CatalÃ¡n	-30.7511959	-56.2146568	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	Unknown	0101000020E6100000000000E0791B4CC0000000604EC03EC0
733	estaciones_salto_grande:1024	El Trompo	-30.9710255	-58.2473183	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	Unknown	0101000020E610000000000020A81F4DC00000002095F83EC0
734	estaciones_salto_grande:1025	Cerro Amarillo	-30.6242695	-56.6574936	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	Unknown	0101000020E6100000000000C028544CC000000020D09F3EC0
735	estaciones_salto_grande:1026	Catalan Grande	-30.6380005	-56.3260002	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	Unknown	0101000020E610000000000060BA294CC00000000054A33EC0
736	estaciones_salto_grande:1027	Paso Campamento	-30.7872143	-56.7863083	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	Unknown	0101000020E6100000000000C0A5644CC0000000E086C93EC0
737	estaciones_salto_grande:1028	Cuareim Rio	-30.5863895	-56.2301521	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	Unknown	0101000020E6100000000000A0751D4CC0000000A01D963EC0
738	estaciones_salto_grande:1029	Roncador	-30.5582523	-56.3100777	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	Unknown	0101000020E6100000000000A0B0274CC0000000A0E98E3EC0
739	estaciones_salto_grande:1030	Paso del LeÃ³n	-30.2052803	-57.0747375	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	Unknown	0101000020E61000000000000091894CC0000000408D343EC0
740	estaciones_salto_grande:1031	CuarÃ³	-30.6138363	-56.9059486	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	Unknown	0101000020E610000000000020F6734CC000000060249D3EC0
741	estaciones_salto_grande:1032	BernabÃ© Rivera	-30.2993011	-56.9721413	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	Unknown	0101000020E6100000000000206F7C4CC0000000009F4C3EC0
742	estaciones_salto_grande:1033	Meneses	-30.8655453	-56.4116592	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	Unknown	0101000020E610000000000040B1344CC00000006094DD3EC0
743	estaciones_salto_grande:1034	Paso del Remanso	-30.2239532	-56.6675415	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	Unknown	0101000020E61000000000000072554CC00000000055393EC0
744	estaciones_salto_grande:1039	PepirÃ­ MinÃ­	-27.1533031	-53.9332848	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	Unknown	0101000020E6100000000000E075F74AC0000000E03E273BC0
745	estaciones_salto_grande:1040	Colonia Lavalleja	-31.0924206	-57.0218887	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	Unknown	0101000020E610000000000040CD824CC0000000E0A8173FC0
746	estaciones_salto_grande:1041	Sequeira	-31.0048771	-56.8790436	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	Unknown	0101000020E61000000000008084704CC0000000A03F013FC0
747	estaciones_salto_grande:1042	ArerunguÃ¡	-31.6630535	-56.6189728	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	Unknown	0101000020E6100000000000803A4F4CC0000000E0BDA93FC0
748	estaciones_salto_grande:1043	Quintana	-31.3503304	-56.3925323	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	Unknown	0101000020E6100000000000803E324CC000000040AF593FC0
749	estaciones_salto_grande:1044	ValentÃ­n	-31.2751503	-57.1300507	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	Unknown	0101000020E610000000000080A5904CC00000004070463FC0
750	estaciones_salto_grande:1045	Puntas de ValentÃ­n	-31.4938374	-57.1205254	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	Unknown	0101000020E6100000000000606D8F4CC0000000206C7E3FC0
751	estaciones_salto_grande:1046	Paso Potrero	-31.4446354	-56.84021	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	Unknown	0101000020E6100000000000008C6B4CC0000000A0D3713FC0
752	estaciones_salto_grande:1047	Cerro Chato	-31.3378334	-56.6290054	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	Unknown	0101000020E61000000000004083504CC0000000407C563FC0
753	estaciones_salto_grande:1035	Garruchos	-28.177515	-55.6422691	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	Unknown	0101000020E6100000000000E035D24BC0000000A0712D3CC0
754	estaciones_salto_grande:1036	Santo TomÃ©	-28.5450726	-56.0289955	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	Unknown	0101000020E610000000000020B6034CC0000000E0898B3CC0
755	estaciones_salto_grande:1037	San Javier	-27.8693428	-55.1292152	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	Unknown	0101000020E6100000000000208A904BC0000000408DDE3BC0
756	estaciones_salto_grande:1038	El Soberbio	-27.2985821	-54.1934357	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	Unknown	0101000020E610000000000080C2184BC0000000E06F4C3BC0
757	estaciones_salto_grande:1064	Solari	-29.3773575	-58.1935349	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	Unknown	0101000020E6100000000000C0C5184DC0000000809A603DC0
758	estaciones_salto_grande:1065	Baibene	-29.6035995	-58.1651764	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	Unknown	0101000020E61000000000008024154DC000000080859A3DC0
759	estaciones_salto_grande:1066	CuruzÃº CuatiÃ¡	-29.7870693	-58.070282	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	Unknown	0101000020E610000000000000FF084DC0000000607DC93DC0
760	estaciones_salto_grande:1067	Cazadores Correntinos	-29.98349	-58.2959633	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	Unknown	0101000020E610000000000020E2254DC000000000C6FB3DC0
761	estaciones_salto_grande:1068	Los Conquistadores	-30.5902958	-58.468998	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	Unknown	0101000020E610000000000020083C4DC0000000A01D973EC0
762	estaciones_salto_grande:1069	ChajarÃ­	-30.7762413	-58.1418877	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	Unknown	0101000020E61000000000006029124DC0000000C0B7C63EC0
763	estaciones_salto_grande:1070	San Jaime	-30.3373718	-58.3171463	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	Unknown	0101000020E61000000000004098284DC0000000005E563EC0
764	estaciones_salto_grande:1071	MocoretÃ¡ Medio	-30.2144451	-57.9669075	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	Unknown	0101000020E6100000000000A0C3FB4CC0000000E0E5363EC0
765	alturas_bdhi:304	San Javier	-27.8799992	-55.1300011	0	\N	\N	\N	\N	\N	\N	\N	MISIONES	\N	\N	ARGENTINA	0101000020E6100000000000E0A3904BC0000000A047E13BC0
766	red_ana_hidro:264	Itapiranga	-27.1718998	-53.7085991	0	\N	\N	\N	\N	\N	\N	\N	BRASIL	\N	\N	BRASIL	0101000020E610000000000060B3DA4AC0000000A0012C3BC0
767	red_ana_hidro:265	Sao Ludgero	-27.0699997	-53.7999992	0	\N	\N	\N	\N	\N	\N	\N	BRASIL	\N	\N	BRASIL	0101000020E61000000000006066E64AC000000080EB113BC0
768	red_ana_hidro:266	El Soberbio	-27.2999992	-54.2000008	0	\N	\N	\N	\N	\N	\N	\N	MISIONES	\N	\N	ARGENTINA	0101000020E6100000000000A099194BC0000000C0CC4C3BC0
769	red_ana_hidro:267	Vera Cruz - Jusante	-27.75	-54.9199982	0	\N	\N	\N	\N	\N	\N	\N	MISIONES	\N	\N	ARGENTINA	0101000020E610000000000080C2754BC00000000000C03BC0
770	red_ana_hidro:269	Garruchos Bz	-28.1800003	-55.6399994	0	\N	\N	\N	\N	\N	\N	\N	MISIONES	\N	\N	ARGENTINA	0101000020E610000000000080EBD14BC000000080142E3CC0
771	red_ana_hidro:270	Garruchos Ar	-28.1800003	-55.6500015	0	\N	\N	\N	\N	\N	\N	\N	MISIONES	\N	\N	ARGENTINA	0101000020E61000000000004033D34BC000000080142E3CC0
772	alturas_chapeco:176	Chapeco_efluente	-27.1400661	-53.0435066	0	\N	\N	\N	\N	\N	\N	\N	BRASIL	\N	\N	BRASIL	0101000020E6100000000000A091854AC000000060DB233BC0
773	alturas_chapeco:178	Chapeco_rio	-27.0956993	-53.014801	0	\N	\N	\N	\N	\N	\N	\N	BRASIL	\N	\N	BRASIL	0101000020E610000000000000E5814AC0000000C07F183BC0
774	alturas_dinac:157	AsunciÃ³n	-25.2720699	-57.6486893	0	\N	\N	\N	\N	\N	\N	\N	PARAGUAY	\N	\N	PARAGUAY	0101000020E61000000000004008D34CC000000060A64539C0
775	stations_cdp:529	CUIABA	-15.3000002	-56.0999985	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	BRASIL	0101000020E6100000000000C0CC0C4CC0000000A099992EC0
776	stations_cdp:530	PADRE RICARDO REMETTER	-15.5	-56	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	BRASIL	0101000020E61000000000000000004CC00000000000002FC0
777	stations_cdp:531	PIRENOPOLIS	-15.5	-48.5999985	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	BRASIL	0101000020E6100000000000C0CC4C48C00000000000002FC0
778	stations_cdp:532	BRASILIA	-15.5	-47.5999985	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	BRASIL	0101000020E6100000000000C0CCCC47C00000000000002FC0
779	stations_cdp:533	BRASILIA AEROPORTO	-15.5	-47.5999985	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	BRASIL	0101000020E6100000000000C0CCCC47C00000000000002FC0
780	stations_cdp:534	CACERES	-16	-57.4000015	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	BRASIL	0101000020E61000000000004033B34CC000000000000030C0
781	stations_cdp:535	RONDONOPOLIS	-16.2999992	-54.2999992	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	BRASIL	0101000020E61000000000006066264BC0000000C0CC4C30C0
782	stations_cdp:536	GOIANIA	-16.3999996	-49.2000008	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	BRASIL	0101000020E6100000000000A0999948C000000060666630C0
783	estaciones_salto_grande:1050	Arapey Grande	-30.9981995	-57.4858398	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	Unknown	0101000020E61000000000000030BE4CC0000000008AFF3EC0
784	estaciones_salto_grande:1052	Arapey Chico	-30.9498997	-57.4558983	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	Unknown	0101000020E6100000000000E05ABA4CC0000000A02CF33EC0
785	alturas_prefe:8	Andresito	-25.583334	-53.9833336	0	\N	\N	\N	\N	\N	\N	\N	MISIONES	\N	\N	ARGENTINA	0101000020E6100000000000E0DDFD4AC000000060559539C0
786	alturas_bdhi:2	Rosario del Tala	-32.291832	-59.0568047	0	\N	\N	\N	\N	\N	\N	\N	ENTRERIOS	\N	\N	ARGENTINA	0101000020E61000000000006045874DC0000000C05A2540C0
787	alturas_bdhi:103	Recreo - Ruta Provincial nÂº 70	-31.475668	-60.7527771	0	\N	\N	\N	\N	\N	\N	\N	SANTAFE	\N	\N	ARGENTINA	0101000020E6100000000000005B604EC000000060C5793FC0
788	alturas_genica:100	Arrecifes	-34.0751991	-60.1079254	0	\N	\N	\N	\N	\N	\N	\N	BUENOSAIRES	\N	\N	ARGENTINA	0101000020E610000000000080D00D4EC000000020A00941C0
789	alturas_genica:101	Salto	-34.2778587	-60.2484055	0	\N	\N	\N	\N	\N	\N	\N	BUENOSAIRES	\N	\N	ARGENTINA	0101000020E6100000000000C0CB1F4EC0000000E0902341C0
790	alturas_prefe:10	Libertad	-25.9166794	-54.6211357	0	\N	\N	\N	\N	\N	\N	\N	MISIONES	\N	\N	ARGENTINA	0101000020E610000000000060814F4BC000000080ABEA39C0
791	alturas_prefe:17	ItatÃ­	-27.266777	-58.2440758	0	\N	\N	\N	\N	\N	\N	\N	CORRIENTES	\N	\N	ARGENTINA	0101000020E6100000000000E03D1F4DC0000000804B443BC0
792	red_ana_hidro:271	Santo Tome	-28.5499992	-56.0299988	0	\N	\N	\N	\N	\N	\N	\N	MISIONES	\N	\N	ARGENTINA	0101000020E610000000000000D7034CC0000000C0CC8C3CC0
793	red_ana_hidro:272	Passo Sao Borja	-28.6243992	-56.3689995	0	\N	\N	\N	\N	\N	\N	\N	BRASIL	\N	\N	BRASIL	0101000020E6100000000000603B2F4CC0000000A0D89F3CC0
794	red_ana_hidro:273	Alvear	-29.1000004	-56.5499992	0	\N	\N	\N	\N	\N	\N	\N	BRASIL	\N	\N	BRASIL	0101000020E61000000000006066464CC0000000A099193DC0
795	red_ana_hidro:274	Itaqui	-29.1200008	-56.5499992	0	\N	\N	\N	\N	\N	\N	\N	BRASIL	\N	\N	BRASIL	0101000020E61000000000006066464CC000000060B81E3DC0
796	red_ana_hidro:275	Passo do Ibicui	-29.4009991	-56.6870003	0	\N	\N	\N	\N	\N	\N	\N	BRASIL	\N	\N	BRASIL	0101000020E6100000000000A0EF574CC0000000E0A7663DC0
797	red_ana_hidro:276	Paso de los Libres	-29.7166996	-57.0833015	0	\N	\N	\N	\N	\N	\N	\N	URUGUAY	\N	\N	URUGUAY	0101000020E6100000000000A0A98A4CC0000000A079B73DC0
798	stations_cdp:537	GOIANIA AEROPORTO	-16.3999996	-49.0999985	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	BRASIL	0101000020E6100000000000C0CC8C48C000000060666630C0
799	stations_cdp:538	JATAI	-17.5	-51.4000015	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	BRASIL	0101000020E61000000000004033B349C000000000008031C0
800	stations_cdp:539	RIO VERDE	-17.6000004	-50.5999985	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	BRASIL	0101000020E6100000000000C0CC4C49C0000000A0999931C0
801	stations_cdp:540	NHUMIRIM	-18.6000004	-56.4000015	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	BRASIL	0101000020E61000000000004033334CC0000000A0999932C0
802	stations_cdp:541	CAPINOPOLIS	-18.3999996	-49.2999992	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	BRASIL	0101000020E61000000000006066A648C000000060666632C0
803	stations_cdp:542	IPAMERI	-17.3999996	-48.0999985	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	BRASIL	0101000020E6100000000000C0CC0C48C000000060666631C0
804	stations_cdp:543	CATALAO	-18.1000004	-47.5999985	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	BRASIL	0101000020E6100000000000C0CCCC47C0000000A0991932C0
805	stations_cdp:544	PATOS DE MINAS	-18.3999996	-46.2999992	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	BRASIL	0101000020E610000000000060662647C000000060666632C0
806	stations_cdp:545	CORUMBA	-19	-57.4000015	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	BRASIL	0101000020E61000000000004033B34CC000000000000033C0
807	stations_cdp:546	CORUMBA-AEROPORTO	-19	-57.4000015	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	BRASIL	0101000020E61000000000004033B34CC000000000000033C0
808	stations_cdp:547	PARANAIBA	-19.3999996	-51.0999985	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	BRASIL	0101000020E6100000000000C0CC8C49C000000060666633C0
809	stations_cdp:548	FRUTAL	-20	-48.5999985	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	BRASIL	0101000020E6100000000000C0CC4C48C000000000000034C0
810	stations_cdp:549	UBERABA (AERO)	-19.5	-47.5999985	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	BRASIL	0101000020E6100000000000C0CCCC47C000000000008033C0
811	stations_cdp:550	UBERABA	-19.5	-47.5	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	BRASIL	0101000020E61000000000000000C047C000000000008033C0
812	stations_cdp:551	ARAXA	-19.2999992	-46.5999985	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	BRASIL	0101000020E6100000000000C0CC4C47C0000000C0CC4C33C0
813	stations_cdp:552	CAMPO GRANDE	-20.2999992	-54.4000015	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	BRASIL	0101000020E61000000000004033334BC0000000C0CC4C34C0
814	stations_cdp:553	CAMPO GRANDE AEROPORTO	-20.2999992	-54.4000015	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	BRASIL	0101000020E61000000000004033334BC0000000C0CC4C34C0
815	stations_cdp:554	TRES LAGOAS	-20.5	-51.4000015	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	BRASIL	0101000020E61000000000004033B349C000000000008034C0
816	stations_cdp:555	VOTUPORANGA	-20.2999992	-49.5999985	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	BRASIL	0101000020E6100000000000C0CCCC48C0000000C0CC4C34C0
817	stations_cdp:556	DOURADOS	-22.1000004	-54.5	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	BRASIL	0101000020E61000000000000000404BC0000000A0991936C0
818	stations_cdp:557	SAO SIMAO	-21.2999992	-47.2999992	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	BRASIL	0101000020E61000000000006066A647C0000000C0CC4C35C0
819	stations_cdp:558	PIRASSUNUNGA	-21.6000004	-47.2000008	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	BRASIL	0101000020E6100000000000A0999947C0000000A0999935C0
820	stations_cdp:559	CATANDUVA	-21.1000004	-48.5999985	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	BRASIL	0101000020E6100000000000C0CC4C48C0000000A0991935C0
821	stations_cdp:560	MACHADO	-21.3999996	-45.5999985	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	BRASIL	0101000020E6100000000000C0CCCC46C000000060666635C0
822	stations_cdp:561	LAVRAS	-21.1000004	-45	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	BRASIL	0101000020E610000000000000008046C0000000A0991935C0
823	stations_cdp:562	PONTA PORA AEROPORTO	-22.2999992	-55.4000015	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	BRASIL	0101000020E61000000000004033B34BC0000000C0CC4C36C0
824	stations_cdp:563	IVINHEMA	-22.2000008	-53.5999985	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	BRASIL	0101000020E6100000000000C0CCCC4AC000000040333336C0
825	stations_cdp:564	CAMPOS DO JORDAO	-22.3999996	-43.4000015	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	BRASIL	0101000020E61000000000004033B345C000000060666636C0
826	stations_cdp:565	PRESIDENTE PRUDENTE	-22.1000004	-51.2000008	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	BRASIL	0101000020E6100000000000A0999949C0000000A0991936C0
827	stations_cdp:566	CAMPINAS AEROPORTO	-23	-47.0999985	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	BRASIL	0101000020E6100000000000C0CC8C47C000000000000037C0
828	stations_cdp:567	BAURU	-22.2000008	-49	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	BRASIL	0101000020E610000000000000008048C000000040333336C0
829	stations_cdp:568	SAO CARLOS	-22	-47.5	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	BRASIL	0101000020E61000000000000000C047C000000000000036C0
830	stations_cdp:569	SAO LOURENCO	-22.1000004	-45	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	BRASIL	0101000020E610000000000000008046C0000000A0991936C0
831	stations_cdp:570	LONDRINA	-23.2000008	-51.0999985	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	BRASIL	0101000020E6100000000000C0CC8C49C000000040333337C0
832	stations_cdp:571	MARINGA	-23.2999992	-51.5999985	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	BRASIL	0101000020E6100000000000C0CCCC49C0000000C0CC4C37C0
833	stations_cdp:572	LONDRINA-AEROPORTO	-23.2000008	-51.0999985	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	BRASIL	0101000020E6100000000000C0CC8C49C000000040333337C0
834	stations_cdp:573	AVARE	-23.1000004	-48.5999985	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	BRASIL	0101000020E6100000000000C0CC4C48C0000000A0991937C0
835	stations_cdp:574	CAMPO DE MARTE	-23.2999992	-46.4000015	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	BRASIL	0101000020E610000000000040333347C0000000C0CC4C37C0
836	stations_cdp:575	SAO PAULO AEROPORTO	-23.3999996	-46.4000015	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	BRASIL	0101000020E610000000000040333347C000000060666637C0
837	stations_cdp:576	SAO PAULO	-23.2999992	-46.4000015	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	BRASIL	0101000020E610000000000040333347C0000000C0CC4C37C0
838	stations_cdp:577	CAMPO MOURAO	-24	-52.2000008	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	BRASIL	0101000020E6100000000000A099194AC000000000000038C0
839	stations_cdp:578	IVAI	-24.2000008	-50.5	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	BRASIL	0101000020E610000000000000004049C000000040333338C0
840	stations_cdp:579	CASTRO	-24.5	-50	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	BRASIL	0101000020E610000000000000000049C000000000008038C0
841	stations_cdp:580	FOZ DO IGUACU AEROPORTO	-25.2999992	-54.4000015	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	BRASIL	0101000020E61000000000004033334BC0000000C0CC4C39C0
842	stations_cdp:582	CURITIBA AEROPORTO	-25.2999992	-49.0999985	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	BRASIL	0101000020E6100000000000C0CC8C48C0000000C0CC4C39C0
843	stations_cdp:583	CURITIBA	-25.2999992	-49.2000008	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	BRASIL	0101000020E6100000000000A0999948C0000000C0CC4C39C0
844	stations_cdp:585	INDAIAL	-26.8999996	-49.2200012	0	\N	\N	\N	\N	\N	\N	\N	SANTACATARINA	\N	\N	BRASIL	0101000020E610000000000000299C48C00000006066E63AC0
845	stations_cdp:586	IRAI	-27.1800003	-53.2299995	0	\N	\N	\N	\N	\N	\N	\N	RIOGRANDEDOSUL	\N	\N	BRASIL	0101000020E6100000000000A0709D4AC000000080142E3BC0
846	stations_cdp:587	CHAPECO	-27.1200008	-52.6199989	0	\N	\N	\N	\N	\N	\N	\N	SANTACATARINA	\N	\N	BRASIL	0101000020E6100000000000205C4F4AC000000060B81E3BC0
847	stations_cdp:588	CAMPOS NOVOS	-27.3799992	-51.2000008	0	\N	\N	\N	\N	\N	\N	\N	SANTACATARINA	\N	\N	BRASIL	0101000020E6100000000000A0999949C0000000A047613BC0
848	stations_cdp:589	LAGES	-27.8199997	-50.3300018	0	\N	\N	\N	\N	\N	\N	\N	SANTACATARINA	\N	\N	BRASIL	0101000020E6100000000000803D2A49C000000080EBD13BC0
849	stations_cdp:590	SAO LUIZ GONZAGA	-28.3999996	-55.0200005	0	\N	\N	\N	\N	\N	\N	\N	RIOGRANDEDOSUL	\N	\N	BRASIL	0101000020E6100000000000608F824BC00000006066663CC0
850	stations_cdp:591	CRUZ ALTA	-28.6299992	-53.5999985	0	\N	\N	\N	\N	\N	\N	\N	RIOGRANDEDOSUL	\N	\N	BRASIL	0101000020E6100000000000C0CCCC4AC0000000A047A13CC0
851	stations_cdp:592	PASSO FUNDO	-28.2199993	-52.4000015	0	\N	\N	\N	\N	\N	\N	\N	RIOGRANDEDOSUL	\N	\N	BRASIL	0101000020E61000000000004033334AC0000000E051383CC0
852	stations_cdp:593	LAGOA VERMELHA	-28.1000004	-51.2999992	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	BRASIL	0101000020E61000000000006066A649C0000000A099193CC0
853	stations_cdp:594	BOM JESUS	-28.6700001	-50.4300003	0	\N	\N	\N	\N	\N	\N	\N	RIOGRANDEDOSUL	\N	\N	BRASIL	0101000020E6100000000000400A3749C00000002085AB3CC0
854	stations_cdp:595	S. JOAQUIM	-28.2999992	-49.9300003	0	\N	\N	\N	\N	\N	\N	\N	SANTACATARINA	\N	\N	BRASIL	0101000020E6100000000000400AF748C0000000C0CC4C3CC0
855	stations_cdp:596	URUGUAIANA	-29.75	-57.0800018	0	\N	\N	\N	\N	\N	\N	\N	RIOGRANDEDOSUL	\N	\N	BRASIL	0101000020E6100000000000803D8A4CC00000000000C03DC0
856	stations_cdp:597	URUGUAIANA AEROPORTO	-29.5	-57	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	BRASIL	0101000020E61000000000000000804CC00000000000803DC0
857	stations_cdp:598	SANTA MARIA	-29.7000008	-53.7000008	0	\N	\N	\N	\N	\N	\N	\N	RIOGRANDEDOSUL	\N	\N	BRASIL	0101000020E6100000000000A099D94AC00000004033B33DC0
858	stations_cdp:599	SANTA MARIA AEROPORTO	-29.3999996	-53.4000015	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	BRASIL	0101000020E61000000000004033B34AC00000006066663DC0
859	stations_cdp:600	SANTANA DO LIVRAMENTO	-30.5	-55.2999992	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	BRASIL	0101000020E61000000000006066A64BC00000000000803EC0
860	stations_cdp:601	BAGE	-31.3299999	-54.0999985	0	\N	\N	\N	\N	\N	\N	\N	RIOGRANDEDOSUL	\N	\N	BRASIL	0101000020E6100000000000C0CC0C4BC0000000E07A543FC0
861	stations_cdp:602	SAN MATIAS	-16.2000008	-58.2000008	0	\N	\N	\N	\N	\N	\N	\N	SANTACRUZ	\N	\N	BOLIVIA	0101000020E6100000000000A099194DC000000040333330C0
862	stations_cdp:603	SAN JOSE DE CHIQUITOS	-17.5	-60.5	0	\N	\N	\N	\N	\N	\N	\N	SANTACRUZ	\N	\N	BOLIVIA	0101000020E61000000000000000404EC000000000008031C0
863	stations_cdp:604	ROBORE	-18.2000008	-59.5	0	\N	\N	\N	\N	\N	\N	\N	SANTACRUZ	\N	\N	BOLIVIA	0101000020E61000000000000000C04DC000000040333332C0
864	stations_cdp:605	PUERTO SUAREZ	-19	-57.4000015	0	\N	\N	\N	\N	\N	\N	\N	SANTACRUZ	\N	\N	BOLIVIA	0101000020E61000000000004033B34CC000000000000033C0
865	stations_cdp:606	POTOSI	-19.2999992	-65.4000015	0	\N	\N	\N	\N	\N	\N	\N	POTOSÃ	\N	\N	BOLIVIA	0101000020E6100000000000A0995950C0000000C0CC4C33C0
866	stations_cdp:607	MONTEAGUDO	-19.5	-64	0	\N	\N	\N	\N	\N	\N	\N	MONTEAGUDO	\N	\N	BOLIVIA	0101000020E610000000000000000050C000000000008033C0
867	stations_cdp:608	CAMIRI	-20	-63.2999992	0	\N	\N	\N	\N	\N	\N	\N	SANTACRUZ	\N	\N	BOLIVIA	0101000020E61000000000006066A64FC000000000000034C0
868	stations_cdp:609	VILLA-MONTES	-21.2000008	-63.2999992	0	\N	\N	\N	\N	\N	\N	\N	TARIJA	\N	\N	BOLIVIA	0101000020E61000000000006066A64FC000000040333335C0
869	stations_cdp:610	TARIJA	-21.2999992	-64.4000015	0	\N	\N	\N	\N	\N	\N	\N	TARIJA	\N	\N	BOLIVIA	0101000020E6100000000000A0991950C0000000C0CC4C35C0
870	stations_cdp:611	YACUIBA	-22	-63.4000015	0	\N	\N	\N	\N	\N	\N	\N	TARIJA	\N	\N	BOLIVIA	0101000020E61000000000004033B34FC000000000000036C0
871	stations_cdp:612	BERMEJO	-22.5	-64.1999969	0	\N	\N	\N	\N	\N	\N	\N	TARIJA	\N	\N	BOLIVIA	0101000020E6100000000000C0CC0C50C000000000008036C0
872	stations_cdp:613	BASE 5 GRAL A. JARA	-19.2999992	-59.2000008	0	\N	\N	\N	\N	\N	\N	\N	ALTOPARAGUAY	\N	\N	PARAGUAY	0101000020E6100000000000A099994DC0000000C0CC4C33C0
873	stations_cdp:614	BAHIA NEGRA	-20.1000004	-58.0999985	0	\N	\N	\N	\N	\N	\N	\N	ALTOPARAGUAY	\N	\N	PARAGUAY	0101000020E6100000000000C0CC0C4DC0000000A0991934C0
874	stations_cdp:615	PRATTS GILL	-22.3999996	-61.2999992	0	\N	\N	\N	\N	\N	\N	\N	BOQUERÃN	\N	\N	PARAGUAY	0101000020E61000000000006066A64EC000000060666636C0
875	stations_cdp:616	MARISCAL ESTIGARRIBIA	-22	-60.4000015	0	\N	\N	\N	\N	\N	\N	\N	BOQUERÃN	\N	\N	PARAGUAY	0101000020E61000000000004033334EC000000000000036C0
876	stations_cdp:617	PUERTO CASADO	-22.2000008	-57.5	0	\N	\N	\N	\N	\N	\N	\N	ALTOPARAGUAY	\N	\N	PARAGUAY	0101000020E61000000000000000C04CC000000040333336C0
877	stations_cdp:618	PEDRO JUAN CABALLERO	-22.3999996	-55.4000015	0	\N	\N	\N	\N	\N	\N	\N	AMAMBAY	\N	\N	PARAGUAY	0101000020E61000000000004033B34BC000000060666636C0
878	stations_cdp:619	CONCEPCION	-23.2999992	-57.2000008	0	\N	\N	\N	\N	\N	\N	\N	CONCEPCIÃN	\N	\N	PARAGUAY	0101000020E6100000000000A099994CC0000000C0CC4C37C0
879	stations_cdp:620	GRAL. BRUGUEZ	-24.5	-58.5	0	\N	\N	\N	\N	\N	\N	\N	PRESIDENTEHAYES	\N	\N	PARAGUAY	0101000020E61000000000000000404DC000000000008038C0
880	stations_cdp:621	SAN PEDRO	-24	-57.0999985	0	\N	\N	\N	\N	\N	\N	\N	SANPEDRO	\N	\N	PARAGUAY	0101000020E6100000000000C0CC8C4CC000000000000038C0
881	stations_cdp:622	SAN ESTANISLAO	-24.3999996	-56.2999992	0	\N	\N	\N	\N	\N	\N	\N	SANPEDRO	\N	\N	PARAGUAY	0101000020E61000000000006066264CC000000060666638C0
882	stations_cdp:623	SALTOS DEL GUAIRA	-24	-54.2000008	0	\N	\N	\N	\N	\N	\N	\N	CANINDEYÃ?	\N	\N	PARAGUAY	0101000020E6100000000000A099194BC000000000000038C0
883	stations_cdp:624	ASUNCION-AEROPUERTO	-25.2000008	-57.4000015	0	\N	\N	\N	\N	\N	\N	\N	CENTRAL	\N	\N	PARAGUAY	0101000020E61000000000004033B34CC000000040333339C0
884	stations_cdp:625	VILLARRICA	-25.5	-56.2999992	0	\N	\N	\N	\N	\N	\N	\N	GUAIRÃ	\N	\N	PARAGUAY	0101000020E61000000000006066264CC000000000008039C0
885	stations_cdp:626	CORONEL OVIEDO	-25.2999992	-56.2000008	0	\N	\N	\N	\N	\N	\N	\N	CAAGUAZÃ	\N	\N	PARAGUAY	0101000020E6100000000000A099194CC0000000C0CC4C39C0
886	stations_cdp:627	GUARANI-AEROPUERTO	-25.2999992	-54.5	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	PARAGUAY	0101000020E61000000000000000404BC0000000C0CC4C39C0
887	stations_cdp:628	CIUDAD DEL ESTE	-25.2999992	-54.4000015	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	PARAGUAY	0101000020E61000000000004033334BC0000000C0CC4C39C0
888	stations_cdp:629	PILAR	-26.5	-58.2000008	0	\N	\N	\N	\N	\N	\N	\N	ÃEEMBUCÃ	\N	\N	PARAGUAY	0101000020E6100000000000A099194DC00000000000803AC0
889	stations_cdp:630	SAN JUAN BAUTISTA MISIONES	-26.3999996	-57.0999985	0	\N	\N	\N	\N	\N	\N	\N	MISIONES	\N	\N	PARAGUAY	0101000020E6100000000000C0CC8C4CC00000006066663AC0
890	stations_cdp:631	CAAZAPA	-26.1000004	-56.2000008	0	\N	\N	\N	\N	\N	\N	\N	CAAZAPÃ	\N	\N	PARAGUAY	0101000020E6100000000000A099194CC0000000A099193AC0
891	stations_cdp:632	CAPITAN MEZA	-26.5	-55.2000008	0	\N	\N	\N	\N	\N	\N	\N	ITAPÃA	\N	\N	PARAGUAY	0101000020E6100000000000A099994BC00000000000803AC0
892	stations_cdp:633	ITA-CORA	-27.1000004	-58.2000008	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	PARAGUAY	0101000020E6100000000000A099194DC0000000A099193BC0
893	stations_cdp:634	ENCARNACION	-27.2000008	-55.5	0	\N	\N	\N	\N	\N	\N	\N	MISIONES	\N	\N	PARAGUAY	0101000020E61000000000000000C04BC00000004033333BC0
894	stations_cdp:635	ARTIGAS	-30.3999996	-56.5099983	0	\N	\N	\N	\N	\N	\N	\N	ARTIGAS	\N	\N	URUGUAY	0101000020E6100000000000A047414CC00000006066663EC0
895	stations_cdp:636	RIVERA	-30.8999996	-55.5400009	0	\N	\N	\N	\N	\N	\N	\N	RIVERA	\N	\N	URUGUAY	0101000020E6100000000000C01EC54BC00000006066E63EC0
896	stations_cdp:637	SALTO	-31.4300003	-57.9799995	0	\N	\N	\N	\N	\N	\N	\N	SALTO	\N	\N	URUGUAY	0101000020E6100000000000A070FD4CC000000080146E3FC0
897	stations_cdp:638	TACUAREMBO	-31.7099991	-55.9900017	0	\N	\N	\N	\N	\N	\N	\N	TACUAREMBO	\N	\N	URUGUAY	0101000020E610000000000060B8FE4BC000000080C2B53FC0
898	stations_cdp:639	PAYSANDU	-32.3499985	-58.0400009	0	\N	\N	\N	\N	\N	\N	\N	PAYSANDU	\N	\N	URUGUAY	0101000020E6100000000000C01E054DC0000000C0CC2C40C0
899	stations_cdp:640	YOUNG	-32.6899986	-57.6500015	0	\N	\N	\N	\N	\N	\N	\N	RIONEGRO	\N	\N	URUGUAY	0101000020E61000000000004033D34CC0000000E0515840C0
900	stations_cdp:641	PASO DE LOS TOROS	-32.7999992	-56.5299988	0	\N	\N	\N	\N	\N	\N	\N	TACUAREMBO	\N	\N	URUGUAY	0101000020E610000000000000D7434CC000000060666640C0
901	stations_cdp:642	MERCEDES	-33.25	-58.0699997	0	\N	\N	\N	\N	\N	\N	\N	SORIANO	\N	\N	URUGUAY	0101000020E6100000000000C0F5084DC00000000000A040C0
902	stations_cdp:643	TREINTA Y TRES	-33.0999985	-54.2000008	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	URUGUAY	0101000020E6100000000000A099194BC0000000C0CC8C40C0
903	stations_cdp:644	DURAZNO	-33.3499985	-56.5	0	\N	\N	\N	\N	\N	\N	\N	DURAZNO	\N	\N	URUGUAY	0101000020E61000000000000000404CC0000000C0CCAC40C0
904	stations_cdp:645	FLORIDA	-34.0900002	-56.2400017	0	\N	\N	\N	\N	\N	\N	\N	FLORIDA	\N	\N	URUGUAY	0101000020E610000000000060B81E4CC000000020850B41C0
905	stations_cdp:646	COLONIA	-34.4500008	-57.7700005	0	\N	\N	\N	\N	\N	\N	\N	COLONIA	\N	\N	URUGUAY	0101000020E6100000000000608FE24CC0000000A0993941C0
906	stations_cdp:647	ROCHA	-34.2999992	-54.2000008	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	URUGUAY	0101000020E6100000000000A099194BC000000060662641C0
907	stations_cdp:648	MELILLA	-34.5	-56.2000008	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	URUGUAY	0101000020E6100000000000A099194CC000000000004041C0
908	stations_cdp:649	CARRASCO	-34.5	-56	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	URUGUAY	0101000020E61000000000000000004CC000000000004041C0
909	stations_cdp:650	EL PRADO	-34.5	-56.0999985	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	URUGUAY	0101000020E6100000000000C0CC0C4CC000000000004041C0
910	stations_cdp:651	PUNTA DEL ESTE	-34.5999985	-54.5999985	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	URUGUAY	0101000020E6100000000000C0CC4C4BC0000000C0CC4C41C0
911	stations_cdp:652	AEROPUERTO GUARANY	-25.4500008	-54.8499985	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	Unknown	0101000020E6100000000000C0CC6C4BC000000040337339C0
912	stations_cdp:653	AGUA CLARA	-20.4500008	-52.8800011	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	Unknown	0101000020E6100000000000E0A3704AC000000040337334C0
913	stations_cdp:654	ANAPOLIS (BRAZ-AFB)	-16.2299995	-48.9700012	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	Unknown	0101000020E610000000000000297C48C000000040E13A30C0
914	stations_cdp:655	BAGE/CMDT KRAEMER	-31.3500004	-54.1199989	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	Unknown	0101000020E6100000000000205C0F4BC0000000A099593FC0
915	stations_cdp:656	BELLA UNION	-30.2700005	-57.5900002	0	\N	\N	\N	\N	\N	\N	\N	ARTIGAS	\N	\N	URUGUAY	0101000020E61000000000002085CB4CC0000000C01E453EC0
916	stations_cdp:657	CAPITAN CORBETA	-34.8699989	-55.0999985	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	Unknown	0101000020E6100000000000C0CC8C4BC0000000205C6F41C0
917	stations_cdp:658	CNEL. BRUGUEZ	-24.75	-58.75	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	Unknown	0101000020E61000000000000000604DC00000000000C038C0
918	stations_cdp:659	COXIM	-18.5	-54.7700005	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	Unknown	0101000020E6100000000000608F624BC000000000008032C0
919	stations_cdp:660	CUIABA/MARECHAL RON	-15.6499996	-56.0999985	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	Unknown	0101000020E6100000000000C0CC0C4CC0000000C0CC4C2FC0
920	stations_cdp:661	GAMA	-16.0499992	-48.0499992	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	Unknown	0101000020E610000000000060660648C0000000C0CC0C30C0
921	stations_cdp:662	GOIANIA/SANTA GENOV	-16.6299992	-49.2200012	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	Unknown	0101000020E610000000000000299C48C0000000A047A130C0
922	stations_cdp:663	GUAIRA	-24.0799999	-54.25	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	Unknown	0101000020E61000000000000000204BC0000000E07A1438C0
923	stations_cdp:664	ITAPEVA	-23.9500008	-48.8800011	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	Unknown	0101000020E6100000000000E0A37048C00000004033F337C0
924	stations_cdp:665	LEITE LOPES/RIBEIR&	-21.1299992	-47.7799988	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	Unknown	0101000020E610000000000000D7E347C0000000A0472135C0
925	stations_cdp:666	MARTE (CIV/MIL)   &	-23.5200005	-46.6300011	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	Unknown	0101000020E6100000000000E0A35047C0000000C01E8537C0
926	stations_cdp:667	NUEVA ASUNCION	-20.7199993	-61.9199982	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	Unknown	0101000020E610000000000080C2F54EC0000000E051B834C0
927	stations_cdp:668	PALMAS	-26.4799995	-51.9799995	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	Unknown	0101000020E6100000000000A070FD49C000000040E17A3AC0
928	stations_cdp:669	POCOS DE CALDAS	-21.8500004	-46.5699997	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	Unknown	0101000020E6100000000000C0F54847C0000000A099D935C0
929	stations_cdp:670	SAO MIGUEL IGUACU	-25.3299999	-54.25	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	Unknown	0101000020E61000000000000000204BC0000000E07A5439C0
930	stations_cdp:671	TOLEDO	-24.7299995	-53.7299995	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	Unknown	0101000020E6100000000000A070DD4AC000000040E1BA38C0
931	stations_cdp:672	UBERLANDIA	-18.8799992	-48.2299995	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	Unknown	0101000020E6100000000000A0701D48C0000000A047E132C0
932	stations_cdp:673	VACARIA	-28.5499992	-50.9300003	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	Unknown	0101000020E6100000000000400A7749C0000000C0CC8C3CC0
933	stations_cdp:675	PARAGUARI	-25.3799992	-57.0800018	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	Unknown	0101000020E6100000000000803D8A4CC0000000A0476139C0
934	stations_cdp:676	QUYQUYHAT	-26.1299992	-56.5900002	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	Unknown	0101000020E610000000000020854B4CC0000000A047213AC0
1051	alturas_bdhi:147	Cachi	-25.1233311	-66.1566696	0	\N	\N	\N	\N	\N	\N	\N	SALTA	\N	\N	ARGENTINA	0101000020E6100000000000E0068A50C0000000A0921F39C0
935	stations_cdp:677	VIVERO FORESTAL	-25.3099995	-54.4700012	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	Unknown	0101000020E610000000000000293C4BC0000000205C4F39C0
936	stations_cdp:678	QUIINDY	-25.9699993	-57.2400017	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	Unknown	0101000020E610000000000060B89E4CC0000000E051F839C0
937	stations_cdp:679	POZO COLORADO	-23.2299995	-57.5600014	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	Unknown	0101000020E610000000000020AEC74CC000000040E13A37C0
938	stations_cdp:680	ASUNCION-SAJONIA	-25	-57	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	Unknown	0101000020E61000000000000000804CC000000000000039C0
939	stations_cdp:681	CARAPEGUA	-25.4799995	-57.1300011	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	Unknown	0101000020E6100000000000E0A3904CC000000040E17A39C0
940	stations_cdp:682	Melo	-32.3699989	-54.1899986	0	\N	\N	\N	\N	\N	\N	\N	CERROLARGO	\N	\N	URUGUAY	0101000020E6100000000000E051184BC0000000205C2F40C0
941	stations_cdp:683	Caxias do Sul	-29.1700001	-51.2000008	0	\N	\N	\N	\N	\N	\N	\N	RIOGRANDEDOSUL	\N	\N	BRASIL	0101000020E6100000000000A0999949C000000020852B3DC0
942	stations_cdp:684	Encruzilhada do Sul	-30.5300007	-52.5200005	0	\N	\N	\N	\N	\N	\N	\N	RIOGRANDEDOSUL	\N	\N	BRASIL	0101000020E6100000000000608F424AC000000020AE873EC0
943	stations_cdp:685	Florianopolis	-27.5799999	-48.5699997	0	\N	\N	\N	\N	\N	\N	\N	SANTACATARINA	\N	\N	BRASIL	0101000020E6100000000000C0F54848C0000000E07A943BC0
944	stations_cdp:686	Porto Alegre	-30.0499992	-51.1699982	0	\N	\N	\N	\N	\N	\N	\N	RIOGRANDEDOSUL	\N	\N	BRASIL	0101000020E610000000000080C29549C0000000C0CC0C3EC0
945	stations_cdp:687	Torres	-29.3500004	-49.7200012	0	\N	\N	\N	\N	\N	\N	\N	RIOGRANDEDOSUL	\N	\N	BRASIL	0101000020E61000000000000029DC48C0000000A099593DC0
946	stations_cdp:688	AimorÃ©s	-19.4799995	-41.0699997	0	\N	\N	\N	\N	\N	\N	\N	MINASGERAIS	\N	\N	BRASIL	0101000020E6100000000000C0F58844C000000040E17A33C0
947	stations_cdp:689	AragarÃ§as	-15.8999996	-52.2299995	0	\N	\N	\N	\N	\N	\N	\N	GOIÃS	\N	\N	BRASIL	0101000020E6100000000000A0701D4AC0000000C0CCCC2FC0
948	stations_cdp:690	BambuÃ­	-20.0300007	-46	0	\N	\N	\N	\N	\N	\N	\N	MINASGERAIS	\N	\N	BRASIL	0101000020E610000000000000000047C000000020AE0734C0
949	stations_cdp:691	Belo Horizonte	-19.9300003	-43.9300003	0	\N	\N	\N	\N	\N	\N	\N	MINASGERAIS	\N	\N	BRASIL	0101000020E6100000000000400AF745C00000008014EE33C0
950	stations_cdp:692	CaparaÃ³	-20.5200005	-41.9000015	0	\N	\N	\N	\N	\N	\N	\N	MINASGERAIS	\N	\N	BRASIL	0101000020E61000000000004033F344C0000000C01E8534C0
951	stations_cdp:693	Caravelas	-17.7299995	-39.25	0	\N	\N	\N	\N	\N	\N	\N	BAHIA	\N	\N	BRASIL	0101000020E61000000000000000A043C000000040E1BA31C0
952	stations_cdp:694	ConceiÃ§Ã£o do Mato Dentro	-19.0200005	-43.4300003	0	\N	\N	\N	\N	\N	\N	\N	MINASGERAIS	\N	\N	BRASIL	0101000020E6100000000000400AB745C0000000C01E0533C0
953	stations_cdp:695	Diamantina	-18.25	-43.5999985	0	\N	\N	\N	\N	\N	\N	\N	MINASGERAIS	\N	\N	BRASIL	0101000020E6100000000000C0CCCC45C000000000004032C0
954	stations_cdp:696	Formosa	-15.5299997	-47.3300018	0	\N	\N	\N	\N	\N	\N	\N	GOIÃS	\N	\N	BRASIL	0101000020E6100000000000803DAA47C0000000205C0F2FC0
955	stations_cdp:697	Gleba Celeste	-12.1999998	-56.5	0	\N	\N	\N	\N	\N	\N	\N	MATOGROSSO	\N	\N	BRASIL	0101000020E61000000000000000404CC000000060666628C0
956	stations_cdp:698	GoiÃ¡s	-15.9200001	-50.1300011	0	\N	\N	\N	\N	\N	\N	\N	GOIÃS	\N	\N	BRASIL	0101000020E6100000000000E0A31049C0000000400AD72FC0
957	stations_cdp:699	Iguape	-24.7199993	-47.5499992	0	\N	\N	\N	\N	\N	\N	\N	SÃOPAULO	\N	\N	BRASIL	0101000020E61000000000006066C647C0000000E051B838C0
958	alturas_dinac:162	Vallemi	-22.1578293	-57.9576454	0	\N	\N	\N	\N	\N	\N	\N	PARAGUAY	\N	\N	PARAGUAY	0101000020E61000000000002094FA4CC000000080672836C0
959	stations_cdp:700	Itamarandiba	-17.8500004	-42.8499985	0	\N	\N	\N	\N	\N	\N	\N	MINASGERAIS	\N	\N	BRASIL	0101000020E6100000000000C0CC6C45C0000000A099D931C0
960	stations_cdp:701	JoÃ£o Pinheiro	-17.7000008	-46.1699982	0	\N	\N	\N	\N	\N	\N	\N	MINASGERAIS	\N	\N	BRASIL	0101000020E610000000000080C21547C00000004033B331C0
961	stations_cdp:702	Juiz de Fora	-21.7700005	-43.3499985	0	\N	\N	\N	\N	\N	\N	\N	MINASGERAIS	\N	\N	BRASIL	0101000020E6100000000000C0CCAC45C0000000C01EC535C0
962	stations_cdp:703	Paracatu	-17.2299995	-46.8800011	0	\N	\N	\N	\N	\N	\N	\N	MINASGERAIS	\N	\N	BRASIL	0101000020E6100000000000E0A37047C000000040E13A31C0
963	stations_cdp:704	ParanaguÃ¡	-25.5300007	-48.5200005	0	\N	\N	\N	\N	\N	\N	\N	PARANÃ	\N	\N	BRASIL	0101000020E6100000000000608F4248C000000020AE8739C0
964	stations_cdp:705	Pirapora	-17.3500004	-44.9199982	0	\N	\N	\N	\N	\N	\N	\N	MINASGERAIS	\N	\N	BRASIL	0101000020E610000000000080C27546C0000000A0995931C0
965	stations_cdp:706	Pompeu	-19.2199993	-45	0	\N	\N	\N	\N	\N	\N	\N	MINASGERAIS	\N	\N	BRASIL	0101000020E610000000000000008046C0000000E0513833C0
966	stations_cdp:707	Ponta PorÃ£	-22.5300007	-55.5299988	0	\N	\N	\N	\N	\N	\N	\N	MATOGROSSODOSUL	\N	\N	BRASIL	0101000020E610000000000000D7C34BC000000020AE8736C0
967	stations_cdp:708	Posse	-14.1000004	-46.3699989	0	\N	\N	\N	\N	\N	\N	\N	GOIÃS	\N	\N	BRASIL	0101000020E6100000000000205C2F47C00000004033332CC0
968	stations_cdp:709	Rio Grande	-32.0299988	-52.0999985	0	\N	\N	\N	\N	\N	\N	\N	RIOGRANDEDOSUL	\N	\N	BRASIL	0101000020E6100000000000C0CC0C4AC000000000D70340C0
969	stations_cdp:710	Santa VitÃ³ria do Palmar	-33.5200005	-53.3499985	0	\N	\N	\N	\N	\N	\N	\N	RIOGRANDEDOSUL	\N	\N	BRASIL	0101000020E6100000000000C0CCAC4AC0000000608FC240C0
970	stations_cdp:711	Sete Lagoas	-19.4699993	-44.25	0	\N	\N	\N	\N	\N	\N	\N	MINASGERAIS	\N	\N	BRASIL	0101000020E610000000000000002046C0000000E0517833C0
971	stations_cdp:712	TeÃ³filo Otoni	-17.8500004	-41.5	0	\N	\N	\N	\N	\N	\N	\N	MINASGERAIS	\N	\N	BRASIL	0101000020E61000000000000000C044C0000000A099D931C0
972	stations_cdp:713	Ubatuba	-23.4500008	-45.0699997	0	\N	\N	\N	\N	\N	\N	\N	SÃOPAULO	\N	\N	BRASIL	0101000020E6100000000000C0F58846C000000040337337C0
973	stations_cdp:714	ViÃ§osa	-20.75	-42.8499985	0	\N	\N	\N	\N	\N	\N	\N	MINASGERAIS	\N	\N	BRASIL	0101000020E6100000000000C0CC6C45C00000000000C034C0
974	stations_cdp:715	AscenciÃ³n de Guarayos - Aerop	-15.9200001	-63.1699982	0	\N	\N	\N	\N	\N	\N	\N	SANTACRUZ	\N	\N	BOLIVIA	0101000020E610000000000080C2954FC0000000400AD72FC0
975	stations_cdp:716	Cochabamba - Aeropuerto	-17.4200001	-66.1699982	0	\N	\N	\N	\N	\N	\N	\N	COCHABAMBA	\N	\N	BOLIVIA	0101000020E610000000000040E18A50C000000020856B31C0
976	stations_cdp:717	ConcepciÃ³n - Aeropuerto	-16.1399994	-62.0299988	0	\N	\N	\N	\N	\N	\N	\N	SANTACRUZ	\N	\N	BOLIVIA	0101000020E610000000000000D7034FC000000000D72330C0
977	stations_cdp:718	El Alto - Aeropuerto	-16.5100002	-68.1999969	0	\N	\N	\N	\N	\N	\N	\N	LAPAZ	\N	\N	BOLIVIA	0101000020E6100000000000C0CC0C51C0000000608F8230C0
978	stations_cdp:719	El Trompillo - Aeropuerto	-17.8099995	-63.1800003	0	\N	\N	\N	\N	\N	\N	\N	SANTACRUZ	\N	\N	BOLIVIA	0101000020E6100000000000400A974FC0000000205CCF31C0
979	stations_cdp:720	Guayaramerin - Aeropuerto	-10.8199997	-65.3499985	0	\N	\N	\N	\N	\N	\N	\N	BENI	\N	\N	BOLIVIA	0101000020E610000000000060665650C000000000D7A325C0
980	stations_cdp:721	Magdalena - Aeropuerto	-13.2600002	-64.0599976	0	\N	\N	\N	\N	\N	\N	\N	BENI	\N	\N	BOLIVIA	0101000020E610000000000000D70350C0000000C01E852AC0
981	stations_cdp:722	Oruro - Aeropuerto	-17.9500008	-67.0800018	0	\N	\N	\N	\N	\N	\N	\N	ORURO	\N	\N	BOLIVIA	0101000020E6100000000000C01EC550C00000004033F331C0
982	stations_cdp:723	Reyes	-14.3000002	-67.3499985	0	\N	\N	\N	\N	\N	\N	\N	BENI	\N	\N	BOLIVIA	0101000020E61000000000006066D650C0000000A099992CC0
983	stations_cdp:724	Riberalta - Aeropuerto	-11.0100002	-66.0800018	0	\N	\N	\N	\N	\N	\N	\N	BENI	\N	\N	BOLIVIA	0101000020E6100000000000C01E8550C0000000C01E0526C0
984	stations_cdp:725	Rurrenabaque - Aeropuerto	-14.4300003	-67.5	0	\N	\N	\N	\N	\N	\N	\N	BENI	\N	\N	BOLIVIA	0101000020E61000000000000000E050C00000000029DC2CC0
985	stations_cdp:726	San Borja - Aeropuerto	-14.8599997	-66.7399979	0	\N	\N	\N	\N	\N	\N	\N	BENI	\N	\N	BOLIVIA	0101000020E6100000000000205CAF50C0000000E051B82DC0
986	stations_cdp:727	San Ignacio de Moxos - Aerop	-14.9700003	-65.6299973	0	\N	\N	\N	\N	\N	\N	\N	BENI	\N	\N	BOLIVIA	0101000020E6100000000000E0516850C0000000E0A3F02DC0
987	stations_cdp:728	San Ignacio de Velasco - Aerop	-16.3799992	-60.9599991	0	\N	\N	\N	\N	\N	\N	\N	SANTACRUZ	\N	\N	BOLIVIA	0101000020E610000000000040E17A4EC0000000A0476130C0
988	stations_cdp:729	San Javier - Aeropuerto	-16.2700005	-62.4700012	0	\N	\N	\N	\N	\N	\N	\N	SANTACRUZ	\N	\N	BOLIVIA	0101000020E610000000000000293C4FC0000000C01E4530C0
989	stations_cdp:730	San Joaquin - Aeropuerto	-13.0500002	-64.6699982	0	\N	\N	\N	\N	\N	\N	\N	BENI	\N	\N	BOLIVIA	0101000020E610000000000040E12A50C0000000A099192AC0
990	stations_cdp:731	San Ramon - Aeropuerto	-13.2600002	-64.6100006	0	\N	\N	\N	\N	\N	\N	\N	BENI	\N	\N	BOLIVIA	0101000020E6100000000000400A2750C0000000C01E852AC0
991	stations_cdp:732	Santa Ana de Yacuma - Aerop	-13.7600002	-65.4300003	0	\N	\N	\N	\N	\N	\N	\N	BENI	\N	\N	BOLIVIA	0101000020E610000000000020855B50C0000000C01E852BC0
992	stations_cdp:733	Sucre - Aeropuerto	-19.0200005	-65.2900009	0	\N	\N	\N	\N	\N	\N	\N	SUCRE	\N	\N	BOLIVIA	0101000020E6100000000000608F5250C0000000C01E0533C0
993	stations_cdp:734	Trinidad - Aeropuerto	-14.8199997	-64.9199982	0	\N	\N	\N	\N	\N	\N	\N	BENI	\N	\N	BOLIVIA	0101000020E610000000000040E13A50C000000000D7A32DC0
994	stations_cdp:735	Valle Grande - Aeropuerto	-18.4799995	-64.1100006	0	\N	\N	\N	\N	\N	\N	\N	SANTACRUZ	\N	\N	BOLIVIA	0101000020E6100000000000400A0750C000000040E17A32C0
995	stations_cdp:736	Viru Viru - Aeropuerto	-17.6499996	-63.1399994	0	\N	\N	\N	\N	\N	\N	\N	SANTACRUZ	\N	\N	BOLIVIA	0101000020E610000000000080EB914FC00000006066A631C0
996	stations_cdp:737	Balmaceda Ad.	-45.9099998	-71.6900024	0	\N	\N	\N	\N	\N	\N	\N	MAGALLANESYDELAANTÃRTICACHILENA	\N	\N	CHILE	0101000020E61000000000000029EC51C0000000E07AF446C0
997	stations_cdp:742	Cerro Moreno Antofagasta Ap.	-23.4500008	-70.4400024	0	\N	\N	\N	\N	\N	\N	\N	ANTOFAGASTA	\N	\N	CHILE	0101000020E610000000000000299C51C000000040337337C0
998	stations_cdp:744	Chile Chico Ad.	-46.5800018	-71.6900024	0	\N	\N	\N	\N	\N	\N	\N	AISÃNDELGRAL.CARLOSIBÃÃEZDELCAMPO	\N	\N	CHILE	0101000020E61000000000000029EC51C0000000803D4A47C0
999	stations_cdp:746	Diego Aracena Iquique Ap.	-20.5400009	-70.1800003	0	\N	\N	\N	\N	\N	\N	\N	TARAPACA	\N	\N	CHILE	0101000020E610000000000020858B51C0000000803D8A34C0
1000	stations_cdp:748	El Paico	-33.7099991	-71.0100021	0	\N	\N	\N	\N	\N	\N	\N	METROPOLITANADESANTIAGO	\N	\N	CHILE	0101000020E6100000000000E0A3C051C000000040E1DA40C0
1001	stations_cdp:749	El Tepual Puerto Montt Ap.	-41.4399986	-73.0999985	0	\N	\N	\N	\N	\N	\N	\N	DELOSLAGOS	\N	\N	CHILE	0101000020E610000000000060664652C0000000E051B844C0
1002	stations_cdp:751	FutaleufÃº Ad.	-43.1899986	-71.8499985	0	\N	\N	\N	\N	\N	\N	\N	DELOSLAGOS	\N	\N	CHILE	0101000020E61000000000006066F651C0000000E0519845C0
1003	stations_cdp:755	Lo Prado Cerro San Francisco	-33.4599991	-70.9499969	0	\N	\N	\N	\N	\N	\N	\N	METROPOLITANADESANTIAGO	\N	\N	CHILE	0101000020E6100000000000C0CCBC51C000000040E1BA40C0
1004	stations_cdp:756	Lord Cochrane Ad.	-47.2400017	-72.5899963	0	\N	\N	\N	\N	\N	\N	\N	AISÃNDELGRAL.CARLOSIBÃÃEZDELCAMPO	\N	\N	CHILE	0101000020E610000000000080C22552C000000060B89E47C0
1005	stations_cdp:759	Pudahuel Santiago	-33.3899994	-70.7900009	0	\N	\N	\N	\N	\N	\N	\N	METROPOLITANADESANTIAGO	\N	\N	CHILE	0101000020E6100000000000608FB251C000000080EBB140C0
1006	stations_cdp:760	Puerto AysÃ©n Ad.	-45.4000015	-72.6600037	0	\N	\N	\N	\N	\N	\N	\N	AISÃNDELGRAL.CARLOSIBÃÃEZDELCAMPO	\N	\N	CHILE	0101000020E6100000000000803D2A52C00000004033B346C0
1007	stations_cdp:761	QuellÃ³n Ad.	-43.1300011	-73.6299973	0	\N	\N	\N	\N	\N	\N	\N	DELOSLAGOS	\N	\N	CHILE	0101000020E6100000000000E0516852C0000000E0A39045C0
1008	stations_cdp:763	San JosÃ© GuayacÃ¡n	-33.6199989	-70.3499985	0	\N	\N	\N	\N	\N	\N	\N	METROPOLITANADESANTIAGO	\N	\N	CHILE	0101000020E610000000000060669651C0000000205CCF40C0
1009	stations_cdp:765	Taltal Campbell	-25.4099998	-70.4800034	0	\N	\N	\N	\N	\N	\N	\N	ANTOFAGASTA	\N	\N	CHILE	0101000020E610000000000060B89E51C0000000C0F56839C0
1010	stations_cdp:768	Toconao	-23.1900005	-68.0100021	0	\N	\N	\N	\N	\N	\N	\N	ANTOFAGASTA	\N	\N	CHILE	0101000020E6100000000000E0A30051C0000000E0A33037C0
1011	estaciones_salto_grande:1073	MocoretÃ¡ Lago	-30.6903076	-57.8207207	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	Unknown	0101000020E6100000000000600DE94CC000000000B8B03EC0
1012	estaciones_salto_grande:1074	Monte Caseros	-30.2492962	-57.6225204	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	Unknown	0101000020E6100000000000C0AECF4CC0000000E0D13F3EC0
1013	estaciones_salto_grande:1075	Pujol	-30.3902588	-57.8809853	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	Unknown	0101000020E610000000000020C4F04CC000000000E8633EC0
1014	estaciones_salto_grande:1076	Arapey Grande Ruta 4	-31.2310982	-57.0970993	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	Unknown	0101000020E6100000000000C06D8C4CC000000040293B3FC0
1015	estaciones_salto_grande:1077	MocoretÃ¡ RÃ­o	-30.6267719	-57.9828377	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	Unknown	0101000020E6100000000000A0CDFD4CC00000002074A03EC0
1016	estaciones_salto_grande:1078	Bonpland	-29.8195171	-57.4298134	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	Unknown	0101000020E61000000000002004B74CC0000000E0CBD13DC0
1017	emas:923	parana	-31.7219448	-60.5308342	0	\N	\N	\N	\N	\N	\N	\N	ENTRERIOS	\N	\N	ARGENTINA	0101000020E610000000000060F2434EC000000060D1B83FC0
1018	emas:913	feliciano	-30.3758297	-58.7543983	0	\N	\N	\N	\N	\N	\N	\N	ENTRERIOS	\N	\N	ARGENTINA	0101000020E61000000000002090604DC00000006036603EC0
1019	emas:924	villaelisa	-32.1669998	-58.4000015	0	\N	\N	\N	\N	\N	\N	\N	ENTRERIOS	\N	\N	ARGENTINA	0101000020E61000000000004033334DC000000040601540C0
1020	emas:925	sjdelafrontera	-30.3570004	-58.3149986	0	\N	\N	\N	\N	\N	\N	\N	ENTRERIOS	\N	\N	ARGENTINA	0101000020E6100000000000E051284DC000000060645B3EC0
1021	emas:926	cuchilla	-33.1969986	-59.2599983	0	\N	\N	\N	\N	\N	\N	\N	ENTRERIOS	\N	\N	ARGENTINA	0101000020E6100000000000A047A14DC000000040379940C0
1022	emas:927	colon	-32.226162	-58.1459427	0	\N	\N	\N	\N	\N	\N	\N	ENTRERIOS	\N	\N	ARGENTINA	0101000020E610000000000040AE124DC0000000E0F21C40C0
1023	emas:928	concepciondeluruguay	-32.5	-58.2999992	0	\N	\N	\N	\N	\N	\N	\N	ENTRERIOS	\N	\N	ARGENTINA	0101000020E61000000000006066264DC000000000004040C0
1024	emas:929	gualeguaychu	-33.0144463	-58.5041656	0	\N	\N	\N	\N	\N	\N	\N	ENTRERIOS	\N	\N	ARGENTINA	0101000020E61000000000008088404DC000000060D98140C0
1025	emas:911	sansalvador	-31.6222191	-58.5247192	0	\N	\N	\N	\N	\N	\N	\N	ENTRERIOS	\N	\N	ARGENTINA	0101000020E6100000000000002A434DC0000000C0499F3FC0
1026	emas:931	basavilbaso	-32.373333	-58.8866653	0	\N	\N	\N	\N	\N	\N	\N	ENTRERIOS	\N	\N	ARGENTINA	0101000020E6100000000000407E714DC000000060C92F40C0
1027	alturas_dinac:173	Villa Florida - Misiones	-26.4025555	-57.1283684	0	\N	\N	\N	\N	\N	\N	\N	PARAGUAY	\N	\N	PARAGUAY	0101000020E6100000000000606E904CC0000000E00D673AC0
1028	lujan_api:933	Rio Lujan - Puente Jauregui	-34.5894432	-59.1783333	0	\N	\N	\N	\N	\N	\N	\N	BUENOSAIRES	\N	\N	Argentina	0101000020E6100000000000A0D3964DC0000000E0724B41C0
1029	alturas_bdhi:1	Ruta Provincial nÂº 39	-32.4451675	-58.5548897	0	\N	\N	\N	\N	\N	\N	\N	ENTRERIOS	\N	\N	ARGENTINA	0101000020E6100000000000A006474DC000000040FB3840C0
1030	alturas_bdhi:119	Paso JuncuÃ©	-30.361639	-59.2586937	0	\N	\N	\N	\N	\N	\N	\N	ENTRERIOS	\N	\N	ARGENTINA	0101000020E6100000000000E01CA14DC000000060945C3EC0
1031	alturas_bdhi:121	Los Laureles	-29.7571106	-59.2171669	0	\N	\N	\N	\N	\N	\N	\N	CORRIENTES	\N	\N	ARGENTINA	0101000020E610000000000020CC9B4DC000000000D2C13DC0
1032	alturas_bdhi:122	Ruta Nacional nÂº 168	-31.6611385	-60.6020546	0	\N	\N	\N	\N	\N	\N	\N	SANTAFE	\N	\N	ARGENTINA	0101000020E610000000000020104D4EC00000006040A93FC0
1033	alturas_bdhi:123	Autopista	-32.0182228	-60.9895554	0	\N	\N	\N	\N	\N	\N	\N	SANTAFE	\N	\N	ARGENTINA	0101000020E6100000000000C0A97E4EC000000020550240C0
1034	alturas_bdhi:124	Autopista	-33.0272217	-60.6635551	0	\N	\N	\N	\N	\N	\N	\N	SANTAFE	\N	\N	ARGENTINA	0101000020E610000000000060EF544EC0000000007C8340C0
1035	alturas_bdhi:125	Ruta Provincial nÂº62	-31.1507778	-60.4043884	0	\N	\N	\N	\N	\N	\N	\N	SANTAFE	\N	\N	ARGENTINA	0101000020E610000000000000C3334EC00000006099263FC0
1036	alturas_bdhi:126	Ruta Provincial nÂº32	-28.4912224	-59.3879433	0	\N	\N	\N	\N	\N	\N	\N	SANTAFE	\N	\N	ARGENTINA	0101000020E610000000000020A8B14DC0000000C0C07D3CC0
1037	alturas_bdhi:129	Resistencia	-27.4397221	-59	0	\N	\N	\N	\N	\N	\N	\N	CHACO	\N	\N	ARGENTINA	0101000020E61000000000000000804DC0000000A091703BC0
1038	alturas_bdhi:130	Paso Ledesma	-29.8459167	-57.6751099	0	\N	\N	\N	\N	\N	\N	\N	CORRIENTES	\N	\N	ARGENTINA	0101000020E6100000000000006AD64CC0000000008ED83DC0
1039	alturas_bdhi:174	San Justo - Ruta Provincial nÂº 2	-30.7468052	-60.6241722	0	\N	\N	\N	\N	\N	\N	\N	SANTAFE	\N	\N	ARGENTINA	0101000020E6100000000000E0E44F4EC0000000A02EBF3EC0
1040	alturas_bdhi:133	La Emilia	-33.3488312	-60.3213043	0	\N	\N	\N	\N	\N	\N	\N	SANTAFE	\N	\N	ARGENTINA	0101000020E61000000000008020294EC000000080A6AC40C0
1041	alturas_bdhi:134	Ruta Nacional nÂº 12	-28.1141663	-58.8086128	0	\N	\N	\N	\N	\N	\N	\N	CORRIENTES	\N	\N	ARGENTINA	0101000020E6100000000000A080674DC0000000003A1D3CC0
1042	alturas_bdhi:135	Autopista	-32.393055	-60.9411125	0	\N	\N	\N	\N	\N	\N	\N	SANTAFE	\N	\N	ARGENTINA	0101000020E61000000000006076784EC0000000A04F3240C0
1043	alturas_bdhi:136	Ruta Nacional nÂº 11	-29.2786102	-59.7855568	0	\N	\N	\N	\N	\N	\N	\N	SANTAFE	\N	\N	ARGENTINA	0101000020E6100000000000208DE44DC00000000053473DC0
1044	alturas_bdhi:137	Florencia	-28.0288887	-58.2249985	0	\N	\N	\N	\N	\N	\N	\N	SANTAFE	\N	\N	ARGENTINA	0101000020E6100000000000C0CC1C4DC00000004065073CC0
1045	alturas_bdhi:175	Emilia - Ruta Provincial nÂº 62	-31.0429993	-60.8409996	0	\N	\N	\N	\N	\N	\N	\N	SANTAFE	\N	\N	ARGENTINA	0101000020E6100000000000E0A56B4EC000000000020B3FC0
1046	alturas_bdhi:139	Ruta Provincial nÂº 18	-33.0292511	-60.6820259	0	\N	\N	\N	\N	\N	\N	\N	SANTAFE	\N	\N	ARGENTINA	0101000020E6100000000000A04C574EC000000080BE8340C0
1047	alturas_bdhi:140	Cnel. Bogado	-33.3605537	-60.5760574	0	\N	\N	\N	\N	\N	\N	\N	SANTAFE	\N	\N	ARGENTINA	0101000020E610000000000040BC494EC0000000A026AE40C0
1048	alturas_bdhi:143	Bell Ville	-32.6166687	-62.6833305	0	\N	\N	\N	\N	\N	\N	\N	CORDOBA	\N	\N	ARGENTINA	0101000020E61000000000006077574FC000000000EF4E40C0
1049	alturas_bdhi:144	Cruz Alta	-32.9166718	-61.8833313	0	\N	\N	\N	\N	\N	\N	\N	CORDOBA	\N	\N	ARGENTINA	0101000020E61000000000000011F14EC000000080557540C0
1050	alturas_bdhi:146	Roque Perez	-35.372612	-59.2805023	0	\N	\N	\N	\N	\N	\N	\N	BUENOSAIRES	\N	\N	ARGENTINA	0101000020E610000000000080E7A34DC0000000C0B1AF41C0
1052	alturas_bdhi:151	Atucha	-33.9630737	-59.2052879	0	\N	\N	\N	\N	\N	\N	\N	BUENOSAIRES	\N	\N	ARGENTINA	0101000020E6100000000000E0469A4DC00000000046FB40C0
1053	alturas_bdhi:159	Ladario	-19.0005436	-57.5955582	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	ARGENTINA	0101000020E6100000000000403BCC4CC0000000A0230033C0
1054	alturas_bdhi:170	Ruta Nacional nÂº 12	-26.4807644	-54.6565208	0	\N	\N	\N	\N	\N	\N	\N	MISIONES	\N	\N	ARGENTINA	0101000020E6100000000000E008544BC000000060137B3AC0
1055	alturas_bdhi:181	Foz de ChapecÃ³ Justante	-27.0456295	-53.381218	0	\N	\N	\N	\N	\N	\N	\N	BRASIL	\N	\N	BRASIL	0101000020E6100000000000C0CBB04AC000000060AE0B3BC0
1056	alturas_bdhi:182	Salto Santiago	-25.6105061	-52.6173668	0	\N	\N	\N	\N	\N	\N	\N	BRASIL	\N	\N	BRASIL	0101000020E6100000000000E0054F4AC0000000204A9C39C0
1057	alturas_bdhi:183	Foz de Areia	-26.0088863	-51.6659813	0	\N	\N	\N	\N	\N	\N	\N	BRASIL	\N	\N	BRASIL	0101000020E6100000000000E03ED549C00000006046023AC0
1058	alturas_bdhi:185	GuaÃ­ra	-24.0771294	-54.2768784	0	\N	\N	\N	\N	\N	\N	\N	BRASIL	\N	\N	BRASIL	0101000020E6100000000000C070234BC0000000C0BE1338C0
1059	red_ana_hidro:277	Barra do Quarai	-30.2099991	-57.5499992	0	\N	\N	\N	\N	\N	\N	\N	BRASIL	\N	\N	BRASIL	0101000020E61000000000006066C64CC000000080C2353EC0
1060	red_ana_hidro:278	Monte Caseros	-30.25	-57.6300011	0	\N	\N	\N	\N	\N	\N	\N	ENTRERIOS	\N	\N	ARGENTINA	0101000020E6100000000000E0A3D04CC00000000000403EC0
1061	red_ana_hidro:279	Passo da Cruz	-30.25	-57.3199997	0	\N	\N	\N	\N	\N	\N	\N	BRASIL	\N	\N	BRASIL	0101000020E6100000000000C0F5A84CC00000000000403EC0
1062	red_ana_hidro:280	Paso de la Cruz	-30.2700005	-57.2999992	0	\N	\N	\N	\N	\N	\N	\N	URUGUAY	\N	\N	URUGUAY	0101000020E61000000000006066A64CC0000000C01E453EC0
1063	red_ana_hidro:281	Passo do Leao	-30.1200008	-57.0800018	0	\N	\N	\N	\N	\N	\N	\N	BRASIL	\N	\N	BRASIL	0101000020E6100000000000803D8A4CC000000060B81E3EC0
1064	red_ana_hidro:282	Salto	-31.3700008	-57.9500008	0	\N	\N	\N	\N	\N	\N	\N	URUGUAY	\N	\N	URUGUAY	0101000020E6100000000000A099F94CC000000060B85E3FC0
1065	red_ana_hidro:283	Concordia	-31.3999996	-58.0200005	0	\N	\N	\N	\N	\N	\N	\N	ENTRERIOS	\N	\N	ARGENTINA	0101000020E6100000000000608F024DC00000006066663FC0
1066	red_ana_hidro:284	Concepcion del uruguay	-32.4833984	-58.2331009	0	\N	\N	\N	\N	\N	\N	\N	ENTRERIOS	\N	\N	ARGENTINA	0101000020E610000000000040D61D4DC000000000E03D40C0
1067	red_ana_hidro:285	Ponte alta do sul	-27.4899998	-50.3899994	0	\N	\N	\N	\N	\N	\N	\N	BRASIL	\N	\N	BRASIL	0101000020E610000000000080EB3149C0000000A0707D3BC0
1068	red_ana_hidro:286	Passo Marombas	-27.3299999	-50.75	0	\N	\N	\N	\N	\N	\N	\N	BRASIL	\N	\N	BRASIL	0101000020E610000000000000006049C0000000E07A543BC0
1069	red_ana_hidro:287	Rio Capinzal	-27.3299999	-51.5999985	0	\N	\N	\N	\N	\N	\N	\N	BRASIL	\N	\N	BRASIL	0101000020E6100000000000C0CCCC49C0000000E07A543BC0
1070	red_ana_hidro:288	Passo Colombelli	-27.5599995	-51.8600006	0	\N	\N	\N	\N	\N	\N	\N	BRASIL	\N	\N	BRASIL	0101000020E61000000000008014EE49C0000000205C8F3BC0
1071	red_ana_hidro:289	Bonito	-26.9500008	-52.1800003	0	\N	\N	\N	\N	\N	\N	\N	BRASIL	\N	\N	BRASIL	0101000020E6100000000000400A174AC00000004033F33AC0
1072	alturas_bdhi:191	ItaipÃº	-25.4507542	-54.61306	0	\N	\N	\N	\N	\N	\N	\N	BRASIL	\N	\N	BRASIL	0101000020E6100000000000C0784E4BC0000000A0647339C0
1073	alturas_bdhi:148	Seminario Diocesano de Azul	-36.8310814	-59.8938866	0	\N	\N	\N	\N	\N	\N	\N	BUENOSAIRES	\N	\N	ARGENTINA	0101000020E6100000000000E06AF24DC0000000E0606A42C0
1074	red_inta:799	INTA - Cuchilla - Establecimiento Cuchilla	-33.1969986	-59.2599983	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E6100000000000A047A14DC000000040379940C0
1075	red_inta:800	INTA - Delta - EEA Delta del Parana	-34.1749992	-58.862999	0	\N	\N	\N	\N	\N	\N	\N	Buenos Aires	\N	\N	ARGENTINA	0101000020E6100000000000C0766E4DC000000060661641C0
1076	red_ana_hidro:252	Passo Santo Antonio	-27.6299992	-51.0200005	0	\N	\N	\N	\N	\N	\N	\N	BRASIL	\N	\N	BRASIL	0101000020E6100000000000608F8249C0000000A047A13BC0
1077	red_ana_hidro:253	Colonia Santana	-27.6499996	-51.0499992	0	\N	\N	\N	\N	\N	\N	\N	BRASIL	\N	\N	BRASIL	0101000020E610000000000060668649C00000006066A63BC0
1078	red_ana_hidro:254	Passo Socorro	-28.2099991	-50.7599983	0	\N	\N	\N	\N	\N	\N	\N	BRASIL	\N	\N	BRASIL	0101000020E6100000000000A0476149C000000080C2353CC0
1079	red_ana_hidro:255	Passo Do Virgilio	-27.5	-51.7099991	0	\N	\N	\N	\N	\N	\N	\N	BRASIL	\N	\N	BRASIL	0101000020E610000000000040E1DA49C00000000000803BC0
1080	red_ana_hidro:256	Marcelino Ramos	-27.4599991	-51.9000015	0	\N	\N	\N	\N	\N	\N	\N	BRASIL	\N	\N	BRASIL	0101000020E61000000000004033F349C000000080C2753BC0
1081	red_ana_hidro:257	Boca do Estreito	-27.4200001	-52	0	\N	\N	\N	\N	\N	\N	\N	BRASIL	\N	\N	BRASIL	0101000020E61000000000000000004AC000000020856B3BC0
1082	red_ana_hidro:258	Ita	-27.2800007	-52.3300018	0	\N	\N	\N	\N	\N	\N	\N	BRASIL	\N	\N	BRASIL	0101000020E6100000000000803D2A4AC000000020AE473BC0
1083	red_ana_hidro:259	Passo Caxambu	-27.1700001	-52.8699989	0	\N	\N	\N	\N	\N	\N	\N	BRASIL	\N	\N	BRASIL	0101000020E6100000000000205C6F4AC000000020852B3BC0
1084	red_ana_hidro:260	Barra do Chapeco aux	-27.0400009	-52.9500008	0	\N	\N	\N	\N	\N	\N	\N	BRASIL	\N	\N	BRASIL	0101000020E6100000000000A099794AC0000000803D0A3BC0
1085	red_ana_hidro:261	Barra do Chapeco	-27.1000004	-53	0	\N	\N	\N	\N	\N	\N	\N	BRASIL	\N	\N	BRASIL	0101000020E61000000000000000804AC0000000A099193BC0
1086	red_ana_hidro:262	Irai	-27.1700001	-53.2299995	0	\N	\N	\N	\N	\N	\N	\N	BRASIL	\N	\N	BRASIL	0101000020E6100000000000A0709D4AC000000020852B3BC0
1087	red_inta:801	INTA - EMA Charata - EMA Charata - Escuela Agropecuaria	-27.2150002	-61.1699982	0	\N	\N	\N	\N	\N	\N	\N	Chaco	\N	\N	ARGENTINA	0101000020E610000000000080C2954EC0000000400A373BC0
1088	red_inta:804	INTA - General Acha - EEA Anguil - Gral. Acha	-37.3829994	-64.5999985	0	\N	\N	\N	\N	\N	\N	\N	La Pampa	\N	\N	ARGENTINA	0101000020E610000000000060662650C00000002006B142C0
1089	red_inta:805	INTA - La Para - Campo	-31.0119991	-63.0200005	0	\N	\N	\N	\N	\N	\N	\N	CÃ³rdoba	\N	\N	ARGENTINA	0101000020E6100000000000608F824FC00000006012033FC0
1090	red_inta:806	INTA - Las Brenas - INTA - Las Brenas	-27.073	-61.0620003	0	\N	\N	\N	\N	\N	\N	\N	Chaco	\N	\N	ARGENTINA	0101000020E6100000000000A0EF874EC000000020B0123BC0
1091	red_inta:828	Manfredi (EMA) - INTA - Manfredi (EMA)	-31.8199997	-63.7700005	0	\N	\N	\N	\N	\N	\N	\N	CÃ³rdoba	\N	\N	ARGENTINA	0101000020E6100000000000608FE24FC000000080EBD13FC0
1092	red_inta:807	INTA - Parana - EEA Parana - Parana	-31.8560009	-60.5299988	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E610000000000000D7434EC0000000E022DB3FC0
1093	red_inta:808	INTA - Pergamino - EEA Pergamino	-33.8880005	-60.5690002	0	\N	\N	\N	\N	\N	\N	\N	Buenos Aires	\N	\N	ARGENTINA	0101000020E610000000000000D5484EC000000000AAF140C0
1094	red_inta:809	INTA - San Gustavo - EEA Parana - San Gustavo	-30.6669998	-59.3829994	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E61000000000002006B14DC000000080C0AA3EC0
1095	red_inta:810	INTA - San Pedro - EEA Pergamino - San Pedro	-33.7750015	-59.7519989	0	\N	\N	\N	\N	\N	\N	\N	Buenos Aires	\N	\N	ARGENTINA	0101000020E61000000000008041E04DC00000004033E340C0
1096	red_inta:811	INTA - Victorica - EEA Anguil - Victorica	-36.2159996	-65.4319992	0	\N	\N	\N	\N	\N	\N	\N	La Pampa	\N	\N	ARGENTINA	0101000020E6100000000000E0A55B50C0000000E0A51B42C0
1097	red_inta:812	INTA - Villa Elisa - EEA Parana - Villa Elisa	-32.1669998	-58.4000015	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E61000000000004033334DC000000040601540C0
1098	red_inta:813	INTA - Villa Regina - Villa Regina	-39.1259995	-67.1060028	0	\N	\N	\N	\N	\N	\N	\N	RÃ­o Negro	\N	\N	ARGENTINA	0101000020E6100000000000C0C8C650C0000000C0209043C0
1099	red_inta:814	Ituzaingo - Establecimiento Ibera Costa	-27.552	-56.5550003	0	\N	\N	\N	\N	\N	\N	\N	Corrientes	\N	\N	ARGENTINA	0101000020E6100000000000400A474CC0000000E04F8D3BC0
1100	red_inta:817	Jumial Grande - Parque agente INTA Prohuerta	-27.4300003	-63.3199997	0	\N	\N	\N	\N	\N	\N	\N	Santiago del Estero	\N	\N	ARGENTINA	0101000020E6100000000000C0F5A84FC000000080146E3BC0
1101	red_inta:818	La Colmena - Escuela Agrotecnica Hipolito Yrigoyen	-31.5529995	-59.7169991	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E6100000000000A0C6DB4DC000000060918D3FC0
1102	red_inta:819	La Dulce - EEA Balcarce - Campo Experimental Buck Semillas SA	-38.3370018	-59.0079994	0	\N	\N	\N	\N	\N	\N	\N	Buenos Aires	\N	\N	ARGENTINA	0101000020E61000000000002006814DC0000000E0222B43C0
1103	red_inta:820	La Leonesa	-27.0540009	-58.7120018	0	\N	\N	\N	\N	\N	\N	\N	Chaco	\N	\N	ARGENTINA	0101000020E6100000000000E0225B4DC000000000D30D3BC0
1104	red_inta:821	Las Armas - INTA - Las Armas	-37.5999985	-57.8330002	0	\N	\N	\N	\N	\N	\N	\N	Buenos Aires	\N	\N	ARGENTINA	0101000020E6100000000000C09FEA4CC0000000C0CCCC42C0
1105	red_inta:823	Las piedritas - INTA - Las piedritas	-26.816	-61.612999	0	\N	\N	\N	\N	\N	\N	\N	Chaco	\N	\N	ARGENTINA	0101000020E6100000000000C076CE4EC000000060E5D03AC0
1106	red_inta:824	Las Rosas - Establecimiento Agricola - Flia Giampieri	-32.4920006	-61.5670013	0	\N	\N	\N	\N	\N	\N	\N	Santa Fe	\N	\N	ARGENTINA	0101000020E61000000000008093C84EC0000000E0F93E40C0
1107	red_inta:825	Las Tunas - Establecimiento San Antonio	-31.8710003	-59.6850014	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E610000000000020AED74DC0000000E0F9DE3FC0
1108	red_inta:826	Lima - EEA San Pedro - Empresa Granel del Sur (Planta de Acopio)	-34.0800018	-59.2060013	0	\N	\N	\N	\N	\N	\N	\N	Buenos Aires	\N	\N	ARGENTINA	0101000020E6100000000000405E9A4DC0000000803D0A41C0
1109	red_inta:827	Macia - INTA - Macia - Establecimiento Casa Juan	-32.1660004	-59.3909988	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E6100000000000400CB24DC0000000803F1540C0
1110	red_inta:830	Miramar - EEA Balcarce - Chacra Experimental Miramar	-38.1549988	-57.9939995	0	\N	\N	\N	\N	\N	\N	\N	Buenos Aires	\N	\N	ARGENTINA	0101000020E6100000000000603BFF4CC000000000D71343C0
1111	red_ana_hidro:268	San Javier	-27.8833008	-55.1333008	0	\N	\N	\N	\N	\N	\N	\N	MISIONES	\N	\N	ARGENTINA	0101000020E61000000000000010914BC00000000020E23BC0
1112	alturas_bdhi:301	Cascata Burica	-27.5200005	-54.2299995	0	\N	\N	\N	\N	\N	\N	\N	BRASIL	\N	\N	BRASIL	0101000020E6100000000000A0701D4BC0000000C01E853BC0
1113	red_ana_hidro:300	Cascata Burica	-27.5200005	-54.2299995	0	\N	\N	\N	\N	\N	\N	\N	BRASIL	\N	\N	BRASIL	0101000020E6100000000000A0701D4BC0000000C01E853BC0
1114	red_ana_hidro:263	Eixo Itapiranga	-27.1700001	-53.6800003	0	\N	\N	\N	\N	\N	\N	\N	BRASIL	\N	\N	BRASIL	0101000020E6100000000000400AD74AC000000020852B3BC0
1115	emas:917	nogoya	-32.3908348	-59.7991676	0	\N	\N	\N	\N	\N	\N	\N	ENTRERIOS	\N	\N	ARGENTINA	0101000020E6100000000000204BE64DC0000000E0063240C0
1116	red_inta:838	Sachayoj - Establecimiento El Toba de Martin Hnos.	-26.4640007	-61.8160019	0	\N	\N	\N	\N	\N	\N	\N	Santiago del Estero	\N	\N	ARGENTINA	0101000020E6100000000000C072E84EC0000000C0C8763AC0
1117	red_inta:839	San Nicolas - EEA San Pedro - Establecimiento Don Umberto	-33.3580017	-60.2249985	0	\N	\N	\N	\N	\N	\N	\N	Buenos Aires	\N	\N	ARGENTINA	0101000020E6100000000000C0CC1C4EC000000000D3AD40C0
1118	red_inta:842	Santa Sylvina - INTA - Santa Sylvina	-27.8500004	-61.132	0	\N	\N	\N	\N	\N	\N	\N	Chaco	\N	\N	ARGENTINA	0101000020E610000000000060E5904EC0000000A099D93BC0
1119	red_inta:787	EFA Bernardo de Irigoyen - Predio del Servicio Meteorologico Nacional	-26.4360008	-53.6739998	0	\N	\N	\N	\N	\N	\N	\N	Misiones	\N	\N	ARGENTINA	0101000020E6100000000000A045D64AC0000000C09D6F3AC0
1120	red_inta:797	Hermoso Campo - INTA - Hermoso Campo	-27.6019993	-61.3110008	0	\N	\N	\N	\N	\N	\N	\N	Chaco	\N	\N	ARGENTINA	0101000020E6100000000000E0CEA74EC0000000A01C9A3BC0
1121	red_inta:786	EFA Andresito - Escuela de la Familia Agricola (EFA 704 ANDRESITO)	-25.6170006	-54.0699997	0	\N	\N	\N	\N	\N	\N	\N	Misiones	\N	\N	ARGENTINA	0101000020E6100000000000C0F5084BC0000000C0F39D39C0
1122	red_inta:1401	EEA Cesareo Naredo	-36.5	-62	0	\N	\N	\N	\N	\N	\N	\N	Buenos Aires	\N	\N	ARGENTINA	0101000020E61000000000000000004FC000000000004042C0
1123	red_inta:1402	El Galpon	-25.3799992	-64.6399994	0	\N	\N	\N	\N	\N	\N	\N	Salta	\N	\N	ARGENTINA	0101000020E6100000000000C0F52850C0000000A0476139C0
1124	red_inta:1403	El Redomon	-31.0799999	-58.2799988	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E610000000000000D7234DC0000000E07A143FC0
1125	alturas_bdhi:319	La Sirena	-28.4168339	-56.5421944	0	\N	\N	\N	\N	\N	\N	\N	CORRIENTES	\N	\N	ARGENTINA	0101000020E6100000000000A066454CC0000000A0B56A3CC0
1126	red_inta:1287	INTA - Saenz PeÃ±a	-26.8400002	-60.4399986	0	\N	\N	\N	\N	\N	\N	\N	Chaco	\N	\N	ARGENTINA	0101000020E6100000000000E051384EC0000000400AD73AC0
1127	red_inta:1292	INTA - Villa Mercedes (EMC)	-33.7200012	-65.4800034	0	\N	\N	\N	\N	\N	\N	\N	San Luis	\N	\N	ARGENTINA	0101000020E610000000000060B85E50C00000000029DC40C0
1128	red_inta:1299	Bordenave - EEA Bordenave	-37.75	-63.0800018	0	\N	\N	\N	\N	\N	\N	\N	Buenos Aires	\N	\N	ARGENTINA	0101000020E6100000000000803D8A4FC00000000000E042C0
1129	red_inta:1306	Mercedes - EEA Mercedes	-29.2000008	-58.0400009	0	\N	\N	\N	\N	\N	\N	\N	Corrientes	\N	\N	ARGENTINA	0101000020E6100000000000C01E054DC00000004033333DC0
1130	alturas_prefe:90	Erogado Salto Grande	-31.2739697	-57.9380112	0	\N	\N	\N	\N	\N	\N	\N	ENTRERIOS	\N	\N	ARGENTINA	0101000020E6100000000000C010F84CC0000000E022463FC0
1131	alturas_prefe:19	Corrientes	-27.463644	-58.838871	0	\N	\N	\N	\N	\N	\N	\N	CORRIENTES	\N	\N	ARGENTINA	0101000020E610000000000020606B4DC000000060B1763BC0
1132	alturas_prefe:20	Barranqueras	-27.4833336	-58.9333344	0	\N	\N	\N	\N	\N	\N	\N	CHACO	\N	\N	ARGENTINA	0101000020E61000000000008077774DC0000000C0BB7B3BC0
1133	alturas_prefe:29	ParanÃ¡	-31.7182369	-60.5225716	0	\N	\N	\N	\N	\N	\N	\N	ENTRERIOS	\N	\N	ARGENTINA	0101000020E6100000000000A0E3424EC000000060DEB73FC0
1134	alturas_prefe:30	Santa Fe	-31.6514778	-60.7002335	0	\N	\N	\N	\N	\N	\N	\N	SANTAFE	\N	\N	ARGENTINA	0101000020E610000000000040A1594EC000000040C7A63FC0
1135	alturas_prefe:34	Rosario	-32.9432716	-60.6308212	0	\N	\N	\N	\N	\N	\N	\N	SANTAFE	\N	\N	ARGENTINA	0101000020E6100000000000C0BE504EC000000020BD7840C0
1136	alturas_prefe:38	San Pedro	-33.6745262	-59.6497192	0	\N	\N	\N	\N	\N	\N	\N	BUENOSAIRES	\N	\N	ARGENTINA	0101000020E6100000000000002AD34DC0000000E056D640C0
1137	alturas_prefe:55	Puerto Pilcomayo	-25.3666668	-57.6500015	0	\N	\N	\N	\N	\N	\N	\N	FORMOSA	\N	\N	ARGENTINA	0101000020E61000000000004033D34CC0000000E0DD5D39C0
1138	alturas_prefe:57	Puerto Formosa	-26.1833324	-58.1833344	0	\N	\N	\N	\N	\N	\N	\N	FORMOSA	\N	\N	ARGENTINA	0101000020E61000000000008077174DC0000000E0EE2E3AC0
1139	alturas_prefe:61	El Soberbio	-27.2999992	-54.2000008	0	\N	\N	\N	\N	\N	\N	\N	MISIONES	\N	\N	ARGENTINA	0101000020E6100000000000A099194BC0000000C0CC4C3BC0
1140	alturas_prefe:65	San Javier	-27.8833332	-55.1333351	0	\N	\N	\N	\N	\N	\N	\N	MISIONES	\N	\N	ARGENTINA	0101000020E61000000000002011914BC00000002022E23BC0
1141	red_ana_hidro:310	Passo do Novo	-28.6800003	-55.5800018	0	\N	\N	\N	\N	\N	\N	\N	BRASIL	\N	\N	BRASIL	0101000020E6100000000000803DCA4BC00000008014AE3CC0
1142	red_ana_hidro:311	Passo Mariano Pinto	-29.3099995	-56.0499992	0	\N	\N	\N	\N	\N	\N	\N	BRASIL	\N	\N	BRASIL	0101000020E61000000000006066064CC0000000205C4F3DC0
1143	red_ana_hidro:312	Passo do Ibicui	-29.3999996	-56.6800003	0	\N	\N	\N	\N	\N	\N	\N	BRASIL	\N	\N	BRASIL	0101000020E6100000000000400A574CC00000006066663DC0
1144	red_ana_hidro:313	Paso de los Libres	-29.7199993	-57.0800018	0	\N	\N	\N	\N	\N	\N	\N	URUGUAY	\N	\N	URUGUAY	0101000020E6100000000000803D8A4CC0000000E051B83DC0
1145	red_ana_hidro:314	Uruguaiana	-29.75	-57.0900002	0	\N	\N	\N	\N	\N	\N	\N	BRASIL	\N	\N	BRASIL	0101000020E610000000000020858B4CC00000000000C03DC0
1146	red_ana_hidro:315	Paso de la Cruz	-30.2700005	-57.2999992	0	\N	\N	\N	\N	\N	\N	\N	URUGUAY	\N	\N	URUGUAY	0101000020E61000000000006066A64CC0000000C01E453EC0
1147	red_ana_hidro:316	Paso de la Cruz	-30.25	-57.3199997	0	\N	\N	\N	\N	\N	\N	\N	URUGUAY	\N	\N	URUGUAY	0101000020E6100000000000C0F5A84CC00000000000403EC0
1148	red_ana_hidro:318	Alegrete2	-29.7686005	-55.7872009	0	\N	\N	\N	\N	\N	\N	\N	BRASIL	\N	\N	BRASIL	0101000020E610000000000000C3E44BC000000000C3C43DC0
1149	alturas_prefe:68	Santo TomÃ©	-28.5499992	-56.0333328	0	\N	\N	\N	\N	\N	\N	\N	CORRIENTES	\N	\N	ARGENTINA	0101000020E61000000000004044044CC0000000C0CC8C3CC0
1150	alturas_prefe:72	Paso de los Libres	-29.7166672	-57.0833321	0	\N	\N	\N	\N	\N	\N	\N	CORRIENTES	\N	\N	ARGENTINA	0101000020E6100000000000A0AA8A4CC00000008077B73DC0
1151	alturas_prefe:77	Salto Grande Arriba	-31.2754707	-57.9369469	0	\N	\N	\N	\N	\N	\N	\N	ENTRERIOS	\N	\N	ARGENTINA	0101000020E6100000000000E0EDF74CC00000004085463FC0
1152	alturas_prefe:78	Salto Grande Abajo	-31.2754707	-57.9369469	0	\N	\N	\N	\N	\N	\N	\N	ENTRERIOS	\N	\N	ARGENTINA	0101000020E6100000000000E0EDF74CC00000004085463FC0
1153	alturas_prefe:79	Concordia	-31.3999996	-58.0166664	0	\N	\N	\N	\N	\N	\N	\N	ENTRERIOS	\N	\N	ARGENTINA	0101000020E61000000000002022024DC00000006066663FC0
1154	alturas_prefe:88	YacyretÃ¡ efluente	-27.4825573	-56.7272453	0	\N	\N	\N	\N	\N	\N	\N	CORRIENTES	\N	\N	ARGENTINA	0101000020E610000000000060165D4CC0000000E0887B3BC0
1155	alturas_prefe:92	Represa ItaipÃº	-25.3999996	-54.5830002	0	\N	\N	\N	\N	\N	\N	\N	BRASIL	\N	\N	ARGENTINA	0101000020E6100000000000C09F4A4BC000000060666639C0
1156	alturas_prefe:94	Represa Capanema	-25.5837784	-53.8170433	0	\N	\N	\N	\N	\N	\N	\N	BRASIL	\N	\N	ARGENTINA	0101000020E6100000000000E094E84AC000000080729539C0
1157	alturas_prefe:95	Caxias	-25.54282	-53.4902229	0	\N	\N	\N	\N	\N	\N	\N	BRASIL	\N	\N	ARGENTINA	0101000020E6100000000000A0BFBE4AC000000040F68A39C0
1158	alturas_prefe:18	Paso de la Patria	-27.333334	-58.5833321	0	\N	\N	\N	\N	\N	\N	\N	CORRIENTES	\N	\N	ARGENTINA	0101000020E6100000000000A0AA4A4DC00000006055553BC0
1159	alturas_prefe:21	Empedrado	-27.9541225	-58.8185234	0	\N	\N	\N	\N	\N	\N	\N	CORRIENTES	\N	\N	ARGENTINA	0101000020E610000000000060C5684DC00000006041F43BC0
1160	alturas_prefe:22	Bella Vista	-28.5184002	-59.0593185	0	\N	\N	\N	\N	\N	\N	\N	CORRIENTES	\N	\N	ARGENTINA	0101000020E6100000000000C097874DC0000000E0B5843CC0
1161	alturas_prefe:23	Goya	-29.1437683	-59.2730408	0	\N	\N	\N	\N	\N	\N	\N	CORRIENTES	\N	\N	ARGENTINA	0101000020E610000000000000F3A24DC000000000CE243DC0
1162	alturas_prefe:24	Reconquista	-29.2375603	-59.5811577	0	\N	\N	\N	\N	\N	\N	\N	SANTAFE	\N	\N	ARGENTINA	0101000020E61000000000006063CA4DC0000000C0D03C3DC0
1163	alturas_prefe:25	Esquina	-30.0192413	-59.5366364	0	\N	\N	\N	\N	\N	\N	\N	CORRIENTES	\N	\N	ARGENTINA	0101000020E610000000000080B0C44DC000000000ED043EC0
1164	alturas_prefe:26	La Paz	-30.7341995	-59.6381149	0	\N	\N	\N	\N	\N	\N	\N	ENTRERIOS	\N	\N	ARGENTINA	0101000020E6100000000000C0ADD14DC000000080F4BB3EC0
1165	alturas_prefe:27	Santa Elena	-30.9500008	-59.7833328	0	\N	\N	\N	\N	\N	\N	\N	ENTRERIOS	\N	\N	ARGENTINA	0101000020E61000000000004044E44DC00000004033F33EC0
1166	alturas_prefe:28	Hernandarias	-31.2265091	-59.9919395	0	\N	\N	\N	\N	\N	\N	\N	ENTRERIOS	\N	\N	ARGENTINA	0101000020E6100000000000E0F7FE4DC000000080FC393FC0
1167	alturas_prefe:31	Diamante	-32.0715599	-60.6432228	0	\N	\N	\N	\N	\N	\N	\N	ENTRERIOS	\N	\N	ARGENTINA	0101000020E61000000000002055524EC0000000E0280940C0
1168	alturas_prefe:32	Victoria	-32.6558456	-60.2195854	0	\N	\N	\N	\N	\N	\N	\N	ENTRERIOS	\N	\N	ARGENTINA	0101000020E6100000000000601B1C4EC0000000C0F25340C0
1169	alturas_prefe:33	San Lorenzo (San MartÃ­n)	-32.7336273	-60.7256699	0	\N	\N	\N	\N	\N	\N	\N	SANTAFE	\N	\N	ARGENTINA	0101000020E6100000000000C0E25C4EC000000080E75D40C0
1170	alturas_prefe:35	Villa ConstituciÃ³n	-33.235424	-60.3091049	0	\N	\N	\N	\N	\N	\N	\N	SANTAFE	\N	\N	ARGENTINA	0101000020E6100000000000C090274EC000000060229E40C0
1171	alturas_prefe:36	San NicolÃ¡s	-33.3419991	-60.1895294	0	\N	\N	\N	\N	\N	\N	\N	BUENOSAIRES	\N	\N	ARGENTINA	0101000020E61000000000008042184EC0000000A0C6AB40C0
1172	alturas_prefe:37	Ramallo	-33.4780655	-59.9957008	0	\N	\N	\N	\N	\N	\N	\N	BUENOSAIRES	\N	\N	ARGENTINA	0101000020E61000000000002073FF4DC00000004031BD40C0
1173	alturas_prefe:39	Baradero	-33.8006935	-59.4955978	0	\N	\N	\N	\N	\N	\N	\N	BUENOSAIRES	\N	\N	ARGENTINA	0101000020E6100000000000C06FBF4DC0000000207DE640C0
1174	alturas_prefe:40	ZÃ¡rate	-34.0987816	-59.0108643	0	\N	\N	\N	\N	\N	\N	\N	BUENOSAIRES	\N	\N	ARGENTINA	0101000020E61000000000000064814DC0000000E0A40C41C0
1175	alturas_prefe:41	Campana	-34.1555862	-58.9581757	0	\N	\N	\N	\N	\N	\N	\N	BUENOSAIRES	\N	\N	ARGENTINA	0101000020E610000000000080A57A4DC000000040EA1341C0
1176	alturas_prefe:52	San Fernando	-34.4333344	-58.5499992	0	\N	\N	\N	\N	\N	\N	\N	BUENOSAIRES	\N	\N	ARGENTINA	0101000020E61000000000006066464DC000000080773741C0
1177	alturas_prefe:53	San Isidro	-34.4571648	-58.507164	0	\N	\N	\N	\N	\N	\N	\N	BUENOSAIRES	\N	\N	ARGENTINA	0101000020E6100000000000C0EA404DC000000060843A41C0
1178	alturas_prefe:54	Olivos	-34.5066643	-58.4758644	0	\N	\N	\N	\N	\N	\N	\N	BUENOSAIRES	\N	\N	ARGENTINA	0101000020E610000000000020E93C4DC000000060DA4041C0
1179	alturas_prefe:56	Bouvier	-25.4519463	-57.5681839	0	\N	\N	\N	\N	\N	\N	\N	FORMOSA	\N	\N	ARGENTINA	0101000020E610000000000040BAC84CC0000000C0B27339C0
1180	alturas_prefe:66	Puerto ConcepciÃ³n	-28.1191921	-55.5813675	0	\N	\N	\N	\N	\N	\N	\N	MISIONES	\N	\N	ARGENTINA	0101000020E6100000000000406ACA4BC000000060831E3CC0
1181	alturas_prefe:67	Garruchos	-28.1833324	-55.6500015	0	\N	\N	\N	\N	\N	\N	\N	CORRIENTES	\N	\N	ARGENTINA	0101000020E61000000000004033D34BC0000000E0EE2E3CC0
1182	alturas_prefe:69	Alvear	-29.1000004	-56.5499992	0	\N	\N	\N	\N	\N	\N	\N	CORRIENTES	\N	\N	ARGENTINA	0101000020E61000000000006066464CC0000000A099193DC0
1183	alturas_prefe:70	La Cruz	-29.1806202	-56.633976	0	\N	\N	\N	\N	\N	\N	\N	CORRIENTES	\N	\N	ARGENTINA	0101000020E61000000000002026514CC0000000203D2E3DC0
1184	alturas_prefe:71	YapeyÃº	-29.4700317	-56.8106728	0	\N	\N	\N	\N	\N	\N	\N	CORRIENTES	\N	\N	ARGENTINA	0101000020E610000000000020C4674CC00000000054783DC0
1185	alturas_prefe:73	Bompland	-29.8726521	-57.3328857	0	\N	\N	\N	\N	\N	\N	\N	CORRIENTES	\N	\N	ARGENTINA	0101000020E6100000000000009CAA4CC00000002066DF3DC0
1186	alturas_prefe:74	Monte Caseros	-30.25	-57.6333351	0	\N	\N	\N	\N	\N	\N	\N	CORRIENTES	\N	\N	ARGENTINA	0101000020E61000000000002011D14CC00000000000403EC0
1187	alturas_prefe:75	MocoretÃ¡	-30.7156811	-57.8177605	0	\N	\N	\N	\N	\N	\N	\N	CORRIENTES	\N	\N	ARGENTINA	0101000020E610000000000060ACE84CC0000000E036B73EC0
1188	alturas_prefe:76	FederaciÃ³n	-30.9932213	-57.9146805	0	\N	\N	\N	\N	\N	\N	\N	ENTRERIOS	\N	\N	ARGENTINA	0101000020E61000000000004014F54CC0000000C043FE3EC0
1189	alturas_prefe:80	ColÃ³n	-32.2333336	-58.1166649	0	\N	\N	\N	\N	\N	\N	\N	ENTRERIOS	\N	\N	ARGENTINA	0101000020E6100000000000E0EE0E4DC0000000E0DD1D40C0
1190	alturas_prefe:81	ConcepciÃ³n del Uruguay	-32.4833336	-58.2333336	0	\N	\N	\N	\N	\N	\N	\N	ENTRERIOS	\N	\N	ARGENTINA	0101000020E6100000000000E0DD1D4DC0000000E0DD3D40C0
1191	alturas_prefe:82	Campichuelo	-32.7010117	-58.1833992	0	\N	\N	\N	\N	\N	\N	\N	ENTRERIOS	\N	\N	ARGENTINA	0101000020E6100000000000A079174DC0000000C0BA5940C0
1192	alturas_prefe:84	Boca GualeguaychÃº	-33.0666656	-58.4166679	0	\N	\N	\N	\N	\N	\N	\N	ENTRERIOS	\N	\N	ARGENTINA	0101000020E61000000000006055354DC000000080888840C0
1193	alturas_prefe:85	Buenos Aires	-34.5610809	-58.3992882	0	\N	\N	\N	\N	\N	\N	\N	BUENOSAIRES	\N	\N	ARGENTINA	0101000020E6100000000000E01B334DC000000080D14741C0
1194	alturas_prefe:86	La Plata	-34.8241959	-57.8735466	0	\N	\N	\N	\N	\N	\N	\N	BUENOSAIRES	\N	\N	ARGENTINA	0101000020E610000000000060D0EF4CC0000000407F6941C0
1195	stations:363	AEROPARQUE BUENOS AIRES                 	-34.5666656	-58.4166679	0	\N	\N	\N	\N	\N	\N	\N	CABA	\N	\N	ARGENTINA	0101000020E61000000000006055354DC000000080884841C0
1196	stations:364	BENITO JUAREZ AERO                      	-37.7166672	-59.7833328	0	\N	\N	\N	\N	\N	\N	\N	BUENOSAIRES	\N	\N	ARGENTINA	0101000020E61000000000004044E44DC0000000C0BBDB42C0
1197	stations:365	CERES AERO                              	-29.8833332	-61.9500008	0	\N	\N	\N	\N	\N	\N	\N	SANTAFE	\N	\N	ARGENTINA	0101000020E6100000000000A099F94EC00000002022E23DC0
1198	stations:366	CONCORDIA AERO                          	-31.2999992	-58.0200005	0	\N	\N	\N	\N	\N	\N	\N	ENTRERIOS	\N	\N	ARGENTINA	0101000020E6100000000000608F024DC0000000C0CC4C3FC0
1199	stations:367	CORDOBA AERO                            	-31.3166676	-64.2166672	0	\N	\N	\N	\N	\N	\N	\N	CORDOBA	\N	\N	ARGENTINA	0101000020E6100000000000E0DD0D50C00000002011513FC0
1200	stations:368	CORONEL PRINGLES AERO                   	-38.0166664	-61.3333321	0	\N	\N	\N	\N	\N	\N	\N	BUENOSAIRES	\N	\N	ARGENTINA	0101000020E6100000000000A0AAAA4EC000000020220243C0
1201	stations:369	DON TORCUATO AERO                       	-34.4833336	-58.6166649	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	ARGENTINA	0101000020E6100000000000E0EE4E4DC0000000E0DD3D41C0
1202	stations:370	ESC.AVIACION MILITAR AERO               	-31.4500008	-64.2666702	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	ARGENTINA	0101000020E610000000000020111150C00000004033733FC0
1203	stations:371	GENERAL PICO AERO                       	-35.7000008	-63.75	0	\N	\N	\N	\N	\N	\N	\N	LAPAMPA	\N	\N	ARGENTINA	0101000020E61000000000000000E04FC0000000A099D941C0
1204	stations:372	GUALEGUAYCHU AERO                       	-33	-58.6199989	0	\N	\N	\N	\N	\N	\N	\N	ENTRERIOS	\N	\N	ARGENTINA	0101000020E6100000000000205C4F4DC000000000008040C0
1205	stations:373	LA PLATA AERO                           	-34.9666672	-57.9000015	0	\N	\N	\N	\N	\N	\N	\N	BUENOSAIRES	\N	\N	ARGENTINA	0101000020E61000000000004033F34CC0000000C0BB7B41C0
1206	stations:374	MAR DEL PLATA AERO                      	-37.9333344	-57.5833321	0	\N	\N	\N	\N	\N	\N	\N	BUENOSAIRES	\N	\N	ARGENTINA	0101000020E6100000000000A0AACA4CC00000008077F742C0
1207	stations:375	MARCOS JUAREZ AERO                      	-32.7000008	-62.1500015	0	\N	\N	\N	\N	\N	\N	\N	CORDOBA	\N	\N	ARGENTINA	0101000020E61000000000004033134FC0000000A0995940C0
1208	red_ana_hidro:290	Passo Alto Irani	-26.9699993	-52.3699989	0	\N	\N	\N	\N	\N	\N	\N	BRASIL	\N	\N	BRASIL	0101000020E6100000000000205C2F4AC0000000E051F83AC0
1209	alturas_varios:1257	canal Borches	-34.0752144	-58.4426651	0	\N	\N	\N	\N	\N	\N	\N	Buenos Aires	\N	\N	ARGENTINA	0101000020E610000000000040A9384DC0000000A0A00941C0
1210	red_ana_hidro:291	Barca Irani	-27.1700001	-52.5200005	0	\N	\N	\N	\N	\N	\N	\N	BRASIL	\N	\N	BRASIL	0101000020E6100000000000608F424AC000000020852B3BC0
1211	red_ana_hidro:292	Ponte do Rio Passo Fundo	-27.3899994	-52.7200012	0	\N	\N	\N	\N	\N	\N	\N	BRASIL	\N	\N	BRASIL	0101000020E610000000000000295C4AC000000000D7633BC0
1212	stations:505	 MERLO AERO	-34.6833344	-58.7333336	0	\N	\N	\N	\N	\N	\N	\N	BUENOSAIRES	\N	\N	ARGENTINA	0101000020E6100000000000E0DD5D4DC000000080775741C0
1213	stations:452	 MORON AERO	-34.6666718	-58.6333313	0	\N	\N	\N	\N	\N	\N	\N	BUENOSAIRES	\N	\N	ARGENTINA	0101000020E61000000000000011514DC000000080555541C0
1214	alturas_genica:1259	ColÃ³n	-33.9126968	-61.1097374	0	\N	\N	\N	\N	\N	\N	\N	BUENOSAIRES	\N	\N	ARGENTINA	0101000020E6100000000000E00B8E4EC000000040D3F440C0
1215	red_ana_hidro:293	Porto Fae Novo	-26.8199997	-52.7299995	0	\N	\N	\N	\N	\N	\N	\N	BRASIL	\N	\N	BRASIL	0101000020E6100000000000A0705D4AC000000080EBD13AC0
1216	red_ana_hidro:294	Passo Nova Erechim	-26.9300003	-52.9000015	0	\N	\N	\N	\N	\N	\N	\N	BRASIL	\N	\N	BRASIL	0101000020E61000000000004033734AC00000008014EE3AC0
1217	red_ana_hidro:295	Raigao Alto	-26.9300003	-53.7099991	0	\N	\N	\N	\N	\N	\N	\N	BRASIL	\N	\N	BRASIL	0101000020E610000000000040E1DA4AC00000008014EE3AC0
1218	red_ana_hidro:296	Passo Rio da Varzea	-27.2800007	-53.3199997	0	\N	\N	\N	\N	\N	\N	\N	BRASIL	\N	\N	BRASIL	0101000020E6100000000000C0F5A84AC000000020AE473BC0
1219	red_ana_hidro:297	Tes Passos	-27.3899994	-53.8800011	0	\N	\N	\N	\N	\N	\N	\N	BRASIL	\N	\N	BRASIL	0101000020E6100000000000E0A3F04AC000000000D7633BC0
1220	red_ana_hidro:298	Alto Uruguai	-27.2999992	-54.1399994	0	\N	\N	\N	\N	\N	\N	\N	BRASIL	\N	\N	BRASIL	0101000020E610000000000080EB114BC0000000C0CC4C3BC0
1221	red_ana_hidro:299	El Soberbio	-27.2999992	-54.2000008	0	\N	\N	\N	\N	\N	\N	\N	MISIONES	\N	\N	ARGENTINA	0101000020E6100000000000A099194BC0000000C0CC4C3BC0
1222	red_ana_hidro:302	Linha Uniao	-27.9300003	-54.9399986	0	\N	\N	\N	\N	\N	\N	\N	BRASIL	\N	\N	BRASIL	0101000020E6100000000000E051784BC00000008014EE3BC0
1223	red_ana_hidro:303	Porto Lucena	-27.8500004	-55.0200005	0	\N	\N	\N	\N	\N	\N	\N	BRASIL	\N	\N	BRASIL	0101000020E6100000000000608F824BC0000000A099D93BC0
1224	red_ana_hidro:305	Passo Florida	-28.1299992	-55.1199989	0	\N	\N	\N	\N	\N	\N	\N	BRASIL	\N	\N	BRASIL	0101000020E6100000000000205C8F4BC0000000A047213CC0
1225	red_ana_hidro:306	Ponte Mistica	-28.1800003	-54.7400017	0	\N	\N	\N	\N	\N	\N	\N	BRASIL	\N	\N	BRASIL	0101000020E610000000000060B85E4BC000000080142E3CC0
1226	red_ana_hidro:307	Passo do Sarmento	-28.2099991	-55.3199997	0	\N	\N	\N	\N	\N	\N	\N	BRASIL	\N	\N	BRASIL	0101000020E6100000000000C0F5A84BC000000080C2353CC0
1227	red_ana_hidro:308	Garruchos	-28.1800003	-55.6399994	0	\N	\N	\N	\N	\N	\N	\N	MISIONES	\N	\N	ARGENTINA	0101000020E610000000000080EBD14BC000000080142E3CC0
1228	red_ana_hidro:309	Ponte do Rio Icamaqua	-28.6499996	-55.7000008	0	\N	\N	\N	\N	\N	\N	\N	BRASIL	\N	\N	BRASIL	0101000020E6100000000000A099D94BC00000006066A63CC0
1229	red_inta:1311	Cerro Azul - EEA Cerro Azul	-27.6599998	-55.4399986	0	\N	\N	\N	\N	\N	\N	\N	Misiones	\N	\N	ARGENTINA	0101000020E6100000000000E051B84BC0000000C0F5A83BC0
1230	red_inta:1380	Colan ConhuÃ© - EEA Esquel	-43.2299995	-69.9199982	0	\N	\N	\N	\N	\N	\N	\N	Chubut	\N	\N	ARGENTINA	0101000020E610000000000040E17A51C0000000A0709D45C0
1231	red_inta:1340	Alcaraz	-31.4799995	-59.5900002	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E61000000000002085CB4DC000000040E17A3FC0
1232	red_inta:1341	Aldea Asuncion	-32.9300003	-59.2400017	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E610000000000060B89E4DC0000000400A7740C0
1233	red_inta:1342	Algarrobo	-38.8899994	-63.1399994	0	\N	\N	\N	\N	\N	\N	\N	Buenos Aires	\N	\N	ARGENTINA	0101000020E610000000000080EB914FC000000080EB7143C0
1234	red_inta:1343	AlmacÃ©n Iglesias	-32.0200005	-59.5299988	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E610000000000000D7C34DC0000000608F0240C0
1235	red_inta:1344	Altamirano Norte	-32.0600014	-59.1599998	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E6100000000000E07A944DC000000020AE0740C0
1236	red_inta:1345	Aparicio - EEA Barrow	-38.6699982	-60.9300003	0	\N	\N	\N	\N	\N	\N	\N	Buenos Aires	\N	\N	ARGENTINA	0101000020E6100000000000400A774EC000000080C25543C0
1237	red_inta:1346	ArandÃº	-29.7800007	-57.4599991	0	\N	\N	\N	\N	\N	\N	\N	Corrientes	\N	\N	ARGENTINA	0101000020E610000000000040E1BA4CC000000020AEC73DC0
1238	red_inta:785	Coronel Suarez - EEA Bordenave - Municipalidad de Coronel Suarez	-37.4440002	-61.9249992	0	\N	\N	\N	\N	\N	\N	\N	Buenos Aires	\N	\N	ARGENTINA	0101000020E61000000000006066F64EC000000000D5B842C0
1239	stations:392	CORDOBA OBSERVATORIO                    	-31.3999996	-64.1833344	0	\N	\N	\N	\N	\N	\N	\N	CORDOBA	\N	\N	ARGENTINA	0101000020E6100000000000C0BB0B50C00000006066663FC0
1240	stations:393	CORONEL SUAREZ AERO                     	-37.4333344	-61.8833351	0	\N	\N	\N	\N	\N	\N	\N	BUENOSAIRES	\N	\N	ARGENTINA	0101000020E61000000000002011F14EC00000008077B742C0
1241	stations:394	DOLORES AERO                            	-36.3499985	-57.7333336	0	\N	\N	\N	\N	\N	\N	\N	BUENOSAIRES	\N	\N	ARGENTINA	0101000020E6100000000000E0DDDD4CC0000000C0CC2C42C0
1242	stations:395	EL PALOMAR AERO                         	-34.5999985	-58.5999985	0	\N	\N	\N	\N	\N	\N	\N	BUENOSAIRES	\N	\N	ARGENTINA	0101000020E6100000000000C0CC4C4DC0000000C0CC4C41C0
1243	stations:396	EL TREBOL                               	-32.2000008	-61.6666679	0	\N	\N	\N	\N	\N	\N	\N	SANTAFE	\N	\N	ARGENTINA	0101000020E61000000000006055D54EC0000000A0991940C0
1244	stations:397	EZEIZA AERO                             	-34.8166656	-58.5333328	0	\N	\N	\N	\N	\N	\N	\N	BUENOSAIRES	\N	\N	ARGENTINA	0101000020E61000000000004044444DC000000080886841C0
1245	stations:398	JUNIN AERO                              	-34.5499992	-60.9166679	0	\N	\N	\N	\N	\N	\N	\N	BUENOSAIRES	\N	\N	ARGENTINA	0101000020E61000000000006055754EC000000060664641C0
1246	stations:399	LABOULAYE AERO                          	-34.1333351	-63.3666649	0	\N	\N	\N	\N	\N	\N	\N	CORDOBA	\N	\N	ARGENTINA	0101000020E6100000000000E0EEAE4FC000000020111141C0
1247	stations:400	LAS FLORES AERO                         	-36.0333328	-59.1333351	0	\N	\N	\N	\N	\N	\N	\N	BUENOSAIRES	\N	\N	ARGENTINA	0101000020E61000000000002011914DC000000040440442C0
1248	stations:401	NUEVE DE JULIO                          	-35.4500008	-60.8833351	0	\N	\N	\N	\N	\N	\N	\N	BUENOSAIRES	\N	\N	ARGENTINA	0101000020E61000000000002011714EC0000000A099B941C0
1249	stations:402	PARANA AERO                             	-31.7833328	-60.4833336	0	\N	\N	\N	\N	\N	\N	\N	ENTRERIOS	\N	\N	ARGENTINA	0101000020E6100000000000E0DD3D4EC00000008088C83FC0
1250	stations:403	PIGUE AERO                              	-37.5999985	-62.3833351	0	\N	\N	\N	\N	\N	\N	\N	BUENOSAIRES	\N	\N	ARGENTINA	0101000020E61000000000002011314FC0000000C0CCCC42C0
1251	stations:404	PUNTA INDIO B.A.                        	-35.3666649	-57.2833328	0	\N	\N	\N	\N	\N	\N	\N	BUENOSAIRES	\N	\N	ARGENTINA	0101000020E61000000000004044A44CC0000000E0EEAE41C0
1252	stations:405	RIO CUARTO AERO                         	-33.1166649	-64.2333298	0	\N	\N	\N	\N	\N	\N	\N	CORDOBA	\N	\N	ARGENTINA	0101000020E6100000000000E0EE0E50C0000000E0EE8E40C0
1253	red_inta:789	El Palmar - Ubicada en Parque Nac. El Palmar	-31.8640003	-58.2589989	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E6100000000000E026214DC0000000202FDD3FC0
1254	red_inta:790	El Portezuelo - EEA La Rioja - AER El Portezuelo	-30.8360004	-66.6969986	0	\N	\N	\N	\N	\N	\N	\N	La Rioja	\N	\N	ARGENTINA	0101000020E6100000000000A09BAC50C00000002004D63EC0
1255	red_inta:791	El Potrero - EEA Yuto - Predio Empresa CITRUSALTA S.A.	-23.4710007	-64.3830032	0	\N	\N	\N	\N	\N	\N	\N	Salta	\N	\N	ARGENTINA	0101000020E610000000000020831850C000000080937837C0
1256	red_inta:792	Esquina - Predio del Aero Club Esquina	-30.0389996	-59.5330009	0	\N	\N	\N	\N	\N	\N	\N	Corrientes	\N	\N	ARGENTINA	0101000020E61000000000006039C44DC0000000E0FB093EC0
1257	red_inta:793	Federal - Parcela frutal de experimental Va. Federal	-30.9290009	-58.7729988	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E6100000000000A0F1624DC000000000D3ED3EC0
1258	red_inta:794	Ferre - EEA Pergamino - Escuela Agrotecnica Salesiana de Ferre	-34.0999985	-61.1399994	0	\N	\N	\N	\N	\N	\N	\N	Buenos Aires	\N	\N	ARGENTINA	0101000020E610000000000080EB914EC0000000C0CC0C41C0
1259	red_inta:795	General Campos - Predio productor arrocero	-31.5300007	-58.4039993	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E610000000000040B6334DC000000020AE873FC0
1260	red_inta:796	Goya - Escuela de la Familia Agricola Coembota IS 16	-29.1779995	-59.0919991	0	\N	\N	\N	\N	\N	\N	\N	Corrientes	\N	\N	ARGENTINA	0101000020E6100000000000A0C68B4DC000000060912D3DC0
1261	red_inta:1347	Arroyo BarÃº	-31.8500004	-58.4700012	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E610000000000000293C4DC0000000A099D93FC0
1262	red_inta:1348	Arroyo del Medio	-31.3099995	-59.0900002	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E610000000000020858B4DC0000000205C4F3FC0
1263	red_inta:1349	Atencio	-30.6599998	-58.7700005	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E6100000000000608F624DC0000000C0F5A83EC0
1264	red_inta:1350	Colonia Celina	-31.6200008	-60.3100014	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E610000000000020AE274EC000000060B89E3FC0
1265	red_inta:1351	Bariloche - EEA Bariloche	-41.1199989	-71.25	0	\N	\N	\N	\N	\N	\N	\N	RÃ­o Negro	\N	\N	ARGENTINA	0101000020E61000000000000000D051C0000000205C8F44C0
1266	red_inta:1352	Basavilbaso	-32.3800011	-58.8800011	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E6100000000000E0A3704DC0000000E0A33040C0
1267	stations:421	HILARIO ASCASUBI (EMC) - HILARIO ASCASUBI EEA INTA	-39.3800011	-62.6199989	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	ARGENTINA	0101000020E6100000000000205C4F4FC0000000E0A3B043C0
1268	stations:422	MANFREDI (EMC) - MANFREDI EEA INTA	-31.8199997	-63.7700005	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	ARGENTINA	0101000020E6100000000000608FE24FC000000080EBD13FC0
1269	stations:423	MARCOS JUAREZ (EMC) - MARCOS JUAREZ EEA INTA	-32.6800003	-62.1199989	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	ARGENTINA	0101000020E6100000000000205C0F4FC0000000400A5740C0
1270	stations:424	OLIVEROS (EMC) - OLIVEROS EEA INTA	-32.5499992	-60.8499985	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	ARGENTINA	0101000020E6100000000000C0CC6C4EC000000060664640C0
1271	stations:425	PARANA (EMC) - PARANÃ EEA INTA	-31.8490009	-60.5359993	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	ARGENTINA	0101000020E6100000000000A09B444EC00000002058D93FC0
1272	stations:426	PERGAMINO (EMC) - PERGAMINO EEA INTA	-33.9300003	-60.5499992	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	ARGENTINA	0101000020E61000000000006066464EC0000000400AF740C0
1273	stations:427	RAFAELA (EMC) - RAFAELA EEA INTA	-31.1800003	-61.5499992	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	ARGENTINA	0101000020E61000000000006066C64EC000000080142E3FC0
1274	red_inta:1353	Basualdo	-30.2900009	-58.6599998	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E6100000000000E07A544DC0000000803D4A3EC0
1275	red_inta:1354	Bella Vista - EEA Bella Vista	-28.4500008	-58.9900017	0	\N	\N	\N	\N	\N	\N	\N	Corrientes	\N	\N	ARGENTINA	0101000020E610000000000060B87E4DC00000004033733CC0
1276	red_inta:1355	Berduc	-31.9400005	-58.2999992	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E61000000000006066264DC0000000E0A3F03FC0
1277	stations:523	Pres. Roque SÃ¡enz PeÃ±a INTA	-26.8700008	-60.4500008	0	\N	\N	\N	\N	\N	\N	\N	CHACO	\N	\N	ARGENTINA	0101000020E6100000000000A099394EC000000060B8DE3AC0
1278	red_inta:1356	BerÃ³n de Astrada	-27.4200001	-57.6399994	0	\N	\N	\N	\N	\N	\N	\N	Corrientes	\N	\N	ARGENTINA	0101000020E610000000000080EBD14CC000000020856B3BC0
1279	red_inta:1357	Bodegas Etchart	-26.1000004	-65.9700012	0	\N	\N	\N	\N	\N	\N	\N	Salta	\N	\N	ARGENTINA	0101000020E610000000000080147E50C0000000A099193AC0
1280	red_inta:1358	Bordo	-24.6599998	-65.1100006	0	\N	\N	\N	\N	\N	\N	\N	Salta	\N	\N	ARGENTINA	0101000020E6100000000000400A4750C0000000C0F5A838C0
1281	red_inta:1359	Buenaventura	-24.9799995	-64.3700027	0	\N	\N	\N	\N	\N	\N	\N	Salta	\N	\N	ARGENTINA	0101000020E610000000000020AE1750C000000040E1FA38C0
1282	stations:525	Villa Mercedes INTA	-33.7200012	-65.4800034	0	\N	\N	\N	\N	\N	\N	\N	SANLUIS	\N	\N	ARGENTINA	0101000020E610000000000060B85E50C00000000029DC40C0
1283	red_inta:1360	C. A. Cordero - EEA Alto Valle	-38.7400017	-68.1100006	0	\N	\N	\N	\N	\N	\N	\N	RÃ­o Negro	\N	\N	ARGENTINA	0101000020E6100000000000400A0751C000000060B85E43C0
1284	red_inta:1361	CabaÃ±a El Paraiso	-29.6900005	-58.2900009	0	\N	\N	\N	\N	\N	\N	\N	Corrientes	\N	\N	ARGENTINA	0101000020E6100000000000C01E254DC0000000E0A3B03DC0
1285	red_inta:1363	Calchaqui - EEA Reconquista	-29.8799992	-60.2400017	0	\N	\N	\N	\N	\N	\N	\N	Santa Fe	\N	\N	ARGENTINA	0101000020E610000000000060B81E4EC0000000A047E13DC0
1286	red_inta:1364	Calingasta - EEA San Juan	-31.6200008	-69.4599991	0	\N	\N	\N	\N	\N	\N	\N	San Juan	\N	\N	ARGENTINA	0101000020E6100000000000A0705D51C000000060B89E3FC0
1287	red_inta:1365	Capilla de Siton - ICyA CIRN	-30.5699997	-63.6500015	0	\N	\N	\N	\N	\N	\N	\N	CÃ³rdoba	\N	\N	ARGENTINA	0101000020E61000000000004033D34FC000000080EB913EC0
1288	red_inta:1366	Capilla del Monte (EMC)	-30.8700008	-64.5500031	0	\N	\N	\N	\N	\N	\N	\N	CÃ³rdoba	\N	\N	ARGENTINA	0101000020E610000000000040332350C000000060B8DE3EC0
1289	stations:416	BORDENAVE (EMC) - BORDENAVE EEA INTA	-37.8499985	-63.0200005	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	ARGENTINA	0101000020E6100000000000608F824FC0000000C0CCEC42C0
1290	red_inta:1367	Catuna - EEA La Rioja	-30.9599991	-66.1699982	0	\N	\N	\N	\N	\N	\N	\N	La Rioja	\N	\N	ARGENTINA	0101000020E610000000000040E18A50C000000080C2F53EC0
1291	red_inta:1368	Caucete - EEA San Juan	-31.7000008	-68.2900009	0	\N	\N	\N	\N	\N	\N	\N	San Juan	\N	\N	ARGENTINA	0101000020E6100000000000608F1251C00000004033B33FC0
1292	red_inta:1369	CaÃ±ada Ombu - EEA Reconquista	-28.3600006	-60.1500015	0	\N	\N	\N	\N	\N	\N	\N	Santa Fe	\N	\N	ARGENTINA	0101000020E61000000000004033134EC000000000295C3CC0
1293	red_inta:1370	CaÃ±ada Seca - EEA Villegas	-34.5499992	-62.9000015	0	\N	\N	\N	\N	\N	\N	\N	Buenos Aires	\N	\N	ARGENTINA	0101000020E61000000000004033734FC000000060664641C0
1294	red_inta:1371	CE.TE.PRO.	-27.4699993	-58.7799988	0	\N	\N	\N	\N	\N	\N	\N	Corrientes	\N	\N	ARGENTINA	0101000020E610000000000000D7634DC0000000E051783BC0
1295	red_inta:1372	CEAGRO	-29.5599995	-58.0900002	0	\N	\N	\N	\N	\N	\N	\N	Corrientes	\N	\N	ARGENTINA	0101000020E610000000000020850B4DC0000000205C8F3DC0
1296	stations:511	Mercedes INTA (Ctes.)	-29.1700001	-58.0200005	0	\N	\N	\N	\N	\N	\N	\N	CORRIENTES	\N	\N	ARGENTINA	0101000020E6100000000000608F024DC000000020852B3DC0
1297	red_inta:1373	Centro de ConservaciÃ³n	-27.3400002	-58.5999985	0	\N	\N	\N	\N	\N	\N	\N	Corrientes	\N	\N	ARGENTINA	0101000020E6100000000000C0CC4C4DC0000000400A573BC0
1298	red_inta:1374	Ceres - EEA Rafaela	-29.8700008	-61.9599991	0	\N	\N	\N	\N	\N	\N	\N	Santa Fe	\N	\N	ARGENTINA	0101000020E610000000000040E1FA4EC000000060B8DE3DC0
1299	red_inta:1375	Cerrito	-31.5900002	-60.0800018	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E6100000000000803D0A4EC0000000400A973FC0
1300	red_inta:1376	Chacra 25 de Julio	-43.4000015	-65.8199997	0	\N	\N	\N	\N	\N	\N	\N	Chubut	\N	\N	ARGENTINA	0101000020E6100000000000E07A7450C00000004033B345C0
1301	red_inta:1377	ChajarÃ­	-30.7399998	-58.0099983	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E6100000000000A047014DC0000000A070BD3EC0
1302	red_inta:1378	Chascomus - EEA Cuenca Salado	-35.7400017	-58.0499992	0	\N	\N	\N	\N	\N	\N	\N	Buenos Aires	\N	\N	ARGENTINA	0101000020E61000000000006066064DC000000060B8DE41C0
1303	stations:510	Cerro Azul INTA	-27.6499996	-55.4300003	0	\N	\N	\N	\N	\N	\N	\N	MISIONES	\N	\N	ARGENTINA	0101000020E6100000000000400AB74BC00000006066A63BC0
1304	red_inta:802	INTA - Escuela Macia - Escuela Agrotecnica G. Macia	-32.1580009	-59.394001	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E6100000000000A06EB24DC000000060391440C0
1305	red_inta:788	El Colorado - El Colorado EEA INTA	-26.3279991	-59.348999	0	\N	\N	\N	\N	\N	\N	\N	Formosa	\N	\N	ARGENTINA	0101000020E610000000000000ACAC4DC0000000C0F7533AC0
1306	red_inta:1404	El Remanso	-29.9899998	-58.3800011	0	\N	\N	\N	\N	\N	\N	\N	Corrientes	\N	\N	ARGENTINA	0101000020E6100000000000E0A3304DC0000000A070FD3DC0
1307	red_inta:1379	Chavarria	-28.8700008	-58.4599991	0	\N	\N	\N	\N	\N	\N	\N	Corrientes	\N	\N	ARGENTINA	0101000020E610000000000040E13A4DC000000060B8DE3CC0
1308	red_inta:1381	Colonia Carlos Pellegrini	-28.5499992	-57.2000008	0	\N	\N	\N	\N	\N	\N	\N	Corrientes	\N	\N	ARGENTINA	0101000020E6100000000000A099994CC0000000C0CC8C3CC0
1309	red_inta:1382	Colonia Carrasco	-31.3199997	-59.5900002	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E61000000000002085CB4DC000000080EB513FC0
1310	red_inta:1383	Colonia Catalina	-31.5100002	-58.5499992	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E61000000000006066464DC0000000608F823FC0
1311	red_inta:1384	Colonia San Carlos	-31.1900005	-59.5200005	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E6100000000000608FC24DC0000000E0A3303FC0
1312	red_inta:1385	Colonia Santa Lucia	-30.8799992	-58.5099983	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E6100000000000A047414DC0000000A047E13EC0
1313	red_inta:1386	ColÃ³n	-32.25	-58.1500015	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E61000000000004033134DC000000000002040C0
1314	red_inta:1387	Comandante Fontana	-25.3600006	-59.6899986	0	\N	\N	\N	\N	\N	\N	\N	Formosa	\N	\N	ARGENTINA	0101000020E6100000000000E051D84DC000000000295C39C0
1315	red_inta:1388	Coopecicor	-30.6200008	-57.9799995	0	\N	\N	\N	\N	\N	\N	\N	Corrientes	\N	\N	ARGENTINA	0101000020E6100000000000A070FD4CC000000060B89E3EC0
1316	red_inta:1389	Corrales	-32.5699997	-60.0900002	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E610000000000020850B4EC0000000C0F54840C0
1317	red_inta:1390	Crespo	-32.0699997	-60.25	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E61000000000000000204EC0000000C0F50840C0
1318	red_inta:1391	Crucecita 7ma.	-31.9699993	-59.8499985	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E6100000000000C0CCEC4DC0000000E051F83FC0
1319	red_inta:1392	Crucecita Tercera	-32.2099991	-59.6699982	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E610000000000080C2D54DC000000040E11A40C0
1320	red_inta:1393	Cuchilla	-33.0400009	-59.4399986	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E6100000000000E051B84DC0000000C01E8540C0
1321	red_inta:1394	Curuzu Cuatia (Aeropuerto)	-29.75	-57.9799995	0	\N	\N	\N	\N	\N	\N	\N	Corrientes	\N	\N	ARGENTINA	0101000020E6100000000000A070FD4CC00000000000C03DC0
1322	red_inta:1395	De La Garma - ICyA CIRN	-37.8400002	-60.3899994	0	\N	\N	\N	\N	\N	\N	\N	Buenos Aires	\N	\N	ARGENTINA	0101000020E610000000000080EB314EC00000002085EB42C0
1323	red_inta:1396	Dean Funes - EEA Manfredi	-30.3400002	-64.3199997	0	\N	\N	\N	\N	\N	\N	\N	CÃ³rdoba	\N	\N	ARGENTINA	0101000020E6100000000000E07A1450C0000000400A573EC0
1324	red_inta:1397	Derqui	-27.8299999	-58.7900009	0	\N	\N	\N	\N	\N	\N	\N	Corrientes	\N	\N	ARGENTINA	0101000020E6100000000000C01E654DC0000000E07AD43BC0
1325	red_inta:1398	Diamante (Ejido)	-32.1300011	-60.5299988	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E610000000000000D7434EC0000000E0A31040C0
1326	red_inta:1399	Don Cristobal 2da.	-32.0699997	-60	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E61000000000000000004EC0000000C0F50840C0
1327	red_inta:1400	Du Graty - EEA SÃ¡enz PeÃ±a	-27.7000008	-60.9099998	0	\N	\N	\N	\N	\N	\N	\N	Chaco	\N	\N	ARGENTINA	0101000020E6100000000000E07A744EC00000004033B33BC0
1328	red_inta:1405	Esperanza - EEA Santa Cruz	-51.0999985	-70.5	0	\N	\N	\N	\N	\N	\N	\N	Santa Cruz	\N	\N	ARGENTINA	0101000020E61000000000000000A051C0000000C0CC8C49C0
1329	red_inta:1406	Est. Torrent - EEA Mercedes	-28.7999992	-56.5	0	\N	\N	\N	\N	\N	\N	\N	Corrientes	\N	\N	ARGENTINA	0101000020E61000000000000000404CC0000000C0CCCC3CC0
1330	red_inta:1407	Estacas	-30.5900002	-59.2299995	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E6100000000000A0709D4DC0000000400A973EC0
1331	red_inta:1408	Estancia Puerto Valle	-27.6100006	-56.4399986	0	\N	\N	\N	\N	\N	\N	\N	Corrientes	\N	\N	ARGENTINA	0101000020E6100000000000E051384CC000000000299C3BC0
1332	red_inta:1409	Estancia San Nicolas	-27.8700008	-57.3899994	0	\N	\N	\N	\N	\N	\N	\N	Corrientes	\N	\N	ARGENTINA	0101000020E610000000000080EBB14CC000000060B8DE3BC0
1333	red_inta:1410	Famailla - EEA Famailla	-27.0200005	-65.3799973	0	\N	\N	\N	\N	\N	\N	\N	Tucuman	\N	\N	ARGENTINA	0101000020E6100000000000E0515850C0000000C01E053BC0
1334	red_inta:1411	FederaciÃ³n	-31.0599995	-57.9199982	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E610000000000080C2F54CC0000000205C0F3FC0
1335	red_inta:1412	Federal	-30.9300003	-58.7900009	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E6100000000000C01E654DC00000008014EE3EC0
1336	red_inta:1413	Feliciano	-30.4300003	-58.7700005	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E6100000000000608F624DC000000080146E3EC0
1337	red_inta:1414	G Conesa - EEA Valle Inferior	-40.0699997	-64.6100006	0	\N	\N	\N	\N	\N	\N	\N	RÃ­o Negro	\N	\N	ARGENTINA	0101000020E6100000000000400A2750C0000000C0F50844C0
1338	red_inta:1415	Galarza	-32.7200012	-59.3800011	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E6100000000000E0A3B04DC000000000295C40C0
1339	red_inta:1416	Gancedo - EEA Las BreÃ±as	-27.4799995	-61.6599998	0	\N	\N	\N	\N	\N	\N	\N	Chaco	\N	\N	ARGENTINA	0101000020E6100000000000E07AD44EC000000040E17A3BC0
1340	red_inta:1418	Garabato - EEA Reconquista	-28.8899994	-60.1899986	0	\N	\N	\N	\N	\N	\N	\N	Santa Fe	\N	\N	ARGENTINA	0101000020E6100000000000E051184EC000000000D7E33CC0
1341	red_inta:1419	General Paz (CaÃ¡ CatÃ­)	-27.7199993	-57.5999985	0	\N	\N	\N	\N	\N	\N	\N	Corrientes	\N	\N	ARGENTINA	0101000020E6100000000000C0CCCC4CC0000000E051B83BC0
1342	red_inta:1420	Goya - EEA Bella Vista	-29.1800003	-59.0900002	0	\N	\N	\N	\N	\N	\N	\N	Corrientes	\N	\N	ARGENTINA	0101000020E610000000000020858B4DC000000080142E3DC0
1343	alturas_bdhi:120	Paso TelÃ©grafo	-30.34375	-59.5129738	0	\N	\N	\N	\N	\N	\N	\N	ENTRERIOS	\N	\N	ARGENTINA	0101000020E610000000000020A9C14DC00000000000583EC0
1344	red_inta:1421	Gral San Martin - EEA Anguil	-38	-63.5200005	0	\N	\N	\N	\N	\N	\N	\N	La Pampa	\N	\N	ARGENTINA	0101000020E6100000000000608FC24FC000000000000043C0
1345	red_inta:1422	Gral. Roca - EEA Alto Valle	-39.0299988	-67.7399979	0	\N	\N	\N	\N	\N	\N	\N	RÃ­o Negro	\N	\N	ARGENTINA	0101000020E6100000000000205CEF50C000000000D78343C0
1346	red_inta:1423	Gualeguay	-33.0999985	-59.2999992	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E61000000000006066A64DC0000000C0CC8C40C0
1347	red_inta:1424	Gualeguaychu	-33.0299988	-58.6199989	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E6100000000000205C4F4DC000000000D78340C0
1348	red_inta:1425	Gualjaina - EEA Esquel	-42.7299995	-70.5	0	\N	\N	\N	\N	\N	\N	\N	Chubut	\N	\N	ARGENTINA	0101000020E61000000000000000A051C0000000A0705D45C0
1349	red_inta:1426	GuayquirarÃ³	-30.2900009	-59.4500008	0	\N	\N	\N	\N	\N	\N	\N	Corrientes	\N	\N	ARGENTINA	0101000020E6100000000000A099B94DC0000000803D4A3EC0
1350	red_inta:1427	Hasenkamp	-31.5200005	-59.8400002	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E61000000000002085EB4DC0000000C01E853FC0
1351	red_inta:1428	Herliszka - EEA Corrientes	-27.6200008	-58.3699989	0	\N	\N	\N	\N	\N	\N	\N	Corrientes	\N	\N	ARGENTINA	0101000020E6100000000000205C2F4DC000000060B89E3BC0
1352	red_inta:1429	Hernandarias	-31.2000008	-59.9700012	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E61000000000000029FC4DC00000004033333FC0
1353	red_inta:1430	Hinojal	-32.3800011	-60.1699982	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E610000000000080C2154EC0000000E0A33040C0
1354	red_inta:1431	Hornillos - IPAF NOA	-23.6599998	-65.4300003	0	\N	\N	\N	\N	\N	\N	\N	Jujuy	\N	\N	ARGENTINA	0101000020E610000000000020855B50C0000000C0F5A837C0
1355	red_inta:1432	Humaita	-31.7999992	-58.1899986	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E6100000000000E051184DC0000000C0CCCC3FC0
1356	red_inta:1433	Ibicuy-Copra	-29.1700001	-57.9599991	0	\N	\N	\N	\N	\N	\N	\N	Corrientes	\N	\N	ARGENTINA	0101000020E610000000000040E1FA4CC000000020852B3DC0
1357	red_inta:1434	IDEVI - EEA Valle Inferior	-40.7099991	-63.5299988	0	\N	\N	\N	\N	\N	\N	\N	RÃ­o Negro	\N	\N	ARGENTINA	0101000020E610000000000000D7C34FC000000040E15A44C0
1358	red_inta:1435	Ing. Jacobacci - EEA Bariloche	-41.3300018	-69.5500031	0	\N	\N	\N	\N	\N	\N	\N	RÃ­o Negro	\N	\N	ARGENTINA	0101000020E610000000000040336351C0000000803DAA44C0
1359	red_inta:1436	Ing. JuÃ¡rez - EEA Ing. JuÃ¡rez	-23.9500008	-61.75	0	\N	\N	\N	\N	\N	\N	\N	Formosa	\N	\N	ARGENTINA	0101000020E61000000000000000E04EC00000004033F337C0
1360	red_inta:1437	INTA - 9 de Julio (Imetos)	-35.4599991	-60.9500008	0	\N	\N	\N	\N	\N	\N	\N	Buenos Aires	\N	\N	ARGENTINA	0101000020E6100000000000A099794EC000000040E1BA41C0
1361	red_inta:1438	INTA - Abra Pampa (EMC)	-22.8299999	-65.8499985	0	\N	\N	\N	\N	\N	\N	\N	Jujuy	\N	\N	ARGENTINA	0101000020E610000000000060667650C0000000E07AD436C0
1362	red_inta:1439	INTA - Alpachiri (Imetos)	-37.3699989	-63.7700005	0	\N	\N	\N	\N	\N	\N	\N	La Pampa	\N	\N	ARGENTINA	0101000020E6100000000000608FE24FC0000000205CAF42C0
1363	red_inta:1440	INTA - Alto Valle (EMC)	-39.0099983	-67.4000015	0	\N	\N	\N	\N	\N	\N	\N	RÃ­o Negro	\N	\N	ARGENTINA	0101000020E6100000000000A099D950C0000000A0478143C0
1364	red_inta:1441	INTA - Anguil (EMC)	-36.5	-63.9799995	0	\N	\N	\N	\N	\N	\N	\N	La Pampa	\N	\N	ARGENTINA	0101000020E6100000000000A070FD4FC000000000004042C0
1365	red_inta:1442	INTA - AÃ±atuya	-28.4500008	-62.8300018	0	\N	\N	\N	\N	\N	\N	\N	Santiago del Estero	\N	\N	ARGENTINA	0101000020E6100000000000803D6A4FC00000004033733CC0
1366	red_inta:1443	INTA - Balcarce (EMC)	-37.75	-58.2999992	0	\N	\N	\N	\N	\N	\N	\N	Buenos Aires	\N	\N	ARGENTINA	0101000020E61000000000006066264DC00000000000E042C0
1367	red_inta:1444	INTA - Barrow (EMC)	-38.3199997	-60.25	0	\N	\N	\N	\N	\N	\N	\N	Buenos Aires	\N	\N	ARGENTINA	0101000020E61000000000000000204EC0000000C0F52843C0
1368	red_inta:1445	INTA - Basavilbaso	-32.3699989	-58.8899994	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E610000000000080EB714DC0000000205C2F40C0
1369	red_inta:1446	INTA - Bella Vista	-28.4500008	-58.9900017	0	\N	\N	\N	\N	\N	\N	\N	Corrientes	\N	\N	ARGENTINA	0101000020E610000000000060B87E4DC00000004033733CC0
1370	red_inta:1447	INTA - Bella Vista (EMC)	-28.4300003	-58.9199982	0	\N	\N	\N	\N	\N	\N	\N	Corrientes	\N	\N	ARGENTINA	0101000020E610000000000080C2754DC000000080146E3CC0
1371	red_inta:1448	INTA - Bordenave (EMC)	-37.8499985	-63.0200005	0	\N	\N	\N	\N	\N	\N	\N	Buenos Aires	\N	\N	ARGENTINA	0101000020E6100000000000608F824FC0000000C0CCEC42C0
1372	red_inta:1449	INTA - Calafate	-50.3400002	-72.2799988	0	\N	\N	\N	\N	\N	\N	\N	Santa Cruz	\N	\N	ARGENTINA	0101000020E610000000000080EB1152C000000020852B49C0
1373	red_inta:1450	INTA - Castelar (EMC)	-34.6100006	-58.6699982	0	\N	\N	\N	\N	\N	\N	\N	Buenos Aires	\N	\N	ARGENTINA	0101000020E610000000000080C2554DC000000080144E41C0
1374	red_inta:1451	INTA - Catamarca Sumalao (EMC)	-28.4799995	-65.7300034	0	\N	\N	\N	\N	\N	\N	\N	Catamarca	\N	\N	ARGENTINA	0101000020E610000000000060B86E50C000000040E17A3CC0
1375	red_inta:1452	INTA - Cerrillos	-24.8899994	-65.4700012	0	\N	\N	\N	\N	\N	\N	\N	Salta	\N	\N	ARGENTINA	0101000020E610000000000080145E50C000000000D7E338C0
1376	red_inta:1453	INTA - Chubut	-43.2700005	-65.3600006	0	\N	\N	\N	\N	\N	\N	\N	Chubut	\N	\N	ARGENTINA	0101000020E6100000000000400A5750C0000000608FA245C0
1377	red_inta:1454	INTA - Cinco Saltos	-38.8400002	-68.0699997	0	\N	\N	\N	\N	\N	\N	\N	RÃ­o Negro	\N	\N	ARGENTINA	0101000020E6100000000000E07A0451C000000020856B43C0
1378	red_inta:1455	INTA - Colonia Benitez (EMC)	-27.4200001	-58.9300003	0	\N	\N	\N	\N	\N	\N	\N	Chaco	\N	\N	ARGENTINA	0101000020E6100000000000400A774DC000000020856B3BC0
1379	red_inta:1456	INTA - Conc. del Uruguay (EMC)	-32.4900017	-58.3499985	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E6100000000000C0CC2C4DC000000060B83E40C0
1380	red_inta:1457	INTA - Concordia (EMC)	-31.3799992	-58.0299988	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E610000000000000D7034DC0000000A047613FC0
1381	red_inta:1468	INTA - Hernando	-32.3699989	-63.7999992	0	\N	\N	\N	\N	\N	\N	\N	CÃ³rdoba	\N	\N	ARGENTINA	0101000020E61000000000006066E64FC0000000205C2F40C0
1382	red_inta:1458	INTA - Consorcio de SG	-39.3199997	-65.75	0	\N	\N	\N	\N	\N	\N	\N	RÃ­o Negro	\N	\N	ARGENTINA	0101000020E610000000000000007050C0000000C0F5A843C0
1383	red_inta:1459	INTA - Contralmirante Guerrico	-39.0200005	-67.6699982	0	\N	\N	\N	\N	\N	\N	\N	RÃ­o Negro	\N	\N	ARGENTINA	0101000020E610000000000040E1EA50C0000000608F8243C0
1384	red_inta:1460	INTA - Coronel Belisle	-39.2000008	-65.8899994	0	\N	\N	\N	\N	\N	\N	\N	RÃ­o Negro	\N	\N	ARGENTINA	0101000020E6100000000000C0F57850C0000000A0999943C0
1385	red_inta:1461	INTA - Corrientes (EMC)	-27.6499996	-58.7700005	0	\N	\N	\N	\N	\N	\N	\N	Corrientes	\N	\N	ARGENTINA	0101000020E6100000000000608F624DC00000006066A63BC0
1386	red_inta:1462	INTA - El Colorado (EMC)	-26.2999992	-59.3800011	0	\N	\N	\N	\N	\N	\N	\N	Formosa	\N	\N	ARGENTINA	0101000020E6100000000000E0A3B04DC0000000C0CC4C3AC0
1387	red_inta:1463	INTA - Famailla (DAVIS)	-27.0499992	-65.4199982	0	\N	\N	\N	\N	\N	\N	\N	Tucuman	\N	\N	ARGENTINA	0101000020E610000000000040E15A50C0000000C0CC0C3BC0
1388	red_inta:1464	INTA - Famailla (EMC)	-27.0499992	-65.4199982	0	\N	\N	\N	\N	\N	\N	\N	Tucuman	\N	\N	ARGENTINA	0101000020E610000000000040E15A50C0000000C0CC0C3BC0
1389	red_inta:1465	INTA - General Galarza	-32.7200012	-59.3899994	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E610000000000080EBB14DC000000000295C40C0
1390	red_inta:1466	INTA - Gral Pico (EMC)	-35.6699982	-63.75	0	\N	\N	\N	\N	\N	\N	\N	La Pampa	\N	\N	ARGENTINA	0101000020E61000000000000000E04FC000000080C2D541C0
1391	red_inta:1467	INTA - Gral Villegas (EMC)	-34.9199982	-62.7299995	0	\N	\N	\N	\N	\N	\N	\N	Buenos Aires	\N	\N	ARGENTINA	0101000020E6100000000000A0705D4FC000000080C27541C0
1392	red_inta:1469	INTA - Hilario Ascasubi	-39.3800011	-62.6199989	0	\N	\N	\N	\N	\N	\N	\N	Buenos Aires	\N	\N	ARGENTINA	0101000020E6100000000000205C4F4FC0000000E0A3B043C0
1393	red_inta:1470	INTA - Hilario Ascasubi (EMC)	-39.3800011	-62.6199989	0	\N	\N	\N	\N	\N	\N	\N	Buenos Aires	\N	\N	ARGENTINA	0101000020E6100000000000205C4F4FC0000000E0A3B043C0
1394	red_inta:1471	INTA - Intendente Alvear	-35.2400017	-63.5900002	0	\N	\N	\N	\N	\N	\N	\N	La Pampa	\N	\N	ARGENTINA	0101000020E61000000000002085CB4FC000000060B89E41C0
1395	red_inta:1472	INTA - La Abrita	-28.0200005	-64.2200012	0	\N	\N	\N	\N	\N	\N	\N	Santiago del Estero	\N	\N	ARGENTINA	0101000020E610000000000080140E50C0000000C01E053CC0
1396	red_inta:1473	INTA - La Consulta (EMC)	-33.7299995	-69.1200027	0	\N	\N	\N	\N	\N	\N	\N	Mendoza	\N	\N	ARGENTINA	0101000020E610000000000020AE4751C0000000A070DD40C0
1397	red_inta:1474	INTA - La Maria S.Estero (EMC)	-28.0200005	-64.2300034	0	\N	\N	\N	\N	\N	\N	\N	Santiago del Estero	\N	\N	ARGENTINA	0101000020E610000000000060B80E50C0000000C01E053CC0
1398	red_inta:1475	INTA - Lago Posadas	-47.5699997	-71.7399979	0	\N	\N	\N	\N	\N	\N	\N	Santa Cruz	\N	\N	ARGENTINA	0101000020E6100000000000205CEF51C0000000C0F5C847C0
1399	red_inta:1476	INTA - Las BreÃ±as	-27.0699997	-61.0600014	0	\N	\N	\N	\N	\N	\N	\N	Chaco	\N	\N	ARGENTINA	0101000020E610000000000020AE874EC000000080EB113BC0
1400	red_inta:1477	INTA - Los Antiguos	-46.5299988	-71.6299973	0	\N	\N	\N	\N	\N	\N	\N	Santa Cruz	\N	\N	ARGENTINA	0101000020E6100000000000E051E851C000000000D74347C0
1401	red_inta:1478	INTA - Malbran	-29.3500004	-62.4399986	0	\N	\N	\N	\N	\N	\N	\N	Santiago del Estero	\N	\N	ARGENTINA	0101000020E6100000000000E051384FC0000000A099593DC0
1402	red_inta:1479	INTA - Marcos Juarez (EMC)	-32.6800003	-62.1199989	0	\N	\N	\N	\N	\N	\N	\N	CÃ³rdoba	\N	\N	ARGENTINA	0101000020E6100000000000205C0F4FC0000000400A5740C0
1403	red_inta:1480	INTA - Mendoza (EMC)	-33.1500015	-68.4700012	0	\N	\N	\N	\N	\N	\N	\N	Mendoza	\N	\N	ARGENTINA	0101000020E610000000000080141E51C000000040339340C0
1404	red_inta:1481	INTA - Mercedes Ctes (EMC)	-29.1700001	-58.0200005	0	\N	\N	\N	\N	\N	\N	\N	Corrientes	\N	\N	ARGENTINA	0101000020E6100000000000608F024DC000000020852B3DC0
1405	red_inta:1482	INTA - Naineck	-25.2000008	-58.1199989	0	\N	\N	\N	\N	\N	\N	\N	Formosa	\N	\N	ARGENTINA	0101000020E6100000000000205C0F4DC000000040333339C0
1406	red_inta:1483	INTA - Oliveros (EMC)	-32.5499992	-60.8499985	0	\N	\N	\N	\N	\N	\N	\N	Santa Fe	\N	\N	ARGENTINA	0101000020E6100000000000C0CC6C4EC000000060664640C0
1407	red_inta:1484	INTA - Olleros	-25.1000004	-64.2300034	0	\N	\N	\N	\N	\N	\N	\N	Salta	\N	\N	ARGENTINA	0101000020E610000000000060B80E50C0000000A0991939C0
1408	red_inta:1485	INTA - Parana	-31.8600006	-60.5299988	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E610000000000000D7434EC00000000029DC3FC0
1409	red_inta:1486	INTA - Pergamino	-33.9399986	-60.5800018	0	\N	\N	\N	\N	\N	\N	\N	Buenos Aires	\N	\N	ARGENTINA	0101000020E6100000000000803D4A4EC0000000E051F840C0
1410	red_inta:1487	INTA - PicÃºn LeufÃº	-39.5400009	-69.3000031	0	\N	\N	\N	\N	\N	\N	\N	Neuquen	\N	\N	ARGENTINA	0101000020E610000000000040335351C0000000C01EC543C0
1411	red_inta:1488	INTA - Piquete Cavado	-24.8199997	-64.1800003	0	\N	\N	\N	\N	\N	\N	\N	Salta	\N	\N	ARGENTINA	0101000020E610000000000020850B50C000000080EBD138C0
1412	red_inta:1489	INTA - Pomona	-39.4799995	-65.6500015	0	\N	\N	\N	\N	\N	\N	\N	RÃ­o Negro	\N	\N	ARGENTINA	0101000020E6100000000000A0996950C0000000A070BD43C0
1413	red_inta:1490	INTA - Potrok Aike	-51.9500008	-70.4100037	0	\N	\N	\N	\N	\N	\N	\N	Santa Cruz	\N	\N	ARGENTINA	0101000020E6100000000000803D9A51C0000000A099F949C0
1414	red_inta:1491	INTA - R de la Frontera	-25.8199997	-64.9599991	0	\N	\N	\N	\N	\N	\N	\N	Salta	\N	\N	ARGENTINA	0101000020E6100000000000A0703D50C000000080EBD139C0
1415	red_inta:1492	INTA - Rafaela (EMC)	-31.1800003	-61.5499992	0	\N	\N	\N	\N	\N	\N	\N	Santa Fe	\N	\N	ARGENTINA	0101000020E61000000000006066C64EC000000080142E3FC0
1416	red_inta:1493	INTA - Rama CaÃ­da (EMC)	-34.6699982	-68.3799973	0	\N	\N	\N	\N	\N	\N	\N	Mendoza	\N	\N	ARGENTINA	0101000020E6100000000000E0511851C000000080C25541C0
1417	red_inta:1494	INTA - Reconquista (EMC)	-29.1800003	-59.7000008	0	\N	\N	\N	\N	\N	\N	\N	Santa Fe	\N	\N	ARGENTINA	0101000020E6100000000000A099D94DC000000080142E3DC0
1418	red_inta:1495	INTA - Roque Saenz PeÃ±a (EMC)	-26.8700008	-60.4500008	0	\N	\N	\N	\N	\N	\N	\N	Chaco	\N	\N	ARGENTINA	0101000020E6100000000000A099394EC000000060B8DE3AC0
1419	red_inta:1496	INTA - RÃ­o Gallegos	-51.6300011	-69.2300034	0	\N	\N	\N	\N	\N	\N	\N	Santa Cruz	\N	\N	ARGENTINA	0101000020E610000000000060B84E51C0000000E0A3D049C0
1420	red_inta:1497	INTA - Salta (EMC)	-24.8999996	-65.5	0	\N	\N	\N	\N	\N	\N	\N	Salta	\N	\N	ARGENTINA	0101000020E610000000000000006050C00000006066E638C0
1421	red_inta:1498	INTA - Salta Forestal	-24.9599991	-63.8499985	0	\N	\N	\N	\N	\N	\N	\N	Salta	\N	\N	ARGENTINA	0101000020E6100000000000C0CCEC4FC000000080C2F538C0
1422	red_inta:1499	INTA - San JosÃ© de Yatasto	-25.6000004	-64.9700012	0	\N	\N	\N	\N	\N	\N	\N	Salta	\N	\N	ARGENTINA	0101000020E610000000000080143E50C0000000A0999939C0
1423	red_inta:1500	INTA - San Juan (EMC)	-31.3700008	-68.3199997	0	\N	\N	\N	\N	\N	\N	\N	San Juan	\N	\N	ARGENTINA	0101000020E6100000000000E07A1451C000000060B85E3FC0
1424	red_inta:1501	INTA - San MartÃ­n	-22.5300007	-63.5200005	0	\N	\N	\N	\N	\N	\N	\N	Salta	\N	\N	ARGENTINA	0101000020E6100000000000608FC24FC000000020AE8736C0
1425	red_inta:1502	INTA - San Patricio	-38.5699997	-68.3600006	0	\N	\N	\N	\N	\N	\N	\N	Neuquen	\N	\N	ARGENTINA	0101000020E6100000000000400A1751C0000000C0F54843C0
1426	red_inta:1503	INTA - San Pedro	-33.7700005	-59.75	0	\N	\N	\N	\N	\N	\N	\N	Buenos Aires	\N	\N	ARGENTINA	0101000020E61000000000000000E04DC0000000608FE240C0
1427	red_inta:1504	INTA - Tostado	-29.1399994	-61.8400002	0	\N	\N	\N	\N	\N	\N	\N	Santa Fe	\N	\N	ARGENTINA	0101000020E61000000000002085EB4EC000000000D7233DC0
1428	red_inta:1505	INTA - Trelew (EMC)	-43.2299995	-65.3000031	0	\N	\N	\N	\N	\N	\N	\N	Chubut	\N	\N	ARGENTINA	0101000020E610000000000040335350C0000000A0709D45C0
1429	red_inta:1507	INTA - Yuto	-23.5900002	-64.5100021	0	\N	\N	\N	\N	\N	\N	\N	Jujuy	\N	\N	ARGENTINA	0101000020E6100000000000E0A32050C0000000400A9737C0
1430	red_inta:1508	INTA DELTA del Parana (EMC)	-34.1800003	-58.8600006	0	\N	\N	\N	\N	\N	\N	\N	Buenos Aires	\N	\N	ARGENTINA	0101000020E610000000000080146E4DC0000000400A1741C0
1431	red_inta:1509	Isla Apipe	-27.5100002	-56.7599983	0	\N	\N	\N	\N	\N	\N	\N	Corrientes	\N	\N	ARGENTINA	0101000020E6100000000000A047614CC0000000608F823BC0
1432	red_inta:1510	Isletas	-32.2200012	-60.3600006	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E610000000000080142E4EC000000000291C40C0
1433	red_inta:1511	Ita Ibate	-27.4400005	-57.3800011	0	\N	\N	\N	\N	\N	\N	\N	Corrientes	\N	\N	ARGENTINA	0101000020E6100000000000E0A3B04CC0000000E0A3703BC0
1434	red_inta:1512	Jubileo	-31.7099991	-58.6399994	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E610000000000080EB514DC000000080C2B53FC0
1435	red_inta:1513	JunÃ­n - EEA Junin Mendoza	-33.1199989	-68.4800034	0	\N	\N	\N	\N	\N	\N	\N	Mendoza	\N	\N	ARGENTINA	0101000020E610000000000060B81E51C0000000205C8F40C0
1436	red_inta:1514	La CigÃ¼eÃ±a - EEA Reconquista	-29.25	-61.0200005	0	\N	\N	\N	\N	\N	\N	\N	Santa Fe	\N	\N	ARGENTINA	0101000020E6100000000000608F824EC00000000000403DC0
1437	red_inta:1515	La Consulta - EEA Consulta	-33.7700005	-69.1500015	0	\N	\N	\N	\N	\N	\N	\N	Mendoza	\N	\N	ARGENTINA	0101000020E6100000000000A0994951C0000000608FE240C0
1438	red_inta:1516	La Criolla	-31.2999992	-58.0800018	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E6100000000000803D0A4DC0000000C0CC4C3FC0
1439	red_inta:1517	La Cruz	-29.1800003	-56.6699982	0	\N	\N	\N	\N	\N	\N	\N	Corrientes	\N	\N	ARGENTINA	0101000020E610000000000080C2554CC000000080142E3DC0
1440	red_inta:1518	La Guevarina - EEA Rama Caida	-34.7900009	-68.0199966	0	\N	\N	\N	\N	\N	\N	\N	Mendoza	\N	\N	ARGENTINA	0101000020E6100000000000A0470151C0000000C01E6541C0
1441	red_inta:1519	La Paz	-30.7999992	-59.5900002	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E61000000000002085CB4DC0000000C0CCCC3EC0
1442	red_inta:1520	La Paz 2	-30.7399998	-59.5600014	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E610000000000020AEC74DC0000000A070BD3EC0
1443	red_inta:1521	La Picada	-31.7099991	-60.3199997	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E6100000000000C0F5284EC000000080C2B53FC0
1444	red_inta:1522	Laguna Yema (DAVIS)	-24.2800007	-61.2400017	0	\N	\N	\N	\N	\N	\N	\N	Formosa	\N	\N	ARGENTINA	0101000020E610000000000060B89E4EC000000020AE4738C0
1445	red_inta:1523	Larroque	-33.0499992	-59.0099983	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E6100000000000A047814DC000000060668640C0
1446	red_inta:1524	Las Delicias	-31.9200001	-60.4199982	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E610000000000080C2354EC00000002085EB3FC0
1447	red_inta:1525	Las Lajitas	-24.7399998	-64.25	0	\N	\N	\N	\N	\N	\N	\N	Salta	\N	\N	ARGENTINA	0101000020E610000000000000001050C0000000A070BD38C0
1448	red_inta:1526	Las Moscas	-32.0999985	-58.9700012	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E610000000000000297C4DC0000000C0CC0C40C0
1449	red_inta:1527	Lincoln - EEA Villegas	-34.8400002	-61.5999985	0	\N	\N	\N	\N	\N	\N	\N	Buenos Aires	\N	\N	ARGENTINA	0101000020E6100000000000C0CCCC4EC000000020856B41C0
1450	red_inta:1528	Loma Chata - EEA Barrow	-38.6500015	-61.4500008	0	\N	\N	\N	\N	\N	\N	\N	Buenos Aires	\N	\N	ARGENTINA	0101000020E6100000000000A099B94EC000000040335343C0
1451	red_inta:1529	Los Arrieta - EEA Famailla	-27.2600002	-65.3700027	0	\N	\N	\N	\N	\N	\N	\N	Tucuman	\N	\N	ARGENTINA	0101000020E610000000000020AE5750C0000000608F423BC0
1452	red_inta:1530	Los Conquistadores	-30.5200005	-58.4000015	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E61000000000004033334DC0000000C01E853EC0
1453	red_inta:1531	Los JurÃ­es - EEA E Santiago	-28.6100006	-62.1599998	0	\N	\N	\N	\N	\N	\N	\N	Santiago del Estero	\N	\N	ARGENTINA	0101000020E6100000000000E07A144FC000000000299C3CC0
1454	red_inta:1532	Lucas Gonzalez	-32.4099998	-59.5499992	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E61000000000006066C64DC0000000E07A3440C0
1455	red_inta:1533	Lucas Norte	-31.3799992	-58.9099998	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E6100000000000E07A744DC0000000A047613FC0
1456	red_inta:1534	Lucas Sur	-31.6399994	-58.9599991	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E610000000000040E17A4DC000000000D7A33FC0
1457	red_inta:1535	Macia	-32.1500015	-59.4099998	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E6100000000000E07AB44DC000000040331340C0
1458	red_inta:1536	MalargÃ¼e - EEA Rama Caida	-35.3800011	-69.5699997	0	\N	\N	\N	\N	\N	\N	\N	Mendoza	\N	\N	ARGENTINA	0101000020E6100000000000E07A6451C0000000E0A3B041C0
1459	red_inta:1537	Malbran - EEA E Sgo del Estero	-29.3199997	-62.4599991	0	\N	\N	\N	\N	\N	\N	\N	Santiago del Estero	\N	\N	ARGENTINA	0101000020E610000000000040E13A4FC000000080EB513DC0
1460	red_inta:1538	Manfredi - EEA Manfredi	-31.8600006	-63.75	0	\N	\N	\N	\N	\N	\N	\N	CÃ³rdoba	\N	\N	ARGENTINA	0101000020E61000000000000000E04FC00000000029DC3FC0
1461	red_inta:1539	Mansilla	-32.4799995	-59.3300018	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E6100000000000803DAA4DC0000000A0703D40C0
1462	red_inta:1540	Maria Grande	-31.6900005	-59.9099998	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E6100000000000E07AF44DC0000000E0A3B03FC0
1463	red_inta:1541	Maria Grande 2da.	-31.6900005	-59.6500015	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E61000000000004033D34DC0000000E0A3B03FC0
1464	red_inta:1542	Mbocaya	-28.4099998	-57.9199982	0	\N	\N	\N	\N	\N	\N	\N	Corrientes	\N	\N	ARGENTINA	0101000020E610000000000080C2F54CC0000000C0F5683CC0
1465	red_inta:1543	Medanos - EEA Hilario Ascasubi	-38.8699989	-62.6599998	0	\N	\N	\N	\N	\N	\N	\N	Buenos Aires	\N	\N	ARGENTINA	0101000020E6100000000000E07A544FC0000000205C6F43C0
1466	red_inta:1544	Mojones	-31.5599995	-59.2099991	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E610000000000040E19A4DC0000000205C8F3FC0
1467	red_inta:1545	Mojones Norte	-31.4799995	-59.3300018	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E6100000000000803DAA4DC000000040E17A3FC0
1468	red_inta:1546	Mojones Sur	-31.6499996	-59.2000008	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E6100000000000A099994DC00000006066A63FC0
1469	red_inta:1547	Molino Doll	-32.3300018	-60.4000015	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E61000000000004033334EC0000000803D2A40C0
1470	red_inta:1548	Monte Caseros	-30.25	-57.6800003	0	\N	\N	\N	\N	\N	\N	\N	Corrientes	\N	\N	ARGENTINA	0101000020E6100000000000400AD74CC00000000000403EC0
1471	red_inta:1549	Monte Quemado - EEA E Santiago	-25.8600006	-62.7099991	0	\N	\N	\N	\N	\N	\N	\N	Santiago del Estero	\N	\N	ARGENTINA	0101000020E610000000000040E15A4FC00000000029DC39C0
1472	red_inta:773	Anguil -EEA Anguil - EEA INTA Anguil - Guillermo Covas	-36.5419998	-63.9910011	0	\N	\N	\N	\N	\N	\N	\N	La Pampa	\N	\N	ARGENTINA	0101000020E610000000000020D9FE4FC000000040604542C0
1473	red_inta:774	Apolinario Saravia - EEA Salta - OIT Apolinario Saravia	-24.4349995	-63.9889984	0	\N	\N	\N	\N	\N	\N	\N	Salta	\N	\N	ARGENTINA	0101000020E61000000000008097FE4FC0000000205C6F38C0
1474	red_inta:775	Arrecifes - EEA Pergamino - Escuela Agropecuaria N 1 de Arrecifes	-34.0499992	-60.1360016	0	\N	\N	\N	\N	\N	\N	\N	Buenos Aires	\N	\N	ARGENTINA	0101000020E61000000000008068114EC000000060660641C0
1475	red_inta:1550	Montecarlo - EEA Montecarlo	-26.5699997	-54.7299995	0	\N	\N	\N	\N	\N	\N	\N	Misiones	\N	\N	ARGENTINA	0101000020E6100000000000A0705D4BC000000080EB913AC0
1476	red_inta:1551	Montoya	-32.5800018	-59.8899994	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E610000000000080EBF14DC0000000803D4A40C0
1477	red_inta:1552	Mora Cue	-28.3600006	-56.1599998	0	\N	\N	\N	\N	\N	\N	\N	Corrientes	\N	\N	ARGENTINA	0101000020E6100000000000E07A144CC000000000295C3CC0
1478	red_inta:1553	Moreira	-31.2199993	-58.3100014	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E610000000000020AE274DC0000000E051383FC0
1479	red_inta:1554	Morillo - EEA Salta	-23.4599991	-62.8899994	0	\N	\N	\N	\N	\N	\N	\N	Salta	\N	\N	ARGENTINA	0101000020E610000000000080EB714FC000000080C27537C0
1480	red_inta:1555	Mulitas	-30.3700008	-58.9799995	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E6100000000000A0707D4DC000000060B85E3EC0
1481	red_inta:1556	NogoyÃ¡	-32.4099998	-59.8100014	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E610000000000020AEE74DC0000000E07A3440C0
1482	red_inta:1557	Nueva Pompeya - EEA SÃ¡enz PeÃ±a	-24.8999996	-61.4700012	0	\N	\N	\N	\N	\N	\N	\N	Chaco	\N	\N	ARGENTINA	0101000020E61000000000000029BC4EC00000006066E638C0
1483	red_inta:1558	Oro Verde	-31.8500004	-60.5200005	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E6100000000000608F424EC0000000A099D93FC0
1484	red_inta:1559	P de Los Llanos - EEA La Rioja	-30.1499996	-66.5500031	0	\N	\N	\N	\N	\N	\N	\N	La Rioja	\N	\N	ARGENTINA	0101000020E61000000000004033A350C00000006066263EC0
1485	red_inta:1560	P Golondrinas - EEA Bariloche	-41.9599991	-71.5199966	0	\N	\N	\N	\N	\N	\N	\N	Chubut	\N	\N	ARGENTINA	0101000020E6100000000000A047E151C000000040E1FA44C0
1486	red_inta:1561	P. de la Plaza -EEA SÃ¡enz PeÃ±a	-26.9300003	-59.7999992	0	\N	\N	\N	\N	\N	\N	\N	Chaco	\N	\N	ARGENTINA	0101000020E61000000000006066E64DC00000008014EE3AC0
1487	red_inta:1562	P. Roca - EEA El Colorado	-26.1499996	-59.5800018	0	\N	\N	\N	\N	\N	\N	\N	Chaco	\N	\N	ARGENTINA	0101000020E6100000000000803DCA4DC00000006066263AC0
1488	red_inta:1563	Pajonal	-32.4799995	-60.3100014	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E610000000000020AE274EC0000000A0703D40C0
1489	red_inta:1564	Palavecino	-32.9199982	-58.7400017	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E610000000000060B85E4DC000000080C27540C0
1490	red_inta:1565	Palmita - Perugorria	-29.3199997	-58.7999992	0	\N	\N	\N	\N	\N	\N	\N	Corrientes	\N	\N	ARGENTINA	0101000020E61000000000006066664DC000000080EB513DC0
1491	red_inta:1566	Palo Santo - ICyA CIRN	-25.5699997	-59.3400002	0	\N	\N	\N	\N	\N	\N	\N	Formosa	\N	\N	ARGENTINA	0101000020E61000000000002085AB4DC000000080EB9139C0
1492	red_inta:1567	Pampa Infierno -EA SÃ¡enz PeÃ±a	-26.5	-61.2000008	0	\N	\N	\N	\N	\N	\N	\N	Chaco	\N	\N	ARGENTINA	0101000020E6100000000000A099994EC00000000000803AC0
1493	red_inta:1568	ParanÃ¡	-31.7299995	-60.5299988	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E610000000000000D7434EC000000040E1BA3FC0
1494	red_inta:1569	Pareditas - EEA Consulta	-33.9500008	-69.0800018	0	\N	\N	\N	\N	\N	\N	\N	Mendoza	\N	\N	ARGENTINA	0101000020E6100000000000C01E4551C0000000A099F940C0
1495	red_inta:1570	Parque Nacional Mburucuya	-28.0400009	-58.0999985	0	\N	\N	\N	\N	\N	\N	\N	Corrientes	\N	\N	ARGENTINA	0101000020E6100000000000C0CC0C4DC0000000803D0A3CC0
1496	red_inta:1571	Paso de la Arena	-31.75	-60.1100006	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E610000000000080140E4EC00000000000C03FC0
1497	red_inta:1572	Paso de los Indios EEA Chubut	-43.3600006	-68.5800018	0	\N	\N	\N	\N	\N	\N	\N	Chubut	\N	\N	ARGENTINA	0101000020E6100000000000C01E2551C00000008014AE45C0
1498	red_inta:1573	Paso del Sapo - EEA Esquel	-42.7400017	-69.5999985	0	\N	\N	\N	\N	\N	\N	\N	Chubut	\N	\N	ARGENTINA	0101000020E610000000000060666651C000000060B85E45C0
1499	red_inta:1574	Perdices	-33.2299995	-58.7000008	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E6100000000000A099594DC0000000A0709D40C0
1500	red_inta:1575	Picada Veron	-30.8500004	-59.3899994	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E610000000000080EBB14DC0000000A099D93EC0
1501	stations:428	RECONQUISTA (EMC) - RECONQUISTA EEA INTA	-29.1800003	-59.7000008	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	ARGENTINA	0101000020E6100000000000A099D94DC000000080142E3DC0
1502	stations:429	SAN PEDRO (EMC) - SAN PEDRO EEA INTA	-33.6800003	-59.6800003	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	ARGENTINA	0101000020E6100000000000400AD74DC0000000400AD740C0
1503	stations:430	ZAVALLA (EMC) - ZAVALLA - UNROSARIO	-33.0200005	-60.8800011	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	ARGENTINA	0101000020E6100000000000E0A3704EC0000000608F8240C0
1504	stations:431	SANTIAGO DEL ESTERO AERO	-27.7667007	-64.2833023	0	\N	\N	\N	\N	\N	\N	\N	SANTIAGODELESTERO	\N	\N	ARGENTINA	0101000020E6100000000000A0211250C00000008046C43BC0
1505	stations:432	PCIA. ROQUE SAENZ PENA AERO	-26.8167	-60.4500008	0	\N	\N	\N	\N	\N	\N	\N	CHACO	\N	\N	ARGENTINA	0101000020E6100000000000A099394EC00000004013D13AC0
1506	stations:433	RESISTENCIA AERO	-27.4333	-59.0332985	0	\N	\N	\N	\N	\N	\N	\N	CHACO	\N	\N	ARGENTINA	0101000020E61000000000002043844DC0000000C0EC6E3BC0
1507	stations:434	CORRIENTES AERO	-27.4333	-58.7667007	0	\N	\N	\N	\N	\N	\N	\N	CORRIENTES	\N	\N	ARGENTINA	0101000020E61000000000004023624DC0000000C0EC6E3BC0
1508	stations_cdp:584	SOROCABA	-23.2999992	-47.2999992	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	BRASIL	0101000020E61000000000006066A647C0000000C0CC4C37C0
1509	red_inta:843	Sumalao - EEA Catamarca - Campo anexo Sumalao	-28.2830009	-65.439003	0	\N	\N	\N	\N	\N	\N	\N	Catamarca	\N	\N	ARGENTINA	0101000020E6100000000000A0185C50C0000000C072483CC0
1510	red_inta:844	Trenque Lauquen - EEA Villegas - Predio de Aeroclub T. Lauquen	-35.9729996	-62.7649994	0	\N	\N	\N	\N	\N	\N	\N	Buenos Aires	\N	\N	ARGENTINA	0101000020E610000000000080EB614FC0000000408BFC41C0
1511	red_inta:845	Tres Esquinas - Cooperativa La Ganadera de Gral. Ramirez	-32.3619995	-60.3470001	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E6100000000000806A2C4EC000000000562E40C0
1512	red_inta:847	Viamonte - Establecimiento El Viejo Roble	-33.8199997	-63.0200005	0	\N	\N	\N	\N	\N	\N	\N	CÃ³rdoba	\N	\N	ARGENTINA	0101000020E6100000000000608F824FC0000000C0F5E840C0
1513	red_inta:1627	Tacuara	-30.5599995	-59.5200005	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E6100000000000608FC24DC0000000205C8F3EC0
1514	red_inta:1628	Telsen - Chubut	-42.4300003	-66.8899994	0	\N	\N	\N	\N	\N	\N	\N	Chubut	\N	\N	ARGENTINA	0101000020E6100000000000C0F5B850C0000000400A3745C0
1515	red_inta:1629	Tilisarao - EEA San Luis	-32.6699982	-65.2300034	0	\N	\N	\N	\N	\N	\N	\N	San Luis	\N	\N	ARGENTINA	0101000020E610000000000060B84E50C000000080C25540C0
1516	red_inta:1630	Tornquist - EEA Bordenave	-38.1199989	-62.2400017	0	\N	\N	\N	\N	\N	\N	\N	Buenos Aires	\N	\N	ARGENTINA	0101000020E610000000000060B81E4FC0000000205C0F43C0
1517	red_inta:1631	Trancas - EEA FamaillÃ¡	-26.2800007	-65.2699966	0	\N	\N	\N	\N	\N	\N	\N	Tucuman	\N	\N	ARGENTINA	0101000020E6100000000000A0475150C000000020AE473AC0
1518	red_inta:1632	Tres bocas	-32.75	-59.7599983	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E6100000000000A047E14DC000000000006040C0
1519	red_inta:1633	Tres Esquinas	-32.25	-59.9300003	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E6100000000000400AF74DC000000000002040C0
1520	red_inta:1634	UNR - Zavalla (EMC)	-33.0200005	-60.8800011	0	\N	\N	\N	\N	\N	\N	\N	Santa Fe	\N	\N	ARGENTINA	0101000020E6100000000000E0A3704EC0000000608F8240C0
1521	red_inta:1635	Urdinarrain	-32.7000008	-58.8600006	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E610000000000080146E4DC0000000A0995940C0
1522	red_inta:1636	Valcheta - EEA Valle Inferior	-40.7200012	-66.3099976	0	\N	\N	\N	\N	\N	\N	\N	RÃ­o Negro	\N	\N	ARGENTINA	0101000020E610000000000000D79350C000000000295C44C0
1523	red_inta:1637	Viale	-31.8600006	-60.0299988	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E610000000000000D7034EC00000000029DC3FC0
1524	red_inta:1646	Yerua	-31.5200005	-58.1899986	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E6100000000000E051184DC0000000C01E853FC0
1525	red_inta:1576	Pje Galarza - EEA Mercedes	-28.1599998	-56.7099991	0	\N	\N	\N	\N	\N	\N	\N	Corrientes	\N	\N	ARGENTINA	0101000020E610000000000040E15A4CC0000000C0F5283CC0
1526	red_inta:1577	Plottier - IPAF Patagonia	-38.9500008	-68.3300018	0	\N	\N	\N	\N	\N	\N	\N	Neuquen	\N	\N	ARGENTINA	0101000020E6100000000000C01E1551C0000000A0997943C0
1527	red_ana_pluvio:903	Irai	-27.1888885	-53.253334	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	BRASIL	0101000020E6100000000000406DA04AC0000000005B303BC0
1528	red_inta:1362	CAFER - Don CristÃ³bal	-32.0699997	-59.9900017	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E610000000000060B8FE4DC0000000C0F50840C0
1529	stations_cdp:497	FRANCA	-20.2999992	-47.2999992	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	BRASIL	0101000020E61000000000006066A647C0000000C0CC4C34C0
1530	stations_cdp:581	IRATI	-25.4699993	-50.6300011	0	\N	\N	\N	\N	\N	\N	\N	PARANA	\N	\N	BRASIL	0101000020E6100000000000E0A35049C0000000E0517839C0
1531	stations_cdp:527	GUARULHOS	-23.2999992	-46.2999992	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	BRASIL	0101000020E610000000000060662647C0000000C0CC4C37C0
1532	stations_cdp:528	DIAMANTINO	-14.1999998	-56.2999992	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	BRASIL	0101000020E61000000000006066264CC00000006066662CC0
1533	red_inta:1506	INTA - Valle Inferior	-40.7999992	-63.0600014	0	\N	\N	\N	\N	\N	\N	\N	RÃ­o Negro	\N	\N	ARGENTINA	0101000020E610000000000020AE874FC000000060666644C0
1534	red_ana_pluvio:904	Alto Uruguai	-27.3019447	-54.1394463	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	BRASIL	0101000020E610000000000060D9114BC0000000404C4D3BC0
1535	red_inta:780	CAFER - Don Cristobal	-32.0750008	-59.9939995	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	ARGENTINA	0101000020E6100000000000603BFF4DC0000000A0990940C0
1536	red_inta:781	CAFER - San Victor	-30.4669991	-59.0330009	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	ARGENTINA	0101000020E61000000000006039844DC0000000408D773EC0
1537	red_inta:784	Concepcion del Uruguay - Predio observatorio agrometeorologico	-32.487999	-58.3479996	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E6100000000000408B2C4DC0000000C0763E40C0
1538	red_inta:776	Balcarce - EEA Balcarce - EEA Balcarce	-37.7630005	-58.2980003	0	\N	\N	\N	\N	\N	\N	\N	Buenos Aires	\N	\N	ARGENTINA	0101000020E6100000000000E024264DC000000000AAE142C0
1539	red_inta:777	Bandera - Predio AER INTA Bandera	-28.8929996	-62.2750015	0	\N	\N	\N	\N	\N	\N	\N	Santiago del Estero	\N	\N	ARGENTINA	0101000020E61000000000004033234FC0000000A09BE43CC0
1540	red_inta:778	Basail - INTA - Basail	-27.8969994	-59.2949982	0	\N	\N	\N	\N	\N	\N	\N	Chaco	\N	\N	ARGENTINA	0101000020E610000000000080C2A54DC0000000C0A1E53BC0
1541	red_inta:779	Caa Cati - Caa Cati	-27.75	-57.6160011	0	\N	\N	\N	\N	\N	\N	\N	Corrientes	\N	\N	ARGENTINA	0101000020E610000000000020D9CE4CC00000000000C03BC0
1542	red_inta:782	Castelar (Observatorio) - Obs. Principal-Predio INTA Castelar	-34.6049995	-58.6699982	0	\N	\N	\N	\N	\N	\N	\N	Buenos Aires	\N	\N	ARGENTINA	0101000020E610000000000080C2554DC0000000A0704D41C0
1543	red_inta:783	Cerro Azul - EEA INTA - Cerro Azul	-27.6560001	-55.4379997	0	\N	\N	\N	\N	\N	\N	\N	Misiones	\N	\N	ARGENTINA	0101000020E61000000000006010B84BC0000000A0EFA73BC0
1544	red_inta:769	25 de Mayo - EEA Pergamino - Estacion Forestal INTA	-35.4790001	-60.1269989	0	\N	\N	\N	\N	\N	\N	\N	Buenos Aires	\N	\N	ARGENTINA	0101000020E61000000000008041104EC0000000E04FBD41C0
1545	red_inta:770	Abra Pampa - EEA Abra Pampa	-22.7989998	-65.8259964	0	\N	\N	\N	\N	\N	\N	\N	Jujuy	\N	\N	ARGENTINA	0101000020E610000000000020DD7450C0000000408BCC36C0
1546	red_inta:771	Alfonso - EEA Pergamino - Cooperativa Agricola La Union	-33.9119987	-60.8380013	0	\N	\N	\N	\N	\N	\N	\N	Buenos Aires	\N	\N	ARGENTINA	0101000020E6100000000000A0436B4EC000000060BCF440C0
1547	red_inta:772	Andalgala - EEA Catamarca - AER Andalgala	-27.6040001	-66.3359985	0	\N	\N	\N	\N	\N	\N	\N	Catamarca	\N	\N	ARGENTINA	0101000020E610000000000000819550C0000000C09F9A3BC0
1548	red_inta:1578	Pocito - EEA San juan	-31.6599998	-68.5899963	0	\N	\N	\N	\N	\N	\N	\N	San Juan	\N	\N	ARGENTINA	0101000020E610000000000080C22551C0000000C0F5A83FC0
1549	red_inta:1579	Posadas Sede	-27.3700008	-55.8899994	0	\N	\N	\N	\N	\N	\N	\N	Sin asignar	\N	\N	ARGENTINA	0101000020E610000000000080EBF14BC000000060B85E3BC0
1550	red_inta:1580	Presa	-27.4799995	-56.7099991	0	\N	\N	\N	\N	\N	\N	\N	Sin asignar	\N	\N	ARGENTINA	0101000020E610000000000040E15A4CC000000040E17A3BC0
1551	red_inta:1581	Pueblo Brugo	-31.4300003	-60.0900002	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E610000000000020850B4EC000000080146E3FC0
1552	red_inta:1582	Pueblo Cazes	-32	-58.5299988	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E610000000000000D7434DC000000000000040C0
1553	red_inta:1583	Puerto Piramides - EEA Chubut	-42.5400009	-64.2900009	0	\N	\N	\N	\N	\N	\N	\N	Chubut	\N	\N	ARGENTINA	0101000020E6100000000000608F1250C0000000C01E4545C0
1554	red_inta:841	Santa Rosa - Productor Cornelio Atemberg	-28.2740002	-58.1290016	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	ARGENTINA	0101000020E61000000000002083104DC0000000E024463CC0
1555	red_inta:1584	QuimilÃ­ - EEA E Santiago	-27.5400009	-62.3499985	0	\N	\N	\N	\N	\N	\N	\N	Santiago del Estero	\N	\N	ARGENTINA	0101000020E6100000000000C0CC2C4FC0000000803D8A3BC0
1556	red_ana_pluvio:897	Dionisio Cerqueira	-26.2691669	-53.6274986	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	BRASIL	0101000020E6100000000000E051D04AC000000020E8443AC0
1557	red_ana_pluvio:898	Ponte do Sargento	-26.6827774	-53.2866669	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	BRASIL	0101000020E610000000000080B1A44AC000000080CAAE3AC0
1558	red_ana_pluvio:899	Sao Jose do Cedro	-26.4650002	-53.4536095	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	BRASIL	0101000020E6100000000000E00FBA4AC0000000400A773AC0
1559	red_ana_pluvio:900	Ipora	-27.0013885	-53.5255547	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	BRASIL	0101000020E61000000000006045C34AC0000000005B003BC0
1560	red_ana_pluvio:901	Liberato Salzano	-27.5991669	-53.0713882	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	BRASIL	0101000020E61000000000004023894AC00000000063993BC0
1561	red_inta:1585	Raices	-31.8199997	-59.2200012	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E610000000000000299C4DC000000080EBD13FC0
1562	red_inta:1586	Rama Caida - EEA Rama Caida	-34.6699982	-68.3899994	0	\N	\N	\N	\N	\N	\N	\N	Mendoza	\N	\N	ARGENTINA	0101000020E6100000000000C0F51851C000000080C25541C0
1563	red_inta:1587	Ramada Paso	-27.2900009	-58.3199997	0	\N	\N	\N	\N	\N	\N	\N	Corrientes	\N	\N	ARGENTINA	0101000020E6100000000000C0F5284DC0000000803D4A3BC0
1564	red_inta:1588	Ramirez	-32.1500015	-60.1899986	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E6100000000000E051184EC000000040331340C0
1565	red_inta:1589	Rauch - EEA Cuenca Salado	-36.7999992	-59.1100006	0	\N	\N	\N	\N	\N	\N	\N	Buenos Aires	\N	\N	ARGENTINA	0101000020E610000000000080148E4DC000000060666642C0
1566	red_inta:1590	RaÃ­ces Oeste	-31.8500004	-59.5600014	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E610000000000020AEC74DC0000000A099D93FC0
1567	red_ana_pluvio:902	Palmeira das Missoes	-27.9133339	-53.310833	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	BRASIL	0101000020E610000000000060C9A74AC000000040D0E93BC0
1568	red_salado:852	avellaneda	-28.8225002	-59.6916656	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	ARGENTINA	0101000020E61000000000008088D84DC0000000608FD23CC0
1569	alturas_dinac:155	Concepcion	-23.4576607	-57.4439011	0	\N	\N	\N	\N	\N	\N	\N	PARAGUAY	\N	\N	PARAGUAY	0101000020E6100000000000C0D1B84CC000000040297537C0
1570	alturas_dinac:153	Bahia Negra	-20.22719	-58.1632004	0	\N	\N	\N	\N	\N	\N	\N	PARAGUAY	\N	\N	PARAGUAY	0101000020E6100000000000C0E3144DC000000020293A34C0
1571	alturas_dinac:154	Olimpo	-21.0423508	-57.8682709	0	\N	\N	\N	\N	\N	\N	\N	PARAGUAY	\N	\N	PARAGUAY	0101000020E61000000000008023EF4CC000000080D70A35C0
1572	red_ana_pluvio:905	Tucunduva	-27.6552773	-54.4422226	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	BRASIL	0101000020E6100000000000C09A384BC000000040C0A73BC0
1573	red_ana_pluvio:906	Porto Lucena	-27.8544445	-55.023613	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	BRASIL	0101000020E6100000000000C005834BC0000000E0BCDA3BC0
1574	red_inta:1611	Santa Magdalena	-24.5200005	-64.1299973	0	\N	\N	\N	\N	\N	\N	\N	Salta	\N	\N	ARGENTINA	0101000020E6100000000000E0510850C0000000C01E8538C0
1575	red_salado:853	bombal-i	-33.4319458	-61.2861099	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	ARGENTINA	0101000020E6100000000000409FA44EC0000000004AB740C0
1576	emas:930	villaparanacito	-33.7116661	-58.6602783	0	\N	\N	\N	\N	\N	\N	\N	ENTRERIOS	\N	\N	ARGENTINA	0101000020E61000000000000084544DC0000000E017DB40C0
1577	emas:932	urdinarrain	-32.6790695	-58.8917999	0	\N	\N	\N	\N	\N	\N	\N	ENTRERIOS	\N	\N	ARGENTINA	0101000020E61000000000008026724DC0000000C0EB5640C0
1578	emas:907	larroque	-33.044445	-58.9947205	0	\N	\N	\N	\N	\N	\N	\N	ENTRERIOS	\N	\N	ARGENTINA	0101000020E610000000000000537F4DC000000060B08540C0
1579	emas:908	villaguay	-31.8575001	-59.0972214	0	\N	\N	\N	\N	\N	\N	\N	ENTRERIOS	\N	\N	ARGENTINA	0101000020E6100000000000C0718C4DC00000002085DB3FC0
1580	emas:909	saucedeluna	-31.2383327	-59.2219429	0	\N	\N	\N	\N	\N	\N	\N	ENTRERIOS	\N	\N	ARGENTINA	0101000020E6100000000000A0689C4DC000000060033D3FC0
1581	emas:910	gualeguay	-33.1624985	-59.3125	0	\N	\N	\N	\N	\N	\N	\N	ENTRERIOS	\N	\N	ARGENTINA	0101000020E61000000000000000A84DC0000000C0CC9440C0
1582	emas:912	galarza	-32.7288895	-59.394165	0	\N	\N	\N	\N	\N	\N	\N	ENTRERIOS	\N	\N	ARGENTINA	0101000020E61000000000000074B24DC0000000404C5D40C0
1583	emas:914	macia	-32.1728516	-59.3999252	0	\N	\N	\N	\N	\N	\N	\N	ENTRERIOS	\N	\N	ARGENTINA	0101000020E6100000000000C030B34DC000000000201640C0
1584	emas:915	bovril	-31.3397217	-59.4486122	0	\N	\N	\N	\N	\N	\N	\N	ENTRERIOS	\N	\N	ARGENTINA	0101000020E6100000000000206CB94DC000000000F8563FC0
1585	emas:916	lapaz	-30.7000008	-59.5999985	0	\N	\N	\N	\N	\N	\N	\N	ENTRERIOS	\N	\N	ARGENTINA	0101000020E6100000000000C0CCCC4DC00000004033B33EC0
1586	emas:918	hasenkamp	-31.5108337	-59.8419456	0	\N	\N	\N	\N	\N	\N	\N	ENTRERIOS	\N	\N	ARGENTINA	0101000020E6100000000000E0C4EB4DC000000000C6823FC0
1587	emas:919	viale	-31.8688889	-60.0177765	0	\N	\N	\N	\N	\N	\N	\N	ENTRERIOS	\N	\N	ARGENTINA	0101000020E61000000000008046024EC0000000806FDE3FC0
1588	emas:920	victoria	-32.6127777	-60.1391678	0	\N	\N	\N	\N	\N	\N	\N	ENTRERIOS	\N	\N	ARGENTINA	0101000020E610000000000040D0114EC0000000806F4E40C0
1589	emas:921	villaurquiza	-31.6000004	-60.2999992	0	\N	\N	\N	\N	\N	\N	\N	ENTRERIOS	\N	\N	ARGENTINA	0101000020E61000000000006066264EC0000000A099993FC0
1590	emas:922	crespo	-32.0275002	-60.3172226	0	\N	\N	\N	\N	\N	\N	\N	ENTRERIOS	\N	\N	ARGENTINA	0101000020E6100000000000C09A284EC000000020850340C0
1591	red_inta:1591	Reconquista - EEA Reconquista	-29.2600002	-59.7099991	0	\N	\N	\N	\N	\N	\N	\N	Santa Fe	\N	\N	ARGENTINA	0101000020E610000000000040E1DA4DC0000000608F423DC0
1592	red_inta:1592	Rincon del GenÃ¡	-32.5200005	-58.5800018	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E6100000000000803D4A4DC0000000608F4240C0
1593	red_inta:1593	Rincon Ombu	-27.3199997	-56.3699989	0	\N	\N	\N	\N	\N	\N	\N	Sin asignar	\N	\N	ARGENTINA	0101000020E6100000000000205C2F4CC000000080EB513BC0
1594	red_inta:1594	RincÃ³n de NogoyÃ¡	-32.7799988	-59.9099998	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E6100000000000E07AF44DC000000000D76340C0
1595	red_inta:1595	Rio Gallegos - EEA Santa Cruz	-51.3800011	-69.1399994	0	\N	\N	\N	\N	\N	\N	\N	Santa Cruz	\N	\N	ARGENTINA	0101000020E6100000000000C0F54851C0000000E0A3B049C0
1596	red_inta:1596	Rivadavia - EEA Junin Mendoza	-33.2599983	-68.5	0	\N	\N	\N	\N	\N	\N	\N	Mendoza	\N	\N	ARGENTINA	0101000020E610000000000000002051C0000000A047A140C0
1597	red_inta:1597	Rosario de Lerma	-24.9899998	-65.5899963	0	\N	\N	\N	\N	\N	\N	\N	Salta	\N	\N	ARGENTINA	0101000020E610000000000080C26550C0000000A070FD38C0
1598	red_inta:1598	Rosario del Tala	-32.3300018	-59.1899986	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E6100000000000E051984DC0000000803D2A40C0
1599	red_inta:1599	San Carlos	-27.6800003	-56.0099983	0	\N	\N	\N	\N	\N	\N	\N	Corrientes	\N	\N	ARGENTINA	0101000020E6100000000000A047014CC00000008014AE3BC0
1600	red_inta:1600	San Fernando - EEA Delta	-34.25	-58.6100006	0	\N	\N	\N	\N	\N	\N	\N	Buenos Aires	\N	\N	ARGENTINA	0101000020E610000000000080144E4DC000000000002041C0
1601	red_inta:837	S.J. de la Frontera - Estancia la Colorada de TILO PARANA SA	-30.3570004	-58.3149986	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E6100000000000E051284DC000000060645B3EC0
1602	red_inta:840	San Vicente - Campo Anexo Cuartel Rio Victoria (INTA)	-26.9169998	-54.4169998	0	\N	\N	\N	\N	\N	\N	\N	Misiones	\N	\N	ARGENTINA	0101000020E61000000000004060354BC000000080C0EA3AC0
1603	red_inta:846	UNLZ - Fac. Cs. Agrarias - Predio Facultad de Cs. Agrarias de UNLZ	-34.7799988	-58.4599991	0	\N	\N	\N	\N	\N	\N	\N	Buenos Aires	\N	\N	ARGENTINA	0101000020E610000000000040E13A4DC000000000D76341C0
1604	red_inta:831	Palma Sola - EEA Yuto - OIT Palma Sola	-23.9750004	-64.3040009	0	\N	\N	\N	\N	\N	\N	\N	Jujuy	\N	\N	ARGENTINA	0101000020E6100000000000C0741350C0000000A099F937C0
1605	alturas_prefe:11	El Dorado	-26.3833332	-54.7000008	0	\N	\N	\N	\N	\N	\N	\N	MISIONES	\N	\N	ARGENTINA	0101000020E6100000000000A099594BC00000002022623AC0
1606	alturas_prefe:12	Libertador	-26.7999992	-55.0333328	0	\N	\N	\N	\N	\N	\N	\N	MISIONES	\N	\N	ARGENTINA	0101000020E61000000000004044844BC0000000C0CCCC3AC0
1607	red_inta:833	Rafaela - EEA Rafaela	-31.2000008	-61.5	0	\N	\N	\N	\N	\N	\N	\N	Santa Fe	\N	\N	ARGENTINA	0101000020E61000000000000000C04EC00000004033333FC0
1608	red_inta:834	Recreo - EEA Catamarca - Parque Industrial Recreo	-29.1660004	-65.0449982	0	\N	\N	\N	\N	\N	\N	\N	Catamarca	\N	\N	ARGENTINA	0101000020E610000000000040E14250C0000000007F2A3DC0
1609	red_inta:835	Rio Colorado - EEA Alto valle - Chacra Pagliai-Meirino - Colonia Julia y Echarren	-39.0200005	-64.0800018	0	\N	\N	\N	\N	\N	\N	\N	RÃ­o Negro	\N	\N	ARGENTINA	0101000020E6100000000000C01E0550C0000000608F8243C0
1610	red_inta:836	Rio Tala - EEA San Pedro - Vivero Las Margaritas SRL	-33.7649994	-59.6269989	0	\N	\N	\N	\N	\N	\N	\N	Buenos Aires	\N	\N	ARGENTINA	0101000020E61000000000008041D04DC000000080EBE140C0
1611	red_inta:1643	Villaguay	-31.8099995	-59.0200005	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E6100000000000608F824DC0000000205CCF3FC0
1612	alturas_prefe:13	Santa Ana	-27.3350906	-55.5884132	0	\N	\N	\N	\N	\N	\N	\N	MISIONES	\N	\N	ARGENTINA	0101000020E61000000000002051CB4BC000000080C8553BC0
1613	alturas_prefe:14	Posadas	-27.3666668	-55.8833351	0	\N	\N	\N	\N	\N	\N	\N	MISIONES	\N	\N	ARGENTINA	0101000020E61000000000002011F14BC0000000E0DD5D3BC0
1614	alturas_prefe:15	ItuzaingÃ³	-27.583334	-56.7000008	0	\N	\N	\N	\N	\N	\N	\N	CORRIENTES	\N	\N	ARGENTINA	0101000020E6100000000000A099594CC00000006055953BC0
1615	alturas_prefe:16	ItÃ¡ IbatÃ©	-27.4233608	-57.3332672	0	\N	\N	\N	\N	\N	\N	\N	CORRIENTES	\N	\N	ARGENTINA	0101000020E610000000000080A8AA4CC000000060616C3BC0
1616	alturas_dinac:164	Villeta	-25.5131397	-57.5709076	0	\N	\N	\N	\N	\N	\N	\N	PARAGUAY	\N	\N	PARAGUAY	0101000020E61000000000008013C94CC0000000205D8339C0
1617	alturas_dinac:172	Yuty - CaazapÃ¡	-26.7158718	-56.281559	0	\N	\N	\N	\N	\N	\N	\N	PARAGUAY	\N	\N	PARAGUAY	0101000020E6100000000000200A244CC00000006043B73AC0
1618	alturas_dinac:166	Pilar	-26.8576984	-58.3105621	0	\N	\N	\N	\N	\N	\N	\N	PARAGUAY	\N	\N	PARAGUAY	0101000020E610000000000080C0274DC00000002092DB3AC0
1619	alturas_dinac:156	Rosario	-24.4478703	-57.1514282	0	\N	\N	\N	\N	\N	\N	\N	PARAGUAY	\N	\N	PARAGUAY	0101000020E61000000000000062934CC0000000A0A77238C0
1620	alturas_dinac:165	Alberdi	-26.1887913	-58.1474495	0	\N	\N	\N	\N	\N	\N	\N	PARAGUAY	\N	\N	PARAGUAY	0101000020E6100000000000A0DF124DC0000000A054303AC0
1621	lujan_api:934	Rio Lujan - Puente Manuel J. Garcia	-34.7022209	-59.5488892	0	\N	\N	\N	\N	\N	\N	\N	BUENOSAIRES	\N	\N	Argentina	0101000020E61000000000000042C64DC000000060E25941C0
1622	lujan_api:935	Rio Lujan - Puente Olivera	-34.6172218	-59.2605553	0	\N	\N	\N	\N	\N	\N	\N	BUENOSAIRES	\N	\N	Argentina	0101000020E6100000000000E059A14DC000000020014F41C0
1623	lujan_api:936	Rio Lujan - Puente Ruta Nac. 6	-34.5208321	-59.0374985	0	\N	\N	\N	\N	\N	\N	\N	BUENOSAIRES	\N	\N	Argentina	0101000020E6100000000000C0CC844DC0000000A0AA4241C0
1624	lujan_api:937	Rio Lujan - Puente Ruta Nac. 9	-34.2983322	-58.8822212	0	\N	\N	\N	\N	\N	\N	\N	BUENOSAIRES	\N	\N	Argentina	0101000020E6100000000000A0EC704DC0000000C02F2641C0
1625	lujan_api:938	Rio Lujan - Puente Granadero Gelves	-34.4336128	-58.9438896	0	\N	\N	\N	\N	\N	\N	\N	BUENOSAIRES	\N	\N	Argentina	0101000020E610000000000060D1784DC0000000A0803741C0
1626	red_inta:850	Alejandro Roca - EEA Marcos JuÃ¡rez	-33.4959984	-63.6609993	0	\N	\N	\N	\N	\N	\N	\N	CÃ³rdoba	\N	\N	ARGENTINA	0101000020E6100000000000A09BD44FC0000000E07CBF40C0
1627	red_inta:832	Posadas - Ruta Nacional 12 km 7.5 Villa Miguel Lanus	-27.427	-55.8899994	0	\N	\N	\N	\N	\N	\N	\N	Misiones	\N	\N	ARGENTINA	0101000020E610000000000080EBF14BC0000000E04F6D3BC0
1628	red_inta:848	Villa CaÃ±as - EEA Oliveros - Predio Aeroclub	-33.9630013	-61.632	0	\N	\N	\N	\N	\N	\N	\N	Santa Fe	\N	\N	ARGENTINA	0101000020E610000000000060E5D04EC0000000A043FB40C0
1629	red_inta:1601	San Francisco de Laishi	-26.2399998	-58.6399994	0	\N	\N	\N	\N	\N	\N	\N	Formosa	\N	\N	ARGENTINA	0101000020E610000000000080EB514DC0000000A0703D3AC0
1630	red_inta:1602	San Gustavo	-30.7000008	-59.4500008	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E6100000000000A099B94DC00000004033B33EC0
1631	red_inta:1603	San Isidro - EEA Bella Vista	-29.4799995	-59.2999992	0	\N	\N	\N	\N	\N	\N	\N	Corrientes	\N	\N	ARGENTINA	0101000020E61000000000006066A64DC000000040E17A3DC0
1632	red_inta:1604	San Jaime de la Frontera	-30.3600006	-58.2299995	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E6100000000000A0701D4DC000000000295C3EC0
1633	red_inta:1605	San Jorge - EEA Rafaela	-31.9500008	-61.8300018	0	\N	\N	\N	\N	\N	\N	\N	Santa Fe	\N	\N	ARGENTINA	0101000020E6100000000000803DEA4EC00000004033F33FC0
1634	red_inta:1606	San Lorenzo	-28.1700001	-58.7000008	0	\N	\N	\N	\N	\N	\N	\N	Corrientes	\N	\N	ARGENTINA	0101000020E6100000000000A099594DC000000020852B3CC0
1635	red_inta:1607	San Pedro - EEA San Pedro	-33.7400017	-59.7999992	0	\N	\N	\N	\N	\N	\N	\N	Buenos Aires	\N	\N	ARGENTINA	0101000020E61000000000006066E64DC000000060B8DE40C0
1636	red_inta:1608	San Roque	-28.6000004	-58.7299995	0	\N	\N	\N	\N	\N	\N	\N	Corrientes	\N	\N	ARGENTINA	0101000020E6100000000000A0705D4DC0000000A099993CC0
1637	red_inta:1609	San Sebastian - EEA Santa Cruz	-52.8899994	-68.4499969	0	\N	\N	\N	\N	\N	\N	\N	Tierra del Fuego	\N	\N	ARGENTINA	0101000020E6100000000000C0CC1C51C000000080EB714AC0
1638	red_inta:1610	Santa Elena	-30.9899998	-59.6800003	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E6100000000000400AD74DC0000000A070FD3EC0
1639	red_inta:1612	Santa Rosa - EEA Junin Mendoza	-33.1800003	-67.8700027	0	\N	\N	\N	\N	\N	\N	\N	Mendoza	\N	\N	ARGENTINA	0101000020E610000000000020AEF750C0000000400A9740C0
1640	red_inta:1613	Santa Victoria Este - EEA Yuto	-22.2700005	-62.7099991	0	\N	\N	\N	\N	\N	\N	\N	Salta	\N	\N	ARGENTINA	0101000020E610000000000040E15A4FC0000000C01E4536C0
1641	red_inta:1614	Sarmiento - Chubut	-45.6100006	-69.0699997	0	\N	\N	\N	\N	\N	\N	\N	Chubut	\N	\N	ARGENTINA	0101000020E6100000000000E07A4451C00000008014CE46C0
1642	red_inta:1615	Sarmiento - EEA Chubut	-45.5999985	-69.0299988	0	\N	\N	\N	\N	\N	\N	\N	Chubut	\N	\N	ARGENTINA	0101000020E610000000000080EB4151C0000000C0CCCC46C0
1643	red_inta:1616	Sauce	-32.5600014	-59.6300011	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E6100000000000E0A3D04DC000000020AE4740C0
1644	red_inta:1617	Sauce de Luna	-31.1100006	-59.2900009	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E6100000000000C01EA54DC000000000291C3FC0
1645	red_inta:1618	Seclantas - EEA Salta	-25.3299999	-66.25	0	\N	\N	\N	\N	\N	\N	\N	Salta	\N	\N	ARGENTINA	0101000020E610000000000000009050C0000000E07A5439C0
1646	red_inta:1619	Segui	-31.9599991	-60.1300011	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E6100000000000E0A3104EC000000080C2F53FC0
1647	red_inta:1620	Segundo Cuartel	-32.3800011	-59.1199989	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E6100000000000205C8F4DC0000000E0A33040C0
1648	red_inta:1621	Sexto Distrito	-32.8499985	-59.6199989	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E6100000000000205CCF4DC0000000C0CC6C40C0
1649	red_inta:1622	Sociedad Rural Sauce	-30.1000004	-58.7900009	0	\N	\N	\N	\N	\N	\N	\N	Corrientes	\N	\N	ARGENTINA	0101000020E6100000000000C01E654DC0000000A099193EC0
1650	estaciones_salto_grande:1015	Libertad	-30.0142612	-57.8594513	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	Unknown	0101000020E61000000000008002EE4CC0000000A0A6033EC0
1651	alturas_prefe:42	Escobar	-34.2999992	-58.7333336	0	\N	\N	\N	\N	\N	\N	\N	BUENOSAIRES	\N	\N	ARGENTINA	0101000020E6100000000000E0DD5D4DC000000060662641C0
1652	alturas_prefe:43	Villa Paranacito	-33.7000008	-58.6500015	0	\N	\N	\N	\N	\N	\N	\N	ENTRERIOS	\N	\N	ARGENTINA	0101000020E61000000000004033534DC0000000A099D940C0
1653	alturas_prefe:44	Canal Nuevo	-33.8627014	-58.6604195	0	\N	\N	\N	\N	\N	\N	\N	ENTRERIOS	\N	\N	ARGENTINA	0101000020E6100000000000A088544DC0000000006DEE40C0
1654	alturas_prefe:45	Ibicuy	-33.7619781	-59.1800613	0	\N	\N	\N	\N	\N	\N	\N	ENTRERIOS	\N	\N	ARGENTINA	0101000020E6100000000000400C974DC00000008088E140C0
1655	alturas_prefe:46	Puerto Ruiz	-33.2166672	-59.3666649	0	\N	\N	\N	\N	\N	\N	\N	ENTRERIOS	\N	\N	ARGENTINA	0101000020E6100000000000E0EEAE4DC0000000C0BB9B40C0
1656	alturas_prefe:47	MartÃ­n GarcÃ­a	-34.1902885	-58.2530441	0	\N	\N	\N	\N	\N	\N	\N	BUENOSAIRES	\N	\N	ARGENTINA	0101000020E6100000000000C063204DC0000000605B1841C0
1657	alturas_prefe:48	Guazucito	-34.0166664	-58.4000015	0	\N	\N	\N	\N	\N	\N	\N	BUENOSAIRES	\N	\N	ARGENTINA	0101000020E61000000000004033334DC000000020220241C0
1658	alturas_prefe:49	Tigre	-34.4159317	-58.5779762	0	\N	\N	\N	\N	\N	\N	\N	BUENOSAIRES	\N	\N	ARGENTINA	0101000020E610000000000020FB494DC0000000403D3541C0
1659	alturas_prefe:50	Dique LujÃ¡n	-34.3515778	-58.6861153	0	\N	\N	\N	\N	\N	\N	\N	BUENOSAIRES	\N	\N	ARGENTINA	0101000020E6100000000000A0D2574DC000000080002D41C0
1660	alturas_prefe:51	ChanÃ¡ MinÃ­	-34.2000008	-58.4833336	0	\N	\N	\N	\N	\N	\N	\N	BUENOSAIRES	\N	\N	ARGENTINA	0101000020E6100000000000E0DD3D4DC0000000A0991941C0
1661	red_inta:1623	Sombrerito - EEA Corrientes	-27.6499996	-58.7700005	0	\N	\N	\N	\N	\N	\N	\N	Corrientes	\N	\N	ARGENTINA	0101000020E6100000000000608F624DC00000006066A63BC0
1662	red_inta:1624	Sta Victoria O -EEA Abra Pampa	-22.25	-64.9599991	0	\N	\N	\N	\N	\N	\N	\N	Salta	\N	\N	ARGENTINA	0101000020E6100000000000A0703D50C000000000004036C0
1663	red_inta:1625	Strobel	-32.0499992	-60.5999985	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E6100000000000C0CC4C4EC000000060660640C0
1664	red_inta:1626	Stroeder -EEA Hilario Ascasubi	-40.1800003	-62.6100006	0	\N	\N	\N	\N	\N	\N	\N	Buenos Aires	\N	\N	ARGENTINA	0101000020E610000000000080144E4FC0000000400A1744C0
1665	red_inta:1638	Victoria	-32.5900002	-60.1599998	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E6100000000000E07A144EC000000020854B40C0
1666	red_inta:1639	Villa Ana - EEA Reconquista	-28.4400005	-59.7999992	0	\N	\N	\N	\N	\N	\N	\N	Santa Fe	\N	\N	ARGENTINA	0101000020E61000000000006066E64DC0000000E0A3703CC0
1667	red_inta:1640	Villa Dolores - EEA Manfredi	-31.9400005	-65.2200012	0	\N	\N	\N	\N	\N	\N	\N	CÃ³rdoba	\N	\N	ARGENTINA	0101000020E610000000000080144E50C0000000E0A3F03FC0
1668	red_inta:1641	Villa Elisa	-32.1500015	-58.4099998	0	\N	\N	\N	\N	\N	\N	\N	Entre Rios	\N	\N	ARGENTINA	0101000020E6100000000000E07A344DC000000040331340C0
1669	estaciones_salto_grande:1053	Javier de Viana	-30.4328022	-56.7872124	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	Unknown	0101000020E610000000000060C3644CC000000020CC6E3EC0
1670	estaciones_salto_grande:1054	Paso FarÃ­as 	-30.4763966	-57.1249924	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	Unknown	0101000020E6100000000000C0FF8F4CC000000020F5793EC0
1671	estaciones_salto_grande:1055	Baltasar Brum	-30.7190819	-57.3252792	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	Unknown	0101000020E6100000000000C0A2A94CC0000000C015B83EC0
1672	estaciones_salto_grande:1056	Diego Lamas	-30.7557335	-57.0550156	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	Unknown	0101000020E6100000000000C00A874CC0000000C077C13EC0
1673	estaciones_salto_grande:1057	TomÃ¡s Gomensoro	-30.4318867	-57.4406281	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	Unknown	0101000020E61000000000008066B84CC000000020906E3EC0
1674	red_inta:1642	Villa Mercedes - EEA San Luis	-33.6599998	-65.4100037	0	\N	\N	\N	\N	\N	\N	\N	San Luis	\N	\N	ARGENTINA	0101000020E6100000000000803D5A50C0000000E07AD440C0
1675	red_inta:1644	Villalonga - EEA H Ascasubi	-39.9199982	-62.6199989	0	\N	\N	\N	\N	\N	\N	\N	Buenos Aires	\N	\N	ARGENTINA	0101000020E6100000000000205C4F4FC000000080C2F543C0
1676	red_inta:1645	Virasoro	-28.0900002	-56.0299988	0	\N	\N	\N	\N	\N	\N	\N	Corrientes	\N	\N	ARGENTINA	0101000020E610000000000000D7034CC0000000400A173CC0
1677	red_inta:1647	Zaiman Inta	-27.4300003	-55.8899994	0	\N	\N	\N	\N	\N	\N	\N	Sin asignar	\N	\N	ARGENTINA	0101000020E610000000000080EBF14BC000000080146E3BC0
1678	red_inta:1648	Zampalito - EEA Consulta	-33.4799995	-69.0500031	0	\N	\N	\N	\N	\N	\N	\N	Mendoza	\N	\N	ARGENTINA	0101000020E610000000000040334351C0000000A070BD40C0
1679	estaciones_salto_grande:1048	GuaviyÃº de Arapey	-31.0376015	-56.6358795	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	Unknown	0101000020E61000000000008064514CC000000040A0093FC0
1680	estaciones_salto_grande:1049	SarandÃ­ de Arapey	-30.9885578	-56.2157593	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	Unknown	0101000020E6100000000000009E1B4CC00000002012FD3EC0
1681	estaciones_salto_grande:1051	Espinillar	-30.9711876	-57.8807144	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	Unknown	0101000020E610000000000040BBF04CC0000000C09FF83EC0
1682	estaciones_salto_grande:1020	Paso de la Cruz	-30.2889996	-57.2916946	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	Unknown	0101000020E61000000000004056A54CC0000000E0FB493EC0
1683	otros_registros:526	ARECO	-34.2400017	-59.5	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	ARGENTINA	0101000020E61000000000000000C04DC000000060B81E41C0
1684	alturas_bdhi:105	Tostado	-29.2751675	-61.7439423	0	\N	\N	\N	\N	\N	\N	\N	SANTAFE	\N	\N	ARGENTINA	0101000020E61000000000008039DF4EC00000006071463DC0
1685	estaciones_salto_grande:1060	Cuchilla de Salto	-31.4444065	-57.4215088	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	Unknown	0101000020E610000000000000F4B54CC0000000A0C4713FC0
1686	estaciones_salto_grande:1061	ItapebÃ­	-31.2861271	-57.7035332	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	Unknown	0101000020E6100000000000600DDA4CC0000000A03F493FC0
1687	alturas_prefe:91	GuaÃ­ra Porto	-24.0424995	-54.2341995	0	\N	\N	\N	\N	\N	\N	\N	PARANA	\N	\N	BRASIL	0101000020E610000000000040FA1D4BC000000040E10A38C0
1688	estaciones_salto_grande:1062	MiriÃ±ay Medio	-29.3570366	-57.7050438	0	\N	\N	\N	\N	\N	\N	\N	Unknown	\N	\N	Unknown	0101000020E6100000000000E03EDA4CC0000000C0665B3DC0
1689	alturas_bdhi:106	IraÃ­	-27.1888885	-53.253334	0	\N	\N	\N	\N	\N	\N	\N	BRASIL	\N	\N	BRASIL	0101000020E6100000000000406DA04AC0000000005B303BC0
1690	alturas_bdhi:107	Santa LucÃ­a	-28.9960003	-59.1022987	0	\N	\N	\N	\N	\N	\N	\N	CORRIENTES	\N	\N	ARGENTINA	0101000020E610000000000020188D4DC0000000E0F9FE3CC0
1691	alturas_bdhi:108	San Roque	-28.5696392	-58.7172241	0	\N	\N	\N	\N	\N	\N	\N	CORRIENTES	\N	\N	ARGENTINA	0101000020E610000000000000CE5B4DC0000000E0D3913CC0
1692	alturas_bdhi:109	Paso Lucero	-28.9945564	-58.5614433	0	\N	\N	\N	\N	\N	\N	\N	CORRIENTES	\N	\N	ARGENTINA	0101000020E610000000000060DD474DC0000000409BFE3CC0
1693	alturas_bdhi:110	Segui	-31.9500008	-60.1263885	0	\N	\N	\N	\N	\N	\N	\N	ENTRERIOS	\N	\N	ARGENTINA	0101000020E6100000000000802D104EC00000004033F33FC0
1694	alturas_bdhi:111	LÃ­mite con Entre RÃ­os â Ruta Provincial nÂº 28	-30.2166386	-58.7846375	0	\N	\N	\N	\N	\N	\N	\N	ENTRERIOS	\N	\N	ARGENTINA	0101000020E6100000000000006F644DC0000000A075373EC0
1695	alturas_bdhi:112	NogoyÃ¡ Ruta Provincial nÂº 11	-32.8472519	-59.8649445	0	\N	\N	\N	\N	\N	\N	\N	ENTRERIOS	\N	\N	ARGENTINA	0101000020E610000000000080B6EE4DC0000000C0726C40C0
1696	alturas_bdhi:114	Ruta Provincial nÂº 41	-35.7246666	-58.5365295	0	\N	\N	\N	\N	\N	\N	\N	BUENOSAIRES	\N	\N	ARGENTINA	0101000020E610000000000000AD444DC0000000E0C1DC41C0
1697	alturas_bdhi:116	Ruta Provincial nÂº 39	-32.3946381	-59.7638626	0	\N	\N	\N	\N	\N	\N	\N	ENTRERIOS	\N	\N	ARGENTINA	0101000020E610000000000040C6E14DC000000080833240C0
1698	alturas_bdhi:118	Pueblo Andino	-32.6733322	-60.8659439	0	\N	\N	\N	\N	\N	\N	\N	SANTAFE	\N	\N	ARGENTINA	0101000020E610000000000040D76E4EC0000000C02F5640C0
1699	alturas_prefe:58	Bermejo	-26.9262905	-58.5062065	0	\N	\N	\N	\N	\N	\N	\N	FORMOSA	\N	\N	ARGENTINA	0101000020E610000000000060CB404DC00000006021ED3AC0
1700	alturas_prefe:59	Isla del Cerrito	-27.3166676	-58.6166649	0	\N	\N	\N	\N	\N	\N	\N	CHACO	\N	\N	ARGENTINA	0101000020E6100000000000E0EE4E4DC00000002011513BC0
1701	alturas_prefe:60	PepirÃ­ MinÃ­	-27.1537437	-53.9331474	0	\N	\N	\N	\N	\N	\N	\N	MISIONES	\N	\N	ARGENTINA	0101000020E61000000000006071F74AC0000000C05B273BC0
1702	alturas_prefe:62	Alicia	-27.4375	-54.3553009	0	\N	\N	\N	\N	\N	\N	\N	MISIONES	\N	\N	ARGENTINA	0101000020E6100000000000807A2D4BC00000000000703BC0
1703	alturas_prefe:63	Alba Posse	-27.5720005	-54.6784935	0	\N	\N	\N	\N	\N	\N	\N	MISIONES	\N	\N	ARGENTINA	0101000020E6100000000000E0D8564BC0000000A06E923BC0
1704	alturas_prefe:64	PanambÃ­	-27.7306271	-54.9130516	0	\N	\N	\N	\N	\N	\N	\N	MISIONES	\N	\N	ARGENTINA	0101000020E6100000000000E0DE744BC0000000600ABB3BC0
1705	alturas_prefe:97	Brazo Largo	-33.8833351	-58.9000015	0	\N	\N	\N	\N	\N	\N	\N	ENTRERIOS	\N	\N	ARGENTINA	0101000020E61000000000004033734DC00000002011F140C0
1706	alturas_prefe:9	Puerto IguazÃº	-25.583334	-54.5666656	0	\N	\N	\N	\N	\N	\N	\N	MISIONES	\N	\N	ARGENTINA	0101000020E61000000000008088484BC000000060559539C0
1707	alturas_prefe:93	Confluencia	-25.592701	-54.5933647	0	\N	\N	\N	\N	\N	\N	\N	BRASIL	\N	\N	ARGENTINA	0101000020E610000000000060F34B4BC000000040BB9739C0
1708	alturas_prefe:87	YacyretÃ¡ afluente	-27.4825573	-56.7272453	0	\N	\N	\N	\N	\N	\N	\N	CORRIENTES	\N	\N	ARGENTINA	0101000020E610000000000060165D4CC0000000E0887B3BC0
1709	alturas_varios:1698	Carapachay	-34.3562012	-58.6338348	0	\N	\N	\N	\N	\N	\N	\N	BUENOSAIRES	\N	\N	ARGENTINA	0101000020E61000000000008021514DC000000000982D41C0
1710	alturas_varios:1699	Nueva Palmira	-33.878479	-58.4220276	0	\N	\N	\N	\N	\N	\N	\N	Colonia	\N	\N	URUGUAY	0101000020E61000000000000005364DC00000000072F040C0
\.


--
-- Name: Sites_SiteID_seq; Type: SEQUENCE SET; Schema: public; Owner: jbianchi
--

SELECT pg_catalog.setval('public."Sites_SiteID_seq"', 1710, true);


--
-- Data for Name: Sources; Type: TABLE DATA; Schema: public; Owner: jbianchi
--

COPY public."Sources" ("SourceID", "Organization", "SourceDescription", "SourceLink", "ContactName", "Phone", "Email", "Address", "City", "State", "ZipCode", "Citation", "MetadataID") FROM stdin;
5	INA	Web Service WaterML del Servicio de informaciÃ³n y alerta de la Cuenca del Plata	http://localhost:8080/wateroneflow/ws	Unknown	Unknown	Unknown	Unknown	Unknown	Unknown	Unknown	INA SIyAH 2018	0
\.


--
-- Name: Sources_SourceID_seq; Type: SEQUENCE SET; Schema: public; Owner: jbianchi
--

SELECT pg_catalog.setval('public."Sources_SourceID_seq"', 6, true);


--
-- Data for Name: SpatialReferences; Type: TABLE DATA; Schema: public; Owner: jbianchi
--

COPY public."SpatialReferences" ("SpatialReferenceID", "SRSID", "SRSName", "IsGeographic", "Notes") FROM stdin;
0	\N	Unknown	f	The spatial reference system is unknown
1	4267	NAD27	t	\N
2	4269	NAD83	t	\N
3	4326	WGS84	t	\N
4	26703	NAD27 / UTM zone 3N	f	\N
5	26704	NAD27 / UTM zone 4N	f	\N
6	26705	NAD27 / UTM zone 5N	f	\N
7	26706	NAD27 / UTM zone 6N	f	\N
8	26707	NAD27 / UTM zone 7N	f	\N
9	26708	NAD27 / UTM zone 8N	f	\N
10	26709	NAD27 / UTM zone 9N	f	\N
11	26710	NAD27 / UTM zone 10N	f	\N
12	26711	NAD27 / UTM zone 11N	f	\N
13	26712	NAD27 / UTM zone 12N	f	\N
14	26713	NAD27 / UTM zone 13N	f	\N
15	26714	NAD27 / UTM zone 14N	f	\N
16	26715	NAD27 / UTM zone 15N	f	\N
17	26716	NAD27 / UTM zone 16N	f	\N
18	26717	NAD27 / UTM zone 17N	f	\N
19	26718	NAD27 / UTM zone 18N	f	\N
20	26719	NAD27 / UTM zone 19N	f	\N
21	26720	NAD27 / UTM zone 20N	f	\N
22	26721	NAD27 / UTM zone 21N	f	\N
23	26722	NAD27 / UTM zone 22N	f	\N
24	26729	NAD27 / Alabama East	f	\N
25	26730	NAD27 / Alabama West	f	\N
26	26732	NAD27 / Alaska zone 2	f	\N
27	26733	NAD27 / Alaska zone 3	f	\N
28	26734	NAD27 / Alaska zone 4	f	\N
29	26735	NAD27 / Alaska zone 5	f	\N
30	26736	NAD27 / Alaska zone 6	f	\N
31	26737	NAD27 / Alaska zone 7	f	\N
32	26738	NAD27 / Alaska zone 8	f	\N
33	26739	NAD27 / Alaska zone 9	f	\N
34	26740	NAD27 / Alaska zone 10	f	\N
35	26741	NAD27 / California zone I	f	\N
36	26742	NAD27 / California zone II	f	\N
37	26743	NAD27 / California zone III	f	\N
38	26744	NAD27 / California zone IV	f	\N
39	26745	NAD27 / California zone V	f	\N
40	26746	NAD27 / California zone VI	f	\N
41	26747	NAD27 / California zone VII	f	\N
42	26748	NAD27 / Arizona East	f	\N
43	26749	NAD27 / Arizona Central	f	\N
44	26750	NAD27 / Arizona West	f	\N
45	26751	NAD27 / Arkansas North	f	\N
46	26752	NAD27 / Arkansas South	f	\N
47	26753	NAD27 / Colorado North	f	\N
48	26754	NAD27 / Colorado Central	f	\N
49	26755	NAD27 / Colorado South	f	\N
50	26756	NAD27 / Connecticut	f	\N
51	26757	NAD27 / Delaware	f	\N
52	26758	NAD27 / Florida East	f	\N
53	26759	NAD27 / Florida West	f	\N
54	26760	NAD27 / Florida North	f	\N
55	26761	NAD27 / Hawaii zone 1	f	\N
56	26762	NAD27 / Hawaii zone 2	f	\N
57	26763	NAD27 / Hawaii zone 3	f	\N
58	26764	NAD27 / Hawaii zone 4	f	\N
59	26765	NAD27 / Hawaii zone 5	f	\N
60	26766	NAD27 / Georgia East	f	\N
61	26767	NAD27 / Georgia West	f	\N
62	26768	NAD27 / Idaho East	f	\N
63	26769	NAD27 / Idaho Central	f	\N
64	26770	NAD27 / Idaho West	f	\N
65	26771	NAD27 / Illinois East	f	\N
66	26772	NAD27 / Illinois West	f	\N
67	26773	NAD27 / Indiana East	f	\N
68	26774	NAD27 / Indiana West	f	\N
69	26775	NAD27 / Iowa North	f	\N
70	26776	NAD27 / Iowa South	f	\N
71	26777	NAD27 / Kansas North	f	\N
72	26778	NAD27 / Kansas South	f	\N
73	26779	NAD27 / Kentucky North	f	\N
74	26780	NAD27 / Kentucky South	f	\N
75	26781	NAD27 / Louisiana North	f	\N
76	26782	NAD27 / Louisiana South	f	\N
77	26783	NAD27 / Maine East	f	\N
78	26784	NAD27 / Maine West	f	\N
79	26785	NAD27 / Maryland	f	\N
80	26786	NAD27 / Massachusetts Mainland	f	\N
81	26787	NAD27 / Massachusetts Island	f	\N
82	26791	NAD27 / Minnesota North	f	\N
83	26792	NAD27 / Minnesota Central	f	\N
84	26793	NAD27 / Minnesota South	f	\N
85	26794	NAD27 / Mississippi East	f	\N
86	26795	NAD27 / Mississippi West	f	\N
87	26796	NAD27 / Missouri East	f	\N
88	26797	NAD27 / Missouri Central	f	\N
89	26798	NAD27 / Missouri West	f	\N
90	26801	NAD Michigan / Michigan East	f	\N
91	26802	NAD Michigan / Michigan Old Central	f	\N
92	26803	NAD Michigan / Michigan West	f	\N
93	26811	NAD Michigan / Michigan North	f	\N
94	26812	NAD Michigan / Michigan Central	f	\N
95	26813	NAD Michigan / Michigan South	f	\N
96	26903	NAD83 / UTM zone 3N	f	\N
97	26904	NAD83 / UTM zone 4N	f	\N
98	26905	NAD83 / UTM zone 5N	f	\N
99	26906	NAD83 / UTM zone 6N	f	\N
100	26907	NAD83 / UTM zone 7N	f	\N
101	26908	NAD83 / UTM zone 8N	f	\N
102	26909	NAD83 / UTM zone 9N	f	\N
103	26910	NAD83 / UTM zone 10N	f	\N
104	26911	NAD83 / UTM zone 11N	f	\N
105	26912	NAD83 / UTM zone 12N	f	\N
106	26913	NAD83 / UTM zone 13N	f	\N
107	26914	NAD83 / UTM zone 14N	f	\N
108	26915	NAD83 / UTM zone 15N	f	\N
109	26916	NAD83 / UTM zone 16N	f	\N
110	26917	NAD83 / UTM zone 17N	f	\N
111	26918	NAD83 / UTM zone 18N	f	\N
112	26919	NAD83 / UTM zone 19N	f	\N
113	26920	NAD83 / UTM zone 20N	f	\N
114	26921	NAD83 / UTM zone 21N	f	\N
115	26922	NAD83 / UTM zone 22N	f	\N
116	26923	NAD83 / UTM zone 23N	f	\N
117	26929	NAD83 / Alabama East	f	\N
118	26930	NAD83 / Alabama West	f	\N
119	26932	NAD83 / Alaska zone 2	f	\N
120	26933	NAD83 / Alaska zone 3	f	\N
121	26934	NAD83 / Alaska zone 4	f	\N
122	26935	NAD83 / Alaska zone 5	f	\N
123	26936	NAD83 / Alaska zone 6	f	\N
124	26937	NAD83 / Alaska zone 7	f	\N
125	26938	NAD83 / Alaska zone 8	f	\N
126	26939	NAD83 / Alaska zone 9	f	\N
127	26940	NAD83 / Alaska zone 10	f	\N
128	26941	NAD83 / California zone 1	f	\N
129	26942	NAD83 / California zone 2	f	\N
130	26943	NAD83 / California zone 3	f	\N
131	26944	NAD83 / California zone 4	f	\N
132	26945	NAD83 / California zone 5	f	\N
133	26946	NAD83 / California zone 6	f	\N
134	26948	NAD83 / Arizona East	f	\N
135	26949	NAD83 / Arizona Central	f	\N
136	26950	NAD83 / Arizona West	f	\N
137	26951	NAD83 / Arkansas North	f	\N
138	26952	NAD83 / Arkansas South	f	\N
139	26953	NAD83 / Colorado North	f	\N
140	26954	NAD83 / Colorado Central	f	\N
141	26955	NAD83 / Colorado South	f	\N
142	26956	NAD83 / Connecticut	f	\N
143	26957	NAD83 / Delaware	f	\N
144	26958	NAD83 / Florida East	f	\N
145	26959	NAD83 / Florida West	f	\N
146	26960	NAD83 / Florida North	f	\N
147	26961	NAD83 / Hawaii zone 1	f	\N
148	26962	NAD83 / Hawaii zone 2	f	\N
149	26963	NAD83 / Hawaii zone 3	f	\N
150	26964	NAD83 / Hawaii zone 4	f	\N
151	26965	NAD83 / Hawaii zone 5	f	\N
152	26966	NAD83 / Georgia East	f	\N
153	26967	NAD83 / Georgia West	f	\N
154	26968	NAD83 / Idaho East	f	\N
155	26969	NAD83 / Idaho Central	f	\N
156	26970	NAD83 / Idaho West	f	\N
157	26971	NAD83 / Illinois East	f	\N
158	26972	NAD83 / Illinois West	f	\N
159	26973	NAD83 / Indiana East	f	\N
160	26974	NAD83 / Indiana West	f	\N
161	26975	NAD83 / Iowa North	f	\N
162	26976	NAD83 / Iowa South	f	\N
163	26977	NAD83 / Kansas North	f	\N
164	26978	NAD83 / Kansas South	f	\N
165	26979	NAD83 / Kentucky North	f	\N
166	26980	NAD83 / Kentucky South	f	\N
167	26981	NAD83 / Louisiana North	f	\N
168	26982	NAD83 / Louisiana South	f	\N
169	26983	NAD83 / Maine East	f	\N
170	26984	NAD83 / Maine West	f	\N
171	26985	NAD83 / Maryland	f	\N
172	26986	NAD83 / Massachusetts Mainland	f	\N
173	26987	NAD83 / Massachusetts Island	f	\N
174	26988	NAD83 / Michigan North	f	\N
175	26989	NAD83 / Michigan Central	f	\N
176	26990	NAD83 / Michigan South	f	\N
177	26991	NAD83 / Minnesota North	f	\N
178	26992	NAD83 / Minnesota Central	f	\N
179	26993	NAD83 / Minnesota South	f	\N
180	26994	NAD83 / Mississippi East	f	\N
181	26995	NAD83 / Mississippi West	f	\N
182	26996	NAD83 / Missouri East	f	\N
183	26997	NAD83 / Missouri Central	f	\N
184	26998	NAD83 / Missouri West  	f	\N
185	4176	Australian Antarctic	t	Datum Name: Australian Antarctic Datum 1998    Area of Use: Antarctica - Australian sector.    Datum Origin: No Data Available    Coord System: ellipsoidal    Ellipsoid Name: GRS 1980    Data Source: EPSG
186	4203	AGD84	t	Datum Name: Australian Geodetic Datum 1984    Area of Use: Australia - Queensland (Qld), South Australia (SA), Western Australia (WA).    Datum Origin: Fundamental point: Johnson Memorial Cairn. Latitude: 25 deg 56 min 54.5515 sec S; Longitude: 133 deg 12 min 30.0771 sec E (of Greenwich).    Coord System: ellipsoidal    Ellipsoid Name: Australian National Spheroid    Data Source: EPSG
187	4283	GDA94	t	Datum Name: Geocentric Datum of Australia 1994    Area of Use: Australia - Australian Capital Territory (ACT); New South Wales (NSW); Northern Territory (NT); Queensland (Qld); South Australia (SA); Tasmania (Tas); Western Australia (WA); Victoria (Vic).    Datum Origin: ITRF92 at epoch 1994.0    Coord System: ellipsoidal    Ellipsoid Name: GRS 1980    Data Source: EPSG
188	5711	Australian Height Datum	f	Datum Name: Australian Height Datum    Area of Use: Australia - Australian Capital Territory (ACT); New South Wales (NSW); Northern Territory (NT); Queensland; South Australia (SA); Western Australia (WA); Victoria.    Datum Origin: MSL 1966-68 at 30 gauges around coast.    Coord System: vertical    Ellipsoid Name: No Data Available    Data Source: EPSG
189	5712	Australian Height Datum (Tasmania)	f	Datum Name: Australian Height Datum (Tasmania)    Area of Use: Australia - Tasmania (Tas).    Datum Origin: MSL 1972 at Hobart and Burnie.    Coord System: vertical    Ellipsoid Name: No Data Available    Data Source: EPSG
190	5714	Mean Sea Level Height	f	Datum Name: Mean Sea Level    Area of Use: World.    Datum Origin: No Data Available    Coord System: vertical    Ellipsoid Name: No Data Available    Data Source: EPSG
191	5715	Mean Sea Level Depth	f	Datum Name: Mean Sea Level    Area of Use: World.    Datum Origin: No Data Available    Coord System: vertical    Ellipsoid Name: No Data Available    Data Source: EPSG
192	20348	AGD84 / AMG zone 48	f	Datum Name: Australian Geodetic Datum 1984    Area of Use: Australia - between 102 and 108 deg East.    Datum Origin: Fundamental point: Johnson Memorial Cairn. Latitude: 25 deg 56 min 54.5515 sec S; Longitude: 133 deg 12 min 30.0771 sec E (of Greenwich).    Coord System: Cartesian    Ellipsoid Name: Australian National Spheroid    Data Source: EPSG
193	20349	AGD84 / AMG zone 49	f	Datum Name: Australian Geodetic Datum 1984    Area of Use: Australia - between 108 and 114 deg East.    Datum Origin: Fundamental point: Johnson Memorial Cairn. Latitude: 25 deg 56 min 54.5515 sec S; Longitude: 133 deg 12 min 30.0771 sec E (of Greenwich).    Coord System: Cartesian    Ellipsoid Name: Australian National Spheroid    Data Source: EPSG
194	20350	AGD84 / AMG zone 50	f	Datum Name: Australian Geodetic Datum 1984    Area of Use: Australia - between 114 and 120 deg East.    Datum Origin: Fundamental point: Johnson Memorial Cairn. Latitude: 25 deg 56 min 54.5515 sec S; Longitude: 133 deg 12 min 30.0771 sec E (of Greenwich).    Coord System: Cartesian    Ellipsoid Name: Australian National Spheroid    Data Source: EPSG
195	20351	AGD84 / AMG zone 51	f	Datum Name: Australian Geodetic Datum 1984    Area of Use: Australia - between 120 and 126 deg East.    Datum Origin: Fundamental point: Johnson Memorial Cairn. Latitude: 25 deg 56 min 54.5515 sec S; Longitude: 133 deg 12 min 30.0771 sec E (of Greenwich).    Coord System: Cartesian    Ellipsoid Name: Australian National Spheroid    Data Source: EPSG
196	20352	AGD84 / AMG zone 52	f	Datum Name: Australian Geodetic Datum 1984    Area of Use: Australia - between 126 and 132 deg East.    Datum Origin: Fundamental point: Johnson Memorial Cairn. Latitude: 25 deg 56 min 54.5515 sec S; Longitude: 133 deg 12 min 30.0771 sec E (of Greenwich).    Coord System: Cartesian    Ellipsoid Name: Australian National Spheroid    Data Source: EPSG
197	20353	AGD84 / AMG zone 53	f	Datum Name: Australian Geodetic Datum 1984    Area of Use: Australia - between 132 and 138 deg East.    Datum Origin: Fundamental point: Johnson Memorial Cairn. Latitude: 25 deg 56 min 54.5515 sec S; Longitude: 133 deg 12 min 30.0771 sec E (of Greenwich).    Coord System: Cartesian    Ellipsoid Name: Australian National Spheroid    Data Source: EPSG
198	20354	AGD84 / AMG zone 54	f	Datum Name: Australian Geodetic Datum 1984    Area of Use: Australia - between 138 and 144 deg East.    Datum Origin: Fundamental point: Johnson Memorial Cairn. Latitude: 25 deg 56 min 54.5515 sec S; Longitude: 133 deg 12 min 30.0771 sec E (of Greenwich).    Coord System: Cartesian    Ellipsoid Name: Australian National Spheroid    Data Source: EPSG
199	20355	AGD84 / AMG zone 55	f	Datum Name: Australian Geodetic Datum 1984    Area of Use: Australia - between 144 and 150 deg East.    Datum Origin: Fundamental point: Johnson Memorial Cairn. Latitude: 25 deg 56 min 54.5515 sec S; Longitude: 133 deg 12 min 30.0771 sec E (of Greenwich).    Coord System: Cartesian    Ellipsoid Name: Australian National Spheroid    Data Source: EPSG
200	20356	AGD84 / AMG zone 56	f	Datum Name: Australian Geodetic Datum 1984    Area of Use: Australia - between 150 and 156 deg East.    Datum Origin: Fundamental point: Johnson Memorial Cairn. Latitude: 25 deg 56 min 54.5515 sec S; Longitude: 133 deg 12 min 30.0771 sec E (of Greenwich).    Coord System: Cartesian    Ellipsoid Name: Australian National Spheroid    Data Source: EPSG
201	20357	AGD84 / AMG zone 57	f	Datum Name: Australian Geodetic Datum 1984    Area of Use: Australia - between 156 and 162 deg East.    Datum Origin: Fundamental point: Johnson Memorial Cairn. Latitude: 25 deg 56 min 54.5515 sec S; Longitude: 133 deg 12 min 30.0771 sec E (of Greenwich).    Coord System: Cartesian    Ellipsoid Name: Australian National Spheroid    Data Source: EPSG
202	20358	AGD84 / AMG zone 58	f	Datum Name: Australian Geodetic Datum 1984    Area of Use: Australia - between 162 and 168 deg East.    Datum Origin: Fundamental point: Johnson Memorial Cairn. Latitude: 25 deg 56 min 54.5515 sec S; Longitude: 133 deg 12 min 30.0771 sec E (of Greenwich).    Coord System: Cartesian    Ellipsoid Name: Australian National Spheroid    Data Source: EPSG
203	28348	GDA94 / MGA zone 48	f	Datum Name: Geocentric Datum of Australia 1994    Area of Use: Australia - between 102 and 108 deg East.    Datum Origin: ITRF92 at epoch 1994.0    Coord System: Cartesian    Ellipsoid Name: GRS 1980    Data Source: EPSG
204	28349	GDA94 / MGA zone 49	f	Datum Name: Geocentric Datum of Australia 1994    Area of Use: Australia - between 108 and 114 deg East.    Datum Origin: ITRF92 at epoch 1994.0    Coord System: Cartesian    Ellipsoid Name: GRS 1980    Data Source: EPSG
205	28350	GDA94 / MGA zone 50	f	Datum Name: Geocentric Datum of Australia 1994    Area of Use: Australia - between 114 and 120 deg East.    Datum Origin: ITRF92 at epoch 1994.0    Coord System: Cartesian    Ellipsoid Name: GRS 1980    Data Source: EPSG
206	28351	GDA94 / MGA zone 51	f	Datum Name: Geocentric Datum of Australia 1994    Area of Use: Australia - between 120 and 126 deg East.    Datum Origin: ITRF92 at epoch 1994.0    Coord System: Cartesian    Ellipsoid Name: GRS 1980    Data Source: EPSG
207	28352	GDA94 / MGA zone 52	f	Datum Name: Geocentric Datum of Australia 1994    Area of Use: Australia - between 126 and 132 deg East.    Datum Origin: ITRF92 at epoch 1994.0    Coord System: Cartesian    Ellipsoid Name: GRS 1980    Data Source: EPSG
208	28353	GDA94 / MGA zone 53	f	Datum Name: Geocentric Datum of Australia 1994    Area of Use: Australia - between 132 and 138 deg East.    Datum Origin: ITRF92 at epoch 1994.0    Coord System: Cartesian    Ellipsoid Name: GRS 1980    Data Source: EPSG
209	28354	GDA94 / MGA zone 54	f	Datum Name: Geocentric Datum of Australia 1994    Area of Use: Australia - between 138 and 144 deg East.    Datum Origin: ITRF92 at epoch 1994.0    Coord System: Cartesian    Ellipsoid Name: GRS 1980    Data Source: EPSG
210	28355	GDA94 / MGA zone 55	f	Datum Name: Geocentric Datum of Australia 1994    Area of Use: Australia - between 144 and 150 deg East.    Datum Origin: ITRF92 at epoch 1994.0    Coord System: Cartesian    Ellipsoid Name: GRS 1980    Data Source: EPSG
211	28356	GDA94 / MGA zone 56	f	Datum Name: Geocentric Datum of Australia 1994    Area of Use: Australia - between 150 and 156 deg East.    Datum Origin: ITRF92 at epoch 1994.0    Coord System: Cartesian    Ellipsoid Name: GRS 1980    Data Source: EPSG
212	28357	GDA94 / MGA zone 57	f	Datum Name: Geocentric Datum of Australia 1994    Area of Use: Australia - between 156 and 162 deg East.    Datum Origin: ITRF92 at epoch 1994.0    Coord System: Cartesian    Ellipsoid Name: GRS 1980    Data Source: EPSG
213	28358	GDA94 / MGA zone 58	f	Datum Name: Geocentric Datum of Australia 1994    Area of Use: Australia - between 162 and 168 deg East.    Datum Origin: ITRF92 at epoch 1994.0    Coord System: Cartesian    Ellipsoid Name: GRS 1980    Data Source: EPSG
214	32748	WGS 84 / UTM zone 48S	f	Datum Name: World Geodetic System 1984    Area of Use: Between 102 and 108 deg East; southern hemisphere. Indonesia.    Datum Origin: Defined through a consistent set of station coordinates. These have changed with time: by 0.7m on 29/6/1994 [WGS 84 (G730)], a further 0.2m on 29/1/1997 [WGS 84 (G873)] and a further 0.06m on 20/1/2002 [WGS 84 (G1150)].    Coord System: Cartesian    Ellipsoid Name: WGS 84    Data Source: EPSG
215	32749	WGS 84 / UTM zone 49S	f	Datum Name: World Geodetic System 1984    Area of Use: Between 108 and 114 deg East; southern hemisphere. Australia. Indonesia.    Datum Origin: Defined through a consistent set of station coordinates. These have changed with time: by 0.7m on 29/6/1994 [WGS 84 (G730)], a further 0.2m on 29/1/1997 [WGS 84 (G873)] and a further 0.06m on 20/1/2002 [WGS 84 (G1150)].    Coord System: Cartesian    Ellipsoid Name: WGS 84    Data Source: EPSG
216	32750	WGS 84 / UTM zone 50S	f	Datum Name: World Geodetic System 1984    Area of Use: Between 114 and 120 deg East; southern hemisphere. Australia. Indonesia.    Datum Origin: Defined through a consistent set of station coordinates. These have changed with time: by 0.7m on 29/6/1994 [WGS 84 (G730)], a further 0.2m on 29/1/1997 [WGS 84 (G873)] and a further 0.06m on 20/1/2002 [WGS 84 (G1150)].    Coord System: Cartesian    Ellipsoid Name: WGS 84    Data Source: EPSG
217	32751	WGS 84 / UTM zone 51S	f	Datum Name: World Geodetic System 1984    Area of Use: Between 120 and 126 deg East; southern hemisphere. Australia. East Timor. Indonesia.    Datum Origin: Defined through a consistent set of station coordinates. These have changed with time: by 0.7m on 29/6/1994 [WGS 84 (G730)], a further 0.2m on 29/1/1997 [WGS 84 (G873)] and a further 0.06m on 20/1/2002 [WGS 84 (G1150)].    Coord System: Cartesian    Ellipsoid Name: WGS 84    Data Source: EPSG
218	32752	WGS 84 / UTM zone 52S	f	Datum Name: World Geodetic System 1984    Area of Use: Between 126 and 132 deg East; southern hemisphere. Australia. East Timor. Indonesia.    Datum Origin: Defined through a consistent set of station coordinates. These have changed with time: by 0.7m on 29/6/1994 [WGS 84 (G730)], a further 0.2m on 29/1/1997 [WGS 84 (G873)] and a further 0.06m on 20/1/2002 [WGS 84 (G1150)].    Coord System: Cartesian    Ellipsoid Name: WGS 84    Data Source: EPSG
219	32753	WGS 84 / UTM zone 53S	f	Datum Name: World Geodetic System 1984    Area of Use: Between 132 and 138 deg East; southern hemisphere. Australia.  Indonesia.    Datum Origin: Defined through a consistent set of station coordinates. These have changed with time: by 0.7m on 29/6/1994 [WGS 84 (G730)], a further 0.2m on 29/1/1997 [WGS 84 (G873)] and a further 0.06m on 20/1/2002 [WGS 84 (G1150)].    Coord System: Cartesian    Ellipsoid Name: WGS 84    Data Source: EPSG
220	32754	WGS 84 / UTM zone 54S	f	Datum Name: World Geodetic System 1984    Area of Use: Between 138 and 144 deg East; southern hemisphere. Australia. Indonesia. Papua New Guinea.    Datum Origin: Defined through a consistent set of station coordinates. These have changed with time: by 0.7m on 29/6/1994 [WGS 84 (G730)], a further 0.2m on 29/1/1997 [WGS 84 (G873)] and a further 0.06m on 20/1/2002 [WGS 84 (G1150)].    Coord System: Cartesian    Ellipsoid Name: WGS 84    Data Source: EPSG
221	32755	WGS 84 / UTM zone 55S	f	Datum Name: World Geodetic System 1984    Area of Use: Between 144 and 150 deg East; southern hemisphere. Australia. Papua New Guinea.    Datum Origin: Defined through a consistent set of station coordinates. These have changed with time: by 0.7m on 29/6/1994 [WGS 84 (G730)], a further 0.2m on 29/1/1997 [WGS 84 (G873)] and a further 0.06m on 20/1/2002 [WGS 84 (G1150)].    Coord System: Cartesian    Ellipsoid Name: WGS 84    Data Source: EPSG
222	32756	WGS 84 / UTM zone 56S	f	Datum Name: World Geodetic System 1984    Area of Use: Between 150 and 156 deg East; southern hemisphere. Australia. Papua New Guinea.    Datum Origin: Defined through a consistent set of station coordinates. These have changed with time: by 0.7m on 29/6/1994 [WGS 84 (G730)], a further 0.2m on 29/1/1997 [WGS 84 (G873)] and a further 0.06m on 20/1/2002 [WGS 84 (G1150)].    Coord System: Cartesian    Ellipsoid Name: WGS 84    Data Source: EPSG
223	32757	WGS 84 / UTM zone 57S	f	Datum Name: World Geodetic System 1984    Area of Use: Between 156 and 162 deg East; southern hemisphere.    Datum Origin: Defined through a consistent set of station coordinates. These have changed with time: by 0.7m on 29/6/1994 [WGS 84 (G730)], a further 0.2m on 29/1/1997 [WGS 84 (G873)] and a further 0.06m on 20/1/2002 [WGS 84 (G1150)].    Coord System: Cartesian    Ellipsoid Name: WGS 84    Data Source: EPSG
224	32758	WGS 84 / UTM zone 58S	f	Datum Name: World Geodetic System 1984    Area of Use: Between 162 and 168 deg East; southern hemisphere.    Datum Origin: Defined through a consistent set of station coordinates. These have changed with time: by 0.7m on 29/6/1994 [WGS 84 (G730)], a further 0.2m on 29/1/1997 [WGS 84 (G873)] and a further 0.06m on 20/1/2002 [WGS 84 (G1150)].    Coord System: Cartesian    Ellipsoid Name: WGS 84    Data Source: EPSG
225	3308	GDA94 / NSW Lambert	f	Datum Name: Geocentric Datum of Australia 1994 Area of Use: Australia - New South Wales (NSW). Datum Origin: ITRF92 at epoch 1994.0  Ellipsoid Name: GRS 1980 Data Source: EPSG
226	2914	NAD_1983_HARN_StatePlane_Oregon_South_FIPS_3602_Feet_Intl	f	I wonder if we can't just load the entire list at:\\nhttp://www.arcwebservices.com/v2006/help/index_Left.htm#StartTopic=support/pcs_name.htm#|SkinName=ArcWeb \\ninto the CV??
227	2276	NAD83 / Texas North Central (ftUS)	f	ESRI Name: NAD_1983_StatePlane_Texas_North_Central_FIPS_4202_Feet\\nArea of Use: United States (USA) - Texas - counties of: Andrews; Archer; Bailey; Baylor; Borden; Bowie; Callahan; Camp; Cass; Clay; Cochran; Collin; Cooke; Cottle; Crosby; Dallas; Dawson; Delta; Denton; Dickens; Eastland; Ellis; Erath; Fannin; Fisher; Floyd; Foard; Franklin; Gaines; Garza; Grayson; Gregg; Hale; Hardeman; Harrison; Haskell; Henderson; Hill; Hockley; Hood; Hopkins; Howard; Hunt; Jack; Johnson; Jones; Kaufman; Kent; King; Knox; Lamar; Lamb; Lubbock; Lynn; Marion; Martin; Mitchell; Montague; Morris; Motley; Navarro; Nolan; Palo Pinto; Panola; Parker; Rains; Red River; Rockwall; Rusk; Scurry; Shackelford; Smith; Somervell; Stephens; Stonewall; Tarrant; Taylor; Terry; Throckmorton; Titus; Upshur; Van Zandt; Wichita; Wilbarger; Wise; Wood; Yoakum; Young.
228	0	HRAP Grid Coordinate System	f	Datum Name: Hydrologic Rainfall Analysis Project (HRAP) grid coordinate system  Information: a polar stereographic projection true at 60°N / 105°W  Link:  http://www.nws.noaa.gov/oh/hrl/distmodel/hrap.htm#background
\.


--
-- Name: SpatialReferences_SpatialReferenceID_seq; Type: SEQUENCE SET; Schema: public; Owner: jbianchi
--

SELECT pg_catalog.setval('public."SpatialReferences_SpatialReferenceID_seq"', 1, false);


--
-- Data for Name: SpeciationCV; Type: TABLE DATA; Schema: public; Owner: jbianchi
--

COPY public."SpeciationCV" ("Term", "Definition") FROM stdin;
Al	Expressed as aluminium
As	Expressed as arsenic
B	Expressed as boron
Ba	Expressed as barium
Br	Expressed as bromine
C	Expressed as carbon
C2H6	Expressed as ethane
Ca	Expressed as calcium
CaCO3	Expressed as calcium carbonate
Cd	Expressed as cadmium
CH4	Expressed as methane
Cl	Expressed as chlorine
Co	Expressed as cobalt
CO2	Expressed as carbon dioxide
CO3	Expressed as carbonate
Cr	Expressed as chromium
Cu	Expressed as copper
delta 2H	Expressed as deuterium
delta N15	Expressed as nitrogen-15
delta O18 	Expressed as oxygen-18
EC	Expressed as electrical conductivity
F	Expressed as fluorine 
Fe	Expressed as iron
H2O	Expressed as water
HCO3	Expressed as hydrogen carbonate
Hg	Expressed as mercury
K	Expressed as potassium
Mg	Expressed as magnesium
Mn	Expressed as manganese
Mo	Expressed as molybdenum
N	Expressed as nitrogen
Na	Expressed as sodium
NH4	Expressed as ammonium
Ni	Expressed as nickel
NO2	Expressed as nitrite
NO3	Expressed as nitrate
Not Applicable	Speciation is not applicable
P	Expressed as phosphorus
Pb	Expressed as lead
pH	Expressed as pH
PO4	Expressed as phosphate
S	Expressed as Sulfur
Sb	Expressed as antimony
Se	Expressed as selenium
Si	Expressed as silicon
SiO2	Expressed as silicate
SN	Expressed as tin
SO4	Expressed as Sulfate
Sr	Expressed as strontium
TA	Expressed as total alkalinity
Ti	Expressed as titanium
Tl	Expressed as thallium
U	Expressed as uranium
Unknown	Speciation is unknown
V	Expressed as vanadium
Zn	Expressed as zinc
Zr	Expressed as zircon
\.


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
-- Data for Name: Units; Type: TABLE DATA; Schema: public; Owner: jbianchi
--

COPY public."Units" ("UnitsID", "UnitsName", "UnitsType", "UnitsAbbreviation") FROM stdin;
1	percent	Dimensionless	%
2	degree	Angle	deg
3	grad	Angle	grad
4	radian	Angle	rad
5	degree north	Angle	degN
6	degree south	Angle	degS
7	degree west	Angle	degW
8	degree east	Angle	degE
9	arcminute	Angle	arcmin
10	arcsecond	Angle	arcsec
11	steradian	Angle	sr
12	acre	Area	ac
13	hectare	Area	ha
14	square centimeter	Area	cm^2
15	square foot	Area	ft^2
16	square kilometer	Area	km^2
17	square meter	Area	m^2
18	square mile	Area	mi^2
19	hertz	Frequency	Hz
20	darcy	Permeability	D
21	british thermal unit	Energy	BTU
22	calorie	Energy	cal
23	erg	Energy	erg
24	foot pound force	Energy	lbf ft
25	joule	Energy	J
26	kilowatt hour	Energy	kW hr
27	electronvolt	Energy	eV
28	langleys per day	Energy Flux	Ly/d
29	langleys per minute	Energy Flux	Ly/min
30	langleys per second	Energy Flux	Ly/s
31	megajoules per square meter per day	Energy Flux	MJ/m^2 d
32	watts per square centimeter	Energy Flux	W/cm^2
33	watts per square meter	Energy Flux	W/m^2
34	acre feet per year	Flow	ac ft/yr
35	cubic feet per second	Flow	cfs
36	cubic meters per second	Flow	m^3/s
37	cubic meters per day	Flow	m^3/d
38	gallons per minute	Flow	gpm
39	liters per second	Flow	L/s
40	million gallons per day	Flow	MGD
41	dyne	Force	dyn
42	kilogram force	Force	kgf
43	newton	Force	N
44	pound force	Force	lbf
45	kilo pound force	Force	kip
46	ounce force	Force	ozf
47	centimeter   	Length	cm
48	international foot	Length	ft
49	international inch	Length	in
50	international yard	Length	yd
51	kilometer	Length	km
52	meter	Length	m
53	international mile	Length	mi
54	millimeter	Length	mm
55	micron	Length	um
56	angstrom	Length	Å
57	femtometer	Length	fm
58	nautical mile	Length	nmi
59	lumen	Light	lm
60	lux	Light	lx
61	lambert	Light	La
62	stilb	Light	sb
63	phot	Light	ph
64	langley	Light	Ly
65	gram	Mass	g
66	kilogram	Mass	kg
67	milligram	Mass	mg
68	microgram	Mass	ug
69	pound mass (avoirdupois)	Mass	lb
70	slug	Mass	slug
71	metric ton	Mass	tonne
72	grain	Mass	grain
73	carat	Mass	car
74	atomic mass unit	Mass	amu
75	short ton	Mass	ton
76	BTU per hour	Power	BTU/hr
77	foot pound force per second	Power	lbf/s
78	horse power (shaft)	Power	hp
79	kilowatt	Power	kW
80	watt	Power	W
81	voltampere	Power	VA
82	atmospheres	Pressure/Stress	atm
83	pascal	Pressure/Stress	Pa
84	inch of mercury	Pressure/Stress	inch Hg
85	inch of water	Pressure/Stress	inch H2O
86	millimeter of mercury	Pressure/Stress	mm Hg
87	millimeter of water	Pressure/Stress	mm H2O
88	centimeter of mercury	Pressure/Stress	cm Hg
89	centimeter of water	Pressure/Stress	cm H2O
90	millibar	Pressure/Stress	mbar
91	pound force per square inch	Pressure/Stress	psi
92	torr	Pressure/Stress	torr
93	barie	Pressure/Stress	barie
94	meters per pixel	Resolution	meters per pixel
95	meters per meter	Scale	-
96	degree celsius	Temperature	degC
97	degree fahrenheit	Temperature	degF
98	degree rankine	Temperature	degR
99	degree kelvin	Temperature	degK
100	second	Time	s
101	millisecond	Time	millisec
102	minute	Time	min
103	hour	Time	hr
104	day	Time	d
105	week	Time	week
106	month	Time	month
107	common year (365 days)	Time	yr
108	leap year (366 days)	Time	leap yr
109	Julian year (365.25 days)	Time	jul yr
110	Gregorian year (365.2425 days)	Time	greg yr
111	centimeters per hour	Velocity	cm/hr
112	centimeters per second	Velocity	cm/s
113	feet per second	Velocity	ft/s
114	gallons per day per square foot	Velocity	gpd/ft^2
115	inches per hour	Velocity	in/hr
116	kilometers per hour	Velocity	km/h
117	meters per day	Velocity	m/d
118	meters per hour	Velocity	m/hr
119	meters per second	Velocity	m/s
120	miles per hour	Velocity	mph
121	millimeters per hour	Velocity	mm/hr
122	nautical mile per hour	Velocity	knot
123	acre foot	Volume	ac ft
124	cubic centimeter	Volume	cc
125	cubic foot	Volume	ft^3
126	cubic meter	Volume	m^3
127	hectare meter	Volume	hec m
128	liter	Volume	L
129	US gallon	Volume	gal
130	barrel	Volume	bbl
131	pint	Volume	pt
132	bushel	Volume	bu
133	teaspoon	Volume	tsp
134	tablespoon	Volume	tbsp
135	quart	Volume	qrt
136	ounce	Volume	oz
137	dimensionless	Dimensionless	-
138	mega joule	Energy	MJ
139	degrees minutes seconds	Angle	dddmmss
140	calories per square centimeter per day	Energy Flux	cal/cm^2 d
141	calories per square centimeter per minute	Energy Flux	cal/cm^2 min
142	milliliters per square centimeter per day	Hyporheic flux	ml/cm^2 d
144	megajoules per square meter	Energy per Area	MJ/m^2
145	gallons per day	Flow	gpd
146	million gallons per month	Flow	MGM
147	million gallons per year	Flow	MGY
148	short tons per day per foot	Mass flow per unit width	ton/d ft
149	lumens per square foot	Light Intensity	lm/ft^2
150	microeinsteins per square meter per second	Light Intensity	uE/m^2 s
151	alphas per meter	Light	a/m
152	microeinsteins per square meter	Light	uE/m^2
153	millimoles of photons per square meter	Light	mmol/m^2
154	absorbance per centimeter	Extinction/Absorbance	A/cm
155	nanogram	Mass	ng
156	picogram	Mass	pg
157	milliequivalents	Mass	meq
158	grams per square meter	Areal Density	g/m^2
159	milligrams per square meter	Areal Density	mg/m^2
160	micrograms per square meter	Areal Density	ug/m^2
161	grams per square meter per day	Areal Loading	g/m^2 d
162	grams per day	Loading	g/d
163	pounds per day	Loading	lb/d
164	pounds per mile	Loading	lb/mi
165	short tons per day	Loading	ton/d
166	milligrams per cubic meter per day	Productivity	mg/m^3 d
167	milligrams per square meter per day	Productivity	mg/m^2 d
168	volts	Potential Difference	V
169	millivolts	Potential Difference	mV
170	kilopascal	Pressure/Stress	kPa
171	megapascal	Pressure/Stress	MPa
172	becquerel	Radioactivity	Bq
173	becquerels per gram	Radioactivity	Bq/g
174	curie	Radioactivity	Ci
175	picocurie	Radioactivity	pCi
176	ohm	Resistance	ohm
177	ohm meter	Resistivity	ohm m
178	picocuries per gram	Specific Activity	pCi/g
179	picocuries per liter	Specific Activity	pCi/L
180	picocuries per milliliter	Specific Activity	pCi/ml
181	hour minute	Time	hhmm
182	year month day	Time	yymmdd
183	year day (Julian)	Time	yyddd
184	inches per day	Velocity	in/d
185	inches per week	Velocity	in/week
186	inches per storm	Precipitation	in/storm
187	thousand acre feet	Volume	10^3 ac ft
188	milliliter	Volume	ml
189	cubic feet per second days	Volume	cfs d
190	thousand gallons	Volume	10^3 gal
191	million gallons	Volume	10^6 gal
192	microsiemens per centimeter	Electrical Conductivity	uS/cm
193	practical salinity units 	Salinity	psu
194	decibel	Sound	dB
195	cubic centimeters per gram	Specific Volume	cm^3/g
196	square meters per gram	Specific Surface Area 	m^2/g
197	short tons per acre foot	Concentration	ton/ac ft
198	grams per cubic centimeter	Concentration	g/cm^3
199	milligrams per liter	Concentration	mg/L
200	nanograms per cubic meter	Concentration	ng/m^3
201	nanograms per liter	Concentration	ng/L
202	grams per liter	Concentration	g/L
203	micrograms per cubic meter	Concentration	ug/m^3
204	micrograms per liter	Concentration	ug/L
205	parts per million	Concentration	ppm
206	parts per billion	Concentration	ppb
207	parts per trillion	Concentration	ppt
208	parts per quintillion	Concentration	ppqt
209	parts per quadrillion	Concentration	ppq
210	per mille	Concentration	%o
211	microequivalents per liter	Concentration	ueq/L
212	milliequivalents per liter	Concentration	meq/L
213	milliequivalents per 100 gram	Concentration	meq/100 g
214	milliosmols per kilogram	Concentration	mOsm/kg
215	nanomoles per liter	Concentration	nmol/L
216	picograms per cubic meter	Concentration	pg/m^3
217	picograms per liter	Concentration	pg/L
218	picograms per milliliter	Concentration	pg/ml
219	tritium units	Concentration	TU
220	jackson turbidity units	Turbidity	JTU
221	nephelometric turbidity units	Turbidity	NTU
222	nephelometric turbidity multibeam unit	Turbidity	NTMU
223	nephelometric turbidity ratio unit	Turbidity	NTRU
224	formazin nephelometric multibeam unit	Turbidity	FNMU
225	formazin nephelometric ratio unit	Turbidity	FNRU
226	formazin nephelometric unit	Turbidity	FNU
227	formazin attenuation unit	Turbidity	FAU
228	formazin backscatter unit 	Turbidity	FBU
229	backscatter units	Turbidity	BU
230	attenuation units	Turbidity	AU
231	platinum cobalt units	Color	PCU
232	the ratio between UV absorbance at 254 nm and DOC level	Specific UV Absorbance	L/(mg DOC/cm)
233	billion colonies per day	Organism Loading	10^9 colonies/d
234	number of organisms per square meter	Organism Concentration	#/m^2
235	number of organisms per liter	Organism Concentration	#/L
236	number or organisms per cubic meter	Organism Concentration	#/m^3
237	cells per milliliter	Organism Concentration	cells/ml
238	cells per square millimeter	Organism Concentration	cells/mm^2
239	colonies per 100 milliliters	Organism Concentration	colonies/100 ml
240	colonies per milliliter	Organism Concentration	colonies/ml
241	colonies per gram	Organism Concentration	colonies/g
242	colony forming units per milliliter	Organism Concentration	CFU/ml
243	cysts per 10 liters	Organism Concentration	cysts/10 L
244	cysts per 100 liters	Organism Concentration	cysts/100 L
245	oocysts per 10 liters	Organism Concentration	oocysts/10 L
246	oocysts per 100 liters	Organism Concentration	oocysts/100 L
247	most probable number	Organism Concentration	MPN
248	most probable number per 100 liters	Organism Concentration	MPN/100 L
249	most probable number per 100 milliliters	Organism Concentration	MPN/100 ml
250	most probable number per gram	Organism Concentration	MPN/g
251	plaque-forming units per 100 liters	Organism Concentration	PFU/100 L
252	plaques per 100 milliliters	Organism Concentration	plaques/100 ml
253	counts per second	Rate	#/s
254	per day	Rate	1/d
255	nanograms per square meter per hour	Volatilization Rate	ng/m^2 hr
256	nanograms per square meter per week	Volatilization Rate	ng/m^2 week
257	count	Dimensionless	#
258	categorical	Dimensionless	code
259	absorbance per centimeter per mg/L of given acid 	Absorbance	100/cm mg/L
260	per liter	Concentration Ratio	1/L
261	per mille per hour	Sedimentation Rate	%o/hr
262	gallons per batch	Flow	gpb
263	cubic feet per barrel	Concentration	ft^3/bbl
264	per mille by volume	Concentration	%o by vol
265	per mille per hour by volume	Sedimentation Rate	%o/hr by vol
266	micromoles	Amount	umol
267	tons of calcium carbonate per kiloton	Net Neutralization Potential	tCaCO3/Kt
268	siemens per meter	Electrical Conductivity	S/m
269	millisiemens per centimeter	Electrical Conductivity	mS/cm
270	siemens per centimeter	Electrical Conductivity	S/cm
271	practical salinity scale	Salinity	pss
272	per meter	Light Extinction	1/m
273	normal	Normality	N
274	nanomoles per kilogram	Concentration	nmol/kg
275	millimoles per kilogram	Concentration	mmol/kg
276	millimoles per square meter per hour	Areal Flux	mmol/m^2 hr
277	milligrams per cubic meter per hour	Productivity	mg/m^3 hr
278	milligrams per day	Loading	mg/d
279	liters per minute	Flow	L/min
280	liters per day	Flow	L/d
281	jackson candle units 	Turbidity	JCU
282	grains per gallon	Concentration	gpg
283	gallons per second	Flow	gps
284	gallons per hour	Flow	gph
285	foot candle	Illuminance	ftc
286	fibers per liter	Concentration	fibers/L
287	drips per minute	Flow	drips/min
288	cubic centimeters per second	Flow	cm^3/sec
289	colony forming units	Organism Concentration	CFU
290	colony forming units per 100 milliliter	Organism Concentration	CFU/100 ml
291	cubic feet per minute	Flow	cfm
292	ADMI color unit	Color	ADMI
293	percent by volume	Concentration	% by vol
294	number of organisms per 500 milliliter	Organism Concentration	#/500 ml
295	number of organisms per 100 gallon	Organism Concentration	#/100 gal
296	grams per cubic meter per hour	Productivity	g/m^3 hr
297	grams per minute	Loading	g/min
298	grams per second	Loading	g/s
299	million cubic feet	Volume	10^6 ft^3
300	month year	Time	mmyy
301	bar	Pressure	bar
302	decisiemens per centimeter	Electrical Conductivity	dS/cm
303	micromoles per liter	Concentration	umol/L
304	Joules per square centimeter	Energy per Area	J/cm^2
305	millimeters per day	velocity	mm/day
306	parts per thousand	Concentration	ppth
307	megaliter	Volume	ML
308	Percent Saturation	Concentration	% Sat
309	pH Unit	Dimensionless	pH
310	millimeters per second	Velocity	mm/s
311	liters per hour	Flow	L/hr
312	cubic hecto meter	Volume	(hm)^3
313	mols per cubic meter	Concentration or organism concentration	mol/m^3
314	kilo grams per month	Loading	kg/month
315	Hecto Pascal	Pressure/Stress	hPa
316	kilo grams per cubic meter	Concentration	kg/m^3
317	short tons per month	Loading	ton/month
318	micromoles per square meter per second	Areal Flux	umol/m^2 s
319	grams per square meter per hour	Areal Flux	g/m^2 hr
320	milligrams per cubic meter	Concentration	mg/m^3
321	meters squared per second squared	Velocity	m^2/s^2
322	squared degree Celsius	Temperature	(DegC)^2
323	milligrams per cubic meter squared	Concentration	(mg/m^3)^2
324	meters per second degree Celsius	Temperature	m/s DegC
325	millimoles per square meter per second	Areal Flux	mmol/m^2 s
326	degree Celsius millimoles per cubic meter	Concentration	DegC mmol/m^3
327	millimoles per cubic meter	Concentration	mmol/m^3
328	millimoles per cubic meter squared	Concentration	(mmol/m^3)^2
329	Langleys per hour	Energy Flux	Ly/hr
330	hits per square centimeter	Precipitation	hits/cm^2
331	hits per square centimeter per hour	Velocity	hits/cm^2 hr
332	relative fluorescence units	Fluorescence	RFU
333	kilograms per hectare per day	Areal Flux	kg/ha d
334	kilowatts per square meter	Energy Flux	kW/m^2
335	kilograms per square meter	Areal Density	kg/m^2
336	microeinsteins per square meter per day	Light Intensity	uE/m^2 d
337	microgram per milliliter	Concentration	ug/mL
338	Newton per square meter	Pressure/Stress	Newton/m^2
339	micromoles per liter per hour	Pressure/Stress	umol/L hr
340	decisiemens per meter	Electrical Conductivity	dS/m
341	milligrams per kilogram	Mass Fraction	mg/Kg
342	number of organisms per 100 milliliter	Organism Concentration	#/100 mL
343	micrograms per kilogram	Mass Fraction	ug/Kg
344	grams per kilogram	Mass Fraction	g/Kg
345	acre feet per month	Flow	ac ft/mo
346	acre feet per half month	Flow	ac ft/0.5 mo
347	cubic meters per minute	Flow	m^3/min
348	count per half cubic foot	Concentration	#/((ft^3)/2)
349	no units	none	-
350	fraction by volume	Proportion	v/v
351	standard deviations * 1000	deviation	sd*1000
352	ISO DateTime	Time	ISO DateTime
353	Okta	Proportion	Okta
\.


--
-- Name: Units_UnitsID_seq; Type: SEQUENCE SET; Schema: public; Owner: jbianchi
--

SELECT pg_catalog.setval('public."Units_UnitsID_seq"', 2, true);


--
-- Data for Name: ValueTypeCV; Type: TABLE DATA; Schema: public; Owner: jbianchi
--

COPY public."ValueTypeCV" ("Term", "Definition") FROM stdin;
Calibration Value	A value used as part of the calibration of an instrument at a particular time.
Derived Value	Value that is directly derived from an observation or set of observations
Field Observation	Observation of a variable using a field instrument
Model Simulation Result	Values generated by a simulation model
Sample	Observation that is the result of analyzing a sample in a laboratory
Unknown	The value type is unknown
\.


--
-- Data for Name: VariableNameCV; Type: TABLE DATA; Schema: public; Owner: jbianchi
--

COPY public."VariableNameCV" ("Term", "Definition") FROM stdin;
19-Hexanoyloxyfucoxanthin	The phytoplankton pigment 19-Hexanoyloxyfucoxanthin
9 cis-Neoxanthin	The phytoplankton pigment  9 cis-Neoxanthin
Acid neutralizing capacity	Acid neutralizing capacity 
Agency code	Code for the agency which analyzed the sample
Albedo	The ratio of reflected to incident light.
Alkalinity, bicarbonate	Bicarbonate Alkalinity 
Alkalinity, carbonate 	Carbonate Alkalinity 
Alkalinity, carbonate plus bicarbonate	Alkalinity, carbonate plus bicarbonate
Alkalinity, hydroxide 	Hydroxide Alkalinity 
Alkalinity, total 	Total Alkalinity
Alloxanthin	The phytoplankton pigment Alloxanthin
Aluminium	Aluminium (Al)
Aluminum, dissolved	Dissolved Aluminum (Al)
Ammonium flux	Ammonium (NH4) flux
Antimony	Antimony (Sb)
Area	Area of a measurement location
Arsenic	Arsenic (As)
Asteridae coverage	Areal coverage of the plant Asteridae
Barium, dissolved	Dissolved Barium (Ba)
Barium, total	Total Barium (Ba)
Barometric pressure	Barometric pressure
Baseflow	The portion of streamflow (discharge) that is supplied by groundwater sources.
Batis maritima Coverage	Areal coverage of the plant Batis maritima
Battery Temperature	The battery temperature of a datalogger or sensing system
Battery voltage	The battery voltage of a datalogger or sensing system, often recorded as an indicator of data reliability
Benthos	Benthic species
Bicarbonate	Bicarbonate (HCO3-)
Biogenic silica	Hydrated silica (SiO2 nH20)
Biomass, phytoplankton	Total mass of phytoplankton, per unit area or volume
Biomass, total	Total biomass
Blue-green algae (cyanobacteria), phycocyanin	Blue-green algae (cyanobacteria) with phycocyanin pigments
BOD1	1-day Biochemical Oxygen Demand
BOD2, carbonaceous	2-day Carbonaceous Biochemical Oxygen Demand
BOD20	20-day Biochemical Oxygen Demand
BOD20, carbonaceous	20-day Carbonaceous Biochemical Oxygen Demand
BOD20, nitrogenous	20-day Nitrogenous Biochemical Oxygen Demand
BOD3, carbonaceous	3-day Carbonaceous Biochemical Oxygen Demand
BOD4, carbonaceous	4-day Carbonaceous Biological Oxygen Demand
BOD5	5-day Biochemical Oxygen Demand
BOD5, carbonaceous	5-day Carbonaceous Biochemical Oxygen Demand
BOD5, nitrogenous	5-day Nitrogenous Biochemical Oxygen Demand
BOD6, carbonaceous	6-day Carbonaceous Biological Oxygen Demand
BOD7, carbonaceous	7-day Carbonaceous Biochemical Oxygen Demand
BODu	Ultimate Biochemical Oxygen Demand
BODu, carbonaceous	Carbonaceous Ultimate Biochemical Oxygen Demand
BODu, nitrogenous	Nitrogenous Ultimate Biochemical Oxygen Demand
Borehole log material classification	Classification of material encountered by a driller at various depths during the drilling of a well and recorded in the borehole log.
Boron	Boron (B)
Borrichia frutescens Coverage	Areal coverage of the plant Borrichia frutescens
Bromide	Bromide
Bromine	Bromine (Br)
Bromine, dissolved	Dissolved Bromine (Br)
Bulk electrical conductivity	Bulk electrical conductivity of a medium measured using a sensor such as time domain reflectometry (TDR), as a raw sensor response in the measurement of a quantity like soil moisture.
Cadmium	Cadmium (Cd)
Calcium 	Calcium (Ca) 
Calcium, dissolved	Dissolved Calcium (Ca)
Canthaxanthin	The phytoplankton pigment Canthaxanthin
Carbon dioxide	Carbon dioxide
Carbon dioxide Flux	Carbon dioxide (CO2) flux
Carbon dioxide Storage Flux	Carbon dioxide (CO2) storage flux
Carbon dioxide, transducer signal	Carbon dioxide (CO2), raw data from sensor
Carbon disulfide	Carbon disulfide (CS2)
Carbon tetrachloride	Carbon tetrachloride (CCl4)
Carbon to Nitrogen molar ratio	C:N (molar)
Carbon, dissolved inorganic	Dissolved Inorganic Carbon
Carbon, dissolved organic	Dissolved Organic Carbon
Carbon, dissolved total	Dissolved Total (Organic+Inorganic) Carbon
Carbon, particulate organic	Particulate organic carbon in suspension
Carbon, suspended inorganic	Suspended Inorganic Carbon
Carbon, suspended organic	DEPRECATED -- The use of this term is discouraged in favor of the use of the synonymous term \\"Carbon, particulate organic\\".
Carbon, suspened total	Suspended Total (Organic+Inorganic) Carbon
Carbon, total	Total (Dissolved+Particulate) Carbon
Carbon, total inorganic	Total (Dissolved+Particulate) Inorganic Carbon
Carbon, total organic	Total (Dissolved+Particulate) Organic Carbon
Carbon, total solid phase	Total solid phase carbon
Carbonate	Carbonate ion (CO3-2) concentration
Chloride	Chloride (Cl-)
Chloride, total	Total Chloride (Cl-)
Chlorine	Chlorine (Cl)
Chlorine, dissolved	Dissolved Chlorine (Cl)
Chlorophyll (a+b+c)	Chlorophyll (a+b+c)
Chlorophyll a	Chlorophyll a
Chlorophyll a allomer	The phytoplankton pigment Chlorophyll a allomer
Chlorophyll a, corrected for pheophytin	Chlorphyll a corrected for pheophytin
Chlorophyll a, uncorrected for pheophytin	Chlorophyll a uncorrected for pheophytin
Chlorophyll b	Chlorophyll b
Chlorophyll c	Chlorophyll c
Chlorophyll c1 and c2	Chlorophyll c1 and c2
Chlorophyll Fluorescence	Chlorophyll Fluorescence
Chromium (III)	Trivalent Chromium
Chromium (VI)	Hexavalent Chromium
Chromium, dissolved	Dissolved Chromium
Chromium, total	Chromium, all forms
Cobalt	Cobalt (Co)
Cobalt, dissolved	Dissolved Cobalt (Co)
COD	Chemical oxygen demand
Coliform, fecal	Fecal Coliform
Coliform, total	Total Coliform
Color	Color in quantified in color units
Colored Dissolved Organic Matter	The concentration of colored dissolved organic matter (humic substances)
Container number	The identifying number for a water sampler container.
Copper	Copper (Cu)
Copper, dissolved	Dissolved Copper (Cu)
Cryptophytes	The chlorophyll a concentration contributed by cryptophytes
Cuscuta spp. coverage	Areal coverage of the plant Cuscuta spp.
Density	Density
Deuterium	Deuterium (2H), Delta D
Diadinoxanthin	The phytoplankton pigment Diadinoxanthin
Diatoxanthin	The phytoplankton pigment Diatoxanthin
Dinoflagellates	The chlorophyll a concentration contributed by Dinoflagellates
Discharge	Discharge
Distance	Distance measured from a sensor to a target object such as the surface of a water body or snow surface.
Distichlis spicata Coverage	Areal coverage of the plant Distichlis spicata
E-coli	Escherichia coli
Electric Energy	Electric Energy
Electric Power	Electric Power
Electrical conductivity	Electrical conductivity
Enterococci	Enterococcal bacteria
Ethane, dissolved	Dissolved Ethane (C2H6)
Evaporation	Evaporation
Evapotranspiration	Evapotranspiration
Evapotranspiration, potential	The amount of water that could be evaporated and transpired if there was sufficient water available.
Fish detections	The number of fish identified by the detection equipment
Flash memory error count	A counter which counts the number of  datalogger flash memory errors
Fluoride	Fluoride - F-
Fluorine	Fluorine (F-)
Fluorine, dissolved	Dissolved Fluorine (Fl)
Friction velocity	Friction velocity
Gage height	Water level with regard to an arbitrary gage datum (also see Water depth for comparison)
Global Radiation	Solar radiation, direct and diffuse, received from a solid angle of 2p steradians on a horizontal surface. \\nSource: World Meteorological Organization, Meteoterm
Ground heat flux	Ground heat flux
Groundwater Depth	Groundwater depth is the distance between the water surface and the ground surface at a specific location specified by the site location and offset.
Hardness, carbonate	Carbonate hardness also known as temporary hardness
Hardness, non-carbonate	Non-carbonate hardness
Hardness, total	Total hardness
Heat index	The combination effect of heat and humidity on the temperature felt by people.
Hydrogen sulfide	Hydrogen sulfide (H2S)
Hydrogen-2, stable isotope ratio delta	Difference in the  2H:1H ratio between the sample and standard
Imaginary dielectric constant	Soil reponse of a reflected standing electromagnetic wave of a particular frequency which is related to the dissipation (or loss) of energy within the medium. This is the imaginary portion of the complex dielectric constant.
Iron sulfide	Iron sulfide (FeS2)
Iron, dissolved	Dissolved Iron (Fe)
Iron, ferric	Ferric Iron (Fe+3)
Iron, ferrous	Ferrous Iron (Fe+2)
Iva frutescens coverage	Areal coverage of the plant Iva frutescens
Latent Heat Flux	Latent Heat Flux
Latitude	Latitude as a variable measurement or observation (Spatial reference to be designated in methods).  This is distinct from the latitude of a site which is a site attribute.
Lead	Lead (Pb)
Leaf wetness	The effect of moisture settling on the surface of a leaf as a result of either condensation or rainfall.
Light attenuation coefficient	Light attenuation coefficient
Limonium nashii Coverage	Areal coverage of the plant Limonium nashii
Lithium	Lithium (Li)
Longitude	Longitude as a variable measurement or observation (Spatial reference to be designated in methods). This is distinct from the longitude of a site which is a site attribute.
Low battery count	A counter of the number of times the battery voltage dropped below a minimum threshold
LSI	Langelier Saturation Index is an indicator of the degree of saturation of water with respect to calcium carbonate 
Lycium carolinianum Coverage	Areal coverage of the plant Lycium carolinianum
Magnesium	Magnesium (Mg)
Magnesium, dissolved	Dissolved Magnesium (Mg)
Manganese	Manganese (Mn)
Manganese, dissolved	Dissolved Manganese (Mn)
Mercury	Mercury (Hg)
Methane, dissolved	Dissolved Methane (CH4)
Methylmercury	Methylmercury (CH3Hg)
Molybdenum	Molybdenum (Mo)
Momentum flux	Momentum flux
Monanthochloe littoralis Coverage	Areal coverage of the plant Monanthochloe littoralis
N, albuminoid	Albuminoid Nitrogen
Net heat flux	Outgoing rate of heat energy transfer minus the incoming rate of heat energy transfer through a given area
Nickel	Nickel (Ni)
Nickel, dissolved	Dissolved Nickel (Ni)
Nitrogen, Dissolved Inorganic	Dissolved inorganic nitrogen
Nitrogen, dissolved Kjeldahl	Dissolved Kjeldahl (organic nitrogen + ammonia (NH3) + ammonium (NH4))nitrogen
Nitrogen, dissolved nitrate (NO3)	Dissolved nitrate (NO3) nitrogen
Nitrogen, dissolved nitrite (NO2)	Dissolved nitrite (NO2) nitrogen
Nitrogen, dissolved nitrite (NO2) + nitrate (NO3)	Dissolved nitrite (NO2) + nitrate (NO3) nitrogen
Nitrogen, Dissolved Organic	Dissolved Organic Nitrogen
Nitrogen, gas	Gaseous Nitrogen (N2)
Nitrogen, inorganic	Total Inorganic Nitrogen
Nitrogen, NH3	Free Ammonia (NH3)
Nitrogen, NH3 + NH4	Total (free+ionized) Ammonia
Nitrogen, NH4	Ammonium (NH4)
Nitrogen, nitrate (NO3)	Nitrate (NO3) Nitrogen
Nitrogen, nitrite (NO2)	Nitrite (NO2) Nitrogen
Nitrogen, nitrite (NO2) + nitrate (NO3)	Nitrite (NO2) + Nitrate (NO3) Nitrogen
Nitrogen, organic	Organic Nitrogen
Nitrogen, organic kjeldahl	Organic Kjeldahl (organic nitrogen + ammonia (NH3) + ammonium (NH4)) nitrogen
Nitrogen, particulate organic	Particulate Organic Nitrogen
Nitrogen, total	Total Nitrogen (NO3+NO2+NH4+NH3+Organic)
Nitrogen, total dissolved	Total dissolved nitrogen
Nitrogen, total kjeldahl	Total Kjeldahl Nitrogen (Ammonia+Organic) 
Nitrogen, total organic	Total (dissolved + particulate) organic nitrogen
Nitrogen-15	15 Nitrogen, Delta Nitrogen
Nitrogen-15, stable isotope ratio delta	Difference in the 15N:14N ratio between the sample and standard
No vegetation coverage	Areal coverage of no vegetation
Odor	Odor
Oxygen flux	Oxygen (O2) flux
Oxygen, dissolved	Dissolved oxygen
Oxygen, dissolved percent of saturation	Dissolved oxygen, percent saturation
Oxygen, dissolved, transducer signal	Dissolved oxygen, raw data from sensor
Oxygen-18	18 O, Delta O
Oxygen-18, stable isotope ratio delta	Difference in the 18O:16O ratio between the sample and standard
Ozone	Ozone (O3)
Parameter	Parameter related to a hydrologic process.  An example usage would be for a starge-discharge relation parameter.
Peridinin	The phytoplankton pigment Peridinin
Permittivity	Permittivity is a physical quantity that describes how an electric field affects, and is affected by a dielectric medium, and is determined by the ability of a material to polarize in response to the field, and thereby reduce the total electric field inside the material. Thus, permittivity relates to a material's ability to transmit (or \\"permit\\") an electric field.
Petroleum hydrocarbon, total	Total petroleum hydrocarbon
pH	pH is the measure of the acidity or alkalinity of a solution. pH is formally a measure of the activity of dissolved hydrogen ions (H+).  Solutions in which the concentration of H+ exceeds that of OH- have a pH value lower than 7.0 and are known as acids. 
Pheophytin	Pheophytin (Chlorophyll which has lost the central Mg ion) is a degradation product of Chlorophyll
Phosphorus, dissolved	Dissolved Phosphorus (P)
Phosphorus, dissolved organic	Dissolved organic phosphorus
Phosphorus, inorganic 	Inorganic Phosphorus
Phosphorus, organic	Organic Phosphorus
Phosphorus, orthophosphate	Orthophosphate Phosphorus
Phosphorus, orthophosphate dissolved	Dissolved orthophosphate phosphorus
Phosphorus, particulate	Particulate phosphorus
Phosphorus, particulate organic	Particulate organic phosphorus in suspension
Phosphorus, phosphate (PO4)	Phosphate Phosphorus
Phosphorus, phosphate flux	Phosphate (PO4) flux
Phosphorus, polyphosphate	Polyphosphate Phosphorus
Phosphorus, total	Total Phosphorus
Phosphorus, total dissolved	Total dissolved phosphorus
Phytoplankton	Measurement of phytoplankton with no differentiation between species
Position	Position of an element that interacts with water such as reservoir gates
Potassium	Potassium (K)
Potassium, dissolved	Dissolved Potassium (K)
Precipitation	Precipitation such as rainfall. Should not be confused with settling.
Pressure, absolute	Pressure
Pressure, gauge	Pressure relative to the local atmospheric or ambient pressure
Primary Productivity	Primary Productivity
Program signature	A unique data recorder program identifier which is useful for knowing when the source code in the data recorder has been modified.
Radiation, incoming longwave	Incoming Longwave Radiation
Radiation, incoming PAR	Incoming Photosynthetically-Active Radiation
Radiation, incoming shortwave	Incoming Shortwave Radiation
Radiation, incoming UV-A	Incoming Ultraviolet A Radiation
Radiation, incoming UV-B	Incoming Ultraviolet B Radiation
Radiation, net	Net Radiation
Radiation, net longwave	Net Longwave Radiation
Radiation, net PAR	Net Photosynthetically-Active Radiation
Radiation, net shortwave	Net Shortwave radiation
Radiation, outgoing longwave	Outgoing Longwave Radiation
Radiation, outgoing PAR	Outgoing Photosynthetically-Active Radiation
Radiation, outgoing shortwave	Outgoing Shortwave Radiation
Radiation, total incoming	Total amount of incoming radiation from all frequencies
Radiation, total outgoing	Total amount of outgoing radiation from all frequencies
Radiation, total shortwave	Total Shortwave Radiation
Rainfall rate	A measure of the intensity of rainfall, calculated as the depth of water to fall over a given time period if the intensity were to remain constant over that time interval (in/hr, mm/hr, etc)
Real dielectric constant	Soil reponse of a reflected standing electromagnetic wave of a particular frequency which is related to the stored energy within the medium.  This is the real portion of the complex dielectric constant.
Recorder code	A code used to identifier a data recorder.
Reduction potential	Oxidation-reduction potential
Relative humidity	Relative humidity
Reservoir storage	Reservoir water volume
Respiration, net	Net respiration
Salicornia bigelovii coverage	Areal coverage of the plant Salicornia bigelovii
Salicornia virginica coverage	Areal coverage of the plant Salicornia virginica
Salinity	Salinity
Secchi depth	Secchi depth
Selenium	Selenium (Se)
Sensible Heat Flux	Sensible Heat Flux
Sequence number	A counter of events in a sequence
Signal-to-noise ratio	Signal-to-noise ratio (often abbreviated SNR or S/N) is defined as the ratio of a signal power to the noise power corrupting the signal. The higher the ratio, the less obtrusive the background noise is.
Silica	Silica (SiO2)
Silicate	Silicate.  Chemical compound containing silicon, oxygen, and one or more metals, e.g., aluminum, barium, beryllium, calcium, iron, magnesium, manganese, potassium, sodium, or zirconium.
Silicic acid	Hydrated silica disolved in water
Silicic acid flux	Silicate acid (H4SiO4) flux
Silicon	Silicon (Si)  
Silicon, dissolved	Dissolved Silicon (Si)
Snow depth	Snow depth
Snow Water Equivalent	The depth of water if a snow cover is completely melted, expressed in units of depth, on a corresponding horizontal surface area.
Sodium	Sodium (Na)
Sodium adsorption ratio	Sodium adsorption ratio
Sodium plus potassium	Sodium plus potassium
Sodium, dissolved	Dissolved Sodium (Na)
Sodium, fraction of cations	Sodium, fraction of cations
Solids, fixed Dissolved	Fixed Dissolved Solids
Solids, fixed Suspended	Fixed Suspended Solids
Solids, total	Total Solids
Solids, total Dissolved	Total Dissolved Solids
Solids, total Fixed	Total Fixed Solids
Solids, total Suspended	Total Suspended Solids
Solids, total Volatile	Total Volatile Solids
Solids, volatile Dissolved	Volatile Dissolved Solids
Solids, volatile Suspended	Volatile Suspended Solids
Spartina alterniflora coverage	Areal coverage of the plant Spartina alterniflora
Spartina spartinea coverage	Areal coverage of the plant Spartina spartinea
Specific conductance	Specific conductance
Streamflow	The volume of water flowing past a fixed point.  Equivalent to discharge
Streptococci, fecal	Fecal Streptococci
Strontium	Strontium (Sr)
Strontium, dissolved	Dissolved Strontium (Sr)
Strontium, total	Total Strontium (Sr)
Suaeda linearis coverage	Areal coverage of the plant Suaeda linearis
Suaeda maritima coverage	Areal coverage of the plant Suaeda maritima
Sulfate	Sulfate (SO4)
Sulfate, dissolved	Dissolved Sulfate (SO4)
Sulfur	Sulfur (S)
Sulfur dioxide	Sulfur dioxide (SO2)
Sulfur, organic	Organic Sulfur
Sulfur, pyritic	Pyritic Sulfur
Sunshine duration	Sunshine duration
Table overrun error count	A counter which counts the number of datalogger table overrun errors
TDR waveform relative length	Time domain reflextometry, apparent length divided by probe length. Square root of dielectric
Temperature	Temperature
Temperature, dew point	Dew point temperature
Temperature, transducer signal	Temperature, raw data from sensor
Thallium	Thallium (Tl)
THSW Index	The THSW Index uses temperature, humidity, solar radiation, and wind speed to calculate an apparent temperature.
THW Index	The THW Index uses temperature, humidity, and wind speed to calculate an apparent temperature.
Tide stage	Tidal stage
Tin	Tin (Sn)
Titanium	Titanium (Ti)
Transient species coverage	Areal coverage of transient species
Transpiration	Transpiration
TSI	Carlson Trophic State Index is a measurement of eutrophication based on Secchi depth
Turbidity	Turbidity
Uranium	Uranium (U)
Urea	Urea ((NH2)2CO)
Urea flux	Urea ((NH2)2CO) flux
Vanadium	Vanadium (V)
Vapor pressure	The pressure of a vapor in equilibrium with its non-vapor phases
Vapor pressure deficit	The difference between the actual water vapor pressure and the saturation of water vapor pressure at a particular temperature.
Velocity	The velocity of a substance, fluid or object
Visibility	Visibility
Voltage	Voltage or Electrical Potential
Volume	Volume. To quantify discharge or hydrograph volume or some other volume measurement.
Volumetric water content	Volume of liquid water relative to bulk volume. Used for example to quantify soil moisture
Watchdog error count	A counter which counts the number of total datalogger watchdog errors
Water depth	Water depth is the distance between the water surface and the bottom of the water body at a specific location specified by the site location and offset.
Water depth, averaged	Water depth averaged over a channel cross-section or water body.  Averaging method to be specified in methods.
Water flux	Water Flux
Water level	Water level relative to datum. The datum may be local or global such as NGVD 1929 and should be specified in the method description for associated data values.
Water potential	Water potential is the potential energy of water relative to pure free water (e.g. deionized water) in reference conditions. It quantifies the tendency of water to move from one area to another due to osmosis, gravity, mechanical pressure, or matrix effects including surface tension.
Water vapor density	Water vapor density
Wave height	The height of a surface wave, measured as the difference in elevation between the wave crest and an adjacent trough.
Weather conditions	Weather conditions
Well flow rate	Flow rate from well while pumping
Wellhead pressure	The pressure exerted by the fluid at the wellhead or casinghead after the well has been shut off for a period of time, typically 24 hours
Wind chill	The effect of wind on the temperature felt on human skin.
Wind direction	Wind direction
Wind gust direction	Direction of gusts of wind
Wind gust speed	Speed of gusts of wind
Wind Run	The length of flow of air past a point over a time interval. Windspeed times the interval of time.
Wind speed	Wind speed
Wind stress	Drag or trangential force per unit area exerted on a surface by the adjacent layer of moving air
Wrack coverage	Areal coverage of dead vegetation
Zeaxanthin	The phytoplankton pigment Zeaxanthin
Zinc	Zinc (Zn)
Zinc, dissolved	Dissolved Zinc (Zn)
Zircon, dissolved	Dissolved Zircon (Zr)
Zooplankton	Zooplanktonic organisms, non-specific
Cloud cover	fraction of the sky obscured by clouds when observed from ground
Sea-level pressure	Atmospheric pressure at sea level
Flood magnitude	Deviation from mean water covered area fraction
Reservoir inflow	Reservoir water inflow rate
Reservoir outflow	Reservoir water outflow rate
Turbine flow	Hydro power plant water flow rate through the turbines
Transfered discharge	Hydro power plant water transfer rate
Reservoir spilled	Reservoir water release rate through spillways
Water extent	Areal coverage of water
\.


--
-- Data for Name: Variables; Type: TABLE DATA; Schema: public; Owner: jbianchi
--

COPY public."Variables" ("VariableID", "VariableCode", "VariableName", "Speciation", "VariableUnitsID", "SampleMedium", "ValueType", "IsRegular", "TimeSupport", "TimeUnitsID", "DataType", "GeneralCategory", "NoDataValue") FROM stdin;
4	1	Precipitation	Not Applicable	54	Precipitation	Field Observation	f	0	100	Cumulative	Unknown	0
3	2	Gage height	Not Applicable	52	Surface Water	Field Observation	f	0	100	Continuous	Unknown	0
6	4	Discharge	Not Applicable	36	Surface Water	Derived Value	f	0	100	Continuous	Unknown	0
7	5	Temperature	Not Applicable	96	Air	Field Observation	f	1	104	Minimum	Unknown	0
8	6	Temperature	Not Applicable	96	Air	Field Observation	f	1	104	Maximum	Unknown	0
9	7	Temperature	Not Applicable	96	Air	Field Observation	f	1	104	Average	Unknown	0
10	8	Temperature	Not Applicable	96	Soil	Field Observation	f	1	104	Average	Unknown	0
11	9	Wind speed	Not Applicable	116	Air	Field Observation	f	1	104	Maximum	Unknown	0
12	10	Wind speed	Not Applicable	116	Air	Field Observation	f	1	104	Average	Unknown	0
13	11	Wind direction	Not Applicable	8	Air	Field Observation	f	1	104	Mode	Unknown	0
14	12	Relative humidity	Not Applicable	1	Air	Field Observation	f	1	104	Average	Unknown	0
15	13	Sunshine duration	Not Applicable	103	Air	Field Observation	f	1	104	Cumulative	Unknown	0
16	14	Global Radiation	Not Applicable	144	Air	Field Observation	f	1	104	Average	Unknown	0
17	15	Evapotranspiration, potential	Not Applicable	54	Air	Derived Value	f	1	104	Cumulative	Unknown	0
18	16	Barometric pressure	Not Applicable	315	Air	Field Observation	f	1	104	Average	Unknown	0
19	18	Sea-level pressure	Not Applicable	16	Air	Field Observation	f	1	104	Average	Unknown	0
20	20	Volumetric water content	Not Applicable	349	Not Relevant	Derived Value	f	0	100	Sporadic	Unknown	0
21	21	Flood magnitude	Not Applicable	351	Not Relevant	Derived Value	f	1	104	Sporadic	Unknown	0
22	22	Reservoir inflow	Not Applicable	36	Surface Water	Field Observation	f	0	100	Continuous	Unknown	0
23	23	Reservoir outflow	Not Applicable	36	Surface Water	Field Observation	f	0	100	Continuous	Unknown	0
24	24	Reservoir spilled	Not Applicable	36	Surface Water	Field Observation	f	0	100	Continuous	Unknown	0
25	25	Transfered discharge	Not Applicable	36	Surface Water	Field Observation	f	0	100	Continuous	Unknown	0
26	26	Reservoir storage	Not Applicable	126	Surface Water	Field Observation	f	0	100	Continuous	Unknown	0
27	27	Precipitation	Not Applicable	54	Precipitation	Field Observation	f	1	103	Cumulative	Unknown	0
28	28	Gage height	Not Applicable	52	Surface Water	Field Observation	f	0	100	Sporadic	Unknown	0
29	29	Discharge	Not Applicable	36	Surface Water	Field Observation	f	0	100	Sporadic	Unknown	0
30	30	Water extent	Not Applicable	349	Not Relevant	Derived Value	f	0	100	Continuous	Unknown	0
31	17	Cloud cover	Not Applicable	353	Not Relevant	Field Observation	f	1	104	Average	Unknown	0
\.


--
-- Name: Variables_VariableID_seq; Type: SEQUENCE SET; Schema: public; Owner: jbianchi
--

SELECT pg_catalog.setval('public."Variables_VariableID_seq"', 32, true);


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
-- Data for Name: spatial_ref_sys; Type: TABLE DATA; Schema: public; Owner: jbianchi
--

COPY public.spatial_ref_sys  FROM stdin;
\.


--
-- Data for Name: us_gaz; Type: TABLE DATA; Schema: public; Owner: jbianchi
--

COPY public.us_gaz  FROM stdin;
\.


--
-- Data for Name: us_lex; Type: TABLE DATA; Schema: public; Owner: jbianchi
--

COPY public.us_lex  FROM stdin;
\.


--
-- Data for Name: us_rules; Type: TABLE DATA; Schema: public; Owner: jbianchi
--

COPY public.us_rules  FROM stdin;
\.


--
-- Data for Name: geocode_settings; Type: TABLE DATA; Schema: tiger; Owner: jbianchi
--

COPY tiger.geocode_settings  FROM stdin;
\.


--
-- Data for Name: pagc_gaz; Type: TABLE DATA; Schema: tiger; Owner: jbianchi
--

COPY tiger.pagc_gaz  FROM stdin;
\.


--
-- Data for Name: pagc_lex; Type: TABLE DATA; Schema: tiger; Owner: jbianchi
--

COPY tiger.pagc_lex  FROM stdin;
\.


--
-- Data for Name: pagc_rules; Type: TABLE DATA; Schema: tiger; Owner: jbianchi
--

COPY tiger.pagc_rules  FROM stdin;
\.


--
-- Data for Name: topology; Type: TABLE DATA; Schema: topology; Owner: jbianchi
--

COPY topology.topology  FROM stdin;
\.


--
-- Data for Name: layer; Type: TABLE DATA; Schema: topology; Owner: jbianchi
--

COPY topology.layer  FROM stdin;
\.


--
-- Name: CensorCodeCV_pkey; Type: CONSTRAINT; Schema: public; Owner: jbianchi
--

ALTER TABLE ONLY public."CensorCodeCV"
    ADD CONSTRAINT "CensorCodeCV_pkey" PRIMARY KEY ("Term");


--
-- Name: DataTypeCV_pkey; Type: CONSTRAINT; Schema: public; Owner: jbianchi
--

ALTER TABLE ONLY public."DataTypeCV"
    ADD CONSTRAINT "DataTypeCV_pkey" PRIMARY KEY ("Term");


--
-- Name: DataValues_DataValue_ValueAccuracy_LocalDateTime_UTCOffset__key; Type: CONSTRAINT; Schema: public; Owner: jbianchi
--

ALTER TABLE ONLY public."DataValues"
    ADD CONSTRAINT "DataValues_DataValue_ValueAccuracy_LocalDateTime_UTCOffset__key" UNIQUE ("DataValue", "ValueAccuracy", "LocalDateTime", "UTCOffset", "DateTimeUTC", "SiteID", "VariableID", "OffsetValue", "OffsetTypeID", "CensorCode", "QualifierID", "MethodID", "SourceID", "SampleID", "DerivedFromID", "QualityControlLevelID");


--
-- Name: DataValues_pkey; Type: CONSTRAINT; Schema: public; Owner: jbianchi
--

ALTER TABLE ONLY public."DataValues"
    ADD CONSTRAINT "DataValues_pkey" PRIMARY KEY ("ValueID");


--
-- Name: GeneralCategoryCV_pkey; Type: CONSTRAINT; Schema: public; Owner: jbianchi
--

ALTER TABLE ONLY public."GeneralCategoryCV"
    ADD CONSTRAINT "GeneralCategoryCV_pkey" PRIMARY KEY ("Term");


--
-- Name: GroupDescriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: jbianchi
--

ALTER TABLE ONLY public."GroupDescriptions"
    ADD CONSTRAINT "GroupDescriptions_pkey" PRIMARY KEY ("GroupID");


--
-- Name: ISOMetadata_pkey; Type: CONSTRAINT; Schema: public; Owner: jbianchi
--

ALTER TABLE ONLY public."ISOMetadata"
    ADD CONSTRAINT "ISOMetadata_pkey" PRIMARY KEY ("MetadataID");


--
-- Name: LabMethods_pkey; Type: CONSTRAINT; Schema: public; Owner: jbianchi
--

ALTER TABLE ONLY public."LabMethods"
    ADD CONSTRAINT "LabMethods_pkey" PRIMARY KEY ("LabMethodID");


--
-- Name: Methods_pkey; Type: CONSTRAINT; Schema: public; Owner: jbianchi
--

ALTER TABLE ONLY public."Methods"
    ADD CONSTRAINT "Methods_pkey" PRIMARY KEY ("MethodID");


--
-- Name: OffsetTypes_pkey; Type: CONSTRAINT; Schema: public; Owner: jbianchi
--

ALTER TABLE ONLY public."OffsetTypes"
    ADD CONSTRAINT "OffsetTypes_pkey" PRIMARY KEY ("OffsetTypeID");


--
-- Name: Qualifiers_pkey; Type: CONSTRAINT; Schema: public; Owner: jbianchi
--

ALTER TABLE ONLY public."Qualifiers"
    ADD CONSTRAINT "Qualifiers_pkey" PRIMARY KEY ("QualifierID");


--
-- Name: QualityControlLevels_pkey; Type: CONSTRAINT; Schema: public; Owner: jbianchi
--

ALTER TABLE ONLY public."QualityControlLevels"
    ADD CONSTRAINT "QualityControlLevels_pkey" PRIMARY KEY ("QualityControlLevelID");


--
-- Name: SampleMediumCV_pkey; Type: CONSTRAINT; Schema: public; Owner: jbianchi
--

ALTER TABLE ONLY public."SampleMediumCV"
    ADD CONSTRAINT "SampleMediumCV_pkey" PRIMARY KEY ("Term");


--
-- Name: SampleTypeCV_pkey; Type: CONSTRAINT; Schema: public; Owner: jbianchi
--

ALTER TABLE ONLY public."SampleTypeCV"
    ADD CONSTRAINT "SampleTypeCV_pkey" PRIMARY KEY ("Term");


--
-- Name: Samples_pkey; Type: CONSTRAINT; Schema: public; Owner: jbianchi
--

ALTER TABLE ONLY public."Samples"
    ADD CONSTRAINT "Samples_pkey" PRIMARY KEY ("SampleID");


--
-- Name: SeriesCatalog_pkey; Type: CONSTRAINT; Schema: public; Owner: jbianchi
--

ALTER TABLE ONLY public."SeriesCatalog"
    ADD CONSTRAINT "SeriesCatalog_pkey" PRIMARY KEY ("SeriesID");


--
-- Name: SiteTypeCV_pkey; Type: CONSTRAINT; Schema: public; Owner: jbianchi
--

ALTER TABLE ONLY public."SiteTypeCV"
    ADD CONSTRAINT "SiteTypeCV_pkey" PRIMARY KEY ("Term");


--
-- Name: Sites_SiteCode_key; Type: CONSTRAINT; Schema: public; Owner: jbianchi
--

ALTER TABLE ONLY public."Sites"
    ADD CONSTRAINT "Sites_SiteCode_key" UNIQUE ("SiteCode");


--
-- Name: Sites_pkey; Type: CONSTRAINT; Schema: public; Owner: jbianchi
--

ALTER TABLE ONLY public."Sites"
    ADD CONSTRAINT "Sites_pkey" PRIMARY KEY ("SiteID");


--
-- Name: Sources_pkey; Type: CONSTRAINT; Schema: public; Owner: jbianchi
--

ALTER TABLE ONLY public."Sources"
    ADD CONSTRAINT "Sources_pkey" PRIMARY KEY ("SourceID");


--
-- Name: SpatialReferences_pkey; Type: CONSTRAINT; Schema: public; Owner: jbianchi
--

ALTER TABLE ONLY public."SpatialReferences"
    ADD CONSTRAINT "SpatialReferences_pkey" PRIMARY KEY ("SpatialReferenceID");


--
-- Name: SpeciationCV_pkey; Type: CONSTRAINT; Schema: public; Owner: jbianchi
--

ALTER TABLE ONLY public."SpeciationCV"
    ADD CONSTRAINT "SpeciationCV_pkey" PRIMARY KEY ("Term");


--
-- Name: TopicCategoryCV_pkey; Type: CONSTRAINT; Schema: public; Owner: jbianchi
--

ALTER TABLE ONLY public."TopicCategoryCV"
    ADD CONSTRAINT "TopicCategoryCV_pkey" PRIMARY KEY ("Term");


--
-- Name: Units_pkey; Type: CONSTRAINT; Schema: public; Owner: jbianchi
--

ALTER TABLE ONLY public."Units"
    ADD CONSTRAINT "Units_pkey" PRIMARY KEY ("UnitsID");


--
-- Name: ValueTypeCV_pkey; Type: CONSTRAINT; Schema: public; Owner: jbianchi
--

ALTER TABLE ONLY public."ValueTypeCV"
    ADD CONSTRAINT "ValueTypeCV_pkey" PRIMARY KEY ("Term");


--
-- Name: VariableNameCV_pkey; Type: CONSTRAINT; Schema: public; Owner: jbianchi
--

ALTER TABLE ONLY public."VariableNameCV"
    ADD CONSTRAINT "VariableNameCV_pkey" PRIMARY KEY ("Term");


--
-- Name: Variables_VariableCode_key; Type: CONSTRAINT; Schema: public; Owner: jbianchi
--

ALTER TABLE ONLY public."Variables"
    ADD CONSTRAINT "Variables_VariableCode_key" UNIQUE ("VariableCode");


--
-- Name: Variables_pkey; Type: CONSTRAINT; Schema: public; Owner: jbianchi
--

ALTER TABLE ONLY public."Variables"
    ADD CONSTRAINT "Variables_pkey" PRIMARY KEY ("VariableID");


--
-- Name: VerticalDatumCV_pkey; Type: CONSTRAINT; Schema: public; Owner: jbianchi
--

ALTER TABLE ONLY public."VerticalDatumCV"
    ADD CONSTRAINT "VerticalDatumCV_pkey" PRIMARY KEY ("Term");


--
-- Name: geom_default; Type: TRIGGER; Schema: public; Owner: jbianchi
--

CREATE TRIGGER geom_default BEFORE INSERT ON public."Sites" FOR EACH ROW WHEN (((new."Geometry" IS NULL) AND (new."Longitude" IS NOT NULL) AND (new."Latitude" IS NOT NULL))) EXECUTE PROCEDURE public.trg_geom_default();


--
-- Name: Categories_VariableID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jbianchi
--

ALTER TABLE ONLY public."Categories"
    ADD CONSTRAINT "Categories_VariableID_fkey" FOREIGN KEY ("VariableID") REFERENCES public."Variables"("VariableID");


--
-- Name: DataValues_CensorCode_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jbianchi
--

ALTER TABLE ONLY public."DataValues"
    ADD CONSTRAINT "DataValues_CensorCode_fkey" FOREIGN KEY ("CensorCode") REFERENCES public."CensorCodeCV"("Term");


--
-- Name: DataValues_MethodID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jbianchi
--

ALTER TABLE ONLY public."DataValues"
    ADD CONSTRAINT "DataValues_MethodID_fkey" FOREIGN KEY ("MethodID") REFERENCES public."Methods"("MethodID");


--
-- Name: DataValues_OffsetTypeID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jbianchi
--

ALTER TABLE ONLY public."DataValues"
    ADD CONSTRAINT "DataValues_OffsetTypeID_fkey" FOREIGN KEY ("OffsetTypeID") REFERENCES public."OffsetTypes"("OffsetTypeID");


--
-- Name: DataValues_QualifierID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jbianchi
--

ALTER TABLE ONLY public."DataValues"
    ADD CONSTRAINT "DataValues_QualifierID_fkey" FOREIGN KEY ("QualifierID") REFERENCES public."Qualifiers"("QualifierID");


--
-- Name: DataValues_QualityControlLevelID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jbianchi
--

ALTER TABLE ONLY public."DataValues"
    ADD CONSTRAINT "DataValues_QualityControlLevelID_fkey" FOREIGN KEY ("QualityControlLevelID") REFERENCES public."QualityControlLevels"("QualityControlLevelID");


--
-- Name: DataValues_SampleID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jbianchi
--

ALTER TABLE ONLY public."DataValues"
    ADD CONSTRAINT "DataValues_SampleID_fkey" FOREIGN KEY ("SampleID") REFERENCES public."Samples"("SampleID");


--
-- Name: DataValues_SiteID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jbianchi
--

ALTER TABLE ONLY public."DataValues"
    ADD CONSTRAINT "DataValues_SiteID_fkey" FOREIGN KEY ("SiteID") REFERENCES public."Sites"("SiteID") ON UPDATE CASCADE;


--
-- Name: DataValues_SourceID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jbianchi
--

ALTER TABLE ONLY public."DataValues"
    ADD CONSTRAINT "DataValues_SourceID_fkey" FOREIGN KEY ("SourceID") REFERENCES public."Sources"("SourceID");


--
-- Name: DataValues_VariableID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jbianchi
--

ALTER TABLE ONLY public."DataValues"
    ADD CONSTRAINT "DataValues_VariableID_fkey" FOREIGN KEY ("VariableID") REFERENCES public."Variables"("VariableID");


--
-- Name: DerivedFrom_ValueID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jbianchi
--

ALTER TABLE ONLY public."DerivedFrom"
    ADD CONSTRAINT "DerivedFrom_ValueID_fkey" FOREIGN KEY ("ValueID") REFERENCES public."DataValues"("ValueID");


--
-- Name: Groups_GroupID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jbianchi
--

ALTER TABLE ONLY public."Groups"
    ADD CONSTRAINT "Groups_GroupID_fkey" FOREIGN KEY ("GroupID") REFERENCES public."GroupDescriptions"("GroupID");


--
-- Name: Groups_ValueID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jbianchi
--

ALTER TABLE ONLY public."Groups"
    ADD CONSTRAINT "Groups_ValueID_fkey" FOREIGN KEY ("ValueID") REFERENCES public."DataValues"("ValueID");


--
-- Name: ISOMetadata_TopicCategory_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jbianchi
--

ALTER TABLE ONLY public."ISOMetadata"
    ADD CONSTRAINT "ISOMetadata_TopicCategory_fkey" FOREIGN KEY ("TopicCategory") REFERENCES public."TopicCategoryCV"("Term");


--
-- Name: OffsetTypes_OffsetUnitsID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jbianchi
--

ALTER TABLE ONLY public."OffsetTypes"
    ADD CONSTRAINT "OffsetTypes_OffsetUnitsID_fkey" FOREIGN KEY ("OffsetUnitsID") REFERENCES public."Units"("UnitsID");


--
-- Name: Samples_LabMethodID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jbianchi
--

ALTER TABLE ONLY public."Samples"
    ADD CONSTRAINT "Samples_LabMethodID_fkey" FOREIGN KEY ("LabMethodID") REFERENCES public."LabMethods"("LabMethodID");


--
-- Name: Samples_SampleType_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jbianchi
--

ALTER TABLE ONLY public."Samples"
    ADD CONSTRAINT "Samples_SampleType_fkey" FOREIGN KEY ("SampleType") REFERENCES public."SampleTypeCV"("Term");


--
-- Name: Sites_LatLongDatumID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jbianchi
--

ALTER TABLE ONLY public."Sites"
    ADD CONSTRAINT "Sites_LatLongDatumID_fkey" FOREIGN KEY ("LatLongDatumID") REFERENCES public."SpatialReferences"("SpatialReferenceID");


--
-- Name: Sites_LocalProjectionID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jbianchi
--

ALTER TABLE ONLY public."Sites"
    ADD CONSTRAINT "Sites_LocalProjectionID_fkey" FOREIGN KEY ("LocalProjectionID") REFERENCES public."SpatialReferences"("SpatialReferenceID");


--
-- Name: Sites_SiteType_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jbianchi
--

ALTER TABLE ONLY public."Sites"
    ADD CONSTRAINT "Sites_SiteType_fkey" FOREIGN KEY ("SiteType") REFERENCES public."SiteTypeCV"("Term");


--
-- Name: Sites_VerticalDatum_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jbianchi
--

ALTER TABLE ONLY public."Sites"
    ADD CONSTRAINT "Sites_VerticalDatum_fkey" FOREIGN KEY ("VerticalDatum") REFERENCES public."VerticalDatumCV"("Term");


--
-- Name: Sources_MetadataID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jbianchi
--

ALTER TABLE ONLY public."Sources"
    ADD CONSTRAINT "Sources_MetadataID_fkey" FOREIGN KEY ("MetadataID") REFERENCES public."ISOMetadata"("MetadataID");


--
-- Name: Variables_DataType_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jbianchi
--

ALTER TABLE ONLY public."Variables"
    ADD CONSTRAINT "Variables_DataType_fkey" FOREIGN KEY ("DataType") REFERENCES public."DataTypeCV"("Term");


--
-- Name: Variables_GeneralCategory_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jbianchi
--

ALTER TABLE ONLY public."Variables"
    ADD CONSTRAINT "Variables_GeneralCategory_fkey" FOREIGN KEY ("GeneralCategory") REFERENCES public."GeneralCategoryCV"("Term");


--
-- Name: Variables_SampleMedium_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jbianchi
--

ALTER TABLE ONLY public."Variables"
    ADD CONSTRAINT "Variables_SampleMedium_fkey" FOREIGN KEY ("SampleMedium") REFERENCES public."SampleMediumCV"("Term");


--
-- Name: Variables_Speciation_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jbianchi
--

ALTER TABLE ONLY public."Variables"
    ADD CONSTRAINT "Variables_Speciation_fkey" FOREIGN KEY ("Speciation") REFERENCES public."SpeciationCV"("Term");


--
-- Name: Variables_TimeUnitsID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jbianchi
--

ALTER TABLE ONLY public."Variables"
    ADD CONSTRAINT "Variables_TimeUnitsID_fkey" FOREIGN KEY ("TimeUnitsID") REFERENCES public."Units"("UnitsID");


--
-- Name: Variables_ValueType_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jbianchi
--

ALTER TABLE ONLY public."Variables"
    ADD CONSTRAINT "Variables_ValueType_fkey" FOREIGN KEY ("ValueType") REFERENCES public."ValueTypeCV"("Term");


--
-- Name: Variables_VariableName_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jbianchi
--

ALTER TABLE ONLY public."Variables"
    ADD CONSTRAINT "Variables_VariableName_fkey" FOREIGN KEY ("VariableName") REFERENCES public."VariableNameCV"("Term");


--
-- Name: Variables_VariableUnitsID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jbianchi
--

ALTER TABLE ONLY public."Variables"
    ADD CONSTRAINT "Variables_VariableUnitsID_fkey" FOREIGN KEY ("VariableUnitsID") REFERENCES public."Units"("UnitsID");


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO jbianchi;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- Name: TABLE "Categories"; Type: ACL; Schema: public; Owner: jbianchi
--

REVOKE ALL ON TABLE public."Categories" FROM PUBLIC;
REVOKE ALL ON TABLE public."Categories" FROM jbianchi;
GRANT ALL ON TABLE public."Categories" TO jbianchi;
GRANT SELECT ON TABLE public."Categories" TO sololectura;
GRANT SELECT ON TABLE public."Categories" TO actualiza;


--
-- Name: TABLE "CensorCodeCV"; Type: ACL; Schema: public; Owner: jbianchi
--

REVOKE ALL ON TABLE public."CensorCodeCV" FROM PUBLIC;
REVOKE ALL ON TABLE public."CensorCodeCV" FROM jbianchi;
GRANT ALL ON TABLE public."CensorCodeCV" TO jbianchi;
GRANT SELECT ON TABLE public."CensorCodeCV" TO sololectura;
GRANT SELECT ON TABLE public."CensorCodeCV" TO actualiza;


--
-- Name: TABLE "DataTypeCV"; Type: ACL; Schema: public; Owner: jbianchi
--

REVOKE ALL ON TABLE public."DataTypeCV" FROM PUBLIC;
REVOKE ALL ON TABLE public."DataTypeCV" FROM jbianchi;
GRANT ALL ON TABLE public."DataTypeCV" TO jbianchi;
GRANT SELECT ON TABLE public."DataTypeCV" TO sololectura;
GRANT SELECT ON TABLE public."DataTypeCV" TO actualiza;


--
-- Name: TABLE "DataValues"; Type: ACL; Schema: public; Owner: jbianchi
--

REVOKE ALL ON TABLE public."DataValues" FROM PUBLIC;
REVOKE ALL ON TABLE public."DataValues" FROM jbianchi;
GRANT ALL ON TABLE public."DataValues" TO jbianchi;
GRANT SELECT ON TABLE public."DataValues" TO sololectura;
GRANT SELECT ON TABLE public."DataValues" TO actualiza;


--
-- Name: TABLE "DerivedFrom"; Type: ACL; Schema: public; Owner: jbianchi
--

REVOKE ALL ON TABLE public."DerivedFrom" FROM PUBLIC;
REVOKE ALL ON TABLE public."DerivedFrom" FROM jbianchi;
GRANT ALL ON TABLE public."DerivedFrom" TO jbianchi;
GRANT SELECT ON TABLE public."DerivedFrom" TO sololectura;
GRANT SELECT ON TABLE public."DerivedFrom" TO actualiza;


--
-- Name: TABLE "GeneralCategoryCV"; Type: ACL; Schema: public; Owner: jbianchi
--

REVOKE ALL ON TABLE public."GeneralCategoryCV" FROM PUBLIC;
REVOKE ALL ON TABLE public."GeneralCategoryCV" FROM jbianchi;
GRANT ALL ON TABLE public."GeneralCategoryCV" TO jbianchi;
GRANT SELECT ON TABLE public."GeneralCategoryCV" TO sololectura;
GRANT SELECT ON TABLE public."GeneralCategoryCV" TO actualiza;


--
-- Name: TABLE "GroupDescriptions"; Type: ACL; Schema: public; Owner: jbianchi
--

REVOKE ALL ON TABLE public."GroupDescriptions" FROM PUBLIC;
REVOKE ALL ON TABLE public."GroupDescriptions" FROM jbianchi;
GRANT ALL ON TABLE public."GroupDescriptions" TO jbianchi;
GRANT SELECT ON TABLE public."GroupDescriptions" TO sololectura;
GRANT SELECT ON TABLE public."GroupDescriptions" TO actualiza;


--
-- Name: TABLE "Groups"; Type: ACL; Schema: public; Owner: jbianchi
--

REVOKE ALL ON TABLE public."Groups" FROM PUBLIC;
REVOKE ALL ON TABLE public."Groups" FROM jbianchi;
GRANT ALL ON TABLE public."Groups" TO jbianchi;
GRANT SELECT ON TABLE public."Groups" TO sololectura;
GRANT SELECT ON TABLE public."Groups" TO actualiza;


--
-- Name: TABLE "ISOMetadata"; Type: ACL; Schema: public; Owner: jbianchi
--

REVOKE ALL ON TABLE public."ISOMetadata" FROM PUBLIC;
REVOKE ALL ON TABLE public."ISOMetadata" FROM jbianchi;
GRANT ALL ON TABLE public."ISOMetadata" TO jbianchi;
GRANT SELECT ON TABLE public."ISOMetadata" TO sololectura;
GRANT SELECT ON TABLE public."ISOMetadata" TO actualiza;


--
-- Name: TABLE "LabMethods"; Type: ACL; Schema: public; Owner: jbianchi
--

REVOKE ALL ON TABLE public."LabMethods" FROM PUBLIC;
REVOKE ALL ON TABLE public."LabMethods" FROM jbianchi;
GRANT ALL ON TABLE public."LabMethods" TO jbianchi;
GRANT SELECT ON TABLE public."LabMethods" TO sololectura;
GRANT SELECT ON TABLE public."LabMethods" TO actualiza;


--
-- Name: TABLE "Methods"; Type: ACL; Schema: public; Owner: jbianchi
--

REVOKE ALL ON TABLE public."Methods" FROM PUBLIC;
REVOKE ALL ON TABLE public."Methods" FROM jbianchi;
GRANT ALL ON TABLE public."Methods" TO jbianchi;
GRANT SELECT ON TABLE public."Methods" TO sololectura;
GRANT SELECT ON TABLE public."Methods" TO actualiza;


--
-- Name: TABLE "ODMVersion"; Type: ACL; Schema: public; Owner: jbianchi
--

REVOKE ALL ON TABLE public."ODMVersion" FROM PUBLIC;
REVOKE ALL ON TABLE public."ODMVersion" FROM jbianchi;
GRANT ALL ON TABLE public."ODMVersion" TO jbianchi;
GRANT SELECT ON TABLE public."ODMVersion" TO sololectura;
GRANT SELECT ON TABLE public."ODMVersion" TO actualiza;


--
-- Name: TABLE "OffsetTypes"; Type: ACL; Schema: public; Owner: jbianchi
--

REVOKE ALL ON TABLE public."OffsetTypes" FROM PUBLIC;
REVOKE ALL ON TABLE public."OffsetTypes" FROM jbianchi;
GRANT ALL ON TABLE public."OffsetTypes" TO jbianchi;
GRANT SELECT ON TABLE public."OffsetTypes" TO sololectura;
GRANT SELECT ON TABLE public."OffsetTypes" TO actualiza;


--
-- Name: TABLE "Qualifiers"; Type: ACL; Schema: public; Owner: jbianchi
--

REVOKE ALL ON TABLE public."Qualifiers" FROM PUBLIC;
REVOKE ALL ON TABLE public."Qualifiers" FROM jbianchi;
GRANT ALL ON TABLE public."Qualifiers" TO jbianchi;
GRANT SELECT ON TABLE public."Qualifiers" TO sololectura;
GRANT SELECT ON TABLE public."Qualifiers" TO actualiza;


--
-- Name: TABLE "QualityControlLevels"; Type: ACL; Schema: public; Owner: jbianchi
--

REVOKE ALL ON TABLE public."QualityControlLevels" FROM PUBLIC;
REVOKE ALL ON TABLE public."QualityControlLevels" FROM jbianchi;
GRANT ALL ON TABLE public."QualityControlLevels" TO jbianchi;
GRANT SELECT ON TABLE public."QualityControlLevels" TO sololectura;
GRANT SELECT ON TABLE public."QualityControlLevels" TO actualiza;


--
-- Name: TABLE "SampleMediumCV"; Type: ACL; Schema: public; Owner: jbianchi
--

REVOKE ALL ON TABLE public."SampleMediumCV" FROM PUBLIC;
REVOKE ALL ON TABLE public."SampleMediumCV" FROM jbianchi;
GRANT ALL ON TABLE public."SampleMediumCV" TO jbianchi;
GRANT SELECT ON TABLE public."SampleMediumCV" TO sololectura;
GRANT SELECT ON TABLE public."SampleMediumCV" TO actualiza;


--
-- Name: TABLE "SampleTypeCV"; Type: ACL; Schema: public; Owner: jbianchi
--

REVOKE ALL ON TABLE public."SampleTypeCV" FROM PUBLIC;
REVOKE ALL ON TABLE public."SampleTypeCV" FROM jbianchi;
GRANT ALL ON TABLE public."SampleTypeCV" TO jbianchi;
GRANT SELECT ON TABLE public."SampleTypeCV" TO sololectura;
GRANT SELECT ON TABLE public."SampleTypeCV" TO actualiza;


--
-- Name: TABLE "Samples"; Type: ACL; Schema: public; Owner: jbianchi
--

REVOKE ALL ON TABLE public."Samples" FROM PUBLIC;
REVOKE ALL ON TABLE public."Samples" FROM jbianchi;
GRANT ALL ON TABLE public."Samples" TO jbianchi;
GRANT SELECT ON TABLE public."Samples" TO sololectura;
GRANT SELECT ON TABLE public."Samples" TO actualiza;


--
-- Name: TABLE "SeriesCatalog"; Type: ACL; Schema: public; Owner: jbianchi
--

REVOKE ALL ON TABLE public."SeriesCatalog" FROM PUBLIC;
REVOKE ALL ON TABLE public."SeriesCatalog" FROM jbianchi;
GRANT ALL ON TABLE public."SeriesCatalog" TO jbianchi;
GRANT SELECT ON TABLE public."SeriesCatalog" TO sololectura;
GRANT SELECT ON TABLE public."SeriesCatalog" TO actualiza;


--
-- Name: TABLE "Sites"; Type: ACL; Schema: public; Owner: jbianchi
--

REVOKE ALL ON TABLE public."Sites" FROM PUBLIC;
REVOKE ALL ON TABLE public."Sites" FROM jbianchi;
GRANT ALL ON TABLE public."Sites" TO jbianchi;
GRANT SELECT ON TABLE public."Sites" TO sololectura;
GRANT SELECT,INSERT,UPDATE ON TABLE public."Sites" TO actualiza;


--
-- Name: TABLE "SiteInfoXML"; Type: ACL; Schema: public; Owner: jbianchi
--

REVOKE ALL ON TABLE public."SiteInfoXML" FROM PUBLIC;
REVOKE ALL ON TABLE public."SiteInfoXML" FROM jbianchi;
GRANT ALL ON TABLE public."SiteInfoXML" TO jbianchi;
GRANT SELECT ON TABLE public."SiteInfoXML" TO sololectura;
GRANT SELECT ON TABLE public."SiteInfoXML" TO actualiza;


--
-- Name: TABLE "SiteTypeCV"; Type: ACL; Schema: public; Owner: jbianchi
--

REVOKE ALL ON TABLE public."SiteTypeCV" FROM PUBLIC;
REVOKE ALL ON TABLE public."SiteTypeCV" FROM jbianchi;
GRANT ALL ON TABLE public."SiteTypeCV" TO jbianchi;
GRANT SELECT ON TABLE public."SiteTypeCV" TO sololectura;
GRANT SELECT ON TABLE public."SiteTypeCV" TO actualiza;


--
-- Name: SEQUENCE "Sites_SiteID_seq"; Type: ACL; Schema: public; Owner: jbianchi
--

REVOKE ALL ON SEQUENCE public."Sites_SiteID_seq" FROM PUBLIC;
REVOKE ALL ON SEQUENCE public."Sites_SiteID_seq" FROM jbianchi;
GRANT ALL ON SEQUENCE public."Sites_SiteID_seq" TO jbianchi;
GRANT ALL ON SEQUENCE public."Sites_SiteID_seq" TO actualiza;


--
-- Name: TABLE "Sources"; Type: ACL; Schema: public; Owner: jbianchi
--

REVOKE ALL ON TABLE public."Sources" FROM PUBLIC;
REVOKE ALL ON TABLE public."Sources" FROM jbianchi;
GRANT ALL ON TABLE public."Sources" TO jbianchi;
GRANT SELECT ON TABLE public."Sources" TO sololectura;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public."Sources" TO actualiza;


--
-- Name: TABLE "SourceInfoXML"; Type: ACL; Schema: public; Owner: jbianchi
--

REVOKE ALL ON TABLE public."SourceInfoXML" FROM PUBLIC;
REVOKE ALL ON TABLE public."SourceInfoXML" FROM jbianchi;
GRANT ALL ON TABLE public."SourceInfoXML" TO jbianchi;
GRANT SELECT ON TABLE public."SourceInfoXML" TO sololectura;
GRANT SELECT ON TABLE public."SourceInfoXML" TO actualiza;


--
-- Name: SEQUENCE "Sources_SourceID_seq"; Type: ACL; Schema: public; Owner: jbianchi
--

REVOKE ALL ON SEQUENCE public."Sources_SourceID_seq" FROM PUBLIC;
REVOKE ALL ON SEQUENCE public."Sources_SourceID_seq" FROM jbianchi;
GRANT ALL ON SEQUENCE public."Sources_SourceID_seq" TO jbianchi;
GRANT USAGE,UPDATE ON SEQUENCE public."Sources_SourceID_seq" TO actualiza;


--
-- Name: TABLE "SpatialReferences"; Type: ACL; Schema: public; Owner: jbianchi
--

REVOKE ALL ON TABLE public."SpatialReferences" FROM PUBLIC;
REVOKE ALL ON TABLE public."SpatialReferences" FROM jbianchi;
GRANT ALL ON TABLE public."SpatialReferences" TO jbianchi;
GRANT SELECT ON TABLE public."SpatialReferences" TO sololectura;
GRANT SELECT ON TABLE public."SpatialReferences" TO actualiza;


--
-- Name: TABLE "SpeciationCV"; Type: ACL; Schema: public; Owner: jbianchi
--

REVOKE ALL ON TABLE public."SpeciationCV" FROM PUBLIC;
REVOKE ALL ON TABLE public."SpeciationCV" FROM jbianchi;
GRANT ALL ON TABLE public."SpeciationCV" TO jbianchi;
GRANT SELECT ON TABLE public."SpeciationCV" TO sololectura;
GRANT SELECT ON TABLE public."SpeciationCV" TO actualiza;


--
-- Name: TABLE "TopicCategoryCV"; Type: ACL; Schema: public; Owner: jbianchi
--

REVOKE ALL ON TABLE public."TopicCategoryCV" FROM PUBLIC;
REVOKE ALL ON TABLE public."TopicCategoryCV" FROM jbianchi;
GRANT ALL ON TABLE public."TopicCategoryCV" TO jbianchi;
GRANT SELECT ON TABLE public."TopicCategoryCV" TO sololectura;
GRANT SELECT ON TABLE public."TopicCategoryCV" TO actualiza;


--
-- Name: TABLE "Units"; Type: ACL; Schema: public; Owner: jbianchi
--

REVOKE ALL ON TABLE public."Units" FROM PUBLIC;
REVOKE ALL ON TABLE public."Units" FROM jbianchi;
GRANT ALL ON TABLE public."Units" TO jbianchi;
GRANT SELECT ON TABLE public."Units" TO sololectura;
GRANT SELECT ON TABLE public."Units" TO actualiza;


--
-- Name: TABLE "UnitsXML"; Type: ACL; Schema: public; Owner: jbianchi
--

REVOKE ALL ON TABLE public."UnitsXML" FROM PUBLIC;
REVOKE ALL ON TABLE public."UnitsXML" FROM jbianchi;
GRANT ALL ON TABLE public."UnitsXML" TO jbianchi;
GRANT SELECT ON TABLE public."UnitsXML" TO sololectura;
GRANT SELECT ON TABLE public."UnitsXML" TO actualiza;


--
-- Name: TABLE "ValueTypeCV"; Type: ACL; Schema: public; Owner: jbianchi
--

REVOKE ALL ON TABLE public."ValueTypeCV" FROM PUBLIC;
REVOKE ALL ON TABLE public."ValueTypeCV" FROM jbianchi;
GRANT ALL ON TABLE public."ValueTypeCV" TO jbianchi;
GRANT SELECT ON TABLE public."ValueTypeCV" TO sololectura;
GRANT SELECT ON TABLE public."ValueTypeCV" TO actualiza;


--
-- Name: TABLE "Variables"; Type: ACL; Schema: public; Owner: jbianchi
--

REVOKE ALL ON TABLE public."Variables" FROM PUBLIC;
REVOKE ALL ON TABLE public."Variables" FROM jbianchi;
GRANT ALL ON TABLE public."Variables" TO jbianchi;
GRANT SELECT ON TABLE public."Variables" TO sololectura;
GRANT SELECT,INSERT,UPDATE ON TABLE public."Variables" TO actualiza;


--
-- Name: TABLE "VariableInfoXML"; Type: ACL; Schema: public; Owner: jbianchi
--

REVOKE ALL ON TABLE public."VariableInfoXML" FROM PUBLIC;
REVOKE ALL ON TABLE public."VariableInfoXML" FROM jbianchi;
GRANT ALL ON TABLE public."VariableInfoXML" TO jbianchi;
GRANT SELECT ON TABLE public."VariableInfoXML" TO sololectura;
GRANT SELECT ON TABLE public."VariableInfoXML" TO actualiza;


--
-- Name: TABLE "VariableNameCV"; Type: ACL; Schema: public; Owner: jbianchi
--

REVOKE ALL ON TABLE public."VariableNameCV" FROM PUBLIC;
REVOKE ALL ON TABLE public."VariableNameCV" FROM jbianchi;
GRANT ALL ON TABLE public."VariableNameCV" TO jbianchi;
GRANT SELECT ON TABLE public."VariableNameCV" TO sololectura;
GRANT SELECT ON TABLE public."VariableNameCV" TO actualiza;


--
-- Name: SEQUENCE "Variables_VariableID_seq"; Type: ACL; Schema: public; Owner: jbianchi
--

REVOKE ALL ON SEQUENCE public."Variables_VariableID_seq" FROM PUBLIC;
REVOKE ALL ON SEQUENCE public."Variables_VariableID_seq" FROM jbianchi;
GRANT ALL ON SEQUENCE public."Variables_VariableID_seq" TO jbianchi;
GRANT USAGE,UPDATE ON SEQUENCE public."Variables_VariableID_seq" TO actualiza;


--
-- Name: TABLE "VerticalDatumCV"; Type: ACL; Schema: public; Owner: jbianchi
--

REVOKE ALL ON TABLE public."VerticalDatumCV" FROM PUBLIC;
REVOKE ALL ON TABLE public."VerticalDatumCV" FROM jbianchi;
GRANT ALL ON TABLE public."VerticalDatumCV" TO jbianchi;
GRANT SELECT ON TABLE public."VerticalDatumCV" TO sololectura;
GRANT SELECT ON TABLE public."VerticalDatumCV" TO actualiza;


--
-- PostgreSQL database dump complete
--

