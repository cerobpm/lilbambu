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
-- Name: FeatureTypes; Type: TABLE; Schema: public; Owner: jbianchi
--

CREATE TABLE public."FeatureTypes" (
    "FeatureTypeID" integer NOT NULL,
    "FeatureTypeName" character varying NOT NULL,
    "Description" character varying
);


ALTER TABLE public."FeatureTypes" OWNER TO jbianchi;

--
-- Name: FeatureTypes_FeatureTypeID_seq; Type: SEQUENCE; Schema: public; Owner: jbianchi
--

CREATE SEQUENCE public."FeatureTypes_FeatureTypeID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."FeatureTypes_FeatureTypeID_seq" OWNER TO jbianchi;

--
-- Name: FeatureTypes_FeatureTypeID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jbianchi
--

ALTER SEQUENCE public."FeatureTypes_FeatureTypeID_seq" OWNED BY public."FeatureTypes"."FeatureTypeID";


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
    "MetadataID" integer DEFAULT 0 NOT NULL
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
    XMLELEMENT(NAME "sr:variable", XMLELEMENT(NAME "variableCode", XMLATTRIBUTES(true AS "default", "Variables"."VariableID" AS "variableID"), "Variables"."VariableCode"), XMLELEMENT(NAME "variableName", "Variables"."VariableName"), XMLELEMENT(NAME "variableDescription", ''), XMLELEMENT(NAME "valueType", "Variables"."ValueType"), "UnitsXML"."UnitsXML") AS "VariableInfoXML"
   FROM public."Variables",
    public."UnitsXML"
  WHERE ("Variables"."VariableUnitsID" = "UnitsXML"."UnitsID");


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
-- Name: SitesWithSeriesCatalogXML; Type: VIEW; Schema: public; Owner: jbianchi
--

CREATE VIEW public."SitesWithSeriesCatalogXML" AS
 WITH siteseriesagg AS (
         SELECT "Sites"."SiteID",
            xmlagg("SeriesCatalogXML"."SeriesCatalogXML") AS "seriesCatalog"
           FROM public."Sites",
            public."SeriesCatalogXML",
            public."SeriesCatalogView"
          WHERE (("Sites"."SiteID" = "SeriesCatalogView"."SiteID") AND ("SeriesCatalogView"."SeriesID" = "SeriesCatalogXML"."SeriesID"))
          GROUP BY "Sites"."SiteID"
        )
 SELECT "SiteInfoXML"."SiteID",
    XMLELEMENT(NAME site, "SiteInfoXML"."SiteInfoXML", siteseriesagg."seriesCatalog") AS site
   FROM public."SiteInfoXML",
    siteseriesagg
  WHERE ("SiteInfoXML"."SiteID" = siteseriesagg."SiteID")
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

ALTER TABLE ONLY public."FeatureTypes" ALTER COLUMN "FeatureTypeID" SET DEFAULT nextval('public."FeatureTypes_FeatureTypeID_seq"'::regclass);


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
-- Name: FeatureTypes_FeatureTypeName_key; Type: CONSTRAINT; Schema: public; Owner: jbianchi
--

ALTER TABLE ONLY public."FeatureTypes"
    ADD CONSTRAINT "FeatureTypes_FeatureTypeName_key" UNIQUE ("FeatureTypeName");


--
-- Name: FeatureTypes_pkey; Type: CONSTRAINT; Schema: public; Owner: jbianchi
--

ALTER TABLE ONLY public."FeatureTypes"
    ADD CONSTRAINT "FeatureTypes_pkey" PRIMARY KEY ("FeatureTypeID");


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
    ADD CONSTRAINT "Sites_FeatureType_fkey" FOREIGN KEY ("FeatureType") REFERENCES public."FeatureTypes"("FeatureTypeName");


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

