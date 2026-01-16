-- ============================================
-- Migración 031: Asignar external_id a eventos desde JSON
-- ============================================
-- Este script asigna el external_id (ID del JSON) a los eventos existentes
-- usando coincidencia flexible de título y fecha
-- Requiere que la migración 030_add_external_id_to_events.sql ya se haya ejecutado
-- Usa una estrategia segura para evitar duplicados: solo actualiza un evento por external_id
-- ============================================

-- Paso 1: Limpiar external_id duplicados (si los hay)
-- Establecer NULL en eventos donde el external_id ya está asignado a otro evento
UPDATE public.events e1
SET external_id = NULL
WHERE e1.external_id IS NOT NULL
  AND EXISTS (
    SELECT 1
    FROM public.events e2
    WHERE e2.external_id = e1.external_id
      AND e2.id != e1.id
  );


-- Paso 2: Asignar external_id a los eventos
-- IMPORTANTE: Usamos subconsulta con LIMIT 1 para asignar solo UN evento por external_id
-- Esto evita duplicados cuando múltiples eventos coinciden con la misma condición

-- XIV Trail Urbano Villaluenga del Rosario -> external_id: 1
UPDATE public.events
SET external_id = 1
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'XIV Trail Urbano Villaluenga del Rosario%'
    AND e.starts_at::date = '2026-01-11'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 1
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Fútbol Segunda Federación: Xerez DFC vs La Unión Atlético -> external_id: 2
UPDATE public.events
SET external_id = 2
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Fútbol Segunda Federación%'
    AND e.starts_at::date = '2026-01-11'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 2
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Juan Dávila: La Capital del Pecado 2.0 -> external_id: 3
UPDATE public.events
SET external_id = 3
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Juan Dávila%'
    AND e.starts_at::date = '2026-01-11'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 3
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- COAC 2026: Preliminares (Sesión 1) - Gran Estreno -> external_id: 4
UPDATE public.events
SET external_id = 4
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'COAC 2026%'
    AND e.starts_at::date = '2026-01-11'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 4
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- COAC 2026: Preliminares (Sesión 2) -> external_id: 5
UPDATE public.events
SET external_id = 5
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'COAC 2026%'
    AND e.starts_at::date = '2026-01-12'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 5
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- COAC 2026: Preliminares (Sesión 3) -> external_id: 6
UPDATE public.events
SET external_id = 6
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'COAC 2026%'
    AND e.starts_at::date = '2026-01-13'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 6
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- COAC 2026: Preliminares (Sesión 4) -> external_id: 7
UPDATE public.events
SET external_id = 7
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'COAC 2026%'
    AND e.starts_at::date = '2026-01-14'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 7
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Andalucía Pre-Sunshine Tour: Jornada de Caballos Jóvenes -> external_id: 8
UPDATE public.events
SET external_id = 8
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Andalucía Pre-Sunshine Tour%'
    AND e.starts_at::date = '2026-01-15'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 8
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- COAC 2026: Preliminares (Sesión 5) -> external_id: 9
UPDATE public.events
SET external_id = 9
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'COAC 2026%'
    AND e.starts_at::date = '2026-01-15'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 9
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Andalucía Pre-Sunshine Tour: Competición CSI2* -> external_id: 10
UPDATE public.events
SET external_id = 10
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Andalucía Pre-Sunshine Tour%'
    AND e.starts_at::date = '2026-01-16'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 10
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- COAC 2026: Preliminares (Sesión 6) - Especial Viernes -> external_id: 11
UPDATE public.events
SET external_id = 11
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'COAC 2026%'
    AND e.starts_at::date = '2026-01-16'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 11
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Syrah Morrison en Concierto: Folk & Soul -> external_id: 12
UPDATE public.events
SET external_id = 12
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Syrah Morrison en Concierto%'
    AND e.starts_at::date = '2026-01-16'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 12
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Fiesta Universitaria: Welcome 2026 -> external_id: 13
UPDATE public.events
SET external_id = 13
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Fiesta Universitaria%'
    AND e.starts_at::date = '2026-01-16'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 13
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Andalucía Pre-Sunshine Tour: Pruebas Clasificatorias GP -> external_id: 14
UPDATE public.events
SET external_id = 14
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Andalucía Pre-Sunshine Tour%'
    AND e.starts_at::date = '2026-01-17'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 14
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Sábados de Cuento: Animación a la Lectura Infantil -> external_id: 15
UPDATE public.events
SET external_id = 15
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Sábados de Cuento%'
    AND e.starts_at::date = '2026-01-17'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 15
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Futsal Segunda B: CD Virgili Cádiz vs CD Alcalá -> external_id: 16
UPDATE public.events
SET external_id = 16
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Futsal Segunda B%'
    AND e.starts_at::date = '2026-01-17'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 16
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- COAC 2026: Preliminares (Sesión 7) - Sábado de Coplas -> external_id: 17
UPDATE public.events
SET external_id = 17
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'COAC 2026%'
    AND e.starts_at::date = '2026-01-17'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 17
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Andalucía Pre-Sunshine Tour: Gran Premio CSI2* -> external_id: 18
UPDATE public.events
SET external_id = 18
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Andalucía Pre-Sunshine Tour%'
    AND e.starts_at::date = '2026-01-18'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 18
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Sunday Market Sotogrande: Moda y Diseño -> external_id: 19
UPDATE public.events
SET external_id = 19
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Sunday Market Sotogrande%'
    AND e.starts_at::date = '2026-01-18'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 19
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- COAC 2026: Preliminares (Sesión 8) -> external_id: 20
UPDATE public.events
SET external_id = 20
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'COAC 2026%'
    AND e.starts_at::date = '2026-01-18'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 20
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- COAC 2026: Preliminares (Sesión 9) -> external_id: 21
UPDATE public.events
SET external_id = 21
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'COAC 2026%'
    AND e.starts_at::date = '2026-01-19'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 21
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- COAC 2026: Preliminares (Sesión 10) -> external_id: 22
UPDATE public.events
SET external_id = 22
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'COAC 2026%'
    AND e.starts_at::date = '2026-01-20'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 22
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- COAC 2026: Preliminares (Sesión 11) -> external_id: 23
UPDATE public.events
SET external_id = 23
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'COAC 2026%'
    AND e.starts_at::date = '2026-01-21'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 23
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Andalucía Pre-Sunshine Tour: Competición CSI3* -> external_id: 24
UPDATE public.events
SET external_id = 24
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Andalucía Pre-Sunshine Tour%'
    AND e.starts_at::date = '2026-01-22'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 24
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- COAC 2026: Preliminares (Sesión 12) -> external_id: 25
UPDATE public.events
SET external_id = 25
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'COAC 2026%'
    AND e.starts_at::date = '2026-01-22'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 25
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Andalucía Pre-Sunshine Tour: Saltos de Potencia -> external_id: 26
UPDATE public.events
SET external_id = 26
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Andalucía Pre-Sunshine Tour%'
    AND e.starts_at::date = '2026-01-23'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 26
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- COAC 2026: Preliminares (Sesión 13) - Noche de Estrellas -> external_id: 27
UPDATE public.events
SET external_id = 27
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'COAC 2026%'
    AND e.starts_at::date = '2026-01-23'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 27
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- GT Winter Series: Entrenamientos Oficiales -> external_id: 28
UPDATE public.events
SET external_id = 28
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'GT Winter Series%'
    AND e.starts_at::date = '2026-01-24'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 28
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Andalucía Pre-Sunshine Tour: Small Tour GP -> external_id: 29
UPDATE public.events
SET external_id = 29
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Andalucía Pre-Sunshine Tour%'
    AND e.starts_at::date = '2026-01-24'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 29
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- COAC 2026: Preliminares (Sesión 14) - Noche de Sábado -> external_id: 30
UPDATE public.events
SET external_id = 30
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'COAC 2026%'
    AND e.starts_at::date = '2026-01-24'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 30
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Fútbol LaLiga: Cádiz CF vs Granada CF -> external_id: 31
UPDATE public.events
SET external_id = 31
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Fútbol LaLiga%'
    AND e.starts_at::date = '2026-01-24'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 31
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- GT Winter Series: Carreras de Resistencia y Sprint -> external_id: 32
UPDATE public.events
SET external_id = 32
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'GT Winter Series%'
    AND e.starts_at::date = '2026-01-25'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 32
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Musical Infantil: 'El Reino del León' -> external_id: 33
UPDATE public.events
SET external_id = 33
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Musical Infantil%'
    AND e.starts_at::date = '2026-01-25'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 33
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- XXXIX Ostionada Popular: Carnaval en el Paladar -> external_id: 34
UPDATE public.events
SET external_id = 34
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'XXXIX Ostionada Popular%'
    AND e.starts_at::date = '2026-01-25'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 34
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- COAC 2026: Cuartos de Final (Sesión 1) - Comienza la Verdad -> external_id: 35
UPDATE public.events
SET external_id = 35
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'COAC 2026%'
    AND e.starts_at::date = '2026-01-30'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 35
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Noche de Flamenco Jondo: Peña Buena Gente -> external_id: 36
UPDATE public.events
SET external_id = 36
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Noche de Flamenco Jondo%'
    AND e.starts_at::date = '2026-01-30'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 36
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Pregón Infantil del Carnaval de Cádiz 2026 -> external_id: 37
UPDATE public.events
SET external_id = 37
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Pregón Infantil del Carnaval de Cádiz 2026%'
    AND e.starts_at::date = '2026-01-31'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 37
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- COAC 2026: Cuartos de Final (Sesión 2) -> external_id: 38
UPDATE public.events
SET external_id = 38
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'COAC 2026%'
    AND e.starts_at::date = '2026-01-31'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 38
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Presentación Oficial del Carnaval de Chipiona 2026 -> external_id: 39
UPDATE public.events
SET external_id = 39
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Presentación Oficial del Carnaval de Chipiona 2026%'
    AND e.starts_at::date = '2026-01-31'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 39
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Desfile de la Cantera: Cabalgata Infantil -> external_id: 40
UPDATE public.events
SET external_id = 40
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Desfile de la Cantera%'
    AND e.starts_at::date = '2026-02-01'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 40
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- XLIV Erizada Popular en la Viña -> external_id: 41
UPDATE public.events
SET external_id = 41
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'XLIV Erizada Popular en la Viña%'
    AND e.starts_at::date = '2026-02-01'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 41
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- COAC 2026: Cuartos de Final (Sesión 3) -> external_id: 42
UPDATE public.events
SET external_id = 42
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'COAC 2026%'
    AND e.starts_at::date = '2026-02-01'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 42
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- COAC 2026: Cuartos de Final (Sesión 4) -> external_id: 43
UPDATE public.events
SET external_id = 43
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'COAC 2026%'
    AND e.starts_at::date = '2026-02-02'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 43
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Inicio Andalucía Sunshine Tour: Semana 1 oficial -> external_id: 44
UPDATE public.events
SET external_id = 44
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Inicio Andalucía Sunshine Tour%'
    AND e.starts_at::date = '2026-02-03'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 44
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- COAC 2026: Cuartos de Final (Sesión 6) -> external_id: 45
UPDATE public.events
SET external_id = 45
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'COAC 2026%'
    AND e.starts_at::date = '2026-02-04'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 45
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- COAC 2026: Cuartos de Final (Sesión Final y Fallo) -> external_id: 46
UPDATE public.events
SET external_id = 46
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'COAC 2026%'
    AND e.starts_at::date = '2026-02-05'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 46
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Recital Flamenco de Solera: Peña Juanito Villar -> external_id: 47
UPDATE public.events
SET external_id = 47
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Recital Flamenco de Solera%'
    AND e.starts_at::date = '2026-02-06'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 47
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Pregón del Carnaval de Arcos de la Frontera -> external_id: 48
UPDATE public.events
SET external_id = 48
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Pregón del Carnaval de Arcos de la Frontera%'
    AND e.starts_at::date = '2026-02-07'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 48
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Teatro de Títeres: La Tía Norica (Función Dominical) -> external_id: 49
UPDATE public.events
SET external_id = 49
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Teatro de Títeres%'
    AND e.starts_at::date = '2026-02-08'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 49
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- I Chicharronada Popular de Cádiz -> external_id: 50
UPDATE public.events
SET external_id = 50
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'I Chicharronada Popular de Cádiz%'
    AND e.starts_at::date = '2026-02-08'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 50
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Cádiz Fight Night: El Gran Desafío (Muay Thai) -> external_id: 51
UPDATE public.events
SET external_id = 51
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Cádiz Fight Night%'
    AND e.starts_at::date = '2026-02-08'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 51
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Encendido del Alumbrado Extraordinario de Carnaval -> external_id: 52
UPDATE public.events
SET external_id = 52
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Encendido del Alumbrado Extraordinario de Carnaval%'
    AND e.starts_at::date = '2026-02-12'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 52
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- La Gran Final del COAC 2026 -> external_id: 53
UPDATE public.events
SET external_id = 53
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'La Gran Final del COAC 2026%'
    AND e.starts_at::date = '2026-02-13'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 53
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Pregón del Carnaval (Manu Sánchez) -> external_id: 54
UPDATE public.events
SET external_id = 54
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Pregón del Carnaval (Manu Sánchez)%'
    AND e.starts_at::date = '2026-02-14'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 54
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Domingo de Coros: Carrusel del Mercado -> external_id: 55
UPDATE public.events
SET external_id = 55
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Domingo de Coros%'
    AND e.starts_at::date = '2026-02-15'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 55
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Gran Cabalgata Magna del Carnaval de Cádiz -> external_id: 56
UPDATE public.events
SET external_id = 56
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Gran Cabalgata Magna del Carnaval de Cádiz%'
    AND e.starts_at::date = '2026-02-15'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 56
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Lunes de Carnaval: Carrusel en la Viña -> external_id: 57
UPDATE public.events
SET external_id = 57
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Lunes de Carnaval%'
    AND e.starts_at::date = '2026-02-16'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 57
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Gala Inaugural XXX Festival de Jerez: Manuela Carpio -> external_id: 58
UPDATE public.events
SET external_id = 58
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Gala Inaugural XXX Festival de Jerez%'
    AND e.starts_at::date = '2026-02-20'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 58
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Cabalgata del Humor de Cádiz -> external_id: 59
UPDATE public.events
SET external_id = 59
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Cabalgata del Humor de Cádiz%'
    AND e.starts_at::date = '2026-02-21'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 59
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Quema de la Bruja Piti y Fuegos Artificiales -> external_id: 60
UPDATE public.events
SET external_id = 60
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Quema de la Bruja Piti y Fuegos Artificiales%'
    AND e.starts_at::date = '2026-02-22'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 60
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Fútbol Regional: CD Guadiaro vs Barbate CF -> external_id: 61
UPDATE public.events
SET external_id = 61
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Fútbol Regional%'
    AND e.starts_at::date = '2026-01-11'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 61
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Limpieza de Playa Yerbabuena (Voluntariado) -> external_id: 62
UPDATE public.events
SET external_id = 62
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Limpieza de Playa Yerbabuena (Voluntariado)%'
    AND e.starts_at::date = '2026-01-17'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 62
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- VIII Carrera Popular El Pilar-Marianistas -> external_id: 63
UPDATE public.events
SET external_id = 63
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'VIII Carrera Popular El Pilar-Marianistas%'
    AND e.starts_at::date = '2026-01-18'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 63
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- II Trail Villa de El Bosque (Ruta del Majaceite) -> external_id: 64
UPDATE public.events
SET external_id = 64
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'II Trail Villa de El Bosque (Ruta del Majaceite)%'
    AND e.starts_at::date = '2026-01-18'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 64
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Romería de San Sebastián: Convivencia Campestre -> external_id: 65
UPDATE public.events
SET external_id = 65
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Romería de San Sebastián%'
    AND e.starts_at::date = '2026-01-18'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 65
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- María Parrado: Presentación 'La niña que fui' -> external_id: 66
UPDATE public.events
SET external_id = 66
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'María Parrado%'
    AND e.starts_at::date = '2026-01-23'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 66
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- VI Ruta MTB Barbate: Los Alcornocales -> external_id: 67
UPDATE public.events
SET external_id = 67
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'VI Ruta MTB Barbate%'
    AND e.starts_at::date = '2026-01-25'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 67
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- IV Media Maratón Monumental Ciudad de Arcos -> external_id: 68
UPDATE public.events
SET external_id = 68
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'IV Media Maratón Monumental Ciudad de Arcos%'
    AND e.starts_at::date = '2026-01-31'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 68
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- XII Víboras Trail: Maratón de Montaña -> external_id: 69
UPDATE public.events
SET external_id = 69
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'XII Víboras Trail%'
    AND e.starts_at::date = '2026-02-07'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 69
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Kayak por las Marismas: Especial San Valentín -> external_id: 70
UPDATE public.events
SET external_id = 70
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Kayak por las Marismas%'
    AND e.starts_at::date = '2026-02-14'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 70
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- DERBI Futsal: Virgili Cádiz vs Xerez Toyota Nimauto -> external_id: 71
UPDATE public.events
SET external_id = 71
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'DERBI Futsal%'
    AND e.starts_at::date = '2026-02-21'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 71
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Vía Crucis Oficial de Hermandades y Cofradías -> external_id: 72
UPDATE public.events
SET external_id = 72
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Vía Crucis Oficial de Hermandades y Cofradías%'
    AND e.starts_at::date = '2026-02-23'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 72
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Concierto Orquesta de Algeciras: Antología Andaluza -> external_id: 73
UPDATE public.events
SET external_id = 73
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Concierto Orquesta de Algeciras%'
    AND e.starts_at::date = '2026-02-27'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 73
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Torneo Día de Andalucía de Golf: Sotogrande Cup -> external_id: 74
UPDATE public.events
SET external_id = 74
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Torneo Día de Andalucía de Golf%'
    AND e.starts_at::date = '2026-02-28'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 74
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Día de Andalucía: Izada de Bandera y Actos Oficiales -> external_id: 75
UPDATE public.events
SET external_id = 75
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Día de Andalucía%'
    AND e.starts_at::date = '2026-02-28'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 75
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Exposición Permanente: Los Sarcófagos Fenicios -> external_id: 76
UPDATE public.events
SET external_id = 76
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Exposición Permanente%'
    AND e.starts_at::date = '2026-01-20'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 76
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- COAC 2026: Cuartos de Final (Noche 1) -> external_id: 77
UPDATE public.events
SET external_id = 77
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'COAC 2026%'
    AND e.starts_at::date = '2026-01-30'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 77
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Futsal: Virgili Cádiz vs UD Alchoyano -> external_id: 78
UPDATE public.events
SET external_id = 78
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Futsal%'
    AND e.starts_at::date = '2026-01-31'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 78
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Teatro: Los Lunes al Sol (Adaptación Teatral) -> external_id: 79
UPDATE public.events
SET external_id = 79
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Teatro%'
    AND e.starts_at::date = '2026-02-06'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 79
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Anti-San Valentín Party en Bereber -> external_id: 80
UPDATE public.events
SET external_id = 80
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Anti-San Valentín Party en Bereber%'
    AND e.starts_at::date = '2026-02-14'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 80
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Festival de Jerez: Niño de los Reyes 'Vuelta al Sol' -> external_id: 81
UPDATE public.events
SET external_id = 81
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Festival de Jerez%'
    AND e.starts_at::date = '2026-02-21'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 81
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Festival de Jerez: Eduardo Guerrero -> external_id: 82
UPDATE public.events
SET external_id = 82
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Festival de Jerez%'
    AND e.starts_at::date = '2026-02-23'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 82
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Noche de Rock: Tributo a Héroes del Silencio -> external_id: 83
UPDATE public.events
SET external_id = 83
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Noche de Rock%'
    AND e.starts_at::date = '2026-02-28'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 83
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Taller de Máscaras de Carnaval para Niños -> external_id: 84
UPDATE public.events
SET external_id = 84
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Taller de Máscaras de Carnaval para Niños%'
    AND e.starts_at::date = '2026-01-16'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 84
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Tardeo de Invierno en El Puerto: Iroko Garden -> external_id: 85
UPDATE public.events
SET external_id = 85
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Tardeo de Invierno en El Puerto%'
    AND e.starts_at::date = '2026-01-24'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 85
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Degustación de 'Pringá' Popular -> external_id: 86
UPDATE public.events
SET external_id = 86
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Degustación de ''Pringá'' Popular%'
    AND e.starts_at::date = '2026-02-15'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 86
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Tagarninada Popular: Platos del Día de Andalucía -> external_id: 87
UPDATE public.events
SET external_id = 87
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Tagarninada Popular%'
    AND e.starts_at::date = '2026-02-28'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 87
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Ensayo Solidario de Costaleros: 'Un kilo de coplas' -> external_id: 88
UPDATE public.events
SET external_id = 88
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Ensayo Solidario de Costaleros%'
    AND e.starts_at::date = '2026-01-18'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 88
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Panizada Popular: Fritura de Panizas -> external_id: 89
UPDATE public.events
SET external_id = 89
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Panizada Popular%'
    AND e.starts_at::date = '2026-02-21'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 89
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Rastro de Antigüedades de Algeciras -> external_id: 90
UPDATE public.events
SET external_id = 90
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Rastro de Antigüedades de Algeciras%'
    AND e.starts_at::date = '2026-01-31'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 90
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Visita Guiada: Baelo Claudia Romano -> external_id: 91
UPDATE public.events
SET external_id = 91
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Visita Guiada%'
    AND e.starts_at::date = '2026-01-11'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 91
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Mercado de Artesanía y Disfraces -> external_id: 92
UPDATE public.events
SET external_id = 92
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Mercado de Artesanía y Disfraces%'
    AND e.starts_at::date = '2026-02-14'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 92
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Concentración de Coches Clásicos y Motor de Época -> external_id: 93
UPDATE public.events
SET external_id = 93
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Concentración de Coches Clásicos y Motor de Época%'
    AND e.starts_at::date = '2026-01-25'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 93
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Certamen de Romanceros en los Rincones -> external_id: 94
UPDATE public.events
SET external_id = 94
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Certamen de Romanceros en los Rincones%'
    AND e.starts_at::date = '2026-02-21'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 94
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- XXX Fritada Popular de Pescado: Carnaval de Despedida -> external_id: 95
UPDATE public.events
SET external_id = 95
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'XXX Fritada Popular de Pescado%'
    AND e.starts_at::date = '2026-02-22'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 95
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Cineclub San Fernando: Ciclo de Autor -> external_id: 96
UPDATE public.events
SET external_id = 96
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Cineclub San Fernando%'
    AND e.starts_at::date = '2026-01-20'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 96
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Conferencia: 'Cádiz y el Monopolio de Indias' -> external_id: 97
UPDATE public.events
SET external_id = 97
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Conferencia%'
    AND e.starts_at::date = '2026-02-19'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 97
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Fútbol Juvenil: Cádiz CF vs Arenas de Armilla -> external_id: 98
UPDATE public.events
SET external_id = 98
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Fútbol Juvenil%'
    AND e.starts_at::date = '2026-02-08'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 98
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Fútbol Infantil: Cádiz CF 'A' vs Real Betis -> external_id: 99
UPDATE public.events
SET external_id = 99
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Fútbol Infantil%'
    AND e.starts_at::date = '2026-02-15'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 99
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Mercadillo del Coleccionismo de Jerez -> external_id: 100
UPDATE public.events
SET external_id = 100
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Mercadillo del Coleccionismo de Jerez%'
    AND e.starts_at::date = '2026-02-28'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 100
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- COAC 2026: Semifinales (Día 1) -> external_id: 101
UPDATE public.events
SET external_id = 101
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'COAC 2026%'
    AND e.starts_at::date = '2026-02-08'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 101
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- COAC 2026: Semifinales (Día 2) -> external_id: 102
UPDATE public.events
SET external_id = 102
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'COAC 2026%'
    AND e.starts_at::date = '2026-02-09'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 102
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- COAC 2026: Semifinales (Día 3) -> external_id: 103
UPDATE public.events
SET external_id = 103
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'COAC 2026%'
    AND e.starts_at::date = '2026-02-10'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 103
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- COAC 2026: Semifinales (Día Final) -> external_id: 104
UPDATE public.events
SET external_id = 104
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'COAC 2026%'
    AND e.starts_at::date = '2026-02-11'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 104
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Concierto Jazz: The Chameleons -> external_id: 105
UPDATE public.events
SET external_id = 105
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Concierto Jazz%'
    AND e.starts_at::date = '2026-02-14'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 105
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Concierto de Cuaresma: Banda Maestro Dueñas -> external_id: 106
UPDATE public.events
SET external_id = 106
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Concierto de Cuaresma%'
    AND e.starts_at::date = '2026-02-21'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 106
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Festival de Jerez: Olga Pericet presenta 'La Materia' -> external_id: 107
UPDATE public.events
SET external_id = 107
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Festival de Jerez%'
    AND e.starts_at::date = '2026-02-22'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 107
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Festival de Jerez: Estévez y Paños 'Doncellas' -> external_id: 108
UPDATE public.events
SET external_id = 108
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Festival de Jerez%'
    AND e.starts_at::date = '2026-02-24'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 108
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Festival de Jerez: Carmen Herrera 'GhERRERA' -> external_id: 109
UPDATE public.events
SET external_id = 109
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Festival de Jerez%'
    AND e.starts_at::date = '2026-02-26'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 109
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Festival de Jerez: Gran Clausura de Febrero -> external_id: 110
UPDATE public.events
SET external_id = 110
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Festival de Jerez%'
    AND e.starts_at::date = '2026-02-28'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 110
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Ensayo General Chirigota del Selu -> external_id: 111
UPDATE public.events
SET external_id = 111
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Ensayo General Chirigota del Selu%'
    AND e.starts_at::date = '2026-01-15'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 111
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Ruta Ornitológica: Avistamiento de Invierno -> external_id: 112
UPDATE public.events
SET external_id = 112
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Ruta Ornitológica%'
    AND e.starts_at::date = '2026-01-24'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 112
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Senderismo: Los Alcornocales - Ruta del Agua -> external_id: 113
UPDATE public.events
SET external_id = 113
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Senderismo%'
    AND e.starts_at::date = '2026-02-14'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 113
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Gran Arroz Popular en Benalup -> external_id: 114
UPDATE public.events
SET external_id = 114
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Gran Arroz Popular en Benalup%'
    AND e.starts_at::date = '2026-02-28'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 114
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Ortigada Popular: Sabores del Mar -> external_id: 115
UPDATE public.events
SET external_id = 115
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Ortigada Popular%'
    AND e.starts_at::date = '2026-02-21'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 115
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Zambomba de Invierno: Especial Flamenco -> external_id: 116
UPDATE public.events
SET external_id = 116
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Zambomba de Invierno%'
    AND e.starts_at::date = '2026-01-16'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 116
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Rugby: Atlético Portuense vs CD Universidad -> external_id: 117
UPDATE public.events
SET external_id = 117
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Rugby%'
    AND e.starts_at::date = '2026-02-08'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 117
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Yoga en la Playa de la Barrosa -> external_id: 118
UPDATE public.events
SET external_id = 118
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Yoga en la Playa de la Barrosa%'
    AND e.starts_at::date = '2026-02-28'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 118
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Sesión DJ Vinilo: Funk & Soul -> external_id: 119
UPDATE public.events
SET external_id = 119
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Sesión DJ Vinilo%'
    AND e.starts_at::date = '2026-01-11'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 119
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Fiesta Post-Final Falla: Noche de Carnaval -> external_id: 120
UPDATE public.events
SET external_id = 120
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Fiesta Post-Final Falla%'
    AND e.starts_at::date = '2026-02-13'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 120
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Ciclo Cine y Gastronomía: Proyección y Cata -> external_id: 121
UPDATE public.events
SET external_id = 121
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Ciclo Cine y Gastronomía%'
    AND e.starts_at::date = '2026-01-15'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 121
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Batalla de Coplas en el Paseo Marítimo -> external_id: 122
UPDATE public.events
SET external_id = 122
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Batalla de Coplas en el Paseo Marítimo%'
    AND e.starts_at::date = '2026-02-14'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 122
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Concierto Acústico: Cantautores de Cádiz -> external_id: 123
UPDATE public.events
SET external_id = 123
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Concierto Acústico%'
    AND e.starts_at::date = '2026-01-18'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 123
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Fútbol Femenino: San Fernando CD vs Algeciras CF -> external_id: 124
UPDATE public.events
SET external_id = 124
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Fútbol Femenino%'
    AND e.starts_at::date = '2026-02-01'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 124
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Izado de Bandera: Sanlúcar de Barrameda -> external_id: 125
UPDATE public.events
SET external_id = 125
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Izado de Bandera%'
    AND e.starts_at::date = '2026-02-28'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 125
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Inauguración: Exposición Fotográfica 'Cádiz en B/N' -> external_id: 126
UPDATE public.events
SET external_id = 126
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Inauguración%'
    AND e.starts_at::date = '2026-01-20'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 126
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Club de Lectura: Especial Novela Negra Gaditana -> external_id: 127
UPDATE public.events
SET external_id = 127
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Club de Lectura%'
    AND e.starts_at::date = '2026-02-10'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 127
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Jam Session de Jazz: Lunes Musicales -> external_id: 128
UPDATE public.events
SET external_id = 128
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Jam Session de Jazz%'
    AND e.starts_at::date = '2026-01-12'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 128
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Ruta en Kayak: Castillo de Sancti Petri -> external_id: 129
UPDATE public.events
SET external_id = 129
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Ruta en Kayak%'
    AND e.starts_at::date = '2026-02-15'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 129
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Torneo de Pádel Solidario -> external_id: 130
UPDATE public.events
SET external_id = 130
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Torneo de Pádel Solidario%'
    AND e.starts_at::date = '2026-01-25'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 130
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Concierto Flamenco: Tributo a Camarón -> external_id: 131
UPDATE public.events
SET external_id = 131
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Concierto Flamenco%'
    AND e.starts_at::date = '2026-02-14'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 131
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Cata de Vinos del Marco de Jerez -> external_id: 132
UPDATE public.events
SET external_id = 132
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Cata de Vinos del Marco de Jerez%'
    AND e.starts_at::date = '2026-01-18'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 132
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Concierto: Grupo de Rock Local 'Los Atómicos' -> external_id: 133
UPDATE public.events
SET external_id = 133
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Concierto%'
    AND e.starts_at::date = '2026-02-28'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 133
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Taller de Teatro para Mayores -> external_id: 134
UPDATE public.events
SET external_id = 134
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Taller de Teatro para Mayores%'
    AND e.starts_at::date = '2026-02-05'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 134
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Carnaval de los Colegios: Desfile Escolar -> external_id: 135
UPDATE public.events
SET external_id = 135
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Carnaval de los Colegios%'
    AND e.starts_at::date = '2026-01-30'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 135
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Tortillada Popular: Especial Camarones -> external_id: 136
UPDATE public.events
SET external_id = 136
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Tortillada Popular%'
    AND e.starts_at::date = '2026-02-22'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 136
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Ruta MTB: Los Alcornocales Extremo -> external_id: 137
UPDATE public.events
SET external_id = 137
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Ruta MTB%'
    AND e.starts_at::date = '2026-02-15'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 137
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Exposición de Belenes: Clausura -> external_id: 138
UPDATE public.events
SET external_id = 138
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Exposición de Belenes%'
    AND e.starts_at::date = '2026-01-11'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 138
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Fútbol Regional: Arcos CF vs Ubrique UD -> external_id: 139
UPDATE public.events
SET external_id = 139
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Fútbol Regional%'
    AND e.starts_at::date = '2026-02-08'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 139
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Festival de Bandas de Música: Día de Andalucía -> external_id: 140
UPDATE public.events
SET external_id = 140
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Festival de Bandas de Música%'
    AND e.starts_at::date = '2026-02-28'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 140
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Zambomba Solidaria en la Asociación de Vecinos -> external_id: 141
UPDATE public.events
SET external_id = 141
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Zambomba Solidaria en la Asociación de Vecinos%'
    AND e.starts_at::date = '2026-01-15'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 141
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Concurso de Disfraces en Familia -> external_id: 142
UPDATE public.events
SET external_id = 142
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Concurso de Disfraces en Familia%'
    AND e.starts_at::date = '2026-02-14'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 142
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Conferencia de Historia: Baelo Claudia Romano -> external_id: 143
UPDATE public.events
SET external_id = 143
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Conferencia de Historia%'
    AND e.starts_at::date = '2026-01-12'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 143
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Paella Gigante en el Parque -> external_id: 144
UPDATE public.events
SET external_id = 144
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Paella Gigante en el Parque%'
    AND e.starts_at::date = '2026-02-28'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 144
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Fútbol Alevín: Cádiz CF vs Puerto Malagueño -> external_id: 145
UPDATE public.events
SET external_id = 145
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Fútbol Alevín%'
    AND e.starts_at::date = '2026-01-24'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 145
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Taller de Pitos de Carnaval -> external_id: 146
UPDATE public.events
SET external_id = 146
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Taller de Pitos de Carnaval%'
    AND e.starts_at::date = '2026-02-21'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 146
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Concierto Acústico de Cantautor -> external_id: 147
UPDATE public.events
SET external_id = 147
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Concierto Acústico de Cantautor%'
    AND e.starts_at::date = '2026-01-20'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 147
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Limpieza de Entorno Natural: Voluntariado -> external_id: 148
UPDATE public.events
SET external_id = 148
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Limpieza de Entorno Natural%'
    AND e.starts_at::date = '2026-02-14'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 148
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Triatlón de Invierno: Puerto Sherry -> external_id: 149
UPDATE public.events
SET external_id = 149
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Triatlón de Invierno%'
    AND e.starts_at::date = '2026-01-25'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 149
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Degustación de Productos de la Sierra -> external_id: 150
UPDATE public.events
SET external_id = 150
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Degustación de Productos de la Sierra%'
    AND e.starts_at::date = '2026-02-28'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 150
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Misa Solemne y Ofrenda Floral -> external_id: 151
UPDATE public.events
SET external_id = 151
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Misa Solemne y Ofrenda Floral%'
    AND e.starts_at::date = '2026-02-28'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 151
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Entierro de la Caballa: Fin de Carnaval -> external_id: 152
UPDATE public.events
SET external_id = 152
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Entierro de la Caballa%'
    AND e.starts_at::date = '2026-02-22'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 152
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Concierto Rock Local: 'Viento de Levante' -> external_id: 153
UPDATE public.events
SET external_id = 153
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Concierto Rock Local%'
    AND e.starts_at::date = '2026-01-30'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 153
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Ruta Fotográfica: Pueblos Blancos -> external_id: 154
UPDATE public.events
SET external_id = 154
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Ruta Fotográfica%'
    AND e.starts_at::date = '2026-02-15'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 154
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Obra de Teatro: 'La Pasión de Cádiz' -> external_id: 155
UPDATE public.events
SET external_id = 155
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Obra de Teatro%'
    AND e.starts_at::date = '2026-01-11'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 155
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Concurso de Tapas de Carnaval -> external_id: 156
UPDATE public.events
SET external_id = 156
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Concurso de Tapas de Carnaval%'
    AND e.starts_at::date = '2026-02-08'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 156
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Marcha Ciclista por la Autonomía -> external_id: 157
UPDATE public.events
SET external_id = 157
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Marcha Ciclista por la Autonomía%'
    AND e.starts_at::date = '2026-02-28'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 157
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Tertulia Carnavalesca: Pasado y Presente -> external_id: 158
UPDATE public.events
SET external_id = 158
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Tertulia Carnavalesca%'
    AND e.starts_at::date = '2026-01-20'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 158
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Taller de Poesía de Amor: Especial San Valentín -> external_id: 159
UPDATE public.events
SET external_id = 159
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Taller de Poesía de Amor%'
    AND e.starts_at::date = '2026-02-14'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 159
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Recital de Guitarra Clásica -> external_id: 160
UPDATE public.events
SET external_id = 160
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Recital de Guitarra Clásica%'
    AND e.starts_at::date = '2026-01-12'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 160
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Comida de Convivencia Andaluza -> external_id: 161
UPDATE public.events
SET external_id = 161
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Comida de Convivencia Andaluza%'
    AND e.starts_at::date = '2026-02-28'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 161
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Vela: Regata de Carnaval -> external_id: 162
UPDATE public.events
SET external_id = 162
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Vela%'
    AND e.starts_at::date = '2026-02-22'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 162
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Sesión de Jazz en vivo: Trio 'Aires' -> external_id: 163
UPDATE public.events
SET external_id = 163
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Sesión de Jazz en vivo%'
    AND e.starts_at::date = '2026-01-15'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 163
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Degustación de 'Migas' Serranas -> external_id: 164
UPDATE public.events
SET external_id = 164
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Degustación de ''Migas'' Serranas%'
    AND e.starts_at::date = '2026-02-15'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 164
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Taller de Carnaval: Crea tu propio Disfraz -> external_id: 165
UPDATE public.events
SET external_id = 165
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Taller de Carnaval%'
    AND e.starts_at::date = '2026-01-31'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 165
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Recital de Poesía de Amor: Especial San Valentín -> external_id: 166
UPDATE public.events
SET external_id = 166
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Recital de Poesía de Amor%'
    AND e.starts_at::date = '2026-02-14'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 166
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Concierto de Cante Flamenco: Día de Andalucía -> external_id: 167
UPDATE public.events
SET external_id = 167
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Concierto de Cante Flamenco%'
    AND e.starts_at::date = '2026-02-28'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 167
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Ruta de Senderismo: Acantilados de Barbate -> external_id: 168
UPDATE public.events
SET external_id = 168
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Ruta de Senderismo%'
    AND e.starts_at::date = '2026-02-22'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 168
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Mercadillo de Segunda Mano y Artesanía -> external_id: 169
UPDATE public.events
SET external_id = 169
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Mercadillo de Segunda Mano y Artesanía%'
    AND e.starts_at::date = '2026-01-25'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 169
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);

-- Gran Concierto de Clausura del Día de Andalucía -> external_id: 170
UPDATE public.events
SET external_id = 170
WHERE id IN (
  SELECT e.id
  FROM public.events e
  WHERE e.title LIKE 'Gran Concierto de Clausura del Día de Andalucía%'
    AND e.starts_at::date = '2026-02-28'::date
    AND e.external_id IS NULL
    AND NOT EXISTS (
      SELECT 1 FROM public.events e2
      WHERE e2.external_id = 170
        AND e2.id != e.id
    )
  ORDER BY e.id
  LIMIT 1
);


-- Verificar resultados
DO $$
DECLARE
  total_events integer;
  events_with_external_id integer;
  duplicate_external_ids integer;
  percentage_assigned numeric;
BEGIN
  SELECT COUNT(*) INTO total_events FROM public.events;
  SELECT COUNT(*) INTO events_with_external_id FROM public.events WHERE external_id IS NOT NULL;
  -- Verificar si hay external_id duplicados
  SELECT COUNT(*) INTO duplicate_external_ids
  FROM (
    SELECT external_id
    FROM public.events
    WHERE external_id IS NOT NULL
    GROUP BY external_id
    HAVING COUNT(*) > 1
  ) duplicados;
  
  IF total_events > 0 THEN
    percentage_assigned := ROUND((events_with_external_id::numeric / total_events::numeric) * 100, 2);
  ELSE
    percentage_assigned := 0;
  END IF;
  
  RAISE NOTICE '📊 Resumen de asignación de external_id:';
  RAISE NOTICE '   Total de eventos: %', total_events;
  RAISE NOTICE '   Eventos con external_id asignado: % (% %%)', events_with_external_id, percentage_assigned;
  IF duplicate_external_ids > 0 THEN
    RAISE WARNING '⚠️  Se encontraron % external_id duplicados. Revisar manualmente.', duplicate_external_ids;
  ELSE
    RAISE NOTICE '✅ No hay external_id duplicados.';
  END IF;
END $$;