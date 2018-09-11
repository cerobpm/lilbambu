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
-- Name: pg_cron; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS pg_cron WITH SCHEMA public;


--
-- Name: EXTENSION pg_cron; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_cron IS 'Job scheduler for PostgreSQL';


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
-- Name: FeatureTypeCV; Type: TABLE; Schema: public; Owner: jbianchi
--

CREATE TABLE public."FeatureTypeCV" (
    "FeatureTypeID" integer NOT NULL,
    "FeatureTypeName" character varying NOT NULL,
    "Description" character varying
);


ALTER TABLE public."FeatureTypeCV" OWNER TO jbianchi;

--
-- Name: FeatureTypeCV_FeatureTypeID_seq; Type: SEQUENCE; Schema: public; Owner: jbianchi
--

CREATE SEQUENCE public."FeatureTypeCV_FeatureTypeID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."FeatureTypeCV_FeatureTypeID_seq" OWNER TO jbianchi;

--
-- Name: FeatureTypeCV_FeatureTypeID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jbianchi
--

ALTER SEQUENCE public."FeatureTypeCV_FeatureTypeID_seq" OWNED BY public."FeatureTypeCV"."FeatureTypeID";


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
    "MethodLink" text,
    "MethodCode" character varying(255)
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
    "Geometry" public.geometry,
    "FeatureType" character varying(50) DEFAULT 'point'::character varying
);


ALTER TABLE public."Sites" OWNER TO jbianchi;

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
    "MetadataID" integer DEFAULT 0 NOT NULL,
    "SourceCode" character varying
);


ALTER TABLE public."Sources" OWNER TO jbianchi;

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
-- Name: SeriesCatalogView; Type: MATERIALIZED VIEW; Schema: public; Owner: jbianchi
--

CREATE MATERIALIZED VIEW public."SeriesCatalogView" AS
 WITH timeunits AS (
         SELECT "Units"."UnitsID",
            "Units"."UnitsName",
            "Units"."UnitsType",
            "Units"."UnitsAbbreviation"
           FROM public."Units"
        ), series AS (
         SELECT "Sites"."SiteID",
            "Sites"."SiteCode",
            "Sites"."SiteName",
            "Sites"."SiteType",
            "Variables"."VariableID",
            "Variables"."VariableCode",
            "Variables"."VariableName",
            "Variables"."Speciation",
            "Variables"."VariableUnitsID",
            "Units"."UnitsName" AS "VariableUnitsName",
            "Variables"."SampleMedium",
            "Variables"."ValueType",
            "Variables"."TimeSupport",
            "Variables"."TimeUnitsID",
            timeunits."UnitsName" AS "TimeUnitsName",
            "Variables"."DataType",
            "Variables"."GeneralCategory",
            "Methods"."MethodID",
            "Methods"."MethodDescription",
            "Sources"."SourceID",
            "Sources"."Organization",
            "Sources"."SourceDescription",
            "Sources"."Citation",
            "QualityControlLevels"."QualityControlLevelID",
            "QualityControlLevels"."QualityControlLevelCode",
            min("DataValues"."LocalDateTime") AS "BeginDateTime",
            max("DataValues"."LocalDateTime") AS "EndDateTime",
            min("DataValues"."DateTimeUTC") AS "BeginDateTimeUTC",
            max("DataValues"."DateTimeUTC") AS "EndDateTimeUTC",
            count("DataValues"."DataValue") AS "ValueCount"
           FROM public."Sites",
            public."Variables",
            public."Sources",
            public."DataValues",
            public."QualityControlLevels",
            public."Methods",
            public."Units",
            timeunits
          WHERE (("Sites"."SiteID" = "DataValues"."SiteID") AND ("Variables"."VariableID" = "DataValues"."VariableID") AND ("Sources"."SourceID" = "DataValues"."SourceID") AND ("QualityControlLevels"."QualityControlLevelID" = "DataValues"."QualityControlLevelID") AND ("Methods"."MethodID" = "DataValues"."MethodID") AND ("Units"."UnitsID" = "Variables"."VariableUnitsID") AND (timeunits."UnitsID" = "Variables"."TimeUnitsID"))
          GROUP BY "Sites"."SiteID", "Sites"."SiteCode", "Sites"."SiteName", "Sites"."SiteType", "Variables"."VariableID", "Variables"."VariableCode", "Variables"."VariableName", "Variables"."Speciation", "Variables"."VariableUnitsID", "Units"."UnitsName", "Variables"."SampleMedium", "Variables"."ValueType", "Variables"."TimeSupport", "Variables"."TimeUnitsID", timeunits."UnitsName", "Variables"."DataType", "Variables"."GeneralCategory", "Methods"."MethodID", "Methods"."MethodDescription", "Sources"."SourceID", "Sources"."Organization", "Sources"."SourceDescription", "Sources"."Citation", "QualityControlLevels"."QualityControlLevelID", "QualityControlLevels"."QualityControlLevelCode"
          ORDER BY "Sites"."SiteID", "Sites"."SiteCode", "Sites"."SiteName", "Sites"."SiteType", "Variables"."VariableID", "Variables"."VariableCode", "Variables"."VariableName", "Variables"."Speciation", "Variables"."VariableUnitsID", "Units"."UnitsName", "Variables"."SampleMedium", "Variables"."ValueType", "Variables"."TimeSupport", "Variables"."TimeUnitsID", timeunits."UnitsName", "Variables"."DataType", "Variables"."GeneralCategory", "Methods"."MethodID", "Methods"."MethodDescription", "Sources"."SourceID", "Sources"."Organization", "Sources"."SourceDescription", "Sources"."Citation", "QualityControlLevels"."QualityControlLevelID", "QualityControlLevels"."QualityControlLevelCode"
        )
 SELECT row_number() OVER (ORDER BY series."SiteID", series."VariableID", series."SourceID") AS "SeriesID",
    series."SiteID",
    series."SiteCode",
    series."SiteName",
    series."SiteType",
    series."VariableID",
    series."VariableCode",
    series."VariableName",
    series."Speciation",
    series."VariableUnitsID",
    series."VariableUnitsName",
    series."SampleMedium",
    series."ValueType",
    series."TimeSupport",
    series."TimeUnitsID",
    series."TimeUnitsName",
    series."DataType",
    series."GeneralCategory",
    series."MethodID",
    series."MethodDescription",
    series."SourceID",
    series."Organization",
    series."SourceDescription",
    series."Citation",
    series."QualityControlLevelID",
    series."QualityControlLevelCode",
    series."BeginDateTime",
    series."EndDateTime",
    series."BeginDateTimeUTC",
    series."EndDateTimeUTC",
    series."ValueCount"
   FROM series
  WITH NO DATA;


ALTER TABLE public."SeriesCatalogView" OWNER TO jbianchi;

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
    XMLELEMENT(NAME variable, XMLELEMENT(NAME "variableCode", XMLATTRIBUTES(true AS "default", "Variables"."VariableID" AS "variableID"), "Variables"."VariableCode"), XMLELEMENT(NAME "variableName", "Variables"."VariableName"), XMLELEMENT(NAME "variableDescription", ''), XMLELEMENT(NAME "valueType", "Variables"."ValueType"), XMLELEMENT(NAME "dataType", "Variables"."DataType"), XMLELEMENT(NAME "generalCategory", "Variables"."GeneralCategory"), "UnitsXML"."UnitsXML", XMLELEMENT(NAME "timeScale", XMLATTRIBUTES("Variables"."IsRegular" AS "isRegular"), XMLELEMENT(NAME unit, timeunits."UnitsXML"), XMLELEMENT(NAME "timeSupport", "Variables"."TimeSupport"), XMLELEMENT(NAME "timeSpacing",
        CASE
            WHEN ("Variables"."IsRegular" = true) THEN "Variables"."TimeSupport"
            ELSE (0)::real
        END)), XMLELEMENT(NAME "noDataValue", "Variables"."NoDataValue"), XMLELEMENT(NAME "sampleMedium", "Variables"."SampleMedium")) AS "VariableInfoXML"
   FROM public."Variables",
    public."UnitsXML",
    public."UnitsXML" timeunits
  WHERE (("Variables"."VariableUnitsID" = "UnitsXML"."UnitsID") AND ("Variables"."TimeUnitsID" = timeunits."UnitsID"));


ALTER TABLE public."VariableInfoXML" OWNER TO jbianchi;

--
-- Name: SeriesCatalogXML; Type: VIEW; Schema: public; Owner: jbianchi
--

CREATE VIEW public."SeriesCatalogXML" AS
 SELECT "SeriesCatalogView"."SeriesID",
    XMLELEMENT(NAME series, XMLATTRIBUTES("SeriesCatalogView"."SeriesID" AS "seriesID"), XMLELEMENT(NAME "dataType", "SeriesCatalogView"."DataType"), XMLELEMENT(NAME variable, "VariableInfoXML"."VariableInfoXML"), XMLELEMENT(NAME "valueCount", "SeriesCatalogView"."ValueCount"), XMLELEMENT(NAME "variableTimeInterval", XMLELEMENT(NAME "beginDateTime", "SeriesCatalogView"."BeginDateTime"), XMLELEMENT(NAME "endDateTime", "SeriesCatalogView"."EndDateTime"), XMLELEMENT(NAME "beginDateTimeUTC", "SeriesCatalogView"."BeginDateTimeUTC"), XMLELEMENT(NAME "endDateTimeUTC", "SeriesCatalogView"."EndDateTimeUTC")), XMLELEMENT(NAME method, XMLATTRIBUTES("SeriesCatalogView"."MethodID" AS "methodID"), XMLELEMENT(NAME "methodCode", ("Methods"."MethodID")::text), XMLELEMENT(NAME "methodDescription", "SeriesCatalogView"."MethodDescription")), XMLELEMENT(NAME source, XMLATTRIBUTES("SeriesCatalogView"."SourceID" AS "sourceID"), XMLELEMENT(NAME "sourceCode", ("Sources"."SourceID")::text), XMLELEMENT(NAME organization, "SeriesCatalogView"."Organization"), XMLELEMENT(NAME "sourceDescription", "SeriesCatalogView"."SourceDescription"), XMLELEMENT(NAME "sourceLink", "Sources"."SourceLink"))) AS "SeriesCatalogXML"
   FROM public."SeriesCatalogView",
    public."VariableInfoXML",
    public."Methods",
    public."Sources"
  WHERE (("SeriesCatalogView"."VariableID" = "VariableInfoXML"."VariableID") AND ("SeriesCatalogView"."SourceID" = "Sources"."SourceID") AND ("SeriesCatalogView"."SourceID" = "Sources"."SourceID"))
  ORDER BY "SeriesCatalogView"."SiteID", "SeriesCatalogView"."VariableID";


ALTER TABLE public."SeriesCatalogXML" OWNER TO jbianchi;

--
-- Name: SeriesCatalogXMLcombinada; Type: VIEW; Schema: public; Owner: jbianchi
--

CREATE VIEW public."SeriesCatalogXMLcombinada" AS
 WITH fromview AS (
         SELECT "VariableInfoXML"."VariableID",
            "Sources"."SourceID",
            "SeriesCatalogView"."SiteID",
            "SeriesCatalogView"."SeriesID",
            XMLELEMENT(NAME series, XMLATTRIBUTES("SeriesCatalogView"."SeriesID" AS "seriesID"), XMLELEMENT(NAME "dataType", "SeriesCatalogView"."DataType"), XMLELEMENT(NAME variable, "VariableInfoXML"."VariableInfoXML"), XMLELEMENT(NAME "valueCount", "SeriesCatalogView"."ValueCount"), XMLELEMENT(NAME "variableTimeInterval", XMLELEMENT(NAME "beginDateTime", "SeriesCatalogView"."BeginDateTime"), XMLELEMENT(NAME "endDateTime", "SeriesCatalogView"."EndDateTime"), XMLELEMENT(NAME "beginDateTimeUTC", "SeriesCatalogView"."BeginDateTimeUTC"), XMLELEMENT(NAME "endDateTimeUTC", "SeriesCatalogView"."EndDateTimeUTC")), XMLELEMENT(NAME method, XMLATTRIBUTES("SeriesCatalogView"."MethodID" AS "methodID"), XMLELEMENT(NAME "methodCode", ("Methods"."MethodID")::text), XMLELEMENT(NAME "methodDescription", "SeriesCatalogView"."MethodDescription")), XMLELEMENT(NAME source, XMLATTRIBUTES("SeriesCatalogView"."SourceID" AS "sourceID"), XMLELEMENT(NAME "sourceCode", ("Sources"."SourceID")::text), XMLELEMENT(NAME organization, "SeriesCatalogView"."Organization"), XMLELEMENT(NAME "sourceDescription", "SeriesCatalogView"."SourceDescription"), XMLELEMENT(NAME "sourceLink", "Sources"."SourceLink"))) AS "SeriesCatalogXML"
           FROM public."SeriesCatalogView",
            public."VariableInfoXML",
            public."Methods",
            public."Sources"
          WHERE (("SeriesCatalogView"."VariableID" = "VariableInfoXML"."VariableID") AND ("SeriesCatalogView"."SourceID" = "Sources"."SourceID") AND ("SeriesCatalogView"."MethodID" = "Methods"."MethodID"))
          ORDER BY "SeriesCatalogView"."SiteID", "SeriesCatalogView"."VariableID"
        ), fromtable AS (
         SELECT "VariableInfoXML"."VariableID",
            "Sources"."SourceID",
            "SeriesCatalog"."SiteID",
            "SeriesCatalog"."SeriesID",
            XMLELEMENT(NAME series, XMLATTRIBUTES("SeriesCatalog"."SeriesID" AS "seriesID"), XMLELEMENT(NAME "dataType", "SeriesCatalog"."DataType"), XMLELEMENT(NAME variable, "VariableInfoXML"."VariableInfoXML"), XMLELEMENT(NAME "valueCount", "SeriesCatalog"."ValueCount"), XMLELEMENT(NAME "variableTimeInterval", XMLELEMENT(NAME "beginDateTime", "SeriesCatalog"."BeginDateTime"), XMLELEMENT(NAME "endDateTime", "SeriesCatalog"."EndDateTime"), XMLELEMENT(NAME "beginDateTimeUTC", "SeriesCatalog"."BeginDateTimeUTC"), XMLELEMENT(NAME "endDateTimeUTC", "SeriesCatalog"."EndDateTimeUTC")), XMLELEMENT(NAME method, XMLATTRIBUTES("SeriesCatalog"."MethodID" AS "methodID"), XMLELEMENT(NAME "methodCode", ("Methods"."MethodID")::text), XMLELEMENT(NAME "methodDescription", "SeriesCatalog"."MethodDescription")), XMLELEMENT(NAME source, XMLATTRIBUTES("SeriesCatalog"."SourceID" AS "sourceID"), XMLELEMENT(NAME "sourceCode", ("Sources"."SourceID")::text), XMLELEMENT(NAME organization, "SeriesCatalog"."Organization"), XMLELEMENT(NAME "sourceDescription", "SeriesCatalog"."SourceDescription"), XMLELEMENT(NAME "sourceLink", "Sources"."SourceLink"))) AS "SeriesCatalogXML"
           FROM public."SeriesCatalog",
            public."VariableInfoXML",
            public."Methods",
            public."Sources"
          WHERE (("SeriesCatalog"."VariableID" = "VariableInfoXML"."VariableID") AND ("SeriesCatalog"."SourceID" = "Sources"."SourceID") AND ("SeriesCatalog"."MethodID" = "Methods"."MethodID"))
          ORDER BY "SeriesCatalog"."SiteID", "SeriesCatalog"."VariableID"
        ), fromall AS (
         SELECT "Sites"."SiteID",
            "Variables"."VariableID",
            COALESCE(fromview."SeriesCatalogXML", fromtable."SeriesCatalogXML") AS "SeriesCatalogXML",
            COALESCE(fromview."SeriesID", (fromtable."SeriesID")::bigint) AS "SeriesID"
           FROM (((public."Sites"
             JOIN public."Variables" ON (("Sites"."SiteID" IS NOT NULL)))
             LEFT JOIN fromview ON ((("Sites"."SiteID" = fromview."SiteID") AND ("Variables"."VariableID" = fromview."VariableID"))))
             LEFT JOIN fromtable ON ((("Sites"."SiteID" = fromtable."SiteID") AND ("Variables"."VariableID" = fromtable."VariableID"))))
        )
 SELECT fromall."SiteID",
    fromall."VariableID",
    fromall."SeriesCatalogXML",
    fromall."SeriesID"
   FROM fromall
  WHERE (fromall."SeriesCatalogXML" IS NOT NULL)
  ORDER BY fromall."SiteID", fromall."VariableID";


ALTER TABLE public."SeriesCatalogXMLcombinada" OWNER TO jbianchi;

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
-- Name: SiteInfoXML; Type: VIEW; Schema: public; Owner: jbianchi
--

CREATE VIEW public."SiteInfoXML" AS
 SELECT "Sites"."SiteID",
    XMLELEMENT(NAME "siteInfo", XMLATTRIBUTES("Sites"."SiteID" AS oid), XMLELEMENT(NAME "siteName", "Sites"."SiteName"), XMLELEMENT(NAME "siteCode", XMLATTRIBUTES(true AS "defaultId", "Sites"."SiteID" AS "siteID", 'SAT-CDP INA' AS network, 'INA' AS "agencyCode", 'INA' AS "agencyName"), "Sites"."SiteCode"), XMLELEMENT(NAME "timeZoneInfo", XMLATTRIBUTES(false AS "siteUsesDaylightSavingsTime"), XMLELEMENT(NAME "defaultTimeZone", '-03')), XMLELEMENT(NAME "geoLocation", XMLELEMENT(NAME "geogLocation", XMLATTRIBUTES('LatLonPointType' AS "xsi:type", 'EPSG:4326' AS srs), XMLELEMENT(NAME latitude, "Sites"."Latitude"), XMLELEMENT(NAME longitude, "Sites"."Longitude")), XMLELEMENT(NAME "localSiteXY", XMLATTRIBUTES((spatial_ref_sys.auth_name)::text AS "projectionInformation"), XMLELEMENT(NAME "X", public.st_x("Sites"."Geometry")), XMLELEMENT(NAME "Y", public.st_y("Sites"."Geometry")))), XMLELEMENT(NAME elevation_m, "Sites"."Elevation_m"), XMLELEMENT(NAME "verticalDatum", "Sites"."VerticalDatum"), XMLELEMENT(NAME "siteProperty", XMLATTRIBUTES('Country' AS title), "Sites"."Country"), XMLELEMENT(NAME "siteProperty", XMLATTRIBUTES('State' AS title), "Sites"."State"), XMLELEMENT(NAME "siteProperty", XMLATTRIBUTES('Site Comments' AS title), "Sites"."Comments")) AS "SiteInfoXML"
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
-- Name: SitesWithSeriesCatalogXML; Type: VIEW; Schema: public; Owner: jbianchi
--

CREATE VIEW public."SitesWithSeriesCatalogXML" AS
 WITH siteseriesagg AS (
         SELECT "Sites"."SiteID",
            xmlagg("SeriesCatalogXMLcombinada"."SeriesCatalogXML") AS "seriesCatalog"
           FROM public."Sites",
            public."SeriesCatalogXMLcombinada"
          WHERE ("Sites"."SiteID" = "SeriesCatalogXMLcombinada"."SiteID")
          GROUP BY "Sites"."SiteID"
        )
 SELECT "SiteInfoXML"."SiteID",
    XMLELEMENT(NAME site, "SiteInfoXML"."SiteInfoXML", XMLELEMENT(NAME "seriesCatalog", siteseriesagg."seriesCatalog")) AS site
   FROM (public."SiteInfoXML"
     LEFT JOIN siteseriesagg ON (("SiteInfoXML"."SiteID" = siteseriesagg."SiteID")))
  ORDER BY "SiteInfoXML"."SiteID";


ALTER TABLE public."SitesWithSeriesCatalogXML" OWNER TO jbianchi;

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
-- Name: ValuesXML; Type: VIEW; Schema: public; Owner: jbianchi
--

CREATE VIEW public."ValuesXML" AS
 SELECT "DataValues"."ValueID",
    XMLELEMENT(NAME "sr:value", XMLATTRIBUTES("DataValues"."LocalDateTime" AS "dateTime", "DataValues"."DateTimeUTC" AS "dateTimeUTC", "DataValues"."MethodID" AS "methodID", "DataValues"."SourceID" AS "sourceID", "DataValues"."SampleID" AS "sampleID", "DataValues"."ValueID" AS oid, "DataValues"."UTCOffset" AS "timeOffset"), "DataValues"."DataValue") AS "ValueXML"
   FROM public."DataValues";


ALTER TABLE public."ValuesXML" OWNER TO jbianchi;

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
-- Name: FeatureTypeID; Type: DEFAULT; Schema: public; Owner: jbianchi
--

ALTER TABLE ONLY public."FeatureTypeCV" ALTER COLUMN "FeatureTypeID" SET DEFAULT nextval('public."FeatureTypeCV_FeatureTypeID_seq"'::regclass);


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
-- Name: DataValues_SiteID_VariableID_SourceID_DateTimeUTC_key; Type: CONSTRAINT; Schema: public; Owner: jbianchi
--

ALTER TABLE ONLY public."DataValues"
    ADD CONSTRAINT "DataValues_SiteID_VariableID_SourceID_DateTimeUTC_key" UNIQUE ("SiteID", "VariableID", "SourceID", "DateTimeUTC");


--
-- Name: DataValues_pkey; Type: CONSTRAINT; Schema: public; Owner: jbianchi
--

ALTER TABLE ONLY public."DataValues"
    ADD CONSTRAINT "DataValues_pkey" PRIMARY KEY ("ValueID");


--
-- Name: FeatureTypeCV_FeatureTypeID_key; Type: CONSTRAINT; Schema: public; Owner: jbianchi
--

ALTER TABLE ONLY public."FeatureTypeCV"
    ADD CONSTRAINT "FeatureTypeCV_FeatureTypeID_key" UNIQUE ("FeatureTypeID");


--
-- Name: FeatureTypeCV_FeatureTypeName_key; Type: CONSTRAINT; Schema: public; Owner: jbianchi
--

ALTER TABLE ONLY public."FeatureTypeCV"
    ADD CONSTRAINT "FeatureTypeCV_FeatureTypeName_key" UNIQUE ("FeatureTypeName");


--
-- Name: FeatureTypeCV_pkey; Type: CONSTRAINT; Schema: public; Owner: jbianchi
--

ALTER TABLE ONLY public."FeatureTypeCV"
    ADD CONSTRAINT "FeatureTypeCV_pkey" PRIMARY KEY ("FeatureTypeID");


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
-- Name: SeriesCatalog_SiteID_VariableID_key; Type: CONSTRAINT; Schema: public; Owner: jbianchi
--

ALTER TABLE ONLY public."SeriesCatalog"
    ADD CONSTRAINT "SeriesCatalog_SiteID_VariableID_key" UNIQUE ("SiteID", "VariableID");


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
-- Name: Sources_SourceCode_key; Type: CONSTRAINT; Schema: public; Owner: jbianchi
--

ALTER TABLE ONLY public."Sources"
    ADD CONSTRAINT "Sources_SourceCode_key" UNIQUE ("SourceCode");


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
-- Name: SeriesCatalog_SiteID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jbianchi
--

ALTER TABLE ONLY public."SeriesCatalog"
    ADD CONSTRAINT "SeriesCatalog_SiteID_fkey" FOREIGN KEY ("SiteID") REFERENCES public."Sites"("SiteID");


--
-- Name: SeriesCatalog_VariableID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jbianchi
--

ALTER TABLE ONLY public."SeriesCatalog"
    ADD CONSTRAINT "SeriesCatalog_VariableID_fkey" FOREIGN KEY ("VariableID") REFERENCES public."Variables"("VariableID");


--
-- Name: Sites_FeatureType_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jbianchi
--

ALTER TABLE ONLY public."Sites"
    ADD CONSTRAINT "Sites_FeatureType_fkey" FOREIGN KEY ("FeatureType") REFERENCES public."FeatureTypeCV"("FeatureTypeName");


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
GRANT SELECT,INSERT,UPDATE ON TABLE public."DataValues" TO actualiza;


--
-- Name: SEQUENCE "DataValues_ValueID_seq"; Type: ACL; Schema: public; Owner: jbianchi
--

REVOKE ALL ON SEQUENCE public."DataValues_ValueID_seq" FROM PUBLIC;
REVOKE ALL ON SEQUENCE public."DataValues_ValueID_seq" FROM jbianchi;
GRANT ALL ON SEQUENCE public."DataValues_ValueID_seq" TO jbianchi;
GRANT ALL ON SEQUENCE public."DataValues_ValueID_seq" TO actualiza;


--
-- Name: TABLE "DerivedFrom"; Type: ACL; Schema: public; Owner: jbianchi
--

REVOKE ALL ON TABLE public."DerivedFrom" FROM PUBLIC;
REVOKE ALL ON TABLE public."DerivedFrom" FROM jbianchi;
GRANT ALL ON TABLE public."DerivedFrom" TO jbianchi;
GRANT SELECT ON TABLE public."DerivedFrom" TO sololectura;
GRANT SELECT ON TABLE public."DerivedFrom" TO actualiza;


--
-- Name: TABLE "FeatureTypeCV"; Type: ACL; Schema: public; Owner: jbianchi
--

REVOKE ALL ON TABLE public."FeatureTypeCV" FROM PUBLIC;
REVOKE ALL ON TABLE public."FeatureTypeCV" FROM jbianchi;
GRANT ALL ON TABLE public."FeatureTypeCV" TO jbianchi;
GRANT SELECT,INSERT,UPDATE ON TABLE public."FeatureTypeCV" TO actualiza;


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
-- Name: TABLE "Sources"; Type: ACL; Schema: public; Owner: jbianchi
--

REVOKE ALL ON TABLE public."Sources" FROM PUBLIC;
REVOKE ALL ON TABLE public."Sources" FROM jbianchi;
GRANT ALL ON TABLE public."Sources" TO jbianchi;
GRANT SELECT ON TABLE public."Sources" TO sololectura;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public."Sources" TO actualiza;


--
-- Name: TABLE "Units"; Type: ACL; Schema: public; Owner: jbianchi
--

REVOKE ALL ON TABLE public."Units" FROM PUBLIC;
REVOKE ALL ON TABLE public."Units" FROM jbianchi;
GRANT ALL ON TABLE public."Units" TO jbianchi;
GRANT SELECT ON TABLE public."Units" TO sololectura;
GRANT SELECT ON TABLE public."Units" TO actualiza;


--
-- Name: TABLE "Variables"; Type: ACL; Schema: public; Owner: jbianchi
--

REVOKE ALL ON TABLE public."Variables" FROM PUBLIC;
REVOKE ALL ON TABLE public."Variables" FROM jbianchi;
GRANT ALL ON TABLE public."Variables" TO jbianchi;
GRANT SELECT ON TABLE public."Variables" TO sololectura;
GRANT SELECT,INSERT,UPDATE ON TABLE public."Variables" TO actualiza;


--
-- Name: TABLE "SeriesCatalogView"; Type: ACL; Schema: public; Owner: jbianchi
--

REVOKE ALL ON TABLE public."SeriesCatalogView" FROM PUBLIC;
REVOKE ALL ON TABLE public."SeriesCatalogView" FROM jbianchi;
GRANT ALL ON TABLE public."SeriesCatalogView" TO jbianchi;
GRANT SELECT ON TABLE public."SeriesCatalogView" TO sololectura;
GRANT SELECT ON TABLE public."SeriesCatalogView" TO actualiza;


--
-- Name: TABLE "UnitsXML"; Type: ACL; Schema: public; Owner: jbianchi
--

REVOKE ALL ON TABLE public."UnitsXML" FROM PUBLIC;
REVOKE ALL ON TABLE public."UnitsXML" FROM jbianchi;
GRANT ALL ON TABLE public."UnitsXML" TO jbianchi;
GRANT SELECT ON TABLE public."UnitsXML" TO sololectura;
GRANT SELECT ON TABLE public."UnitsXML" TO actualiza;


--
-- Name: TABLE "VariableInfoXML"; Type: ACL; Schema: public; Owner: jbianchi
--

REVOKE ALL ON TABLE public."VariableInfoXML" FROM PUBLIC;
REVOKE ALL ON TABLE public."VariableInfoXML" FROM jbianchi;
GRANT ALL ON TABLE public."VariableInfoXML" TO jbianchi;
GRANT SELECT ON TABLE public."VariableInfoXML" TO sololectura;
GRANT SELECT ON TABLE public."VariableInfoXML" TO actualiza;


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
-- Name: TABLE "SitesWithSeriesCatalogXML"; Type: ACL; Schema: public; Owner: jbianchi
--

REVOKE ALL ON TABLE public."SitesWithSeriesCatalogXML" FROM PUBLIC;
REVOKE ALL ON TABLE public."SitesWithSeriesCatalogXML" FROM jbianchi;
GRANT ALL ON TABLE public."SitesWithSeriesCatalogXML" TO jbianchi;
GRANT SELECT ON TABLE public."SitesWithSeriesCatalogXML" TO sololectura;
GRANT SELECT ON TABLE public."SitesWithSeriesCatalogXML" TO actualiza;


--
-- Name: SEQUENCE "Sites_SiteID_seq"; Type: ACL; Schema: public; Owner: jbianchi
--

REVOKE ALL ON SEQUENCE public."Sites_SiteID_seq" FROM PUBLIC;
REVOKE ALL ON SEQUENCE public."Sites_SiteID_seq" FROM jbianchi;
GRANT ALL ON SEQUENCE public."Sites_SiteID_seq" TO jbianchi;
GRANT ALL ON SEQUENCE public."Sites_SiteID_seq" TO actualiza;


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
-- Name: TABLE "ValueTypeCV"; Type: ACL; Schema: public; Owner: jbianchi
--

REVOKE ALL ON TABLE public."ValueTypeCV" FROM PUBLIC;
REVOKE ALL ON TABLE public."ValueTypeCV" FROM jbianchi;
GRANT ALL ON TABLE public."ValueTypeCV" TO jbianchi;
GRANT SELECT ON TABLE public."ValueTypeCV" TO sololectura;
GRANT SELECT ON TABLE public."ValueTypeCV" TO actualiza;


--
-- Name: TABLE "ValuesXML"; Type: ACL; Schema: public; Owner: jbianchi
--

REVOKE ALL ON TABLE public."ValuesXML" FROM PUBLIC;
REVOKE ALL ON TABLE public."ValuesXML" FROM jbianchi;
GRANT ALL ON TABLE public."ValuesXML" TO jbianchi;
GRANT SELECT ON TABLE public."ValuesXML" TO sololectura;
GRANT SELECT ON TABLE public."ValuesXML" TO actualiza;


--
-- Name: TABLE "VariableNameCV"; Type: ACL; Schema: public; Owner: jbianchi
--

REVOKE ALL ON TABLE public."VariableNameCV" FROM PUBLIC;
REVOKE ALL ON TABLE public."VariableNameCV" FROM jbianchi;
GRANT ALL ON TABLE public."VariableNameCV" TO jbianchi;
GRANT SELECT ON TABLE public."VariableNameCV" TO sololectura;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public."VariableNameCV" TO actualiza;


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
-- PostgreSQL database dump complete
--

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
-- Name: FeatureTypeCV_FeatureTypeID_seq; Type: SEQUENCE SET; Schema: public; Owner: jbianchi
--

SELECT pg_catalog.setval('public."FeatureTypeCV_FeatureTypeID_seq"', 1, false);


--
-- PostgreSQL database dump complete
--

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
Surface water	Observation or sample of surface water such as a stream, river, lake, pond, reservoir, ocean, etc.
\.


--
-- PostgreSQL database dump complete
--

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
-- PostgreSQL database dump complete
--

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
-- PostgreSQL database dump complete
--

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
-- PostgreSQL database dump complete
--

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
Vazao	portuguese: discharge
Nivel	portuguese: gage height
Chuva	portuguese: precipitation
Water Level	sinonym: gage height
altura	spanish: gage height
caudal	spanish: discharge
precipitacion	spanish: precipitation
Qefluente	spanish: reservoir outflow
Qafluente	spanish: reservoir inflow
Qvertido	spanish: reservoir water release through spillways
Vutil	spanish: reservoir water volume
precip_diaria_met	spanish: precipitation daily 12Z
Qtransfer	spanish: reservoir water transfer
precip_inst	spanish: precipitation incremental
\.


--
-- PostgreSQL database dump complete
--

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

