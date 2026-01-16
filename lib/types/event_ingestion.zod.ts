/**
 * ============================================
 * SCHEMA ZOD PARA VALIDACIÓN DE EVENTOS
 * ============================================
 * 
 * Este archivo define schemas Zod para validar en runtime
 * que el JSON generado por la IA cumple con el contrato.
 * 
 * Útil para validar datos antes de insertarlos en la BD.
 */

import { z } from 'zod';

/**
 * Schema para EventCategory
 */
export const EventCategorySchema = z.enum([
  'Música',
  'Gastronomía',
  'Deportes',
  'Arte y Cultura',
  'Aire Libre',
  'Tradiciones',
  'Mercadillos',
]);

/**
 * Schema para EventStatus
 */
export const EventStatusSchema = z.enum([
  'new',
  'modified',
  'cancelled',
  'confirmed',
]);

/**
 * Schema para validar formato de fecha "YYYY-MM-DD"
 */
const DateStringSchema = z.string().regex(
  /^\d{4}-\d{2}-\d{2}$/,
  'La fecha debe estar en formato YYYY-MM-DD'
);

/**
 * Schema para validar formato de hora "HH:MM:SS"
 */
const TimeStringSchema = z.string().regex(
  /^\d{2}:\d{2}:\d{2}$/,
  'La hora debe estar en formato HH:MM:SS'
);

/**
 * Schema para validar URL de Google Maps
 */
const GoogleMapsUrlSchema = z.string().url().refine(
  (url) => url.includes('google.com/maps'),
  'Debe ser una URL válida de Google Maps'
);

/**
 * Schema principal para EventItem
 */
export const EventItemSchema = z.object({
  id: z.number().int().positive('El ID debe ser un número entero positivo'),
  
  status: EventStatusSchema,
  
  date: DateStringSchema,
  
  time: TimeStringSchema,
  
  category: EventCategorySchema,
  
  title: z.string()
    .min(3, 'El título debe tener al menos 3 caracteres')
    .max(100, 'El título no debe exceder 100 caracteres'),
  
  description: z.string()
    .min(10, 'La descripción debe tener al menos 10 caracteres')
    .max(2000, 'La descripción no debe exceder 2000 caracteres'),
  
  location_name: z.string()
    .min(2, 'El nombre del lugar debe tener al menos 2 caracteres')
    .max(200, 'El nombre del lugar no debe exceder 200 caracteres'),
  
  gmaps_link: GoogleMapsUrlSchema,
  
  price: z.string()
    .min(1, 'El precio es obligatorio')
    .max(50, 'El precio no debe exceder 50 caracteres'),
  
  info_url: z.string().url().or(z.literal('')).optional(),
});

/**
 * Schema para el array completo de eventos
 */
export const EventsIngestionPayloadSchema = z.array(EventItemSchema);

/**
 * Función helper para validar un evento
 * 
 * @param data - Datos a validar
 * @returns EventItem validado o lanza error
 */
export function validateEventItem(data: unknown) {
  return EventItemSchema.parse(data);
}

/**
 * Función helper para validar un array de eventos
 * 
 * @param data - Datos a validar
 * @returns Array de EventItem validado o lanza error
 */
export function validateEventsPayload(data: unknown) {
  return EventsIngestionPayloadSchema.parse(data);
}

/**
 * Función helper para validar de forma segura (no lanza error)
 * 
 * @param data - Datos a validar
 * @returns Objeto con success y data/error
 */
export function safeValidateEventItem(data: unknown) {
  return EventItemSchema.safeParse(data);
}

export function safeValidateEventsPayload(data: unknown) {
  return EventsIngestionPayloadSchema.safeParse(data);
}
