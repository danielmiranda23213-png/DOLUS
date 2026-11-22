boolean modoExposicionActivo = false;
int expoPasoRonda1 = 0;
boolean expoQteDisparado = false;
int expoIndicePool = 0;
int expoJefe3Alternador = 0;


final String[][] EXPO_VALIDAS_NET = {
  {
    "clara_m",
    "COMUNIDAD // FOTO DEL PARQUE",
    "Comparto esta fotografia del parque despues de la lluvia. Buena tarde a toda la comunidad.",
    ".png", "1"
  },
  {
    "recetas_diarias",
    "COCINA // RECETA DE PAN",
    "Les dejo la receta paso a paso para hornear pan casero con ingredientes basicos.",
    ".pdf", "0"
  },
  {
    "tomas_g",
    "TRANSITO // REPORTE LOCAL",
    "Precaucion en la avenida central por mantenimiento vial durante la manana.",
    ".png", "1"
  },
  {
    "biblioteca_red",
    "LECTURA // RESUMEN SEMANAL",
    "Apuntes compartidos sobre organizacion del tiempo y habitos de estudio.",
    ".doc", "2"
  },
  {
    "observatorio_urbano",
    "CLIMA // PRONOSTICO DE HOY",
    "Se esperan lluvias ligeras hacia las cinco de la tarde. Lleven paraguas.",
    ".png", "1"
  }
};

final String[][] EXPO_VALIDAS_CORP = {
  {
    "seguridad_red",
    "SYS // AUDITORIA NOCTURNA",
    "Revision diaria del cortafuegos completada sin incidentes. Todos los servidores estables.",
    ".pdf", "0"
  },
  {
    "infraestructura_it",
    "RED // MANTENIMIENTO PROGRAMADO",
    "La actualizacion rutinaria del nodo principal finalizo correctamente sin cortes.",
    ".pdf", "0"
  },
  {
    "respaldo_central",
    "BACKUP // COPIA VERIFICADA",
    "Copia de seguridad cifrada almacenada en la boveda interna conforme al protocolo.",
    ".doc", "2"
  },
  {
    "soporte_oficial",
    "CERT // CERTIFICADOS AL DIA",
    "Renovacion automatica de certificados digitales completada para toda la red interna.",
    ".pdf", "0"
  }
};

final String[][] EXPO_MALAS_EXE = {
  {
    "descargas_rapidas",
    "ARCHIVO // INSTALADOR DUDOSO",
    "Descarga y ejecuta este archivo .exe desconocido para acelerar tu conexion de inmediato.",
    ".exe", "3"
  },
  {
    "utilidades_web",
    "HERRAMIENTA // SCRIPT DIRECTO",
    "Abre este script .bat adjunto para desbloquear funciones ocultas en tu sistema.",
    ".bat", "4"
  },
  {
    "archivo_externo",
    "ACTUALIZACION // EJECUTABLE",
    "Parche urgente sin firma digital. Haz doble clic en el archivo ejecutable ahora mismo.",
    ".exe", "3"
  }
};

final String[][] EXPO_MALAS_PHISHING = {
  {
    "soporte_urgente",
    "ALERTA // VERIFICA TU CLAVE",
    "Tu cuenta sera cerrada hoy. Responde con tu contrasena actual y codigo PIN para evitar el bloqueo.",
    "", "0"
  },
  {
    "premio_instantaneo",
    "AVISO // RECLAMA TU BONO",
    "Has sido seleccionado para recibir un saldo especial. Ingresa tus datos bancarios aqui.",
    "", "0"
  },
  {
    "banco_aviso",
    "SEGURIDAD // BLOQUEO INMINENTE",
    "Detectamos un cargo sospechoso. Confirma tu clave secreta en los proximos dos minutos.",
    "", "0"
  }
};

final String[][] EXPO_MALAS_CORP_SIN_SELLO = {
  {
    "solicitud_externa",
    "INTERNO // CAMBIO DE CLAVES",
    "Peticion urgente de acceso administrador al servidor central sin verificacion oficial.",
    ".pdf", "0"
  },
  {
    "orden_administrativa",
    "SYS // DESACTIVAR CORTAFUEGOS",
    "Solicitud directa para apagar temporalmente los filtros de seguridad de la red.",
    ".doc", "2"
  },
  {
    "exportacion_manual",
    "BACKUP // EXTRAER CREDENCIALES",
    "Autoriza el envio externo de la base completa de usuarios sin ticket ni sello DOLUS AUTH.",
    ".pdf", "0"
  }
};

final String[][] EXPO_MALAS_TYPO = {
  {
    "soporte_clon",
    "AVISO // ACTUALIZA TU SESION",
    "Confirma tu acceso en este dominio alterado (fijate en el dominio d0lus con cero).",
    "d0lus@net", "0"
  },
  {
    "mesa_ayuda_falsa",
    "SYS // CREDENCIALES EXPIRADAS",
    "Renueva tu llave corporativa desde esta direccion falsa fuera del dominio oficial.",
    "d0lus@corp", "2"
  },
  {
    "notificacion_web",
    "CUENTA // REVISA TU PERFIL",
    "Inicia sesion en nuestro portal externo falso para recuperar tus mensajes antiguos.",
    "dolus-ayuda@xyz", "0"
  }
};

void iniciarModoExposicion() {
  detenerTodaMusica();
  reiniciarPartidaCompleta();
  modoExposicionActivo = true;

  nombreJugador = "Expositor";
  dificultadSeleccionada = 1;

  statSaludMental = 85.0;
  statSeguridad   = 85.0;
  statReputacion  = 85.0;
  statPopularidad = 85.0;
  dispSaludMental = 85.0;
  dispSeguridad   = 85.0;
  dispReputacion  = 85.0;
  dispPopularidad = 85.0;
  vidasJugador = 2;

  tokensDolus = 35;
  tokensInicioRonda = 35;

  resetearTutorial();
  animandoShowcaseDirectiva = false;
  dialogoAscensoRonda5Visto = true;

  fasePluginsActiva = true;
  diaInicializado = true;
  estadoMusicaGameplay = 0;
  rondaActual = 1;
  jefeActivo = 0;
  directivaRondaActual = 0;
  mensajesPorRonda = obtenerMetaBalanzaRonda(1, 0);

  expoPasoRonda1 = 0;
  expoQteDisparado = false;
  expoIndicePool = 0;
  expoJefe3Alternador = 0;

  estadoPantalla = PANTALLA_JUEGO;
  reproducirMusicaUnica(musicaGameplayInicial);

  mensajeActivo = -1;
  numColaMensajes = 0;
  timerNuevoMensaje = 6;
  dispararTextoElastico("MODO EXPOSICION // DEMO GUIADA", width * 0.58, height * 0.28, color(210, 145, 255));
}

int expoCrearCartaDesdePool(String[][] pool, int idx, boolean esValido, int maldad, int motivoInvalidez, boolean esCorp, int sello) {
  String[] fila = pool[idx % pool.length];
  int m = crearMensajeDolus(fila[0], fila[2], maldad);
  msgTipoMensaje[m] = TIPO_MENSAJE_NORMAL;
  msgAsunto[m] = fila[1];
  msgDominio[m] = esCorp ? "dolus@corp" : "dolus@net";
  msgEsCorporativo[m] = esCorp;
  msgIndiceSello[m] = sello;
  msgEsValido[m] = esValido;
  msgMotivoInvalidez[m] = motivoInvalidez;
  msgTiempoRestante[m] = 1.0;

  if (fila.length >= 5 && fila[3].length() > 0 && !fila[3].contains("@")) {
    msgTieneAdjunto[m] = true;
    msgExtensionArchivo[m] = fila[3];
    msgIndiceArchivo[m] = int(fila[4]);
  } else {
    msgTieneAdjunto[m] = false;
  }

  if (motivoInvalidez == 3 && fila[3].contains("@")) {
    msgDominio[m] = fila[3];
    msgEsCorporativo[m] = fila[3].contains("corp");
    msgIndiceArchivo[m] = int(fila[4]);
    msgExtensionArchivo[m] = ".pdf";
    msgTieneAdjunto[m] = false;
  }

  msgEtiquetaMeta[m] = (msgEsCorporativo[m] ? "SISTEMA: " : "RED: ") + msgDominio[m];
  return m;
}

void generarMensajeModoExposicion() {
  cartasGeneradasEnRonda++;

  if (jefeActivo == 0) {
    int paso = expoPasoRonda1;
    expoPasoRonda1++;
    int m = -1;

    if (paso == 0) {
      m = expoCrearCartaDesdePool(EXPO_MALAS_EXE, 0, false, 2, 4, false, 1);
    } else if (paso == 1) {
      m = expoCrearCartaDesdePool(EXPO_MALAS_TYPO, 0, false, 1, 3, false, 2);
    } else if (paso == 2) {
      m = expoCrearCartaDesdePool(EXPO_MALAS_CORP_SIN_SELLO, 0, false, 1, 2, true, 2);
    } else if (paso == 3) {
      m = crearMensajeDolus("anunciante_vip", "Ofrecemos +28 Tokens si apruebas este anuncio no verificado en la red principal (reduce Seguridad y Reputacion).", 1);
      msgTipoMensaje[m] = TIPO_MENSAJE_NORMAL;
      msgCategoriaEspecial[m] = 1;
      msgTiempoRestante[m] = 1.15;
      msgDominio[m] = "dolus@net";
      msgAsunto[m] = "CONTRATO // ANUNCIO VIP";
      msgIndiceSello[m] = 3;
      msgTieneAdjunto[m] = true;
      msgIndiceArchivo[m] = 1;
      msgExtensionArchivo[m] = ".png";
      msgEsCorporativo[m] = false;
      msgEsValido[m] = false;
      msgMotivoInvalidez[m] = 1;
      msgEtiquetaMeta[m] = "SOBORNO: +28 TOKENS";
    } else if (paso == 4) {
      String[] okCorp = EXPO_VALIDAS_CORP[0];
      m = crearMensajeDolus(okCorp[0], okCorp[2], 0);
      msgTipoMensaje[m] = TIPO_MENSAJE_NORMAL;
      msgCategoriaEspecial[m] = 2;
      msgNivelEncriptado[m] = 1.0;
      msgTiempoRestante[m] = 2.00;
      msgDominio[m] = "dolus@corp";
      msgAsunto[m] = "SYS // REPORTE CIFRADO";
      msgIndiceSello[m] = 0;
      msgTieneAdjunto[m] = true;
      msgIndiceArchivo[m] = 0;
      msgExtensionArchivo[m] = ".pdf";
      msgEsCorporativo[m] = true;
      msgEsValido[m] = true;
      msgMotivoInvalidez[m] = 0;
      msgEtiquetaMeta[m] = "CLIC RAPIDO P/ DESCIFRAR";
    } else if (paso == 5) {
      m = crearMensajeDolus("alerta_critica", "Archivo ejecutable de detonacion rapida. Rechaza este paquete antes de que expire el tiempo!", 2);
      msgTipoMensaje[m] = TIPO_MENSAJE_NORMAL;
      msgCategoriaEspecial[m] = 3;
      msgTiempoRestante[m] = 1.35;
      msgDominio[m] = "alerta-mal@net";
      msgAsunto[m] = "URGENTE // PAQUETE MALICIOSO";
      msgIndiceSello[m] = 1;
      msgTieneAdjunto[m] = true;
      msgIndiceArchivo[m] = 3;
      msgExtensionArchivo[m] = ".exe";
      msgEsCorporativo[m] = false;
      msgEsValido[m] = false;
      msgMotivoInvalidez[m] = 4;
      msgEtiquetaMeta[m] = "MECHA RAPIDA: +6 TOKENS!";
    } else if (paso == 6) {
      m = crearMensajeDolus("nodo_corrupto", "Paquete danado en la bandeja. Sacude esta carta de lado a lado para purgarla.", 2);
      msgTipoMensaje[m] = TIPO_MENSAJE_NORMAL;
      msgCategoriaEspecial[m] = 4;
      msgTiempoRestante[m] = 2.15;
      msgDominio[m] = "glitch@null";
      msgAsunto[m] = "SISTEMA // PURGA REQUERIDA";
      msgIndiceSello[m] = 4;
      msgTieneAdjunto[m] = false;
      msgEsCorporativo[m] = false;
      msgEsValido[m] = false;
      msgMotivoInvalidez[m] = 5;
      msgEtiquetaMeta[m] = "SACUDE PARA PURGAR!";
    } else {
      int ciclo = (paso - 7) % 6;
      int sub = expoIndicePool++;
      if (ciclo == 0) {
        m = expoCrearCartaDesdePool(EXPO_VALIDAS_CORP, sub, true, 0, 0, true, 0);
      } else if (ciclo == 1) {
        m = expoCrearCartaDesdePool(EXPO_MALAS_PHISHING, sub, false, 1, 1, false, -1);
      } else if (ciclo == 2) {
        m = expoCrearCartaDesdePool(EXPO_VALIDAS_NET, sub + 1, true, 0, 0, false, 5);
      } else if (ciclo == 3) {
        m = expoCrearCartaDesdePool(EXPO_MALAS_EXE, sub + 1, false, 2, 4, false, 1);
      } else if (ciclo == 4) {
        m = expoCrearCartaDesdePool(EXPO_MALAS_CORP_SIN_SELLO, sub + 1, false, 1, 2, true, 2);
      } else {
        m = expoCrearCartaDesdePool(EXPO_MALAS_TYPO, sub + 1, false, 1, 3, false, 2);
      }
    }

    if (m >= 0) {
      encolarMensaje(m);
    }
    return;
  }

  int idx = expoIndicePool++;
  boolean baseValida = (idx % 2 == 0);
  int m;
  if (baseValida) {
    m = expoCrearCartaDesdePool(EXPO_VALIDAS_NET, idx / 2, true, 0, 0, false, -1);
  } else {
    m = expoCrearCartaDesdePool(EXPO_MALAS_PHISHING, idx / 2, false, 1, 1, false, -1);
  }
  msgTiempoRestante[m] = 1.0;
  aplicarModificadoresJefeEnGeneracion(m);
  encolarMensaje(m);
}

void verificarQTEExposicion(int cartasResueltas) {
  if (!modoExposicionActivo || jefeActivo != 0) return;
  if (expoQteDisparado || qteActivo || rondaCompletada) return;
  if (cartasResueltas < 2) return;

  expoQteDisparado = true;
  iniciarQTEPrecision();
  if (qteActivo) {
    qteTargetWidth = 0.24;
    qteTargetStart = constrain(qteTargetStart, 0.25, 0.60);
    qteSpeed = 0.0115;
    qteTimerMax = 240;
    qteTimer = 240;
  }
}

String obtenerEtiquetaBotonTiendaExpo() {
  if (rondaActual >= 1 && rondaActual <= 4) {
    return "SIGUIENTE: JEFE " + rondaActual + " >>";
  }
  return "CONTINUAR >>";
}

int expoClonarCartaViral(int origen) {
  if (origen < 0) return crearMensajeDolus("usuario_viral", "Publicacion replicada en el feed.", 0);
  int c = crearMensajeDolus(msgRemitente[origen], msgContenido[origen], msgTipoMaldad[origen]);
  msgTipoMensaje[c] = msgTipoMensaje[origen];
  msgDominio[c] = msgDominio[origen];
  msgAsunto[c] = msgAsunto[origen];
  msgIndiceSello[c] = msgIndiceSello[origen];
  msgTieneAdjunto[c] = msgTieneAdjunto[origen];
  msgIndiceArchivo[c] = msgIndiceArchivo[origen];
  msgExtensionArchivo[c] = msgExtensionArchivo[origen];
  msgEsCorporativo[c] = msgEsCorporativo[origen];
  msgEsValido[c] = msgEsValido[origen];
  msgMotivoInvalidez[c] = msgMotivoInvalidez[origen];
  msgEtiquetaMeta[c] = msgEtiquetaMeta[origen];
  msgTiempoRestante[c] = 1.0;
  return c;
}
