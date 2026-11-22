int dificultadSeleccionada = 0;
boolean juegoPausado = false;

boolean fasePluginsActiva = false;
int conversanteActual = 0;

float anguloFlotanteJimbo = 0.0;
float escalaJimboActual = 1.0;
float alphaAparicionJimbo = 0.0;

boolean animandoAparicionChat = false;
float progresoAparicionChat = 0.0;

int numColumnasChatFondo = 0;
float anchoCeldaChatFondo = 24.0;
float[] chatFondoOffsetY;
float[] chatFondoVelocidad;

String nombreJugador = "User_Name";

int maxPopups = 6;
boolean[] popupActivo;
float[] popupX;
float[] popupY;
float[] popupVidaActual;
float[] popupDuracionTotal;
String[] popupMensajeActual;
float[] popupSemillaTemblor;
float tiempoSiguienteAparicionPopup = 0.0;

String[] mensajesPopup = {
  "Sistema Inestable",
  "Conexion Ilicita",
  "Por Favor Reiniciar",
  "Red No Habilitada",
  "Reinicio Inminente",
  "Sistema Fuera De Servicio"
};

float popupAnchoBase = 300;
float popupAltoBase = 64;

void inicializarJuego(int dificultad) {
  reiniciarPartidaCompleta();
  dificultadSeleccionada = dificultad;
  juegoPausado = false;
  fasePluginsActiva = false;
  conversanteActual = 0;

  resetearTutorial();

  anguloFlotanteJimbo = 0.0;
  escalaJimboActual = 1.0;
  alphaAparicionJimbo = 0.0;

  animandoAparicionChat = true;
  progresoAparicionChat = 0.0;

  int columnasNecesarias = int(620 / anchoCeldaChatFondo) + 1;
  numColumnasChatFondo = min(columnasNecesarias, 64);
  chatFondoOffsetY = new float[64];
  chatFondoVelocidad = new float[64];

  for (int i = 0; i < numColumnasChatFondo; i++) {
    chatFondoOffsetY[i] = random(0, 200);
    chatFondoVelocidad[i] = random(0.3, 0.9);
  }

  inicializarPopups();
  construirArbolAdmin(nombreJugador);
  dialogoAbierto = false;
}

void dibujarFondoJuego() {
  pushStyle();
  background(5, 9, 7);

  color colG = colorTema();
  float parX = (mouseX - width * 0.5) * 0.025;
  float parY = (mouseY - height * 0.5) * 0.025;
  float velCombo = 1.0 + min(comboActual, 15) * 0.18;

  noStroke();
  fill(colG, 14);
  float velOffset = (frameCount * 2.5 * velCombo) % (width + 800);

  pushMatrix();
  translate(-width + velOffset + parX * 0.5, parY * 0.5);
  for (int i = 0; i < 5; i++) {
    quad(i * 700, height, i * 700 + 200, height, i * 700 + 500, 0, i * 700 + 300, 0);
  }
  popMatrix();

  float horizY = height * 0.62 + parY * 0.8;
  stroke(colG, 26);
  strokeWeight(1.5);
  int numLineasPersp = 12;
  for (int i = -numLineasPersp; i <= numLineasPersp; i++) {
    float xTop = width * 0.5 + i * 65 + parX * 0.6;
    float xBot = width * 0.5 + i * 240 + parX * 1.8;
    line(xTop, horizY, xBot, height + 20);
  }
  float scrollGrid = (frameCount * 0.025 * velCombo) % 1.0;
  for (int r = 0; r < 6; r++) {
    float p = (r + scrollGrid) / 6.0;
    float yRow = horizY + pow(p, 1.8) * (height - horizY + 20);
    stroke(colG, map(p, 0, 1, 8, 45));
    line(0, yRow, width, yRow);
  }

  int totalNodos = 18;
  float[] nx = new float[18];
  float[] ny = new float[18];
  for (int i = 0; i < totalNodos; i++) {
    float prof = 0.4 + (i % 3) * 0.35;
    float baseAng = i * 2.399 + frameCount * 0.004 * prof * velCombo;
    float rx = width * 0.5 + cos(baseAng) * (width * 0.42) * noise(i * 11.3, frameCount * 0.002) + parX * prof * 1.6;
    float ry = height * 0.48 + sin(baseAng * 1.3) * (height * 0.42) * noise(i * 7.1 + 50, frameCount * 0.002) + parY * prof * 1.6;
    nx[i] = rx;
    ny[i] = ry;
  }

  strokeWeight(1.2);
  for (int i = 0; i < totalNodos; i++) {
    for (int j = i + 1; j < totalNodos; j++) {
      float d = dist(nx[i], ny[i], nx[j], ny[j]);
      if (d < 240) {
        stroke(colG, map(d, 0, 240, 42, 0));
        line(nx[i], ny[i], nx[j], ny[j]);
      }
    }
    noStroke();
    float pulsoNodo = 4.0 + sin(frameCount * 0.08 + i) * 2.0 + pulsoComboUI * 4.0;
    fill(colG, 75);
    ellipse(nx[i], ny[i], pulsoNodo * 2.2, pulsoNodo * 2.2);
    fill(255, 160);
    ellipse(nx[i], ny[i], pulsoNodo, pulsoNodo);
  }

  noStroke();
  fill(0, 105);
  rectMode(CORNER);
  rect(0, 0, width, height);

  popStyle();
}

void actualizarYDibujarJuego() {
  dibujarFondoJuego();

  if (fasePluginsActiva) {
    actualizarYRenderizarPlugins();
    actualizarYDibujarPopups();
  } else {
    actualizarYDibujarPopups();
    dibujarJimboYChat();
    actualizarEscrituraDialogo();
    dibujarOpcionesDialogo();
  }
}

void dibujarJimboYChat() {
  pushStyle();

  if (alphaAparicionJimbo < 1.0) {
    alphaAparicionJimbo += 0.02;
    if (alphaAparicionJimbo > 1.0) alphaAparicionJimbo = 1.0;
  }

  if (animandoAparicionChat) {
    if (progresoAparicionChat == 0.0) {
      reproducirDialogoIn();
    }
    progresoAparicionChat += 0.05;
    if (progresoAparicionChat >= 1.0) {
      progresoAparicionChat = 1.0;
      animandoAparicionChat = false;
      abrirDialogoAdmin(0);
    }
  }

  anguloFlotanteJimbo += 0.03;
  float desvioYJimbo = sin(anguloFlotanteJimbo) * 10.0;

  float xJimbo = width * 0.20;
  float yJimbo = height * 0.5 + desvioYJimbo;
  float tamanoIconoAncho = 220;
  float tamanoIconoAlto = 280;

  boolean hoverJimbo = (mouseX >= xJimbo - (tamanoIconoAncho * escalaJimboActual) / 2 &&
                        mouseX <= xJimbo + (tamanoIconoAncho * escalaJimboActual) / 2 &&
                        mouseY >= yJimbo - (tamanoIconoAlto * escalaJimboActual) / 2 &&
                        mouseY <= yJimbo + (tamanoIconoAlto * escalaJimboActual) / 2);
  float escalaObjetivo = hoverJimbo ? 1.18 : 1.0;
  escalaJimboActual = lerp(escalaJimboActual, escalaObjetivo, 0.15);

  color colMarcoJimbo = colorTema();

  pushMatrix();
  translate(xJimbo, yJimbo);
  scale(escalaJimboActual);
  rotate(sin(frameCount * 0.04) * 0.02 + (escalaJimboActual - 1.0) * -0.15);

  rectMode(CENTER);
  noStroke();

  pushMatrix();
  translate(8, 12);
  rotate(0.02);
  fill(red(colMarcoJimbo) * 0.25, green(colMarcoJimbo) * 0.25, blue(colMarcoJimbo) * 0.25, 140 * alphaAparicionJimbo);
  rect(0, 0, tamanoIconoAncho + 24, tamanoIconoAlto + 24, 20);
  popMatrix();

  fill(6, 16, 12, 240 * alphaAparicionJimbo);
  rect(0, 0, tamanoIconoAncho + 24, tamanoIconoAlto + 24, 20);

  imageMode(CENTER);
  tint(255, 255 * alphaAparicionJimbo);
  if (conversanteActual == 0 && imgAdminIcon != null) {
    image(imgShaderDaltonismo(imgAdminIcon), 0, 0, tamanoIconoAncho, tamanoIconoAlto);
  } else {
    if (conversanteActual == 1 && imgJefeTendencia != null) {
      image(imgShaderDaltonismo(imgJefeTendencia), 0, 0, tamanoIconoAncho, tamanoIconoAlto);
    } else {
      if (conversanteActual == 2 && imgJefeCamaraEco != null) {
        image(imgShaderDaltonismo(imgJefeCamaraEco), 0, 0, tamanoIconoAncho, tamanoIconoAlto);
      } else {
        if (conversanteActual == 3 && imgJefeDesinformacion != null) {
          image(imgShaderDaltonismo(imgJefeDesinformacion), 0, 0, tamanoIconoAncho, tamanoIconoAlto);
        } else {
          if (conversanteActual == 4) {
            if (imgJefeAlgoritmo != null) image(imgShaderDaltonismo(imgJefeAlgoritmo), 0, 0, tamanoIconoAncho, tamanoIconoAlto);
            else {
              if (imgAdminIcon != null) image(imgShaderDaltonismo(imgAdminIcon), 0, 0, tamanoIconoAncho, tamanoIconoAlto);
            }
          }
        }
      }
    }
  }
  noTint();
  imageMode(CORNER);

  dibujarMarcoProcedural(tamanoIconoAncho + 24, tamanoIconoAlto + 24, 10, alphaAparicionJimbo);
  popMatrix();

  if (progresoAparicionChat > 0.0) {
    dibujarCuadroDialogoCiber(width * 0.62, height * 0.5, 620, 260, progresoAparicionChat, colMarcoJimbo);
  }

  popStyle();
}

void dibujarCuadroDialogoCiber(float x, float y, float w, float h, float progreso, color colTema) {
  pushStyle();
  pushMatrix();
  translate(x, y);

  rectMode(CENTER);
  noStroke();

  pushMatrix();
  rotate(0.025 * progreso);
  fill(red(colTema) * 0.25, green(colTema) * 0.25, blue(colTema) * 0.25, 180 * progreso);
  rect(8, 10, w, h, 16);
  popMatrix();

  pushMatrix();
  rotate(-0.015 * progreso);
  fill(red(colTema) * 0.12, green(colTema) * 0.12, blue(colTema) * 0.12, 140 * progreso);
  rect(-8, 4, w, h, 16);
  popMatrix();

  fill(4, 12, 9, 235 * progreso);
  rect(0, 0, w, h, 16);

  float medioW = w / 2.0;
  float medioH = h / 2.0;

  textSize(anchoCeldaChatFondo * 0.7);
  for (int i = 0; i < numColumnasChatFondo; i++) {
    float colX = -medioW + 10 + i * anchoCeldaChatFondo;
    if (colX <= medioW - 10) {
      chatFondoOffsetY[i] += chatFondoVelocidad[i];
      if (chatFondoOffsetY[i] > h) chatFondoOffsetY[i] = 0;

      int filas = int(h / anchoCeldaChatFondo) + 2;
      for (int f = 0; f < filas; f++) {
        float celdaY = -medioH + ((chatFondoOffsetY[i] + f * anchoCeldaChatFondo) % (h + anchoCeldaChatFondo));
        if (celdaY > -medioH && celdaY < medioH) {
          fill(red(colTema), green(colTema), blue(colTema), map(f, 0, filas, 70, 8) * progreso);
          text(((int)((celdaY + colX) * 0.5) % 2) == 0 ? "0" : "1", colX, celdaY);
        }
      }
    }
  }

  noFill();
  stroke(red(colTema), green(colTema), blue(colTema), 200 * progreso);
  strokeWeight(2);
  rect(0, 0, w, h, 16);

  if (progreso > 0.35) {
    if (fuenteRetro != null) textFont(fuenteRetro);
    textAlign(LEFT, TOP);
    fill(red(colTema), green(colTema), blue(colTema), 255 * progreso);
    textSize(16);
    String etiquetaConversante = "ADMIN //";
    if (conversanteActual == 1) etiquetaConversante = "TENDENCIA VIRAL // [NEON-V]";
    else {
      if (conversanteActual == 2) etiquetaConversante = "EL HACKER // [CAMARA DE ECO]";
      else {
        if (conversanteActual == 3) etiquetaConversante = "EL PAYASO // [MR. DEEPFAKE]";
        else {
          if (conversanteActual == 4) etiquetaConversante = "EL ALGORITMO SUPREMO // [ROOT_CORE]";
        }
      }
    }
    text(etiquetaConversante, -medioW + 24, -medioH + 20);

    String textoVisible = mensajeActualDialogo.substring(0, min(caracteresVisiblesDialogo, mensajeActualDialogo.length()));
    fill(230, 235, 230, 255 * progreso);
    textSize(18);

    dibujarTextoConSaltosDeLinea(textoVisible, -medioW + 24, -medioH + 55, w - 48, 24);

    if ((millis() / 500) % 2 == 0) {
      noStroke();
      fill(red(colTema), green(colTema), blue(colTema), 255 * progreso);
      rectMode(CORNER);
      rect(-medioW + 24, medioH - 40, 10, 20);
    }
  }

  popMatrix();
  popStyle();
}

void inicializarPopups() {
  popupActivo = new boolean[6];
  popupX = new float[6];
  popupY = new float[6];
  popupVidaActual = new float[6];
  popupDuracionTotal = new float[6];
  popupMensajeActual = new String[6];
  popupSemillaTemblor = new float[6];
  for (int i = 0; i < maxPopups; i++) popupActivo[i] = false;
  tiempoSiguienteAparicionPopup = random(20, 60);
}

boolean posicionPopupValida(float px, float py, float mitadW, float mitadH) {
  float iconoCentroX = width * 0.20, iconoCentroY = height * 0.5;
  float chatCentroX = width * 0.62, chatCentroY = height * 0.5;
  float opcionesCentroX = width * 0.62, opcionesCentroY = height * 0.5 + 232;

  if (!fasePluginsActiva) {
    if (abs(px - iconoCentroX) < 160 + mitadW && abs(py - iconoCentroY) < 210 + mitadH) return false;
    if (abs(px - chatCentroX) < 340 + mitadW && abs(py - chatCentroY) < 160 + mitadH) return false;
    if (abs(px - opcionesCentroX) < 320 + mitadW && abs(py - opcionesCentroY) < 90 + mitadH) return false;
  }
  return true;
}

void actualizarYDibujarPopups() {
  pushStyle();
  tiempoSiguienteAparicionPopup -= 1.0;
  if (tiempoSiguienteAparicionPopup <= 0) {
    int indiceLibre = -1;
    for (int i = 0; i < maxPopups; i++) {
      if (!popupActivo[i]) { indiceLibre = i; break; }
    }
    if (indiceLibre != -1) {
      int totalMsgPopup = contarTextos(mensajesPopup);
      String mensajeElegido = mensajesPopup[int(random(totalMsgPopup))];
      float anchoEst = max(popupAnchoBase, textWidth(mensajeElegido) + 60);
      float xc = random(anchoEst/2 + 30, width - anchoEst/2 - 30);
      float yc = random(popupAltoBase/2 + 30, height - popupAltoBase/2 - 30);
      if (posicionPopupValida(xc, yc, anchoEst/2, popupAltoBase/2)) {
        popupActivo[indiceLibre] = true;
        popupX[indiceLibre] = xc;
        popupY[indiceLibre] = yc;
        popupVidaActual[indiceLibre] = 0.0;
        popupDuracionTotal[indiceLibre] = random(90, 150);
        popupMensajeActual[indiceLibre] = mensajeElegido;
        popupSemillaTemblor[indiceLibre] = random(1000);
      }
    }
    tiempoSiguienteAparicionPopup = random(35, 90);
  }

  color colPopup = colorTema();

  for (int i = 0; i < maxPopups; i++) {
    if (popupActivo[i]) {
      popupVidaActual[i] += 1.0;
      float p = popupVidaActual[i] / popupDuracionTotal[i];
      float alpha = (p < 0.12) ? map(p, 0, 0.12, 0, 255) : ((p > 0.75) ? map(p, 0.75, 1.0, 255, 0) : 255);

      pushMatrix();
      translate(popupX[i] + (noise(popupSemillaTemblor[i], popupVidaActual[i] * 0.4) - 0.5) * 6,
                popupY[i] + (noise(popupSemillaTemblor[i] + 500, popupVidaActual[i] * 0.4) - 0.5) * 6);
      rectMode(CENTER);
      noStroke();
      fill(4, 12, 9, 230 * (alpha / 255.0));
      rect(0, 0, popupAnchoBase, popupAltoBase, 10);
      noFill();
      stroke(red(colPopup), green(colPopup), blue(colPopup), alpha);
      strokeWeight(2);
      rect(0, 0, popupAnchoBase, popupAltoBase, 10);
      if (fuenteRetro != null) textFont(fuenteRetro);
      textAlign(CENTER, CENTER);
      textSize(18);
      fill(255, alpha);
      text(popupMensajeActual[i], 0, 0);
      popMatrix();

      if (popupVidaActual[i] >= popupDuracionTotal[i]) popupActivo[i] = false;
    }
  }
  popStyle();
}

void mousePressedJuego() {
  if (fasePluginsActiva) {
    mousePressedPlugins();
    return;
  }

  if (!dialogoAbierto) return;

  if (!textoDialogoTerminado()) {
    caracteresVisiblesDialogo = mensajeActualDialogo.length();
    detenerVozDialogo();
    reproducirClickUI(false);
    return;
  }

  int opcionElegida = opcionBajoMouseDialogo();
  if (opcionElegida != -1) {
    reproducirClickUI(true);
    seleccionarOpcionAdmin(opcionElegida);
  }
}

void mouseReleasedJuego() {
  if (fasePluginsActiva) {
    mouseReleasedPlugins();
  }
}

void keyPressedJuego() {
  if (!fasePluginsActiva && dialogoAbierto) {
    if (!textoDialogoTerminado() && (key == ' ' || key == ENTER || key == RETURN)) {
      caracteresVisiblesDialogo = mensajeActualDialogo.length();
      detenerVozDialogo();
    }
  }
}

void activarSistemaPluginsTrasDialogo() {
  dialogoAbierto = false;
  fasePluginsActiva = true;
  inicializarSistemaPlugins();
}
