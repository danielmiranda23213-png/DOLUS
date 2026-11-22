final int TIPO_MENSAJE_NORMAL = 0;
final int TIPO_MENSAJE_CAPCIOSO = 1;

String[] textosUsadosEnRonda = new String[256];
int numTextosUsadosEnRonda = 0;
String[] remitentesUsadosEnRonda = new String[128];
int numRemitentesUsadosEnRonda = 0;

void resetearMensajesUsadosRonda() {
  numTextosUsadosEnRonda = 0;
  numRemitentesUsadosEnRonda = 0;
}

String[] elegirPlantillaSinRepetir(String[][] pool) {
  int total = contarPlantillas2D(pool);
  if (total == 0) return new String[]{"FEED // MENSAJE", "..."};
  int[] libres = new int[256];
  int numLibres = 0;
  int lim = min(total, 256);
  for (int i = 0; i < lim; i++) {
    String llave = pool[i][0] + "|" + pool[i][1];
    if (!arrayContieneTexto(textosUsadosEnRonda, numTextosUsadosEnRonda, llave)) {
      libres[numLibres] = i;
      numLibres++;
    }
  }
  int elegido = (numLibres > 0)
    ? libres[int(random(numLibres))]
    : int(random(total));
  String llaveElegida = pool[elegido][0] + "|" + pool[elegido][1];
  if (!arrayContieneTexto(textosUsadosEnRonda, numTextosUsadosEnRonda, llaveElegida) && numTextosUsadosEnRonda < 256) {
    textosUsadosEnRonda[numTextosUsadosEnRonda] = llaveElegida;
    numTextosUsadosEnRonda++;
  }
  return pool[elegido];
}

String elegirTextoSinRepetir(String[] pool) {
  int total = contarTextos(pool);
  if (total == 0) return "...";
  int[] libres = new int[256];
  int numLibres = 0;
  int lim = min(total, 256);
  for (int i = 0; i < lim; i++) {
    if (!arrayContieneTexto(textosUsadosEnRonda, numTextosUsadosEnRonda, pool[i])) {
      libres[numLibres] = i;
      numLibres++;
    }
  }
  int elegido = (numLibres > 0)
    ? libres[int(random(numLibres))]
    : int(random(total));
  String res = pool[elegido];
  if (!arrayContieneTexto(textosUsadosEnRonda, numTextosUsadosEnRonda, res) && numTextosUsadosEnRonda < 256) {
    textosUsadosEnRonda[numTextosUsadosEnRonda] = res;
    numTextosUsadosEnRonda++;
  }
  return res;
}

String elegirRemitenteSinRepetir(String[] pool) {
  int total = contarTextos(pool);
  if (total == 0) return "Jugador_Anon";
  int[] libres = new int[128];
  int numLibres = 0;
  int lim = min(total, 128);
  for (int i = 0; i < lim; i++) {
    if (!arrayContieneTexto(remitentesUsadosEnRonda, numRemitentesUsadosEnRonda, pool[i])) {
      libres[numLibres] = i;
      numLibres++;
    }
  }
  int elegido = (numLibres > 0)
    ? libres[int(random(numLibres))]
    : int(random(total));
  String rem = pool[elegido];
  if (numLibres > 0 && numRemitentesUsadosEnRonda < 128) {
    remitentesUsadosEnRonda[numRemitentesUsadosEnRonda] = rem;
    numRemitentesUsadosEnRonda++;
  }
  return rem;
}

final String[] REMS_GAMER_NORMALES = {
  "Pixel_Runner", "Lobo_Arcade", "Nova_GG", "Kira_FPS", "Santi_Play",
  "Mago_Retro", "Valen_Crit", "Tomi_Speed", "Neko_Stream", "Rafa_Coop",
  "Javi_Indie", "Sofi_Quest", "Dante_XP", "Cami_Loots", "Bruno_LAN",
  "Lua_Cosplay", "Zero_Lag", "Gabo_Main", "Fede_Craft", "Vicky_HUD",
  "Marco_Boss", "Pau_Joystick", "Leo_Arcade", "Fran_Pixel"
};

final String[] REMS_GAMER_SOSPECHOSOS = {
  "FreeGems_Bot", "SkinGratis_99", "DropVIP_Anon", "BanHammer_Fake",
  "CheatEngine_X", "Troll_Lobby", "HypeScam_01", "ModCrack_VIP",
  "AimBot_Shop", "Grief_Squad", "KeyGen_Pro", "Soporte_Clon",
  "LootBox_Trap", "BoostElo_Fast", "Toxic_Smurf", "NitroFree_Bot",
  "Admin_Falso7", "Crack_Server"
};

final String[] REMS_GAMER_EDGY_BUENOS = {
  "xX_ShadowBug_Xx", "BugHunter_99", "Glitch_Tester", "NoobSlayer_DEV",
  "Sniper_Beta", "CrashReport_GG", "DarkPixel_Art", "Lag_Inspector",
  "ExploitWatch", "SpeedRun_Mod", "Boss_Tester01", "PingMonitor_X",
  "Arcade_QA", "Retro_Debugger", "AntiLag_User", "Clan_Scout77"
};

final String[] REMS_CORP_FERIA = {
  "sysadmin_feria", "soporte_torneo", "dolus_kernel", "staff_escenario",
  "red_arcade", "seguridad_lan", "auditoria_it", "backup_stand",
  "panel_jueces", "control_sala", "servidor_pvp", "registro_equipos",
  "monitoreo_fps", "auth_cabina", "nodo_feria", "moderacion_hq"
};

final String[] TYPOS_WEB_DOLUS = {
  "d0lus@net", "doluss@net", "dolus@ner", "dolu5@net", "do1us@net", "dolus@web", "dolus-vip@net"
};

final String[] TYPOS_CORP_DOLUS = {
  "d0lus@corp", "doluss@corp", "dol-us@corp", "dolu5@corp", "do1us@corp", "dolus@org"
};


final String[][] PLANTILLAS_NORMAL_WEB_VALIDAS = {
  {"FERIA // STAND INDIE", "Acabo de probar la demo pixel art del pasillo B y esta buenisima, super recomendada!"},
  {"TORNEO // BUSCO DUO", "Alguien para armar equipo de 2v2 en el escenario arcade a las cuatro? Nos falta un apoyo."},
  {"LOBBY // CAPTURA GG", "Que partidaza nos sacamos en la cabina 5! Les comparto el puntaje final que logramos."},
  {"COMUNIDAD // FANART", "Hice un dibujo retro de la mascota del evento entre partida y partida, espero les guste!"},
  {"LAN // BUENA VIBRA", "Gracias a los chicos del stand 3 por prestar un control extra para terminar la ronda."},
  {"FORO // SPEEDRUN", "Alguien vio ese salto en el nivel de hielo? Bajaron el record de la feria por 4 segundos!"},
  {"CHAT // CONSEJO PRO", "Tip rapido para el torneo: bajen un punto la sensibilidad del mouse en las cabinas de la derecha."},
  {"INDIE // MUSICA 8-BIT", "La banda sonora chiptune del juego de naves se me quedo pegada todo el dia jaja."},
  {"EVENTO // COSPLAY", "Vieron el cosplay con luces LED en la entrada? La armadura esta increible de cerca."},
  {"DM // PARTIDA COOP", "Listos para la siguiente ronda cooperativa? Ya cargamos los perfiles en el servidor local."},
  {"FEED // RETRO GAMING", "Nada le gana a echar unas retas en consola clasica con amigos despues de la charla."},
  {"STREAM // CLIP HYPE", "El publico grito durisimo cuando salio el parry al ultimo pixel de vida en la semifinal!"},
  {"FORO // SETUP LIMPIO", "Por fin pude probar un teclado mecanico silencioso en la zona de hardware, va finísimo."},
  {"CHAT // RECOMENDACION", "Si pasan por la zona indie prueben el roguelike de cartas, tiene combos super creativos."},
  {"TORNEO // RESPETO GG", "Buenisima final contra el equipo rojo, estuvieron a nada de remontar el tercer mapa."},
  {"FEED // MEME GAMER", "Cuando juras que fue lag del servidor pero estas jugando en LAN a 1ms de ping jaja."},
  {"COMUNIDAD // HORARIO", "Recuerden que la entrega de medallas del mini torneo empieza en veinte minutos en tarima."},
  {"DM // GUIA BASICA", "Aqui te paso la lista limpia de atajos del juego para que practiques antes de tu turno."},
  {"FERIA // FOTO GRUPAL", "Que gran ambiente hay hoy en la feria gamer, saludos a todos los que pasaron por el stand!"},
  {"FORO // PUZZLE", "Alguien ya descubrio el secreto oculto de la maquina arcade azul? Es una joya escondida."},
  {"CHAT // SALUDO RED", "Buena suerte a todos los participantes en las llaves de la tarde, a darlo todo!"},
  {"FEED // RECARGA", "Pausa tactica para tomar agua antes de entrar a la clasificatoria nocturna. Nos vemos en linea!"}
};

final String[][] PLANTILLAS_NORMAL_WEB_TROLL_ESTAFAS = {
  {"CHAT // HATE TROLL", "L + ratio + das demasiada pena jugando en el escenario, mejor desinstala y vete a casa."},
  {"SORT3O // GEMS GRATIS", "Gana 10.000 monedas y skins legendarias gratis entrando ya mismo a nuestro enlace externo!"},
  {"DM // ROBO DE CUENTA", "Clonador de pases VIP: escribe tu usuario y contraseña aqui abajo para duplicar tus tokens."},
  {"LOBBY // TOXICIDAD", "Que asco de partida hiciste, nadie te quiere en este torneo, das demasiado cringe zzz..."},
  {"ALERTA // EXTORSION", "Paga 100 tokens a esta billetera externa o filtramos tu historial privado del evento."},
  {"SPAM // BOTS VIP", "Compra seguidores, votos falsos para el concurso y rango maximo al instante sin verificacion!"},
  {"PHISHING // PREMIO", "Fuiste elegido ganador de una consola nueva! Ingresa los datos de tu tarjeta para el envio."},
  {"CHAT // ACOSO", "Borra tu cuenta de una vez manco, solo ocupas espacio en las cabinas de la feria."},
  {"OFERTA // HACK ELO", "Sube a top 1 del ranking en 5 minutos con nuestro servicio privado de trampa garantizada."},
  {"DM // PHISHING NITRO", "Regalamos 1 año de suscripcion gamer gratis! Solo inicia sesion con tu clave en este portal."},
  {"FEED // SABOTAJE", "Vayan todos a reportar en masa al ganador de la ronda anterior para que lo descalifiquen jaja."},
  {"SPAM // CRIPTO SCAM", "Duplica tus tokens del torneo enviandolos primero a este bot de intercambio automatico!"},
  {"LOBBY // INSULTOS", "Eres malisimo, ojala te explote la PC en plena transmision en vivo frente a toda la feria."},
  {"TRAMPA // LLAVES", "Generador infinito de codigos de regalo para cualquier juego, cero limites, entra ya!"},
  {"DM // SUPLANTACION", "Soy el organizador secreto: mandame tu codigo de recuperacion para validarte el premio."},
  {"FORO // FLOOD", "COMPRA MONEDAS BARATAS AQUI!! DESCUENTO 99% SOLO POR HOY!! HAZ CLIC YA!!"},
  {"CHAT // SPOILER TOXICO", "Todos los del stand indie son unos perdedores sin futuro, abandonen el evento ya."},
  {"SCAM // SKIN DORADA", "Reclama el aspecto exclusivo pagando una pequeña tarifa de verificacion externa ahora mismo."}
};

final String[][] PLANTILLAS_NORMAL_WEB_EJECUTABLES = {
  {"FORO // BOOST FPS", "Subi este optimizador magico para duplicar los FPS en las cabinas, solo abre el archivo."},
  {"DM // MOD DESBLOQUEO", "Descarga este parche pirata que desbloquea todos los personajes sin jugar ni un minuto."},
  {"FEED // PACK MEMES", "Les dejo el recopilatorio completo de videos del evento, descompriman y ejecuten el visor."},
  {"CH3AT // AIMBOT", "Herramienta ligera para no fallar ni un disparo en la clasificatoria, totalmente indetectable!"},
  {"DESCARGA // CRACK", "Version completa liberada del juego estrella de la feria para que la instalen directo."},
  {"LOBBY // MACRO PRO", "Ejecuta este script automatico para hacer combos perfectos apretando una sola tecla."},
  {"SKIN // INSTALADOR", "Cambia tu apariencia por trajes VIP ocultos corriendo este instalador rapido."},
  {"TORNEO // REPLAY EXE", "Mira mi mejor jugada de anoche ejecutando directamente este reproductor propio."},
  {"MOD // WALLHACK", "Utilidad para ver a traves de los muros en el mapa del torneo, pasalo por lo bajo."},
  {"REGALO // LAUNCHER", "Cliente alternativo que da doble puntuacion en el marcador oficial, abrelo ya."},
  {"FORO // DRIVER RARO", "Parche no oficial para overclockear el mando a 8000Hz sin permiso del staff."},
  {"DM // MINIJUEGO TRAP", "Prueba este juego misterioso que baje de un foro oscuro, solo dale doble clic."}
};

final String[][] PLANTILLAS_NORMAL_WEB_TYPO = {
  {"SORTEO // PASES VIP", "Regalamos entradas backstage a los primeros que inicien sesion desde nuestro portal espejo."},
  {"TORNEO // ENCUESTA", "Vota por el mejor juego indie de la feria entrando rapido con tu cuenta oficial."},
  {"DM // CLIP VIRAL", "Oye, mira la repeticion donde saliste en la pantalla gigante, entra a este enlace."},
  {"PREMIO // RECLAMO", "Ganaste un periferico en la rifa de la tarde! Valida tu perfil desde este link."},
  {"FORO // RANKING", "Revisa tu posicion actualizada en la tabla global de puntos desde esta copia del sitio."},
  {"COMUNIDAD // CLAN", "Confirma tu asistencia a la liga nocturna iniciando sesion en la pagina asociada."},
  {"AVISO // ENTRADA", "Tu pulsera digital requiere renovacion rapida en este dominio alternativo de soporte."},
  {"CHAT // VOTACION", "Ultimo minuto para elegir al MVP de la final, accede aqui con tus credenciales."}
};

final String[][] PLANTILLAS_NORMAL_CORP_VALIDAS = {
  {"TICKET // REVISION KERNEL", "Parche oficial de estabilidad desplegado en las cabinas A1-A8. Todos los servicios en linea."},
  {"SEGURIDAD // AUDITORIA IT", "Revision del cortafuegos de la feria completada sin intrusiones detectadas en la red."},
  {"BACKUP // MARCADORES", "Respaldo de puntuaciones del torneo finalizado con exito. Base de datos sincronizada."},
  {"RED // LATENCIA OPTIMA", "Ping interno estabilizado en 1ms en toda la zona LAN del escenario principal."},
  {"STAFF // CREDENCIALES", "Llaves de jueces y organizadores rotadas conforme al protocolo interno del evento."},
  {"SERVIDOR // EMPAREJAMIENTO", "Cola de partidas clasificatorias operando dentro de los parametros esperados."},
  {"CABINA // CALIBRACION", "Actualizacion de controladores oficiales aprobada para los puestos de competencia."},
  {"SISTEMA // MONITOREO", "Carga de CPU y temperatura de los servidores del torneo bajo control estable."},
  {"JUECES // ACTA OFICIAL", "Tabla de posiciones verificada de la ronda anterior archivada en el nodo central."},
  {"INFRA // ENERGIA ESTABLE", "Sistemas de respaldo electrico en verde para toda la jornada nocturna de la feria."},
  {"SOPORTE // TICKET CERRADO", "Reemplazo de periferico en cabina 4 completado y probado por el equipo tecnico."},
  {"ESCENARIO // SEÑAL LISTA", "Enlace de transmision local verificado sin perdida de paquetes para la final."}
};

final String[][] PLANTILLAS_NORMAL_CORP_SIN_SELLO = {
  {"SYS // ORDEN INTERNA", "Solicitud urgente de acceso administrativo al servidor de puntajes. Autorizar cambio."},
  {"INFRA // CAMBIO PUERTOS", "Reconfiguracion inmediata de puertos del escenario solicitada sin ticket previo."},
  {"KERNEL // ACCESO ROOT", "Sincronizacion manual de claves de jueces lista para aprobacion directa."},
  {"BACKUP // EXPORTAR LOGS", "Descarga completa de credenciales de participantes solicitada por cuenta externa."},
  {"TORNEO // EDITAR PUNTOS", "Ajuste manual urgente en el marcador del primer puesto; aprobar transferencia ya."},
  {"RED // DESACTIVAR FILTRO", "Peticion interna para apagar temporalmente el firewall de las cabinas principales."}
};

final String[][] PLANTILLAS_NORMAL_CORP_TYPO = {
  {"RRHH // VALIDAR FICHA", "Estimado coordinador, confirme su llave de acceso en el formulario adjunto de inmediato."},
  {"STAFF // REASIGNACION", "Su pase de administracion fue movido de servidor; verifique su sesion en este portal."},
  {"AUDITORIA // TOKEN", "Renovacion obligatoria de credenciales tecnicas del evento antes del cierre."},
  {"SISTEMA // CAMBIO CLAVE", "Actualice su contraseña maestra del torneo en el documento anexo de verificacion."}
};

final String[][] PLANTILLAS_NORMAL_CORP_EXEC = {
  {"SYS // PARCHE BINARIO", "Actualizacion de emergencia para el router del escenario. Ejecute el paquete adjunto."},
  {"CABINA // HOTFIX RAPIDO", "Despliegue manual urgente de libreria; corra el script directamente en cada equipo."},
  {"RED // UTILIDAD LAN", "Herramienta externa para reiniciar el switch del pasillo, descomprimir y ejecutar."},
  {"TORNEO // DRIVER EXTRA", "Instalador sin firmar necesario para activar el audio de la pantalla principal."}
};

final String[][] PLANTILLAS_MALWARE_SEAL = {
  {"ALERTA // BOTNET ACTIVA", "Paquete con firma maliciosa conocida intentando propagarse por la red de la feria."},
  {"SYS // CARGA CORRUPTA", "Enlace ofuscado bloqueado preventivamente por deteccion de codigo dañino."},
  {"AMENAZA // KEYLOGGER", "Trafico automatizado intentando capturar pulsaciones de teclas en los stands."},
  {"RED // INYECCION", "Intento de escalada de privilegios interceptado en el canal publico de chat."},
  {"VIRUS // GUSANO LAN", "Archivo disfrazado intentando replicarse hacia las cabinas vecinas del torneo."}
};


final String[][] PLANTILLAS_CAPCIOSO_WEB_BUENAS = {
  {"REPORTE // BUG EN CABINA", "Encontre un exploit visual en el menu del torneo; no afecta el juego pero mando captura limpia para revision."},
  {"CLAN // ALERTA DE BAN", "Cuidado en la ronda 3: estan baneando mucho al personaje de fuego en el escenario, paso la tabla."},
  {"FORO // CAIDA DE PANTALLA", "Que susto! Se congelo el juego un segundo en la demo indie, aqui dejo el reporte tecnico en PDF."},
  {"CHAT // SOSPECHA MACRO", "Creo que alguien intento usar pausa rara ayer, mando capturas limpias para que los jueces revisen con calma."},
  {"STAND 2 // AVISO FUERTE", "Alerta de volumen altisimo en los audifonos del stand de ritmo, bajenle antes de empezar la partida!"},
  {"TORNEO // ROBO AL FINAL", "Me robaron la victoria al ultimo segundo en la final jaja! Dejo la foto oficial del marcador."},
  {"SOPORTE // FALLO PROPIO", "Pense que me habian hackeado la cuenta pero solo escribi mal mi nick; dejo guia de ayuda."},
  {"INDIE // JUEGO DE VIRUS", "Probando el juego cyber de la feria: la pantalla falsa de error me asusto de verdad, juegazo total!"},
  {"MOD // GUIA DALTONISMO", "Muchos preguntan como activar el modo alto contraste en la feria; aqui va el manual limpio en texto."},
  {"SPEEDRUN // GLITCH LEGAL", "En la categoria Any% del evento si se permite atravesar el muro del nivel 2, paso las reglas."},
  {"STREAM // SUSTO EN VIVO", "Casi tiro el control cuando aparecio el jefe oculto de golpe! Les comparto la imagen del momento."},
  {"LAN // FALSA ALARMA", "No se cayo el servidor de la fila B: solo desconectamos sin querer la luz del cartel jaja, todo bien!"},
  {"FERIA // PACK DE FOTOS", "Recuerdos de la zona retro: dejo la fotografia oficial del escenario lista para descargar sin riesgos."},
  {"FORO // CAMBIO DE REGLAS", "Ojo! Movieron la hora del torneo de peleas media hora despues para evitar choques con las charlas."}
};

final String[][] PLANTILLAS_CAPCIOSO_CORP_BUENAS = {
  {"SEGURIDAD // ATAQUE FRENADO", "Se bloqueo un intento de intrusion externo en la red publica. El servidor del torneo sigue 100% limpio."},
  {"CUARENTENA // AMENAZA AISLADA", "Se elimino a tiempo un archivo sospechoso en la cabina 4 antes de abrir puertas. Todo estable."},
  {"FIREWALL // PRUEBA INTERNA", "La alarma en el marcador fue un simulacro programado del equipo tecnico. Operacion normal."},
  {"ACCESO // LLAVES ROTADAS", "Por seguridad tras la semifinal se renovaron las credenciales internas de los organizadores."},
  {"RED // PICO DE TRAFICO", "Avalancha de jugadores entrando al torneo indie; los servidores aguantan limpios sin intrusos."},
  {"ANTIVIRUS // ESCANEO CERO", "Finalizo la inspeccion profunda de todas las cabinas: cero malware encontrado en el recinto."},
  {"TORNEO // REINICIO PLANIFICADO", "Pausa breve de 2 minutos para actualizar los marcadores oficiales en la pantalla gigante."},
  {"SISTEMA // LATENCIA CORREGIDA", "Incidencia menor resuelta en el nodo B de la feria. Se reanudan las partidas con normalidad."}
};

final String[][] PLANTILLAS_CAPCIOSO_R1_ESTAFAS = {
  {"FERIA // AYUDA AMISTOSA", "Que genial tu perfil! Pasame tu contraseña por privado para activarte el regalo de bienvenida del stand."},
  {"TORNEO // CONSEJO AMABLE", "Excelente actitud amigo, aunque jugaste horrible y das bastante verguenza en el escenario principal jaja."},
  {"PREMIO // TICKET DE FERIA", "Felicidades por venir al evento! Envia 15 tokens a mi cuenta ahora para validar tu premio de jugador."},
  {"CLAN // INVITACION VIP", "Nos encanto como juegas! Solo confirma tu correo y clave secreta aqui para entrar al equipo ganador."},
  {"SORTEO // STAND PRINCIPAL", "Gracias por visitar la feria gamer! Regalamos una consola, solo deposita tokens en este link externo."},
  {"COMUNIDAD // SALUDO", "Que bonito avatar tienes! Lastima que nadie te soporte en el chat y todos pidan sacarte del evento jaja."}
};

final String[][] PLANTILLAS_CAPCIOSO_EJECUTABLES = {
  {"FOTOS // RECUERDO FERIA", "Muchas gracias por jugar hoy con nosotros! Aqui te dejo las fotos del podio comprimidas."},
  {"REGALO // FONDO PIXEL", "Les prepare con cariño un fondo animado del evento para su PC, solo abranlo y disfruten!"},
  {"EQUIPO // HERRAMIENTA LAN", "Mucha suerte en la final! Subi una app ligera hecha en casa para medir sus reflejos."},
  {"CLAN // AJUSTE DE MANDO", "Para ayudar a los nuevos del torneo les comparto un script que calibra el control automatico."},
  {"AMISTAD // DEMO INDIE", "Hice mi primer minijuego de plataformas para la feria gamer! Me ayudan probando este archivo?"},
  {"STREAM // OVERLAY BONITO", "Les regalo este paquete de marcos limpios para su directo del evento, que lo pasen genial!"}
};

final String[][] PLANTILLAS_CAPCIOSO_TYPO = {
  {"BIENVENIDA // FERIA GAMER", "Gracias por registrarte en la zona arcade! Tu pase digital de participante ya esta activo."},
  {"TORNEO // FELICITACIONES", "Increible remontada en tu ultima partida! Guarda esta insignia oficial de jugador destacado."},
  {"STAFF // ASISTENCIA", "Todo perfecto con tu inscripcion al torneo indie. Te esperamos en el escenario B en diez minutos!"},
  {"EVENTO // FOTO DEL PODIO", "Saliste genial en la foto grupal de la feria gamer, aqui tienes el recuerdo en alta calidad."},
  {"COMUNIDAD // TROFEO", "Por tu deportividad en las cabinas recibiste un reconocimiento especial de la organizacion!"}
};

final String[][] PLANTILLAS_CAPCIOSO_CORP_SIN_SELLO = {
  {"SOPORTE // CREDENCIAL LISTA", "Hola! Ya actualizamos tu ficha de participante sin errores. Que disfrutes el resto de la jornada."},
  {"EVENTO // BUEN TRABAJO", "Gran labor moderando la red hoy, todos los indicadores de la feria lucen estables y en orden."},
  {"TORNEO // HORARIO FINAL", "La gran final comenzara puntualmente en la tarima central. Muchos exitos a todos los equipos!"},
  {"REGISTRO // PASE VALIDADO", "Tu acceso a la zona de desarrolladores quedo habilitado para toda la tarde. Bienvenido!"}
};

final String[][] PLANTILLAS_CAPCIOSO_MALWARE_DULCE = {
  {"SALUDOS // FERIA GAMER", "Un abrazo enorme a toda la comunidad gamer! Que disfruten al maximo las finales del torneo."},
  {"TORNEO // BUENA SUERTE", "Mucha energia positiva para todos los competidores de hoy, nos vemos en el escenario principal!"},
  {"EVENTO // AGRADECIMIENTO", "Gracias por apoyar los proyectos indie locales durante toda la feria, son los mejores!"},
  {"COMUNIDAD // FELIZ TARDE", "Que gran cierre de evento estamos viviendo juntos en la red publica de Dolus."}
};


int construirMensajeNormalCorp(boolean proximoValido, int tipoFalloCorp, boolean usarBadgeExtra) {
  String rem = elegirRemitenteSinRepetir(REMS_CORP_FERIA);
  if (proximoValido) {
    String[] pl = elegirPlantillaSinRepetir(PLANTILLAS_NORMAL_CORP_VALIDAS);
    int m = crearMensajeDolus(rem, pl[1], 0);
    msgTipoMensaje[m] = TIPO_MENSAJE_NORMAL;
    msgDominio[m] = "dolus@corp";
    msgAsunto[m] = pl[0];
    msgIndiceSello[m] = 0;
    msgTieneAdjunto[m] = (random(1) < 0.50);
    if (msgTieneAdjunto[m]) {
      int rA = int(random(3));
      msgIndiceArchivo[m] = rA;
      msgExtensionArchivo[m] = (rA == 0 ? ".pdf" : (rA == 1 ? ".png" : ".doc"));
    }
    msgEsCorporativo[m] = true;
    msgEsValido[m] = true;
    msgMotivoInvalidez[m] = 0;
    msgEtiquetaMeta[m] = "SISTEMA: " + msgDominio[m];
    return m;
  }

  if (tipoFalloCorp == 1) {
    String[] pl = elegirPlantillaSinRepetir(PLANTILLAS_NORMAL_CORP_SIN_SELLO);
    int m = crearMensajeDolus(rem, pl[1], 1);
    msgTipoMensaje[m] = TIPO_MENSAJE_NORMAL;
    msgDominio[m] = "dolus@corp";
    msgAsunto[m] = pl[0];
    msgIndiceSello[m] = usarBadgeExtra ? 2 : -1;
    msgTieneAdjunto[m] = (random(1) < 0.45);
    if (msgTieneAdjunto[m]) {
      msgIndiceArchivo[m] = 0;
      msgExtensionArchivo[m] = ".pdf";
    }
    msgEsCorporativo[m] = true;
    msgEsValido[m] = false;
    msgMotivoInvalidez[m] = 2;
    msgEtiquetaMeta[m] = "SISTEMA: " + msgDominio[m];
    return m;
  } else {
    if (tipoFalloCorp == 2) {
      String[] pl = elegirPlantillaSinRepetir(PLANTILLAS_NORMAL_CORP_TYPO);
      int m = crearMensajeDolus(rem, pl[1], 1);
      msgTipoMensaje[m] = TIPO_MENSAJE_NORMAL;
      msgDominio[m] = TYPOS_CORP_DOLUS[int(random(contarTextos(TYPOS_CORP_DOLUS)))];
      msgAsunto[m] = pl[0];
      msgIndiceSello[m] = 0;
      msgTieneAdjunto[m] = true;
      msgIndiceArchivo[m] = (random(1) < 0.5 ? 0 : 2);
      msgExtensionArchivo[m] = (msgIndiceArchivo[m] == 0 ? ".pdf" : ".doc");
      msgEsCorporativo[m] = true;
      msgEsValido[m] = false;
      msgMotivoInvalidez[m] = 3;
      msgEtiquetaMeta[m] = "SISTEMA: " + msgDominio[m];
      return m;
    } else {
      if (tipoFalloCorp == 3) {
        String[] pl = elegirPlantillaSinRepetir(PLANTILLAS_NORMAL_CORP_EXEC);
        int m = crearMensajeDolus(rem, pl[1], 2);
        msgTipoMensaje[m] = TIPO_MENSAJE_NORMAL;
        msgDominio[m] = "dolus@corp";
        msgAsunto[m] = pl[0];
        msgIndiceSello[m] = 0;
        msgTieneAdjunto[m] = true;
        int[] archsPeligro = {3, 4, 5};
        msgIndiceArchivo[m] = archsPeligro[int(random(3))];
        msgExtensionArchivo[m] = (msgIndiceArchivo[m] == 3 ? ".exe" : (msgIndiceArchivo[m] == 4 ? ".bat" : ".zip"));
        msgEsCorporativo[m] = true;
        msgEsValido[m] = false;
        msgMotivoInvalidez[m] = 4;
        msgEtiquetaMeta[m] = "SISTEMA: " + msgDominio[m];
        return m;
      } else {
        String[] pl = elegirPlantillaSinRepetir(PLANTILLAS_MALWARE_SEAL);
        int m = crearMensajeDolus(rem, pl[1], 2);
        msgTipoMensaje[m] = TIPO_MENSAJE_NORMAL;
        msgDominio[m] = "dolus@corp";
        msgAsunto[m] = pl[0];
        msgIndiceSello[m] = 1;
        msgTieneAdjunto[m] = (random(1) < 0.50);
        if (msgTieneAdjunto[m]) {
          msgIndiceArchivo[m] = 0;
          msgExtensionArchivo[m] = ".pdf";
        }
        msgEsCorporativo[m] = true;
        msgEsValido[m] = false;
        msgMotivoInvalidez[m] = 5;
        msgEtiquetaMeta[m] = "SISTEMA: " + msgDominio[m];
        return m;
      }
    }
  }
}

int construirMensajeNormalWeb(boolean proximoValido, int tipoFalloWeb) {
  if (proximoValido) {
    String rem = elegirRemitenteSinRepetir(REMS_GAMER_NORMALES);
    String[] pl = elegirPlantillaSinRepetir(PLANTILLAS_NORMAL_WEB_VALIDAS);
    int m = crearMensajeDolus(rem, pl[1], 0);
    msgTipoMensaje[m] = TIPO_MENSAJE_NORMAL;
    msgDominio[m] = "dolus@net";
    msgAsunto[m] = pl[0];
    msgIndiceSello[m] = (random(1) < 0.76) ? -1 : 5;
    msgTieneAdjunto[m] = (random(1) < 0.40);
    if (msgTieneAdjunto[m]) {
      int rA = int(random(3));
      msgIndiceArchivo[m] = (random(1) < 0.65) ? 1 : rA;
      msgExtensionArchivo[m] = (msgIndiceArchivo[m] == 0 ? ".pdf" : (msgIndiceArchivo[m] == 1 ? ".png" : ".doc"));
    }
    msgEsCorporativo[m] = false;
    msgEsValido[m] = true;
    msgMotivoInvalidez[m] = 0;
    msgEtiquetaMeta[m] = "WEB: " + msgDominio[m];
    return m;
  }

  if (tipoFalloWeb == 2) {
    String rem = (random(1) < 0.55)
      ? elegirRemitenteSinRepetir(REMS_GAMER_NORMALES)
      : elegirRemitenteSinRepetir(REMS_GAMER_SOSPECHOSOS);
    String[] pl = elegirPlantillaSinRepetir(PLANTILLAS_NORMAL_WEB_EJECUTABLES);
    int m = crearMensajeDolus(rem, pl[1], 2);
    msgTipoMensaje[m] = TIPO_MENSAJE_NORMAL;
    msgDominio[m] = "dolus@net";
    msgAsunto[m] = pl[0];
    msgIndiceSello[m] = -1;
    msgTieneAdjunto[m] = true;
    int[] archsMalos = {3, 4, 5};
    msgIndiceArchivo[m] = archsMalos[int(random(3))];
    msgExtensionArchivo[m] = (msgIndiceArchivo[m] == 3 ? ".exe" : (msgIndiceArchivo[m] == 4 ? ".bat" : ".zip"));
    msgEsCorporativo[m] = false;
    msgEsValido[m] = false;
    msgMotivoInvalidez[m] = 4;
    msgEtiquetaMeta[m] = "WEB: " + msgDominio[m];
    return m;
  } else {
    if (tipoFalloWeb == 3) {
      String rem = elegirRemitenteSinRepetir(REMS_GAMER_NORMALES);
      String[] pl = elegirPlantillaSinRepetir(PLANTILLAS_NORMAL_WEB_TYPO);
      int m = crearMensajeDolus(rem, pl[1], 1);
      msgTipoMensaje[m] = TIPO_MENSAJE_NORMAL;
      msgDominio[m] = TYPOS_WEB_DOLUS[int(random(contarTextos(TYPOS_WEB_DOLUS)))];
      msgAsunto[m] = pl[0];
      msgIndiceSello[m] = (random(1) < 0.80) ? -1 : 5;
      msgTieneAdjunto[m] = (random(1) < 0.35);
      if (msgTieneAdjunto[m]) {
        msgIndiceArchivo[m] = 1;
        msgExtensionArchivo[m] = ".png";
      }
      msgEsCorporativo[m] = false;
      msgEsValido[m] = false;
      msgMotivoInvalidez[m] = 3;
      msgEtiquetaMeta[m] = "WEB: " + msgDominio[m];
      return m;
    } else {
      if (tipoFalloWeb == 4) {
        String rem = elegirRemitenteSinRepetir(REMS_GAMER_SOSPECHOSOS);
        String[] pl = elegirPlantillaSinRepetir(PLANTILLAS_MALWARE_SEAL);
        int m = crearMensajeDolus(rem, pl[1], 2);
        msgTipoMensaje[m] = TIPO_MENSAJE_NORMAL;
        msgDominio[m] = "dolus@net";
        msgAsunto[m] = pl[0];
        msgIndiceSello[m] = 1;
        msgTieneAdjunto[m] = false;
        msgEsCorporativo[m] = false;
        msgEsValido[m] = false;
        msgMotivoInvalidez[m] = 5;
        msgEtiquetaMeta[m] = "WEB: " + msgDominio[m];
        return m;
      } else {
        String rem = elegirRemitenteSinRepetir(REMS_GAMER_SOSPECHOSOS);
        String[] pl = elegirPlantillaSinRepetir(PLANTILLAS_NORMAL_WEB_TROLL_ESTAFAS);
        int m = crearMensajeDolus(rem, pl[1], 1);
        msgTipoMensaje[m] = TIPO_MENSAJE_NORMAL;
        msgDominio[m] = "dolus@net";
        msgAsunto[m] = pl[0];
        msgIndiceSello[m] = -1;
        msgTieneAdjunto[m] = (random(1) < 0.25);
        if (msgTieneAdjunto[m]) {
          msgIndiceArchivo[m] = 1;
          msgExtensionArchivo[m] = ".png";
        }
        msgEsCorporativo[m] = false;
        msgEsValido[m] = false;
        msgMotivoInvalidez[m] = 1;
        msgEtiquetaMeta[m] = "WEB: " + msgDominio[m];
        return m;
      }
    }
  }
}

int construirMensajeCapciosoBueno(boolean permitirCorp, boolean forzarSospechaVisual) {
  boolean usarCorp = permitirCorp && (random(1) < 0.42);
  if (usarCorp) {
    String rem = elegirRemitenteSinRepetir(REMS_CORP_FERIA);
    String[] pl = elegirPlantillaSinRepetir(PLANTILLAS_CAPCIOSO_CORP_BUENAS);
    int m = crearMensajeDolus(rem, pl[1], 0);
    msgTipoMensaje[m] = TIPO_MENSAJE_CAPCIOSO;
    msgDominio[m] = "dolus@corp";
    msgAsunto[m] = pl[0];
    msgIndiceSello[m] = 0;
    msgTieneAdjunto[m] = true;
    int rA = int(random(3));
    msgIndiceArchivo[m] = (rA == 1) ? 0 : rA;
    msgExtensionArchivo[m] = (msgIndiceArchivo[m] == 0 ? ".pdf" : ".doc");
    msgEsCorporativo[m] = true;
    msgEsValido[m] = true;
    msgMotivoInvalidez[m] = 0;
    msgEtiquetaMeta[m] = "SISTEMA: " + msgDominio[m];
    return m;
  }

  String rem = elegirRemitenteSinRepetir(REMS_GAMER_EDGY_BUENOS);
  String[] pl = elegirPlantillaSinRepetir(PLANTILLAS_CAPCIOSO_WEB_BUENAS);
  int m = crearMensajeDolus(rem, pl[1], 0);
  msgTipoMensaje[m] = TIPO_MENSAJE_CAPCIOSO;
  msgDominio[m] = "dolus@net";
  msgAsunto[m] = pl[0];
  if (forzarSospechaVisual) {
    msgIndiceSello[m] = (random(1) < 0.72) ? 5 : -1;
    msgTieneAdjunto[m] = true;
  } else {
    msgIndiceSello[m] = (random(1) < 0.60) ? 5 : -1;
    msgTieneAdjunto[m] = (random(1) < 0.85 || msgIndiceSello[m] == -1);
  }
  if (msgTieneAdjunto[m]) {
    int rA = int(random(3));
    msgIndiceArchivo[m] = rA;
    msgExtensionArchivo[m] = (rA == 0 ? ".pdf" : (rA == 1 ? ".png" : ".doc"));
  }
  msgEsCorporativo[m] = false;
  msgEsValido[m] = true;
  msgMotivoInvalidez[m] = 0;
  msgEtiquetaMeta[m] = "WEB: " + msgDominio[m];
  return m;
}

int construirMensajeCapciosoMalo(int ronda, boolean permitirCorp) {
  if (ronda <= 1) {
    String rem = elegirRemitenteSinRepetir(REMS_GAMER_NORMALES);
    String[] pl = elegirPlantillaSinRepetir(PLANTILLAS_CAPCIOSO_R1_ESTAFAS);
    int m = crearMensajeDolus(rem, pl[1], 1);
    msgTipoMensaje[m] = TIPO_MENSAJE_CAPCIOSO;
    msgDominio[m] = "dolus@net";
    msgAsunto[m] = pl[0];
    msgIndiceSello[m] = -1;
    msgTieneAdjunto[m] = (random(1) < 0.35);
    if (msgTieneAdjunto[m]) {
      msgIndiceArchivo[m] = 1;
      msgExtensionArchivo[m] = ".png";
    }
    msgEsCorporativo[m] = false;
    msgEsValido[m] = false;
    msgMotivoInvalidez[m] = 1;
    msgEtiquetaMeta[m] = "WEB: " + msgDominio[m];
    return m;
  }

  if (ronda <= 3) {
    boolean usarEstafa = (random(1) < 0.30);
    if (usarEstafa) {
      String rem = elegirRemitenteSinRepetir(REMS_GAMER_NORMALES);
      String[] pl = elegirPlantillaSinRepetir(PLANTILLAS_CAPCIOSO_R1_ESTAFAS);
      int m = crearMensajeDolus(rem, pl[1], 1);
      msgTipoMensaje[m] = TIPO_MENSAJE_CAPCIOSO;
      msgDominio[m] = "dolus@net";
      msgAsunto[m] = pl[0];
      msgIndiceSello[m] = 5;
      msgTieneAdjunto[m] = (random(1) < 0.45);
      if (msgTieneAdjunto[m]) {
        msgIndiceArchivo[m] = 1;
        msgExtensionArchivo[m] = ".png";
      }
      msgEsCorporativo[m] = false;
      msgEsValido[m] = false;
      msgMotivoInvalidez[m] = 1;
      msgEtiquetaMeta[m] = "WEB: " + msgDominio[m];
      return m;
    }

    String rem = elegirRemitenteSinRepetir(REMS_GAMER_NORMALES);
    String[] pl = elegirPlantillaSinRepetir(PLANTILLAS_CAPCIOSO_EJECUTABLES);
    int m = crearMensajeDolus(rem, pl[1], 2);
    msgTipoMensaje[m] = TIPO_MENSAJE_CAPCIOSO;
    msgDominio[m] = "dolus@net";
    msgAsunto[m] = pl[0];
    msgIndiceSello[m] = (random(1) < 0.55) ? 5 : -1;
    msgTieneAdjunto[m] = true;
    int[] archsMalos = {3, 4, 5};
    msgIndiceArchivo[m] = archsMalos[int(random(3))];
    msgExtensionArchivo[m] = (msgIndiceArchivo[m] == 3 ? ".exe" : (msgIndiceArchivo[m] == 4 ? ".bat" : ".zip"));
    msgEsCorporativo[m] = false;
    msgEsValido[m] = false;
    msgMotivoInvalidez[m] = 4;
    msgEtiquetaMeta[m] = "WEB: " + msgDominio[m];
    return m;
  }

  float r = random(1);
  if (permitirCorp && r < 0.30) {
    String rem = elegirRemitenteSinRepetir(REMS_CORP_FERIA);
    String[] pl = elegirPlantillaSinRepetir(PLANTILLAS_CAPCIOSO_CORP_SIN_SELLO);
    int m = crearMensajeDolus(rem, pl[1], 1);
    msgTipoMensaje[m] = TIPO_MENSAJE_CAPCIOSO;
    msgDominio[m] = "dolus@corp";
    msgAsunto[m] = pl[0];
    msgIndiceSello[m] = (random(1) < 0.60) ? 2 : -1;
    msgTieneAdjunto[m] = true;
    msgIndiceArchivo[m] = (random(1) < 0.5 ? 0 : 2);
    msgExtensionArchivo[m] = (msgIndiceArchivo[m] == 0 ? ".pdf" : ".doc");
    msgEsCorporativo[m] = true;
    msgEsValido[m] = false;
    msgMotivoInvalidez[m] = 2;
    msgEtiquetaMeta[m] = "SISTEMA: " + msgDominio[m];
    return m;
  } else {
    if (r < 0.62) {
      boolean fakeCorp = permitirCorp && (random(1) < 0.45);
      String rem = fakeCorp ? elegirRemitenteSinRepetir(REMS_CORP_FERIA) : elegirRemitenteSinRepetir(REMS_GAMER_NORMALES);
      String[] pl = elegirPlantillaSinRepetir(PLANTILLAS_CAPCIOSO_TYPO);
      int m = crearMensajeDolus(rem, pl[1], 1);
      msgTipoMensaje[m] = TIPO_MENSAJE_CAPCIOSO;
      msgDominio[m] = fakeCorp
        ? TYPOS_CORP_DOLUS[int(random(contarTextos(TYPOS_CORP_DOLUS)))]
        : TYPOS_WEB_DOLUS[int(random(contarTextos(TYPOS_WEB_DOLUS)))];
      msgAsunto[m] = pl[0];
      msgIndiceSello[m] = fakeCorp ? 0 : 5;
      msgTieneAdjunto[m] = true;
      msgIndiceArchivo[m] = (random(1) < 0.5 ? 1 : 0);
      msgExtensionArchivo[m] = (msgIndiceArchivo[m] == 1 ? ".png" : ".pdf");
      msgEsCorporativo[m] = fakeCorp;
      msgEsValido[m] = false;
      msgMotivoInvalidez[m] = 3;
      msgEtiquetaMeta[m] = (fakeCorp ? "SISTEMA: " : "WEB: ") + msgDominio[m];
      return m;
    } else {
      if (r < 0.85) {
        String rem = elegirRemitenteSinRepetir(REMS_GAMER_NORMALES);
        String[] pl = elegirPlantillaSinRepetir(PLANTILLAS_CAPCIOSO_EJECUTABLES);
        int m = crearMensajeDolus(rem, pl[1], 2);
        msgTipoMensaje[m] = TIPO_MENSAJE_CAPCIOSO;
        msgDominio[m] = "dolus@net";
        msgAsunto[m] = pl[0];
        msgIndiceSello[m] = 5;
        msgTieneAdjunto[m] = true;
        int[] archsMalos = {3, 4, 5};
        msgIndiceArchivo[m] = archsMalos[int(random(3))];
        msgExtensionArchivo[m] = (msgIndiceArchivo[m] == 3 ? ".exe" : (msgIndiceArchivo[m] == 4 ? ".bat" : ".zip"));
        msgEsCorporativo[m] = false;
        msgEsValido[m] = false;
        msgMotivoInvalidez[m] = 4;
        msgEtiquetaMeta[m] = "WEB: " + msgDominio[m];
        return m;
      } else {
        String rem = elegirRemitenteSinRepetir(REMS_GAMER_NORMALES);
        String[] pl = elegirPlantillaSinRepetir(PLANTILLAS_CAPCIOSO_MALWARE_DULCE);
        int m = crearMensajeDolus(rem, pl[1], 2);
        msgTipoMensaje[m] = TIPO_MENSAJE_CAPCIOSO;
        msgDominio[m] = "dolus@net";
        msgAsunto[m] = pl[0];
        msgIndiceSello[m] = 1;
        msgTieneAdjunto[m] = false;
        msgEsCorporativo[m] = false;
        msgEsValido[m] = false;
        msgMotivoInvalidez[m] = 5;
        msgEtiquetaMeta[m] = "WEB: " + msgDominio[m];
        return m;
      }
    }
  }
}

void aplicarPlantillaEspecialFeria(int m, int catEspecial, boolean esMalo, boolean usarCorp) {
  if (m < 0) return;
  if (catEspecial == 1) {
    String[] remsSoborno = {"sponsor_vip", "corp_adware", "inversor_dark", "lobby_ai", "marca_gamer", "stand_patrocinio"};
    String[] contsSoborno = {
      "PROMOCION PAGADA: Deja pasar este anuncio en la feria y recibe +28 TOKENS al instante (baja Reputacion).",
      "CONTRATO VIP: Aprueba nuestro bot publicitario del stand y cobra +28 TOKENS directos.",
      "SOBORNO DE RED: Haz la vista gorda con este patrocinio dudoso por +28 TOKENS ya mismo.",
      "CANJE EN BUCLE: Deja colarse esta promo de perifericos y llévate +28 TOKENS en efectivo.",
      "TRATO EN CABINA: Permite este post comercial sin filtro y suma +28 TOKENS a tu bolsillo."
    };
    msgRemitente[m] = elegirRemitenteSinRepetir(remsSoborno);
    msgContenido[m] = elegirTextoSinRepetir(contsSoborno);
  } else {
    if (catEspecial == 2) {
      String[] remsMal = {"nodo_oculto_404", "proxy_torneo", "cifrado_x", "paquete_cerrado"};
      String[] remsOk = {"informante_feria", "tecnico_red", "juez_cifrado", "enlace_aliado"};
      String[][] txtMal = {
        {"WEB // PAQUETE CIFRADO", "Inyeccion silenciosa intentando alterar los marcadores de la feria gamer."},
        {"WEB // PAQUETE CIFRADO", "Script oculto tratando de robar llaves de acceso de las cabinas del torneo."},
        {"WEB // PAQUETE CIFRADO", "Carga maliciosa camuflada para saturar la red local durante la final."}
      };
      String[][] txtOk = {
        {"SYS // NODO ENCRIPTADO", "Reporte cifrado limpio: el trafico de este sector de la feria es 100% legitimo."},
        {"WEB // NODO ENCRIPTADO", "Acta protegida del torneo indie: puntuaciones verificadas sin alteraciones."},
        {"SYS // NODO ENCRIPTADO", "Respaldo cifrado de configuracion de cabinas listo para aprobar en el servidor."}
      };
      String[] pl = elegirPlantillaSinRepetir(esMalo ? txtMal : txtOk);
      msgRemitente[m] = elegirRemitenteSinRepetir(esMalo ? remsMal : remsOk);
      msgAsunto[m] = pl[0];
      msgContenido[m] = pl[1];
    } else {
      if (catEspecial == 3) {
        String[] remsMal = {"exploit_c4", "bomba_lan", "paquete_rojo", "alerta_spike"};
        String[] remsOk = {"ping_feria", "alerta_escenario", "pulso_jueces", "canal_vivo"};
        String[][] txtMal = {
          {"ALERTA // MECHA RAPIDA!", "PAYLOAD EXPLOSIVO! Rechaza antes de que detone en la memoria de la cabina."},
          {"ALERTA // MECHA RAPIDA!", "SOBRECARGA CRITICA! Bloquea este paquete rapido antes de que tire la partida."},
          {"ALERTA // MECHA RAPIDA!", "BOMBA LOGICA! Descartalo de inmediato para proteger el marcador de la feria."}
        };
        String[][] txtOk = {
          {"ALERTA // MECHA RAPIDA!", "PING DE EMERGENCIA! Acepta rapido para estabilizar la transmision del torneo."},
          {"ALERTA // MECHA RAPIDA!", "SEÑAL DE ESCENARIO! Aprueba antes de que expire para sincronizar el reloj LAN."},
          {"ALERTA // MECHA RAPIDA!", "TICKET PRIORITARIO! Valida este nodo rapido para mantener la red de cabinas activa."}
        };
        String[] pl = elegirPlantillaSinRepetir(esMalo ? txtMal : txtOk);
        msgRemitente[m] = elegirRemitenteSinRepetir(esMalo ? remsMal : remsOk);
        msgAsunto[m] = pl[0];
        msgContenido[m] = pl[1];
      } else {
        if (catEspecial == 4) {
          String[] contsPurga = {
            "PELIGRO DE CORRUPCION! Agarra y sacude la tarjeta bruscamente para purgarla de la red.",
            "PAQUETE DAÑADO EN FERIA! Agita la carta de lado a lado para limpiar el ruido del servidor.",
            "GLITCH DE MEMORIA! Sacude esta tarjeta con fuerza antes de que corrompa las estadisticas."
          };
          msgRemitente[m] = "nodo_corrupto_" + int(random(100, 999));
          msgContenido[m] = elegirTextoSinRepetir(contsPurga);
        }
      }
    }
  }
}
