-- ============================================
-- Migración 027: Actualizar precios desde JSON original
-- ============================================
-- Este script actualiza el campo price de los eventos
-- basándose en el JSON original final-definitivo.txt
-- ============================================

-- XIV Trail Urbano Villaluenga
UPDATE public.events
SET price = '18€'
WHERE title = 'XIV Trail Urbano Villaluenga' AND starts_at::date = '2026-01-11'::date;

-- Fútbol: Xerez DFC vs La Unión Atlético
UPDATE public.events
SET price = 'Desde 10€'
WHERE title = 'Fútbol: Xerez DFC vs La Unión Atlético' AND starts_at::date = '2026-01-11'::date;

-- Juan Dávila: La Capital del Pecado 2.0
UPDATE public.events
SET price = 'Desde 36€'
WHERE title = 'Juan Dávila: La Capital del Pecado 2.0' AND starts_at::date = '2026-01-11'::date;

-- COAC 2026: Preliminares (Sesión 1)
UPDATE public.events
SET price = 'De pago'
WHERE title = 'COAC 2026: Preliminares (Sesión 1)' AND starts_at::date = '2026-01-11'::date;

-- COAC 2026: Preliminares (Sesión 2)
UPDATE public.events
SET price = 'De pago'
WHERE title = 'COAC 2026: Preliminares (Sesión 2)' AND starts_at::date = '2026-01-12'::date;

-- COAC 2026: Preliminares (Sesión 3)
UPDATE public.events
SET price = 'De pago'
WHERE title = 'COAC 2026: Preliminares (Sesión 3)' AND starts_at::date = '2026-01-13'::date;

-- COAC 2026: Preliminares (Sesión 4)
UPDATE public.events
SET price = 'De pago'
WHERE title = 'COAC 2026: Preliminares (Sesión 4)' AND starts_at::date = '2026-01-14'::date;

-- Andalucía Pre-Sunshine Tour (Día 1)
UPDATE public.events
SET price = 'Gratis'
WHERE title = 'Andalucía Pre-Sunshine Tour (Día 1)' AND starts_at::date = '2026-01-15'::date;

-- COAC 2026: Preliminares (Sesión 5)
UPDATE public.events
SET price = 'De pago'
WHERE title = 'COAC 2026: Preliminares (Sesión 5)' AND starts_at::date = '2026-01-15'::date;

-- Andalucía Pre-Sunshine Tour (Día 2)
UPDATE public.events
SET price = 'Gratis'
WHERE title = 'Andalucía Pre-Sunshine Tour (Día 2)' AND starts_at::date = '2026-01-16'::date;

-- COAC 2026: Preliminares (Sesión 6)
UPDATE public.events
SET price = 'De pago'
WHERE title = 'COAC 2026: Preliminares (Sesión 6)' AND starts_at::date = '2026-01-16'::date;

-- Concierto: Syrah Morrison
UPDATE public.events
SET price = '12€'
WHERE title = 'Concierto: Syrah Morrison' AND starts_at::date = '2026-01-16'::date;

-- Fiesta Universitaria Welcome 2026
UPDATE public.events
SET price = '15€'
WHERE title = 'Fiesta Universitaria Welcome 2026' AND starts_at::date = '2026-01-16'::date;

-- Andalucía Pre-Sunshine Tour (Día 3)
UPDATE public.events
SET price = 'Gratis'
WHERE title = 'Andalucía Pre-Sunshine Tour (Día 3)' AND starts_at::date = '2026-01-17'::date;

-- Sábados de Cuento
UPDATE public.events
SET price = 'Gratis'
WHERE title = 'Sábados de Cuento' AND starts_at::date = '2026-01-17'::date;

-- Futsal: CD Virgili Cádiz vs CD Alcalá
UPDATE public.events
SET price = '5€'
WHERE title = 'Futsal: CD Virgili Cádiz vs CD Alcalá' AND starts_at::date = '2026-01-17'::date;

-- COAC 2026: Preliminares (Sesión 7)
UPDATE public.events
SET price = 'De pago'
WHERE title = 'COAC 2026: Preliminares (Sesión 7)' AND starts_at::date = '2026-01-17'::date;

-- Andalucía Pre-Sunshine Tour (Día 4 - GP)
UPDATE public.events
SET price = 'Gratis'
WHERE title = 'Andalucía Pre-Sunshine Tour (Día 4 - GP)' AND starts_at::date = '2026-01-18'::date;

-- Mercadillo de Sotogrande
UPDATE public.events
SET price = 'Gratis'
WHERE title = 'Mercadillo de Sotogrande' AND starts_at::date = '2026-01-18'::date;

-- COAC 2026: Preliminares (Sesión 8)
UPDATE public.events
SET price = 'De pago'
WHERE title = 'COAC 2026: Preliminares (Sesión 8)' AND starts_at::date = '2026-01-18'::date;

-- COAC 2026: Preliminares (Sesión 9)
UPDATE public.events
SET price = 'De pago'
WHERE title = 'COAC 2026: Preliminares (Sesión 9)' AND starts_at::date = '2026-01-19'::date;

-- COAC 2026: Preliminares (Sesión 10)
UPDATE public.events
SET price = 'De pago'
WHERE title = 'COAC 2026: Preliminares (Sesión 10)' AND starts_at::date = '2026-01-20'::date;

-- COAC 2026: Preliminares (Sesión 11)
UPDATE public.events
SET price = 'De pago'
WHERE title = 'COAC 2026: Preliminares (Sesión 11)' AND starts_at::date = '2026-01-21'::date;

-- Andalucía Pre-Sunshine Tour (Día 5)
UPDATE public.events
SET price = 'Gratis'
WHERE title = 'Andalucía Pre-Sunshine Tour (Día 5)' AND starts_at::date = '2026-01-22'::date;

-- COAC 2026: Preliminares (Sesión 12)
UPDATE public.events
SET price = 'De pago'
WHERE title = 'COAC 2026: Preliminares (Sesión 12)' AND starts_at::date = '2026-01-22'::date;

-- Andalucía Pre-Sunshine Tour (Día 6)
UPDATE public.events
SET price = 'Gratis'
WHERE title = 'Andalucía Pre-Sunshine Tour (Día 6)' AND starts_at::date = '2026-01-23'::date;

-- COAC 2026: Preliminares (Sesión 13)
UPDATE public.events
SET price = 'De pago'
WHERE title = 'COAC 2026: Preliminares (Sesión 13)' AND starts_at::date = '2026-01-23'::date;

-- GT Winter Series (Sábado)
UPDATE public.events
SET price = 'Gratis (Grada X1)'
WHERE title = 'GT Winter Series (Sábado)' AND starts_at::date = '2026-01-24'::date;

-- Andalucía Pre-Sunshine Tour (Día 7)
UPDATE public.events
SET price = 'Gratis'
WHERE title = 'Andalucía Pre-Sunshine Tour (Día 7)' AND starts_at::date = '2026-01-24'::date;

-- COAC 2026: Preliminares (Sesión 14)
UPDATE public.events
SET price = 'De pago'
WHERE title = 'COAC 2026: Preliminares (Sesión 14)' AND starts_at::date = '2026-01-24'::date;

-- Fútbol: Cádiz CF vs Granada CF
UPDATE public.events
SET price = 'Desde 25€'
WHERE title = 'Fútbol: Cádiz CF vs Granada CF' AND starts_at::date = '2026-01-24'::date;

-- GT Winter Series (Carreras)
UPDATE public.events
SET price = 'Gratis (Grada X1)'
WHERE title = 'GT Winter Series (Carreras)' AND starts_at::date = '2026-01-25'::date;

-- Andalucía Pre-Sunshine Tour (Día 8 - GP)
UPDATE public.events
SET price = 'Gratis'
WHERE title = 'Andalucía Pre-Sunshine Tour (Día 8 - GP)' AND starts_at::date = '2026-01-25'::date;

-- XXXIX Ostionada Popular
UPDATE public.events
SET price = 'Gratis'
WHERE title = 'XXXIX Ostionada Popular' AND starts_at::date = '2026-01-25'::date;

-- COAC 2026: Preliminares (Sesión 15)
UPDATE public.events
SET price = 'De pago'
WHERE title = 'COAC 2026: Preliminares (Sesión 15)' AND starts_at::date = '2026-01-25'::date;

-- COAC 2026: Preliminares (Sesión 16)
UPDATE public.events
SET price = 'De pago'
WHERE title = 'COAC 2026: Preliminares (Sesión 16)' AND starts_at::date = '2026-01-26'::date;

-- COAC 2026: Preliminares (Día Final)
UPDATE public.events
SET price = 'De pago'
WHERE title = 'COAC 2026: Preliminares (Día Final)' AND starts_at::date = '2026-01-27'::date;

-- COAC 2026: Cuartos de Final (Día 1)
UPDATE public.events
SET price = 'De pago'
WHERE title = 'COAC 2026: Cuartos de Final (Día 1)' AND starts_at::date = '2026-01-30'::date;

-- Flamenco: Peña Buena Gente
UPDATE public.events
SET price = 'Donativo'
WHERE title = 'Flamenco: Peña Buena Gente' AND starts_at::date = '2026-01-30'::date;

-- IV Media Maratón Ciudad de Arcos
UPDATE public.events
SET price = '15€'
WHERE title = 'IV Media Maratón Ciudad de Arcos' AND starts_at::date = '2026-01-31'::date;

-- Pregón Infantil Carnaval 2026
UPDATE public.events
SET price = 'Gratis'
WHERE title = 'Pregón Infantil Carnaval 2026' AND starts_at::date = '2026-01-31'::date;

-- Futsal: Virgili Cádiz vs UD Alchoyano
UPDATE public.events
SET price = '5€'
WHERE title = 'Futsal: Virgili Cádiz vs UD Alchoyano' AND starts_at::date = '2026-01-31'::date;

-- COAC 2026: Cuartos de Final (Día 2)
UPDATE public.events
SET price = 'De pago'
WHERE title = 'COAC 2026: Cuartos de Final (Día 2)' AND starts_at::date = '2026-01-31'::date;

-- At. Sanluqueño vs Betis Deportivo
UPDATE public.events
SET price = '15€'
WHERE title = 'At. Sanluqueño vs Betis Deportivo' AND starts_at::date = '2026-02-01'::date;

-- XLIV Erizada Popular
UPDATE public.events
SET price = 'Gratis'
WHERE title = 'XLIV Erizada Popular' AND starts_at::date = '2026-02-01'::date;

-- COAC 2026: Cuartos de Final (Día 3)
UPDATE public.events
SET price = 'De pago'
WHERE title = 'COAC 2026: Cuartos de Final (Día 3)' AND starts_at::date = '2026-02-01'::date;

-- COAC 2026: Cuartos de Final (Día 4)
UPDATE public.events
SET price = 'De pago'
WHERE title = 'COAC 2026: Cuartos de Final (Día 4)' AND starts_at::date = '2026-02-02'::date;

-- Andalucía Sunshine Tour (Día 1)
UPDATE public.events
SET price = 'Gratis'
WHERE title = 'Andalucía Sunshine Tour (Día 1)' AND starts_at::date = '2026-02-03'::date;

-- COAC 2026: Cuartos de Final (Día 5)
UPDATE public.events
SET price = 'De pago'
WHERE title = 'COAC 2026: Cuartos de Final (Día 5)' AND starts_at::date = '2026-02-03'::date;

-- Andalucía Sunshine Tour (Día 2)
UPDATE public.events
SET price = 'Gratis'
WHERE title = 'Andalucía Sunshine Tour (Día 2)' AND starts_at::date = '2026-02-04'::date;

-- COAC 2026: Cuartos de Final (Día 6)
UPDATE public.events
SET price = 'De pago'
WHERE title = 'COAC 2026: Cuartos de Final (Día 6)' AND starts_at::date = '2026-02-04'::date;

-- Andalucía Sunshine Tour (Día 3)
UPDATE public.events
SET price = 'Gratis'
WHERE title = 'Andalucía Sunshine Tour (Día 3)' AND starts_at::date = '2026-02-05'::date;

-- COAC 2026: Cuartos de Final (Día Final)
UPDATE public.events
SET price = 'De pago'
WHERE title = 'COAC 2026: Cuartos de Final (Día Final)' AND starts_at::date = '2026-02-05'::date;

-- Andalucía Sunshine Tour (Día 4)
UPDATE public.events
SET price = 'Gratis'
WHERE title = 'Andalucía Sunshine Tour (Día 4)' AND starts_at::date = '2026-02-06'::date;

-- Teatro: Los Lunes al Sol
UPDATE public.events
SET price = '20€'
WHERE title = 'Teatro: Los Lunes al Sol' AND starts_at::date = '2026-02-06'::date;

-- Recital Peña Juanito Villar
UPDATE public.events
SET price = 'Gratis'
WHERE title = 'Recital Peña Juanito Villar' AND starts_at::date = '2026-02-06'::date;

-- Andalucía Sunshine Tour (Día 5)
UPDATE public.events
SET price = 'Gratis'
WHERE title = 'Andalucía Sunshine Tour (Día 5)' AND starts_at::date = '2026-02-07'::date;

-- XII Víboras Trail
UPDATE public.events
SET price = '35€'
WHERE title = 'XII Víboras Trail' AND starts_at::date = '2026-02-07'::date;

-- Pregón Carnaval de Arcos
UPDATE public.events
SET price = 'Gratis'
WHERE title = 'Pregón Carnaval de Arcos' AND starts_at::date = '2026-02-07'::date;

-- Andalucía Sunshine Tour (Día 6 - GP)
UPDATE public.events
SET price = 'Gratis'
WHERE title = 'Andalucía Sunshine Tour (Día 6 - GP)' AND starts_at::date = '2026-02-08'::date;

-- Teatro Títeres La Tía Norica
UPDATE public.events
SET price = '7€'
WHERE title = 'Teatro Títeres La Tía Norica' AND starts_at::date = '2026-02-08'::date;

-- I Chicharronada Popular
UPDATE public.events
SET price = 'Gratis'
WHERE title = 'I Chicharronada Popular' AND starts_at::date = '2026-02-08'::date;

-- Cádiz CF vs UD Almería
UPDATE public.events
SET price = 'Desde 20€'
WHERE title = 'Cádiz CF vs UD Almería' AND starts_at::date = '2026-02-08'::date;

-- Andalucía Sunshine Tour (Semana 2 - Día 1)
UPDATE public.events
SET price = 'Gratis'
WHERE title = 'Andalucía Sunshine Tour (Semana 2 - Día 1)' AND starts_at::date = '2026-02-10'::date;

-- Andalucía Sunshine Tour (Semana 2 - Día 2)
UPDATE public.events
SET price = 'Gratis'
WHERE title = 'Andalucía Sunshine Tour (Semana 2 - Día 2)' AND starts_at::date = '2026-02-11'::date;

-- Andalucía Sunshine Tour (Semana 2 - Día 3)
UPDATE public.events
SET price = 'Gratis'
WHERE title = 'Andalucía Sunshine Tour (Semana 2 - Día 3)' AND starts_at::date = '2026-02-12'::date;

-- Encendido Alumbrado Carnaval
UPDATE public.events
SET price = 'Gratis'
WHERE title = 'Encendido Alumbrado Carnaval' AND starts_at::date = '2026-02-12'::date;

-- Andalucía Sunshine Tour (Semana 2 - Día 4)
UPDATE public.events
SET price = 'Gratis'
WHERE title = 'Andalucía Sunshine Tour (Semana 2 - Día 4)' AND starts_at::date = '2026-02-13'::date;

-- Gran Final COAC 2026
UPDATE public.events
SET price = 'De pago'
WHERE title = 'Gran Final COAC 2026' AND starts_at::date = '2026-02-13'::date;

-- Andalucía Sunshine Tour (Semana 2 - Día 5)
UPDATE public.events
SET price = 'Gratis'
WHERE title = 'Andalucía Sunshine Tour (Semana 2 - Día 5)' AND starts_at::date = '2026-02-14'::date;

-- Mercado Agroecológico Toruños
UPDATE public.events
SET price = 'Gratis'
WHERE title = 'Mercado Agroecológico Toruños' AND starts_at::date = '2026-02-14'::date;

-- Pregón Manu Sánchez
UPDATE public.events
SET price = 'Gratis'
WHERE title = 'Pregón Manu Sánchez' AND starts_at::date = '2026-02-14'::date;

-- Andalucía Sunshine Tour (Semana 2 - GP)
UPDATE public.events
SET price = 'Gratis'
WHERE title = 'Andalucía Sunshine Tour (Semana 2 - GP)' AND starts_at::date = '2026-02-15'::date;

-- Carrusel de Coros (Mercado)
UPDATE public.events
SET price = 'Gratis'
WHERE title = 'Carrusel de Coros (Mercado)' AND starts_at::date = '2026-02-15'::date;

-- Gran Cabalgata Magna
UPDATE public.events
SET price = 'Gratis'
WHERE title = 'Gran Cabalgata Magna' AND starts_at::date = '2026-02-15'::date;

-- Carrusel de Coros (La Viña)
UPDATE public.events
SET price = 'Gratis'
WHERE title = 'Carrusel de Coros (La Viña)' AND starts_at::date = '2026-02-16'::date;

-- Andalucía Sunshine Tour (Semana 3 - Día 1)
UPDATE public.events
SET price = 'Gratis'
WHERE title = 'Andalucía Sunshine Tour (Semana 3 - Día 1)' AND starts_at::date = '2026-02-17'::date;

-- Andalucía Sunshine Tour (Semana 3 - Día 2)
UPDATE public.events
SET price = 'Gratis'
WHERE title = 'Andalucía Sunshine Tour (Semana 3 - Día 2)' AND starts_at::date = '2026-02-18'::date;

-- Andalucía Sunshine Tour (Semana 3 - Día 3)
UPDATE public.events
SET price = 'Gratis'
WHERE title = 'Andalucía Sunshine Tour (Semana 3 - Día 3)' AND starts_at::date = '2026-02-19'::date;

-- Conferencia Historia de Cádiz
UPDATE public.events
SET price = 'Gratis'
WHERE title = 'Conferencia Historia de Cádiz' AND starts_at::date = '2026-02-19'::date;

-- Andalucía Sunshine Tour (Semana 3 - Día 4)
UPDATE public.events
SET price = 'Gratis'
WHERE title = 'Andalucía Sunshine Tour (Semana 3 - Día 4)' AND starts_at::date = '2026-02-20'::date;

-- Inauguración Festival Jerez
UPDATE public.events
SET price = '25€'
WHERE title = 'Inauguración Festival Jerez' AND starts_at::date = '2026-02-20'::date;

-- Jerez Off Festival: Agujetas Chico
UPDATE public.events
SET price = '15€'
WHERE title = 'Jerez Off Festival: Agujetas Chico' AND starts_at::date = '2026-02-20'::date;

-- Concierto: José de los Camarones
UPDATE public.events
SET price = '20€'
WHERE title = 'Concierto: José de los Camarones' AND starts_at::date = '2026-02-21'::date;

-- Andalucía Sunshine Tour (Semana 3 - Día 5)
UPDATE public.events
SET price = 'Gratis'
WHERE title = 'Andalucía Sunshine Tour (Semana 3 - Día 5)' AND starts_at::date = '2026-02-21'::date;

-- Festival Jerez (Día 2)
UPDATE public.events
SET price = 'Varios'
WHERE title = 'Festival Jerez (Día 2)' AND starts_at::date = '2026-02-21'::date;

-- Cabalgata del Humor
UPDATE public.events
SET price = 'Gratis'
WHERE title = 'Cabalgata del Humor' AND starts_at::date = '2026-02-21'::date;

-- Andalucía Sunshine Tour (Semana 3 - GP)
UPDATE public.events
SET price = 'Gratis'
WHERE title = 'Andalucía Sunshine Tour (Semana 3 - GP)' AND starts_at::date = '2026-02-22'::date;

-- Cádiz CF vs Real Sociedad B
UPDATE public.events
SET price = '15€'
WHERE title = 'Cádiz CF vs Real Sociedad B' AND starts_at::date = '2026-02-22'::date;

-- Quema de la Bruja Piti
UPDATE public.events
SET price = 'Gratis'
WHERE title = 'Quema de la Bruja Piti' AND starts_at::date = '2026-02-22'::date;

-- Vía Crucis Hermandades
UPDATE public.events
SET price = 'Gratis'
WHERE title = 'Vía Crucis Hermandades' AND starts_at::date = '2026-02-23'::date;

-- Andalucía Sunshine Tour (Semana 4 - Día 1)
UPDATE public.events
SET price = 'Gratis'
WHERE title = 'Andalucía Sunshine Tour (Semana 4 - Día 1)' AND starts_at::date = '2026-02-24'::date;

-- Festival Jerez (Día 5)
UPDATE public.events
SET price = 'Varios'
WHERE title = 'Festival Jerez (Día 5)' AND starts_at::date = '2026-02-24'::date;

-- Andalucía Sunshine Tour (Semana 4 - Día 2)
UPDATE public.events
SET price = 'Gratis'
WHERE title = 'Andalucía Sunshine Tour (Semana 4 - Día 2)' AND starts_at::date = '2026-02-25'::date;

-- Andalucía Sunshine Tour (Semana 4 - Día 3)
UPDATE public.events
SET price = 'Gratis'
WHERE title = 'Andalucía Sunshine Tour (Semana 4 - Día 3)' AND starts_at::date = '2026-02-26'::date;

-- Andalucía Sunshine Tour (Semana 4 - Día 4)
UPDATE public.events
SET price = 'Gratis'
WHERE title = 'Andalucía Sunshine Tour (Semana 4 - Día 4)' AND starts_at::date = '2026-02-27'::date;

-- Concierto Orquesta Algeciras
UPDATE public.events
SET price = 'Invitación'
WHERE title = 'Concierto Orquesta Algeciras' AND starts_at::date = '2026-02-27'::date;

-- Andalucía Sunshine Tour (Semana 4 - GP Andalucía)
UPDATE public.events
SET price = 'Gratis'
WHERE title = 'Andalucía Sunshine Tour (Semana 4 - GP Andalucía)' AND starts_at::date = '2026-02-28'::date;

-- Día de Andalucía Provincial
UPDATE public.events
SET price = 'Gratis'
WHERE title = 'Día de Andalucía Provincial' AND starts_at::date = '2026-02-28'::date;

-- Festival Jerez (Día 9)
UPDATE public.events
SET price = 'Desde 20€'
WHERE title = 'Festival Jerez (Día 9)' AND starts_at::date = '2026-02-28'::date;

-- Fútbol Juvenil: Cádiz CF vs Arenas de Armilla
UPDATE public.events
SET price = 'Gratis'
WHERE title = 'Fútbol Juvenil: Cádiz CF vs Arenas de Armilla' AND starts_at::date = '2026-02-08'::date;

-- COAC 2026: Semifinales (Sesión 1)
UPDATE public.events
SET price = 'De pago'
WHERE title = 'COAC 2026: Semifinales (Sesión 1)' AND starts_at::date = '2026-02-08'::date;

-- COAC 2026: Semifinales (Sesión 2)
UPDATE public.events
SET price = 'De pago'
WHERE title = 'COAC 2026: Semifinales (Sesión 2)' AND starts_at::date = '2026-02-09'::date;

-- COAC 2026: Semifinales (Sesión 3)
UPDATE public.events
SET price = 'De pago'
WHERE title = 'COAC 2026: Semifinales (Sesión 3)' AND starts_at::date = '2026-02-10'::date;

-- COAC 2026: Semifinales (Día Final)
UPDATE public.events
SET price = 'De pago'
WHERE title = 'COAC 2026: Semifinales (Día Final)' AND starts_at::date = '2026-02-11'::date;

-- Ruta en Kayak: San Valentín en el Mar
UPDATE public.events
SET price = '25€'
WHERE title = 'Ruta en Kayak: San Valentín en el Mar' AND starts_at::date = '2026-02-14'::date;

-- Teatro: ''Se Alquila'' con Andoni Ferreño
UPDATE public.events
SET price = '18€'
WHERE title = 'Teatro: ''Se Alquila'' con Andoni Ferreño' AND starts_at::date = '2026-01-26'::date;

-- Fútbol Infantil: Cádiz CF ''A'' vs Real Betis
UPDATE public.events
SET price = 'Gratis'
WHERE title = 'Fútbol Infantil: Cádiz CF ''A'' vs Real Betis' AND starts_at::date = '2026-02-15'::date;

-- Sunshine Tour: Young Horses Week 2
UPDATE public.events
SET price = 'Gratis'
WHERE title = 'Sunshine Tour: Young Horses Week 2' AND starts_at::date = '2026-02-18'::date;

-- Sunshine Tour: CSI4* Week 2 (Día 1)
UPDATE public.events
SET price = 'Gratis'
WHERE title = 'Sunshine Tour: CSI4* Week 2 (Día 1)' AND starts_at::date = '2026-02-19'::date;

-- Concierto: King Sapo (Rock)
UPDATE public.events
SET price = '12€'
WHERE title = 'Concierto: King Sapo (Rock)' AND starts_at::date = '2026-01-23'::date;

-- Carrusel de Coros: Puerta Tierra
UPDATE public.events
SET price = 'Gratis'
WHERE title = 'Carrusel de Coros: Puerta Tierra' AND starts_at::date = '2026-02-21'::date;

-- Degustación Popular: Paniza y Estofado
UPDATE public.events
SET price = 'Gratis'
WHERE title = 'Degustación Popular: Paniza y Estofado' AND starts_at::date = '2026-02-21'::date;

-- Círculo Literario Francófono
UPDATE public.events
SET price = 'Gratis'
WHERE title = 'Círculo Literario Francófono' AND starts_at::date = '2026-01-14'::date;

-- Festival de Jerez: Joaquín Grilo
UPDATE public.events
SET price = 'Desde 20€'
WHERE title = 'Festival de Jerez: Joaquín Grilo' AND starts_at::date = '2026-02-24'::date;

-- Festival de Jerez: David Coria
UPDATE public.events
SET price = 'Desde 20€'
WHERE title = 'Festival de Jerez: David Coria' AND starts_at::date = '2026-02-25'::date;

-- Festival de Jerez: Sara Baras
UPDATE public.events
SET price = 'Desde 35€'
WHERE title = 'Festival de Jerez: Sara Baras' AND starts_at::date = '2026-02-26'::date;

-- Mercadillo de Antigüedades (Algeciras)
UPDATE public.events
SET price = 'Gratis'
WHERE title = 'Mercadillo de Antigüedades (Algeciras)' AND starts_at::date = '2026-01-31'::date;

-- Senderismo: Subida al Picacho
UPDATE public.events
SET price = 'Gratis (Permiso previo)'
WHERE title = 'Senderismo: Subida al Picacho' AND starts_at::date = '2026-02-07'::date;

-- Carnaval Chiclana: Cabalgata
UPDATE public.events
SET price = 'Gratis'
WHERE title = 'Carnaval Chiclana: Cabalgata' AND starts_at::date = '2026-02-15'::date;

-- Pringá Popular (Chiclana)
UPDATE public.events
SET price = 'Gratis'
WHERE title = 'Pringá Popular (Chiclana)' AND starts_at::date = '2026-02-15'::date;

-- Romanceros en la calle
UPDATE public.events
SET price = 'Gratis'
WHERE title = 'Romanceros en la calle' AND starts_at::date = '2026-02-21'::date;

-- Noche de DJs: Carnaval Techno
UPDATE public.events
SET price = '15€'
WHERE title = 'Noche de DJs: Carnaval Techno' AND starts_at::date = '2026-02-21'::date;

-- Tortillada Popular de Camarones
UPDATE public.events
SET price = 'Gratis'
WHERE title = 'Tortillada Popular de Camarones' AND starts_at::date = '2026-02-22'::date;

-- Fútbol Femenino: Cádiz CF vs Málaga CF
UPDATE public.events
SET price = 'Gratis'
WHERE title = 'Fútbol Femenino: Cádiz CF vs Málaga CF' AND starts_at::date = '2026-02-27'::date;

-- Musical: Las Guerreras K-Pop
UPDATE public.events
SET price = '12€'
WHERE title = 'Musical: Las Guerreras K-Pop' AND starts_at::date = '2026-01-16'::date;

-- Monólogo: José Luis Calero
UPDATE public.events
SET price = '18€'
WHERE title = 'Monólogo: José Luis Calero' AND starts_at::date = '2026-01-17'::date;

-- David Navarro: Humor en Algeciras
UPDATE public.events
SET price = '15€'
WHERE title = 'David Navarro: Humor en Algeciras' AND starts_at::date = '2026-01-17'::date;

-- Arroz de Convivencia: Día de Andalucía
UPDATE public.events
SET price = 'Gratis'
WHERE title = 'Arroz de Convivencia: Día de Andalucía' AND starts_at::date = '2026-02-28'::date;

-- Mercado de Artesanía de Carnaval
UPDATE public.events
SET price = 'Gratis'
WHERE title = 'Mercado de Artesanía de Carnaval' AND starts_at::date = '2026-02-14'::date;

-- CSI4* Sunshine Tour - Qualifying
UPDATE public.events
SET price = 'Gratis'
WHERE title = 'CSI4* Sunshine Tour - Qualifying' AND starts_at::date = '2026-02-10'::date;

-- CSI4* Sunshine Tour - Young Horses
UPDATE public.events
SET price = 'Gratis'
WHERE title = 'CSI4* Sunshine Tour - Young Horses' AND starts_at::date = '2026-02-11'::date;

-- CSI4* Sunshine Tour - Medium Tour
UPDATE public.events
SET price = 'Gratis'
WHERE title = 'CSI4* Sunshine Tour - Medium Tour' AND starts_at::date = '2026-02-12'::date;

-- Sunshine Tour - Grand Prix CSI4*
UPDATE public.events
SET price = 'Gratis'
WHERE title = 'Sunshine Tour - Grand Prix CSI4*' AND starts_at::date = '2026-02-22'::date;

-- Sunshine Tour - Descanso y Revisión Veterinaria
UPDATE public.events
SET price = 'Gratis'
WHERE title = 'Sunshine Tour - Descanso y Revisión Veterinaria' AND starts_at::date = '2026-02-23'::date;

-- Sunshine Tour - Semana Andalucía (Inicio)
UPDATE public.events
SET price = 'Gratis'
WHERE title = 'Sunshine Tour - Semana Andalucía (Inicio)' AND starts_at::date = '2026-02-24'::date;

-- Sunshine Tour - Semana Andalucía (CSI2*)
UPDATE public.events
SET price = 'Gratis'
WHERE title = 'Sunshine Tour - Semana Andalucía (CSI2*)' AND starts_at::date = '2026-02-25'::date;

-- Sunshine Tour - Semana Andalucía (YH)
UPDATE public.events
SET price = 'Gratis'
WHERE title = 'Sunshine Tour - Semana Andalucía (YH)' AND starts_at::date = '2026-02-26'::date;

-- Sunshine Tour - Semana Andalucía (Clasificación GP)
UPDATE public.events
SET price = 'Gratis'
WHERE title = 'Sunshine Tour - Semana Andalucía (Clasificación GP)' AND starts_at::date = '2026-02-27'::date;

-- Fútbol Alevín: Cádiz CF vs Divina Pastora
UPDATE public.events
SET price = 'Gratis'
WHERE title = 'Fútbol Alevín: Cádiz CF vs Divina Pastora' AND starts_at::date = '2026-01-24'::date;

-- Lectura Dramatizada: ''Incendios''
UPDATE public.events
SET price = 'Gratis'
WHERE title = 'Lectura Dramatizada: ''Incendios''' AND starts_at::date = '2026-01-12'::date;

-- Magic Fest: Gala Inaugural
UPDATE public.events
SET price = '10€'
WHERE title = 'Magic Fest: Gala Inaugural' AND starts_at::date = '2026-01-12'::date;

-- Encuentro Amigos de la Biblioteca
UPDATE public.events
SET price = 'Gratis'
WHERE title = 'Encuentro Amigos de la Biblioteca' AND starts_at::date = '2026-01-13'::date;

-- Magic Fest: Magia Infantil
UPDATE public.events
SET price = '8€'
WHERE title = 'Magic Fest: Magia Infantil' AND starts_at::date = '2026-01-18'::date;

-- Romería de San Sebastián
UPDATE public.events
SET price = 'Gratis'
WHERE title = 'Romería de San Sebastián' AND starts_at::date = '2026-01-18'::date;

-- Homenaje a Robe Iniesta
UPDATE public.events
SET price = 'Gratis'
WHERE title = 'Homenaje a Robe Iniesta' AND starts_at::date = '2026-01-23'::date;

-- Concierto: María Parrado
UPDATE public.events
SET price = '15€'
WHERE title = 'Concierto: María Parrado' AND starts_at::date = '2026-01-23'::date;

-- Ópera: I Tre Gobbi
UPDATE public.events
SET price = '25€'
WHERE title = 'Ópera: I Tre Gobbi' AND starts_at::date = '2026-01-24'::date;

-- I Certamen Nacional de Coplas
UPDATE public.events
SET price = '5€'
WHERE title = 'I Certamen Nacional de Coplas' AND starts_at::date = '2026-01-24'::date;

-- Tributo Dire Straits: Alchemy Project
UPDATE public.events
SET price = '20€'
WHERE title = 'Tributo Dire Straits: Alchemy Project' AND starts_at::date = '2026-01-24'::date;

-- VI Ruta MTB Barbate
UPDATE public.events
SET price = '25€'
WHERE title = 'VI Ruta MTB Barbate' AND starts_at::date = '2026-01-25'::date;

-- Noche de Jazz: The Chameleons
UPDATE public.events
SET price = 'Gratis'
WHERE title = 'Noche de Jazz: The Chameleons' AND starts_at::date = '2026-02-14'::date;

-- Fiesta Enamorados Anti-San Valentín
UPDATE public.events
SET price = '12€'
WHERE title = 'Fiesta Enamorados Anti-San Valentín' AND starts_at::date = '2026-02-14'::date;

-- Cádiz CF Juvenil vs Tomares
UPDATE public.events
SET price = 'Gratis'
WHERE title = 'Cádiz CF Juvenil vs Tomares' AND starts_at::date = '2026-02-15'::date;

-- Flamenco Off Festival: Agujetas Chico
UPDATE public.events
SET price = '15€'
WHERE title = 'Flamenco Off Festival: Agujetas Chico' AND starts_at::date = '2026-02-20'::date;

-- Festival de Jerez: Gala de Baile
UPDATE public.events
SET price = '20€'
WHERE title = 'Festival de Jerez: Gala de Baile' AND starts_at::date = '2026-02-23'::date;

-- Festival de Jerez: Cante de Mujer
UPDATE public.events
SET price = '18€'
WHERE title = 'Festival de Jerez: Cante de Mujer' AND starts_at::date = '2026-02-24'::date;

-- Festival de Jerez: Jóvenes Talentos
UPDATE public.events
SET price = '15€'
WHERE title = 'Festival de Jerez: Jóvenes Talentos' AND starts_at::date = '2026-02-25'::date;

-- Festival de Jerez: Estreno Absoluto
UPDATE public.events
SET price = '25€'
WHERE title = 'Festival de Jerez: Estreno Absoluto' AND starts_at::date = '2026-02-26'::date;

-- Ruta Flora y Fauna: Parque de los Toruños
UPDATE public.events
SET price = 'Gratis'
WHERE title = 'Ruta Flora y Fauna: Parque de los Toruños' AND starts_at::date = '2026-02-27'::date;

-- Festival de Jerez: Cante Jondo
UPDATE public.events
SET price = '20€'
WHERE title = 'Festival de Jerez: Cante Jondo' AND starts_at::date = '2026-02-27'::date;

-- Homenaje a Blas Infante
UPDATE public.events
SET price = 'Gratis'
WHERE title = 'Homenaje a Blas Infante' AND starts_at::date = '2026-02-28'::date;

-- Tagarninada Popular
UPDATE public.events
SET price = 'Gratis'
WHERE title = 'Tagarninada Popular' AND starts_at::date = '2026-02-28'::date;

-- Festival de Jerez: Gala de Clausura Enero
UPDATE public.events
SET price = '30€'
WHERE title = 'Festival de Jerez: Gala de Clausura Enero' AND starts_at::date = '2026-02-28'::date;

-- Fútbol: San Fernando CD vs Estepona
UPDATE public.events
SET price = '12€'
WHERE title = 'Fútbol: San Fernando CD vs Estepona' AND starts_at::date = '2026-01-18'::date;

-- Fútbol: Balompédica Linense vs Minera
UPDATE public.events
SET price = '10€'
WHERE title = 'Fútbol: Balompédica Linense vs Minera' AND starts_at::date = '2026-01-25'::date;

-- Viernes Flamenco: Peña El Pescaero
UPDATE public.events
SET price = 'Donativo'
WHERE title = 'Viernes Flamenco: Peña El Pescaero' AND starts_at::date = '2026-01-30'::date;

-- Fiesta Post-Final Falla
UPDATE public.events
SET price = '15€'
WHERE title = 'Fiesta Post-Final Falla' AND starts_at::date = '2026-02-13'::date;

-- XXX Fritada Popular de Pescado
UPDATE public.events
SET price = 'Gratis'
WHERE title = 'XXX Fritada Popular de Pescado' AND starts_at::date = '2026-02-21'::date;

-- Mercado del Coleccionismo (Jerez)
UPDATE public.events
SET price = 'Gratis'
WHERE title = 'Mercado del Coleccionismo (Jerez)' AND starts_at::date = '2026-02-28'::date;

-- Verificar resultados
DO $$
DECLARE
  total_events integer;
  events_with_price integer;
  events_without_price integer;
  percentage numeric;
BEGIN
  SELECT COUNT(*) INTO total_events FROM public.events;
  SELECT COUNT(*) INTO events_with_price FROM public.events WHERE price IS NOT NULL;
  SELECT COUNT(*) INTO events_without_price FROM public.events WHERE price IS NULL;
  SELECT ROUND((events_with_price::numeric / total_events::numeric) * 100, 2) INTO percentage;
  
  RAISE NOTICE '📊 Resumen de actualización de precios:';
  RAISE NOTICE '   Total de eventos: %', total_events;
  RAISE NOTICE '   Eventos con precio: %', events_with_price;
  RAISE NOTICE '   Eventos sin precio: %', events_without_price;
  RAISE NOTICE '   Porcentaje actualizado: %', percentage;
END $$;
