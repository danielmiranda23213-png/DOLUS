int NUM_CARTAS = 1;
float anchoRect = 200;
float altoRect = 280;

float[] posXInicial;
float[] posYInicial;
float[] posXActual;
float[] posYActual;
float[] velCartaX;
float[] velCartaY;
float[] faseFlote;
float[] desplazamientoHover;
float[] escalaHover;
int[] hoverElapsed;

int cartaHover = -1;
int cartaHoverAnterior = -1;
int cartaArrastrada = -1;
float offsetXArrastre = 0;
float offsetYArrastre = 0;
float velXArrastre = 0;
float velYArrastre = 0;

PImage[] imagenFrente;
PImage imagenReverso;

int[] manoPlugins = new int[16];
int numManoPlugins = 0;

SoundFile sndHover;
SoundFile sndClick;
SoundFile sndVuelo;
SoundFile sndAterrizaje;

long ultimoHoverSonido = 0;
final int HOVER_COOLDOWN_MS = 180;
float shakeMag = 0;

float zonaIdX, zonaIdY, zonaIdAncho, zonaIdAlto;
boolean cartaAdheridaId = false;
boolean transicionIdActiva = false;
float progresoTransicionId = 0.0;
float escalaCartaSnap = 1.0;
float alphaTransicionId = 0.0;

final int NUM_BURST = 70;
float[] bX    = new float[70];
float[] bY    = new float[70];
float[] bVX   = new float[70];
float[] bVY   = new float[70];
float[] bAlph = new float[70];
float[] bTam  = new float[70];
float[] bRot  = new float[70];
int[]   bTipo = new int[70];

void inicializarSistemaPlugins() {
  if (!recursosPluginsPrecargados) {
    precargarRecursosPluginsYAudio();
  }

  numManoPlugins = 0;
  for (int i = 0; i < min(NUM_CARTAS, numCatalogoPlugins); i++) {
    if (numManoPlugins < 16) {
      manoPlugins[numManoPlugins] = i;
      numManoPlugins++;
    }
  }

  posXInicial = new float[1];
  posYInicial = new float[1];
  posXActual = new float[1];
  posYActual = new float[1];
  velCartaX = new float[1];
  velCartaY = new float[1];
  faseFlote = new float[1];
  desplazamientoHover = new float[1];
  escalaHover = new float[1];
  hoverElapsed = new int[1];

  if (imagenFrente == null) {
    imagenFrente = new PImage[1];
  }

  imagenReverso = cacheReversoIntro;
  sndHover = sndHoverPlugin;
  sndClick = sndClickPlugin;
  sndVuelo = sndVueloPlugin;
  sndAterrizaje = sndAterrizajePlugin;

  zonaIdAncho = 320;
  zonaIdAlto = 75;
  zonaIdX = width / 2.0;
  zonaIdY = height / 2.0 + 160;

  cartaAdheridaId = false;
  transicionIdActiva = false;
  progresoTransicionId = 0.0;
  escalaCartaSnap = 1.0;
  alphaTransicionId = 0.0;

  for (int i = 0; i < NUM_CARTAS; i++) {
    posXInicial[i] = width / 2.0;
    posYInicial[i] = height / 2.0 - 50;
    posXActual[i] = posXInicial[i];
    posYActual[i] = posYInicial[i];
    velCartaX[i] = 0;
    velCartaY[i] = 0;
    faseFlote[i] = i * 1.3;
    desplazamientoHover[i] = 0;
    escalaHover[i] = 1.0;
    hoverElapsed[i] = 0;

    if (i < numManoPlugins) {
      imagenFrente[i] = plugCatImgIntro[manoPlugins[i]];
    }
  }
  inicializarParticulasPlugins();
}

void actualizarYRenderizarPlugins() {
  actualizarParticulasPlugins();

  if (transicionIdActiva) {
    progresoTransicionId += 0.025;
    alphaTransicionId = lerp(alphaTransicionId, 255, 0.08);

    posXActual[0] = lerp(posXActual[0], zonaIdX, 0.2);
    posYActual[0] = lerp(posYActual[0], zonaIdY, 0.2);
    escalaCartaSnap = lerp(escalaCartaSnap, 0.0, 0.15);

    if (frameCount % 2 == 0) {
      emitirShimmerPlugins(zonaIdX, zonaIdY);
    }

    pushMatrix();
    pushStyle();

    rectMode(CENTER);
    noFill();
    color colTema = colorTema();
    stroke(colTema, 200 + sin(frameCount * 0.3) * 55);
    strokeWeight(3);
    rect(zonaIdX, zonaIdY, zonaIdAncho + sin(progresoTransicionId * 20) * 8, zonaIdAlto, 12);

    pushMatrix();
    translate(posXActual[0], posYActual[0]);
    scale(escalaCartaSnap);
    if (imagenFrente[0] != null) {
      imageMode(CENTER);
      image(imgShaderDaltonismo(imagenFrente[0]), 0, 0, anchoRect, altoRect);
    }
    popMatrix();

    dibujarParticulasBurstPlugins();

    noStroke();
    fill(0, alphaTransicionId);
    rectMode(CORNER);
    rect(0, 0, width, height);

    if (progresoTransicionId >= 1.2 || alphaTransicionId >= 245) {
      transicionIdActiva = false;
      estadoPantalla = PANTALLA_JUEGO;
    }

    popStyle();
    popMatrix();
    return;
  }

  detectarHoverPlugins();

  if (cartaHover != cartaHoverAnterior) {
    if (cartaHover != -1 && millis() - ultimoHoverSonido >= HOVER_COOLDOWN_MS) {
      if (sndHover != null) {
        reproducirSFXConTono(sndHover, random(0.95, 1.05), 0.55);
      }
      ultimoHoverSonido = millis();
    }
    cartaHoverAnterior = cartaHover;
  }

  actualizarArrastrePlugins();

  if (cartaHover != -1 && frameCount % 6 == 0) {
    float hx = posXActual[cartaHover];
    float hy = posYActual[cartaHover] + desplazamientoHover[cartaHover];
    emitirHoverSparkle(hx, hy);
  }

  pushMatrix();
  if (shakeMag > 0.05) {
    float sx = random(-shakeMag, shakeMag);
    float sy = random(-shakeMag, shakeMag);
    translate(sx, sy);
    shakeMag *= 0.82;
  } else {
    shakeMag = 0;
  }

  dibujarRecuadroZonaId();

  for (int i = 0; i < NUM_CARTAS; i++) {
    dibujarCartaPluginJuice(i);
  }

  dibujarParticulasBurstPlugins();
  popMatrix();
}

void dibujarRecuadroZonaId() {
  pushStyle();
  rectMode(CENTER);

  float distanciaCarta = dist(posXActual[0], posYActual[0], zonaIdX, zonaIdY);
  boolean cerca = (distanciaCarta < 150 && cartaArrastrada == 0);

  color colTema = colorTema();

  stroke(cerca ? colTema : color(40, 60, 50), cerca ? 255 : 160);
  strokeWeight(cerca ? 3.0 : 2.0);
  fill(10, 15, 12, 220);
  rect(zonaIdX, zonaIdY, zonaIdAncho, zonaIdAlto, 10);

  textAlign(CENTER, CENTER);
  if (fuenteRetro != null) {
    textFont(fuenteRetro);
  }
  textSize(18);
  fill(cerca ? colTema : color(140, 180, 160), cerca ? 255 : 180);
  text(cerca ? "> SOLTAR PARA VERIFICAR ID <" : "INGRESE SU ID", zonaIdX, zonaIdY);

  popStyle();
}

void detectarHoverPlugins() {
  cartaHover = -1;
  if (cartaArrastrada == -1 && !cartaAdheridaId) {
    for (int i = NUM_CARTAS - 1; i >= 0; i--) {
      if (mouseX >= posXActual[i] - (anchoRect * escalaHover[i]) / 2 &&
          mouseX <= posXActual[i] + (anchoRect * escalaHover[i]) / 2 &&
          mouseY >= posYActual[i] - (altoRect * escalaHover[i]) / 2  &&
          mouseY <= posYActual[i] + (altoRect * escalaHover[i]) / 2) {
        cartaHover = i;
        cursorSobreElementoClicable = true;
        break;
      }
    }
  } else {
    if (cartaArrastrada != -1) {
      cursorSobreElementoClicable = true;
    }
  }
}

void actualizarArrastrePlugins() {
  if (cartaArrastrada >= 0 && cartaArrastrada < NUM_CARTAS) {
    float prevX = posXActual[cartaArrastrada];
    float prevY = posYActual[cartaArrastrada];

    posXActual[cartaArrastrada] = mouseX - offsetXArrastre;
    posYActual[cartaArrastrada] = mouseY - offsetYArrastre;

    velXArrastre = lerp(velXArrastre, posXActual[cartaArrastrada] - prevX, 0.6);
    velYArrastre = lerp(velYArrastre, posYActual[cartaArrastrada] - prevY, 0.6);
  } else {
    cartaArrastrada = -1;
    velXArrastre = lerp(velXArrastre, 0, 0.2);
    velYArrastre = lerp(velYArrastre, 0, 0.2);

    if (!cartaAdheridaId) {
      for (int i = 0; i < NUM_CARTAS; i++) {
        aplicarSpringPlugin(i, posXInicial[i], posYInicial[i]);
      }
    }
  }

  for (int i = 0; i < NUM_CARTAS; i++) {
    boolean estaHover = (cartaHover == i && cartaArrastrada == -1 && !cartaAdheridaId);
    float objetivoHover = estaHover ? -14.0 : 0.0;
    float objetivoEscala = estaHover ? 1.06 : 1.0;

    desplazamientoHover[i] = lerp(desplazamientoHover[i], objetivoHover, 0.12);
    escalaHover[i] = lerp(escalaHover[i], objetivoEscala, 0.12);
  }
}

void aplicarSpringPlugin(int i, float objetivoX, float objetivoY) {
  float fuerzaX = (objetivoX - posXActual[i]) * 0.12;
  float fuerzaY = (objetivoY - posYActual[i]) * 0.12;
  velCartaX[i] = (velCartaX[i] + fuerzaX) * 0.65;
  velCartaY[i] = (velCartaY[i] + fuerzaY) * 0.65;
  posXActual[i] += velCartaX[i];
  posYActual[i] += velCartaY[i];
}

void dibujarCartaPluginJuice(int i) {
  if (i < 0 || i >= NUM_CARTAS) return;

  pushMatrix();
  pushStyle();

  float xActual = posXActual[i];
  float yActual = posYActual[i];

  float flote = 0;
  if (cartaArrastrada != i && !cartaAdheridaId) {
    flote = sin(frameCount * 0.025 + faseFlote[i]);
    yActual += flote * 6.0 + desplazamientoHover[i];
  }

  translate(xActual, yActual);

  float rotacion = 0;
  if (cartaArrastrada == i) {
    rotacion = constrain(velXArrastre * 0.065, -0.32, 0.32);
  } else {
    if (!cartaAdheridaId) {
      rotacion = flote * 0.03 + (velXArrastre * 0.02);
    }
  }
  rotate(rotacion);

  float escalaActual = escalaHover[i];
  if (cartaArrastrada == i) {
    escalaActual = 1.08;
  }
  scale(escalaActual);

  noStroke();
  fill(0, 90);
  rectMode(CENTER);
  rect(4, 12, anchoRect, altoRect, 10);

  if (i < NUM_CARTAS && imagenFrente[i] != null) {
    imageMode(CENTER);
    noTint();
    image(imgShaderDaltonismo(imagenFrente[i]), 0, 0, anchoRect, altoRect);
  } else {
    stroke(colorTema());
    strokeWeight(4);
    fill(0);
    rect(0, 0, anchoRect, altoRect);
  }

  popStyle();
  popMatrix();
}

void inicializarParticulasPlugins() {
  for (int i = 0; i < NUM_BURST; i++) bAlph[i] = 0;
}

void actualizarParticulasPlugins() {
  for (int i = 0; i < NUM_BURST; i++) {
    if (bAlph[i] > 0) {
      bX[i] += bVX[i];
      bY[i] += bVY[i];
      bVY[i] += 0.06;
      bVX[i] *= 0.97;
      bAlph[i] -= 6;
      bRot[i] += 0.08;
      if (bAlph[i] < 0) bAlph[i] = 0;
    }
  }
}

void dibujarParticulasBurstPlugins() {
  pushStyle();
  textAlign(CENTER, CENTER);
  textSize(14);
  color colTema = colorTema();
  for (int i = 0; i < NUM_BURST; i++) {
    if (bAlph[i] > 0) {
      fill(red(colTema), green(colTema), blue(colTema), bAlph[i]);
      text(bTipo[i] == 0 ? "0" : "1", bX[i], bY[i]);
    }
  }
  popStyle();
}

void emitirHoverSparkle(float x, float y) {
  for (int i = 0; i < NUM_BURST; i++) {
    if (bAlph[i] <= 0) {
      float angulo = random(TWO_PI);
      float radio  = random(anchoRect * 0.25, anchoRect * 0.5);
      bX[i] = x + cos(angulo) * radio;
      bY[i] = y + sin(angulo) * radio;
      bVX[i] = random(-0.4, 0.4);
      bVY[i] = -random(0.5, 1.2);
      bAlph[i] = random(80, 160);
      bTam[i] = random(10, 18);
      bRot[i] = random(TWO_PI);
      bTipo[i] = (int)random(2);
      break;
    }
  }
}

void emitirShimmerPlugins(float cx, float cy) {
  for (int i = 0; i < NUM_BURST; i++) {
    if (bAlph[i] <= 0) {
      bX[i] = cx + random(-80, 80);
      bY[i] = cy + random(-30, 30);
      bVX[i] = random(-1.5, 1.5);
      bVY[i] = random(-1.5, 1.5);
      bAlph[i] = random(150, 255);
      bTam[i] = random(14, 22);
      bRot[i] = random(TWO_PI);
      bTipo[i] = (int)random(2);
      break;
    }
  }
}

void mousePressedPlugins() {
  if (transicionIdActiva) return;

  for (int i = NUM_CARTAS - 1; i >= 0; i--) {
    if (mouseX >= posXActual[i] - (anchoRect * escalaHover[i]) / 2 &&
        mouseX <= posXActual[i] + (anchoRect * escalaHover[i]) / 2 &&
        mouseY >= posYActual[i] - (altoRect * escalaHover[i]) / 2  &&
        mouseY <= posYActual[i] + (altoRect * escalaHover[i]) / 2) {
      cartaArrastrada = i;
      offsetXArrastre = mouseX - posXActual[i];
      offsetYArrastre = mouseY - posYActual[i];

      if (sndClick != null) {
        reproducirSFX(sndClick);
      }
      break;
    }
  }
}

void mouseReleasedPlugins() {
  if (cartaArrastrada != -1) {
    float distanciaZona = dist(posXActual[0], posYActual[0], zonaIdX, zonaIdY);
    if (distanciaZona < 110) {
      cartaAdheridaId = true;
      transicionIdActiva = true;
      progresoTransicionId = 0.0;

      if (sndAterrizaje != null) {
        reproducirSFX(sndAterrizaje);
      }
    }
  }
  cartaArrastrada = -1;
}
