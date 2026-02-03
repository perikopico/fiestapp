-- Migración 034: Trigger para extraer automáticamente lat/lng desde maps_url
-- Este trigger extrae coordenadas desde maps_url cuando se inserta o actualiza un evento
-- y las coordenadas no están ya definidas

-- Asegurar que las funciones de extracción existen (por si no se ejecutó la migración 033)
CREATE OR REPLACE FUNCTION extract_lat_from_maps_url(url text)
RETURNS double precision AS $$
DECLARE
  match_result text[];
BEGIN
  IF url IS NULL THEN
    RETURN NULL;
  END IF;
  
  -- Formato 1: query=LAT,LNG
  IF url ~ 'query=(-?\d+\.?\d*),(-?\d+\.?\d*)' THEN
    match_result := regexp_match(url, 'query=(-?\d+\.?\d*),(-?\d+\.?\d*)');
    IF match_result IS NOT NULL AND array_length(match_result, 1) >= 2 THEN
      RETURN match_result[1]::double precision;
    END IF;
  END IF;
  
  -- Formato 2: @LAT,LNG (más común en URLs de Google Maps)
  IF url ~ '@(-?\d+\.?\d*),(-?\d+\.?\d*)' THEN
    match_result := regexp_match(url, '@(-?\d+\.?\d*),(-?\d+\.?\d*)');
    IF match_result IS NOT NULL AND array_length(match_result, 1) >= 2 THEN
      RETURN match_result[1]::double precision;
    END IF;
  END IF;
  
  -- Formato 3: ?q=LAT,LNG
  IF url ~ '[?&]q=(-?\d+\.?\d*),(-?\d+\.?\d*)' THEN
    match_result := regexp_match(url, '[?&]q=(-?\d+\.?\d*),(-?\d+\.?\d*)');
    IF match_result IS NOT NULL AND array_length(match_result, 1) >= 2 THEN
      RETURN match_result[1]::double precision;
    END IF;
  END IF;
  
  RETURN NULL;
END;
$$ LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION extract_lng_from_maps_url(url text)
RETURNS double precision AS $$
DECLARE
  match_result text[];
BEGIN
  IF url IS NULL THEN
    RETURN NULL;
  END IF;
  
  -- Formato 1: query=LAT,LNG
  IF url ~ 'query=(-?\d+\.?\d*),(-?\d+\.?\d*)' THEN
    match_result := regexp_match(url, 'query=(-?\d+\.?\d*),(-?\d+\.?\d*)');
    IF match_result IS NOT NULL AND array_length(match_result, 1) >= 2 THEN
      RETURN match_result[2]::double precision;
    END IF;
  END IF;
  
  -- Formato 2: @LAT,LNG (más común en URLs de Google Maps)
  IF url ~ '@(-?\d+\.?\d*),(-?\d+\.?\d*)' THEN
    match_result := regexp_match(url, '@(-?\d+\.?\d*),(-?\d+\.?\d*)');
    IF match_result IS NOT NULL AND array_length(match_result, 1) >= 2 THEN
      RETURN match_result[2]::double precision;
    END IF;
  END IF;
  
  -- Formato 3: ?q=LAT,LNG
  IF url ~ '[?&]q=(-?\d+\.?\d*),(-?\d+\.?\d*)' THEN
    match_result := regexp_match(url, '[?&]q=(-?\d+\.?\d*),(-?\d+\.?\d*)');
    IF match_result IS NOT NULL AND array_length(match_result, 1) >= 2 THEN
      RETURN match_result[2]::double precision;
    END IF;
  END IF;
  
  RETURN NULL;
END;
$$ LANGUAGE plpgsql IMMUTABLE;

-- Función del trigger que extrae coordenadas desde maps_url
CREATE OR REPLACE FUNCTION auto_extract_coords_from_maps_url()
RETURNS TRIGGER AS $$
DECLARE
  extracted_lat double precision;
  extracted_lng double precision;
BEGIN
  -- Solo extraer si:
  -- 1. Hay un maps_url
  -- 2. Y NO hay coordenadas ya definidas (lat/lng son NULL)
  -- 3. Y el maps_url contiene coordenadas extraíbles
  
  IF NEW.maps_url IS NOT NULL 
     AND (NEW.lat IS NULL OR NEW.lng IS NULL) THEN
    
    extracted_lat := extract_lat_from_maps_url(NEW.maps_url);
    extracted_lng := extract_lng_from_maps_url(NEW.maps_url);
    
    -- Solo actualizar si se extrajeron coordenadas válidas
    IF extracted_lat IS NOT NULL 
       AND extracted_lng IS NOT NULL
       AND extracted_lat BETWEEN -90 AND 90
       AND extracted_lng BETWEEN -180 AND 180 THEN
      
      -- Solo actualizar si no hay coordenadas ya definidas
      IF NEW.lat IS NULL THEN
        NEW.lat := extracted_lat;
      END IF;
      
      IF NEW.lng IS NULL THEN
        NEW.lng := extracted_lng;
      END IF;
    END IF;
  END IF;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Crear el trigger (eliminar si existe primero)
DROP TRIGGER IF EXISTS trigger_auto_extract_coords_from_maps_url ON public.events;

CREATE TRIGGER trigger_auto_extract_coords_from_maps_url
  BEFORE INSERT OR UPDATE ON public.events
  FOR EACH ROW
  EXECUTE FUNCTION auto_extract_coords_from_maps_url();

COMMENT ON FUNCTION auto_extract_coords_from_maps_url() IS 
  'Trigger que extrae automáticamente lat/lng desde maps_url cuando se inserta o actualiza un evento';

COMMENT ON TRIGGER trigger_auto_extract_coords_from_maps_url ON public.events IS 
  'Extrae automáticamente coordenadas desde maps_url si no están ya definidas';
