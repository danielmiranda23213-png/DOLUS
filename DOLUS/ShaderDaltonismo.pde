
int modoShaderDaltonismoCacheado = 0;
PImage[] cacheShaderSrc = new PImage[256];
PImage[] cacheShaderDst = new PImage[256];
int numCacheShader = 0;

PImage[] cacheShaderCursorSrc = new PImage[64];
PImage[] cacheShaderCursorDst = new PImage[64];
int numCacheShaderCursor = 0;

void limpiarCacheShaderDaltonismo() {
  for (int i = 0; i < numCacheShader; i++) {
    cacheShaderSrc[i] = null;
    cacheShaderDst[i] = null;
  }
  numCacheShader = 0;
  for (int i = 0; i < numCacheShaderCursor; i++) {
    cacheShaderCursorSrc[i] = null;
    cacheShaderCursorDst[i] = null;
  }
  numCacheShaderCursor = 0;
  modoShaderDaltonismoCacheado = modoDaltonismo;
}

float dolusShaderHue(float s, float t, float h) {
  float hm = h - floor(h);
  float hs = hm * 6.0;
  if (hs < 1.0) return (t - s) * hs + s;
  if (hs < 3.0) return t;
  if (hs < 4.0) return (t - s) * (4.0 - hs) + s;
  return s;
}

void dolusHSLtoRGB(float h, float s, float l, float[] outRGB) {
  if (s <= 0.0001) {
    outRGB[0] = l;
    outRGB[1] = l;
    outRGB[2] = l;
    return;
  }
  float t = (l < 0.5) ? (s * l + l) : (-s * l + (s + l));
  float sv = 2.0 * l - t;
  outRGB[0] = constrain(dolusShaderHue(sv, t, h + 1.0 / 3.0), 0.0, 1.0);
  outRGB[1] = constrain(dolusShaderHue(sv, t, h), 0.0, 1.0);
  outRGB[2] = constrain(dolusShaderHue(sv, t, h - 1.0 / 3.0), 0.0, 1.0);
}

int evaluarPixelShaderDaltonismo(int argb, int modo, boolean teniarBlancos, float[] tmpNeutro, float[] tmpChroma) {
  if (modo == 0) return argb;
  int a = (argb >>> 24) & 0xFF;
  if (a == 0) return argb;

  float r = ((argb >>> 16) & 0xFF) / 255.0;
  float g = ((argb >>> 8) & 0xFF) / 255.0;
  float b = (argb & 0xFF) / 255.0;

  float low = min(r, min(g, b));
  float high = max(r, max(g, b));
  float delta = high - low;
  float sum = high + low;
  float l = 0.5 * sum;

  if (high < 0.04 || (l < 0.085 && delta < 0.035)) {
    return argb;
  }

  if (low > 0.88 && delta < 0.12) {
    if (!teniarBlancos) return argb;
    float tr = 1.0, tg = 0.91, tb = 0.56;
    if (modo == 2) {
      tr = 1.0; tg = 0.96; tb = 0.48;
    } else {
      if (modo == 3) {
        tr = 0.92; tg = 0.76; tb = 1.0;
      }
    }
    float wr = lerp(r, tr, 0.78);
    float wg = lerp(g, tg, 0.78);
    float wb = lerp(b, tb, 0.78);
    int orI = constrain(round(wr * 255.0), 0, 255);
    int ogI = constrain(round(wg * 255.0), 0, 255);
    int obI = constrain(round(wb * 255.0), 0, 255);
    return (a << 24) | (orI << 16) | (ogI << 8) | obI;
  }

  float s = 0.0;
  float h = 0.0;
  if (delta > 0.0001) {
    s = (l < 0.5) ? (delta / max(0.0001, sum)) : (delta / max(0.0001, 2.0 - sum));
    if (high == r) h = (g - b) / delta;
    else {
      if (high == g) h = (b - r) / delta + 2.0;
      else h = (r - g) / delta + 4.0;
    }
    h = h / 6.0;
    h = h - floor(h);
  }

  float washH = 0.128;
  if (modo == 2) washH = 0.146;
  else {
    if (modo == 3) washH = 0.785;
  }

  float washS = 0.26 * (4.0 * l * (1.0 - l));
  dolusHSLtoRGB(washH, washS, l, tmpNeutro);

  if (delta <= 0.085) {
    int orI = constrain(round(tmpNeutro[0] * 255.0), 0, 255);
    int ogI = constrain(round(tmpNeutro[1] * 255.0), 0, 255);
    int obI = constrain(round(tmpNeutro[2] * 255.0), 0, 255);
    return (a << 24) | (orI << 16) | (ogI << 8) | obI;
  }

  float targetH = h;
  float targetS = s;
  float targetL = l;

  if (modo == 1) {

    if (h >= 0.18 && h < 0.48) {

      targetH = 0.128 + (h - 0.36) * 0.12;
      targetS = constrain(s * 0.96, 0.55, 0.94);
      targetL = (l < 0.20) ? l : constrain(l * 1.05, 0.0, 0.88);
    } else {
      if (h >= 0.08 && h < 0.18) {

        targetH = 0.535;
        targetS = constrain(s * 0.72, 0.35, 0.75);
        targetL = constrain(max(l, 0.58) * 1.08, 0.0, 0.90);
      } else {
        if (h < 0.08 || h >= 0.78) {

          targetH = 0.578;
          targetS = constrain(max(s, 0.78), 0.0, 0.96);
          targetL = (l < 0.18) ? l : constrain(l * 1.12, 0.22, 0.88);
        } else {
          if (h >= 0.48 && h < 0.56) {

            targetH = 0.565;
            targetS = s * 0.95;
          } else {

            if (l >= 0.74) {
              targetH = 0.570;
              targetS = s * 0.55;
            } else {
              targetH = 0.128;
              targetS = 0.90;
              targetL = max(l, 0.56);
            }
          }
        }
      }
    }
  } else {
    if (modo == 2) {

      if (h >= 0.18 && h < 0.48) {

        targetH = 0.146 + (h - 0.36) * 0.10;
        targetS = constrain(s * 0.98, 0.65, 0.96);
        targetL = (l < 0.20) ? l : constrain(l * 1.10, 0.0, 0.90);
      } else {
        if (h >= 0.08 && h < 0.18) {

          targetH = 0.530;
          targetS = constrain(s * 0.75, 0.38, 0.78);
          targetL = constrain(max(l, 0.58) * 1.08, 0.0, 0.90);
        } else {
          if (h < 0.08 || h >= 0.78) {

            targetH = 0.585;
            targetS = constrain(max(s, 0.80), 0.0, 0.96);
            targetL = (l < 0.18) ? l : constrain(l * 1.12, 0.22, 0.88);
          } else {
            if (h >= 0.48 && h < 0.56) {

              targetH = 0.575;
              targetS = s * 0.95;
            } else {
              if (l >= 0.74) {
                targetH = 0.575;
                targetS = s * 0.55;
              } else {
                targetH = 0.146;
                targetS = 0.92;
                targetL = max(l, 0.58);
              }
            }
          }
        }
      }
    } else {

      if (h >= 0.18 && h < 0.48) {

        targetH = 0.785 + (h - 0.36) * 0.10;
        targetS = constrain(s * 0.92, 0.55, 0.92);
        targetL = (l < 0.20) ? l : constrain(l * 1.12, 0.0, 0.88);
      } else {
        if (h >= 0.08 && h < 0.18) {

          targetH = 0.470;
          targetS = constrain(s * 0.90, 0.55, 0.92);
          targetL = constrain(l * 1.06, 0.0, 0.86);
        } else {
          if (h < 0.08 || h >= 0.78) {

            targetH = 0.930;
            targetS = constrain(max(s, 0.80), 0.0, 0.96);
            targetL = (l < 0.18) ? l : constrain(l * 1.10, 0.22, 0.88);
          } else {
            if (h >= 0.48 && h < 0.56) {

              targetH = 0.465;
              targetS = s * 0.95;
            } else {
              if (l >= 0.74) {
                targetH = 0.790;
                targetS = s * 0.45;
              } else {
                targetH = 0.475;
                targetS = 0.86;
                targetL = max(l, 0.52);
              }
            }
          }
        }
      }
    }
  }

  dolusHSLtoRGB(targetH, targetS, targetL, tmpChroma);

  float chromaBlend = constrain((delta - 0.085) / 0.12, 0.0, 1.0);
  float outR = lerp(tmpNeutro[0], tmpChroma[0], chromaBlend);
  float outG = lerp(tmpNeutro[1], tmpChroma[1], chromaBlend);
  float outB = lerp(tmpNeutro[2], tmpChroma[2], chromaBlend);

  int orI = constrain(round(outR * 255.0), 0, 255);
  int ogI = constrain(round(outG * 255.0), 0, 255);
  int obI = constrain(round(outB * 255.0), 0, 255);
  return (a << 24) | (orI << 16) | (ogI << 8) | obI;
}

PImage aplicarShaderDaltonismoPImage(PImage src, int modo, boolean teniarBlancos) {
  if (src == null || src.width <= 0 || src.height <= 0 || modo == 0) return src;
  src.loadPixels();
  if (src.pixels == null) return src;

  int w = src.width;
  int h = src.height;
  PImage dst = createImage(w, h, ARGB);
  dst.loadPixels();

  float[] tmpNeutro = new float[3];
  float[] tmpChroma = new float[3];
  int total = w * h;
  boolean forzarOpaco = (src.format == RGB);

  for (int i = 0; i < total; i++) {
    int px = src.pixels[i];
    if (forzarOpaco) px = px | 0xFF000000;
    dst.pixels[i] = evaluarPixelShaderDaltonismo(px, modo, teniarBlancos, tmpNeutro, tmpChroma);
  }
  dst.updatePixels();
  return dst;
}

PImage imgShaderDaltonismo(PImage src) {
  if (src == null || modoDaltonismo == 0) return src;
  if (modoShaderDaltonismoCacheado != modoDaltonismo) {
    limpiarCacheShaderDaltonismo();
  }
  for (int i = 0; i < numCacheShader; i++) {
    if (cacheShaderSrc[i] == src) return cacheShaderDst[i];
  }

  PImage shaded = aplicarShaderDaltonismoPImage(src, modoDaltonismo, false);
  if (shaded != null) {
    if (numCacheShader < 256) {
      cacheShaderSrc[numCacheShader] = src;
      cacheShaderDst[numCacheShader] = shaded;
      numCacheShader++;
    }
    return shaded;
  }
  return src;
}

PImage imgCursorShaderDaltonismo(PImage src) {
  if (src == null || modoDaltonismo == 0) return src;
  if (modoShaderDaltonismoCacheado != modoDaltonismo) {
    limpiarCacheShaderDaltonismo();
  }
  for (int i = 0; i < numCacheShaderCursor; i++) {
    if (cacheShaderCursorSrc[i] == src) return cacheShaderCursorDst[i];
  }

  PImage shaded = aplicarShaderDaltonismoPImage(src, modoDaltonismo, true);
  if (shaded != null) {
    if (numCacheShaderCursor < 64) {
      cacheShaderCursorSrc[numCacheShaderCursor] = src;
      cacheShaderCursorDst[numCacheShaderCursor] = shaded;
      numCacheShaderCursor++;
    }
    return shaded;
  }
  return src;
}

color colorShaderDaltonismo(color c) {
  if (modoDaltonismo == 0) return c;
  float[] tmpN = new float[3];
  float[] tmpC = new float[3];
  return evaluarPixelShaderDaltonismo(c, modoDaltonismo, false, tmpN, tmpC);
}
