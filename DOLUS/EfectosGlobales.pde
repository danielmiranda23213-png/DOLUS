float glitchIntensity = 0;
int ultimoEstadoPantallaProf = -1;
float flashTransicionProf = 0;
String globalUltimoBotonHover = "";

int[] evFramesEspera = new int[96];
int[] evTipo = new int[96];
String[] evTexto = new String[96];
float[] evX = new float[96];
float[] evY = new float[96];
color[] evCol = new color[96];
int[] evValorExtra = new int[96];
int numEventosJuego = 0;
int eslabonCadenaPlugin = 0;
int frameUltimoEslabonPlugin = -999;

void eliminarEventoJuegoEn(int idx) {
  if (idx < 0 || idx >= numEventosJuego) return;
  for (int i = idx; i < numEventosJuego - 1; i++) {
    evFramesEspera[i] = evFramesEspera[i + 1];
    evTipo[i] = evTipo[i + 1];
    evTexto[i] = evTexto[i + 1];
    evX[i] = evX[i + 1];
    evY[i] = evY[i + 1];
    evCol[i] = evCol[i + 1];
    evValorExtra[i] = evValorExtra[i + 1];
  }
  numEventosJuego--;
}

void encolarEvento(int framesEspera, int tipo, String texto, float x, float y, color col, int extra) {
  if (numEventosJuego > 80 || numEventosJuego >= 96) return;
  int idx = numEventosJuego;
  evFramesEspera[idx] = max(0, framesEspera);
  evTipo[idx] = tipo;
  evTexto[idx] = texto;
  evX[idx] = x;
  evY[idx] = y;
  evCol[idx] = col;
  evValorExtra[idx] = extra;
  numEventosJuego++;
}

void limpiarColaEventos() {
  numEventosJuego = 0;
  numRayosFlourish = 0;
  eslabonCadenaPlugin = 0;
}

void actualizarColaEventos() {
  for (int i = numEventosJuego - 1; i >= 0; i--) {
    evFramesEspera[i]--;
    if (evFramesEspera[i] <= 0) {
      ejecutarEventoJuego(i);
      eliminarEventoJuegoEn(i);
    }
  }
}

void ejecutarEventoJuego(int idx) {
  if (idx < 0 || idx >= numEventosJuego) return;
  int tipo = evTipo[idx];
  String txt = evTexto[idx];
  float pxEv = evX[idx];
  float pyEv = evY[idx];
  color cEv = evCol[idx];
  int extra = evValorExtra[idx];

  if (tipo == 1) {
    dispararTextoElastico(txt, pxEv, pyEv, cEv);
  } else {
    if (tipo == 2) {
      pulsarBarraStat(extra);
    } else {
      if (tipo == 3) {
        if (frameCount - frameUltimoEslabonPlugin > 28) {
          eslabonCadenaPlugin = 0;
        } else {
          eslabonCadenaPlugin = min(8, eslabonCadenaPlugin + 1);
        }
        frameUltimoEslabonPlugin = frameCount;

        juiceSlotPlugin(extra);
        dispararMarcoRayosPlugin(extra, cEv);
        dispararSacudidaCamara(1.8 + eslabonCadenaPlugin * 0.6);

        if (sndHoverPlugin != null) {
          float pitchCadena = constrain(0.95 + eslabonCadenaPlugin * 0.11, 0.9, 1.85);
          reproducirSFXConTono(sndHoverPlugin, pitchCadena, 0.50);
        }

        if (txt != null && txt.length() > 0) {
          float py = (pyEv > 0) ? pyEv : (leftPanelSlotY != null && extra >= 0 && extra < 4 ? leftPanelSlotY[extra] : height * 0.55);
          float px = (pxEv > 0) ? pxEv : width * 0.22;
          dispararTextoElastico(txt, px, py, cEv);
        }
      } else {
        if (tipo == 4) {
          tokensDolus = max(0, tokensDolus + extra);
          pulsoTokensUI = 1.0;
          reproducirTap();
          fijarProgresoMaximoLogro(8, tokensDolus);
        } else {
          if (tipo == 5) {
            dispararSacudidaCamara(pxEv);
          } else {
            if (tipo == 6) {
              dispararOrbesToken(pxEv, pyEv, extra, cEv);
            }
          }
        }
      }
    }
  }
}

float[] partX = new float[256];
float[] partY = new float[256];
float[] partVX = new float[256];
float[] partVY = new float[256];
float[] partTam = new float[256];
float[] partRot = new float[256];
float[] partVRot = new float[256];
float[] partVida = new float[256];
float[] partVidaMax = new float[256];
color[] partCol = new color[256];
int[] partTipo = new int[256];
float[] partDestX = new float[256];
float[] partDestY = new float[256];
int numParticulasJuego = 0;

void agregarParticulaJuego(float px, float py, float pvx, float pvy, float ptam, color c, int ptipo, float dX, float dY) {
  if (numParticulasJuego >= 256) return;
  int idx = numParticulasJuego;
  partX[idx] = px;
  partY[idx] = py;
  partVX[idx] = pvx;
  partVY[idx] = pvy;
  partTam[idx] = ptam;
  partRot[idx] = random(TWO_PI);
  partVRot[idx] = random(-0.22, 0.22);
  partVidaMax[idx] = (ptipo == 2) ? 38.0 : random(24.0, 46.0);
  partVida[idx] = partVidaMax[idx];
  partCol[idx] = c;
  partTipo[idx] = ptipo;
  partDestX[idx] = dX;
  partDestY[idx] = dY;
  numParticulasJuego++;
}

void eliminarParticulaJuegoEn(int idx) {
  if (idx < 0 || idx >= numParticulasJuego) return;
  for (int i = idx; i < numParticulasJuego - 1; i++) {
    partX[i] = partX[i + 1];
    partY[i] = partY[i + 1];
    partVX[i] = partVX[i + 1];
    partVY[i] = partVY[i + 1];
    partTam[i] = partTam[i + 1];
    partRot[i] = partRot[i + 1];
    partVRot[i] = partVRot[i + 1];
    partVida[i] = partVida[i + 1];
    partVidaMax[i] = partVidaMax[i + 1];
    partCol[i] = partCol[i + 1];
    partTipo[i] = partTipo[i + 1];
    partDestX[i] = partDestX[i + 1];
    partDestY[i] = partDestY[i + 1];
  }
  numParticulasJuego--;
}

void dispararExplosionCarta(float cx, float cy, color cPrincipal, boolean incluirFragmentos) {
  if (numParticulasJuego > 180) return;

  int cantChispas = incluirFragmentos ? 22 : 12;
  for (int i = 0; i < cantChispas; i++) {
    float ang = random(TWO_PI);
    float vel = random(3.5, 13.0);
    color cP = (i % 3 == 0) ? color(255) : cPrincipal;
    agregarParticulaJuego(
      cx + random(-90, 90),
      cy + random(-50, 50),
      cos(ang) * vel,
      sin(ang) * vel - random(1.0, 3.0),
      random(5, 12),
      cP,
      0, 0, 0
    );
  }

  if (incluirFragmentos) {
    for (int i = 0; i < 14; i++) {
      float ang = random(TWO_PI);
      float vel = random(4.0, 11.0);
      agregarParticulaJuego(
        cx + random(-140, 140),
        cy + random(-80, 80),
        cos(ang) * vel,
        sin(ang) * vel - 2.0,
        random(16, 34),
        cPrincipal,
        1, 0, 0
      );
    }
  }
}

void dispararOrbesToken(float origenX, float origenY, int cantidad, color colOrbe) {
  if (numParticulasJuego > 180) return;
  int n = constrain(cantidad, 1, 10);
  float metaX = width * 0.02 + width * 0.26 - 70;
  float metaY = height * 0.03 + height * 0.72 - 50;

  for (int i = 0; i < n; i++) {
    float ang = random(TWO_PI);
    float vel = random(4.0, 9.0);
    agregarParticulaJuego(
      origenX + random(-30, 30),
      origenY + random(-20, 20),
      cos(ang) * vel,
      sin(ang) * vel,
      random(9, 15),
      colOrbe,
      2, metaX, metaY
    );
  }
}

void actualizarYDibujarParticulasJuego() {
  if (numParticulasJuego == 0) return;

  pushStyle();
  for (int i = numParticulasJuego - 1; i >= 0; i--) {
    partVida[i] -= 1.0;
    if (partVida[i] <= 0) {
      if (partTipo[i] == 2) {
        pulsoTokensUI = max(pulsoTokensUI, 0.65);
      }
      eliminarParticulaJuegoEn(i);
      continue;
    }

    float tVida = constrain(partVida[i] / partVidaMax[i], 0, 1);

    if (partTipo[i] == 2) {
      float progreso = 1.0 - tVida;
      partVX[i] = lerp(partVX[i], (partDestX[i] - partX[i]) * 0.18, 0.25);
      partVY[i] = lerp(partVY[i], (partDestY[i] - partY[i]) * 0.18, 0.25);
      partX[i] += partVX[i];
      partY[i] += partVY[i];
      if (progreso > 0.3 && dist(partX[i], partY[i], partDestX[i], partDestY[i]) < 22) {
        pulsoTokensUI = 1.0;
        eliminarParticulaJuegoEn(i);
        continue;
      }
    } else {
      partX[i] += partVX[i];
      partY[i] += partVY[i];
      partVY[i] += (partTipo[i] == 1) ? 0.38 : 0.18;
      partVX[i] *= 0.96;
      partRot[i] += partVRot[i];
    }

    float alphaP = 255 * tVida;
    pushMatrix();
    translate(partX[i], partY[i]);
    rotate(partRot[i]);

    if (partTipo[i] == 0) {
      noStroke();
      fill(red(partCol[i]), green(partCol[i]), blue(partCol[i]), alphaP * 0.4);
      rectMode(CENTER);
      rect(0, 0, partTam[i] * 1.8 * tVida, partTam[i] * 1.8 * tVida, 3);
      fill(255, alphaP);
      rect(0, 0, partTam[i] * 0.8 * tVida, partTam[i] * 0.8 * tVida, 2);
    } else {
      if (partTipo[i] == 1) {
        fill(12, 22, 16, alphaP * 0.9);
        stroke(red(partCol[i]), green(partCol[i]), blue(partCol[i]), alphaP);
        strokeWeight(2);
        float s = partTam[i] * (0.4 + 0.6 * tVida);
        beginShape();
        vertex(-s * 0.6, -s * 0.4);
        vertex(s * 0.5, -s * 0.2);
        vertex(s * 0.3, s * 0.6);
        vertex(-s * 0.4, s * 0.3);
        endShape(CLOSE);
      } else {
        if (partTipo[i] == 2) {
          noStroke();
          fill(red(partCol[i]), green(partCol[i]), blue(partCol[i]), alphaP * 0.45);
          ellipse(0, 0, partTam[i] * 2.1, partTam[i] * 2.1);
          fill(255, 240, 150, alphaP);
          ellipse(0, 0, partTam[i], partTam[i]);
        }
      }
    }

    popMatrix();
  }
  popStyle();
}

float cartaActivaJuice = 0.0;
float cartaActivaJuiceRot = 0.0;

float[] slotPluginJuice = {0.0, 0.0, 0.0, 0.0, 0.0};
float[] slotPluginJuiceRot = {0.0, 0.0, 0.0, 0.0, 0.0};

float[] pulsoBarraStat = {0.0, 0.0, 0.0, 0.0};

float pulsoTokensUI = 0.0;
float pulsoComboUI = 0.0;
float pulsoBalanzaUI = 0.0;
float pulsoRestantesUI = 0.0;

float sacudidaCamaraFuerza = 0.0;
float sacudidaCamaraX = 0.0;
float sacudidaCamaraY = 0.0;

void juiceCartaActiva(float fuerza) {
  cartaActivaJuice = max(cartaActivaJuice, fuerza);
  cartaActivaJuiceRot = random(-0.12, 0.12);
}

void juiceSlotPlugin(int slot) {
  if (slot < 0 || slot >= 5) return;
  slotPluginJuice[slot] = 1.0;
  slotPluginJuiceRot[slot] = (frameCount % 2 == 0) ? 0.14 : -0.14;
}

void pulsarBarraStat(int idx) {
  if (idx < 0 || idx >= 4) return;
  pulsoBarraStat[idx] = 1.0;
}

void dispararSacudidaCamara(float fuerza) {
  sacudidaCamaraFuerza = max(sacudidaCamaraFuerza, fuerza);
}

void actualizarJuiceYCamara() {
  cartaActivaJuice = lerp(cartaActivaJuice, 0.0, 0.18);
  cartaActivaJuiceRot = lerp(cartaActivaJuiceRot, 0.0, 0.18);

  for (int i = 0; i < 5; i++) {
    slotPluginJuice[i] = lerp(slotPluginJuice[i], 0.0, 0.16);
    slotPluginJuiceRot[i] = lerp(slotPluginJuiceRot[i], 0.0, 0.16);
  }
  for (int i = 0; i < 4; i++) {
    pulsoBarraStat[i] = lerp(pulsoBarraStat[i], 0.0, 0.14);
  }

  pulsoTokensUI = lerp(pulsoTokensUI, 0.0, 0.15);
  pulsoComboUI = lerp(pulsoComboUI, 0.0, 0.15);
  pulsoBalanzaUI = lerp(pulsoBalanzaUI, 0.0, 0.16);
  pulsoRestantesUI = lerp(pulsoRestantesUI, 0.0, 0.16);

  if (sacudidaCamaraFuerza > 0.2) {
    sacudidaCamaraX = random(-sacudidaCamaraFuerza, sacudidaCamaraFuerza);
    sacudidaCamaraY = random(-sacudidaCamaraFuerza, sacudidaCamaraFuerza);
    sacudidaCamaraFuerza *= 0.84;
  } else {
    sacudidaCamaraFuerza = 0.0;
    sacudidaCamaraX = 0.0;
    sacudidaCamaraY = 0.0;
  }
}

final int LIGHTNING_FRAMES = 5;
final boolean LIGHTNING_HORIZONTAL = true;
final int LIGHTNING_FRAME_HOLD = 3;
final float BOLT_WIDTH_BASE = 120.0;
final int TOTAL_PALETAS_RAYO = 6;

PImage lightningSheet = null;
PImage[][] spritesRayoPaleta = new PImage[6][5];
boolean spritesRayoListos = false;
boolean spritesRayoIntentados = false;

PImage recortarFrameRayo(PImage img) {
  if (img == null || img.width <= 0 || img.height <= 0) return img;
  img.loadPixels();
  int minX = img.width, minY = img.height, maxX = -1, maxY = -1;
  for (int y = 0; y < img.height; y++) {
    for (int x = 0; x < img.width; x++) {
      if (alpha(img.pixels[y * img.width + x]) > 10) {
        if (x < minX) minX = x;
        if (x > maxX) maxX = x;
        if (y < minY) minY = y;
        if (y > maxY) maxY = y;
      }
    }
  }
  if (maxX < 0) return img;
  return img.get(minX, minY, maxX - minX + 1, maxY - minY + 1);
}

PImage colorearFrameRayo(PImage src, int cr, int cg, int cb) {
  if (src == null) return null;
  PImage dst = createImage(src.width, src.height, ARGB);
  src.loadPixels();
  dst.loadPixels();
  int totalPx = src.width * src.height;
  for (int i = 0; i < totalPx; i++) {
    int px = src.pixels[i];
    float a = alpha(px);
    if (a <= 1.0) {
      dst.pixels[i] = 0;
    } else {
      float lum = red(px) / 255.0;
      float nucleo = constrain(((a / 255.0) * lum - 0.66) / 0.32, 0.0, 1.0);
      int rr = int(lerp(cr * lum, 255, nucleo));
      int gg = int(lerp(cg * lum, 255, nucleo));
      int bb = int(lerp(cb * lum, 255, nucleo));
      dst.pixels[i] = color(constrain(rr, 0, 255), constrain(gg, 0, 255), constrain(bb, 0, 255), int(a));
    }
  }
  dst.updatePixels();
  return dst;
}

void precargarSpritesRayo() {
  if (spritesRayoIntentados) return;
  spritesRayoIntentados = true;

  lightningSheet = cargarImagenSegura("lightning.png");
  if (lightningSheet == null || lightningSheet.width <= 0 || lightningSheet.height <= 0) return;

  for (int i = 0; i < LIGHTNING_FRAMES; i++) {
    PImage raw;
    if (LIGHTNING_HORIZONTAL) {
      int fw = lightningSheet.width / LIGHTNING_FRAMES;
      raw = lightningSheet.get(i * fw, 0, fw, lightningSheet.height);
    } else {
      int fh = lightningSheet.height / LIGHTNING_FRAMES;
      raw = lightningSheet.get(0, i * fh, lightningSheet.width, fh);
    }
    PImage recortado = recortarFrameRayo(raw);
    spritesRayoPaleta[0][i] = recortado;
    spritesRayoPaleta[1][i] = colorearFrameRayo(recortado, 55, 255, 155);
    spritesRayoPaleta[2][i] = colorearFrameRayo(recortado, 255, 150, 55);
    spritesRayoPaleta[3][i] = colorearFrameRayo(recortado, 255, 220, 70);
    spritesRayoPaleta[4][i] = colorearFrameRayo(recortado, 60, 235, 255);
    spritesRayoPaleta[5][i] = colorearFrameRayo(recortado, 255, 90, 195);
  }
  spritesRayoListos = true;
}

void asegurarSpritesRayoCargados() {
  if (!spritesRayoIntentados) precargarSpritesRayo();
}

int elegirPaletaRayo(color c) {
  float r = red(c);
  float g = green(c);
  float b = blue(c);
  if (r > 230 && g > 230 && b > 230) return 0;
  if (r > 205 && g > 180 && b < 135) return 3;
  if (r > 180 && b > 140 && g < 150) return 5;
  if (b > r + 30 && b >= g - 35) return 4;
  if (r > g + 25) return 2;
  return 1;
}

void dibujarSpriteRayoEntrePuntos(float x1, float y1, float x2, float y2, int frameIdx, boolean flipX, float grosorPx, color colRayo, float alpha01) {
  asegurarSpritesRayoCargados();
  if (!spritesRayoListos) return;
  float a = constrain(alpha01, 0.0, 1.0);
  if (a <= 0.01) return;

  float dx = x2 - x1;
  float dy = y2 - y1;
  float distTotal = sqrt(dx * dx + dy * dy);
  if (distTotal < 8.0) return;

  int pal = elegirPaletaRayo(colRayo);
  int idx = constrain(frameIdx, 0, LIGHTNING_FRAMES - 1);
  PImage f = spritesRayoPaleta[pal][idx];
  if (f == null || f.height <= 0) return;

  float drawH = distTotal;
  float drawW = (grosorPx > 0) ? grosorPx : (f.width * (drawH / float(f.height)));
  float angulo = atan2(dy, dx) - HALF_PI;

  pushStyle();
  pushMatrix();
  imageMode(CORNER);
  translate(x1, y1);
  rotate(angulo);
  if (flipX) scale(-1, 1);

  int alphaInt = int(255.0 * a);
  if (alphaInt >= 244) {
    noTint();
  } else {
    int alphaQ = max(16, (alphaInt / 16) * 16);
    tint(255, alphaQ);
  }
  image(imgShaderDaltonismo(f), -drawW * 0.5, 0, drawW, drawH);
  noTint();
  popMatrix();
  popStyle();
}

float[] rFlOrigX = new float[64];
float[] rFlOrigY = new float[64];
float[] rFlDestX = new float[64];
float[] rFlDestY = new float[64];
int[] rFlAge = new int[64];
int[] rFlTotalFrames = new int[64];
boolean[] rFlFlip = new boolean[64];
float[] rFlAnchoBolt = new float[64];
color[] rFlCol = new color[64];
int[] rFlSemillaFlicker = new int[64];
int numRayosFlourish = 0;

void agregarRayoFlourish(float ox, float oy, float dx, float dy, color c, float ancho, int extraHold) {
  if (numRayosFlourish >= 64) return;
  int idx = numRayosFlourish;
  rFlOrigX[idx] = ox;
  rFlOrigY[idx] = oy;
  rFlDestX[idx] = dx;
  rFlDestY[idx] = dy;
  rFlAge[idx] = 0;
  rFlTotalFrames[idx] = LIGHTNING_FRAMES * LIGHTNING_FRAME_HOLD + max(0, extraHold);
  rFlFlip[idx] = random(1) < 0.5;
  rFlAnchoBolt[idx] = ancho;
  rFlCol[idx] = c;
  rFlSemillaFlicker[idx] = int(random(100));
  numRayosFlourish++;
}

void eliminarRayoFlourishEn(int idx) {
  if (idx < 0 || idx >= numRayosFlourish) return;
  for (int i = idx; i < numRayosFlourish - 1; i++) {
    rFlOrigX[i] = rFlOrigX[i + 1];
    rFlOrigY[i] = rFlOrigY[i + 1];
    rFlDestX[i] = rFlDestX[i + 1];
    rFlDestY[i] = rFlDestY[i + 1];
    rFlAge[i] = rFlAge[i + 1];
    rFlTotalFrames[i] = rFlTotalFrames[i + 1];
    rFlFlip[i] = rFlFlip[i + 1];
    rFlAnchoBolt[i] = rFlAnchoBolt[i + 1];
    rFlCol[i] = rFlCol[i + 1];
    rFlSemillaFlicker[i] = rFlSemillaFlicker[i + 1];
  }
  numRayosFlourish--;
}

boolean arcosMagneticosSwipeActivos = false;
boolean arcosMagneticosPrevios = false;
int ultimoTiempoRayoStrikeMs = -1000;
final int INTERVALO_MINIMO_RAYO_STRIKE_MS = 180;
int framesSinRayos = 999;

void reproducirActivacionRayo() {
  if (sonidoLightningStrike == null || sonidoLightningStrike.frames() <= 0) return;
  int ahora = millis();

  if (ahora - ultimoTiempoRayoStrikeMs < INTERVALO_MINIMO_RAYO_STRIKE_MS) return;

  if (sonidoLightningStrike.isPlaying() && (ahora - ultimoTiempoRayoStrikeMs < 240)) return;

  float vol = constrain(volumenFinalSFX() * 0.70, 0.0, 1.0);
  if (vol <= 0.001) return;

  ultimoTiempoRayoStrikeMs = ahora;
  if (sonidoLightningStrike.isPlaying()) {
    sonidoLightningStrike.stop();
  }
  sonidoLightningStrike.play(random(0.96, 1.05), vol);
}

boolean hayRayoActivo() {
  if (numRayosFlourish > 0) return true;
  if (numRayosRielSwipe > 0) return true;
  if (arcosMagneticosSwipeActivos) return true;
  return false;
}

void actualizarAudioRayoContinuo() {
  if (sonidoLightningLoop == null || sonidoLightningLoop.frames() <= 0) return;

  if (pausaActiva()) {
    if (sonidoLightningLoop.isPlaying()) {
      sonidoLightningLoop.stop();
    }
    framesSinRayos = 999;
    return;
  }

  boolean hayRayos = hayRayoActivo();
  if (hayRayos) {
    framesSinRayos = 0;
  } else {
    framesSinRayos++;
  }

  boolean mantenerLoop = (framesSinRayos <= 8);

  if (mantenerLoop) {
    float vol = constrain(volumenFinalSFX() * 0.38, 0.0, 1.0);
    if (vol > 0.001) {
      sonidoLightningLoop.amp(vol);
      if (!sonidoLightningLoop.isPlaying()) {
        sonidoLightningLoop.loop();
      }
    } else {
      if (sonidoLightningLoop.isPlaying()) {
        sonidoLightningLoop.stop();
      }
    }
  } else {
    if (sonidoLightningLoop.isPlaying()) {
      sonidoLightningLoop.stop();
    }
  }

  arcosMagneticosPrevios = arcosMagneticosSwipeActivos;
  arcosMagneticosSwipeActivos = false;
}

void dispararRayoEntrePuntos(float origX, float origY, float destX, float destY, color c, float ancho, int extraHold) {
  if (numRayosFlourish > 32) return;
  agregarRayoFlourish(origX, origY, destX, destY, c, ancho, extraHold);
  reproducirActivacionRayo();
}

void dispararMarcoRayosRect(float cx, float cy, float w, float h, color c, float anchoBolt, int extraHold) {
  if (numRayosFlourish > 28) return;

  float hw = w * 0.5 + 4;
  float hh = h * 0.5 + 4;

  float x1 = cx - hw;
  float y1 = cy - hh;
  float x2 = cx + hw;
  float y2 = cy + hh;

  agregarRayoFlourish(x1 - 4, y1, x2 + 4, y1, c, anchoBolt, extraHold);
  agregarRayoFlourish(x2, y1 - 4, x2, y2 + 4, c, anchoBolt, extraHold);
  agregarRayoFlourish(x2 + 4, y2, x1 - 4, y2, c, anchoBolt, extraHold);
  agregarRayoFlourish(x1, y2 + 4, x1, y1 - 4, c, anchoBolt, extraHold);

  reproducirActivacionRayo();
}

void dispararMarcoRayosPlugin(int slotIndex, color colRayo) {
  if (slotIndex < 0 || slotIndex >= 5) return;

  color cFinal = (colRayo != 0) ? colRayo : colorTema();

  if (plugBaseX != null && slotIndex < 5 && plugBaseX[slotIndex] > 0) {
    float cx = plugBaseX[slotIndex];
    float cy = plugBaseY[slotIndex];
    float w = anchoRectPlugin * escalaSlot;
    float h = altoRectPlugin * escalaSlot;

    if (plugEstado != null && slotIndex < 5 && plugEstado[slotIndex] == 2) {
      cx = width / 2.0 - 250;
      cy = height / 2.0;
      w = anchoRectPlugin * 2.3;
      h = altoRectPlugin * 2.3;
    }

    dispararMarcoRayosRect(cx, cy, w, h, cFinal, 48.0, 5);
  }

  if (leftPanelSlotY != null && slotIndex < 5 && leftPanelSlotY[slotIndex] > 0) {
    float pIzqX = width * 0.02;
    float pIzqW = width * 0.26;
    float slotW = pIzqW - 40;
    float slotH = 28;
    float slotCX = pIzqX + 20 + slotW * 0.5;
    float slotCY = leftPanelSlotY[slotIndex] + slotH * 0.5;

    dispararMarcoRayosRect(slotCX, slotCY, slotW, slotH, cFinal, 22.0, 5);
  }
}

void dispararMarcoRayosPlugin(int slotIndex) {
  dispararMarcoRayosPlugin(slotIndex, colorTema());
}

void dispararRayoFlourish(float destX, float destY, color c, int tipo) {
  if (numRayosFlourish > 16) return;
  float targetY = max(destY, 24);
  float origX = constrain(destX + random(-95, 95), 40, width - 40);
  float anchoPrincipal = (tipo == 1) ? (BOLT_WIDTH_BASE * 1.18) : BOLT_WIDTH_BASE;
  agregarRayoFlourish(origX, -8, destX, targetY, c, anchoPrincipal, 6);

  if (tipo == 1) {
    float origLatX = (destX > width * 0.5) ? (width + 8) : -8;
    float origLatY = constrain(targetY + random(-210, 170), 30, height - 30);
    agregarRayoFlourish(origLatX, origLatY, destX, targetY, c, BOLT_WIDTH_BASE * 0.78, 4);
  }
  reproducirActivacionRayo();
}

void actualizarYDibujarFlourishLayer() {
  if (numRayosFlourish == 0) return;

  for (int r = numRayosFlourish - 1; r >= 0; r--) {
    int idx = rFlAge[r] / LIGHTNING_FRAME_HOLD;
    if (idx >= LIGHTNING_FRAMES) {
      idx = (rFlSemillaFlicker[r] + rFlAge[r]) % LIGHTNING_FRAMES;
    }

    float alpha01 = 1.0;
    int fadeStart = rFlTotalFrames[r] - 5;
    if (rFlAge[r] > fadeStart) {
      alpha01 = map(rFlAge[r], fadeStart, rFlTotalFrames[r], 1.0, 0.0);
    }

    dibujarSpriteRayoEntrePuntos(
      rFlOrigX[r], rFlOrigY[r], rFlDestX[r], rFlDestY[r],
      idx, rFlFlip[r], rFlAnchoBolt[r], rFlCol[r], alpha01
    );

    rFlAge[r]++;
    if (rFlAge[r] >= rFlTotalFrames[r]) {
      eliminarRayoFlourishEn(r);
    }
  }
}

void dibujarSinergiasVisualesRack(boolean[] slotOculto, float[] offsetYSlot, float cardW, float cardH) {
  if (numSinergiasActivas == 0) return;
  if (plugBaseX == null || plugBaseY == null || slotsPluginEquipado == null) return;

  int totalSlots = min(limiteMaxSlotsRack(), 5);
  if (totalSlots <= 1) return;

  color colOro = color(255, 220, 70);
  int pasoAnim = frameCount / 3;

  pushStyle();

  for (int i = 0; i < totalSlots; i++) {
    if (slotsPluginEquipado[i] < 0) continue;
    if (slotOculto != null && slotOculto[i]) continue;
    if (!slotPerteneceASinergiaActiva(i)) continue;

    float offY = (offsetYSlot != null) ? offsetYSlot[i] : 0.0;
    float cx = plugBaseX[i];
    float cy = plugBaseY[i] + offY;

    float hw = cardW * 0.5 + 3.0;
    float hh = cardH * 0.5 + 3.0;
    float x1 = cx - hw;
    float x2 = cx + hw;
    float y1 = max(5.0, cy - hh);
    float y2 = cy + hh;

    int bf = (pasoAnim + i * 2) % LIGHTNING_FRAMES;
    boolean flipBase = ((i + pasoAnim) % 2 == 0);

    dibujarSpriteRayoEntrePuntos(x1 - 3, y1, x2 + 3, y1, (bf + 0) % LIGHTNING_FRAMES, flipBase, 15.0, colOro, 0.88);
    dibujarSpriteRayoEntrePuntos(x2, y1 - 3, x2, y2 + 3, (bf + 1) % LIGHTNING_FRAMES, !flipBase, 15.0, colOro, 0.88);
    dibujarSpriteRayoEntrePuntos(x2 + 3, y2, x1 - 3, y2, (bf + 2) % LIGHTNING_FRAMES, flipBase, 15.0, colOro, 0.88);
    dibujarSpriteRayoEntrePuntos(x1, y2 + 3, x1, y1 - 3, (bf + 3) % LIGHTNING_FRAMES, !flipBase, 15.0, colOro, 0.88);
  }

  int idxSinergia = 0;
  for (int sIdx = 0; sIdx < numSinergiasActivas; sIdx++) {
    int s = sinergiasActivas[sIdx];
    if (synCatPluginsReq[s] == null) continue;

    int[] slotsSinergia = new int[5];
    int numSlotsSinergia = 0;
    int numReqs = contarEnteros(synCatPluginsReq[s]);
    for (int i = 0; i < totalSlots; i++) {
      int catIdx = slotsPluginEquipado[i];
      if (catIdx < 0) continue;
      if (slotOculto != null && slotOculto[i]) continue;
      for (int r = 0; r < numReqs; r++) {
        int req = synCatPluginsReq[s][r];
        if (catIdx == req) {
          if (numSlotsSinergia < 5) {
            slotsSinergia[numSlotsSinergia++] = i;
          }
          break;
        }
      }
    }

    for (int k = 0; k < numSlotsSinergia - 1; k++) {
      int slotA = slotsSinergia[k];
      int slotB = slotsSinergia[k + 1];

      float offYA = (offsetYSlot != null) ? offsetYSlot[slotA] : 0.0;
      float offYB = (offsetYSlot != null) ? offsetYSlot[slotB] : 0.0;

      float xA = plugBaseX[slotA];
      float yA = plugBaseY[slotA] + offYA;
      float xB = plugBaseX[slotB];
      float yB = plugBaseY[slotB] + offYB;

      float minTop = min(yA, yB) - cardH * 0.5;
      float yArch = max(5.0, minTop - 6.0) + min(idxSinergia * 3.0, 6.0);
      float yLegA = max(yArch + 26.0, yA - cardH * 0.34);
      float yLegB = max(yArch + 26.0, yB - cardH * 0.34);

      int fArc = (pasoAnim + idxSinergia + k) % LIGHTNING_FRAMES;
      boolean flipArc = ((pasoAnim + k) % 2 == 0);

      dibujarSpriteRayoEntrePuntos(xA, yLegA, xA, yArch, (fArc + 0) % LIGHTNING_FRAMES, flipArc, 18.0, colOro, 0.94);

      dibujarSpriteRayoEntrePuntos(xA, yArch, xB, yArch, (fArc + 1) % LIGHTNING_FRAMES, !flipArc, 20.0, colOro, 0.96);

      dibujarSpriteRayoEntrePuntos(xB, yArch, xB, yLegB, (fArc + 2) % LIGHTNING_FRAMES, flipArc, 18.0, colOro, 0.94);

      noStroke();
      fill(255, 240, 145, 210);
      ellipse(xA, yLegA, 8, 8);
      ellipse(xB, yLegB, 8, 8);
      ellipse(xA, yArch, 6, 6);
      ellipse(xB, yArch, 6, 6);
    }
    idxSinergia++;
  }

  popStyle();
}

void dibujarTextoSinergiaBanner(String txt, float x, float y, float maxW, float tamIni, float alpha01, int alignY) {
  if (txt == null || txt.length() == 0) return;
  float tam = tamIni;
  textSize(tam);
  while (textWidth(txt) > maxW && tam > 8.0) {
    tam -= 0.5;
    textSize(tam);
  }
  fill(255, 220, 80, constrain(alpha01, 0, 255));
  textAlign(LEFT, alignY);
  text(txt, x, y);
}

void dibujarLineasVelocidad() {
  if (comboActual < 10 && jefeActivo != 1) return;

  pushStyle();
  float intensidad = constrain(map(comboActual, 10, 18, 0.45, 0.90), 0.45, 0.90);
  if (jefeActivo == 1) intensidad = max(intensidad, 0.65);

  color colL = colorTema();
  float cx = width * 0.5;
  float cy = height * 0.5;
  float radioMax = max(width, height) * 0.75;
  float radioMin = min(width, height) * 0.44;

  int totalLineas = 28;
  for (int i = 0; i < totalLineas; i++) {
    float semilla = i * 19.7 + (frameCount / 3) * 4.3;
    float ang = noise(semilla * 0.13) * TWO_PI * 2.0;
    float rIn = radioMin + noise(semilla * 0.29) * 90.0;
    float rOut = radioMax;

    float x1 = cx + cos(ang) * rIn;
    float y1 = cy + sin(ang) * rIn;
    float x2 = cx + cos(ang) * rOut;
    float y2 = cy + sin(ang) * rOut;

    stroke(red(colL), green(colL), blue(colL), 85 * intensidad);
    strokeWeight(1.1 + (i % 2) * 0.6);
    line(x1, y1, x2, y2);
  }
  popStyle();
}

void triggerGlitchProfesional() {
  glitchIntensity = 1.0;
}

PImage cacheScanlinesCRT = null;
int cacheScanW = 0;
int cacheScanH = 0;

void asegurarScanlinesCRT() {
  int hNecesario = height + 4;
  if (cacheScanlinesCRT != null && cacheScanW == width && cacheScanH == hNecesario) return;
  cacheScanW = width;
  cacheScanH = hNecesario;
  cacheScanlinesCRT = createImage(cacheScanW, cacheScanH, ARGB);
  cacheScanlinesCRT.loadPixels();
  int colOscuro = color(0, 16);
  int colTransp = color(0, 0);
  for (int y = 0; y < cacheScanH; y++) {
    int cFila = ((y % 4) < 2) ? colOscuro : colTransp;
    int offsetFila = y * cacheScanW;
    for (int x = 0; x < cacheScanW; x++) {
      cacheScanlinesCRT.pixels[offsetFila + x] = cFila;
    }
  }
  cacheScanlinesCRT.updatePixels();
}

void dibujarPostProcesadoProfesional() {
  pushStyle();

  if (glitchIntensity > 0.05) {
    fill(255, random(10, 30) * glitchIntensity);
    noStroke();
    rect(0, random(height), width, random(10, 50));

    fill(255, 0, 0, 40 * glitchIntensity);
    rect(random(-10, 10), 0, width, height);
    fill(0, 0, 255, 40 * glitchIntensity);
    rect(random(-10, 10), 0, width, height);

    glitchIntensity *= 0.7;
  }

  if (ultimoEstadoPantallaProf != estadoPantalla) {
    boolean transicionFluidaDolus =
      (ultimoEstadoPantallaProf == PANTALLA_JUEGO && estadoPantalla == PANTALLA_TIENDA) ||
      (ultimoEstadoPantallaProf == PANTALLA_TIENDA && estadoPantalla == PANTALLA_JUEGO);

    if (!transicionFluidaDolus) {
      flashTransicionProf = 255.0;
    } else {
      flashTransicionProf = 0.0;
    }
    ultimoEstadoPantallaProf = estadoPantalla;
  }

  if (estadoPantalla == PANTALLA_JUEGO || estadoPantalla == PANTALLA_TIENDA) {
    if (animandoTransicionTienda || animandoSalidaLiquidacion) {
      flashTransicionProf = 0.0;
    }
  }

  if (flashTransicionProf > 0.5) {
    fill(0, flashTransicionProf);
    noStroke();
    rectMode(CORNER);
    rect(0, 0, width, height);
    flashTransicionProf = lerp(flashTransicionProf, 0, 0.15);
  }

  if (efectosCRTActivos) {
    asegurarScanlinesCRT();
    imageMode(CORNER);
    noTint();
    image(cacheScanlinesCRT, 0, -(frameCount % 4));
  }

  popStyle();
}
