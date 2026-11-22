boolean mostrandoTutorial = true;
float[] leftPanelSlotY = new float[5];

int statHoverIdx = -1;
float statHoverX = 0, statHoverY = 0;

boolean ultimaCartaRenderValida = false;
float ultimaCartaRenderX = 0;
float ultimaCartaRenderY = 0;
float ultimaCartaRenderRot = 0;
float ultimaCartaRenderScX = 1.0;
float ultimaCartaRenderScY = 1.0;
float ultimaCartaRenderParallaxX = 0;

PImage obtenerImgStat(int idx) {
  if (idx == 0) return imgStatSaludMental;
  if (idx == 1) return imgStatSeguridad;
  if (idx == 2) return imgStatReputacion;
  if (idx == 3) return imgStatPopularidad;
  return null;
}

void actualizarYDibujarInterfazJuego() {
  ultimaCartaRenderValida = false;
  actualizarLogicaDolus();
  dibujarFondoJuego();

  pushStyle();
  statHoverIdx = -1;
  if (fuenteRetro != null) textFont(fuenteRetro);

  color colG = colorTema();
  color colBgPanel = color(6, 14, 10, 245);
  color colAlarma = color(255, 70, 70);

  float breath = sin(frameCount * 0.04) * 4.0;

  float comboShakeX = sacudidaCamaraX;
  float comboShakeY = sacudidaCamaraY;

  float panelIzqX = width * 0.02;
  float panelIntegY = height * 0.03 + breath;
  float panelIntegW = width * 0.26;
  float panelIntegH = height * 0.20;

  dibujarPanelPersona(panelIzqX, panelIntegY, panelIntegW, panelIntegH, colG, colBgPanel);
  dibujarContenidoIntegridadSistema(panelIzqX, panelIntegY, panelIntegW, panelIntegH, colG, colAlarma);

  float panelIzqY = panelIntegY + panelIntegH + height * 0.02 - breath*2;
  float panelIzqW = panelIntegW;
  float panelIzqH = height * 0.72;

  if (modoFeriaActivo) {
    dibujarPanelInferiorIzqFeria(panelIzqX, panelIzqY, panelIzqW, panelIzqH, colG, colBgPanel, colAlarma);
  } else {
    dibujarModuloGameplayInferiorIzq(panelIzqX, panelIzqY, panelIzqW, panelIzqH, colG, colBgPanel, colAlarma);
  }

  float panelTopX = panelIzqX + panelIzqW + width * 0.02;
  float panelTopY = height * 0.03 - breath*0.5;
  float panelTopW = width * 0.68;
  float panelTopH = height * 0.20;

  if (modoFeriaActivo) {
    dibujarPanelSuperiorFeria(panelTopX, panelTopY, panelTopW, panelTopH, colG, colBgPanel);
  } else {
    if (jefeActivo != 0) {
      float bossBoxW = panelTopW * 0.35;
      dibujarUIJefe(panelTopX, panelTopY, bossBoxW, panelTopH);
      panelTopX += bossBoxW + width * 0.01;
      panelTopW -= (bossBoxW + width * 0.01);
    }

    actualizarPluginsGameplay(panelTopX, panelTopY, panelTopW, panelTopH);
  }

  float panelGameX = panelIzqX + panelIzqW + width * 0.02;
  float panelGameW = width * 0.68;
  float panelGameY = panelTopY + panelTopH + height * 0.02;
  float panelGameH = height * 0.72;
  dibujarPanelPersona(panelGameX + comboShakeX, panelGameY + comboShakeY, panelGameW, panelGameH, colG, colBgPanel);

  if (modoFeriaActivo) {
    dibujarBannerDirectivaFeria(panelGameX + comboShakeX, panelGameY + comboShakeY, panelGameW, colG);
  } else if (jefeActivo == 0) {
    dibujarBannerDirectivaRonda(panelGameX + comboShakeX, panelGameY + comboShakeY, panelGameW, colG);
  } else {
    dibujarBarkJefeUI(panelGameX + comboShakeX, panelGameY + comboShakeY, panelGameW, panelGameH);
  }

  float cardW = 500;
  float cardH = 275;
  float cardX = panelGameX + panelGameW * 0.5;
  float cardY = panelGameY + panelGameH * 0.45;
  color colRechazo = color(255, 165, 65);

  float floteIdleY = (!arrastrando_mensaje && !cardEntrando) ? sin(cardFloteAngulo) * 4.5 : 0;

  if (mensajeActivo >= 0 && !arrastrando_mensaje && !mostrandoTutorial && !mostrandoTutorialIngame && !animandoShowcaseDirectiva && !rondaCompletada && !pausaActiva()) {
    float hoverX = cardX + swipePosX;
    float hoverY = cardY + swipePosY + floteIdleY;
    cardHover = (mouseX >= hoverX - cardW * 0.55 && mouseX <= hoverX + cardW * 0.55 &&
                 mouseY >= hoverY - cardH * 0.58 && mouseY <= hoverY + cardH * 0.58);
  } else {
    cardHover = false;
  }
  if ((cardHover || arrastrando_mensaje) && !mostrandoTutorial && !mostrandoTutorialIngame && !rondaCompletada) {
    cursorSobreElementoClicable = true;
  }

  rectMode(CORNER);
  clip(panelGameX + comboShakeX + 3, panelGameY + comboShakeY + 3, panelGameW - 6, panelGameH - 6);

  if (rielSpotlightAlpha > 0.006) {
    dibujarSpotlightRielBorde(1, panelGameX, panelGameY, panelGameW, panelGameH, cardY, colRechazo, comboShakeX, comboShakeY);
    dibujarSpotlightRielBorde(0, panelGameX, panelGameY, panelGameW, panelGameH, cardY, colG, comboShakeX, comboShakeY);
  }

  if (mensajeActivo >= 0 || numCartasSaliendo > 0 || numParticulasRielSwipe > 0 || numRayosRielSwipe > 0) {

    if (mensajeActivo >= 0 && arrastrando_mensaje && jefeActivo != 3) {
      float intDerDrag = constrain(swipePosX / SWIPE_THRESHOLD, 0, 1.3);
      float intIzqDrag = constrain(-swipePosX / SWIPE_THRESHOLD, 0, 1.3);
      float targetArcY = constrain(cardY + swipePosY, panelGameY + panelGameH * 0.20, panelGameY + panelGameH * 0.80);
      if (intDerDrag > 0.36) {
        arcosMagneticosSwipeActivos = true;
        if (!arcosMagneticosPrevios) reproducirActivacionRayo();
        float pArc = map(intDerDrag, 0.36, 1.15, 0.22, 1.0);
        color colDerRayo = (msgCategoriaEspecial[mensajeActivo] == 1) ? color(255, 220, 75) : colG;
        dibujarArcosMagneticosSwipe(
          cardX + swipePosX + cardW * 0.42 + comboShakeX, cardY + swipePosY + comboShakeY,
          obtenerPosicionRielSwipeX(0) + comboShakeX, targetArcY + comboShakeY,
          colDerRayo, pArc, intDerDrag >= 0.95 ? 2 : 1
        );
      } else {
        if (intIzqDrag > 0.36) {
          arcosMagneticosSwipeActivos = true;
          if (!arcosMagneticosPrevios) reproducirActivacionRayo();
          float pArc = map(intIzqDrag, 0.36, 1.15, 0.22, 1.0);
          dibujarArcosMagneticosSwipe(
            cardX + swipePosX - cardW * 0.42 + comboShakeX, cardY + swipePosY + comboShakeY,
            obtenerPosicionRielSwipeX(1) + comboShakeX, targetArcY + comboShakeY,
            colRechazo, pArc, intIzqDrag >= 0.95 ? 2 : 1
          );
        }
      }
    }

    float aperturaMazo = constrain(abs(swipePosX) / SWIPE_THRESHOLD, 0, 1);
    int stackVisible = min(numColaMensajes, 3);
    for (int s = stackVisible - 1; s >= 0; s--) {
      int msgCola = colaMensajes[s];
      float nivelEfectivo = (s + 1) - aperturaMazo * 0.84;
      float stackOff = nivelEfectivo * 22.0;
      float stackScale = 1.0 - nivelEfectivo * 0.068;
      float stackRot = ((s % 2 == 0) ? 1 : -1) * nivelEfectivo * 0.036;
      float stackAlpha = constrain(230 - nivelEfectivo * 46, 80, 242);

      color colStack = (msgCategoriaEspecial[msgCola] == 1) ? color(255, 215, 0) : ((msgCategoriaEspecial[msgCola] == 3) ? colAlarma : colG);
      pushMatrix();
      translate(cardX + comboShakeX, cardY + stackOff + comboShakeY);
      rotate(stackRot);
      scale(stackScale);

      rectMode(CENTER);
      noStroke();
      fill(0, 130);
      rect(8, 12, cardW, cardH, 16);
      fill(9, 20, 15, stackAlpha);
      stroke(colStack, stackAlpha * 0.72);
      strokeWeight(2.3);
      rect(0, 0, cardW, cardH, 16);

      if (s == 0 && aperturaMazo > 0.14) {
        noStroke();
        fill(red(colStack) * 0.22, green(colStack) * 0.22, blue(colStack) * 0.22, stackAlpha * 0.90);
        rect(0, -cardH * 0.5 + 18, cardW - 6, 32, 14, 14, 0, 0);
        fill(colStack, stackAlpha * 0.92);
        textAlign(LEFT, CENTER);
        textSize(16);
        String remPrev = (msgCategoriaEspecial[msgCola] == 2 && msgNivelEncriptado[msgCola] > 0.35) ? "NODO_CIFRADO" : msgRemitente[msgCola];
        text("@" + remPrev, -cardW * 0.5 + 24, -cardH * 0.5 + 56);
        String txtPrev = obtenerTextoMostradoCarta(msgCola);
        asegurarCacheTextoCarta(msgCola, txtPrev, cardW - 64, 96, 19);
        dibujarTextoCartaCacheado(msgCola, 0, 12, color(235, 248, 240, stackAlpha * 0.88));
      } else {
        fill(colStack, stackAlpha * 0.45);
        textAlign(CENTER, CENTER);
        textSize(14);
        text("PAQUETE EN COLA #" + (s + 1), 0, 0);
      }
      popMatrix();
    }

    if (mensajeActivo >= 0) {
      float liftHoverY = (cardHover && !arrastrando_mensaje) ? -7.0 : 0;
      float cardRot = calcularRotacionCartaActiva(cardX);
      float tiltPerspX = arrastrando_mensaje
        ? constrain(swipePosX / 360.0, -0.32, 0.32)
        : (cardHover ? constrain((mouseX - cardX) / (cardW * 0.5), -0.22, 0.22) : 0);

      dibujarCartaMensaje25D(
        mensajeActivo,
        cardX + comboShakeX, cardY + floteIdleY + liftHoverY + comboShakeY,
        swipePosX, swipePosY, cardRot,
        cardEscalaX, cardEscalaY, 255,
        cardHover, cardGrabbed, cardW, cardH, colG, colAlarma,
        tiltPerspX, 0
      );
    }

    for (int i = 0; i < numCartasSaliendo; i++) {
      int csMsgId = csMsg[i];
      if (csMsgId < 0) continue;

      if (csDecision[i] == 2) {
        dibujarCartaSaliendoWarp(
          csMsgId, 2,
          csX[i] + comboShakeX, csY[i] + comboShakeY, csRot[i],
          csEscBase[i], csEscBase[i], csAlpha[i],
          cardW, cardH, colAlarma, 0
        );
      } else {
        color cMag = (csDecision[i] == 0)
          ? ((msgCategoriaEspecial[csMsgId] == 1) ? color(255, 220, 75) : colG)
          : colRechazo;
        float rielX = obtenerPosicionRielSwipeX(csDecision[i]) + comboShakeX;
        float rielY = constrain(csY[i], panelGameY + panelGameH * 0.20, panelGameY + panelGameH * 0.80) + comboShakeY;

        dibujarEstelaCintaPlasmaSwipe(i, cMag, comboShakeX, comboShakeY);

        if (!csCruzoRiel[i]) {
          dibujarArcosMagneticosSwipe(csX[i] + comboShakeX, csY[i] + comboShakeY, rielX, rielY, cMag, 0.96, 2);
        }

        float acortWarp = cos(constrain(csVX[i] * 0.007, -0.36, 0.36) * 0.85);
        dibujarCartaSaliendoWarp(
          csMsgId, csDecision[i],
          csX[i] + comboShakeX, csY[i] + comboShakeY, csRot[i],
          csEscBase[i] * csStretchWarpX[i] * acortWarp, csEscBase[i] * csSquashWarpY[i], 255,
          cardW, cardH, cMag, csFlashSalida[i] + (1.0 - csEscBase[i]) * 0.65
        );
      }
    }

    for (int i = 0; i < numRayosRielSwipe; i++) {
      dibujarRayoRielSwipe(i, comboShakeX, comboShakeY);
    }
    for (int i = 0; i < numParticulasRielSwipe; i++) {
      dibujarParticulaRielSwipe(i, comboShakeX, comboShakeY);
    }

  } else {

    if (!mostrandoTutorial && !mostrandoTutorialIngame) {
      pushMatrix();
      translate(cardX + comboShakeX, cardY + comboShakeY);

      float pSize = 150 + sin(frameCount * 0.05) * 20;
      noFill();
      stroke(colG, 50);
      strokeWeight(2);
      ellipse(0, -20, pSize, pSize);
      stroke(colG, 20);
      strokeWeight(10);
      ellipse(0, -20, pSize + 20, pSize + 20);

      textAlign(CENTER, CENTER);
      fill(colG, 200); textSize(26);

      int dotsCount = (frameCount / 15) % 4;
      String dots = "";
      for(int i = 0; i < dotsCount; i++) dots += ".";

      text("ESPERANDO CONEXION" + dots, 0, -20);

      textSize(18); fill(255, 180);
      text("Mensajes pendientes: " + numColaMensajes, 0, 30);
      popMatrix();
    }
  }

  noClip();

  pushStyle();
  pushMatrix();
  translate(panelGameX + comboShakeX, panelGameY + comboShakeY);
  noFill();
  stroke(colG);
  strokeWeight(4);
  dibujarFormaAngularBase(panelGameW, panelGameH, 25);
  strokeWeight(5);
  line(0, 25, 25, 0);
  line(panelGameW, panelGameH - 25, panelGameW - 25, panelGameH);
  popMatrix();
  popStyle();

  dibujarIconosIntegridadBajoSwipe(cardX, panelGameY, panelGameH, colG, colAlarma, comboShakeX, comboShakeY);

  actualizarYDibujarParticulasJuego();
  actualizarYDibujarFlourishLayer();

  dibujarLineasVelocidad();
  actualizarYDibujarMarcoFuegoDolus();

  dibujarCapasPluginsSuperpuestas();

  if (modoFeriaActivo) {
    dibujarBarraOleadaFeria();
  } else {
    dibujarBalanzaEstabilidadVisual();
  }

  if (destelloAnomalia) {
    alphaDestelloAnomalia = 255;
    destelloAnomalia = false;
  }
  if (alphaDestelloAnomalia > 0) {
    pushStyle();
    fill(0, 255, 100, alphaDestelloAnomalia * 0.8);
    noStroke();
    rectMode(CORNER);
    rect(0, 0, width, height);

    textAlign(CENTER, CENTER);
    if (fuenteRetro != null) textFont(fuenteRetro);
    textSize(80);
    fill(0, alphaDestelloAnomalia);
    text("!! ANOMALIA !!", width/2 + random(-5,5), height/2 + random(-5,5));
    fill(255, alphaDestelloAnomalia);
    text("!! ANOMALIA !!", width/2, height/2);
    popStyle();

    alphaDestelloAnomalia -= 15;
  }

  if (alphaEscanerVisual > 0) {
    pushStyle();
    float scanY = map(alphaEscanerVisual, 255, 0, 0, height);
    stroke(255, 0, 255, alphaEscanerVisual);
    strokeWeight(10);
    line(0, scanY, width, scanY);
    noStroke();
    fill(255, 0, 255, alphaEscanerVisual * 0.3);
    rectMode(CORNER);
    rect(0, 0, width, scanY);

    alphaEscanerVisual -= 10;
    popStyle();
  }

  if (estadoTransicionJefe) {
    dibujarTransicionJefe();
  }

  actualizarYDibujarQTE();

  if (animandoShowcaseDirectiva && !mostrandoTutorial && !mostrandoTutorialIngame) {
    dibujarShowcaseDirectiva();
  }

  actualizarYDibujarGuiaErrorAdmin();

  if (mostrandoTutorial) {
    dibujarCapaTutorial();
  } else {
    if (mostrandoTutorialIngame) {
      dibujarCapaTutorialIngame();
    }
  }

  if (rondaCompletada && timerTransicionTienda > 0) {
    dibujarModalLiquidacionRonda(colG);
  }

  dibujarTextoElasticoFlotante();

  if (statHoverIdx != -1) {
    dibujarTooltipStat(statHoverIdx, statHoverX, statHoverY);
  }

  popStyle();
}

void dibujarBannerDirectivaRonda(float px, float py, float pw, color colG) {
  pushStyle();
  rectMode(CORNER);
  float bx = px + 24;
  float by = py + 14;
  float bw = pw - 48;
  float bh = 42;

  float glowPulse = 0.0;
  if (pulsoDirectivaBanner > 0.01) {
    pulsoDirectivaBanner *= 0.90;
    glowPulse = pulsoDirectivaBanner;
  }

  fill(8, 22, 16, 225);
  stroke(colG, min(255, 150 + glowPulse * 105));
  strokeWeight(1.8 + glowPulse * 2.5);
  rect(bx, by, bw, bh, 8);

  float pulsoLed = 0.5 + 0.5 * sin(frameCount * 0.12);
  noStroke();
  fill(colG, 90 * pulsoLed);
  ellipse(bx + 22, by + bh * 0.5, 18, 18);
  fill(255, 220);
  ellipse(bx + 22, by + bh * 0.5, 8, 8);

  textAlign(LEFT, CENTER);
  textSize(14);
  fill(lerpColor(colG, color(255, 255, 220), 0.18 + 0.18 * pulsoLed));
  String txtIzqBanner = modoExposicionActivo
    ? "MODO EXPOSICION // RONDA 1 (DEMO RAPIDA)"
    : obtenerNombreDirectiva();
  text(txtIzqBanner, bx + 40, by + bh * 0.5 - 2);

  textAlign(RIGHT, CENTER);
  fill(220, 240, 230);
  textSize(13);
  String txtDerBanner = modoExposicionActivo
    ? "MUESTRA DE MECANICAS · ARRASTRA O FLECHAS [<-][->]"
    : obtenerDescDirectiva();
  text(txtDerBanner, bx + bw - 18, by + bh * 0.5 - 2);
  popStyle();
}

void dibujarContenidoIntegridadSistema(float panelIzqX, float panelIntegY, float panelIntegW, float panelIntegH, color colG, color colAlarma) {
  pushStyle();

  dispSaludMental = lerp(dispSaludMental, statSaludMental, 0.08);
  dispSeguridad   = lerp(dispSeguridad, statSeguridad, 0.08);
  dispReputacion  = lerp(dispReputacion, statReputacion, 0.08);
  dispPopularidad = lerp(dispPopularidad, statPopularidad, 0.08);

  boolean alertaCritica = (dispSaludMental <= 25.0 || dispSeguridad <= 25.0 || dispReputacion <= 25.0 || dispPopularidad <= 25.0);
  color colHeader = alertaCritica ? colAlarma : colG;

  textAlign(CENTER, TOP);
  textSize(16);
  fill(colHeader);
  text("INTEGRIDAD // " + nombreJugador, panelIzqX + panelIntegW * 0.5, panelIntegY + 13);

  stroke(colHeader, alertaCritica ? (160 + 85 * sin(frameCount * 0.22)) : 75);
  strokeWeight(1.5);
  line(panelIzqX + 16, panelIntegY + 34, panelIzqX + panelIntegW - 16, panelIntegY + 34);

  int dirPreview = -1;
  if (arrastrando_mensaje && (abs(swipeOffsetX) > 22 || abs(swipePosX) > 22)) {
    dirPreview = (swipePosX > 0 || swipeOffsetX > 0) ? 0 : 1;
  }

  boolean gaslight = (jefeActivo == 3 && gaslightingActivo);
  if (gaslight && random(1) < 0.05) gaslightingActivo = false;

  float iconSz = min(36.0, panelIntegW * 0.155);
  float spanW = panelIntegW - 32;
  float stepX = spanW / 4.0;
  float startX = panelIzqX + 16 + stepX * 0.5;
  float rowCenterY = panelIntegY + panelIntegH * 0.58;

  String[] etiquetasGas = {"GENIAL!", "TODO BIEN!", "TE AMAN!", "NÚMERO 1!"};
  String[] etiquetasStd = {"SALUD", "SEG", "REP", "POP"};
  color[] colsGas = {color(255, 0, 255), color(0, 255, 255), color(255, 255, 0), color(0, 255, 0)};
  float[] vals = {dispSaludMental, dispSeguridad, dispReputacion, dispPopularidad};

  for (int i = 0; i < 4; i++) {
    float ix = startX + i * stepX;
    float iy = rowCenterY;
    PImage img = obtenerImgStat(i);
    String etiq = gaslight ? etiquetasGas[i] : etiquetasStd[i];
    float val = gaslight ? 100.0 : vals[i];
    color colBase = gaslight ? colsGas[i] : color(0);
    int impacto = (gaslight || dirPreview == -1) ? 0 : obtenerImpactoPrevistoStat(i, dirPreview);

    dibujarIconoStatReigns(i, img, etiq, val, ix, iy, iconSz, impacto, pulsoBarraStat[i], colBase, true);
  }

  popStyle();
}

void dibujarModuloGameplayInferiorIzq(float panelIzqX, float panelIzqY, float panelIzqW, float panelIzqH, color colG, color colBgPanel, color colAlarma) {
  dibujarPanelPersona(panelIzqX, panelIzqY, panelIzqW, panelIzqH, colG, colBgPanel);

  textAlign(LEFT, TOP);
  textSize(24);
  fill(colG);
  text("EVENTOS ACTIVOS", panelIzqX + 20, panelIzqY + 20);

  stroke(colG, 150); strokeWeight(3);
  line(panelIzqX + 15, panelIzqY + 50, panelIzqX + panelIzqW - 15, panelIzqY + 50);

  float evY = panelIzqY + 65;
  boolean hayEventos = false;
  textSize(16);

  if (bulletTimeActivo) { dibujarEventoActivo("BULLET TIME", panelIzqX + 20, evY, colG); evY += 28; hayEventos = true; }
  if (jackpotBinarioActivo) { dibujarEventoActivo("JACKPOT x2", panelIzqX + 20, evY, colG); evY += 28; hayEventos = true; }
  if (jammingActivo) { dibujarEventoActivo("JAMMING", panelIzqX + 20, evY, colG); evY += 28; hayEventos = true; }
  if (rachaImparableActiva) { dibujarEventoActivo("RACHA IMPARABLE", panelIzqX + 20, evY, colG); evY += 28; hayEventos = true; }
  if (invisibleActivo) { dibujarEventoActivo("INVISIBLE", panelIzqX + 20, evY, colG); evY += 28; hayEventos = true; }
  if (modoAutomaticoActivo) { dibujarEventoActivo("MODO AUTO", panelIzqX + 20, evY, colG); evY += 28; hayEventos = true; }
  if (singularidadActiva) { dibujarEventoActivo("SINGULARIDAD", panelIzqX + 20, evY, colG); evY += 28; hayEventos = true; }
  if (doppelgangerActivo) { dibujarEventoActivo("DOPPELGANGER", panelIzqX + 20, evY, colG); evY += 28; hayEventos = true; }
  if (trampaDesplegadaActiva) { dibujarEventoActivo("TRAMPA ACTIVA", panelIzqX + 20, evY, colG); evY += 28; hayEventos = true; }
  if (qteActivo) { dibujarEventoActivo("MALWARE DETECTADO", panelIzqX + 20, evY, colAlarma); evY += 28; hayEventos = true; }
  for (int s = 0; s < numSinergiasActivas; s++) {
    dibujarEventoActivo("SYN: " + synCatNombre[sinergiasActivas[s]], panelIzqX + 20, evY, color(255, 215, 80));
    evY += 28;
    hayEventos = true;
  }

  float maxEvY = panelIzqY + panelIzqH * 0.45 - 28;
  for (int v = 0; v < 8; v++) {
    if (catalogoVouchersInicializado && vouchComprado[v]) {
      if (evY <= maxEvY) {
        PImage sprMini = obtenerSpriteVoucherMini(v);
        dibujarEventoVoucherActivo(sprMini, vouchNombre[v], panelIzqX + 20, evY, colG);
        evY += 28;
        hayEventos = true;
      }
    }
  }

  if (!hayEventos) {
    fill(150);
    text("Sin eventos activos", panelIzqX + 20, evY);
  }

  float plugY = panelIzqY + panelIzqH * 0.45;
  textSize(24);
  fill(colG);
  text("PLUGINS EQUIPADOS", panelIzqX + 20, plugY);

  stroke(colG, 150); strokeWeight(3);
  line(panelIzqX + 15, plugY + 30, panelIzqX + panelIzqW - 15, plugY + 30);

  plugY += 45;
  int totalSlotsHUD = limiteMaxSlotsRack();
  float stepHUD = (totalSlotsHUD > 4) ? 29.0 : 35.0;
  for (int i = 0; i < totalSlotsHUD; i++) {
    leftPanelSlotY[i] = plugY;
    dibujarSlotPluginIzquierdo(i, panelIzqX + 20, plugY, panelIzqW - 40, 28, colG, colAlarma);
    plugY += stepHUD;
  }

  float progY = plugY + 15;
  int metaBalHUD = obtenerMetaBalanzaActual();
  int faltanBal = max(0, metaBalHUD - balanzaEstabilidad);
  boolean peligroAlg = (balanzaEstabilidad < 0);
  boolean enEmpujon = esUltimoEmpujonActivo();
  boolean cercaGanar = enEmpujon || (balanzaEstabilidad >= metaBalHUD - 2);
  fill(peligroAlg ? colAlarma : colG);
  textSize(14);
  textAlign(LEFT, TOP);
  pushMatrix();
  translate(panelIzqX + 20, progY + 6);
  scale(1.0 + pulsoRestantesUI * 0.14, 1.0 - pulsoRestantesUI * 0.08);
  rotate(sin(pulsoRestantesUI * PI) * 0.03);
  if (peligroAlg && balanzaEstabilidad <= -(metaBalHUD - 2)) {
    fill(colAlarma);
    text("PELIGRO ALGORITMO! (" + balanzaEstabilidad + "/-" + metaBalHUD + ")", 0, -6);
  } else {
    if (enEmpujon) {
      fill(color(255, 215, 80));
      text("ULTIMO EMPUJON! +" + faltanBal + " BAL.", 0, -6);
    } else {
      if (cercaGanar) {
        fill(color(255, 215, 80));
        text("CASI GANAS! FALTA +" + faltanBal + " BAL.", 0, -6);
      } else {
        String signBal = (balanzaEstabilidad > 0) ? "+" : "";
        text("BALANZA R" + rondaActual + " (" + signBal + balanzaEstabilidad + " / +" + metaBalHUD + ")", 0, -6);
      }
    }
  }
  popMatrix();

  float progBarW = panelIzqW - 150;
  float progBarH = 10 + pulsoRestantesUI * 4.0;
  noFill(); stroke(peligroAlg ? colAlarma : colG, 100 + pulsoRestantesUI * 120); strokeWeight(2);
  rectMode(CORNER);
  rect(panelIzqX + 20, progY + 20 - pulsoRestantesUI * 2.0, progBarW, progBarH, 5);

  float progP = constrain(abs((float)balanzaEstabilidad) / max(1, metaBalHUD), 0, 1);
  fill(peligroAlg ? colAlarma : (cercaGanar ? color(255, 215, 80) : (pulsoRestantesUI > 0.2 ? lerpColor(colG, color(255), pulsoRestantesUI * 0.6) : colG)));
  noStroke();
  rect(panelIzqX + 20, progY + 20 - pulsoRestantesUI * 2.0, progBarW * progP, progBarH, 5);

  pushMatrix();
  translate(panelIzqX + panelIzqW - 70, panelIzqY + panelIzqH - 120);
  rotate(-0.05 + sin(pulsoComboUI * PI) * 0.08);
  textAlign(CENTER, CENTER);

  float shakeCombo = comboActual > 0 ? random(-1.5, 1.5) : 0;
  fill(0, 150); text("x" + comboActual, 6 + shakeCombo, 6 + shakeCombo);

  fill(comboActual > 0 ? lerpColor(colG, color(255), abs(sin(frameCount*0.1))) : color(100, 150, 120));
  float comboScaleExtra = pulsoComboUI * 14.0;
  if (comboActual > 0) {
    comboScaleExtra += min(comboActual * 1.5, 20) + sin(frameCount * 0.2) * min(comboActual, 8);
  }
  textSize(int(36 + comboScaleExtra));
  text("x" + comboActual, shakeCombo, shakeCombo);
  textSize(18);
  text("Combo", 0, 35);

  if (comboActual > 0) {
    rectMode(CENTER);
    fill(0, 100);
    rect(0, 50, 80, 8, 4);
    fill(lerpColor(color(255,50,50), colG, tiempoComboRestante/MAX_TIEMPO_COMBO));
    float bw = 80 * (tiempoComboRestante/MAX_TIEMPO_COMBO);
    rect(0, 50, bw, 8, 4);
  }

  float shimmer = 150 + sin(frameCount * 0.1) * 105;
  pushMatrix();
  translate(0, 70);
  scale(1.0 + pulsoTokensUI * 0.28, 1.0 - pulsoTokensUI * 0.12);
  fill(0, 150); text("Tokens: " + tokensDolus, 4, 4);
  fill(255, 200, 100, shimmer);
  textSize(18);
  text("Tokens: " + tokensDolus, 0, 0);
  popMatrix();
  popMatrix();
}

void dibujarModalLiquidacionRonda(color colG) {
  pushStyle();

  float tVuelo = constrain(timerTransicionTienda / 11.0, 0.0, 1.0);
  float eVuelo = easeOutCubic(tVuelo);

  float startX = width * 0.84;
  float startY = height + 260.0;
  float posX = lerp(startX, width * 0.5, eVuelo) + sacudidaCamaraX;
  float posY = lerp(startY, height * 0.5, eVuelo) + sacudidaCamaraY;

  float escX = lerp(1.38, 1.0, eVuelo);
  float escY = escX;
  float rotCarta = lerp(0.28, 0.0, eVuelo);

  if (timerTransicionTienda >= 11 && timerTransicionTienda < 20) {
    float pImpacto = (timerTransicionTienda - 11.0) / 9.0;
    float rebote = sin(pImpacto * PI) * (1.0 - pImpacto);
    escX = 1.0 + rebote * 0.14;
    escY = 1.0 - rebote * 0.11;
    rotCarta = sin(pImpacto * TWO_PI) * 0.022 * (1.0 - pImpacto);
  } else {
    if (timerTransicionTienda >= 20) {
      posY += sin(frameCount * 0.05) * 3.0;
      rotCarta = sin(frameCount * 0.035) * 0.007;
    }
  }

  if (animandoSalidaLiquidacion) {
    float pOut = pow(progresoSalidaLiquidacion, 2.0);
    float travelDist = width * 0.5 + 340 + 80;
    posX += pOut * travelDist;
    posY -= sin(progresoSalidaLiquidacion * PI) * 45.0;
    rotCarta += progresoSalidaLiquidacion * 0.30;
    escX *= (1.0 - progresoSalidaLiquidacion * 0.10);
    escY *= (1.0 - progresoSalidaLiquidacion * 0.10);
  }

  float mw = 680;
  float mh = 510;
  pushMatrix();
  translate(posX, posY);
  rotate(rotCarta);
  scale(escX, escY);

  rectMode(CENTER);
  noStroke();
  float distSombra = lerp(46.0, 14.0, eVuelo);
  float aSombra = 225 * eVuelo;
  if (animandoSalidaLiquidacion) {
    aSombra *= (1.0 - progresoSalidaLiquidacion * 0.6);
  }
  fill(0, aSombra);
  rect(distSombra, distSombra + 4, mw, mh, 18);

  fill(6, 16, 12, 252);
  stroke(colG);
  strokeWeight(4.0);
  rect(0, 0, mw, mh, 18);

  noFill();
  stroke(colG, 85);
  strokeWeight(1.5);
  rect(0, 0, mw - 18, mh - 18, 12);

  float foilL = ((mouseX - posX) * 0.7 + frameCount * 2.8) % (mw * 1.3) - mw * 0.65;
  float fx1 = constrain(foilL - 65, -mw * 0.48, mw * 0.48);
  float fx2 = constrain(foilL + 65, -mw * 0.48, mw * 0.48);
  if (fx2 > fx1 + 4) {
    noStroke();
    fill(red(colG), green(colG), blue(colG), 22);
    rectMode(CORNERS);
    rect(fx1, -mh * 0.48, fx2, mh * 0.48, 10);
    rectMode(CENTER);
  }

  fill(colG);
  noStroke();
  rect(0, -mh * 0.5 + 31, mw - 10, 52, 14, 14, 0, 0);

  String txtTitulo = (jefeActivo == 4 && ultimoJefeDerrotado)
    ? ("EL ALGORITMO DERROTADO - RONDA " + rondaActual)
    : ((jefeActivo != 0)
        ? ("JEFE SUPERADO - RONDA " + rondaActual)
        : ("LIQUIDACION DE RONDA " + rondaActual));
  textSize(24);
  dibujarTextoAnimado(txtTitulo, 0, -mh * 0.5 + 29, color(8, 18, 12, 255), CENTER, 1);

  if (timerTransicionTienda >= 11) {
    float tInfo = constrain((timerTransicionTienda - 11.0) / 5.0, 0.0, 1.0);
    fill(12, 30, 22, 225 * tInfo);
    stroke(colG, 75 * tInfo);
    strokeWeight(1);
    rect(0, -172, mw - 52, 28, 6);

    textSize(12);
    textAlign(LEFT, CENTER);
    fill(190, 220, 205, 255 * tInfo);
    text("CARTAS: " + mensajesProcesadosRonda, -mw * 0.5 + 42, -173);

    textAlign(CENTER, CENTER);
    String signoFarm = (liqFarmRonda >= 0) ? "+" : "";
    fill(110, 245, 175, 255 * tInfo);
    text("FARM EN TURNO: " + signoFarm + liqFarmRonda + "T", 0, -173);

    textAlign(RIGHT, CENTER);
    fill(255, 215, 95, 255 * tInfo);
    text("CAJA ACTUAL: " + tokensDolus + "T", mw * 0.5 - 42, -173);
  }

  float filaY = -124;
  float sepY = 46;

  if (timerTransicionTienda >= 14) {
    String lblBase = (jefeActivo != 0) ? "RECOMPENSA JEFE DERROTADO" : ("SUELDO BASE (RONDA " + rondaActual + ")");
    dibujarFilaLiquidacion(lblBase, liqBase, filaY, colG, timerTransicionTienda - 14);
  }
  if (timerTransicionTienda >= 23) {
    String lblCombo = "COMBO MAXIMO (x" + comboMaximoRonda + ")" + (sinergiaActiva(4) ? " [SYN x2]" : "");
    dibujarFilaLiquidacion(lblCombo, liqComboBonus, filaY + sepY, color(100, 220, 255), timerTransicionTienda - 23);
  }
  if (timerTransicionTienda >= 32) {
    String lblInt = "INTEGRIDAD MEDIA (" + liqPromIntegridad + "%)";
    dibujarFilaLiquidacion(lblInt, liqIntegridadBonus, filaY + sepY * 2, color(120, 255, 160), timerTransicionTienda - 32);
  }
  if (timerTransicionTienda >= 41) {
    dibujarFilaLiquidacion("INTERES BANCARIO (1T CADA 10T)", liqInteres, filaY + sepY * 3, color(255, 215, 80), timerTransicionTienda - 41);
  }

  if (timerTransicionTienda >= 49) {
    float progLinea = constrain((timerTransicionTienda - 49.0) / 5.0, 0.0, 1.0);
    stroke(colG, 185);
    strokeWeight(2);
    line(-mw * 0.44 * progLinea, 46, mw * 0.44 * progLinea, 46);
  }

  if (timerTransicionTienda >= 53) {
    float fTot = timerTransicionTienda - 53.0;
    float tPopTot = constrain(fTot / 6.0, 0.0, 1.0);
    float eTot = easeOutBack(tPopTot);
    float progConteo = constrain(fTot / 10.0, 0.0, 1.0);
    int totalMostrado = int(round(lerp(0, liqTotal, progConteo)));

    pushMatrix();
    translate(0, 82);
    scale(lerp(1.16, 1.0, eTot), lerp(0.75, 1.0, eTot));
    fill(18, 38, 26, 235 * tPopTot);
    stroke(255, 215, 80, 180 * tPopTot);
    strokeWeight(2);
    rect(0, 0, mw - 52, 50, 10);

    textSize(19);
    dibujarTextoAnimado("PAGO DE LIQUIDACION:", -mw * 0.5 + 46, -2, color(255), LEFT, 1);

    textSize(27);
    dibujarTextoAnimado("+" + totalMostrado + " TOKENS", mw * 0.5 - 46, -2, color(255, 220, 85), RIGHT, 3);
    popMatrix();

    if (timerTransicionTienda >= 58) {
      float aSaldo = constrain((timerTransicionTienda - 58.0) / 5.0, 0.0, 1.0) * 255.0;
      textAlign(CENTER, CENTER);
      textSize(14);
      fill(210, 235, 220, aSaldo);
      text("SALDO FINAL PARA TIENDA:  " + tokensDolus + "T  +  " + totalMostrado + "T  =  " + (tokensDolus + totalMostrado) + " TOKENS", 0, 128);
    }
  }

  if (timerTransicionTienda >= FRAMES_FIN_LIQUIDACION) {
    float tBtn = constrain((timerTransicionTienda - FRAMES_FIN_LIQUIDACION) / 8.0, 0.0, 1.0);
    float eBtn = easeOutBack(tBtn);
    pushMatrix();
    translate(0, 194);
    scale(lerp(0.65, 1.0, eBtn), lerp(1.30, 1.0, eBtn));
    String txtBotonLiq = (jefeActivo == 4 && ultimoJefeDerrotado)
      ? ("COBRAR +" + liqTotal + " TOKENS  [SALIR DEL VISOR >>]")
      : ("COBRAR +" + liqTotal + " TOKENS  [TIENDA >>]");
    dibujarBotonSquishy(txtBotonLiq, 0, 0, 490, 52, color(255, 215, 80), 18);
    popMatrix();
  } else {
    if (timerTransicionTienda >= 11) {

      float progEval = constrain((timerTransicionTienda - 11.0) / (FRAMES_FIN_LIQUIDACION - 11.0), 0.0, 1.0);
      float barW = 360;
      float barY = 196;
      fill(10, 24, 18, 210);
      stroke(colG, 90);
      strokeWeight(1.2);
      rect(0, barY, barW, 24, 6);

      noStroke();
      fill(colG, 185);
      rectMode(CORNER);
      rect(-barW * 0.5 + 3, barY - 9, (barW - 6) * progEval, 18, 4);
      rectMode(CENTER);

      textAlign(CENTER, CENTER);
      textSize(12);
      fill(245, 255, 250);
      text("EVALUANDO ACTIVOS DE RED...", 0, barY - 1);
    }
  }

  popMatrix();
  popStyle();
}

void dibujarFilaLiquidacion(String concepto, int cantidadTokens, float y, color colVal, float framesDesdeAparicion) {
  float t = constrain(framesDesdeAparicion / 6.0, 0.0, 1.0);
  float e = easeOutBack(t);
  float escX = (t < 1.0) ? lerp(1.15, 1.0, e) : 1.0;
  float escY = (t < 1.0) ? lerp(0.72, 1.0, e) : 1.0;
  boolean tieneBono = (cantidadTokens > 0);

  pushMatrix();
  translate(0, y);
  scale(escX, escY);
  rectMode(CENTER);
  fill(12, 28, 20, 220 * t);
  stroke(tieneBono ? colVal : color(110, 130, 120), (tieneBono ? 120 : 45) * t);
  strokeWeight(1.4);
  rect(0, 0, 628, 36, 8);

  textAlign(LEFT, CENTER);
  textSize(14);
  fill(0, 175 * t);
  text(concepto, -296, 0);
  fill(tieneBono ? color(235, 248, 240, 255 * t) : color(155, 170, 162, 215 * t));
  text(concepto, -298, -2);

  if (tieneBono) {
    int maxPips = min(cantidadTokens, 8);
    float pipBaseX = 68;
    textSize(15);
    textAlign(CENTER, CENTER);
    for (int p = 0; p < maxPips; p++) {
      float tp = constrain((framesDesdeAparicion - 1.0 - p * 0.55) / 3.2, 0.0, 1.0);
      if (tp <= 0.01) continue;
      float ep = easeOutBack(tp);
      pushMatrix();
      translate(pipBaseX + p * 13.0, -2);
      scale(ep);
      fill(0, 170 * tp);
      text("$", 1.5, 1.5);
      fill(red(colVal), green(colVal), blue(colVal), 255 * tp);
      text("$", 0, 0);
      popMatrix();
    }
    if (cantidadTokens > 8 && framesDesdeAparicion >= 5.0) {
      fill(colVal);
      textSize(13);
      text("+", pipBaseX + 8 * 13.0 + 2, -2);
    }
  } else {
    if (framesDesdeAparicion >= 2.0) {
      textAlign(CENTER, CENTER);
      textSize(13);
      fill(120, 135, 128, 170 * t);
      text("--", 110, -2);
    }
  }

  if (framesDesdeAparicion >= 2.5) {
    float tv = constrain((framesDesdeAparicion - 2.5) / 4.5, 0.0, 1.0);
    float ev = easeOutBack(tv);
    pushMatrix();
    translate(298, -2);
    scale(ev);
    if (tieneBono) {
      textSize(17);
      dibujarTextoAnimado("+" + cantidadTokens + " TOKENS", 0, 0, colVal, RIGHT, 2);
    } else {
      textAlign(RIGHT, CENTER);
      textSize(16);
      fill(135, 150, 142, 205 * tv);
      text("+0 TOKENS", 0, 0);
    }
    popMatrix();
  }
  popMatrix();
}

void dibujarSlotPluginIzquierdo(int i, float x, float y, float wP, float hP, color colG, color colAlarma) {
  if (i == 0) {

    pushStyle();
    pushMatrix();
    translate(x, y);

    fill(12, 16, 14, 225);
    stroke(120, 135, 128, 170);
    strokeWeight(1.8);
    beginShape();
    float cP = 8;
    vertex(cP, 0); vertex(wP, 0); vertex(wP, hP - cP); vertex(wP - cP, hP); vertex(0, hP); vertex(0, cP);
    endShape(CLOSE);

    fill(95, 115, 105, 105);
    textSize(12);
    textAlign(LEFT, CENTER);
    text("S1 | N.01", 10, hP * 0.5 - 2);
    textAlign(RIGHT, CENTER);
    text("[FIJO]", wP - 10, hP * 0.5 - 2);

    stroke(colAlarma, 195);
    strokeWeight(2.2);
    line(8, 4, wP - 8, hP - 4);
    line(8, hP - 4, wP - 8, 4);
    line(6, hP * 0.5, wP - 6, hP * 0.5);

    rectMode(CENTER);
    fill(8, 14, 11, 244);
    stroke(255, 205, 85, 225);
    strokeWeight(1.5);
    rect(wP * 0.5, hP * 0.5, 168, hP - 6, 4);

    fill(255, 215, 95);
    textSize(12);
    textAlign(CENTER, CENTER);
    text("LLAVE DE ACCESO", wP * 0.5, hP * 0.5 - 2);

    popMatrix();
    popStyle();
    return;
  }

  int idEq = slotsPluginEquipado[i];
  boolean silenciado = (jefeActivo == 4 && i == slotSilenciadoAlgoritmo);
  boolean hoverSlot = (!mostrandoTutorial && !mostrandoTutorialIngame && !animandoShowcaseDirectiva && !rondaCompletada && mouseX >= x && mouseX <= x + wP && mouseY >= y && mouseY <= y + hP);
  if (hoverSlot && idEq >= 0 && !silenciado) cursorSobreElementoClicable = true;
  float juice = slotPluginJuice[i];
  float rotJ = slotPluginJuiceRot[i] * juice;

  pushStyle();
  pushMatrix();
  translate(x + wP * 0.5, y + hP * 0.5);
  rotate(rotJ);
  float escX = 1.0 + juice * 0.18 + (hoverSlot ? 0.03 : 0.0);
  float escY = 1.0 - juice * 0.10 + (hoverSlot ? 0.03 : 0.0);
  scale(escX, escY);
  translate(-wP * 0.5, -hP * 0.5);

  fill(silenciado ? color(35, 8, 8, 220) : (hoverSlot ? color(18, 38, 26, 230) : color(10, 20, 15, 200)));
  stroke(silenciado ? colAlarma : (juice > 0.1 ? color(255) : colG), hoverSlot || juice > 0.1 ? 230 : 120);
  strokeWeight(hoverSlot || juice > 0.1 ? 2.5 : 1.5);
  beginShape();
  float cP = 8;
  vertex(cP, 0); vertex(wP, 0); vertex(wP, hP - cP); vertex(wP - cP, hP); vertex(0, hP); vertex(0, cP);
  endShape(CLOSE);

  if (idEq >= 0 && idEq < numCatalogoPlugins) {
    fill(silenciado ? color(255, 110, 110) : color(255));
    textSize(14);
    textAlign(LEFT, CENTER);
    text("S" + (i + 1) + " | " + plugCatId[idEq] + " " + plugCatNombrePasiva[idEq], 10, hP/2 - 2);

    if (silenciado) {
      stroke(colAlarma);
      strokeWeight(2);
      line(6, hP/2, wP - 6, hP/2);
      fill(colAlarma);
      textAlign(RIGHT, CENTER);
      textSize(12);
      text("SILENCIADO", wP - 8, hP/2 - 2);
    } else {
      if (cooldownActivaRestante[i] > 0) {
        fill(colAlarma);
        textAlign(RIGHT, CENTER);
        textSize(13);
        text("CD:" + (cooldownActivaRestante[i] / 60 + 1) + "s", wP - 8, hP/2 - 2);
      } else {
        if (plugCatCostoTokensActiva[idEq] > 0) {
          fill(255, 215, 90);
          textAlign(RIGHT, CENTER);
          textSize(12);
          text("[" + plugCatCostoTokensActiva[idEq] + "T]", wP - 8, hP/2 - 2);
        }
      }
    }
  } else {
    fill(silenciado ? color(180, 70, 70) : color(100));
    textSize(14);
    textAlign(LEFT, CENTER);
    text(silenciado ? "S" + (i + 1) + " | [NODO BLOQUEADO]" : "S" + (i + 1) + " | [VACIO]", 10, hP/2 - 2);
  }

  popMatrix();
  popStyle();
}

void dibujarEventoActivo(String txt, float x, float y, color c) {
  pushStyle();
  float pulso = sin(frameCount * 0.08) * 0.3 + 0.7;
  fill(c, 30 * pulso); stroke(c, 180 * pulso); strokeWeight(1.5);
  rectMode(CORNER);
  float w = textWidth(txt) + 20;
  rect(x, y - 4, w, 24, 6);
  fill(255, 240 * pulso);
  textSize(14);
  text(txt, x + 10, y);
  popStyle();
}

void dibujarEventoVoucherActivo(PImage icon, String nombre, float x, float y, color c) {
  pushStyle();
  textSize(13);
  float pulso = sin(frameCount * 0.08) * 0.25 + 0.75;
  color colCyan = (modoDaltonismo == 0) ? color(80, 245, 195) : colorShaderDaltonismo(color(80, 245, 195));

  String txtNombre = (nombre != null) ? strToUpper(nombre) : "RAM";
  float iconW = (icon != null) ? 16 : 0;
  float txtW = textWidth(txtNombre + ": ACTIVO");
  float totalW = iconW + 12 + txtW + 16;
  totalW = min(totalW, width * 0.26 - 40);

  fill(c, 32 * pulso);
  stroke(colCyan, 180 * pulso);
  strokeWeight(1.5);
  rectMode(CORNER);
  rect(x, y - 4, totalW, 24, 6);

  if (icon != null) {
    imageMode(CORNER);
    noTint();
    image(imgShaderDaltonismo(icon), x + 6, y - 2, 16, 20);
  }

  textAlign(LEFT, TOP);
  float txtX = x + (icon != null ? 28 : 10);
  fill(240, 252, 246, 245);
  text(txtNombre + ": ", txtX, y);

  float prefixW = textWidth(txtNombre + ": ");
  fill(colCyan, 255 * pulso);
  text("ACTIVO", txtX + prefixW, y);

  popStyle();
}

void dibujarPanelPersona(float x, float y, float w, float h, color c, color bg) {
  pushStyle();
  rectMode(CORNER);

  noStroke(); fill(0, 230);
  pushMatrix();
  translate(x + 18, y + 20);
  dibujarFormaAngularBase(w, h, 25);
  popMatrix();

  fill(bg); stroke(c); strokeWeight(4);
  pushMatrix();
  translate(x, y);
  dibujarFormaAngularBase(w, h, 25);

  noStroke(); fill(c, 40);
  beginShape();
  vertex(w - 70, 0); vertex(w, 0); vertex(w, 70); vertex(w - 70, 0);
  endShape();

  stroke(c); strokeWeight(5);
  line(0, 25, 25, 0);
  line(w, h - 25, w - 25, h);
  popMatrix();

  popStyle();
}

void dibujarFormaAngularBase(float w, float h, float corte) {
  beginShape();
  vertex(corte, 0);
  vertex(w, 0);
  vertex(w, h - corte);
  vertex(w - corte, h);
  vertex(0, h);
  vertex(0, corte);
  endShape(CLOSE);
}

void dibujarBotonSquishy(String texto, float x, float y, float w, float h, color c, float tamTexto) {
  pushStyle();
  rectMode(CENTER);

  float sx = screenX(x, y);
  float sy = screenY(x, y);
  boolean hover = (mouseX >= sx - w/2 && mouseX <= sx + w/2 && mouseY >= sy - h/2 && mouseY <= sy + h/2);

  if (hover) {
    cursorSobreElementoClicable = true;
    if (!globalUltimoBotonHover.equals(texto)) {
      reproducirSFXConTono(sndHoverPlugin, random(1.3, 1.5), 0.35);
      globalUltimoBotonHover = texto;
    }
  } else {
    if (globalUltimoBotonHover.equals(texto)) {
      globalUltimoBotonHover = "";
    }
  }

  pushMatrix();
  translate(x, y);

  boolean presionado = hover && mousePressed;

  if (presionado) {
    scale(1.22, 0.82);
    rotate(random(-0.03, 0.03));
  } else {
    if (hover) {
      scale(1.12, 1.15);
      rotate(random(-0.015, 0.015));
    } else {
      scale(1.0 + sin(frameCount * 0.05 + x) * 0.02);
      rotate(sin(frameCount * 0.03 + y) * 0.015);
    }
  }

  fill(0, 180); noStroke();
  pushMatrix(); translate(6, 6); dibujarFormaAngularBoton(w, h, h*0.35); popMatrix();

  if (hover) {
    fill(c); stroke(255);
  } else {
    fill(4, 12, 9, 240); stroke(c);
  }
  strokeWeight(2.5);
  dibujarFormaAngularBoton(w, h, h*0.35);

  textAlign(CENTER, CENTER);
  fill(hover ? 0 : c);
  textSize(tamTexto);
  if (fuenteRetro != null) textFont(fuenteRetro);
  text(texto, 0, -2);

  popMatrix();
  popStyle();
}

void dibujarFormaAngularBoton(float w, float h, float corte) {
  float hw = w / 2.0; float hh = h / 2.0;
  beginShape();
  vertex(-hw + corte, -hh); vertex(hw, -hh); vertex(hw, hh - corte);
  vertex(hw - corte, hh); vertex(-hw, hh); vertex(-hw, -hh + corte);
  endShape(CLOSE);
}

void dibujarBarraStat(String nombre, float valor, float x, float y, float w, float h, color c, float pulso, int impactoPrevisto) {
  pushStyle();

  textAlign(RIGHT, CENTER);
  fill(pulso > 0.15 ? lerpColor(color(255), c, 0.5) : color(255));
  textSize(int(12 + pulso * 2.5));
  text(nombre, x - w/2 - 15, y);

  if (impactoPrevisto > 0) {
    float rDot = (impactoPrevisto == 2) ? 9.0 : 5.5;
    float pulsoDot = 1.0 + sin(frameCount * 0.25) * 0.28;
    noStroke();
    fill(255, 230, 90, 90);
    ellipse(x + w/2 + 16, y, rDot * 2.0 * pulsoDot, rDot * 2.0 * pulsoDot);
    fill(255, 250, 180);
    ellipse(x + w/2 + 16, y, rDot * pulsoDot, rDot * pulsoDot);
  }

  float vib = (valor <= 0) ? random(-3, 3) : 0;

  pushMatrix();
  translate(x - w/2 + vib, y - h/2 + vib - pulso * 2.0);
  scale(1.0 + pulso * 0.04, 1.0 + pulso * 0.22);

  stroke(pulso > 0.2 ? color(255) : c, 150 + pulso * 105); strokeWeight(2); noFill();
  quad(0, h, h*0.5, 0, w + h*0.5, 0, w, h);

  fill(pulso > 0.2 ? lerpColor(c, color(255), pulso * 0.6) : c); noStroke();
  float wFill = w * (valor / 100.0);
  if (wFill > 0) quad(2, h-2, h*0.5 + 2, 2, wFill + h*0.5 - 2, 2, wFill - 2, h-2);

  if (valor <= 0 && frameCount % 10 < 5) {
    fill(255, 0, 0, 180);
    quad(2, h-2, h*0.5 + 2, 2, w + h*0.5 - 2, 2, w - 2, h-2);
  }

  popMatrix();
  popStyle();
}

void dibujarIconosIntegridadBajoSwipe(float cardX, float panelGameY, float panelGameH, color colG, color colAlarma, float comboShakeX, float comboShakeY) {
  pushStyle();

  float dockW = 390;
  float dockH = 68;
  float dockX = cardX + comboShakeX;
  float dockY = panelGameY + panelGameH * 0.86 + comboShakeY;

  rectMode(CENTER);
  noStroke();
  fill(0, 210);
  rect(dockX, dockY + 4, dockW, dockH, 14);

  fill(8, 13, 17, 250);
  stroke(colG, 140);
  strokeWeight(2.0);
  rect(dockX, dockY, dockW, dockH, 14);

  stroke(colG, 190);
  strokeWeight(2.5);
  line(dockX - dockW*0.5 + 8, dockY - dockH*0.5 + 2, dockX - dockW*0.5 + 22, dockY - dockH*0.5 + 2);
  line(dockX + dockW*0.5 - 22, dockY - dockH*0.5 + 2, dockX + dockW*0.5 - 8, dockY - dockH*0.5 + 2);
  line(dockX - dockW*0.5 + 8, dockY + dockH*0.5 - 2, dockX - dockW*0.5 + 22, dockY + dockH*0.5 - 2);
  line(dockX + dockW*0.5 - 22, dockY + dockH*0.5 - 2, dockX + dockW*0.5 - 8, dockY + dockH*0.5 - 2);

  stroke(colG, 45);
  strokeWeight(1.2);
  float step = 88.0;
  for (int d = -1; d <= 1; d++) {
    float dxDiv = dockX + (d + 0.5) * step;
    line(dxDiv, dockY - dockH * 0.30, dxDiv, dockY + dockH * 0.30);
  }

  int dirPreview = -1;
  if (arrastrando_mensaje && (abs(swipeOffsetX) > 22 || abs(swipePosX) > 22)) {
    dirPreview = (swipePosX > 0 || swipeOffsetX > 0) ? 0 : 1;
  }

  boolean gaslight = (jefeActivo == 3 && gaslightingActivo);
  String[] etiquetasGas = {"GENIAL!", "TODO BIEN!", "TE AMAN!", "NÚMERO 1!"};
  String[] etiquetasStd = {"SALUD", "SEG", "REP", "POP"};
  color[] colsGas = {color(255, 0, 255), color(0, 255, 255), color(255, 255, 0), color(0, 255, 0)};
  float[] vals = {dispSaludMental, dispSeguridad, dispReputacion, dispPopularidad};

  float iconSz = 38.0;
  float startX = dockX - 1.5 * step;

  for (int i = 0; i < 4; i++) {
    float ix = startX + i * step;
    float iy = dockY - 1;
    PImage img = obtenerImgStat(i);
    String etiq = gaslight ? etiquetasGas[i] : etiquetasStd[i];
    float val = gaslight ? 100.0 : vals[i];
    color colBase = gaslight ? colsGas[i] : color(0);
    int impacto = (gaslight || dirPreview == -1) ? 0 : obtenerImpactoPrevistoStat(i, dirPreview);

    dibujarIconoStatReigns(i, img, etiq, val, ix, iy, iconSz, impacto, pulsoBarraStat[i], colBase, false);
  }

  popStyle();
}

void dibujarIconoStatReigns(int statIdx, PImage img, String etiqueta, float valor, float cx, float cy, float sz, int impacto, float pulso, color colBase, boolean compacta) {
  pushStyle();
  pushMatrix();

  float pct = constrain(valor / 100.0, 0.0, 1.0);

  color colStat;
  if (colBase != color(0)) {
    colStat = colorShaderDaltonismo(colBase);
  } else {
    if (valor <= 25.0) {
      float pulseAlarm = 0.5 + 0.5 * sin(frameCount * 0.22);
      color colCrit = colorShaderDaltonismo(color(255, 45, 45));
      color colCritHi = (modoDaltonismo == 0) ? color(255, 145, 145) : color(220, 240, 255);
      colStat = lerpColor(colCrit, colCritHi, pulseAlarm);
    } else {
      if (valor <= 50.0) {
        colStat = (modoDaltonismo == 3) ? color(255, 165, 115) : color(255, 195, 60);
      } else {
        if (statIdx == 0) colStat = colorShaderDaltonismo(color(80, 245, 160));
        else {
          if (statIdx == 1) colStat = colorShaderDaltonismo(color(70, 215, 255));
          else {
            if (statIdx == 2) {
              if (modoDaltonismo == 1 || modoDaltonismo == 2) colStat = color(225, 240, 255);
              else {
                if (modoDaltonismo == 3) colStat = color(255, 130, 210);
                else colStat = color(255, 215, 75);
              }
            }
            else colStat = colorShaderDaltonismo(color(105, 255, 130));
          }
        }
      }
    }
  }

  float vibX = (valor <= 12.0) ? random(-1.8, 1.8) : 0;
  float vibY = (valor <= 12.0) ? random(-1.8, 1.8) : 0;
  float escJuice = 1.0 + pulso * 0.16;

  translate(cx + vibX, cy + vibY);
  scale(escJuice);

  float boxSz = sz + 8;
  rectMode(CENTER);

  noStroke();
  fill(0, 220);
  rect(0, 2, boxSz + 2, boxSz + 2, 9);

  fill(9, 14, 18, 255);
  stroke((pulso > 0.15) ? color(255) : (valor <= 25.0 ? colStat : lerpColor(colStat, color(255), 0.20)));
  strokeWeight((pulso > 0.15 || valor <= 25.0) ? 2.2 : 1.5);
  rect(0, 0, boxSz, boxSz, 8);

  stroke(255, 40);
  strokeWeight(1.0);
  line(-boxSz * 0.5 + 4, -boxSz * 0.5 + 2, boxSz * 0.5 - 4, -boxSz * 0.5 + 2);

  fill(16, 24, 30, 255);
  stroke(colStat, 130);
  strokeWeight(1.3);
  rect(0, 0, sz + 2, sz + 2, 6);

  if (valor <= 25.0) {
    noFill();
    stroke(colorShaderDaltonismo(color(255, 40, 40)), 140 + 95 * sin(frameCount * 0.22));
    strokeWeight(1.8);
    rect(0, 0, boxSz + 4, boxSz + 4, 11);
  }

  imageMode(CORNER);
  float boxLeft = -sz * 0.5;
  float boxTop = -sz * 0.5;
  float boxBottom = sz * 0.5;

  PImage imgShaded = imgShaderDaltonismo(img);
  if (imgShaded != null && imgShaded.width > 0 && imgShaded.height > 0) {
    int sw = imgShaded.width;
    int sh = imgShaded.height;

    tint(0, 210);
    image(imgShaded, boxLeft + 1.2, boxTop + 1.2, sz, sz, 0, 0, sw, sh);

    color colSiluetaFondo = colorShaderDaltonismo(color(215, 240, 235));
    tint(colSiluetaFondo, 200);
    image(imgShaded, boxLeft, boxTop, sz, sz, 0, 0, sw, sh);
    noTint();

    if (pct > 0.01) {
      int srcFillH = max(1, round(sh * pct));
      float dstFillH = max(1.0, sz * pct);
      float dstFillY = boxBottom - dstFillH;
      int u1 = 0;
      int v1 = max(0, sh - srcFillH);
      int u2 = sw;
      int v2 = sh;

      fill(red(colStat), green(colStat), blue(colStat), 35);
      noStroke();
      rect(0, dstFillY + dstFillH * 0.5, sz, dstFillH, 4);

      tint(colStat);
      image(imgShaded, boxLeft, dstFillY, sz, dstFillH, u1, v1, u2, v2);
      noTint();

      if (pct > 0.04 && pct < 0.98) {
        stroke(lerpColor(colStat, color(255), 0.8), 240);
        strokeWeight(2.0);
        line(-sz * 0.38, dstFillY, sz * 0.38, dstFillY);
      }
    }

    if (valor <= 0 && (frameCount % 10 < 5)) {
      tint(colorShaderDaltonismo(color(255, 0, 0)), 230);
      image(imgShaded, boxLeft, boxTop, sz, sz, 0, 0, sw, sh);
      noTint();
    }
  } else {
    dibujarFallbackIconoStat(statIdx, colStat, pct, sz);
  }

  float gaugeW = sz * 0.88;
  float gaugeY = sz * 0.5 + 7;
  noStroke();
  fill(4, 9, 12, 230);
  rect(0, gaugeY, gaugeW, 3.2, 2);
  if (pct > 0) {
    fill(colStat);
    rect(-gaugeW * 0.5 + (gaugeW * pct) * 0.5, gaugeY, gaugeW * pct, 3.2, 2);
  }

  textAlign(CENTER, TOP);
  if (compacta) {
    textSize(9.5);
    fill(225, 245, 235);
    text(int(valor) + "%", 0, gaugeY + 3);
    fill(colStat, 200);
    textSize(8.5);
    text(etiqueta, 0, gaugeY + 15);
  } else {
    textSize(10.5);
    fill(230, 250, 240);
    text(int(valor) + "%", 0, gaugeY + 3);
  }

  if (impacto > 0) {
    float dotY = compacta ? (-sz * 0.5 - 12) : (-sz * 0.5 - 18);
    if (impacto == 1) {

      float dotR = 4.8;
      noStroke();
      fill(255, 230, 90, 85);
      ellipse(0, dotY, dotR * 2.3, dotR * 2.3);
      fill(255, 250, 185);
      ellipse(0, dotY, dotR, dotR);
    } else {

      float pulseDot = 1.0 + sin(frameCount * 0.28) * 0.26;
      float dotR = 8.2 * pulseDot;
      float wave = (frameCount * 2.2) % 24;
      float waveR = dotR * 1.5 + wave;
      float waveA = map(wave, 0, 24, 210, 0);

      noFill();
      stroke(255, 220, 80, waveA);
      strokeWeight(1.5);
      ellipse(0, dotY, waveR, waveR);

      noStroke();
      fill(255, 205, 60, 110);
      ellipse(0, dotY, dotR * 2.2, dotR * 2.2);
      fill(255, 255, 215);
      ellipse(0, dotY, dotR, dotR);
    }
  }

  float sx = screenX(0, 0);
  float sy = screenY(0, 0);
  boolean bloqueoHoverTut = (estadoPantalla == PANTALLA_JUEGO && (mostrandoTutorial || mostrandoTutorialIngame || animandoShowcaseDirectiva))
                         || (estadoPantalla == PANTALLA_TIENDA && tutorialTiendaActivo);
  if (!bloqueoHoverTut && !arrastrando_mensaje && dist(mouseX, mouseY, sx, sy) < boxSz * 0.65) {
    cursorSobreElementoClicable = true;
    statHoverIdx = statIdx;
    statHoverX = sx;
    statHoverY = sy;
  }

  if (valor <= 25.0 && imgArrowUpgrade != null) {
    pushMatrix();
    pushStyle();
    float hop = -abs(sin(frameCount * 0.22)) * 7.0;
    float arrowY = (compacta ? (sz * 0.5 + 35) : (sz * 0.5 + 25)) + hop;
    translate(0, arrowY);
    rotate(-HALF_PI);
    imageMode(CENTER);

    float arrSz = compacta ? 20.0 : 25.0;
    float snapScale = 1.0 + 0.18 * pow(abs(sin(frameCount * 0.22)), 2.0);
    scale(snapScale);

    noStroke();
    float glowA = 80 + 70 * sin(frameCount * 0.22);
    fill(colorShaderDaltonismo(color(255, 40, 40)), glowA);
    ellipse(0, 0, arrSz * 1.4, arrSz * 1.4);

    tint(255, 240);
    image(imgShaderDaltonismo(imgArrowUpgrade), 0, 0, arrSz, arrSz);
    noTint();

    popStyle();
    popMatrix();
  }

  popMatrix();
  popStyle();
}

void dibujarFallbackIconoStat(int statIdx, color colStat, float pct, float sz) {
  pushStyle();
  rectMode(CENTER);
  noStroke();

  fill(165, 205, 195, 80);
  if (statIdx == 0) {
    rect(0, 0, sz * 0.6, sz * 0.2, 2);
    rect(0, 0, sz * 0.2, sz * 0.6, 2);
  } else {
    if (statIdx == 1) {
      triangle(0, sz * 0.35, -sz * 0.3, -sz * 0.3, sz * 0.3, -sz * 0.3);
    } else {
      if (statIdx == 2) {
        quad(0, -sz * 0.35, sz * 0.3, 0, 0, sz * 0.35, -sz * 0.3, 0);
      } else {
        ellipse(0, 0, sz * 0.6, sz * 0.6);
      }
    }
  }

  if (pct > 0.05) {
    fill(colStat);
    if (statIdx == 0) {
      rect(0, 0, sz * 0.6 * pct, sz * 0.2 * pct, 2);
      rect(0, 0, sz * 0.2 * pct, sz * 0.6 * pct, 2);
    } else {
      if (statIdx == 1) {
        triangle(0, sz * 0.35 * pct, -sz * 0.3 * pct, -sz * 0.3 * pct, sz * 0.3 * pct, -sz * 0.3 * pct);
      } else {
        if (statIdx == 2) {
          quad(0, -sz * 0.35 * pct, sz * 0.3 * pct, 0, 0, sz * 0.35 * pct, -sz * 0.3 * pct, 0);
        } else {
          ellipse(0, 0, sz * 0.6 * pct, sz * 0.6 * pct);
        }
      }
    }
  }
  popStyle();
}

void dibujarTooltipStat(int idx, float x, float y) {
  pushStyle();
  rectMode(CENTER);
  textAlign(CENTER, CENTER);
  String[] nombresCompletos = {"SALUD MENTAL", "SEGURIDAD DEL SISTEMA", "REPUTACION PUBLICA", "POPULARIDAD SOCIAL"};
  float[] vals = {dispSaludMental, dispSeguridad, dispReputacion, dispPopularidad};
  if (idx < 0 || idx >= 4) { popStyle(); return; }

  String tit = nombresCompletos[idx];
  String valTxt = int(vals[idx]) + " / 100";

  textSize(11);
  float tw = max(textWidth(tit), textWidth(valTxt)) + 26;
  float th = 40;
  float ty = y - 44;
  float safeX = constrain(x, tw * 0.5 + 10, width - tw * 0.5 - 10);

  noStroke(); fill(0, 170);
  rect(safeX, ty + 2, tw, th, 7);
  fill(5, 16, 12, 240);
  stroke(colorTema(), 180);
  strokeWeight(1.5);
  rect(safeX, ty, tw, th, 7);

  fill(160, 225, 195);
  text(tit, safeX, ty - 8);
  textSize(13);
  fill(255);
  text(valTxt, safeX, ty + 8);
  popStyle();
}

final int DOLUS_FLAME_CELL = 6;
final int DOLUS_FLAME_MAX_ROWS = 26;
final int DOLUS_FLAME_STRIP_PX = DOLUS_FLAME_MAX_ROWS * DOLUS_FLAME_CELL;
final float DOLUS_FLAME_RAD_TO_IDX = 4096.0 / TWO_PI;

float[] dolusFlameSinLUT = null;
PImage imgDolusFlameTop = null;
PImage imgDolusFlameBot = null;
PImage imgDolusFlameIzq = null;
PImage imgDolusFlameDer = null;
int dolusFlameCacheW = 0;
int dolusFlameCacheH = 0;

float dolusFlameRealIntensity = 0.0;
float dolusFlameIntensityVel = 0.0;
float dolusFlameTimer = 0.0;
int dolusFlameUltimoCombo = 0;

void reiniciarMarcoFuegoDolus() {
  dolusFlameRealIntensity = 0.0;
  dolusFlameIntensityVel = 0.0;
  dolusFlameTimer = 0.0;
  dolusFlameUltimoCombo = 0;
}

void asegurarRecursosMarcoFuegoDolus() {
  if (dolusFlameSinLUT == null) {
    dolusFlameSinLUT = new float[4096];
    for (int i = 0; i < 4096; i++) {
      dolusFlameSinLUT[i] = sin((i * TWO_PI) / 4096.0);
    }
  }
  if (imgDolusFlameTop == null || dolusFlameCacheW != width || dolusFlameCacheH != height) {
    dolusFlameCacheW = width;
    dolusFlameCacheH = height;
    imgDolusFlameTop = createImage(width, DOLUS_FLAME_STRIP_PX, ARGB);
    imgDolusFlameBot = createImage(width, DOLUS_FLAME_STRIP_PX, ARGB);
    imgDolusFlameIzq = createImage(DOLUS_FLAME_STRIP_PX, height, ARGB);
    imgDolusFlameDer = createImage(DOLUS_FLAME_STRIP_PX, height, ARGB);
  }
}

float fastSinFlame(float x) {
  int qi = (int) (x * DOLUS_FLAME_RAD_TO_IDX);
  if (x < 0.0) qi--;
  return dolusFlameSinLUT[qi & 4095];
}

float fastCosFlame(float x) {
  return fastSinFlame(x + HALF_PI);
}

int evaluarCeldaFuegoDolus(
  float uAlong, float vDepth, float intensity, float scaleFac, float scaleFacY,
  float invScaleX, float invScaleY, float flameFactor, float heightPenaltyScale,
  float upY, float speed, float time,
  int colCoreARGB, int colYellowARGB, int colMidARGB, int colRimARGB
) {
  float uvY = 0.14 - vDepth * 0.55;
  float wobble = 0.026 * (fastSinFlame(-2.4 * uAlong + 1.3 * time) * fastCosFlame(6.6 * uvY + time * 2.4));
  float ux = uAlong + uAlong * wobble;
  float uy = uvY + uvY * wobble;

  float svx0 = ux * scaleFac;
  float svy0 = uy * scaleFacY + upY;
  float svx = svx0;
  float svy = svy0;
  float sv2x = 0.0;
  float sv2y = 0.0;

  for (int i = 0; i < 5; i++) {
    float lenSv = sqrt(svx * svx + svy * svy);
    float radial = 0.3 * (fastCosFlame(lenSv * 0.411) + 0.3344 * fastSinFlame(lenSv) - 0.23 * fastCosFlame(lenSv));
    float n2x = sv2x + svx + 0.05 * sv2y + radial;
    float n2y = sv2y + svy + 0.05 * sv2x + radial;
    sv2x = n2x;
    sv2y = n2y;
    svx += 0.50 * (fastCosFlame(fastCosFlame(sv2y) + speed * 0.0812) * fastSinFlame(3.22 + sv2x - speed * 0.1531));
    svy += 0.68 * (fastSinFlame(-sv2x * 1.21222 + 0.113785 * speed) * fastCosFlame(sv2y * 0.91213 - 0.13582 * speed));
  }

  float dx = (svx - svx0) * invScaleX;
  float dy = (svy - upY) * invScaleY;
  float turb = sqrt(dx * dx * 1.62 + dy * dy * 0.60) * 5.0;

  float spireWave = 0.60 * fastSinFlame(uAlong * 4.5 + 1.40 * fastSinFlame(vDepth * 5.0 - time * 6.2) + time * 1.8)
                  + 0.40 * fastCosFlame(uAlong * 8.1 - vDepth * 4.2 - time * 3.3);
  float spireCarve = spireWave * (0.30 + 0.36 * vDepth);

  float smoke = (turb * 1.08 + 0.1 * (abs(uy) - 0.5)) * flameFactor + spireCarve;
  float dyBase = uy - 0.5;
  smoke += heightPenaltyScale * (1.68 * dyBase * dyBase);

  float rootBoost = min(1.0, intensity / 2.2) * max(0.0, (0.082 - vDepth) * 15.0);
  smoke -= rootBoost;

  if (smoke > 1.0) return 0;

  float flicker = 0.04 * fastSinFlame(uAlong * 11.0 - time * 14.0);
  float heat = (1.0 - smoke) * 1.15 + max(0.0, 0.22 - vDepth) * 0.85 + flicker;
  if (heat > 0.76) return colCoreARGB;
  if (heat > 0.50) return colYellowARGB;
  if (heat > 0.24) return colMidARGB;
  return colRimARGB;
}

void renderizarFranjaHorizontalFuegoDolus(
  PImage strip, boolean esSuperior, int colsH, int activeRows, float maxRowsRef, float idEdge,
  float intensity, float scaleFac, float scaleFacY, float invScaleX, float invScaleY,
  float flameFactor, float heightPenaltyScale, float time,
  int colCoreARGB, int colYellowARGB, int colMidARGB, int colRimARGB
) {
  strip.loadPixels();
  int totalPx = strip.width * strip.height;
  for (int p = 0; p < totalPx; p++) {
    strip.pixels[p] = 0;
  }

  float upY = ((10.8 * time) % 10000.0) - 5000.0 + ((1.781 * idEdge) % 1000.0);
  float speed = ((20.781 * idEdge) % 100.0) + 1.95 * fastSinFlame(time * 2.1 + idEdge) * fastCosFlame(time * 0.38 + idEdge);
  int w = strip.width;

  for (int r = 0; r < activeRows; r++) {
    float vDepth = r / maxRowsRef;
    int py0 = esSuperior ? (r * DOLUS_FLAME_CELL) : (DOLUS_FLAME_STRIP_PX - (r + 1) * DOLUS_FLAME_CELL);
    int py1 = min(DOLUS_FLAME_STRIP_PX, py0 + DOLUS_FLAME_CELL);
    if (py0 < 0) continue;

    for (int c = 0; c < colsH; c++) {

      if (min(c, colsH - 1 - c) + 1 < r) continue;

      float uAlong = (c / 16.0) - 1.5;
      int colARGB = evaluarCeldaFuegoDolus(
        uAlong, vDepth, intensity, scaleFac, scaleFacY, invScaleX, invScaleY,
        flameFactor, heightPenaltyScale, upY, speed, time,
        colCoreARGB, colYellowARGB, colMidARGB, colRimARGB
      );
      if (colARGB == 0) continue;

      int px0 = c * DOLUS_FLAME_CELL;
      int px1 = min(w, px0 + DOLUS_FLAME_CELL);
      for (int py = py0; py < py1; py++) {
        int rowOff = py * w;
        for (int px = px0; px < px1; px++) {
          strip.pixels[rowOff + px] = colARGB;
        }
      }
    }
  }
  strip.updatePixels();
}

void renderizarFranjaVerticalFuegoDolus(
  PImage strip, boolean esIzquierda, int colsV, int activeRows, float maxRowsRef, float idEdge,
  float intensity, float scaleFac, float scaleFacY, float invScaleX, float invScaleY,
  float flameFactor, float heightPenaltyScale, float time,
  int colCoreARGB, int colYellowARGB, int colMidARGB, int colRimARGB
) {
  strip.loadPixels();
  int totalPx = strip.width * strip.height;
  for (int p = 0; p < totalPx; p++) {
    strip.pixels[p] = 0;
  }

  float upY = ((10.8 * time) % 10000.0) - 5000.0 + ((1.781 * idEdge) % 1000.0);
  float speed = ((20.781 * idEdge) % 100.0) + 1.95 * fastSinFlame(time * 2.1 + idEdge) * fastCosFlame(time * 0.38 + idEdge);
  int w = strip.width;
  int h = strip.height;

  for (int r = 0; r < activeRows; r++) {
    float vDepth = r / maxRowsRef;
    int px0 = esIzquierda ? (r * DOLUS_FLAME_CELL) : (DOLUS_FLAME_STRIP_PX - (r + 1) * DOLUS_FLAME_CELL);
    int px1 = min(DOLUS_FLAME_STRIP_PX, px0 + DOLUS_FLAME_CELL);
    if (px0 < 0) continue;

    for (int c = 0; c < colsV; c++) {

      if (min(c, colsV - 1 - c) < r) continue;

      float uAlong = (c / 16.0) - 1.0;
      int colARGB = evaluarCeldaFuegoDolus(
        uAlong, vDepth, intensity, scaleFac, scaleFacY, invScaleX, invScaleY,
        flameFactor, heightPenaltyScale, upY, speed, time,
        colCoreARGB, colYellowARGB, colMidARGB, colRimARGB
      );
      if (colARGB == 0) continue;

      int py0 = c * DOLUS_FLAME_CELL;
      int py1 = min(h, py0 + DOLUS_FLAME_CELL);
      for (int py = py0; py < py1; py++) {
        int rowOff = py * w;
        for (int px = px0; px < px1; px++) {
          strip.pixels[rowOff + px] = colARGB;
        }
      }
    }
  }
  strip.updatePixels();
}

void actualizarYDibujarMarcoFuegoDolus() {
  if (width < DOLUS_FLAME_STRIP_PX * 2 || height < DOLUS_FLAME_STRIP_PX * 2) return;

  float dt = 1.0 / 60.0;
  float targetIntensity = 0.0;
  float multComboEfectivo = comboActual * max(1.0, multiplicadorRecompensas);
  boolean fuegoComboMaestroActivo = (comboActual >= 20 || (comboActual >= 14 && multComboEfectivo >= 28.0));
  if (fuegoComboMaestroActivo && !rondaCompletada) {
    targetIntensity = constrain(7.2 + log(1.0 + max(0.0, multComboEfectivo - 20.0) * 0.45) * 1.15, 7.2, 10.2);

    float prevMultEfectivo = dolusFlameUltimoCombo * max(1.0, multiplicadorRecompensas);
    boolean estabaActivo = (dolusFlameUltimoCombo >= 20 || (dolusFlameUltimoCombo >= 14 && prevMultEfectivo >= 28.0));
    if (!estabaActivo) {
      dolusFlameIntensityVel = max(dolusFlameIntensityVel, 22.0);
    } else {
      if (comboActual > dolusFlameUltimoCombo) {
        dolusFlameIntensityVel += 9.5;
      }
    }
  }
  dolusFlameUltimoCombo = comboActual;

  float stiffness = (targetIntensity > 0.0) ? 68.0 : 42.0;
  float damping = (targetIntensity > 0.0) ? 9.2 : 11.0;
  float accel = (targetIntensity - dolusFlameRealIntensity) * stiffness;
  dolusFlameIntensityVel = (dolusFlameIntensityVel + accel * dt) * exp(-damping * dt);
  dolusFlameRealIntensity = max(0.0, dolusFlameRealIntensity + dolusFlameIntensityVel * dt);

  float intensity = min(11.0, dolusFlameRealIntensity);
  if (intensity < 0.15) return;

  dolusFlameTimer += dt * (1.70 + min(targetIntensity, intensity) * 0.22);

  asegurarRecursosMarcoFuegoDolus();

  int colCoreARGB = 0xFFFFFDD6;
  int colYellowARGB = 0xFFFFE426;
  int colMidARGB = 0xFFFF7E0C;
  int colRimARGB = 0xFFFF2012;
  if (modoDaltonismo == 1) {
    colMidARGB = 0xFFFFA818;
    colRimARGB = 0xFFFF641E;
  } else {
    if (modoDaltonismo == 2) {
      colMidARGB = 0xFFFFB814;
      colRimARGB = 0xFFFF7814;
    } else {
      if (modoDaltonismo == 3) {
        colYellowARGB = 0xFFFFEE70;
        colMidARGB = 0xFFFF68B8;
        colRimARGB = 0xFFFF28B4;
      }
    }
  }

  float scaleFac = 7.5 + 3.0 / (2.0 + 2.0 * intensity);
  float scaleFacY = scaleFac * 0.42;
  float invScaleX = 1.0 / scaleFac;
  float invScaleY = 1.0 / scaleFacY;
  float flameFactor = 2.0 / (2.0 + intensity * 0.145);
  float heightPenaltyScale = 0.68 + max(0.0, 1.35 - 0.16 * intensity);

  float rowsFull = constrain(4.0 + intensity * 2.75, 4.0, (float) DOLUS_FLAME_MAX_ROWS);
  int activeRowsBot = constrain((int) ceil(rowsFull), 3, DOLUS_FLAME_MAX_ROWS);
  int activeRowsSide = constrain((int) ceil(rowsFull * 0.80), 3, 21);
  int activeRowsTop = constrain((int) ceil(rowsFull * 0.72), 3, 19);

  int colsH = (width + DOLUS_FLAME_CELL - 1) / DOLUS_FLAME_CELL;
  int colsV = (height + DOLUS_FLAME_CELL - 1) / DOLUS_FLAME_CELL;

  renderizarFranjaHorizontalFuegoDolus(
    imgDolusFlameTop, true, colsH, activeRowsTop, 19.0, 1.37,
    intensity, scaleFac, scaleFacY, invScaleX, invScaleY, flameFactor, heightPenaltyScale,
    dolusFlameTimer, colCoreARGB, colYellowARGB, colMidARGB, colRimARGB
  );
  renderizarFranjaHorizontalFuegoDolus(
    imgDolusFlameBot, false, colsH, activeRowsBot, (float) DOLUS_FLAME_MAX_ROWS, 4.91,
    intensity, scaleFac, scaleFacY, invScaleX, invScaleY, flameFactor, heightPenaltyScale,
    dolusFlameTimer, colCoreARGB, colYellowARGB, colMidARGB, colRimARGB
  );
  renderizarFranjaVerticalFuegoDolus(
    imgDolusFlameIzq, true, colsV, activeRowsSide, 21.0, 8.23,
    intensity, scaleFac, scaleFacY, invScaleX, invScaleY, flameFactor, heightPenaltyScale,
    dolusFlameTimer, colCoreARGB, colYellowARGB, colMidARGB, colRimARGB
  );
  renderizarFranjaVerticalFuegoDolus(
    imgDolusFlameDer, false, colsV, activeRowsSide, 21.0, 12.67,
    intensity, scaleFac, scaleFacY, invScaleX, invScaleY, flameFactor, heightPenaltyScale,
    dolusFlameTimer, colCoreARGB, colYellowARGB, colMidARGB, colRimARGB
  );

  pushStyle();
  imageMode(CORNER);
  noTint();
  image(imgDolusFlameTop, 0, 0);
  image(imgDolusFlameBot, 0, height - DOLUS_FLAME_STRIP_PX);
  image(imgDolusFlameIzq, 0, 0);
  image(imgDolusFlameDer, width - DOLUS_FLAME_STRIP_PX, 0);
  popStyle();
}

void dibujarAvatarProceduralCarta(float ax, float ay, float tam, int semilla, color colBorde, float cAlpha) {
  pushStyle();
  pushMatrix();
  translate(ax, ay);
  rectMode(CENTER);

  fill(4, 10, 8, cAlpha * 0.95);
  stroke(colBorde, cAlpha * 0.85);
  strokeWeight(2);
  rect(0, 0, tam, tam, 8);

  int forma = semilla % 3;
  fill(red(colBorde) * 0.35, green(colBorde) * 0.35, blue(colBorde) * 0.35, cAlpha);
  stroke(colBorde, cAlpha);
  strokeWeight(1.5);
  if (forma == 0) {
    rect(0, 3, tam * 0.58, tam * 0.54, 6);
  } else {
    if (forma == 1) {
      ellipse(0, 3, tam * 0.60, tam * 0.58);
    } else {
      beginShape();
      vertex(-tam * 0.28, -tam * 0.22);
      vertex(tam * 0.28, -tam * 0.22);
      vertex(tam * 0.20, tam * 0.28);
      vertex(-tam * 0.20, tam * 0.28);
      endShape(CLOSE);
    }
  }

  line(0, -tam * 0.25, 0, -tam * 0.38);
  noStroke();
  fill(255, cAlpha);
  ellipse(0, -tam * 0.38, 5, 5);

  fill(255, cAlpha);
  float parpadeo = (frameCount + semilla) % 90 < 5 ? 1.5 : 6.0;
  if ((semilla / 3) % 2 == 0) {
    rect(-tam * 0.12, 0, 7, parpadeo, 2);
    rect(tam * 0.12, 0, 7, parpadeo, 2);
  } else {
    rect(0, 0, tam * 0.38, parpadeo * 0.85, 2);
  }

  stroke(colBorde, cAlpha * 0.9);
  strokeWeight(1.5);
  for (int k = -2; k <= 2; k++) {
    float hOnda = 2 + abs(sin(frameCount * 0.15 + k + semilla)) * 5;
    line(k * 5, tam * 0.16 - hOnda * 0.5, k * 5, tam * 0.16 + hOnda * 0.5);
  }

  popMatrix();
  popStyle();
}

void dibujarSpotlightRielBorde(int decision, float pX, float pY, float pW, float pH, float cardY, color colLuz, float shX, float shY) {
  boolean esDer = (decision == 0);
  float semilla = esDer ? 31.7 : 7.3;
  float ondaSuave = 0.80 + 0.20 * sin(frameCount * 0.23 + semilla);
  float ruidoLuz = 0.72 + 0.28 * noise(frameCount * 0.16 + semilla);
  float microParpadeo = ((frameCount + int(semilla * 3)) % 53 < 3) ? 0.54 : 1.0;
  float parpadeo = ondaSuave * ruidoLuz * microParpadeo;

  float prox = esDer
    ? constrain(swipePosX / SWIPE_THRESHOLD, 0, 1)
    : constrain(-swipePosX / SWIPE_THRESHOLD, 0, 1);
  if (jefeActivo == 3) prox = 0.25;

  float intensidad = rielSpotlightAlpha * parpadeo;
  float centroLuzY = constrain(cardY + swipePosY * 0.28, pY + pH * 0.26, pY + pH * 0.74) + shY;
  float bordeX = (esDer ? (pX + pW - 4) : (pX + 4)) + shX;
  float signoIn = esDer ? -1.0 : 1.0;

  pushStyle();
  noStroke();
  rectMode(CENTER);

  for (int k = 5; k >= 1; k--) {
    float anchoHaz = k * 15.0 + prox * k * 5.0;
    float altoHaz = pH * (0.34 + k * 0.065);
    float alphaCapa = (6.0 + 13.0 * prox) * intensidad * (6 - k) * 0.26;
    fill(colLuz, alphaCapa);
    rect(bordeX + signoIn * (anchoHaz * 0.42), centroLuzY, anchoHaz, altoHaz, 8);
  }

  stroke(lerpColor(colLuz, color(255), 0.35 + prox * 0.35), (52 + 88 * prox) * intensidad);
  strokeWeight(1.8 + prox * 1.4);
  line(bordeX, centroLuzY - pH * 0.24, bordeX, centroLuzY + pH * 0.24);
  popStyle();
}

void dibujarEstelaCintaPlasmaSwipe(int csIdx, color colCinta, float shX, float shY) {
  pushStyle();
  noStroke();
  for (int i = 0; i < 8; i++) {
    float x1 = csHistX[csIdx][i] + shX;
    float y1 = csHistY[csIdx][i] + shY;
    float x2 = csHistX[csIdx][i + 1] + shX;
    float y2 = csHistY[csIdx][i + 1] + shY;

    float dx = x1 - x2;
    float dy = y1 - y2;
    float len = sqrt(dx * dx + dy * dy);
    if (len < 1.0) continue;

    float px = -dy / len;
    float py = dx / len;
    float t1 = 1.0 - (i / 9.0);
    float t2 = 1.0 - ((i + 1) / 9.0);
    float w1 = csHistAncho[csIdx][i] * t1;
    float w2 = csHistAncho[csIdx][i + 1] * t2;

    fill(colCinta, 135 * t1);
    beginShape(QUADS);
    vertex(x1 + px * w1, y1 + py * w1);
    vertex(x1 - px * w1, y1 - py * w1);
    vertex(x2 - px * w2, y2 - py * w2);
    vertex(x2 + px * w2, y2 + py * w2);
    endShape();

    float wi1 = w1 * 0.38;
    float wi2 = w2 * 0.38;
    fill(255, 255, 255, 165 * t1);
    beginShape(QUADS);
    vertex(x1 + px * wi1, y1 + py * wi1);
    vertex(x1 - px * wi1, y1 - py * wi1);
    vertex(x2 - px * wi2, y2 - py * wi2);
    vertex(x2 + px * wi2, y2 + py * wi2);
    endShape();
  }
  popStyle();
}

void dibujarArcosMagneticosSwipe(float x1, float y1, float x2, float y2, color colRayo, float intensidad, int cantidad) {
  float pot = constrain(intensidad, 0, 1);
  if (pot <= 0.02) return;

  float distBase = dist(x1, y1, x2, y2);
  if (distBase < 10.0) return;

  float grosorBase = constrain(distBase * 0.44, 30.0, 96.0);
  int pasoAnim = frameCount / LIGHTNING_FRAME_HOLD;

  for (int r = 0; r < cantidad; r++) {
    int idxSprite = (pasoAnim + r * 2) % LIGHTNING_FRAMES;
    boolean flipArco = ((pasoAnim + r) % 2) == 0;
    float desvioOrigenY = (cantidad <= 1) ? 0 : ((r == 0) ? -14.0 : ((r == 1) ? 14.0 : 0.0));
    float desvioRielY = (cantidad <= 1) ? 0 : ((r == 0) ? -28.0 : ((r == 1) ? 28.0 : 0.0));
    float grosor = (r == 0) ? grosorBase : (grosorBase * 0.76);
    float alphaArco = (r == 0) ? pot : (pot * 0.82);

    dibujarSpriteRayoEntrePuntos(
      x2, y2 + desvioRielY,
      x1, y1 + desvioOrigenY,
      idxSprite, flipArco, grosor, colRayo, alphaArco
    );
  }
}

void dibujarCartaMensaje(int msg, float cX, float cY, float offX, float offY, float rot, float cScale, float cAlpha, boolean isHovered, boolean isGrabbed, float cardW, float cardH, color colG, color colAlarma) {
  dibujarCartaMensaje25D(msg, cX, cY, offX, offY, rot, cScale, cScale, cAlpha, isHovered, isGrabbed, cardW, cardH, colG, colAlarma, 0, 0);
}

void dibujarCartaMensaje25D(
  int msg, float cX, float cY,
  float offX, float offY, float rot,
  float scX, float scY, float cAlpha,
  boolean isHovered, boolean isGrabbed,
  float cardW, float cardH, color colG, color colAlarma,
  float tilt3D, float brilloExtra
) {
  if (msg < 0) return;
  float intensidadDer = constrain(offX / SWIPE_THRESHOLD, 0, 1);
  float intensidadIzq = constrain(-offX / SWIPE_THRESHOLD, 0, 1);
  float intMax = max(intensidadDer, intensidadIzq);
  color colRech = color(255, 165, 65);

  color glowColor = color(8, 16, 12);
  float glowIntensity = 0;
  if (jefeActivo != 3) {
    if (intensidadDer >= intensidadIzq && intensidadDer > 0.01) {
      glowColor = colG;
      glowIntensity = intensidadDer;
    } else {
      if (intensidadIzq > 0.01) {
        glowColor = colRech;
        glowIntensity = intensidadIzq;
      }
    }
  }

  color cardBgCol = msgEsCorporativo[msg] ? color(8, 17, 23, cAlpha) : color(8, 18, 13, cAlpha);
  color cardBorderCol = colG;
  color cardTextCol = color(255, cAlpha);
  color cardRemitCol = color(colG, cAlpha);
  String badgeEspecial = msgEsCorporativo[msg] ? "PAQUETE SISTEMA" : "PAQUETE WEB";

  if (msgCategoriaEspecial[msg] == 1) {
    cardBgCol = color(32, 24, 6, cAlpha);
    cardBorderCol = color(255, 215, 40, cAlpha);
    cardTextCol = color(255, 245, 190, cAlpha);
    cardRemitCol = color(255, 215, 40, cAlpha);
    badgeEspecial = "SOBORNO DORADO";
  } else {
    if (msgCategoriaEspecial[msg] == 2) {
      cardBgCol = color(6, 22, 28, cAlpha);
      cardBorderCol = color(0, 240, 255, cAlpha);
      cardTextCol = color(180, 255, 255, cAlpha);
      cardRemitCol = color(0, 240, 255, cAlpha);
      badgeEspecial = (msgNivelEncriptado[msg] > 0.05) ? "CIFRADO [CLIC REPETIDO]" : "DESCIFRADO OK";
    } else {
      if (msgCategoriaEspecial[msg] == 3) {
        float pBomba = 0.5 + 0.5 * sin(frameCount * 0.35);
        cardBgCol = color(34, 10, 8, cAlpha);
        cardBorderCol = lerpColor(color(255, 60, 40), color(255, 200, 40), pBomba);
        cardTextCol = color(255, 230, 220, cAlpha);
        cardRemitCol = color(255, 120, 60, cAlpha);
        badgeEspecial = "BOMBA DE TIEMPO!";
      } else {
        if (msgCategoriaEspecial[msg] == 4) {
          float pGlit = 0.5 + 0.5 * sin(frameCount * 0.45);
          cardBgCol = color(22, 6, 26, cAlpha);
          cardBorderCol = lerpColor(color(255, 30, 160), color(40, 255, 120), pGlit);
          cardTextCol = color(255, 230, 255, cAlpha);
          cardRemitCol = color(255, 60, 200, cAlpha);
          badgeEspecial = "CONTAMINADA: SACUDIR!";
        }
      }
    }
  }

  if (voucherCertAuthActivo && msgTipoMaldad[msg] != 0 && msgCategoriaEspecial[msg] == 0) {
    float pAuth = 0.5 + 0.5 * sin(frameCount * 0.25);
    cardBorderCol = lerpColor(cardBorderCol, color(255, 65, 65, cAlpha), 0.70 * pAuth);
  }

  if (jefeActivo == 2) {
    if (msgTipoMaldad[msg] == 0) {
      cardBgCol = color(40, cAlpha);
      cardBorderCol = color(100, cAlpha);
      cardTextCol = color(150, cAlpha);
      cardRemitCol = color(100, cAlpha);
    } else {
      if (msgTipoMaldad[msg] == 4) {
        cardBgCol = color(20, 0, 40, cAlpha);
        cardBorderCol = color(255, 0, 255, cAlpha);
        cardTextCol = color(0, 255, 255, cAlpha);
        cardRemitCol = color(255, 255, 0, cAlpha);
      }
    }
  }

  if (jefeActivo == 3) {
    if (msgTipoMaldad[msg] == 5 && !msgVerificado[msg]) {
      float shimmerBoss = 150 + sin(frameCount * 0.2) * 100;
      cardBgCol = color(40, 40, 0, cAlpha);
      cardBorderCol = color(255, 215, 0, shimmerBoss);
      cardTextCol = color(255, 255, 100, cAlpha);
      cardRemitCol = color(255, 215, 0, cAlpha);
    } else {
      if (msgVerificado[msg] && msgTipoMaldad[msg] == 5) {
        cardBgCol = color(50, 0, 0, cAlpha);
        cardBorderCol = color(255, 0, 0, cAlpha);
        cardTextCol = color(255, 50, 50, cAlpha);
        cardRemitCol = color(255, 0, 0, cAlpha);
      }
    }
  }

  color cardBg = lerpColor(cardBgCol, glowColor, glowIntensity * 0.16);
  color borderCol = lerpColor(cardBorderCol, glowColor, glowIntensity * 0.72);
  if (isHovered && glowIntensity < 0.05) {
    borderCol = lerpColor(cardBorderCol, color(255), 0.42);
  }
  float flashTotal = constrain((isGrabbed ? swipeFlashUmbral : 0) + brilloExtra, 0, 1);
  if (flashTotal > 0.01) {
    borderCol = lerpColor(borderCol, color(255), flashTotal * 0.80);
    cardBg = lerpColor(cardBg, borderCol, flashTotal * 0.32);
  }

  float acortamiento3D = cos(tilt3D * 0.85);
  float parallaxInternoX = tilt3D * 14.0;

  pushStyle();
  pushMatrix();
  float ampGlitchX = mostrandoTutorialIngame ? 0.6 : 2.5;
  float ampGlitchY = mostrandoTutorialIngame ? 0.4 : 1.5;
  float glitchJitterX = (msgCategoriaEspecial[msg] == 4) ? random(-ampGlitchX, ampGlitchX) : 0;
  float glitchJitterY = (msgCategoriaEspecial[msg] == 4) ? random(-ampGlitchY, ampGlitchY) : 0;
  if (msg == mensajeActivo) {
    ultimaCartaRenderValida = true;
    ultimaCartaRenderX = cX + offX + glitchJitterX;
    ultimaCartaRenderY = cY + offY + glitchJitterY;
    ultimaCartaRenderRot = rot;
    ultimaCartaRenderScX = scX * acortamiento3D;
    ultimaCartaRenderScY = scY;
    ultimaCartaRenderParallaxX = parallaxInternoX * 0.45;
  }
  translate(cX + offX + glitchJitterX, cY + offY + glitchJitterY);
  rotate(rot);
  scale(scX * acortamiento3D, scY);

  float elevacion = (isGrabbed ? 22 : (isHovered ? 15 : 10)) + abs(offX) * 0.035;
  rectMode(CENTER);
  noStroke();
  fill(0, 175 * (cAlpha / 255.0));
  rect(elevacion * 0.65 - tilt3D * 18, elevacion, cardW + 6, cardH + 6, 18);

  if (glowIntensity > 0.72 || brilloExtra > 0.15) {
    float pHalo = max(map(glowIntensity, 0.72, 1.0, 0, 1), brilloExtra);
    noFill();
    stroke(borderCol, 125 * pHalo * (cAlpha / 255.0));
    strokeWeight(8);
    rect(0, 0, cardW + 10, cardH + 10, 20);
  }

  fill(cardBg);
  stroke(borderCol, cAlpha);
  strokeWeight((isHovered || isGrabbed || brilloExtra > 0.1) ? 4.2 : 3.0);
  rect(0, 0, cardW, cardH, 16);

  noFill();
  stroke(borderCol, 55 * (cAlpha / 255.0));
  strokeWeight(1.2);
  rect(0, 0, cardW - 14, cardH - 14, 12);

  noStroke();
  fill(red(borderCol) * 0.22, green(borderCol) * 0.22, blue(borderCol) * 0.22, cAlpha * 0.92);
  rect(0, -cardH * 0.5 + 18, cardW - 6, 32, 14, 14, 0, 0);
  stroke(borderCol, cAlpha * 0.45);
  strokeWeight(1.5);
  line(-cardW * 0.5 + 4, -cardH * 0.5 + 34, cardW * 0.5 - 4, -cardH * 0.5 + 34);

  noStroke();
  fill(255, 90, 90, cAlpha);  ellipse(-cardW * 0.5 + 20, -cardH * 0.5 + 18, 8, 8);
  fill(255, 210, 80, cAlpha); ellipse(-cardW * 0.5 + 34, -cardH * 0.5 + 18, 8, 8);
  fill(80, 240, 140, cAlpha); ellipse(-cardW * 0.5 + 48, -cardH * 0.5 + 18, 8, 8);

  textAlign(LEFT, CENTER);
  textSize(11);
  fill(225, 245, 235, cAlpha * 0.88);
  String txtAsunto = (msgAsunto[msg] != null && msgAsunto[msg].length() > 0) ? msgAsunto[msg] : (msgEsCorporativo[msg] ? "SYS // TICKET" : "FEED // POST");
  text(txtAsunto, -cardW * 0.5 + 64, -cardH * 0.5 + 18);

  textAlign(RIGHT, CENTER);
  textSize(11);
  fill(borderCol, cAlpha);
  text("[" + badgeEspecial + " #" + msgSemillaAvatar[msg] + "]", cardW * 0.5 - 16, -cardH * 0.5 + 17);

  float desplazamientoFoil = (tilt3D * 260 + offX * 0.65 + frameCount * 1.9) % (cardW * 1.4) - cardW * 0.7;
  float anchoHaz = 48;
  float xF1 = constrain(desplazamientoFoil - anchoHaz, -cardW * 0.47, cardW * 0.47);
  float xF2 = constrain(desplazamientoFoil + anchoHaz, -cardW * 0.47, cardW * 0.47);
  if (xF2 > xF1 + 4) {
    noStroke();
    color colFoil = (msgCategoriaEspecial[msg] == 1) ? color(255, 230, 110) : ((msgCategoriaEspecial[msg] == 2) ? color(80, 255, 255) : ((msgCategoriaEspecial[msg] == 4) ? color(255, 40, 200) : borderCol));
    fill(red(colFoil), green(colFoil), blue(colFoil), 28 * (cAlpha / 255.0));
    rectMode(CORNERS);
    rect(xF1, -cardH * 0.48, xF2, cardH * 0.48, 10);
    float xF3 = constrain(desplazamientoFoil + anchoHaz + 14, -cardW * 0.47, cardW * 0.47);
    float xF4 = constrain(desplazamientoFoil + anchoHaz + 28, -cardW * 0.47, cardW * 0.47);
    if (xF4 > xF3 + 2) {
      fill(255, 255, 255, 18 * (cAlpha / 255.0));
      rect(xF3, -cardH * 0.48, xF4, cardH * 0.48, 6);
    }
    rectMode(CENTER);
  }

  pushMatrix();
  translate(parallaxInternoX * 0.45, 0);

  dibujarAvatarProceduralCarta(-cardW * 0.5 + 52, -cardH * 0.5 + 72, 54, msgSemillaAvatar[msg], borderCol, cAlpha);

  String remMostrado = (msgCategoriaEspecial[msg] == 2 && msgNivelEncriptado[msg] > 0.35) ? "NODO_CIFRADO" : msgRemitente[msg];
  textAlign(LEFT, CENTER);
  fill(cardRemitCol);
  textSize(17);
  text("@" + remMostrado, -cardW * 0.5 + 90, -cardH * 0.5 + 60);

  String domTxt = msgDominio[msg] != null ? msgDominio[msg] : (msgEsCorporativo[msg] ? "dolus@corp" : "dolus@net");
  String etiquetaDominio = (msgEsCorporativo[msg] ? "DOMINIO: " : "RED: ") + domTxt;

  color colDomBg = color(10, 18, 24, cAlpha * 0.95);
  color colDomBorde = color(red(borderCol) * 0.5 + 40, green(borderCol) * 0.5 + 80, blue(borderCol) * 0.5 + 100, cAlpha * 0.75);
  color colDomTexto = color(215, 235, 245, cAlpha);

  textSize(12);
  rectMode(CORNER);
  fill(colDomBg);
  stroke(colDomBorde);
  strokeWeight(1.3);
  float wDom = textWidth(etiquetaDominio) + 20;
  rect(-cardW * 0.5 + 90, -cardH * 0.5 + 72, wDom, 22, 6);
  fill(colDomTexto);
  textAlign(LEFT, CENTER);
  text(etiquetaDominio, -cardW * 0.5 + 100, -cardH * 0.5 + 82);
  rectMode(CENTER);

  if (pluginEquipado(19) && msgTipoMaldad[msg] == 1) {
    fill(255, 80, 80, cAlpha);
    textSize(12);
    textAlign(RIGHT, TOP);
    text("[TROLL DETECTADO]", cardW * 0.5 - 18, -cardH * 0.5 + 44);
  }

  String textoMostrar = obtenerTextoMostradoCarta(msg);
  asegurarCacheTextoCarta(msg, textoMostrar, cardW - 64, 76, 18);
  dibujarTextoCartaCacheado(msg, 0, 4, cardTextCol);

  if (msgCategoriaEspecial[msg] == 2 && msgNivelEncriptado[msg] > 0.0) {
    float pDesc = 1.0 - msgNivelEncriptado[msg];
    float pulseClick = 0.5 + 0.5 * sin(frameCount * 0.35);
    fill(0, 240, 255, lerp(180, 255, pulseClick));
    if (fuenteRetro != null) textFont(fuenteRetro);
    textSize(12);
    textAlign(CENTER, CENTER);
    text(">> CLIC RÁPIDO PARA DESCIFRAR! [" + int(pDesc * 100) + "%] <<", 0, 36);
  } else {
    if (msgCategoriaEspecial[msg] == 4) {
      float pulseShake = 0.5 + 0.5 * sin(frameCount * 0.40);
      fill(lerpColor(color(255, 40, 180), color(40, 255, 140), pulseShake));
      if (fuenteRetro != null) textFont(fuenteRetro);
      textSize(12);
      textAlign(CENTER, CENTER);
      text(">> SACUDE BRUSCAMENTE PARA PURGAR! [" + int(msgEnergiaSacudida[msg] * 100) + "%] <<", 0, 36);
    }
  }

  float yBadges = 62;
  float wBadge = 212;
  float hBadge = 42;

  float xBadgeArch = -114;
  rectMode(CENTER);
  if (msgTieneAdjunto[msg]) {
    color colPillArchBg = color(10, 18, 26, cAlpha * 0.96);
    color colPillArchBorde = color(60, 130, 160, cAlpha * 0.75);
    color colPillArchTxt = color(220, 240, 250, cAlpha);

    fill(colPillArchBg);
    stroke(colPillArchBorde);
    strokeWeight(1.4);
    rect(xBadgeArch, yBadges, wBadge, hBadge, 9);

    float xChipArch = xBadgeArch - wBadge * 0.5 + 26;
    color colChipBg = colorShaderDaltonismo(color(22, 44, 60));
    color colChipBorde = colorShaderDaltonismo(color(120, 185, 220));

    noStroke();
    fill(0, 180 * (cAlpha / 255.0));
    rect(xChipArch + 1, yBadges + 1.5, 32, 32, 7);

    fill(colChipBg);
    stroke(colChipBorde);
    strokeWeight(1.8);
    rect(xChipArch, yBadges, 32, 32, 6);

    if (msgIndiceArchivo[msg] >= 0 && msgIndiceArchivo[msg] < 6 && imgArchivosCrisp[msgIndiceArchivo[msg]] != null) {
      PImage imgArchSh = imgShaderDaltonismo(imgArchivosCrisp[msgIndiceArchivo[msg]]);
      pushStyle();
      imageMode(CENTER);
      tint(0, 130 * (cAlpha / 255.0));
      image(imgArchSh, xChipArch + 1.2, yBadges + 1.2, 28, 28);
      tint(255, 255, 255, cAlpha);
      image(imgArchSh, xChipArch, yBadges, 28, 28);
      noTint();
      popStyle();
    }

    textAlign(LEFT, CENTER);
    String extTxt = (msgExtensionArchivo[msg] != null ? strToUpper(msgExtensionArchivo[msg]) : ".DAT");
    textSize(extTxt.length() > 5 ? 11 : 13);
    fill(colPillArchTxt);
    text("ADJUNTO: " + extTxt, xChipArch + 24, yBadges);
  } else {
    fill(12, 18, 22, cAlpha * 0.85);
    stroke(borderCol, cAlpha * 0.35);
    strokeWeight(1.2);
    rect(xBadgeArch, yBadges, wBadge, hBadge, 9);
    textAlign(CENTER, CENTER);
    textSize(12);
    fill(150, 180, 195, cAlpha * 0.85);
    text("[ SIN ARCHIVO ADJUNTO ]", xBadgeArch, yBadges);
  }

  float xBadgeSello = +114;
  if (msgIndiceSello[msg] < 0) {
    fill(12, 18, 22, cAlpha * 0.85);
    stroke(borderCol, cAlpha * 0.35);
    strokeWeight(1.2);
    rect(xBadgeSello, yBadges, wBadge, hBadge, 9);
    textAlign(CENTER, CENTER);
    textSize(12);
    fill(150, 180, 195, cAlpha * 0.85);
    text("[ SIN SELLO ]", xBadgeSello, yBadges);
  } else {
    int sIdx = constrain(msgIndiceSello[msg], 0, 5);
    color colSelloBadge = color(0, 245, 160);
    color colChipSelloBg = color(0, 175, 110);
    color colChipSelloBorde = color(130, 255, 210);
    String txtSelloBadge = "DOLUS AUTH";

    if (sIdx == 1) {
      colSelloBadge = color(255, 65, 65);
      colChipSelloBg = color(225, 35, 45);
      colChipSelloBorde = color(255, 190, 190);
      txtSelloBadge = "MALWARE DETECT";
    } else {
      if (sIdx == 2) {
        colSelloBadge = color(255, 185, 45);
        colChipSelloBg = color(225, 140, 20);
        colChipSelloBorde = color(255, 235, 130);
        txtSelloBadge = "NO VERIFICADO";
      } else {
        if (sIdx == 3) {
          colSelloBadge = color(255, 215, 60);
          colChipSelloBg = color(215, 165, 15);
          colChipSelloBorde = color(255, 245, 150);
          txtSelloBadge = "PATROCINIO VIP";
        } else {
          if (sIdx == 4) {
            colSelloBadge = color(255, 60, 210);
            colChipSelloBg = color(205, 25, 155);
            colChipSelloBorde = color(255, 170, 240);
            txtSelloBadge = "GLITCH / PURGA";
          } else {
            if (sIdx == 5) {
              colSelloBadge = color(60, 205, 255);
              colChipSelloBg = color(20, 140, 225);
              colChipSelloBorde = color(165, 230, 255);
              txtSelloBadge = "TAG COMUNIDAD";
            }
          }
        }
      }
    }

    if (modoDaltonismo == 1 || modoDaltonismo == 2) {
      if (sIdx == 0) {
        colSelloBadge = color(240, 206, 72);
        colChipSelloBg = color(175, 138, 22);
        colChipSelloBorde = color(255, 240, 145);
      } else {
        if (sIdx == 1) {
          colSelloBadge = color(60, 165, 255);
          colChipSelloBg = color(28, 105, 225);
          colChipSelloBorde = color(175, 225, 255);
        } else {
          if (sIdx == 2) {
            colSelloBadge = color(185, 212, 232);
            colChipSelloBg = color(95, 125, 150);
            colChipSelloBorde = color(230, 245, 255);
          } else {
            if (sIdx == 3) {
              colSelloBadge = color(255, 235, 115);
              colChipSelloBg = color(215, 175, 35);
              colChipSelloBorde = color(255, 250, 195);
            } else {
              if (sIdx == 4) {
                colSelloBadge = color(165, 190, 255);
                colChipSelloBg = color(95, 115, 225);
                colChipSelloBorde = color(220, 230, 255);
              } else {
                if (sIdx == 5) {
                  colSelloBadge = color(95, 225, 255);
                  colChipSelloBg = color(30, 155, 215);
                  colChipSelloBorde = color(190, 245, 255);
                }
              }
            }
          }
        }
      }
    } else {
      if (modoDaltonismo == 3) {
        if (sIdx == 0) {
          colSelloBadge = color(50, 235, 190);
          colChipSelloBg = color(15, 165, 130);
          colChipSelloBorde = color(155, 255, 225);
        } else {
          if (sIdx == 1) {
            colSelloBadge = color(255, 68, 145);
            colChipSelloBg = color(210, 25, 95);
            colChipSelloBorde = color(255, 175, 210);
          } else {
            if (sIdx == 2) {
              colSelloBadge = color(255, 150, 185);
              colChipSelloBg = color(195, 85, 120);
              colChipSelloBorde = color(255, 210, 225);
            } else {
              if (sIdx == 3) {
                colSelloBadge = color(245, 120, 225);
                colChipSelloBg = color(185, 55, 175);
                colChipSelloBorde = color(255, 195, 245);
              } else {
                if (sIdx == 4) {
                  colSelloBadge = color(205, 130, 255);
                  colChipSelloBg = color(140, 65, 215);
                  colChipSelloBorde = color(235, 195, 255);
                } else {
                  if (sIdx == 5) {
                    colSelloBadge = color(110, 245, 235);
                    colChipSelloBg = color(35, 175, 170);
                    colChipSelloBorde = color(200, 255, 250);
                  }
                }
              }
            }
          }
        }
      }
    }

    fill(red(colSelloBadge) * 0.16, green(colSelloBadge) * 0.16, blue(colSelloBadge) * 0.16, cAlpha * 0.96);
    stroke(colSelloBadge, cAlpha * 0.88);
    strokeWeight(1.4);
    rect(xBadgeSello, yBadges, wBadge, hBadge, 9);

    float xChipSello = xBadgeSello - wBadge * 0.5 + 26;
    noStroke();
    fill(0, 180 * (cAlpha / 255.0));
    rect(xChipSello + 1, yBadges + 1.5, 32, 32, 7);

    fill(colChipSelloBg);
    stroke(colChipSelloBorde);
    strokeWeight(1.8);
    rect(xChipSello, yBadges, 32, 32, 6);

    if (sIdx >= 0 && sIdx < 6 && imgSellosCrisp[sIdx] != null) {
      PImage imgSelloSh = imgShaderDaltonismo(imgSellosCrisp[sIdx]);
      pushStyle();
      imageMode(CENTER);
      tint(0, 130 * (cAlpha / 255.0));
      image(imgSelloSh, xChipSello + 1.2, yBadges + 1.2, 28, 28);
      tint(255, 255, 255, cAlpha);
      image(imgSelloSh, xChipSello, yBadges, 28, 28);
      noTint();
      popStyle();
    }

    textAlign(LEFT, CENTER);
    textSize(13);
    fill(colSelloBadge, cAlpha);
    text(txtSelloBadge, xChipSello + 24, yBadges);
  }

  float barW = cardW - 76;
  noFill();
  stroke(borderCol, 75 * (cAlpha / 255.0));
  strokeWeight(2);
  rectMode(CENTER);
  rect(0, 112, barW, 9, 4);
  int metaBalTiempo = max(1, obtenerMetaBalanzaActual());
  float ventajaTiempo = (jefeActivo == 0) ? constrain((float)balanzaEstabilidad / metaBalTiempo, 0.0, 1.0) : 0.0;
  color colBarNormal = (ventajaTiempo >= 0.45)
    ? lerpColor(borderCol, color(255, 185, 50), constrain((ventajaTiempo - 0.45) / 0.45, 0.0, 1.0))
    : borderCol;
  fill(msgTiempoRestante[msg] < 0.3 || msgCategoriaEspecial[msg] == 3 ? colAlarma : colBarNormal, cAlpha);
  noStroke();
  rectMode(CORNER);
  float fillW = barW * constrain(msgTiempoRestante[msg], 0, 1);
  rect(-barW * 0.5, 107.5, fillW, 9, 4);

  if (msgCategoriaEspecial[msg] == 3 && fillW > 4) {
    fill(255, 255, 160, cAlpha);
    rectMode(CENTER);
    rect(-barW * 0.5 + fillW, 112, 11 + random(-2, 2), 11 + random(-2, 2), 2);
  }
  rectMode(CENTER);

  popMatrix();

  String textDer = "ACEPTAR >>";
  String textIzq = "<< RECHAZAR";
  if (jefeActivo == 3) {
    if (faseCombateJefe == 2) {
      if ((frameCount / 180) % 2 == 0) {
        textDer = "SOY UN MIEDOSO";
        textIzq = "CLARO QUE SI";
      } else {
        textDer = "CLARO QUE SI";
        textIzq = "SOY UN MIEDOSO";
      }
    } else {
      if (faseJefe3 == 3) {
        textDer = "SOY UN MIEDOSO";
        textIzq = "CLARO QUE SI";
      }
    }
  }

  if (intMax > 0.18) {
    float progSello = constrain((intMax - 0.18) / 0.82, 0, 1);
    boolean armado = (intMax >= 1.0);
    float escSello = lerp(0.75, armado ? 1.12 : 1.0, progSello);
    boolean esAceptar = (intensidadDer >= intensidadIzq);
    color colSello = (jefeActivo == 3) ? color(255, 225, 95) : (esAceptar ? colG : colRech);
    String txtSello = esAceptar ? textDer : textIzq;
    if (msgCategoriaEspecial[msg] == 4) {
      colSello = color(255, 40, 180);
      txtSello = "SACUDE, NO DESLICES!";
    }

    pushMatrix();
    float selloX = esAceptar ? (-cardW * 0.25 + parallaxInternoX * 0.8) : (cardW * 0.25 + parallaxInternoX * 0.8);
    translate(selloX, -10);
    rotate(esAceptar ? -0.22 : 0.22);
    scale(escSello);

    rectMode(CENTER);
    fill(6, 14, 10, 228 * progSello * (cAlpha / 255.0));
    stroke(colSello, 255 * progSello * (cAlpha / 255.0));
    strokeWeight(armado ? 3.8 : 2.5);
    rect(0, 0, 218, 52, 10);

    noFill();
    stroke(colSello, 120 * progSello * (cAlpha / 255.0));
    strokeWeight(1.2);
    rect(0, 0, 206, 40, 6);

    textAlign(CENTER, CENTER);
    textSize(20);
    fill(colSello, 255 * progSello * (cAlpha / 255.0));
    text(txtSello, 0, -2);
    popMatrix();
  }

  popMatrix();
  popStyle();
}

void dibujarTextoCartaCacheado(int msg, float cx, float cy, color colTexto) {
  if (msg < 0 || msgNumLineasCacheadas[msg] <= 0) return;
  textSize(msgTamTextoCache[msg]);
  textAlign(CENTER, CENTER);
  fill(colTexto);
  float interlineado = msgTamTextoCache[msg] * 1.28;
  float altoBloque = msgNumLineasCacheadas[msg] * interlineado;
  float startY = cy - (altoBloque * 0.5) + (interlineado * 0.5);
  for (int i = 0; i < msgNumLineasCacheadas[msg]; i++) {
    text(msgLineasCacheadas[msg][i], cx, startY + i * interlineado);
  }
}

void dibujarCartaSaliendoWarp(
  int msg, int decision,
  float posX, float posY, float rot,
  float scX, float scY, float cAlpha,
  float cardW, float cardH, color colBordeBase, float brilloExtra
) {
  if (msg < 0) return;
  color colBorde = lerpColor(colBordeBase, color(255), constrain(brilloExtra * 0.78, 0, 1));
  color colFondo = lerpColor(color(8, 18, 13, cAlpha), colBorde, constrain(0.18 + brilloExtra * 0.28, 0, 0.55));

  pushStyle();
  pushMatrix();
  translate(posX, posY);
  rotate(rot);
  scale(scX, scY);
  rectMode(CENTER);

  noStroke();
  fill(0, 145 * (cAlpha / 255.0));
  rect(10, 14, cardW + 4, cardH + 4, 16);

  fill(colFondo);
  stroke(colBorde, cAlpha);
  strokeWeight(4.0);
  rect(0, 0, cardW, cardH, 16);

  noStroke();
  fill(red(colBorde) * 0.25, green(colBorde) * 0.25, blue(colBorde) * 0.25, cAlpha * 0.90);
  rect(0, -cardH * 0.5 + 18, cardW - 6, 32, 14, 14, 0, 0);

  String remMostrado = (msgCategoriaEspecial[msg] == 2 && msgNivelEncriptado[msg] > 0.35) ? "NODO_CIFRADO" : msgRemitente[msg];
  textAlign(LEFT, CENTER);
  textSize(17);
  fill(colBorde, cAlpha);
  text("@" + remMostrado, -cardW * 0.5 + 24, -cardH * 0.5 + 56);

  String txtMostrado = obtenerTextoMostradoCarta(msg);
  asegurarCacheTextoCarta(msg, txtMostrado, cardW - 64, 96, 19);
  dibujarTextoCartaCacheado(msg, 0, 14, color(245, 255, 250, cAlpha * 0.92));

  if (decision == 0 || decision == 1) {
    boolean esAceptar = (decision == 0);
    String txtSello = (jefeActivo == 3) ? "ENVIADO" : (esAceptar ? "ACEPTAR >>" : "<< RECHAZAR");
    pushMatrix();
    translate(esAceptar ? -cardW * 0.22 : cardW * 0.22, -8);
    rotate(esAceptar ? -0.20 : 0.20);
    fill(6, 14, 10, 232 * (cAlpha / 255.0));
    stroke(colBorde, cAlpha);
    strokeWeight(3.2);
    rect(0, 0, 214, 50, 10);
    textAlign(CENTER, CENTER);
    textSize(19);
    fill(colBorde, cAlpha);
    text(txtSello, 0, -2);
    popMatrix();
  }

  popMatrix();
  popStyle();
}

void dibujarBalanzaEstabilidadVisual() {
  pushStyle();
  float bx = width * 0.64;
  float by = height * 0.36;
  float bw = 380;
  float bh = 16;
  int metaBal = max(1, obtenerMetaBalanzaActual());

  dispBalanzaEstabilidad = lerp(dispBalanzaEstabilidad, balanzaEstabilidad, 0.1);

  pushMatrix();
  translate(bx, by);
  scale(1.0 + pulsoBalanzaUI * 0.15, 1.0 + pulsoBalanzaUI * 0.30);
  rotate(sin(pulsoBalanzaUI * PI) * 0.035);
  translate(-bx, -by);

  textAlign(CENTER, BOTTOM);
  textSize(11);
  if (esUltimoEmpujonActivo()) {
    fill(255, 215, 80);
    text("ULTIMO EMPUJON (+" + balanzaEstabilidad + " / +" + metaBal + ") // ALERTA!", bx, by - bh * 0.5 - 5);
  } else {
    if (balanzaEstabilidad >= metaBal - 2) {
      fill(255, 215, 80);
      text("POR GANAR (+" + balanzaEstabilidad + " / +" + metaBal + ")", bx, by - bh * 0.5 - 5);
    } else {
      if (balanzaEstabilidad <= -(metaBal - 2)) {
        fill(255, 85, 85);
        text("RIESGO DE GAME OVER! (" + balanzaEstabilidad + " / -" + metaBal + ")", bx, by - bh * 0.5 - 5);
      } else {
        fill(180, 210, 195);
        String signoBal = (balanzaEstabilidad > 0) ? "+" : "";
        text("BALANZA DE CONTROL: " + signoBal + balanzaEstabilidad + " / +" + metaBal, bx, by - bh * 0.5 - 5);
      }
    }
  }

  rectMode(CENTER);
  fill(6, 14, 10, 200);
  stroke(pulsoBalanzaUI > 0.15 ? color(255) : color(100));
  strokeWeight(2 + pulsoBalanzaUI * 1.5);
  rect(bx, by, bw, bh, 8);

  fill(150); noStroke();
  ellipse(bx, by, 6, 6);

  float pOffset = constrain(dispBalanzaEstabilidad / float(metaBal), -1.0, 1.0) * (bw / 2);

  if (dispBalanzaEstabilidad < 0) {
    fill(255, 50, 50, 210);
    rectMode(CORNERS);
    rect(bx + pOffset, by - bh/2 + 2, bx, by + bh/2 - 2);
  } else {
    if (dispBalanzaEstabilidad > 0) {
      fill(50, 220, 110, 210);
      rectMode(CORNERS);
      rect(bx, by - bh/2 + 2, bx + pOffset, by + bh/2 - 2);
    }
  }

  textAlign(RIGHT, CENTER);
  fill(255, 110, 110);
  textSize(12);
  text("ALGORITMO", bx - bw/2 - 12, by - 1);

  textAlign(LEFT, CENTER);
  fill(120, 245, 165);
  textSize(12);
  text("CONTROL JUGADOR", bx + bw/2 + 12, by - 1);

  int pasoTick = (metaBal > 10) ? 2 : 1;
  for (int i = -metaBal; i <= metaBal; i += pasoTick) {
    float mx = bx + (i / float(metaBal)) * (bw / 2);
    stroke(255, 90);
    strokeWeight(1);
    line(mx, by - bh/2, mx, by + bh/2);
  }

  for (int i = 0; i < max(1, vidasJugador + 1); i++) {
    float vx = bx - bw/2 - 20 - i * 16;
    if (i < vidasJugador) fill(255, 60, 60);
    else fill(50);
    noStroke();
    rectMode(CENTER);
    rect(vx, by + 16, 10, 10, 2);
  }
  popMatrix();
  popStyle();
}
