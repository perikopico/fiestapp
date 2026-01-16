/**
 * ============================================
 * TIPOS DE DATOS PARA INGESTA DE EVENTOS
 * ============================================
 * 
 * Este archivo define el contrato estricto que debe cumplir
 * el JSON generado por la IA (Gemini) para la ingesta de eventos.
 * 
 * IMPORTANTE: Cualquier desviación de estos tipos causará errores
 * en el proceso de ingesta.
 */

/**
 * Categorías de eventos permitidas (ENUM estricto)
 * 
 * NOTA: Estos valores deben coincidir EXACTAMENTE con los nombres
 * de categorías en la base de datos Supabase.
 */
export type EventCategory =
  | 'Música'
  | 'Gastronomía'
  | 'Deportes'
  | 'Arte y Cultura'
  | 'Aire Libre'
  | 'Tradiciones'
  | 'Mercadillos';

/**
 * Estados de eventos para la lógica de ingesta
 * 
 * - 'new': Evento nuevo -> Acción: INSERT
 * - 'modified': Evento existente modificado -> Acción: UPDATE
 * - 'cancelled': Evento cancelado -> Acción: SOFT DELETE (is_active = false)
 * - 'confirmed': Sin cambios -> Acción: IGNORAR (opcional, puede omitirse)
 */
export type EventStatus =
  | 'new'        // INSERT
  | 'modified'   // UPDATE
  | 'cancelled'  // SOFT DELETE
  | 'confirmed'; // IGNORE (opcional)

/**
 * Interfaz principal del evento para ingesta
 * 
 * Esta es la estructura EXACTA que debe devolver la IA generadora.
 * Todos los campos son obligatorios excepto los marcados como opcionales.
 */
export interface EventItem {
  /**
   * Identificador único y persistente del evento.
   * 
   * IMPORTANTE:
   * - Para 'new': Puede ser un ID nuevo o uno preexistente (si queremos consistencia)
   * - Para 'modified' y 'cancelled': DEBE ser un ID existente en la BD
   * - Tipo: number (entero positivo)
   */
  id: number;

  /**
   * Estado del evento que determina la acción a ejecutar.
   * 
   * Lógica:
   * - 'new' -> INSERT en la base de datos
   * - 'modified' -> UPDATE del evento existente
   * - 'cancelled' -> UPDATE con is_active = false
   * - 'confirmed' -> IGNORAR (no hacer nada)
   */
  status: EventStatus;

  /**
   * Fecha del evento en formato ISO 8601 (solo fecha).
   * 
   * Formato estricto: "YYYY-MM-DD"
   * Ejemplos válidos: "2026-01-24", "2026-12-31"
   * 
   * NO usar: "24/01/2026", "24-01-2026", "2026/01/24"
   */
  date: string;

  /**
   * Hora del evento en formato 24 horas.
   * 
   * Formato estricto: "HH:MM:SS"
   * Ejemplos válidos: "10:00:00", "20:30:00", "14:15:00"
   * 
   * NO usar: "10:00", "8:30 PM", "14:15"
   */
  time: string;

  /**
   * Categoría del evento.
   * 
   * DEBE ser uno de los valores del enum EventCategory.
   * Case-sensitive: "Música" (con tilde) NO es igual a "Musica"
   */
  category: EventCategory;

  /**
   * Título corto y descriptivo del evento.
   * 
   * Recomendación: Máximo 100 caracteres
   * Ejemplo: "Festival de Flamenco 2026"
   */
  title: string;

  /**
   * Descripción detallada del evento.
   * 
   * Debe aportar valor al usuario: qué es, qué incluye, qué esperar.
   * Puede incluir saltos de línea (\n) para formato.
   * Recomendación: Entre 100-500 caracteres
   */
  description: string;

  /**
   * Nombre del lugar o venue donde se realiza el evento.
   * 
   * Ejemplos: "Teatro Falla", "Plaza de la Constitución", "Pabellón Municipal"
   */
  location_name: string;

  /**
   * URL completa de Google Maps del lugar.
   * 
   * Formato: URL completa válida
   * Ejemplo: "https://www.google.com/maps?q=36.1927,-5.9219"
   * 
   * DEBE ser una URL válida y accesible.
   */
  gmaps_link: string;

  /**
   * Precio del evento como string libre.
   * 
   * NO usar números (int/float).
   * Ejemplos válidos: "Gratis", "10€", "15-20€", "Desde 10€", "Entrada libre"
   * 
   * Si no hay información de precio, usar "Consultar precio"
   */
  price: string;

  /**
   * Enlace a la fuente original o página de entradas.
   * 
   * Puede ser:
   * - URL de la web oficial del evento
   * - URL de venta de entradas
   * - URL de la fuente de información
   * 
   * Si no hay enlace disponible, usar string vacío "" o null (según implementación)
   */
  info_url: string;
}

/**
 * Array de eventos para ingesta masiva
 * 
 * Este es el formato que debe devolver la IA generadora.
 */
export type EventsIngestionPayload = EventItem[];

/**
 * Constantes para validación
 */
export const VALID_CATEGORIES: readonly EventCategory[] = [
  'Música',
  'Gastronomía',
  'Deportes',
  'Arte y Cultura',
  'Aire Libre',
  'Tradiciones',
  'Mercadillos',
] as const;

export const VALID_STATUSES: readonly EventStatus[] = [
  'new',
  'modified',
  'cancelled',
  'confirmed',
] as const;

/**
 * Validación de formato de fecha
 * Regex para validar formato "YYYY-MM-DD"
 */
export const DATE_FORMAT_REGEX = /^\d{4}-\d{2}-\d{2}$/;

/**
 * Validación de formato de hora
 * Regex para validar formato "HH:MM:SS"
 */
export const TIME_FORMAT_REGEX = /^\d{2}:\d{2}:\d{2}$/;
