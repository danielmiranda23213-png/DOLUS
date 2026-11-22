
float devBtnPuzleY = 0;

void dibujarModoDesarrollador() {
  pushStyle();
  rectMode(CORNER);
  fill(4, 12, 8, 225);
  stroke(colorTema(), 200);
  strokeWeight(2);
  rect(10, 10, 390, height - 20, 12);

  fill(colorTema());
  if (fuenteRetro != null) textFont(fuenteRetro);
  textSize(20);
  textAlign(LEFT, TOP);
  text("=== DOLUS DEV CONSOLE [F3] ===", 24, 22);

  stroke(colorTema(), 120);
  strokeWeight(1.5);
  line(20, 48, 380, 48);

  textSize(13);
  float y = 58;
  float dy = 18;

  fill(220, 255, 220);
  text("FPS: " + int(frameRate) + " | Pantalla: " + estadoPantalla + " | Ronda: " + rondaActual, 24, y); y += dy;
  text("Progreso Ronda: " + mensajesProcesadosRonda + "/" + mensajesPorRonda + " | Cola: " + numColaMensajes, 24, y); y += dy;
  text("Combo: x" + comboActual + " (Max: x" + comboMaximoRonda + ") | Tokens: " + tokensDolus, 24, y); y += dy;
  text("Balanza: " + balanzaEstabilidad + " | Vidas: " + vidasJugador + " | Jefe: " + jefeActivo, 24, y); y += dy;
  text("Directiva [" + directivaRondaActual + "]: " + obtenerNombreDirectiva(), 24, y); y += dy;
  text("Particulas: " + numParticulasJuego + " | Eventos Cola: " + numEventosJuego, 24, y); y += dy;
  text("Logros Sesion: " + contarLogrosDesbloqueados() + "/" + TOTAL_LOGROS + " | Plugins Compendio: " + contarPluginsDescubiertos() + "/16", 24, y); y += dy;

  y += 6;
  fill(255, 220, 100);
  text("-- CARTA ACTIVA --", 24, y); y += dy;
  fill(230);
  if (mensajeActivo >= 0) {
    String tipoStr = "Maldad=" + msgTipoMaldad[mensajeActivo] + " | Esp=" + msgCategoriaEspecial[mensajeActivo];
    text(tipoStr + " | Cifrado=" + int(msgNivelEncriptado[mensajeActivo] * 100) + "%", 24, y); y += dy;
    text("Rem: @" + msgRemitente[mensajeActivo] + " [" + msgEtiquetaMeta[mensajeActivo] + "]", 24, y); y += dy;
  } else {
    text("[Ninguna carta activa en centro]", 24, y); y += dy * 2;
  }

  y += 6;
  fill(100, 220, 255);
  text("-- INTEGRIDAD DEL SISTEMA --", 24, y); y += dy;
  fill(230);
  text("Salud Mental: " + int(statSaludMental) + "% | Seguridad: " + int(statSeguridad) + "%", 24, y); y += dy;
  text("Reputacion:   " + int(statReputacion) + "% | Popularidad: " + int(statPopularidad) + "%", 24, y); y += dy;

  y += 8;
  fill(colorTema());
  text("-- ATAJOS DE PRUEBA Y DEBUG --", 24, y); y += dy;
  fill(210, 240, 220);
  text("[J / K] Saltar a Admin (Normal)", 24, y); y += dy;
  text("[1] Completar Ronda (Ver Liquidacion)", 24, y); y += dy;
  text("[2][3][4][5] Cinematica y Combate Jefes 1-4", 24, y); y += dy;
  text("[G] Generar Carta SOBORNO DORADO", 24, y); y += dy;
  text("[E] Generar Carta ENCRIPTADA", 24, y); y += dy;
  text("[X] Generar Carta BOMBA", 24, y); y += dy;
  text("[V] Generar Carta CONTAMINADA (Sacudir)", 24, y); y += dy;
  text("[D] Cambiar Directiva Diaria", 24, y); y += dy;
  text("[T] +50 Tokens  | [C] +5 Combo", 24, y); y += dy;
  text("[H] Curar Stats al 100%", 24, y); y += dy;
  text("[Q] Lanzar QTE Precision | [L] Logro/Compendio", 24, y); y += dy;
  text("[6][7][8][9] Secuencias MetaJuego 1-4", 24, y); y += dy;
  text("[0] / [B] Forzar Game Over", 24, y); y += dy;
  text("[U] Cinematica Final -> Habitacion", 24, y); y += dy;
  text("[P] Glitch Escape Deepfake -> Habitacion", 24, y); y += dy;

  String codBovedaDbg = (pinSecreto[0] == 0)
    ? "[PENDIENTE AL ENTRAR]"
    : ("[" + pinSecreto[0] + "" + pinSecreto[1] + "" + pinSecreto[2] + "" + pinSecreto[3] + "] (Suma: " + pinSumaTotal + ")");
  fill(90, 255, 175);
  text("Codigo Boveda (Puzle 2): " + codBovedaDbg, 24, y); y += dy;
  fill(185, 235, 255);
  text("[Mantener F] Saltar todas las escenas", 24, y); y += dy;

  devBtnPuzleY = y + 2;
  float btnW = 360;
  float btnH = 26;
  float btnX = 24;
  boolean hovPuzBtn = (mouseX >= btnX && mouseX <= btnX + btnW && mouseY >= devBtnPuzleY && mouseY <= devBtnPuzleY + btnH);

  rectMode(CORNER);
  fill(hovPuzBtn ? color(40, 160, 95, 230) : color(18, 55, 38, 210));
  stroke(hovPuzBtn ? color(120, 255, 185) : color(65, 225, 140));
  strokeWeight(hovPuzBtn ? 2.0 : 1.5);
  rect(btnX, devBtnPuzleY, btnW, btnH, 6);

  fill(hovPuzBtn ? color(255) : color(180, 255, 210));
  textAlign(CENTER, CENTER);
  textSize(12);
  text("[Z] RESOLVER PUZLES (PROLOGO)", btnX + btnW * 0.5, devBtnPuzleY + btnH * 0.5 - 1);
  y += btnH + 6;

  y += 4;
  fill(255, 215, 80);
  text("-- CINEMATICAS DE FINALES --", 24, y); y += dy;
  fill(120, 255, 180);
  text("[F5 / Y] Ver Final Bueno (Victoria)", 24, y); y += dy;
  fill(255, 140, 140);
  text("[F6 / I] Ver Final Malo (Admin)", 24, y); y += dy;
  fill(255, 180, 120);
  text("[F7 / O] Ver Final Malo (Pre-Admin)", 24, y); y += dy;

  popStyle();
}

void devResolverPuzlesPrologo() {
  if (estadoPantalla != PANTALLA_HABITACION) {
    iniciarHabitacionFinal();
  }

  puz1Completado = true;
  puz1TiempoVictoriaMs = millis();
  if (habEstadoPuzle < 1) habEstadoPuzle = 1;

  if (pinSecreto[0] == 0) {
    epGenerarPinSecreto();
  }

  puz2Entrada[0] = pinSecreto[0];
  puz2Entrada[1] = pinSecreto[1];
  puz2Entrada[2] = pinSecreto[2];
  puz2Entrada[3] = pinSecreto[3];
  puz2Completado = true;
  puz2TiempoVictoriaMs = millis();
  habEstadoPuzle = 2;

  habModalPuzle1Abierto = false;
  habModalPuzle2Abierto = false;

  epActivarCelebracionCelular();
  reproducirSFX(sonidoDecisionCorrecta);
  reproducirLogro();

  dispararTextoElastico("DEV: PUZLES RESUELTOS! CELULAR OBTENIDO", width * 0.5, height * 0.20, color(75, 255, 160));
  epMostrarMensajeHabitacion("DEV: Puzles completados! Telefono desbloqueado.", color(85, 255, 175), 4500);
  guardarPartidaActual();
}

boolean manejarMouseDesarrollador() {
  if (!modoDesarrollador) return false;
  float btnX = 24;
  float btnW = 360;
  float btnH = 26;
  if (mouseX >= btnX && mouseX <= btnX + btnW && mouseY >= devBtnPuzleY && mouseY <= devBtnPuzleY + btnH) {
    reproducirTap();
    devResolverPuzlesPrologo();
    return true;
  }
  return false;
}

void devMostrarFinal(int tipo) {
  detenerTodaMusica();
  detenerVozDialogo();
  pausaSolicitada = false;
  juegoPausado = false;
  estadoPausa = 0;
  habBatallaFinalCompletada = false;
  habModalPuzle1Abierto = false;
  habModalPuzle2Abierto = false;
  habModalTelefonoAbierto = false;
  estadoPantalla = PANTALLA_HABITACION;
  epIniciarCinematicaFinalDesenlace(tipo);
  String nomFin = (tipo == 1) ? "BUENO" : ((tipo == 2) ? "MALO ADMIN" : "MALO PRE-ADMIN");
  dispararTextoElastico("DEV: MOSTRANDO FINAL " + nomFin, width * 0.5, height * 0.20, color(255, 215, 80));
}

boolean manejarTeclasDesarrollador() {
  if (!modoDesarrollador) return false;

  if (key == 'Y' || key == 'y' || keyCode == 116 ) {
    devMostrarFinal(1);
    return true;
  }
  if (key == 'I' || key == 'i' || keyCode == 117 ) {
    devMostrarFinal(2);
    return true;
  }
  if (key == 'O' || key == 'o' || keyCode == 118 ) {
    devMostrarFinal(3);
    return true;
  }

  if (key == 'U' || key == 'u') {
    iniciarCinematicaFinalVR();
    return true;
  }
  if (key == 'P' || key == 'p') {
    iniciarSecuenciaGlitchEscapeDeepfake();
    return true;
  }
  if (key == 'Z' || key == 'z') {
    devResolverPuzlesPrologo();
    return true;
  }

  if (estadoPantalla == PANTALLA_CINEMATICA_FINAL || estadoPantalla == PANTALLA_HABITACION || estadoPantalla == PANTALLA_GLITCH_ESCAPE) {
    return false;
  }

  if (key == 'J' || key == 'j' || key == 'K' || key == 'k') {
    saltarDirectoAAdminNormal();
    return true;
  }

  if (key == '1') {
    balanzaEstabilidad = obtenerMetaBalanzaActual();
    verificarFinDeRonda();
    return true;
  }
  if (key == '2') { iniciarCinematicaJefe(1); return true; }
  if (key == '3') { iniciarCinematicaJefe(2); return true; }
  if (key == '4') { iniciarCinematicaJefe(3); return true; }
  if (key == '5') { iniciarCinematicaJefe(4); return true; }

  if (key == '6') { etapaMetaJuego = 0; estadoPantalla = 0; chequearProgresoMetaJuego(); return true; }
  if (key == '7') { etapaMetaJuego = 1; estadoPantalla = 0; chequearProgresoMetaJuego(); return true; }
  if (key == '8') { etapaMetaJuego = 2; estadoPantalla = 0; chequearProgresoMetaJuego(); return true; }
  if (key == '9') { etapaMetaJuego = 3; estadoPantalla = 0; chequearProgresoMetaJuego(); return true; }

  if (key == '0') {
    vidasJugador = -1;
    verificarGameOverStats();
    return true;
  }

  if (key == 'B' || key == 'b') {
    statSaludMental = 0;
    verificarGameOverStats();
    return true;
  }

  if (key == 'G' || key == 'g') {
    forzarCartaEspecialDebug(1);
    return true;
  }
  if (key == 'E' || key == 'e') {
    forzarCartaEspecialDebug(2);
    return true;
  }
  if (key == 'X' || key == 'x') {
    forzarCartaEspecialDebug(3);
    return true;
  }
  if (key == 'V' || key == 'v') {
    forzarCartaEspecialDebug(4);
    return true;
  }
  if (key == 'D' || key == 'd') {
    directivaRondaActual = (directivaRondaActual % 4) + 1;
    dispararShowcaseDirectiva();
    return true;
  }
  if (key == 'T' || key == 't') {
    tokensDolus += 50;
    pulsoTokensUI = 1.0;
    fijarProgresoMaximoLogro(8, tokensDolus);
    dispararTextoElastico("+50 TOKENS DEBUG", width * 0.64, height * 0.40, color(255, 215, 80));
    return true;
  }
  if (key == 'C' || key == 'c') {
    comboActual += 5;
    if (comboActual > comboMaximoRonda) comboMaximoRonda = comboActual;
    pulsoComboUI = 1.0;
    tiempoComboRestante = MAX_TIEMPO_COMBO;
    return true;
  }
  if (key == 'H' || key == 'h') {
    statSaludMental = 100;
    statSeguridad = 100;
    statReputacion = 100;
    statPopularidad = 100;
    for (int i = 0; i < 4; i++) pulsarBarraStat(i);
    dispararTextoElastico("STATS AL 100%", width * 0.64, height * 0.40, color(100, 255, 160));
    return true;
  }
  if (key == 'Q' || key == 'q') {
    iniciarQTEPrecision();
    return true;
  }
  if (key == 'L' || key == 'l') {
    desbloquearTodoCompendioDebug();
    return true;
  }

  return false;
}

void saltarDirectoAAdminNormal() {
  detenerTodaMusica();
  detenerPistaSiSuena(sonidoAbsorcionTransicionVortice, null);
  detenerPistaSiSuena(sonidoNexusCargarBarra, null);
  detenerPistaSiSuena(sonidoDisrupcion1, null);
  detenerPistaSiSuena(sonidoDisrupcion2, null);
  detenerPistaSiSuena(sonidoTransferenciaExitosa, null);
  detenerPistaSiSuena(sonidoEstaticaTituloDolus, null);

  succionando = false;
  progresoSuccion = 0.0;
  escupiendoMenu = false;
  progresoEscupidoMenu = 0.0;
  quemandoDificultad = false;
  progresoQuemarDificultad = 0.0;
  animandoDificultad = false;
  progresoDificultad = 0.0;
  seleccionadoParaJugar = false;
  animandoTVOff = false;
  glitchActivo = false;
  mostrandoSplash = false;
  menuDaltonismoAbierto = false;
  juegoPausado = false;

  ejecutandoLinkStart = false;
  progresoLinkStart = 0.0;
  intensidadSuccionFondo = 0.0;
  ejecutandoCargaNexus = false;
  faseCargaNexus = 0;
  progresoBarraNexus = 0.0;
  numCuadrosError = 0;
  numLineasConsola = 0;
  ejecutandoPantallaCargaMeta = false;
  tiempoInicioCargaMeta = 0;
  ejecutandoCargaJefe = false;

  dificultadSeleccionada = 1;
  dificultadSeleccionadaPendiente = 1;
  inicializarJuego(1);

  conversanteActual = 0;
  fasePluginsActiva = false;
  estadoPantalla = PANTALLA_TRANSICION;

  alphaAparicionJimbo = 1.0;
  animandoAparicionChat = false;
  progresoAparicionChat = 1.0;

  abrirDialogoAdmin(0);
  dispararTextoElastico("SKIP -> ADMIN (NORMAL)", width * 0.5, height * 0.22, colorTema());
}
