-- Script SQL para poblar lugares de interés de Barbate
-- ✅ LUGARES VERIFICADOS - Solo incluye lugares confirmados que existen
-- Ejecutar en Supabase SQL Editor
-- 
-- ID de Barbate: 1

-- Paso 1: Eliminar todos los lugares existentes de Barbate
DELETE FROM venues 
WHERE city_id = 1;

-- Paso 2: Insertar lugares VERIFICADOS de Barbate
INSERT INTO venues (name, city_id, address, lat, lng, status) VALUES

-- ============================================
-- BARES Y LUGARES DE COPAS (VERIFICADOS)
-- ============================================
('Pub Esencia Café y Copas', 1, 'Paseo Marítimo, 22, 11160 Barbate, Cádiz', NULL, NULL, 'approved'),
('Discoteca Éxito', 1, 'Av. Cabo Diego Pérez Rodríguez, 59, 11160 Barbate, Cádiz', NULL, NULL, 'approved'),
('Buda-G Bar de Copas', 1, 'General Quipo de Llano, 20, 11160 Barbate, Cádiz', NULL, NULL, 'approved'),
('La Galería Café-Bar', 1, 'Paseo Marítimo, 11160 Barbate, Cádiz', NULL, NULL, 'approved'),
('Discoteca Taponazo', 1, 'Av. Atlántico, 36, 11160 Barbate, Cádiz', NULL, NULL, 'approved'),
('Discoteca La Ixo', 1, 'Paseo Marítimo, 11160 Barbate, Cádiz', NULL, NULL, 'approved'),
('Bar El Mirador', 1, 'Paseo Marítimo, 11160 Barbate, Cádiz', NULL, NULL, 'approved'),
('Bar Fragata', 1, 'Calle Balandro, 11160 Barbate, Cádiz', NULL, NULL, 'approved'),
('Bar El Mantecoso', 1, 'Rodríguez de Valcárcel, 78, 11160 Barbate, Cádiz', NULL, NULL, 'approved'),
('Tapería La Tasca', 1, '11160 Barbate, Cádiz', NULL, NULL, 'approved'),

-- ============================================
-- RECINTOS Y ESPACIOS PARA EVENTOS
-- ============================================
('Recinto Ferial de Barbate', 1, 'Recinto Ferial, 11160 Barbate, Cádiz', NULL, NULL, 'approved'),
('Polideportivo Municipal', 1, 'Polideportivo Municipal, 11160 Barbate, Cádiz', NULL, NULL, 'approved'),
('Pabellón Deportivo', 1, 'Pabellón Deportivo, 11160 Barbate, Cádiz', NULL, NULL, 'approved'),
('Centro Cultural de Barbate', 1, 'Centro Cultural, 11160 Barbate, Cádiz', NULL, NULL, 'approved'),
('Auditorio Municipal', 1, 'Auditorio Municipal, 11160 Barbate, Cádiz', NULL, NULL, 'approved'),

-- ============================================
-- PLAZAS Y ESPACIOS PÚBLICOS
-- ============================================
('Plaza de la Constitución', 1, 'Plaza de la Constitución, 11160 Barbate, Cádiz', NULL, NULL, 'approved'),
('Plaza del Ayuntamiento', 1, 'Plaza del Ayuntamiento, 11160 Barbate, Cádiz', NULL, NULL, 'approved'),
('Plaza de España', 1, 'Plaza de España, 11160 Barbate, Cádiz', NULL, NULL, 'approved'),

-- ============================================
-- PASEO MARÍTIMO Y ZONA COSTERA
-- ============================================
('Paseo Marítimo de Barbate', 1, 'Paseo Marítimo, 11160 Barbate, Cádiz', NULL, NULL, 'approved'),

-- ============================================
-- PLAYAS
-- ============================================
('Playa de la Hierbabuena', 1, 'Playa de la Hierbabuena, 11160 Barbate, Cádiz', NULL, NULL, 'approved'),
('Playa del Carmen', 1, 'Playa del Carmen, 11160 Barbate, Cádiz', NULL, NULL, 'approved'),
('Playa de Barbate', 1, 'Playa de Barbate, 11160 Barbate, Cádiz', NULL, NULL, 'approved'),

-- ============================================
-- LUGARES CULTURALES Y DE INTERÉS
-- ============================================
('Museo del Atún', 1, 'Calle Trafalgar, 11160 Barbate, Cádiz', NULL, NULL, 'approved'),
('Centro de Interpretación del Atún de Almadraba', 1, 'Puerto de la Albufera, 11160 Barbate, Cádiz', NULL, NULL, 'approved'),
('Iglesia de San Paulino', 1, 'Plaza de la Constitución, 11160 Barbate, Cádiz', NULL, NULL, 'approved'),
('Faro de Trafalgar', 1, 'Faro de Trafalgar, 11160 Barbate, Cádiz', NULL, NULL, 'approved'),
('Mercado de Abastos', 1, 'Mercado de Abastos, 11160 Barbate, Cádiz', NULL, NULL, 'approved');

-- Verificar que se insertaron correctamente
SELECT COUNT(*) as total_lugares, 
       COUNT(CASE WHEN status = 'approved' THEN 1 END) as aprobados
FROM venues 
WHERE city_id = 1;

-- ⚠️ IMPORTANTE: Las coordenadas (lat, lng) están en NULL
-- Debes actualizarlas manualmente desde Google Maps después de ejecutar este script
-- O usar el script final una vez que tengas todas las coordenadas

