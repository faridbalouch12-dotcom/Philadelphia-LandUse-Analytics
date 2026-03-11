-- Spatial types and functions (geometry, geography, ST_* functions, spatial indexes)
-- Required for all district boundary, permit location, and zoning geometry work
CREATE EXTENSION IF NOT EXISTS postgis;

-- Parses raw address strings into structured components (street number, name, type, city, state)
-- Required by address_standardizer_data_us; also used as a fallback to geocode permit addresses to points
CREATE EXTENSION IF NOT EXISTS address_standardizer;

-- US-specific address standardization dataset used by address_standardizer
CREATE EXTENSION IF NOT EXISTS address_standardizer_data_us;
