-- ============================================
-- Migración 029: Actualizar info_url y description desde JSON (por external_id)
-- ============================================
-- Este script actualiza los campos info_url y description de los eventos
-- basándose en el JSON final-definitivo2.txt
-- Usa external_id para identificar eventos de forma confiable
-- NOTA: Requiere que primero se ejecute la migración 030_add_external_id_to_events.sql
-- y que los eventos tengan su external_id asignado
-- ============================================

-- XIV Trail Urbano Villaluenga del Rosario (external_id: 1)
UPDATE public.events
SET description = 'Una de las carreras de montaña más singulares de la Sierra de Cádiz. El recorrido combina el exigente trazado urbano del pueblo más alto de la provincia con senderos técnicos por el entorno natural de la Sierra de Grazalema. Ideal para corredores que buscan desnivel y paisajes espectaculares.', info_url = 'https://www.clubrunning.es/carrera/xiv-trail-urbana-villaluenga/76224'
WHERE external_id = 1;

-- Fútbol Segunda Federación: Xerez DFC vs La Unión Atlético (external_id: 2)
UPDATE public.events
SET description = 'Partido oficial de liga del Grupo 4 de la Segunda Federación española. El Xerez Deportivo FC busca consolidar su posición en casa en el Estadio Municipal de Chapín. Un evento con gran ambiente de afición local en uno de los estadios más grandes de Andalucía.', info_url = 'https://xerezdfc.com/'
WHERE external_id = 2;

-- Juan Dávila: La Capital del Pecado 2.0 (external_id: 3)
UPDATE public.events
SET description = 'El show de humor más gamberro y exitoso del momento llega a Jerez. Juan Dávila interactúa con el público en un espectáculo donde la improvisación y la risa sin filtros son los protagonistas. No apto para personas que se ofendan con facilidad.', info_url = 'https://www.tickentradas.com/lugar/teatro-villamarta-jerez'
WHERE external_id = 3;

-- COAC 2026: Preliminares (Sesión 1) - Gran Estreno (external_id: 4)
UPDATE public.events
SET description = 'Noche inaugural del Concurso Oficial de Agrupaciones del Carnaval de Cádiz. El Coro de Ceuta ''Al lío'' tiene el honor de abrir las tablas. Es la primera toma de contacto con las coplas del año, donde comparsas y chirigotas presentan sus tipos y letras inéditas en el templo del carnaval.', info_url = 'https://www.bacantix.com/entradas/webforms/forms/evento.aspx?id=coacfalla'
WHERE external_id = 4;

-- COAC 2026: Preliminares (Sesión 2) (external_id: 5)
UPDATE public.events
SET description = 'Segunda noche de concurso en el Falla. El plato fuerte es el Coro ''El sindicato''. Participan agrupaciones que buscan dar la sorpresa y colarse en cuartos de final. Ambiente auténtico con la cantera y grupos veteranos.', info_url = 'https://www.bacantix.com/'
WHERE external_id = 5;

-- COAC 2026: Preliminares (Sesión 3) (external_id: 6)
UPDATE public.events
SET description = 'Continuación de la fase preliminar. Esta noche destaca la Comparsa ''Los del escondite'' y la Chirigota ''Nos hemos venío arriba''. Una sesión equilibrada para disfrutar de la ironía y la poesía gaditana.', info_url = 'https://www.bacantix.com/'
WHERE external_id = 6;

-- COAC 2026: Preliminares (Sesión 4) (external_id: 7)
UPDATE public.events
SET description = 'Cuarta jornada del concurso oficial. El público espera con ganas a la Comparsa ''La ciudad perfecta''. El teatro se llena de color y crítica social en cada una de las 6-7 actuaciones de la noche.', info_url = 'https://www.bacantix.com/'
WHERE external_id = 7;

-- Andalucía Pre-Sunshine Tour: Jornada de Caballos Jóvenes (external_id: 8)
UPDATE public.events
SET description = 'Apertura del mayor evento hípico de Europa en invierno. En esta jornada se prueban los futuros campeones de salto: potros de 5, 6 y 7 años. Es una oportunidad única para ver el entrenamiento de alto nivel en un entorno natural privilegiado. Acceso libre a las instalaciones.', info_url = 'https://sunshinetour.net/'
WHERE external_id = 8;

-- COAC 2026: Preliminares (Sesión 5) (external_id: 9)
UPDATE public.events
SET description = 'Llegamos a la quinta noche con el Coro ''ADN'' como referente de la sesión. El concurso empieza a coger ritmo y el ambiente en los alrededores del teatro (Plaza de las Flores, La Viña) ya respira carnaval 24 horas.', info_url = 'https://www.bacantix.com/'
WHERE external_id = 9;

-- Andalucía Pre-Sunshine Tour: Competición CSI2* (external_id: 10)
UPDATE public.events
SET description = 'Segundo día de la semana de apertura. Competición internacional de saltos de obstáculos de categoría 2 estrellas. Los jinetes empiezan a buscar los primeros puntos del ranking mundial en la espectacular pista de hierba de Montenmedio.', info_url = 'https://sunshinetour.net/'
WHERE external_id = 10;

-- COAC 2026: Preliminares (Sesión 6) - Especial Viernes (external_id: 11)
UPDATE public.events
SET description = 'Noche de gran ambiente. El Coro ''La Viña del mar'' y la Comparsa ''El verdugo'' centran las miradas. Los viernes de concurso son especialmente vibrantes por la afluencia de público de toda la provincia que se queda luego por la ciudad.', info_url = 'https://www.bacantix.com/'
WHERE external_id = 11;

-- Syrah Morrison en Concierto: Folk & Soul (external_id: 12)
UPDATE public.events
SET description = 'La potente voz de Syrah Morrison llega a Jerez para una noche de folk, soul y jazz en directo. La Guarida del Ángel ofrece el marco perfecto (una antigua fragua) para disfrutar de la música de raíz en un ambiente íntimo y cuidado.', info_url = 'https://laguaridadelangel.com/'
WHERE external_id = 12;

-- Fiesta Universitaria: Welcome 2026 (external_id: 13)
UPDATE public.events
SET description = 'Gran evento de bienvenida para el segundo cuatrimestre universitario. Sesión con los DJs residentes de Momart con los éxitos comerciales, reggaeton y electrónica. El punto de encuentro principal de la noche gaditana frente al mar.', info_url = 'https://momarttheatre.com/'
WHERE external_id = 13;

-- Andalucía Pre-Sunshine Tour: Pruebas Clasificatorias GP (external_id: 14)
UPDATE public.events
SET description = 'Jornada de sábado en Montenmedio donde se deciden los jinetes que pasarán al Gran Premio del domingo. Se puede disfrutar también de la zona de restauración y tiendas de moda hípica abiertas al público general.', info_url = 'https://sunshinetour.net/'
WHERE external_id = 14;

-- Sábados de Cuento: Animación a la Lectura Infantil (external_id: 15)
UPDATE public.events
SET description = 'Sesión gratuita para niños y niñas donde narradores profesionales dan vida a cuentos clásicos y modernos. Una actividad ideal para familias que quieran fomentar la imaginación en un entorno cultural seguro.', info_url = 'https://www.bibliotecasdeandalucia.es/'
WHERE external_id = 15;

-- Futsal Segunda B: CD Virgili Cádiz vs CD Alcalá (external_id: 16)
UPDATE public.events
SET description = 'El equipo de fútbol sala más laureado de la ciudad se enfrenta a un duro rival en la lucha por el ascenso. Emoción asegurada en el complejo deportivo municipal en un partido de alta intensidad y técnica.', info_url = 'https://www.virgilicadiz.com/'
WHERE external_id = 16;

-- COAC 2026: Preliminares (Sesión 7) - Sábado de Coplas (external_id: 17)
UPDATE public.events
SET description = 'Posiblemente la noche con más demanda de la semana. Actúan grupos populares como el Coro ''El reino de los cielos''. El Falla se convierte en un hervidero de pasodobles y cuplés.', info_url = 'https://www.bacantix.com/'
WHERE external_id = 17;

-- Andalucía Pre-Sunshine Tour: Gran Premio CSI2* (external_id: 18)
UPDATE public.events
SET description = 'Día grande de la hípica en Vejer. Los mejores jinetes de la semana compiten por el trofeo del Gran Premio sobre obstáculos de 1.45m. Espectáculo visual impresionante para todos los públicos, incluso si no conoces el deporte.', info_url = 'https://sunshinetour.net/'
WHERE external_id = 18;

-- Sunday Market Sotogrande: Moda y Diseño (external_id: 19)
UPDATE public.events
SET description = 'Mercado exclusivo que se celebra cada domingo en la Marina de Sotogrande. Encontrarás marcas independientes de moda, joyas artesanales, decoración y productos gourmet locales en un entorno de lujo frente a los yates.', info_url = 'https://puerstosotogrande.es/'
WHERE external_id = 19;

-- COAC 2026: Preliminares (Sesión 8) (external_id: 20)
UPDATE public.events
SET description = 'Octava sesión de preliminares. El Falla recibe al Coro ''La carnicería'' y a la Comparsa ''Las muñecas''. Una oportunidad para ver grupos que vienen de toda Andalucía a concursar.', info_url = 'https://www.bacantix.com/'
WHERE external_id = 20;

-- COAC 2026: Preliminares (Sesión 9) (external_id: 21)
UPDATE public.events
SET description = 'El lunes también es carnavalero en Cádiz. Destaca la Comparsa ''La marinera'' con letras dedicadas al mar y a la historia de la ciudad. El concurso no descansa hasta completar las sesiones iniciales.', info_url = 'https://www.bacantix.com/'
WHERE external_id = 21;

-- COAC 2026: Preliminares (Sesión 10) (external_id: 22)
UPDATE public.events
SET description = 'Cruzamos el ecuador de preliminares. Esta noche el Coro ''Café Puerto América'' pone la nota musical clásica con su batea. Una sesión para los puristas del tango gaditano.', info_url = 'https://www.bacantix.com/'
WHERE external_id = 22;

-- COAC 2026: Preliminares (Sesión 11) (external_id: 23)
UPDATE public.events
SET description = 'Día 11 del certamen. Grupos de chirigotas locales compiten por un puesto en cuartos. La competencia se endurece y las risas están aseguradas con los grupos más ingeniosos de la provincia.', info_url = 'https://www.bacantix.com/'
WHERE external_id = 23;

-- Andalucía Pre-Sunshine Tour: Competición CSI3* (external_id: 24)
UPDATE public.events
SET description = 'Segunda fase de preparación para el gran tour de febrero. Jinetes internacionales de primer nivel saltan obstáculos de hasta 1.50m. Las instalaciones cuentan con zonas infantiles y gran oferta de restauración para pasar el día en familia.', info_url = 'https://sunshinetour.net/'
WHERE external_id = 24;

-- COAC 2026: Preliminares (Sesión 12) (external_id: 25)
UPDATE public.events
SET description = 'Sesión protagonizada por el Coro ''Las gladitanas'', primer coro íntegramente femenino de la historia del certamen. Una noche histórica para el feminismo en el carnaval.', info_url = 'https://www.bacantix.com/'
WHERE external_id = 25;

-- Andalucía Pre-Sunshine Tour: Saltos de Potencia (external_id: 26)
UPDATE public.events
SET description = 'Jornada espectacular donde se pone a prueba la fuerza física de los caballos. Pruebas de velocidad y precisión en pistas de arena y hierba. Acceso libre para ver a los mejores del mundo.', info_url = 'https://sunshinetour.net/'
WHERE external_id = 26;

-- COAC 2026: Preliminares (Sesión 13) - Noche de Estrellas (external_id: 27)
UPDATE public.events
SET description = 'Probablemente la sesión con más expectación de la fase. Regreso de David Carapapa con la Comparsa ''El joyero''. Las colas en la taquilla y los servidores web suelen colapsar para esta fecha.', info_url = 'https://www.bacantix.com/'
WHERE external_id = 27;

-- GT Winter Series: Entrenamientos Oficiales (external_id: 28)
UPDATE public.events
SET description = 'El rugir de los motores llega al trazado jerezano. Competición europea de GTs y Prototipos. Se puede disfrutar de los entrenamientos libres y la clasificación desde la grada principal gratuita. Una experiencia brutal para amantes de la velocidad.', info_url = 'https://www.circuitodejerez.com/'
WHERE external_id = 28;

-- Andalucía Pre-Sunshine Tour: Small Tour GP (external_id: 29)
UPDATE public.events
SET description = 'Finales de las categorías intermedias de salto. Ambiente internacional en Vejer. Los jinetes ajustan sus estrategias para el gran cierre de mañana.', info_url = 'https://sunshinetour.net/'
WHERE external_id = 29;

-- COAC 2026: Preliminares (Sesión 14) - Noche de Sábado (external_id: 30)
UPDATE public.events
SET description = 'El Falla es una fiesta. Actuación destacada del Coro ''La esencia''. Los grupos locales de chirigotas traen la risa más canalla en una noche que se alarga hasta la madrugada en los bares del centro.', info_url = 'https://www.bacantix.com/'
WHERE external_id = 30;

-- Fútbol LaLiga: Cádiz CF vs Granada CF (external_id: 31)
UPDATE public.events
SET description = 'El gran derbi andaluz de la segunda vuelta. Dos equipos históricos peleando por el ascenso. El Estadio Nuevo Mirandilla se tiñe de amarillo para recibir a los nazaríes en un partido de máxima tensión deportiva.', info_url = 'https://entradascadizcf.com/'
WHERE external_id = 31;

-- GT Winter Series: Carreras de Resistencia y Sprint (external_id: 32)
UPDATE public.events
SET description = 'Día principal del evento de motor. Carreras consecutivas de GT3, GT4 y prototipos deportivos. El paddock suele estar abierto mediante entrada especial. Velocidad pura en la cuna del motor andaluza.', info_url = 'https://www.circuitodejerez.com/'
WHERE external_id = 32;

-- Musical Infantil: 'El Reino del León' (external_id: 33)
UPDATE public.events
SET description = 'Gran tributo musical inspirado en la película El Rey León. Con voces en directo, coreografías espectaculares y puesta en escena ideal para los más pequeños de la casa. Un plan cultural perfecto para el domingo.', info_url = 'https://www.tickentradas.com/'
WHERE external_id = 33;

-- XXXIX Ostionada Popular: Carnaval en el Paladar (external_id: 34)
UPDATE public.events
SET description = 'Uno de los eventos gastronómicos previos al Carnaval más famosos. La peña El Molino reparte gratis cientos de kilos de ostiones, pimientos y cerveza mientras coros de carnaval actúan en directo sobre bateas. Tradición pura en la calle.', info_url = 'https://carnaval-de-cadiz.com/'
WHERE external_id = 34;

-- COAC 2026: Cuartos de Final (Sesión 1) - Comienza la Verdad (external_id: 35)
UPDATE public.events
SET description = 'Inicio de la fase eliminatoria real. Solo los mejores grupos de preliminares llegan aquí. El nivel de competencia sube exponencialmente y las letras empiezan a ser mucho más críticas e incisivas.', info_url = 'https://www.bacantix.com/'
WHERE external_id = 35;

-- Noche de Flamenco Jondo: Peña Buena Gente (external_id: 36)
UPDATE public.events
SET description = 'Recital tradicional en el corazón de Jerez. Cante, toque y baile sin megafonía ni artificios. Experiencia 100% auténtica para entender el arte andaluz en su entorno natural.', info_url = 'https://www.facebook.com/penabuenagente/'
WHERE external_id = 36;

-- Pregón Infantil del Carnaval de Cádiz 2026 (external_id: 37)
UPDATE public.events
SET description = 'Acto oficial en el que los niños y niñas inauguran su propia fiesta. Con la actuación de las mejores agrupaciones infantiles del COAC. El futuro del carnaval toma el mando en la plaza principal.', info_url = 'https://carnaval-de-cadiz.com/'
WHERE external_id = 37;

-- COAC 2026: Cuartos de Final (Sesión 2) (external_id: 38)
UPDATE public.events
SET description = 'Segunda noche de la fase de cuartos. 8 agrupaciones se juegan el pase a semifinales. Una de las noches más largas y emocionantes del certamen por la calidad de los grupos que coinciden.', info_url = 'https://www.bacantix.com/'
WHERE external_id = 38;

-- Presentación Oficial del Carnaval de Chipiona 2026 (external_id: 39)
UPDATE public.events
SET description = 'Gala inaugural de uno de los carnavales con más solera de la Costa Noroeste. Coronación de la Perla del Carnaval y avance de las coplas locales. Mucho humor y color.', info_url = 'https://www.aytochipiona.es/'
WHERE external_id = 39;

-- Desfile de la Cantera: Cabalgata Infantil (external_id: 40)
UPDATE public.events
SET description = 'Colorido desfile por las calles del centro donde participan los grupos infantiles y juveniles del concurso. Carrozas, disfraces y papelillos en una mañana dedicada a los pequeños carnavaleros.', info_url = 'https://carnaval-de-cadiz.com/'
WHERE external_id = 40;

-- XLIV Erizada Popular en la Viña (external_id: 41)
UPDATE public.events
SET description = 'El evento gastronómico por excelencia del barrio más castizo de Cádiz. Degustación gratuita de erizos de mar (erizos de la Caleta) regados con vino de la tierra y coplas en la calle de la Palma. Masivo y divertido.', info_url = 'https://carnaval-de-cadiz.com/'
WHERE external_id = 41;

-- COAC 2026: Cuartos de Final (Sesión 3) (external_id: 42)
UPDATE public.events
SET description = 'Tercera sesión de la fase. Se decide quién empieza a postularse como gran favorito para la final. El teatro suele presentar un lleno absoluto y una vibración única.', info_url = 'https://www.bacantix.com/'
WHERE external_id = 42;

-- COAC 2026: Cuartos de Final (Sesión 4) (external_id: 43)
UPDATE public.events
SET description = 'Cuarta noche de coplas en el Falla. Sesión de lunes donde la crítica política suele ser la gran protagonista de los repertorios. Imprescindible para entender la actualidad local con humor.', info_url = 'https://www.bacantix.com/'
WHERE external_id = 43;

-- Inicio Andalucía Sunshine Tour: Semana 1 oficial (external_id: 44)
UPDATE public.events
SET description = 'Comienza el tour principal con jinetes del Top 100 mundial. Más de 2000 caballos en las instalaciones. Pruebas de ranking para los Juegos y Campeonatos de Europa. Una ciudad dedicada al caballo durante un mes.', info_url = 'https://sunshinetour.net/'
WHERE external_id = 44;

-- COAC 2026: Cuartos de Final (Sesión 6) (external_id: 45)
UPDATE public.events
SET description = 'Noche de nervios. Penúltima sesión de la fase. Los grupos apuran sus mejores letras de pasodoble para intentar amarrar la puntuación que les lleve a la semifinal.', info_url = 'https://www.bacantix.com/'
WHERE external_id = 45;

-- COAC 2026: Cuartos de Final (Sesión Final y Fallo) (external_id: 46)
UPDATE public.events
SET description = 'La noche más tensa fuera de la final. Tras la última actuación, el jurado se retira a deliberar. Alrededor de la 1 o 2 de la mañana se leerán los nombres de los que pasan a la Semifinal.', info_url = 'https://www.bacantix.com/'
WHERE external_id = 46;

-- Recital Flamenco de Solera: Peña Juanito Villar (external_id: 47)
UPDATE public.events
SET description = 'Cante frente al mar. Disfruta de una velada flamenca en una de las peñas con más historia, situada en las antiguas puertas de la Caleta. Flamenco tradicional sin artificios para un público entendido.', info_url = 'https://www.guiadecadiz.com/'
WHERE external_id = 47;

-- Pregón del Carnaval de Arcos de la Frontera (external_id: 48)
UPDATE public.events
SET description = 'El pregón abre oficialmente la fiesta en uno de los pueblos más bellos de España. Discurso satírico, actuación de comparsas locales y posterior fiesta en las plazas del casco antiguo.', info_url = 'https://www.arcosdelafrontera.es/'
WHERE external_id = 48;

-- Teatro de Títeres: La Tía Norica (Función Dominical) (external_id: 49)
UPDATE public.events
SET description = 'Una de las tradiciones culturales más antiguas de Europa. Títeres de peana que representan escenas costumbristas gaditanas con un humor muy particular. Imprescindible para llevar a los niños y conocer el patrimonio de la ciudad.', info_url = 'https://latiamorica.es/'
WHERE external_id = 49;

-- I Chicharronada Popular de Cádiz (external_id: 50)
UPDATE public.events
SET description = 'Nuevo evento gastronómico que nace con fuerza. Degustación del producto estrella de la provincia: el chicharrón (especialmente el de los barrios/pueblos vecinos). Un plan perfecto para tapear en la calle antes del carnaval.', info_url = 'https://transparencia.cadiz.es/'
WHERE external_id = 50;

-- Cádiz Fight Night: El Gran Desafío (Muay Thai) (external_id: 51)
UPDATE public.events
SET description = 'Evento internacional de artes marciales. Los mejores luchadores tailandeses y europeos se dan cita en Cádiz. Despedida oficial de los rings del multicampeón Carlos Coello. Un espectáculo de luces, sonido y adrenalina pura.', info_url = 'https://cadizfightnight.com/'
WHERE external_id = 51;

-- Encendido del Alumbrado Extraordinario de Carnaval (external_id: 52)
UPDATE public.events
SET description = 'Cádiz se ilumina con miles de bombillas led diseñadas específicamente para la fiesta. La ciudad oficializa así que estamos en la semana grande. Mucho ambiente de familias paseando por las calles del centro.', info_url = 'https://carnaval-de-cadiz.com/'
WHERE external_id = 52;

-- La Gran Final del COAC 2026 (external_id: 53)
UPDATE public.events
SET description = 'La noche más esperada del año. Los 15 mejores grupos (coros, comparsas, chirigotas y cuartetos) se disputan los premios en una sesión que dura hasta las 7 u 8 de la mañana del sábado. Un evento seguido por millones de personas en TV y radio.', info_url = 'https://www.bacantix.com/'
WHERE external_id = 53;

-- Pregón del Carnaval (Manu Sánchez) (external_id: 54)
UPDATE public.events
SET description = 'Manu Sánchez ofrece el pregón que abre el carnaval ''en la calle''. Un discurso cargado de emoción, humor andaluz y amor a Cádiz que congrega a miles de personas en la plaza principal. Tras el pregón, las coplas no pararán en 10 días.', info_url = 'https://carnaval-de-cadiz.com/'
WHERE external_id = 54;

-- Domingo de Coros: Carrusel del Mercado (external_id: 55)
UPDATE public.events
SET description = 'El evento más masivo del carnaval callejero. Los coros cantan sobre plataformas llamadas ''bateas'' alrededor del mercado central. El ambiente es increíble: comida, bebida y miles de personas disfrazadas cantando al unísono.', info_url = 'https://carnaval-de-cadiz.com/'
WHERE external_id = 55;

-- Gran Cabalgata Magna del Carnaval de Cádiz (external_id: 56)
UPDATE public.events
SET description = 'Un desfile espectacular con decenas de carrozas, grupos de animación y las agrupaciones premiadas del Falla. El recorrido atraviesa toda la avenida principal de la ciudad lanzando miles de kilos de caramelos. Ideal para ir con niños.', info_url = 'https://carnaval-de-cadiz.com/'
WHERE external_id = 56;

-- Lunes de Carnaval: Carrusel en la Viña (external_id: 57)
UPDATE public.events
SET description = 'Día festivo en Cádiz capital. El carrusel de coros se traslada al barrio de la Viña. Es un ambiente un poco más íntimo y gaditano que el del domingo, perfecto para disfrutar de la gastronomía local mientras escuchas tangos.', info_url = 'https://carnaval-de-cadiz.com/'
WHERE external_id = 57;

-- Gala Inaugural XXX Festival de Jerez: Manuela Carpio (external_id: 58)
UPDATE public.events
SET description = 'Inicio de uno de los festivales de baile flamenco más importantes del mundo. Manuela Carpio presenta ''Raíces del Alma'', un espectáculo que reivindica el flamenco puro de barrio y herencia. El Teatro Villamarta se convierte en el epicentro mundial de la danza.', info_url = 'https://www.festivaldejerez.es/'
WHERE external_id = 58;

-- Cabalgata del Humor de Cádiz (external_id: 59)
UPDATE public.events
SET description = 'El desfile más canalla y creativo. Aquí no hay presupuesto, hay ingenio. Grupos de amigos y familias se disfrazan con temáticas satíricas y recorren el centro histórico. Es el verdadero carnaval de la calle.', info_url = 'https://carnaval-de-cadiz.com/'
WHERE external_id = 59;

-- Quema de la Bruja Piti y Fuegos Artificiales (external_id: 60)
UPDATE public.events
SET description = 'Acto de clausura oficial del Carnaval de Cádiz. Se quema una gran figura simbólica que representa todo lo malo del año. La noche termina con un espectáculo piromusical en el castillo frente al mar. El fin de fiesta perfecto.', info_url = 'https://carnaval-de-cadiz.com/'
WHERE external_id = 60;

-- Fútbol Regional: CD Guadiaro vs Barbate CF (external_id: 61)
UPDATE public.events
SET description = 'Encuentro de fútbol de categoría regional. Un duelo directo entre dos equipos míticos de la provincia. Ambiente de fútbol de barro, auténtico y con una afición muy entregada en las gradas de La Unión.', info_url = 'https://www.lapreferente.com/'
WHERE external_id = 61;

-- Limpieza de Playa Yerbabuena (Voluntariado) (external_id: 62)
UPDATE public.events
SET description = 'Actividad de concienciación ambiental organizada junto al Open de Surf. Se invita a vecinos y turistas a participar en la recogida de microplásticos y residuos en una de las playas vírgenes más hermosas de Andalucía. Se facilitan materiales.', info_url = 'https://www.barbate.es/delegaciones/medio-ambiente'
WHERE external_id = 62;

-- VIII Carrera Popular El Pilar-Marianistas (external_id: 63)
UPDATE public.events
SET description = 'Una de las carreras populares con más tradición en Jerez. Un circuito urbano apto para todos los niveles que recorre los barrios cercanos al centro educativo. Fomenta el deporte en familia con categorías para todas las edades.', info_url = 'https://cronofinisher.com/'
WHERE external_id = 63;

-- II Trail Villa de El Bosque (Ruta del Majaceite) (external_id: 64)
UPDATE public.events
SET description = 'Carrera de 12 km por uno de los senderos más bonitos de España: el cauce del río Majaceite. Un entorno de vegetación de ribera sombrío y fresco, ideal para disfrutar del trail running sin temperaturas extremas.', info_url = 'https://www.aytoelbosque.es/'
WHERE external_id = 64;

-- Romería de San Sebastián: Convivencia Campestre (external_id: 65)
UPDATE public.events
SET description = 'Gran jornada festiva en honor al patrón de Conil. El pueblo se desplaza en carretas y caballos hasta los pinares para disfrutar de un día de comida, baile y fe. Es una de las romerías más bonitas por su entorno forestal.', info_url = 'https://www.conil.org/'
WHERE external_id = 65;

-- María Parrado: Presentación 'La niña que fui' (external_id: 66)
UPDATE public.events
SET description = 'La voz dulce y potente de la artista chiclanera presenta su gira más íntima. Un concierto que repasa su trayectoria y sus nuevos temas pop con influencias de autor. Una noche muy especial en su tierra natal.', info_url = 'https://www.chiclana.es/delegaciones/cultura'
WHERE external_id = 66;

-- VI Ruta MTB Barbate: Los Alcornocales (external_id: 67)
UPDATE public.events
SET description = 'Competición de Mountain Bike de 47 km que recorre el espectacular Parque Natural de la Breña y las Marismas del Barbate. Combina dunas de arena, pinares y acantilados con vistas al Estrecho de Gibraltar.', info_url = 'https://www.dorsalchip.es/'
WHERE external_id = 67;

-- IV Media Maratón Monumental Ciudad de Arcos (external_id: 68)
UPDATE public.events
SET description = 'Una carrera mítica por su dureza y belleza. Recorre los 21 km que separan la zona baja del casco histórico, subiendo por las famosas cuestas de Arcos hasta la Plaza del Cabildo. Paisajes de postal en cada kilómetro.', info_url = 'https://www.arcosdelafrontera.es/'
WHERE external_id = 68;

-- XII Víboras Trail: Maratón de Montaña (external_id: 69)
UPDATE public.events
SET description = 'Una de las pruebas más extremas de Andalucía. 42 km con un desnivel positivo de más de 2500m por la Sierra de Líjar. Solo para corredores preparados que quieran tocar el cielo de Cádiz.', info_url = 'https://www.viboras-trail.com/'
WHERE external_id = 69;

-- Kayak por las Marismas: Especial San Valentín (external_id: 70)
UPDATE public.events
SET description = 'Ruta guiada en kayak por el caño de Sancti Petri. Una experiencia romántica y tranquila en plena naturaleza donde se explica la biodiversidad de las marismas y se visita la zona del castillo desde el agua.', info_url = 'https://www.novojet.net/'
WHERE external_id = 70;

-- DERBI Futsal: Virgili Cádiz vs Xerez Toyota Nimauto (external_id: 71)
UPDATE public.events
SET description = 'El partido del año en el fútbol sala provincial. Máxima rivalidad, gradas llenas y espectáculo deportivo de alto nivel en la Segunda División B. Imprescindible para los amantes del deporte de sala.', info_url = 'https://www.virgilicadiz.com/'
WHERE external_id = 71;

-- Vía Crucis Oficial de Hermandades y Cofradías (external_id: 72)
UPDATE public.events
SET description = 'El primer lunes de Cuaresma se celebra el acto que marca la cuenta atrás para la Semana Santa. Una imagen sagrada es trasladada en andas hasta la Catedral en un ambiente de silencio y recogimiento único.', info_url = 'https://consejohermandadescadiz.es/'
WHERE external_id = 72;

-- Concierto Orquesta de Algeciras: Antología Andaluza (external_id: 73)
UPDATE public.events
SET description = 'La orquesta sinfónica de la ciudad ofrece un repertorio dedicado a los grandes compositores andaluces (Falla, Turina, Albéniz) en la víspera del día de la comunidad. Un evento de alta calidad musical.', info_url = 'https://www.algeciras.es/'
WHERE external_id = 73;

-- Torneo Día de Andalucía de Golf: Sotogrande Cup (external_id: 74)
UPDATE public.events
SET description = 'Competición amateur abierta a jugadores federados en uno de los campos más exclusivos del mundo. Ambiente de alto nivel y premios especiales por el día festivo autonómico.', info_url = 'https://www.golfsotogrande.com/'
WHERE external_id = 74;

-- Día de Andalucía: Izada de Bandera y Actos Oficiales (external_id: 75)
UPDATE public.events
SET description = 'Acto institucional principal donde se celebra la autonomía andaluza. Incluye izado de bandera, interpretación del himno por bandas locales y, en muchos casos, degustaciones de productos típicos y conciertos de bandas de música.', info_url = 'https://www.juntadeandalucia.es/'
WHERE external_id = 75;

-- Exposición Permanente: Los Sarcófagos Fenicios (external_id: 76)
UPDATE public.events
SET description = 'Visita las piezas arqueológicas más importantes de Cádiz. Dos sarcófagos únicos en el mundo que explican la fundación de Gadir por los fenicios. Una visita obligada para entender por qué Cádiz es la ciudad más antigua de occidente.', info_url = 'https://www.museosdeandalucia.es/'
WHERE external_id = 76;

-- COAC 2026: Cuartos de Final (Noche 1) (external_id: 77)
UPDATE public.events
SET description = 'Primer día de la fase más esperada por los aficionados. Las mejores 8 agrupaciones de preliminares estrenan nuevos pasodobles y cuplés. La exigencia es máxima y el ambiente en el teatro está al rojo vivo.', info_url = 'https://www.bacantix.com/'
WHERE external_id = 77;

-- Futsal: Virgili Cádiz vs UD Alchoyano (external_id: 78)
UPDATE public.events
SET description = 'Partido de liga de fútbol sala. Los de la capital necesitan los puntos para seguir en la zona alta de la tabla frente a un rival rocoso que viene con ganas de dar la sorpresa en el pabellón municipal.', info_url = 'https://www.virgilicadiz.com/'
WHERE external_id = 78;

-- Teatro: Los Lunes al Sol (Adaptación Teatral) (external_id: 79)
UPDATE public.events
SET description = 'Basada en la mítica película de Fernando León de Aranoa. La historia de la dignidad de unos hombres en paro en el norte de España se traslada al escenario con una puesta en escena cruda y emocionante. Imprescindible para amantes del drama social.', info_url = 'https://www.tickentradas.com/'
WHERE external_id = 79;

-- Anti-San Valentín Party en Bereber (external_id: 80)
UPDATE public.events
SET description = 'La fiesta más gamberra de la provincia para solteros y gente que odia los convencionalismos. Sesión especial de DJ con hits de los 90, 2000 y actual. Disfraces, regalos y el mejor ambiente nocturno en el patio de una casa palacio jerezana.', info_url = 'https://bereberjerez.com/'
WHERE external_id = 80;

-- Festival de Jerez: Niño de los Reyes 'Vuelta al Sol' (external_id: 81)
UPDATE public.events
SET description = 'Espectáculo de baile flamenco donde la técnica zapateada llega a niveles asombrosos. El Niño de los Reyes es uno de los bailaores más en forma del panorama actual, mezclando tradición y virtuosismo.', info_url = 'https://www.festivaldejerez.es/'
WHERE external_id = 81;

-- Festival de Jerez: Eduardo Guerrero (external_id: 82)
UPDATE public.events
SET description = 'El bailaor gaditano presenta su propuesta estética y vanguardista. Conocido por su elegancia y su fuerza física en el escenario, Guerrero es uno de los grandes atractivos del festival este año.', info_url = 'https://www.festivaldejerez.es/'
WHERE external_id = 82;

-- Noche de Rock: Tributo a Héroes del Silencio (external_id: 83)
UPDATE public.events
SET description = 'La banda ''Iberia Sumergida'' repasa los grandes éxitos de Bunbury y compañía en una sala con sonido espectacular. Una noche para la nostalgia y el rock potente en directo.', info_url = 'https://www.instagram.com/sohocadiz/'
WHERE external_id = 83;

-- Taller de Máscaras de Carnaval para Niños (external_id: 84)
UPDATE public.events
SET description = 'Actividad creativa donde los más pequeños aprenden a fabricar sus propios antifaces y máscaras usando materiales reciclados. Impartido por artistas locales de la plástica. Una forma divertida de empezar el carnaval.', info_url = 'https://institucional.cadiz.es/area/cultura'
WHERE external_id = 84;

-- Tardeo de Invierno en El Puerto: Iroko Garden (external_id: 85)
UPDATE public.events
SET description = 'La fiesta de tarde definitiva. Música en directo desde las 17h seguido de sesión DJ con hits comerciales y ambiente ''casual''. La mejor forma de disfrutar de la tarde del sábado con amigos en un espacio semicubierto.', info_url = 'https://www.instagram.com/irokopsm/'
WHERE external_id = 85;

-- Degustación de 'Pringá' Popular (external_id: 86)
UPDATE public.events
SET description = 'Evento típico de Chiclana donde se reparten cientos de montaditos de ''pringá'' (carne del cocido desmenuzada) para celebrar el domingo de carnaval. Acompañado de actuaciones de agrupaciones locales de Chiclana.', info_url = 'https://www.chiclana.es/'
WHERE external_id = 86;

-- Tagarninada Popular: Platos del Día de Andalucía (external_id: 87)
UPDATE public.events
SET description = 'Gran olla común de tagarninas ''esparragás'', un plato humilde y exquisito de la sierra gaditana. Convivencia entre vecinos y música popular para celebrar el día festivo andaluz por todo lo alto.', info_url = 'https://www.guiadecadiz.com/'
WHERE external_id = 87;

-- Ensayo Solidario de Costaleros: 'Un kilo de coplas' (external_id: 88)
UPDATE public.events
SET description = 'Las cuadrillas de costaleros ensayan con la parihuela por las calles, pero en lugar de pesas llevan alimentos donados por los vecinos. Un espectáculo visual y auditivo (con bandas de música) que sirve para una causa benéfica.', info_url = 'https://www.uniondehermandades.com/'
WHERE external_id = 88;

-- Panizada Popular: Fritura de Panizas (external_id: 89)
UPDATE public.events
SET description = 'Se reparten de forma gratuita las famosas panizas (harina de garbanzo frita), un manjar casi olvidado de la gastronomía gaditana. Un evento ideal para reponer fuerzas durante la tarde del sábado de carnaval.', info_url = 'https://www.guiadecadiz.com/'
WHERE external_id = 89;

-- Rastro de Antigüedades de Algeciras (external_id: 90)
UPDATE public.events
SET description = 'Mercadillo de segunda mano y coleccionismo en el entorno de la plaza de toros. Libros viejos, vinilos, monedas, muebles restaurados y mil curiosidades para los amantes de lo vintage.', info_url = 'https://www.algeciras.es/'
WHERE external_id = 90;

-- Visita Guiada: Baelo Claudia Romano (external_id: 91)
UPDATE public.events
SET description = 'Recorrido por las ruinas de la ciudad romana de Baelo Claudia, junto a la playa de Bolonia. Incluye explicación sobre la industria del Garum y el teatro romano. Imprescindible para entender la herencia latina en la provincia.', info_url = 'https://www.museosdeandalucia.es/'
WHERE external_id = 91;

-- Mercado de Artesanía y Disfraces (external_id: 92)
UPDATE public.events
SET description = 'Especial de carnaval. Puestos de artesanos locales que ofrecen desde complementos para disfraces hechos a mano hasta productos típicos de marroquinería de la provincia.', info_url = 'https://institucional.cadiz.es/'
WHERE external_id = 92;

-- Concentración de Coches Clásicos y Motor de Época (external_id: 93)
UPDATE public.events
SET description = 'Exhibición de vehículos con más de 30 años de antigüedad. Joyas del motor mantenidas por coleccionistas locales. Ideal para pasear y hacerse fotos con coches históricos en el recinto ferial.', info_url = 'https://www.puertoreal.es/'
WHERE external_id = 93;

-- Certamen de Romanceros en los Rincones (external_id: 94)
UPDATE public.events
SET description = 'La esencia más pura del humor gaditano. Personas individuales o en pareja cuentan historias en verso con ayuda de carteles ilustrados. El humor es inteligente, local e irreverente. Se encuentran en cualquier esquina del barrio del Pópulo.', info_url = 'https://carnaval-de-cadiz.com/'
WHERE external_id = 94;

-- XXX Fritada Popular de Pescado: Carnaval de Despedida (external_id: 95)
UPDATE public.events
SET description = 'Evento final de carnaval en la Plaza de España. Reparto de pescado frito gratuito (boquerones, acedías, pescadilla) a cargo de las peñas de la zona. Es el último gran almuerzo popular antes de que acabe la fiesta.', info_url = 'https://www.guiadecadiz.com/'
WHERE external_id = 95;

-- Cineclub San Fernando: Ciclo de Autor (external_id: 96)
UPDATE public.events
SET description = 'Proyección de cine independiente y de autor en versión original subtitulada. Incluye un pequeño coloquio tras la película para analizar los detalles técnicos y narrativos de la obra.', info_url = 'https://www.sanfernando.es/'
WHERE external_id = 96;

-- Conferencia: 'Cádiz y el Monopolio de Indias' (external_id: 97)
UPDATE public.events
SET description = 'Charla histórica impartida por expertos de la Universidad de Cádiz. Explora la época dorada de la ciudad cuando era el puerto principal del comercio con América. Muy interesante para comprender la arquitectura de las casas-palacio.', info_url = 'https://ateneodecadiz.es/'
WHERE external_id = 97;

-- Fútbol Juvenil: Cádiz CF vs Arenas de Armilla (external_id: 98)
UPDATE public.events
SET description = 'Máxima categoría juvenil española (División de Honor). Una oportunidad para ver a los talentos que en 1 o 2 años estarán en el fútbol profesional. Las instalaciones del Rosal ofrecen un ambiente de fútbol base muy cercano.', info_url = 'https://www.cadizcf.com/cantera'
WHERE external_id = 98;

-- Fútbol Infantil: Cádiz CF 'A' vs Real Betis (external_id: 99)
UPDATE public.events
SET description = 'Encuentro de élite infantil. El Real Betis, una de las mejores canteras del mundo, visita Cádiz. Un partido con scoutings internacionales presentes y un nivel de juego sorprendente para niños de 13-14 años.', info_url = 'https://www.cadizcf.com/cantera'
WHERE external_id = 99;

-- Mercadillo del Coleccionismo de Jerez (external_id: 100)
UPDATE public.events
SET description = 'Espacio para el intercambio y venta de monedas, sellos, cómics y objetos antiguos. Es el lugar ideal para completar colecciones o simplemente curiosear objetos con historia en pleno centro de la ciudad.', info_url = 'https://www.jerez.es/'
WHERE external_id = 100;

-- COAC 2026: Semifinales (Día 1) (external_id: 101)
UPDATE public.events
SET description = 'Comienza la fase decisiva del concurso. Aquí se presentan las letras más esperadas y valientes. El nivel es el más alto de todo el carnaval. Solo las agrupaciones punteras pisan hoy estas tablas.', info_url = 'https://www.bacantix.com/'
WHERE external_id = 101;

-- COAC 2026: Semifinales (Día 2) (external_id: 102)
UPDATE public.events
SET description = 'Segunda noche de semifinales. La ciudad se paraliza para escuchar las coplas que sonarán durante toda la semana en la calle. Crítica social y música en estado puro.', info_url = 'https://www.bacantix.com/'
WHERE external_id = 102;

-- COAC 2026: Semifinales (Día 3) (external_id: 103)
UPDATE public.events
SET description = 'Tercera jornada de la fase. Se empiezan a intuir los candidatos claros a la gran final del viernes. El teatro es un polvorín de emociones y nerviosismo en bambalinas.', info_url = 'https://www.bacantix.com/'
WHERE external_id = 103;

-- COAC 2026: Semifinales (Día Final) (external_id: 104)
UPDATE public.events
SET description = 'Última noche para convencer al jurado. Al término de la sesión, se leen los nombres de los finalistas. La plaza del Falla se llena de aficionados esperando el veredicto.', info_url = 'https://www.bacantix.com/'
WHERE external_id = 104;

-- Concierto Jazz: The Chameleons (external_id: 105)
UPDATE public.events
SET description = 'Banda de jazz-fusión que mezcla ritmos latinos con la elegancia del jazz clásico. Una noche diferente en el barrio más antiguo de la ciudad, ideal para disfrutar de música en vivo tras la cena.', info_url = 'https://www.facebook.com/elmusicariocadiz/'
WHERE external_id = 105;

-- Concierto de Cuaresma: Banda Maestro Dueñas (external_id: 106)
UPDATE public.events
SET description = 'Recital sinfónico dedicado a las marchas procesionales de Semana Santa. Interpretación de piezas clásicas y estrenos locales en un ambiente que ya huele a incienso y azahar.', info_url = 'https://www.elpuertodesantamaria.es/cultura'
WHERE external_id = 106;

-- Festival de Jerez: Olga Pericet presenta 'La Materia' (external_id: 107)
UPDATE public.events
SET description = 'Danza española y flamenca en su máxima expresión. Olga Pericet es una artista que rompe moldes visuales y conceptuales, siendo una de las citas ineludibles del festival este año.', info_url = 'https://www.festivaldejerez.es/'
WHERE external_id = 107;

-- Festival de Jerez: Estévez y Paños 'Doncellas' (external_id: 108)
UPDATE public.events
SET description = 'Propuesta innovadora de una de las parejas de coreógrafos más premiadas del país. Un espectáculo que explora la mitología y la danza clásica con pinceladas flamencas muy actuales.', info_url = 'https://www.festivaldejerez.es/'
WHERE external_id = 108;

-- Festival de Jerez: Carmen Herrera 'GhERRERA' (external_id: 109)
UPDATE public.events
SET description = 'Homenaje al barrio de Santiago a través del baile de Carmen Herrera. Un espectáculo con mucha gitanería, fuerza y el sello inconfundible del flamenco de Jerez.', info_url = 'https://www.festivaldejerez.es/'
WHERE external_id = 109;

-- Festival de Jerez: Gran Clausura de Febrero (external_id: 110)
UPDATE public.events
SET description = 'Ceremonia especial y espectáculo de primer nivel para despedir la programación del mes. Reúne a varias figuras del baile y cante en una noche de celebración del arte flamenco.', info_url = 'https://www.festivaldejerez.es/'
WHERE external_id = 110;

-- Ensayo General Chirigota del Selu (external_id: 111)
UPDATE public.events
SET description = 'Una oportunidad única de ver la agrupación del Selu antes de que pise las tablas del Falla. El ensayo general es abierto al público en su peña, donde se pulen los últimos detalles de la actuación.', info_url = 'https://www.guiadecadiz.com/'
WHERE external_id = 111;

-- Ruta Ornitológica: Avistamiento de Invierno (external_id: 112)
UPDATE public.events
SET description = 'Salida guiada para observar las aves migratorias que pasan el invierno en las marismas de la Bahía de Cádiz. Se incluye material de observación y guía especializado. Ideal para aficionados a la naturaleza.', info_url = 'https://parquedelabahia.es/'
WHERE external_id = 112;

-- Senderismo: Los Alcornocales - Ruta del Agua (external_id: 113)
UPDATE public.events
SET description = 'Ruta circular por el corazón del Parque Natural de los Alcornocales. Caminaremos junto a arroyos cristalinos y bosques de niebla. Dificultad baja, apta para familias con niños acostumbrados a caminar.', info_url = 'https://www.juntadeandalucia.es/'
WHERE external_id = 113;

-- Gran Arroz Popular en Benalup (external_id: 114)
UPDATE public.events
SET description = 'Para celebrar el Día de Andalucía, el pueblo organiza una gran paella popular para miles de personas. Ambiente festivo con música de orquesta y juegos infantiles en el centro del municipio.', info_url = 'https://www.benalupcasasviejas.es/'
WHERE external_id = 114;

-- Ortigada Popular: Sabores del Mar (external_id: 115)
UPDATE public.events
SET description = 'Reparto gratuito de ortiguillas fritas (anémonas de mar), un manjar con sabor a océano puro. El evento se acompaña de agrupaciones de carnaval que animan la degustación. Muy típico del casco antiguo.', info_url = 'https://www.guiadecadiz.com/'
WHERE external_id = 115;

-- Zambomba de Invierno: Especial Flamenco (external_id: 116)
UPDATE public.events
SET description = 'Aunque las zambombas son navideñas, muchas peñas mantienen ciclos de cante tradicional para abrir el año. Villancicos flamencos a ritmo de bulería en un ambiente de convivencia vecinal.', info_url = 'https://perladecadiz.com/'
WHERE external_id = 116;

-- Rugby: Atlético Portuense vs CD Universidad (external_id: 117)
UPDATE public.events
SET description = 'Partido de la liga nacional de rugby. Deporte de contacto, valores y un gran ''tercer tiempo'' abierto al público donde se disfruta de la convivencia entre aficiones.', info_url = 'https://www.rugbyportuense.com/'
WHERE external_id = 117;

-- Yoga en la Playa de la Barrosa (external_id: 118)
UPDATE public.events
SET description = 'Sesión especial por el Día de Andalucía al aire libre. Clase apta para todos los niveles con el sonido del mar de fondo. Se recomienda traer esterilla y ropa cómoda. Una forma zen de empezar el festivo.', info_url = 'https://www.chiclana.es/'
WHERE external_id = 118;

-- Sesión DJ Vinilo: Funk & Soul (external_id: 119)
UPDATE public.events
SET description = 'Una noche dedicada a la música analógica. DJ local pincha joyas del funk y soul de los 70 en formato vinilo. Ambiente relajado, cócteles y buen sonido en el corazón de Cádiz.', info_url = 'https://www.facebook.com/'
WHERE external_id = 119;

-- Fiesta Post-Final Falla: Noche de Carnaval (external_id: 120)
UPDATE public.events
SET description = 'Cuando termina el teatro, la fiesta empieza en las discotecas. Sesión especial donde se alternan coplas de carnaval con hits actuales. Es la noche más larga del año en la capital.', info_url = 'https://www.instagram.com/sohocadiz/'
WHERE external_id = 120;

-- Ciclo Cine y Gastronomía: Proyección y Cata (external_id: 121)
UPDATE public.events
SET description = 'Visualización de un documental sobre la cultura del vino en el Marco de Jerez seguido de una cata comentada por un enólogo profesional. Una experiencia sensorial completa.', info_url = 'https://www.jerez.es/cultura'
WHERE external_id = 121;

-- Batalla de Coplas en el Paseo Marítimo (external_id: 122)
UPDATE public.events
SET description = 'Los grupos que no pasaron a la final se reúnen en escenarios portátiles a pie de playa para cantar sus repertorios. Un ambiente muy familiar y con olor a salitre.', info_url = 'https://carnaval-de-cadiz.com/'
WHERE external_id = 122;

-- Concierto Acústico: Cantautores de Cádiz (external_id: 123)
UPDATE public.events
SET description = 'Música de autor en un local con mucho encanto. Letras cuidadas, guitarras españolas y un ambiente bohemio para la tarde del domingo.', info_url = 'https://www.facebook.com/elpelicano/'
WHERE external_id = 123;

-- Fútbol Femenino: San Fernando CD vs Algeciras CF (external_id: 124)
UPDATE public.events
SET description = 'Partido oficial de la liga andaluza femenina. Un encuentro de mucha entrega y calidad técnica en el estadio Iberoamericano.', info_url = 'https://sfcd.es/'
WHERE external_id = 124;

-- Izado de Bandera: Sanlúcar de Barrameda (external_id: 125)
UPDATE public.events
SET description = 'Acto solemne por el Día de Andalucía con la presencia de autoridades locales y la Banda de Música Municipal interpretando pasodobles y el himno andaluz.', info_url = 'https://www.sanlucardebarrameda.es/'
WHERE external_id = 125;

-- Inauguración: Exposición Fotográfica 'Cádiz en B/N' (external_id: 126)
UPDATE public.events
SET description = 'Muestra del fotógrafo local Paco Medina que recorre los rincones de la ciudad durante el siglo XX. Un viaje nostálgico por las calles y rostros gaditanos.', info_url = 'https://institucional.cadiz.es/'
WHERE external_id = 126;

-- Club de Lectura: Especial Novela Negra Gaditana (external_id: 127)
UPDATE public.events
SET description = 'Reunión de aficionados a la lectura para analizar obras de autores locales de suspense. Incluye intercambio de libros y café.', info_url = 'https://www.chiclana.es/'
WHERE external_id = 127;

-- Jam Session de Jazz: Lunes Musicales (external_id: 128)
UPDATE public.events
SET description = 'Músicos locales e invitados se reúnen para improvisar en directo. Un ambiente cosmopolita y creativo perfecto para terminar el primer lunes de la semana.', info_url = 'https://www.facebook.com/elmusicario/'
WHERE external_id = 128;

-- Ruta en Kayak: Castillo de Sancti Petri (external_id: 129)
UPDATE public.events
SET description = 'Excursión por el mar hasta la isla del castillo de Hércules. Se explica la mitología de la zona y la historia de los fenicios en la Bahía.', info_url = 'https://www.kayakcadiz.com/'
WHERE external_id = 129;

-- Torneo de Pádel Solidario (external_id: 130)
UPDATE public.events
SET description = 'Competición por parejas en beneficio de la Asociación Local contra el Cáncer. Niveles amateur y avanzado con premios para los ganadores.', info_url = 'https://www.elpuertodesantamaria.es/deportes'
WHERE external_id = 130;

-- Concierto Flamenco: Tributo a Camarón (external_id: 131)
UPDATE public.events
SET description = 'Un repaso por los temas más emblemáticos del genio de la Isla. Guitarra, cante y palmas en un ambiente que respira respeto por el flamenco más puro.', info_url = 'https://ventadevargas.es/'
WHERE external_id = 131;

-- Cata de Vinos del Marco de Jerez (external_id: 132)
UPDATE public.events
SET description = 'Descubre los secretos del Fino, el Amontillado y el Oloroso. Incluye maridaje con quesos de la Sierra de Cádiz y explicación técnica sobre la crianza en botas.', info_url = 'https://www.tiopepe.com/visitas'
WHERE external_id = 132;

-- Concierto: Grupo de Rock Local 'Los Atómicos' (external_id: 133)
UPDATE public.events
SET description = 'Banda de versiones de rock español de los 80 y 90. Diversión asegurada para cerrar el día de Andalucía con energía.', info_url = 'https://www.instagram.com/sohocadiz/'
WHERE external_id = 133;

-- Taller de Teatro para Mayores (external_id: 134)
UPDATE public.events
SET description = 'Espacio de creación escénica para personas mayores de 60 años. Se trabajan técnicas de expresión corporal, voz y memoria a través de textos clásicos.', info_url = 'https://www.algeciras.es/'
WHERE external_id = 134;

-- Carnaval de los Colegios: Desfile Escolar (external_id: 135)
UPDATE public.events
SET description = 'Cientos de niños disfrazados recorren el centro histórico con sus centros escolares. Es un momento de gran ternura y color que marca el inicio de la fiesta para los más pequeños.', info_url = 'https://carnaval-de-cadiz.com/'
WHERE external_id = 135;

-- Tortillada Popular: Especial Camarones (external_id: 136)
UPDATE public.events
SET description = 'Degustación de tortillitas de camarones recién hechas. Un evento que atrae a cientos de personas por el sabor inigualable de este plato típico gaditano.', info_url = 'https://www.guiadecadiz.com/'
WHERE external_id = 136;

-- Ruta MTB: Los Alcornocales Extremo (external_id: 137)
UPDATE public.events
SET description = 'Carrera técnica de 60 km por pistas forestales. Solo para ciclistas experimentados con buena preparación física. Incluye avituallamiento y asistencia.', info_url = 'https://www.jimenadelafrontera.es/'
WHERE external_id = 137;

-- Exposición de Belenes: Clausura (external_id: 138)
UPDATE public.events
SET description = 'Último día para visitar los belenes artesanales de la ciudad. Una tradición de gran calidad artística que cuenta con piezas de escultores famosos.', info_url = 'https://www.jerez.es/cultura'
WHERE external_id = 138;

-- Fútbol Regional: Arcos CF vs Ubrique UD (external_id: 139)
UPDATE public.events
SET description = 'Partido de la liga andaluza en un entorno de sierra espectacular. Fútbol local con mucha pasión en las gradas.', info_url = 'https://www.lapreferente.com/'
WHERE external_id = 139;

-- Festival de Bandas de Música: Día de Andalucía (external_id: 140)
UPDATE public.events
SET description = 'Varias bandas de la provincia se reúnen para ofrecer un concierto conjunto con marchas andaluzas y piezas clásicas. Una tarde de orgullo y cultura.', info_url = 'https://www.sanlucardebarrameda.es/'
WHERE external_id = 140;

-- Zambomba Solidaria en la Asociación de Vecinos (external_id: 141)
UPDATE public.events
SET description = 'Evento para recaudar fondos para proyectos locales. Cante flamenco, hogueras y comida típica en un ambiente de hermandad vecinal.', info_url = 'https://institucional.cadiz.es/'
WHERE external_id = 141;

-- Concurso de Disfraces en Familia (external_id: 142)
UPDATE public.events
SET description = 'Premio a los disfraces más originales realizados con materiales reciclados. Un evento para que padres e hijos se diviertan juntos en carnaval.', info_url = 'https://www.aytorota.es/'
WHERE external_id = 142;

-- Conferencia de Historia: Baelo Claudia Romano (external_id: 143)
UPDATE public.events
SET description = 'Charla sobre los últimos descubrimientos arqueológicos en la ciudad romana. Muy recomendada para los amantes de la historia antigua.', info_url = 'https://www.algeciras.es/'
WHERE external_id = 143;

-- Paella Gigante en el Parque (external_id: 144)
UPDATE public.events
SET description = 'Almuerzo popular para celebrar el día festivo andaluz. Una oportunidad para comer en familia al aire libre en un entorno natural.', info_url = 'https://www.guiadecadiz.com/'
WHERE external_id = 144;

-- Fútbol Alevín: Cádiz CF vs Puerto Malagueño (external_id: 145)
UPDATE public.events
SET description = 'Partido de la liga andaluza alevín. Las promesas de la provincia se miden con uno de los equipos más fuertes de la región. Emoción juvenil en El Rosal.', info_url = 'https://www.cadizcf.com/cantera'
WHERE external_id = 145;

-- Taller de Pitos de Carnaval (external_id: 146)
UPDATE public.events
SET description = 'Aprende a tocar el pito de carnaval (kazoo) y conoce los ritmos básicos de la percusión gaditana. Actividad para todas las edades.', info_url = 'https://institucional.cadiz.es/'
WHERE external_id = 146;

-- Concierto Acústico de Cantautor (external_id: 147)
UPDATE public.events
SET description = 'Música íntima y letras profundas en una sala con gran acústica. Un plan relajado para la noche del martes.', info_url = 'https://www.facebook.com/sala-pay-pay'
WHERE external_id = 147;

-- Limpieza de Entorno Natural: Voluntariado (external_id: 148)
UPDATE public.events
SET description = 'Acción colectiva para recoger residuos en las dunas de Tarifa. Colaboración con organizaciones ecologistas locales para preservar el paraíso.', info_url = 'https://www.aytotarifa.com/'
WHERE external_id = 148;

-- Triatlón de Invierno: Puerto Sherry (external_id: 149)
UPDATE public.events
SET description = 'Carrera a pie, bicicleta y natación en un entorno privilegiado. Una prueba de resistencia física y mental para atletas experimentados.', info_url = 'https://www.triatlonandalucia.org/'
WHERE external_id = 149;

-- Degustación de Productos de la Sierra (external_id: 150)
UPDATE public.events
SET description = 'Feria gastronómica con quesos, chacinas y vinos de la sierra de Cádiz. Una delicia para el paladar en el día de Andalucía.', info_url = 'https://www.ubrique.es/'
WHERE external_id = 150;

-- Misa Solemne y Ofrenda Floral (external_id: 151)
UPDATE public.events
SET description = 'Acto religioso y civil para celebrar la identidad andaluza. Un momento de reflexión y tradición compartida por los vecinos.', info_url = 'https://www.alcaladelosgazules.es/'
WHERE external_id = 151;

-- Entierro de la Caballa: Fin de Carnaval (external_id: 152)
UPDATE public.events
SET description = 'La despedida humorística de la fiesta. Un cortejo fúnebre muy gracioso termina en la playa con la quema de una caballa gigante. Pescaito frito gratis para los asistentes.', info_url = 'https://carnaval-de-cadiz.com/'
WHERE external_id = 152;

-- Concierto Rock Local: 'Viento de Levante' (external_id: 153)
UPDATE public.events
SET description = 'Energía pura sobre el escenario con temas propios que mezclan rock urbano y raíces andaluzas. Diversión garantizada en una sala emblemática de la ciudad.', info_url = 'https://www.instagram.com/momarttheatre/'
WHERE external_id = 153;

-- Ruta Fotográfica: Pueblos Blancos (external_id: 154)
UPDATE public.events
SET description = 'Recorrido guiado por un fotógrafo profesional por las calles de Olvera. Aprenderemos técnicas de composición mientras capturamos la luz andaluza en sus paredes encaladas.', info_url = 'https://www.olvera.es/'
WHERE external_id = 154;

-- Obra de Teatro: 'La Pasión de Cádiz' (external_id: 155)
UPDATE public.events
SET description = 'Un drama histórico que narra los asedios de la ciudad en el siglo XIX. Una puesta en escena espectacular con actores locales y música en directo.', info_url = 'https://www.bacantix.com/'
WHERE external_id = 155;

-- Concurso de Tapas de Carnaval (external_id: 156)
UPDATE public.events
SET description = 'Varios bares del centro compiten por ofrecer la mejor tapa inspirada en los tipos del carnaval de este año. Una ruta deliciosa para conocer el ingenio culinario gaditano.', info_url = 'https://www.guiadecadiz.com/'
WHERE external_id = 156;

-- Marcha Ciclista por la Autonomía (external_id: 157)
UPDATE public.events
SET description = 'Paseo en bicicleta para todas las edades por el paseo marítimo. Una forma activa y saludable de celebrar el día de Andalucía en familia.', info_url = 'https://www.cadiz.es/'
WHERE external_id = 157;

-- Tertulia Carnavalesca: Pasado y Presente (external_id: 158)
UPDATE public.events
SET description = 'Antiguos autores de carnaval comparten sus experiencias y visiones sobre la evolución de la fiesta. Un momento de aprendizaje y respeto por la tradición.', info_url = 'https://www.casinogaditano.es/'
WHERE external_id = 158;

-- Taller de Poesía de Amor: Especial San Valentín (external_id: 159)
UPDATE public.events
SET description = 'Expresa tus sentimientos a través de la palabra escrita. Un taller para aprender técnicas poéticas y crear tus propios textos románticos.', info_url = 'https://www.puertoreal.es/'
WHERE external_id = 159;

-- Recital de Guitarra Clásica (external_id: 160)
UPDATE public.events
SET description = 'Una velada de música clásica interpretada por un virtuoso de la guitarra. El entorno histórico de la capilla ofrece una acústica inmejorable.', info_url = 'https://www.nazarenodecádiz.com/'
WHERE external_id = 160;

-- Comida de Convivencia Andaluza (external_id: 161)
UPDATE public.events
SET description = 'Almuerzo comunitario donde cada vecino trae un plato para compartir. Música, risas y celebración de la identidad andaluza en la calle.', info_url = 'https://www.sanroque.es/'
WHERE external_id = 161;

-- Vela: Regata de Carnaval (external_id: 162)
UPDATE public.events
SET description = 'Competición de vela ligera en la bahía de Cádiz. Un espectáculo visual desde el paseo marítimo con decenas de barcos compitiendo por el trofeo.', info_url = 'https://www.clubvela.es/'
WHERE external_id = 162;

-- Sesión de Jazz en vivo: Trio 'Aires' (external_id: 163)
UPDATE public.events
SET description = 'Jazz contemporáneo con influencias flamencas. Un concierto elegante y creativo para disfrutar de la buena música en directo.', info_url = 'https://www.ayto-vejer.es/'
WHERE external_id = 163;

-- Degustación de 'Migas' Serranas (external_id: 164)
UPDATE public.events
SET description = 'Plato contundente y tradicional de la sierra para celebrar el domingo de carnaval. Se cocina a la leña en grandes calderos para que todos los asistentes puedan probarlo.', info_url = 'https://www.grazalema.es/'
WHERE external_id = 164;

-- Taller de Carnaval: Crea tu propio Disfraz (external_id: 165)
UPDATE public.events
SET description = 'Aprende a diseñar y fabricar disfraces originales usando cartón, telas y maquillaje. Un taller lúdico para que los niños se preparen para la gran fiesta.', info_url = 'https://www.jerez.es/juventud'
WHERE external_id = 165;

-- Recital de Poesía de Amor: Especial San Valentín (external_id: 166)
UPDATE public.events
SET description = 'Autores locales leen sus obras más románticas en un entorno íntimo y acogedor. Una forma diferente de celebrar el amor a través de la palabra.', info_url = 'https://www.laclandestina.es/'
WHERE external_id = 166;

-- Concierto de Cante Flamenco: Día de Andalucía (external_id: 167)
UPDATE public.events
SET description = 'Recital de cante jondo con artistas locales para celebrar la cultura andaluza. Un evento lleno de sentimiento y tradición en un entorno inigualable.', info_url = 'https://www.aytotarifa.com/'
WHERE external_id = 167;

-- Ruta de Senderismo: Acantilados de Barbate (external_id: 168)
UPDATE public.events
SET description = 'Caminata por el Parque Natural de la Breña. Disfrutaremos de las vistas espectaculares del océano desde los acantilados de más de 100 metros de altura. Dificultad media.', info_url = 'https://www.juntadeandalucia.es/'
WHERE external_id = 168;

-- Mercadillo de Segunda Mano y Artesanía (external_id: 169)
UPDATE public.events
SET description = 'Espacio para comprar y vender objetos curiosos, ropa vintage y productos hechos a mano por artesanos locales. Un ambiente creativo y sostenible.', info_url = 'https://www.jerez.es/'
WHERE external_id = 169;

-- Gran Concierto de Clausura del Día de Andalucía (external_id: 170)
UPDATE public.events
SET description = 'Espectáculo musical con artistas invitados de renombre nacional para cerrar la festividad autonómica. Un evento multitudinario con música para todos los gustos y edades.', info_url = 'https://www.cadiz.es/'
WHERE external_id = 170;


-- Verificar resultados
DO $$
DECLARE
  total_events integer;
  events_with_info_url integer;
  events_with_description integer;
  events_with_external_id integer;
  percentage_info_url numeric;
  percentage_description numeric;
BEGIN
  SELECT COUNT(*) INTO total_events FROM public.events;
  SELECT COUNT(*) INTO events_with_external_id FROM public.events WHERE external_id IS NOT NULL;
  SELECT COUNT(*) INTO events_with_info_url FROM public.events WHERE info_url IS NOT NULL AND info_url != '';
  SELECT COUNT(*) INTO events_with_description FROM public.events WHERE description IS NOT NULL AND description != '';
  
  IF total_events > 0 THEN
    percentage_info_url := ROUND((events_with_info_url::numeric / total_events::numeric) * 100, 2);
    percentage_description := ROUND((events_with_description::numeric / total_events::numeric) * 100, 2);
  ELSE
    percentage_info_url := 0;
    percentage_description := 0;
  END IF;
  
  RAISE NOTICE '📊 Resumen de actualización:';
  RAISE NOTICE '   Total de eventos: %', total_events;
  RAISE NOTICE '   Eventos con external_id: %', events_with_external_id;
  RAISE NOTICE '   Eventos con info_url: % (% %%)', events_with_info_url, percentage_info_url;
  RAISE NOTICE '   Eventos con description: % (% %%)', events_with_description, percentage_description;
END $$;