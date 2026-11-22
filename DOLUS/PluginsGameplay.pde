import processing.sound.*;

int[] pluginsJugador = new int[16];
int numPluginsJugador = 0;
PImage[] imagenesPluginsJugador = new PImage[5];
PImage[] imagenesPluginsSlot = new PImage[5];
PImage[] imagenesPluginsZoom = new PImage[5];
PImage imagenReversoPlugin;
PImage cacheImgPlug01Base = null;
PImage cacheImgPlug01Zoom = null;

SoundFile sndHoverPlugin;
SoundFile sndClickPlugin;
SoundFile sndVueloPlugin;
SoundFile sndAterrizajePlugin;

int MAX_PLUGINS = 5;
String[][] descripcionesCacheadasPlugin = new String[5][];

float[] plugPosX = new float[5];
float[] plugPosY = new float[5];
float[] plugBaseX = new float[5];
float[] plugBaseY = new float[5];
float[] plugProgreso = new float[5];
int[] plugEstado = new int[5];
float[] plugFaseFlote = new float[5];
float[] plugHoverElapsed = new float[5];
boolean[] aterrizajeSonadoPlugin = new boolean[5];

int pluginAbierto = -1;
int pluginHover = -1;
int pluginHoverAnterior = -1;
long ultimoHoverSonidoPlugin = 0;
float shakeMagPlugin = 0;

float anchoRectPlugin = 200;
float altoRectPlugin = 280;
float vueltasFlipPlugin = 1.4;
float inclinacionMaxPlugin = 1.0;
float escalaSlot = 0.85;

final int NUM_BURST_PLUG = 60;
float[] bXPlug = new float[60];
float[] bYPlug = new float[60];
float[] bVXPlug = new float[60];
float[] bVYPlug = new float[60];
float[] bAlphPlug = new float[60];
float[] bTamPlug = new float[60];
float[] bRotPlug = new float[60];
int[] bTipoPlug = new int[60];

boolean juegoPausadoPorPlugin() {
  for (int i = 0; i < MAX_PLUGINS; i++) {
    if (plugEstado[i] != 0) return true;
  }
  return false;
}

void inicializarPluginsGameplay() {
  if (!recursosPluginsPrecargados) {
    precargarRecursosPluginsYAudio();
  }
  sincronizarSlotsEquipados();
  imagenReversoPlugin = cacheReversoGameplay;

  for (int i = 0; i < MAX_PLUGINS; i++) {
    plugEstado[i] = 0;
    plugProgreso[i] = 0;
    plugFaseFlote[i] = i * 1.3;
    plugHoverElapsed[i] = 0;
    aterrizajeSonadoPlugin[i] = false;
  }
  recargarDatosPlugins();
  for(int i=0; i<NUM_BURST_PLUG; i++) bAlphPlug[i] = 0;
  pluginAbierto = -1;
  shakeMagPlugin = 0;
}

void reproducirPlugin(SoundFile s) {
  reproducirSFX(s);
}

void actualizarPluginsGameplay(float panelX, float panelY, float panelW, float panelH) {
  int totalSlots = limiteMaxSlotsRack();
  float pluginSpace = panelW / float(max(4, totalSlots));
  escalaSlot = (totalSlots > 4) ? 0.72 : 0.85;
  pluginHoverAnterior = pluginHover;
  pluginHover = -1;

  for (int i = 0; i < NUM_BURST_PLUG; i++) {
    if (bAlphPlug[i] > 0) {
      bXPlug[i] += bVXPlug[i]; bYPlug[i] += bVYPlug[i]; bVYPlug[i] += 0.06; bVXPlug[i] *= 0.97;
      bAlphPlug[i] -= 6; bRotPlug[i] += 0.08;
      if (bAlphPlug[i] < 0) bAlphPlug[i] = 0;
    }
  }

  for (int i = 0; i < totalSlots; i++) {
    plugBaseX[i] = panelX + pluginSpace * i + (pluginSpace)/2.0;
    plugBaseY[i] = panelY + panelH * 0.45;

    boolean bloqueadoPorTutorial = (mostrandoTutorial || mostrandoTutorialIngame || animandoShowcaseDirectiva || rondaCompletada);
    if (!bloqueadoPorTutorial && !juegoPausadoPorPlugin() && plugEstado[i] == 0 && i < numPluginsJugador) {
      if (mouseX >= plugBaseX[i] - (anchoRectPlugin*escalaSlot)/2 && mouseX <= plugBaseX[i] + (anchoRectPlugin*escalaSlot)/2 &&
          mouseY >= plugBaseY[i] - (altoRectPlugin*escalaSlot)/2 && mouseY <= plugBaseY[i] + (altoRectPlugin*escalaSlot)/2) {
        pluginHover = i;
      }
    }

    if (pluginHover == i && !bloqueadoPorTutorial) {
      plugHoverElapsed[i]++;
      cursorSobreElementoClicable = true;
    } else {
      plugHoverElapsed[i] = 0;
    }
    if (plugEstado[i] == 2) {
      cursorSobreElementoClicable = true;
    }

    if (plugEstado[i] == 1) {
      plugProgreso[i] += 0.035;
      if (!aterrizajeSonadoPlugin[i] && plugProgreso[i] >= 0.85) {
        reproducirSFX(sndAterrizajePlugin);
        aterrizajeSonadoPlugin[i] = true;
      }
      if (plugProgreso[i] >= 1.0) {
        plugProgreso[i] = 1.0;
        plugEstado[i] = 2;
        shakeMagPlugin = 8;
      }
    } else {
      if (plugEstado[i] == 3) {
        plugProgreso[i] -= 0.05;
        if (!aterrizajeSonadoPlugin[i] && plugProgreso[i] <= 0.15) {
          reproducirSFX(sndAterrizajePlugin);
          aterrizajeSonadoPlugin[i] = true;
        }
        if (plugProgreso[i] <= 0.0) {
          plugProgreso[i] = 0.0;
          plugEstado[i] = 0;
          if (pluginAbierto == i) pluginAbierto = -1;
        }
      }
    }
  }

  if (pluginHover != pluginHoverAnterior && pluginHover != -1) {
    if (millis() - ultimoHoverSonidoPlugin >= 180) {
      reproducirSFXConTono(sndHoverPlugin, random(0.92, 1.08), 0.45);
      ultimoHoverSonidoPlugin = millis();
    }
  }

  if (pluginHover != -1 && frameCount % 7 == 0) {
    emitirHoverSparklePlugin(plugBaseX[pluginHover], plugBaseY[pluginHover] - 10);
  }
  if (pluginAbierto >= 0 && plugEstado[pluginAbierto] == 2 && frameCount % 3 == 0) {
    emitirShimmerPlugin(width / 2.0 - 250, height / 2.0);
  }
}

void dibujarCapasPluginsSuperpuestas() {
  int totalSlots = limiteMaxSlotsRack();
  float alphaOscuro = 0;
  for (int i = 0; i < MAX_PLUGINS; i++) {
    if (plugEstado[i] != 0) {
      if (plugEstado[i] == 2) alphaOscuro = max(alphaOscuro, 1.0);
      else {
        if (plugEstado[i] == 1) alphaOscuro = max(alphaOscuro, plugProgreso[i]);
        else alphaOscuro = max(alphaOscuro, plugProgreso[i]);
      }
    }
  }

  if (alphaOscuro > 0) {
    pushStyle(); fill(0, 180 * alphaOscuro); noStroke(); rectMode(CORNER);
    rect(0, 0, width, height); popStyle();
  }

  pushMatrix();
  if (shakeMagPlugin > 0.05) {
    translate(int(random(-shakeMagPlugin, shakeMagPlugin)), int(random(-shakeMagPlugin, shakeMagPlugin)));
    shakeMagPlugin *= 0.82;
  } else {
    shakeMagPlugin = 0;
  }

  for (int i = 0; i < totalSlots; i++) {
    if (plugEstado[i] == 0) dibujarCartaExactaJuego(i);
  }
  if (pluginAbierto == -1) {
    float[] offsetYSlot = new float[5];
    boolean[] slotOculto = new boolean[5];
    for (int i = 0; i < MAX_PLUGINS; i++) {
      if (i < totalSlots && plugEstado[i] == 0) {
        offsetYSlot[i] = sin(frameCount * 0.02 + plugFaseFlote[i]) * 4.5 + (pluginHover == i ? -10.0 : 0.0);
        slotOculto[i] = false;
      } else {
        offsetYSlot[i] = 0.0;
        slotOculto[i] = true;
      }
    }
    dibujarSinergiasVisualesRack(slotOculto, offsetYSlot, anchoRectPlugin * escalaSlot, altoRectPlugin * escalaSlot);
  }

  dibujarParticulasBurstPlugin();

  for (int i = 0; i < totalSlots; i++) {
    if (plugEstado[i] != 0) {
      dibujarCartaExactaJuego(i);
      if (plugProgreso[i] > 0) {
        dibujarCuadroDialogoPluginJuego(i);
      }
    }
  }
  popMatrix();
}

void dibujarParticulasBurstPlugin() {
  pushStyle();
  textAlign(CENTER, CENTER);
  textSize(14);
  color cTema = colorTema();
  color cAlt = color(100, 255, 140);
  for (int i = 0; i < NUM_BURST_PLUG; i++) {
    if (bAlphPlug[i] > 0) {
      if (bTipoPlug[i] == 0) {
        fill(cTema, bAlphPlug[i]);
        text("0", bXPlug[i], bYPlug[i]);
      } else {
        fill(cAlt, bAlphPlug[i]);
        text("1", bXPlug[i], bYPlug[i]);
      }
    }
  }
  popStyle();
}

void emitirShimmerPlugin(float cx, float cy) {
  float w = anchoRectPlugin * 2.0 * 0.45;
  float h = altoRectPlugin * 2.0 * 0.45;
  for (int i = 0; i < NUM_BURST_PLUG; i++) {
    if (bAlphPlug[i] <= 0) {
      bXPlug[i] = cx + random(-w, w); bYPlug[i] = cy + random(-h, h);
      bVXPlug[i] = random(-0.3, 0.3); bVYPlug[i] = -random(0.3, 1.2);
      bAlphPlug[i] = random(70, 140); bTamPlug[i] = random(12, 18);
      bRotPlug[i] = random(TWO_PI); bTipoPlug[i] = (int)random(2);
      break;
    }
  }
}

void emitirHoverSparklePlugin(float x, float y) {
  for (int i = 0; i < NUM_BURST_PLUG; i++) {
    if (bAlphPlug[i] <= 0) {
      float ang = random(TWO_PI); float rad = random(anchoRectPlugin*0.25, anchoRectPlugin*0.5);
      bXPlug[i] = x + cos(ang)*rad; bYPlug[i] = y + sin(ang)*rad;
      bVXPlug[i] = random(-0.3, 0.3); bVYPlug[i] = -random(0.4, 1.0);
      bAlphPlug[i] = random(60, 120); bTamPlug[i] = random(10, 16);
      bRotPlug[i] = random(TWO_PI); bTipoPlug[i] = (int)random(2);
      break;
    }
  }
}

void dibujarCartaExactaJuego(int i) {
  if (i >= numPluginsJugador) {
    pushMatrix(); translate(plugBaseX[i], plugBaseY[i]); scale(escalaSlot);
    stroke(colorTema(), 50); strokeWeight(4); fill(0, 50);
    dibujarFormaAngularJuego(anchoRectPlugin, altoRectPlugin, 26); popMatrix();
    return;
  }

  pushMatrix(); pushStyle();
  float progreso = plugProgreso[i];
  float destinoX = width / 2.0 - 250;
  float destinoY = height / 2.0;

  float factorPosicion = (plugEstado[i] == 3) ? easeInBackPlugin(progreso) : easeOutBackPlugin(progreso);
  float xActual = lerp(plugBaseX[i], destinoX, factorPosicion);
  float yActual = lerp(plugBaseY[i], destinoY, factorPosicion);

  float flote = 0;
  if (plugEstado[i] == 0) {
    flote = sin(frameCount * 0.02 + plugFaseFlote[i]);
    yActual += flote * 4.5;
    if (pluginHover == i) yActual -= 10;
  } else {
    if (plugEstado[i] == 1 && progreso > 0.80 && progreso < 1.0) {
      xActual += random(-2.5, 2.5); yActual += random(-2.5, 2.5);
    }
  }

  if (plugEstado[i] == 0 && pluginHover != i && slotPluginJuice[i] < 0.01 && imagenesPluginsSlot[i] != null) {
    int bx = int(xActual);
    int by = int(yActual);
    noStroke();
    fill(0, 145);
    rectMode(CENTER);
    rect(bx + 7, by + 9, imagenesPluginsSlot[i].width - 4, imagenesPluginsSlot[i].height - 4, 14);
    imageMode(CENTER);
    noTint();
    image(imgShaderDaltonismo(imagenesPluginsSlot[i]), bx, by);
    popStyle();
    popMatrix();
    return;
  }

  if (plugEstado[i] == 2 && imagenesPluginsZoom[i] != null) {
    translate(int(destinoX), int(destinoY));
    imageMode(CENTER);
    noTint();
    image(imgShaderDaltonismo(imagenesPluginsZoom[i]), 0, 0);
    popStyle();
    popMatrix();
    return;
  }

  translate(xActual, yActual);

  float rotacion = (plugEstado[i] == 2) ? 0.0 : (1.0 - factorPosicion) * TWO_PI;
  if (plugEstado[i] == 0) {
    rotacion = flote * 0.025 + slotPluginJuiceRot[i] * slotPluginJuice[i];
  }
  if (abs(rotacion) > 0.001) rotate(rotacion);

  float escala = lerp(escalaSlot, 2.3, easeOutBackPlugin(progreso));
  if (plugEstado[i] == 3) escala = lerp(escalaSlot, 2.3, easeInBackPlugin(progreso));

  float anguloFlip = TWO_PI * vueltasFlipPlugin * progreso;
  float inclinacion = sin(PI * progreso);
  float cosFlip = cos(anguloFlip);
  float escalaX = (plugEstado[i] == 2) ? escala : escala * abs(cosFlip);
  float escalaY = (plugEstado[i] == 2) ? escala : escala * lerp(1.0, inclinacionMaxPlugin, inclinacion);

  float rebote = 0;
  if (plugEstado[i] == 0 && pluginHover == i) {
    float t = plugHoverElapsed[i] * 0.05;
    rebote = sin(t * 6.0) * exp(-t * 1.4) * 0.14;
  }
  if (plugEstado[i] == 0 && slotPluginJuice[i] > 0.01) {
    rebote += slotPluginJuice[i] * 0.18;
  }
  escalaX *= (1.0 + rebote); escalaY *= (1.0 - rebote * 0.7);

  float anticipacion = 0;
  if (plugEstado[i] == 1 && progreso < 0.12) {
    float tAnt = (progreso / 0.12) * (PI / 6.0);
    anticipacion = sin(tAnt * 6.0) * exp(-tAnt * 1.4) * 0.10;
  }
  escalaX *= (1.0 - anticipacion); escalaY *= (1.0 + anticipacion * 0.6);

  float intensidadSombra = (plugEstado[i] == 3) ? 160 * progreso : 160 * (1.0 - progreso);
  if (intensidadSombra > 0 && plugEstado[i] != 0) {
    noStroke(); fill(0, intensidadSombra);
    pushMatrix(); scale(escalaX, escalaY); translate(6, 8);
    dibujarFormaAngularJuego(anchoRectPlugin - 10, altoRectPlugin - 10, 22); popMatrix();
  }

  if (plugEstado[i] == 0) {
    noStroke(); fill(0, 150);
    pushMatrix(); scale(escalaX, escalaY); translate(8, 10);
    dibujarFormaAngularJuego(anchoRectPlugin, altoRectPlugin, 26); popMatrix();
  }

  scale(escalaX, escalaY);

  boolean enVuelo = (plugEstado[i] == 1 || plugEstado[i] == 3);
  boolean aterrizando = enVuelo && progreso > 0.67;
  boolean verFrente = !enVuelo || aterrizando || (cosFlip >= 0);

  if (verFrente) dibujarCaraFrentePluginJuego(i);
  else dibujarCaraReversoPluginJuego(i);

  popStyle(); popMatrix();
}

void dibujarCaraFrentePluginJuego(int i) {
  color colG = colorTema();

  if (imagenesPluginsJugador[i] != null) {
    imageMode(CENTER); noTint();
    image(imgShaderDaltonismo(imagenesPluginsJugador[i]), 0, 0);
    return;
  }

  stroke(colG); strokeWeight(4); fill(color(14, 18, 15));
  dibujarFormaAngularJuego(anchoRectPlugin, altoRectPlugin, 26);
  noStroke(); fill(colG);
  pushMatrix(); translate(0, -altoRectPlugin / 2 + 30);
  rectMode(CENTER); rect(0, 0, anchoRectPlugin - 10, 26, 0); popMatrix();

  stroke(colG, 130); strokeWeight(1.5); noFill();
  dibujarFormaAngularJuego(anchoRectPlugin - 30, altoRectPlugin - 60, 16);

  noStroke(); fill(colG, 200);
  pushMatrix(); translate(-anchoRectPlugin / 2 + 34, altoRectPlugin / 2 - 26); rotate(radians(-20)); rect(0, 0, 40, 4); popMatrix();
  pushMatrix(); translate(anchoRectPlugin / 2 - 34, altoRectPlugin / 2 - 26); rotate(radians(-20)); rect(0, 0, 40, 4); popMatrix();
}

void dibujarCaraReversoPluginJuego(int i) {
  if (imagenReversoPlugin != null) {
    imageMode(CENTER); noTint(); image(imgShaderDaltonismo(imagenReversoPlugin), 0, 0);
    return;
  }
  color colG = colorTema();
  stroke(colG); strokeWeight(4); fill(0);
  dibujarFormaAngularJuego(anchoRectPlugin, altoRectPlugin, 26);
  stroke(colG, 60); strokeWeight(1.5); noFill();
  dibujarFormaAngularJuego(anchoRectPlugin - 20, altoRectPlugin - 20, 18);
  stroke(colG, 30); strokeWeight(1);
  dibujarFormaAngularJuego(anchoRectPlugin - 50, altoRectPlugin - 50, 12);
  noFill(); stroke(colG, 100); strokeWeight(1.5);
  pushMatrix(); rotate(radians(45)); rectMode(CENTER); rect(0, 0, 44, 44); popMatrix();
  noStroke(); fill(colG, 80); ellipse(0, 0, 8, 8);
}

void dibujarFormaAngularJuego(float w, float h, float corte) {
  float hw = w / 2.0; float hh = h / 2.0;
  beginShape();
  vertex(-hw + corte, -hh); vertex(hw, -hh); vertex(hw, hh - corte);
  vertex(hw - corte, hh); vertex(-hw, hh); vertex(-hw, -hh + corte);
  endShape(CLOSE);
}

void dibujarCuadroDialogoPluginJuego(int i) {
  int pIdx = pluginsJugador[i];
  pushStyle(); rectMode(CENTER);
  if (fuenteRetro != null) textFont(fuenteRetro);

  String compSynActiva = (slotsPluginEquipado != null && i >= 0 && i < 5)
    ? obtenerCompanerosSinergiaActiva(slotsPluginEquipado[i]) : "";
  boolean haySynActiva = !compSynActiva.equals("");

  int numLineas = contarTextos(descripcionesCacheadasPlugin[i]);
  float tamTextoDesc = 15;
  float interlineado = 20;
  float anchoDialogo = 560;
  float altoExtraSyn = haySynActiva ? 26 : 0;
  float altoCalculado = 166 + altoExtraSyn + numLineas * interlineado;
  float altoMaxPantalla = max(280, height - 48);
  if (altoCalculado > altoMaxPantalla && numLineas > 0) {
    tamTextoDesc = 13;
    interlineado = 17;
    altoCalculado = 160 + altoExtraSyn + numLineas * interlineado;
  }
  float altoDialogo = constrain(altoCalculado, 260, altoMaxPantalla);

  float xDiag = constrain(((width / 2.0 - 300) + 400) + (anchoDialogo * 0.10), anchoDialogo * 0.5 + 24, width - anchoDialogo * 0.5 - 24);
  float yDiag = constrain(height / 2.0, altoDialogo * 0.5 + 24, height - altoDialogo * 0.5 - 24);

  float entradaPanel = (plugEstado[i] == 1) ? easeOutCubicPlugin(constrain(plugProgreso[i] * 1.25, 0, 1)) :
                       (plugEstado[i] == 2) ? 1.0 : easeInCubicPlugin(constrain(plugProgreso[i] * 1.5, 0, 1));

  float panelX = int(lerp(xDiag + 140, xDiag, entradaPanel));
  float alphaPanel = 255 * entradaPanel;

  pushMatrix();
  translate(panelX, int(yDiag));

  fill(0, alphaPanel * 0.7); noStroke();
  pushMatrix(); translate(15, 15); dibujarFormaAngularJuego(anchoDialogo, altoDialogo, 30); popMatrix();

  color colG = colorTema();
  stroke(colG, alphaPanel * 0.7); strokeWeight(2.5); fill(color(14, 18, 15), alphaPanel * 0.98);
  dibujarFormaAngularJuego(anchoDialogo, altoDialogo, 30);

  noStroke(); fill(colG, alphaPanel);
  pushMatrix(); translate(0, -altoDialogo / 2 + 22); rect(0, 0, anchoDialogo - 6, 40, 0); popMatrix();

  fill(color(15, 90, 45), alphaPanel);
  pushMatrix(); translate(anchoDialogo / 2 - 70, -altoDialogo / 2 + 22); rotate(radians(-20)); rect(0, 0, 60, 40); popMatrix();

  fill(color(245, 245, 240), alphaPanel); textSize(17); textAlign(LEFT, CENTER);
  text("INFORMACIÓN DEL PLUGIN", -anchoDialogo / 2 + 20, -altoDialogo / 2 + 22);

  fill(color(245, 245, 240), alphaPanel);
  pushMatrix(); translate(anchoDialogo / 2 - 26, -altoDialogo / 2 + 22); rotate(radians(45)); rect(0, 0, 22, 22); popMatrix();
  fill(colG, alphaPanel); textSize(14); textAlign(CENTER, CENTER);
  text("X", anchoDialogo / 2 - 26, -altoDialogo / 2 + 21);

  fill(colG, alphaPanel); textSize(12); textAlign(LEFT, TOP);
  text(plugCatCategoria[pIdx], -anchoDialogo / 2 + 24, -altoDialogo / 2 + 56);

  fill(color(245, 245, 240), alphaPanel); textSize(tamTextoDesc); textAlign(LEFT, TOP);

  if (descripcionesCacheadasPlugin[i] != null) {
    float yTexto = -altoDialogo / 2 + 84;
    float limiteInfTexto = haySynActiva ? (altoDialogo / 2 - 84) : (altoDialogo / 2 - 60);
    for (int l = 0; l < numLineas; l++) {
      String linea = descripcionesCacheadasPlugin[i][l];
      if (yTexto + interlineado > limiteInfTexto) break;
      dibujarLineaDolus(linea, -anchoDialogo / 2 + 24, yTexto, color(245, 245, 240, alphaPanel), LEFT);
      yTexto += interlineado;
    }
  }

  if (haySynActiva) {
    dibujarTextoSinergiaBanner("SINERGIA ACTIVA CON: " + compSynActiva, -anchoDialogo / 2 + 24, altoDialogo / 2 - 74, anchoDialogo - 48, 13, alphaPanel, TOP);
  }

  fill(colG, alphaPanel); textSize(12); textAlign(LEFT, TOP);
  text(plugCatEstado[pIdx], -anchoDialogo / 2 + 24, altoDialogo / 2 - 48);

  fill(color(245, 245, 240), alphaPanel * 0.8); textSize(13); textAlign(CENTER, BOTTOM);
  text("PULSA FUERA DE ESTA VENTANA PARA CERRAR", 0, altoDialogo / 2 - 14);

  popMatrix();
  popStyle();
}

void mousePressedPluginsGameplay() {
  if (pluginAbierto == -1) {
    if (pluginHover != -1 && plugEstado[pluginHover] == 0) {
      plugEstado[pluginHover] = 1;
      plugProgreso[pluginHover] = 0.0;
      pluginAbierto = pluginHover;
      aterrizajeSonadoPlugin[pluginHover] = false;
      reproducirSFX(sndClickPlugin);
      reproducirSFX(sndVueloPlugin);
    }
  } else {
    if (plugEstado[pluginAbierto] == 2) {
      plugEstado[pluginAbierto] = 3;
      aterrizajeSonadoPlugin[pluginAbierto] = false;
      reproducirClickUI(true);
      reproducirSFX(sndVueloPlugin);
    }
  }
}

float easeOutCubicPlugin(float x) { return 1 - pow(1 - x, 3); }
float easeInCubicPlugin(float x) { return x * x * x; }
float easeInBackPlugin(float x) { float c1 = 1.70158; return (c1 + 1) * x * x * x - c1 * x * x; }
float easeOutBackPlugin(float x) { return 1.0 - easeInBackPlugin(1.0 - x); }

String[] wrapTextoPlugin(String texto, float maxWidth) {
  String[] parrafos = dividirTexto(texto, "\n");
  int numParrafos = contarTextos(parrafos);
  String[] resultado = new String[64];
  int numRes = 0;
  for (int p = 0; p < numParrafos; p++) {
    String[] palabras = dividirTexto(parrafos[p], " ");
    int numPalabras = contarTextos(palabras);
    String lineaActual = "";
    for (int w = 0; w < numPalabras; w++) {
      String palabra = palabras[w];
      String prueba = lineaActual.length() == 0 ? palabra : lineaActual + " " + palabra;
      if (textWidth(prueba) <= maxWidth || lineaActual.length() == 0) {
        lineaActual = prueba;
      } else {
        if (numRes < 64) {
          resultado[numRes] = lineaActual;
          numRes++;
        }
        lineaActual = palabra;
      }
    }
    if (numRes < 64) {
      resultado[numRes] = lineaActual;
      numRes++;
    }
  }
  return resultado;
}

void recargarDatosPlugins() {
  if (!recursosPluginsPrecargados) {
    precargarRecursosPluginsYAudio();
  }
  for (int i = 0; i < MAX_PLUGINS; i++) {
    imagenesPluginsJugador[i] = null;
    imagenesPluginsSlot[i] = null;
    imagenesPluginsZoom[i] = null;
    descripcionesCacheadasPlugin[i] = null;

    if (i < numPluginsJugador) {
      int pIdx = pluginsJugador[i];
      imagenesPluginsJugador[i] = plugCatImgBase[pIdx];
      imagenesPluginsSlot[i] = plugCatImgSlot[pIdx];
      imagenesPluginsZoom[i] = plugCatImgZoom[pIdx];

      String descCompleta = plugCatDescripcion[pIdx] + "\n\n[PASIVA]: " + plugCatNombrePasiva[pIdx] + " - " + plugCatDescripcionPasiva[pIdx];
      if (!plugCatNombreActiva[pIdx].equals("Ninguna")) {
         descCompleta += "\n\n[ACTIVA]: " + plugCatNombreActiva[pIdx] + " - " + plugCatDescripcionActiva[pIdx];
      }

      if (fuenteRetro != null) textFont(fuenteRetro);
      textSize(15);
      descripcionesCacheadasPlugin[i] = wrapTextoPlugin(descCompleta, 504);
    }
  }
}
