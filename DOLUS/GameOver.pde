String razonGameOver = "";
int tipoGameOver = 0;
PImage imgGameOverActual = null;

void verificarGameOverStats() {
  boolean condicionGameOver = (statSaludMental <= 0 || statPopularidad <= 0 || statSeguridad <= 0 || statReputacion <= 0 || vidasJugador < 0);
  if (!condicionGameOver) return;

  if (voucherLazarusActivo && !lazarusUsadoEnPartida) {
    lazarusUsadoEnPartida = true;
    statSaludMental = max(statSaludMental, 60.0);
    statPopularidad = max(statPopularidad, 60.0);
    statSeguridad   = max(statSeguridad, 60.0);
    statReputacion  = max(statReputacion, 60.0);
    vidasJugador    = max(vidasJugador, 1);
    dispararExplosionCarta(width * 0.5, height * 0.5, color(0, 230, 160), true);
    dispararTextoElastico("PROTOCOLO LAZARUS ACTIVADO! KERNEL RESTAURADO", width * 0.5, height * 0.35, color(0, 230, 160));
    dispararSacudidaCamara(6.0);
    if (sonidoShopBuy != null) reproducirSFX(sonidoShopBuy);
    return;
  }

  if (statSaludMental <= 0) {
    dispararGameOver(0, "Sacrificaste demasiada salud mental.\nLa ansiedad te ha consumido. El algoritmo gano.");
  } else {
    if (statPopularidad <= 0) {
      dispararGameOver(1, "Has perdido toda tu atencion y alcance.\nNadie te lee. Eres irrelevante. El algoritmo te olvido.");
    } else {
      if (statSeguridad <= 0) {
        dispararGameOver(2, "Tu sistema ha sido vulnerado completamente.\nTus datos ahora pertenecen a la red.");
      } else {
        if (statReputacion <= 0) {
          dispararGameOver(3, "Tu reputacion ha sido destruida.\nHas sido cancelado masivamente. No hay vuelta atras.");
        } else {
          if (vidasJugador < 0) {
            dispararGameOver(4, "La balanza se ha inclinado totalmente hacia el Algoritmo.\nHas perdido tu ultima oportunidad.");
          }
        }
      }
    }
  }
}

void dispararGameOver(int tipo, String razon) {
  if (modoFeriaActivo) {
    finalizarPartidaModoFeria(tipo, razon);
    return;
  }
  tipoGameOver = tipo;
  razonGameOver = razon;
  guardarPluginsTrasDerrota();
  estadoPantalla = PANTALLA_GAMEOVER;

  detenerTodaMusica();
  if (musicaCredits != null && musicaCredits.frames() > 0) {
    reproducirMusicaUnica(musicaCredits);
  }

  if (tipo >= 0 && tipo < 5 && cacheImgGameOver[tipo] != null) {
    imgGameOverActual = cacheImgGameOver[tipo];
  } else {
    imgGameOverActual = epCargarIlustracionFinal("final_malo_temprano");
  }
}

void actualizarYDibujarGameOver() {
  if (modoFeriaActivo) {
    actualizarYDibujarGameOverFeria();
    return;
  }
  pushStyle();
  background(10, 0, 0);

  textAlign(CENTER, CENTER);
  if (fuenteRetro != null) textFont(fuenteRetro);

  textSize(80);
  dibujarTextoAnimado("GAME OVER", width/2, height * 0.15, color(255, 50, 50), CENTER, 4);

  if (imgGameOverActual != null && imgGameOverActual.width > 0 && imgGameOverActual.height > 0) {
    float maxW = min(width * 0.58, 560);
    float maxH = min(height * 0.40, 290);
    float esc = min(maxW / imgGameOverActual.width, maxH / imgGameOverActual.height);
    float dw = imgGameOverActual.width * esc;
    float dh = imgGameOverActual.height * esc;
    rectMode(CENTER);
    fill(18, 4, 6);
    stroke(185, 45, 50, 200);
    strokeWeight(2);
    rect(width/2, height * 0.45, dw + 10, dh + 10, 4);
    noStroke();
    imageMode(CENTER);
    image(imgShaderDaltonismo(imgGameOverActual), width/2, height * 0.45, dw, dh);
  } else {
    fill(40, 0, 0);
    rectMode(CENTER);
    rect(width/2, height * 0.45, 400, 300);
    fill(255, 100);
    textSize(24);
    text("[IMAGEN ILUSTRATIVA AQUI]", width/2, height * 0.45);
  }

  fill(200);
  textSize(24);
  text(razonGameOver, width/2, height * 0.74);

  if (conservarPluginsTrasDerrota && numPluginsConservadosDerrota > 0) {
    fill(95, 240, 175);
    textSize(14);
    text("[ PLUGINS EQUIPADOS CONSERVADOS PARA TU SIGUIENTE INTENTO: " + numPluginsConservadosDerrota + " ]", width/2, height * 0.82);
  }

  float btnW = 280;
  float btnH = 56;
  float btnRetryX = width/2 - 165;
  float btnMenuX = width/2 + 165;
  float btnY = height * 0.90;

  boolean hovRetry = mouseX >= btnRetryX - btnW/2 && mouseX <= btnRetryX + btnW/2 && mouseY >= btnY - btnH/2 && mouseY <= btnY + btnH/2;
  boolean hovMenu = mouseX >= btnMenuX - btnW/2 && mouseX <= btnMenuX + btnW/2 && mouseY >= btnY - btnH/2 && mouseY <= btnY + btnH/2;
  if (hovRetry || hovMenu) cursorSobreElementoClicable = true;

  rectMode(CENTER);
  fill(hovRetry ? color(15, 95, 55) : color(8, 45, 28));
  stroke(75, 245, 155);
  rect(btnRetryX, btnY, btnW, btnH);
  fill(255);
  textSize(22);
  text("REINTENTAR", btnRetryX, btnY - 3);

  fill(hovMenu ? color(100, 0, 0) : color(50, 0, 0));
  stroke(255, 50, 50);
  rect(btnMenuX, btnY, btnW, btnH);
  fill(255);
  textSize(22);
  text("VOLVER AL MENÚ", btnMenuX, btnY - 3);

  popStyle();
}

void reintentarTrasGameOverManteniendoPlugins() {
  int rondaPrev = max(1, rondaActual);
  int jefePrev = jefeActivo;
  int tokensPrev = max(0, tokensDolus);

  detenerTodaMusica();
  float statRetry = modoExposicionActivo ? 85.0 : 50.0;
  statPopularidad = statRetry;
  statSeguridad   = statRetry;
  statReputacion  = statRetry;
  statSaludMental = statRetry;
  dispPopularidad = statRetry;
  dispSeguridad   = statRetry;
  dispReputacion  = statRetry;
  dispSaludMental = statRetry;
  balanzaEstabilidad = 0;
  dispBalanzaEstabilidad = 0.0;
  vidasJugador = modoExposicionActivo ? 2 : 1;
  comboActual = 0;
  comboMaximoRonda = 0;
  reiniciarMarcoFuegoDolus();
  rondaCompletada = false;
  liquidacionCalculada = false;
  numBandejaMensajes = 0;
  limpiarColaMensajes();
  numCartasSaliendo = 0;
  numParticulasRielSwipe = 0;
  numRayosRielSwipe = 0;
  numParticulasJuego = 0;
  limpiarColaEventos();
  mensajeActivo = -1;
  arrastrando_mensaje = false;
  swipePosX = 0; swipePosY = 0;

  rondaActual = rondaPrev;
  tokensDolus = tokensPrev;
  tokensInicioRonda = tokensPrev;
  jefeActivo = jefePrev;
  for (int s = 0; s < 5; s++) cooldownActivaRestante[s] = 0;

  numInventarioPlugins = 0;
  int maxEq = limiteMaxPluginsEquipados();
  for (int i = 0; i < numPluginsConservadosDerrota; i++) {
    int idx = pluginsConservadosDerrota[i];
    if (idx >= 1 && idx < numCatalogoPlugins && !arrayContieneInt(inventarioPlugins, numInventarioPlugins, idx) && numInventarioPlugins < maxEq) {
      agregarInventarioPlugin(idx);
    }
  }
  sincronizarSlotsEquipados();
  inicializarPluginsGameplay();
  evaluarSinergias();
  if (modoExposicionActivo) {
    if (jefeActivo != 0) {
      inicializarJefe(jefeActivo);
    } else {
      expoIndicePool = 0;
      generarMensajeModoExposicion();
      generarMensajeModoExposicion();
      intentarAsignarMensaje();
    }
  }

  fasePluginsActiva = true;
  mostrandoTutorial = false;
  mostrandoTutorialIngame = false;
  estadoPantalla = PANTALLA_JUEGO;
  if (jefeActivo == 1) reproducirMusicaUnica(musicaJefeTendencia);
  else {
    if (jefeActivo == 2) reproducirMusicaUnica(musicaJefeCamara);
    else {
      if (jefeActivo == 3) reproducirMusicaUnica(musicaJefeDesinformacion);
      else {
        if (jefeActivo == 4) reproducirMusicaUnica(musicaJefeAdmin);
        else reproducirMusicaUnica(musicaGameplayInicial);
      }
    }
  }
  dispararTextoElastico("SISTEMA REINICIADO // PLUGINS CONSERVADOS", width * 0.5, height * 0.25, color(75, 245, 155));
}

void mousePressedGameOver() {
  if (modoFeriaActivo) {
    mousePressedGameOverFeria();
    return;
  }
  float btnW = 280;
  float btnH = 56;
  float btnRetryX = width/2 - 165;
  float btnMenuX = width/2 + 165;
  float btnY = height * 0.90;
  boolean hovRetry = mouseX >= btnRetryX - btnW/2 && mouseX <= btnRetryX + btnW/2 && mouseY >= btnY - btnH/2 && mouseY <= btnY + btnH/2;
  boolean hovMenu = mouseX >= btnMenuX - btnW/2 && mouseX <= btnMenuX + btnW/2 && mouseY >= btnY - btnH/2 && mouseY <= btnY + btnH/2;
  if (hovRetry) {
    reproducirTap();
    reintentarTrasGameOverManteniendoPlugins();
  } else {
    if (hovMenu) {
      reproducirTap();
      volverAlMenuPrincipal();
    }
  }
}
