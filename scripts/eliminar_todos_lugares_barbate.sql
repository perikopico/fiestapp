-- Script SQL para ELIMINAR todos los lugares de Barbate
-- ⚠️ ADVERTENCIA: Este script eliminará TODOS los lugares de Barbate (city_id = 1)
-- Ejecutar en Supabase SQL Editor

-- Eliminar todos los lugares de Barbate
DELETE FROM venues 
WHERE city_id = 1;

-- Verificar que se eliminaron
SELECT COUNT(*) as lugares_restantes
FROM venues 
WHERE city_id = 1;
-- Debe mostrar: 0

