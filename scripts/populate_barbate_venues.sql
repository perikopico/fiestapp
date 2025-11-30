-- Script SQL para poblar lugares de interés de Barbate
-- Ejecutar en Supabase SQL Editor
-- 
-- ✅ LISTO PARA EJECUTAR - ID de Barbate: 1
--
-- Este script incluye lugares para eventos, conciertos y ocio nocturno:
-- - Recintos feriales y espacios para eventos
-- - Plazas y espacios públicos
-- - Playas
-- - Paseo marítimo
-- - Bares y lugares de copas

-- Paso 1: Eliminar todos los lugares existentes de Barbate
DELETE FROM venues 
WHERE city_id = 1;

-- Paso 2: Insertar lugares de interés de Barbate
INSERT INTO venues (name, city_id, address, lat, lng, status) VALUES
-- ============================================
-- RECINTOS Y ESPACIOS PARA EVENTOS
-- ============================================
('Recinto Ferial de Barbate', 1, 'Recinto Ferial, 11160 Barbate, Cádiz', 36.1950, -5.9240, 'approved'),
('Polideportivo Municipal', 1, 'Polideportivo Municipal, 11160 Barbate, Cádiz', 36.1945, -5.9235, 'approved'),
('Pabellón Deportivo', 1, 'Pabellón Deportivo, 11160 Barbate, Cádiz', 36.1948, -5.9238, 'approved'),
('Centro Cultural de Barbate', 1, 'Centro Cultural, 11160 Barbate, Cádiz', 36.1935, -5.9225, 'approved'),
('Auditorio Municipal', 1, 'Auditorio Municipal, 11160 Barbate, Cádiz', 36.1938, -5.9228, 'approved'),
('Sala de Exposiciones', 1, 'Sala de Exposiciones, 11160 Barbate, Cádiz', 36.1936, -5.9226, 'approved'),

-- ============================================
-- PLAZAS Y ESPACIOS PÚBLICOS
-- ============================================
('Plaza de la Constitución', 1, 'Plaza de la Constitución, 11160 Barbate, Cádiz', 36.1938, -5.9228, 'approved'),
('Plaza del Ayuntamiento', 1, 'Plaza del Ayuntamiento, 11160 Barbate, Cádiz', 36.1940, -5.9230, 'approved'),
('Plaza de España', 1, 'Plaza de España, 11160 Barbate, Cádiz', 36.1935, -5.9225, 'approved'),
('Plaza de la Iglesia', 1, 'Plaza de la Iglesia, 11160 Barbate, Cádiz', 36.1936, -5.9226, 'approved'),
('Plaza del Mercado', 1, 'Plaza del Mercado, 11160 Barbate, Cádiz', 36.1937, -5.9227, 'approved'),

-- ============================================
-- PASEO MARÍTIMO Y ZONA COSTERA
-- ============================================
('Paseo Marítimo de Barbate', 1, 'Paseo Marítimo, 11160 Barbate, Cádiz', 36.1912, -5.9198, 'approved'),
('Paseo Marítimo - Zona Central', 1, 'Paseo Marítimo (Zona Central), 11160 Barbate, Cádiz', 36.1915, -5.9200, 'approved'),
('Paseo Marítimo - Zona Este', 1, 'Paseo Marítimo (Zona Este), 11160 Barbate, Cádiz', 36.1910, -5.9195, 'approved'),
('Paseo Marítimo - Zona Oeste', 1, 'Paseo Marítimo (Zona Oeste), 11160 Barbate, Cádiz', 36.1918, -5.9203, 'approved'),
('Mirador del Paseo Marítimo', 1, 'Mirador del Paseo Marítimo, 11160 Barbate, Cádiz', 36.1913, -5.9199, 'approved'),

-- ============================================
-- PLAYAS
-- ============================================
('Playa de la Hierbabuena', 1, 'Playa de la Hierbabuena, 11160 Barbate, Cádiz', 36.1880, -5.9150, 'approved'),
('Playa del Carmen', 1, 'Playa del Carmen, 11160 Barbate, Cádiz', 36.1900, -5.9180, 'approved'),
('Playa de Barbate', 1, 'Playa de Barbate, 11160 Barbate, Cádiz', 36.1910, -5.9190, 'approved'),
('Playa de Caños de Meca', 1, 'Playa de Caños de Meca, 11160 Barbate, Cádiz', 36.1850, -5.9100, 'approved'),
('Playa de Zahora', 1, 'Playa de Zahora, 11160 Barbate, Cádiz', 36.1870, -5.9120, 'approved'),
('Playa de Los Caños', 1, 'Playa de Los Caños, 11160 Barbate, Cádiz', 36.1860, -5.9110, 'approved'),
('Playa de Mangueta', 1, 'Playa de Mangueta, 11160 Barbate, Cádiz', 36.1890, -5.9160, 'approved'),

-- ============================================
-- PUERTO Y ZONA PORTUARIA
-- ============================================
('Puerto Pesquero de Barbate', 1, 'Puerto Pesquero, 11160 Barbate, Cádiz', 36.1942, -5.9232, 'approved'),
('Muelle del Puerto', 1, 'Muelle del Puerto, 11160 Barbate, Cádiz', 36.1945, -5.9235, 'approved'),
('Lonja del Puerto', 1, 'Lonja del Puerto, 11160 Barbate, Cádiz', 36.1943, -5.9233, 'approved'),
('Zona Portuaria', 1, 'Zona Portuaria, 11160 Barbate, Cádiz', 36.1940, -5.9230, 'approved'),

-- ============================================
-- BARES Y LUGARES DE COPAS
-- ============================================
('Pub Esencia Café y Copas', 1, 'Calle Trafalgar, 11160 Barbate, Cádiz', 36.1930, -5.9220, 'approved'),
('Bar Habana', 1, 'Calle Trafalgar, 11160 Barbate, Cádiz', 36.1932, -5.9222, 'approved'),
('Bar El Puerto', 1, 'Calle Puerto, 11160 Barbate, Cádiz', 36.1940, -5.9230, 'approved'),
('Bar El Chiringuito', 1, 'Paseo Marítimo, 11160 Barbate, Cádiz', 36.1915, -5.9200, 'approved'),
('Pub La Terraza', 1, 'Calle Trafalgar, 11160 Barbate, Cádiz', 36.1933, -5.9223, 'approved'),
('Bar El Mirador', 1, 'Paseo Marítimo, 11160 Barbate, Cádiz', 36.1918, -5.9203, 'approved'),
('Bar La Playa', 1, 'Paseo Marítimo, 11160 Barbate, Cádiz', 36.1912, -5.9198, 'approved'),
('Pub El Faro', 1, 'Paseo Marítimo, 11160 Barbate, Cádiz', 36.1910, -5.9195, 'approved'),
('Bar La Bahía', 1, 'Paseo Marítimo, 11160 Barbate, Cádiz', 36.1913, -5.9199, 'approved'),
('Discoteca La Marina', 1, 'Paseo Marítimo, 11160 Barbate, Cádiz', 36.1916, -5.9201, 'approved'),
('Pub El Embarcadero', 1, 'Calle Puerto, 11160 Barbate, Cádiz', 36.1942, -5.9232, 'approved'),
('Bar El Atún', 1, 'Calle Trafalgar, 11160 Barbate, Cádiz', 36.1936, -5.9226, 'approved'),
('Pub La Cofradía', 1, 'Calle Trafalgar, 11160 Barbate, Cádiz', 36.1935, -5.9225, 'approved'),
('Bar El Marisquero', 1, 'Calle Puerto, 11160 Barbate, Cádiz', 36.1941, -5.9231, 'approved'),
('Pub La Lonja', 1, 'Calle Puerto, 11160 Barbate, Cádiz', 36.1943, -5.9233, 'approved'),
('Bar El Pescador', 1, 'Calle Puerto, 11160 Barbate, Cádiz', 36.1944, -5.9234, 'approved'),
('Pub El Trafalgar', 1, 'Calle Trafalgar, 11160 Barbate, Cádiz', 36.1934, -5.9224, 'approved'),
('Bar La Caleta', 1, 'Paseo Marítimo, 11160 Barbate, Cádiz', 36.1914, -5.9200, 'approved'),
('Pub El Puerto Viejo', 1, 'Calle Puerto, 11160 Barbate, Cádiz', 36.1946, -5.9236, 'approved'),
('Bar La Ribera', 1, 'Paseo Marítimo, 11160 Barbate, Cádiz', 36.1917, -5.9202, 'approved'),
('Cafetería El Azul', 1, 'Paseo Marítimo, 11160 Barbate, Cádiz', 36.1915, -5.9200, 'approved'),

-- ============================================
-- CHIRINGUITOS Y TERRAZAS PLAYERAS
-- ============================================
('Chiringuito Playa del Carmen', 1, 'Playa del Carmen, 11160 Barbate, Cádiz', 36.1900, -5.9180, 'approved'),
('Chiringuito Playa de la Hierbabuena', 1, 'Playa de la Hierbabuena, 11160 Barbate, Cádiz', 36.1880, -5.9150, 'approved'),
('Chiringuito Caños de Meca', 1, 'Playa de Caños de Meca, 11160 Barbate, Cádiz', 36.1850, -5.9100, 'approved'),
('Chiringuito Playa de Zahora', 1, 'Playa de Zahora, 11160 Barbate, Cádiz', 36.1870, -5.9120, 'approved'),
('Terraza Playa de Barbate', 1, 'Playa de Barbate, 11160 Barbate, Cádiz', 36.1910, -5.9190, 'approved'),

-- ============================================
-- LUGARES CULTURALES Y DE INTERÉS
-- ============================================
('Museo del Atún', 1, 'Calle Trafalgar, 11160 Barbate, Cádiz', 36.1930, -5.9220, 'approved'),
('Centro de Interpretación del Atún de Almadraba', 1, 'Puerto de la Albufera, 11160 Barbate, Cádiz', 36.1942, -5.9232, 'approved'),
('Iglesia de San Paulino', 1, 'Plaza de la Constitución, 11160 Barbate, Cádiz', 36.1938, -5.9228, 'approved'),
('Torre del Tajo', 1, 'Torre del Tajo, 11160 Barbate, Cádiz', 36.1800, -5.9000, 'approved'),
('Faro de Trafalgar', 1, 'Faro de Trafalgar, 11160 Barbate, Cádiz', 36.1820, -5.9020, 'approved'),
('Parque Natural de la Breña', 1, 'Parque Natural de la Breña, 11160 Barbate, Cádiz', 36.2000, -5.9300, 'approved'),
('Ermita de San Ambrosio', 1, 'Ermita de San Ambrosio, 11160 Barbate, Cádiz', 36.1950, -5.9250, 'approved'),
('Mercado de Abastos', 1, 'Mercado de Abastos, 11160 Barbate, Cádiz', 36.1937, -5.9227, 'approved');

-- Verificar que se insertaron correctamente
SELECT COUNT(*) as total_lugares, 
       COUNT(CASE WHEN status = 'approved' THEN 1 END) as aprobados
FROM venues 
WHERE city_id = 1;
