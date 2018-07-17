CREATE OR REPLACE FUNCTION trg_geom_default()
  RETURNS trigger AS
$func$
BEGIN

NEW."Geometry" := st_setsrid(st_point(NEW."Longitude",NEW."Latitude"),4326);

RETURN NEW;

END
$func$ LANGUAGE plpgsql;

CREATE TRIGGER geom_default
BEFORE INSERT ON "Sites"
FOR EACH ROW
WHEN (NEW."Geometry" IS NULL AND NEW."Longitude" IS NOT NULL AND NEW."Latitude" IS NOT NULL)
EXECUTE PROCEDURE trg_geom_default();
