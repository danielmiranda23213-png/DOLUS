
final int TIENDA_ESTADO_NORMAL        = 0;
final int TIENDA_ESTADO_BOOSTER_ANIM  = 1;
final int TIENDA_ESTADO_BOOSTER       = 2;
int estadoTienda = TIENDA_ESTADO_NORMAL;

final color DOLUS_RED          = #c83737;
final color DOLUS_GREEN        = #429e5a;
final color DOLUS_BLUE         = #008eb0;
final color DOLUS_GOLD         = #e8b137;
final color DOLUS_ORANGE       = #d66c2a;
final color DOLUS_PURPLE       = #8352a8;

int ultimaRondaTienda = -1;
int costoRerollTienda = 12;

String[] packNombre = {"PACK BASICO I", "PACK BASICO II", "GIGA PACK CLASIFICADO", "TERA PACK CUANTICO"};
String[] packSubtitulo = {"3 PROTOCOLOS // ELIGE 1", "3 PROTOCOLOS // ELIGE 1", "5 PROTOCOLOS // ELIGE 1", "5 PROTOCOLOS // ELIGE 2"};
String[] packDescripcion = {
  "Abre el sobre y elige 1 de 3 protocolos clasificados para tu equipo.",
  "Abre el sobre y elige 1 de 3 protocolos clasificados para tu equipo.",
  "Inyeccion de alta densidad. Elige 1 de 5 protocolos clasificados.",
  "Matriz cuantica definitiva. Elige 2 de 5 protocolos clasificados para tu equipo."
};
int[] packNumOpciones = {3, 3, 5, 5};
int[] packNumElecciones = {1, 1, 1, 2};
int[] packPrecio = {22, 32, 48, 75};
int[] packFrameIndex = {0, 1, 2, 3};

int tipoPackTiendaActual = 0;
int boosterEleccionesRestantes = 1;
boolean[] boosterOpcionTomada = new boolean[5];

PImage sheetPacks = null;
PImage[] imgPacks = new PImage[4];
boolean packsCargados = false;

boolean boosterPackComprado = false;
int precioBoosterPack = 6;
int[] opcionesBooster = new int[16];
int numOpcionesBooster = 0;

boolean exploitComprado = false;
int precioExploit = 3;

int pluginHoverInspector = -1;
String tipoHoverInspector = "";

SoundFile sonidoShopBuy = null;
SoundFile sndExplosionBuildup = null;
SoundFile sndExplosionRelease = null;
SoundFile sndCardFan = null;

int slotSeleccionadoVenta = -1;

final int JUICE_CARDS_BASE = 0;
final int JUICE_SLOTS_BASE = 3;
final int JUICE_BTN_CONTINUAR = 8;
final int JUICE_BTN_REROLL = 9;
final int JUICE_BOOSTER_CARD = 10;
final int JUICE_EXPLOIT_CARD = 11;
final int JUICE_BOOSTER_OPTS_BASE = 12;
final int JUICE_PACKS_BASE = 17;

float[] juiceTScale = new float[20];
float[] juiceTScaleAmt = new float[20];
float[] juiceTRot = new float[20];
float[] juiceTRAmt = new float[20];
float[] juiceTStartTime = new float[20];
float[] juiceTDuration = new float[20];
boolean juiceTiendaInicializado = false;

void inicializarJuiceTienda() {
  for (int i = 0; i < 20; i++) {
    juiceTScale[i] = 0;
    juiceTScaleAmt[i] = 0.35;
    juiceTRot[i] = 0;
    juiceTRAmt[i] = 0.15;
    juiceTStartTime[i] = -999;
    juiceTDuration[i] = 0.28;
  }
  juiceTiendaInicializado = true;
}

void dispararJuiceTienda(int jIdx, float sAmt, float rotAmt) {
  if (!juiceTiendaInicializado) inicializarJuiceTienda();
  if (jIdx < 0 || jIdx >= 20) return;
  juiceTScaleAmt[jIdx] = sAmt;
  juiceTRAmt[jIdx] = rotAmt;
  juiceTStartTime[jIdx] = millis() / 1000.0;
}

void actualizarJuiceTienda(int jIdx, float now) {
  if (!juiceTiendaInicializado) inicializarJuiceTienda();
  if (jIdx < 0 || jIdx >= 20) return;
  float elapsed = now - juiceTStartTime[jIdx];
  if (elapsed < 0 || elapsed > juiceTDuration[jIdx]) {
    juiceTScale[jIdx] = 0;
    juiceTRot[jIdx] = 0;
    return;
  }
  float progress = elapsed / juiceTDuration[jIdx];
  float decay = max(0, 1.0 - progress);
  juiceTScale[jIdx] = juiceTScaleAmt[jIdx] * sin(62.8 * elapsed) * (decay * decay * decay);
  juiceTRot[jIdx] = juiceTRAmt[jIdx] * sin(48.8 * elapsed) * (decay * decay);
}

boolean vueloTiendaActivo = false;
int vueloTiendaIdPlugin = -1;
int vueloTiendaShopSlotIdx = -1;
int vueloTiendaTargetSlotIdx = -1;
float vueloTiendaStartX, vueloTiendaStartY;
float vueloTiendaEndX, vueloTiendaEndY;
float vueloTiendaStartTime = 0;
float vueloTiendaDuration = 0.32;
float vueloTiendaRotInit = 0;
PImage vueloTiendaSprite = null;

void iniciarVueloTienda(int idPlug, int shopIdx, int targetIdx, float sx, float sy, float ex, float ey) {
  vueloTiendaIdPlugin = idPlug;
  vueloTiendaShopSlotIdx = shopIdx;
  vueloTiendaTargetSlotIdx = targetIdx;
  vueloTiendaStartX = sx;
  vueloTiendaStartY = sy;
  vueloTiendaEndX = ex;
  vueloTiendaEndY = ey;
  vueloTiendaStartTime = millis() / 1000.0;
  vueloTiendaRotInit = random(-0.35, 0.35);
  vueloTiendaActivo = true;
  vueloTiendaSprite = null;
  if (idPlug >= 0 && idPlug < numCatalogoPlugins) {
    vueloTiendaSprite = plugCatImgTienda[idPlug];
    if (vueloTiendaSprite == null) vueloTiendaSprite = plugCatImgSlot[idPlug];
    if (vueloTiendaSprite == null) vueloTiendaSprite = plugCatImgBase[idPlug];
  }
}

void actualizarYDibujarVueloTienda(float now) {
  if (!vueloTiendaActivo) return;
  float elapsed = now - vueloTiendaStartTime;
  float t = constrain(elapsed / vueloTiendaDuration, 0.0, 1.0);

  if (t >= 1.0) {
    vueloTiendaActivo = false;
    if (vueloTiendaTargetSlotIdx >= 0 && vueloTiendaTargetSlotIdx < 4) {
      dispararJuiceTienda(JUICE_SLOTS_BASE + vueloTiendaTargetSlotIdx, 0.48, 0.18);
    }
    if (sndAterrizajePlugin != null) {
      reproducirSFX(sndAterrizajePlugin);
    }
    dispararExplosionCarta(vueloTiendaEndX, vueloTiendaEndY, colorTema(), false);
    dispararSacudidaCamara(2.8);
    return;
  }

  float easeT = 1.0 - pow(1.0 - t, 3.0);
  float curX = lerp(vueloTiendaStartX, vueloTiendaEndX, easeT);

  float arcH = -sin(t * PI) * 85.0;
  float curY = lerp(vueloTiendaStartY, vueloTiendaEndY, easeT) + arcH;

  float targetScale = (anchoRectPlugin * escalaSlot) / float(max(1, (vueloTiendaSprite != null ? vueloTiendaSprite.width : 160)));
  float curScale = lerp(1.0, targetScale, easeT);

  float curRot = vueloTiendaRotInit * (1.0 - easeT) + sin(t * TWO_PI) * 0.18;

  pushMatrix();
  translate(curX, curY);
  rotate(curRot);
  scale(curScale);

  float sombraOffset = map(-arcH, 0, 85, 8, 28);
  float sombraAlpha = map(-arcH, 0, 85, 140, 50);
  noStroke();
  fill(0, sombraAlpha);
  rectMode(CENTER);
  if (vueloTiendaSprite != null) {
    rect(6, sombraOffset, vueloTiendaSprite.width, vueloTiendaSprite.height, 8);
    imageMode(CENTER);
    tint(255, 255);
    image(imgShaderDaltonismo(vueloTiendaSprite), 0, 0);
    noTint();

    stroke(255, 215, 80, 220 * (1.0 - t * 0.5));
    strokeWeight(2.5);
    noFill();
    rect(0, 0, vueloTiendaSprite.width, vueloTiendaSprite.height, 8);
  }
  popMatrix();

  if (frameCount % 3 == 0) {
    color colChispa = (t < 0.5) ? color(255, 215, 80) : colorTema();
    agregarParticulaJuego(curX + random(-8, 8), curY + random(-8, 8),
                          random(-1.4, 1.4), random(-0.8, 1.6),
                          random(3.0, 5.0), colChispa, 0, 0, 0);
  }
}

float[] bBurnX = new float[128];
float[] bBurnY = new float[128];
float[] bBurnVX = new float[128];
float[] bBurnVY = new float[128];
float[] bBurnLife = new float[128];
float[] bBurnDecay = new float[128];
float[] bBurnSize = new float[128];
color[] bBurnCol = new color[128];
int numBBurnParticles = 0;

void agregarBoosterBurnParticle(float x, float y, float vx, float vy, float size, color col) {
  if (numBBurnParticles >= 128) return;
  bBurnX[numBBurnParticles] = x;
  bBurnY[numBBurnParticles] = y;
  bBurnVX[numBBurnParticles] = vx;
  bBurnVY[numBBurnParticles] = vy;
  bBurnSize[numBBurnParticles] = size;
  bBurnCol[numBBurnParticles] = col;
  bBurnLife[numBBurnParticles] = 1.0;
  bBurnDecay[numBBurnParticles] = random(1.5, 3.2);
  numBBurnParticles++;
}

boolean animBoosterActivo = false;
int animBoosterPackIndex = 0;
float animBoosterStartX, animBoosterStartY;
float animBoosterTargetX, animBoosterTargetY;
float animBoosterCurX, animBoosterCurY;
float animBoosterStartTime = 0;
float animBoosterFlyDuration = 0.35;
float animBoosterBurnDuration = 1.25;
boolean animBoosterBuildupSonado = false;

void iniciarAnimBoosterPack(int packIdx, float sx, float sy, float tx, float ty) {
  verificarYPrecargarAssetsTienda();
  animBoosterPackIndex = packIdx;
  animBoosterStartX = sx;
  animBoosterStartY = sy;
  animBoosterTargetX = tx;
  animBoosterTargetY = ty;
  animBoosterCurX = sx;
  animBoosterCurY = sy;
  animBoosterStartTime = millis() / 1000.0;
  animBoosterActivo = true;
  animBoosterBuildupSonado = false;
  numBBurnParticles = 0;
}

void dibujarSobreAnimBooster(float x, float y, float esc, float rot, float incandescencia) {
  if (!packsCargados || imgPacks[0] == null) {
    cargarSpritesheetPacks();
  }
  PImage img = (animBoosterPackIndex >= 0 && animBoosterPackIndex < 4) ? imgPacks[animBoosterPackIndex] : null;
  pushMatrix();
  translate(x, y);
  rotate(rot);
  scale(esc);

  rectMode(CENTER);

  fill(0, 150);
  noStroke();
  rect(4, 8, 120, 170, 8);

  if (img != null) {
    imageMode(CENTER);
    if (incandescencia > 0) {
      tint(255, 255 - incandescencia * 90, 255 - incandescencia * 180);
    }
    image(imgShaderDaltonismo(img), 0, 0, 120, 170);
    noTint();

    if (incandescencia > 0) {
      noFill();
      stroke(255, 180 + 75 * sin(incandescencia * PI), 50, 200 * incandescencia);
      strokeWeight(2.5 + incandescencia * 2.0);
      rect(0, 0, 120, 170, 8);
    }
  } else {
    fill(DOLUS_PURPLE);
    stroke(255);
    strokeWeight(2);
    rect(0, 0, 120, 170, 8);
  }

  popMatrix();
}

void actualizarYDibujarAnimBooster(float now) {
  if (!animBoosterActivo) return;
  if (!packsCargados || imgPacks[0] == null) {
    cargarSpritesheetPacks();
  }
  float elapsed = now - animBoosterStartTime;
  float dt = 1.0 / 60.0;

  for (int i = numBBurnParticles - 1; i >= 0; i--) {
    bBurnX[i] += bBurnVX[i] * dt * 60.0;
    bBurnY[i] += bBurnVY[i] * dt * 60.0;
    bBurnLife[i] -= bBurnDecay[i] * dt;
    if (bBurnLife[i] <= 0) {
      for (int k = i; k < numBBurnParticles - 1; k++) {
        bBurnX[k] = bBurnX[k + 1];
        bBurnY[k] = bBurnY[k + 1];
        bBurnVX[k] = bBurnVX[k + 1];
        bBurnVY[k] = bBurnVY[k + 1];
        bBurnLife[k] = bBurnLife[k + 1];
        bBurnDecay[k] = bBurnDecay[k + 1];
        bBurnSize[k] = bBurnSize[k + 1];
        bBurnCol[k] = bBurnCol[k + 1];
      }
      numBBurnParticles--;
    }
  }

  if (elapsed < animBoosterFlyDuration) {
    float t = elapsed / animBoosterFlyDuration;
    float smoothT = 0.5 - 0.5 * cos(t * PI);
    animBoosterCurX = lerp(animBoosterStartX, animBoosterTargetX, smoothT);
    animBoosterCurY = lerp(animBoosterStartY, animBoosterTargetY, smoothT);
    float esc = lerp(0.85, 1.35, smoothT);
    float rot = sin(t * PI) * 0.12;

    dibujarSobreAnimBooster(animBoosterCurX, animBoosterCurY, esc, rot, 0.0);

  } else {
    if (elapsed < animBoosterFlyDuration + animBoosterBurnDuration) {
      if (!animBoosterBuildupSonado) {
        if (sndExplosionBuildup != null) reproducirSFX(sndExplosionBuildup);
        animBoosterBuildupSonado = true;
      }

      float tBurn = elapsed - animBoosterFlyDuration;
      float percent = constrain(tBurn / animBoosterBurnDuration, 0.0, 1.0);

      float jitter = 0.05 * (sin(5.0 * tBurn * 10.0) + cos(0.33 + 41.15 * tBurn) + cos(67.12 * tBurn)) * percent;
      float shakeX = (sin(48.0 * tBurn * TWO_PI) + cos(0.33 + 71.0 * tBurn * TWO_PI)) * 7.5 * percent;
      float shakeY = (cos(55.0 * tBurn * TWO_PI) + sin(83.0 * tBurn * TWO_PI)) * 6.0 * percent;
      float rotShake = 0.08 * (sin(35.0 * tBurn * TWO_PI) + cos(67.0 * tBurn * TWO_PI)) * percent;
      float swellScale = 1.35 + percent * 0.25;

      animBoosterCurX = animBoosterTargetX + shakeX;
      animBoosterCurY = animBoosterTargetY + shakeY;

      int numChispas = int(random(2, 5));
      float pw = 120 * swellScale;
      float ph = 170 * swellScale;
      for (int c = 0; c < numChispas; c++) {
        float px = animBoosterCurX + random(-pw * 0.45, pw * 0.45);
        float py = animBoosterCurY + random(-ph * 0.45, ph * 0.45);
        color colFuego = lerpColor(color(255, 120, 20), color(255, 230, 80), random(1.0));
        if (random(1.0) < 0.3) colFuego = color(255, 60, 60);
        agregarBoosterBurnParticle(px, py, random(-1.2, 1.2), random(-3.5, -1.0), random(4.0, 9.0), colFuego);
      }

      pushMatrix();
      translate(animBoosterCurX, animBoosterCurY);
      noStroke();
      fill(255, 100, 20, 70 * percent);
      ellipse(0, 0, pw * 1.5, ph * 1.5);
      fill(255, 210, 50, 90 * percent);
      ellipse(0, 0, pw * 1.1, ph * 1.1);
      popMatrix();

      dibujarSobreAnimBooster(animBoosterCurX, animBoosterCurY, swellScale, rotShake, percent);

    } else {
      if (sndExplosionRelease != null) reproducirSFX(sndExplosionRelease);
      if (sndCardFan != null) reproducirSFX(sndCardFan);
      dispararSacudidaCamara(7.0);

      for (int k = 0; k < 40; k++) {
        float ang = random(TWO_PI);
        float vel = random(3.0, 9.0);
        color colBurst = (k % 2 == 0) ? DOLUS_PURPLE : color(255, 215, 80);
        if (k % 4 == 0) colBurst = color(255, 255, 255);
        agregarParticulaJuego(animBoosterCurX, animBoosterCurY, cos(ang) * vel, sin(ang) * vel, random(5.0, 9.0), colBurst, 0, 0, 0);
      }

      dispararExplosionCarta(animBoosterCurX, animBoosterCurY, DOLUS_PURPLE, true);
      animBoosterActivo = false;

      abrirBoosterPackUnboxing(animBoosterPackIndex);
    }
  }

  for (int i = 0; i < numBBurnParticles; i++) {
    if (bBurnLife[i] <= 0) continue;
    noStroke();
    fill(red(bBurnCol[i]), green(bBurnCol[i]), blue(bBurnCol[i]), 255.0 * bBurnLife[i]);
    ellipse(bBurnX[i], bBurnY[i], bBurnSize[i] * bBurnLife[i], bBurnSize[i] * bBurnLife[i]);
  }
}

int shopCardSeleccionada = -1;
boolean shopVoucherSeleccionado = false;
int shopPackSeleccionado = -1;
float hoverVoucherLift = 0;
float hoverVoucherTiltX = 0;
float hoverVoucherTiltY = 0;

float shopDescBoxX = 0, shopDescBoxY = 0, shopDescBoxW = 0, shopDescBoxH = 0;
boolean shopDescBoxActiva = false;
int shopDescBoxTipo = 0;
int shopDescBoxIdx = -1;

int[] tiendaPacksTipo = {0, 1, 2};
boolean[] tiendaPacksComprado = {false, false, false};
int[] tiendaPacksPrecio = {4, 6, 8};
float[] hoverPackLift = {0, 0, 0};
float[] hoverPackTiltX = {0, 0, 0};
float[] hoverPackTiltY = {0, 0, 0};
float[] slidePackX = {0, 0, 0};
float[] targetPackX = {0, 0, 0};

float[] slideCardX = {0, 0, 0};
float[] targetCardX = {0, 0, 0};
float[] hoverCardLift = {0, 0, 0};
float[] hoverCardTiltX = {0, 0, 0};
float[] hoverCardTiltY = {0, 0, 0};

PImage[] bannerTiendaFrames = new PImage[4];
boolean bannerTiendaCargado = false;

void fijarInterpolacionNearestNeighbor(boolean activar) {
  try {
    Object nat = g.getNative();
    if (nat instanceof java.awt.Graphics2D) {
      java.awt.Graphics2D g2 = (java.awt.Graphics2D) nat;
      g2.setRenderingHint(
        java.awt.RenderingHints.KEY_INTERPOLATION,
        activar ? java.awt.RenderingHints.VALUE_INTERPOLATION_NEAREST_NEIGHBOR : java.awt.RenderingHints.VALUE_INTERPOLATION_BILINEAR
      );
    }
  } catch (Exception e) {}
}

void cargarBannerTienda() {
  if (bannerTiendaCargado) return;
  PImage sheet = cargarImagenSegura("shopnexus.png");
  if (sheet == null || sheet.width <= 0) return;

  int numFrames = 4;
  int frameW = sheet.width / numFrames;
  int frameH = sheet.height;

  for (int i = 0; i < numFrames; i++) {
    bannerTiendaFrames[i] = sheet.get(i * frameW, 0, frameW, frameH);
  }
  bannerTiendaCargado = true;
}

void dibujarBannerAnimadoTienda(float cx, float cy, float maxW, float maxH, float now) {
  if (!bannerTiendaCargado) {
    cargarBannerTienda();
  }
  if (!bannerTiendaCargado || bannerTiendaFrames[0] == null) return;

  int frameActual = int(now * 8.0) % 4;
  PImage img = bannerTiendaFrames[frameActual];
  if (img == null) return;

  pushMatrix();
  translate(cx, cy);

  float floteY = round(sin(now * 2.2) * 5.0);
  float wobbleRot = sin(now * 1.5) * 0.015;
  translate(0, floteY);
  rotate(wobbleRot);

  float escala = min(maxW / float(img.width), maxH / float(img.height));
  scale(escala);

  fill(0, 110);
  noStroke();
  rectMode(CENTER);
  rect(3, 5, img.width, img.height, 4);

  fijarInterpolacionNearestNeighbor(true);
  imageMode(CENTER);
  image(imgShaderDaltonismo(img), 0, 0);
  fijarInterpolacionNearestNeighbor(false);

  popMatrix();
}

void cargarSpritesheetPacks() {
  if (packsCargados && imgPacks[0] != null) return;
  sheetPacks = cargarImagenSegura("plugin_packs.png");
  if (sheetPacks == null || sheetPacks.width <= 0) {
    try {
      sheetPacks = loadImage("plugin_packs.png");
    } catch (Exception ignored) {}
  }
  if (sheetPacks != null && sheetPacks.width > 0) {
    int frameW = sheetPacks.width / 4;
    int frameH = sheetPacks.height;
    for (int i = 0; i < 4; i++) {
      imgPacks[i] = sheetPacks.get(i * frameW, 0, frameW, frameH);
    }
    packsCargados = true;
    println("[TIENDA] Spritesheet plugin_packs.png cargada con exito (4 frames de " + frameW + "x" + frameH + ")");
  } else {
    println("[ERROR] No se pudo cargar data/plugin_packs.png");
  }
}

void verificarYPrecargarAssetsTienda() {
  if (!packsCargados || imgPacks[0] == null) {
    cargarSpritesheetPacks();
  }
  if (!bannerTiendaCargado || bannerTiendaFrames[0] == null) {
    cargarBannerTienda();
  }
  if (sonidoShopBuy == null) {
    sonidoShopBuy = cargarSonido("shopbuy.wav");
  }
  if (sndExplosionBuildup == null) {
    sndExplosionBuildup = cargarSonido("explosion_buildup1.ogg");
  }
  if (sndExplosionRelease == null) {
    sndExplosionRelease = cargarSonido("explosion_release1.ogg");
  }
  if (sndCardFan == null) {
    sndCardFan = cargarSonido("cardFan2.ogg");
  }
}

void inicializarTienda() {
  costoRerollTienda = 5;
  boosterPackComprado = false;
  exploitComprado = false;
  estadoTienda = TIENDA_ESTADO_NORMAL;
  slotSeleccionadoVenta = -1;
  shopCardSeleccionada = -1;
  shopVoucherSeleccionado = false;
  shopPackSeleccionado = -1;
  shopDescBoxActiva = false;
  shopDescBoxTipo = 0;
  shopDescBoxIdx = -1;
  inicializarJuiceTienda();
  hoverVoucherLift = 0;
  vueloTiendaActivo = false;
  animBoosterActivo = false;
  tipoPackTiendaActual = 0;
  precioBoosterPack = packPrecio[0];

  for (int p = 0; p < 3; p++) {
    tiendaPacksTipo[p] = p;
    tiendaPacksComprado[p] = false;
    tiendaPacksPrecio[p] = packPrecio[p];
  }

  verificarYPrecargarAssetsTienda();
}

void comprobarResetRondaTienda() {
  if (rondaActual != ultimaRondaTienda) {
    ultimaRondaTienda = rondaActual;
    costoRerollTienda = 12;
    boosterPackComprado = false;
    exploitComprado = false;
    rotarVoucherTienda();
    kernelShieldUsadoEnRonda = false;
    spamAutoEliminadosEnRonda = 0;

    if (voucherStakingPoolActivo) {
      int interes = min(15, tokensDolus / 10);
      if (interes > 0) {
        tokensDolus += interes;
      }
    }

    estadoTienda = TIENDA_ESTADO_NORMAL;
    slotSeleccionadoVenta = -1;
    shopCardSeleccionada = -1;
    shopVoucherSeleccionado = false;
    hoverVoucherLift = 0;
    vueloTiendaActivo = false;
    animBoosterActivo = false;

    for (int p = 0; p < 3; p++) {
      tiendaPacksComprado[p] = false;
      if (p == 0) {
        tiendaPacksTipo[p] = (rondaActual <= 2) ? 0 : ((random(1) < 0.6) ? 0 : 1);
      } else {
        if (p == 1) {
          tiendaPacksTipo[p] = (rondaActual <= 3) ? 1 : ((random(1) < 0.5) ? 1 : 2);
        } else {
          tiendaPacksTipo[p] = (rondaActual <= 5) ? 2 : ((random(1) < 0.5) ? 2 : 3);
        }
      }
      tiendaPacksPrecio[p] = packPrecio[tiendaPacksTipo[p]];
      slidePackX[p] = (targetPackX[p] > 0 ? targetPackX[p] : width * 0.5) + 120.0 + p * 40.0;
      dispararJuiceTienda(JUICE_PACKS_BASE + p, 0.35, random(-0.15, 0.15));
      hoverPackLift[p] = 0;
      hoverPackTiltX[p] = 0;
      hoverPackTiltY[p] = 0;
    }
    tipoPackTiendaActual = tiendaPacksTipo[0];
    precioBoosterPack = tiendaPacksPrecio[0];

    for (int i = 0; i < 3; i++) {
      slideCardX[i] = (targetCardX[i] > 0 ? targetCardX[i] : width * 0.5) + 140.0 + i * 45.0;
      dispararJuiceTienda(JUICE_CARDS_BASE + i, 0.35, random(-0.15, 0.15));
      hoverCardLift[i] = 0;
      hoverCardTiltX[i] = 0;
      hoverCardTiltY[i] = 0;
    }
  }
}

void actualizarYDibujarTienda() {
  verificarYPrecargarAssetsTienda();
  actualizarJuiceYCamara();
  dibujarFondoTiendaOptimizado(colorTema());
  comprobarResetRondaTienda();

  float now = millis() / 1000.0;
  pushStyle();
  if (fuenteRetro != null) textFont(fuenteRetro);

  color colG = colorTema();
  color colBgPanel = color(6, 14, 10, 245);
  color colAlarma = color(255, 70, 70);

  pluginHoverInspector = -1;
  tipoHoverInspector = "";
  statHoverIdx = -1;

  dibujarTopBarDolus(colG, colBgPanel, colAlarma, now);

  dibujarTiendaCuerpoDolus(colG, colBgPanel, colAlarma, now);

  if (!tutorialTiendaActivo && slotSeleccionadoVenta >= 1 && slotSeleccionadoVenta <= 4 && pluginHoverInspector == -1) {
    int invIdx = slotSeleccionadoVenta - 1;
    if (invIdx >= 0 && invIdx < numInventarioPlugins) {
      pluginHoverInspector = inventarioPlugins[invIdx];
      tipoHoverInspector = "EQUIPADO";
    }
  }

  actualizarYDibujarVueloTienda(now);

  actualizarYDibujarParticulasJuego();
  actualizarYDibujarFlourishLayer();
  dibujarTextoElasticoFlotante();

  if (!tutorialTiendaActivo && pluginHoverInspector != -1) {
    dibujarTerminalDiagnosticoTooltip(pluginHoverInspector, tipoHoverInspector, colG);
  }

  if (!tutorialTiendaActivo && statHoverIdx != -1) {
    dibujarTooltipStat(statHoverIdx, statHoverX, statHoverY);
  }

  if (animandoTransicionTienda) {
    if (sentidoTransicionTienda > 0) {
      progresoTransicionTienda += VELOCIDAD_TRANSICION_TIENDA;
      if (progresoTransicionTienda >= 1.0) {
        progresoTransicionTienda = 1.0;
        animandoTransicionTienda = false;
        sentidoTransicionTienda = 0;
        if (!tutorialTiendaVisto && !tutorialTiendaActivo) {
          iniciarTutorialTienda();
        }
      }
    } else {
      if (sentidoTransicionTienda < 0) {
        progresoTransicionTienda -= VELOCIDAD_TRANSICION_TIENDA;
        if (progresoTransicionTienda <= 0.0) {
          progresoTransicionTienda = 0.0;
          finalizarSalidaTienda();
        }
      }
    }
  }

  if (!animandoTransicionTienda && sentidoTransicionTienda == 0 && !tutorialTiendaVisto && !tutorialTiendaActivo) {
    iniciarTutorialTienda();
  }
  if (!animandoTransicionTienda) {
    actualizarYDibujarTutorialTienda();
  }

  popStyle();
  rectMode(CORNER);
  textAlign(LEFT, TOP);
}

void dibujarFondoTiendaOptimizado(color colG) {

  dibujarFondoJuego();
}

void dibujarTexturaCyberGrid(float w, float h, color colG) {
  pushStyle();
  stroke(red(colG), green(colG), blue(colG), 10);
  strokeWeight(1);
  for (float x = 32; x < w - 12; x += 48) {
    line(x, 12, x, h - 12);
  }
  for (float y = 32; y < h - 12; y += 48) {
    line(12, y, w - 12, y);
  }
  popStyle();
}

void actualizarPosicionesSlotsTienda() {
  float margin = width * 0.02;
  float topY = height * 0.03;
  float topH = height * 0.20;
  float hudW = width * 0.26;
  float slotsW = width - hudW - margin * 2 - width * 0.02;
  float slotsX = margin + hudW + width * 0.02;

  int totalSlots = limiteMaxSlotsRack();
  float pluginSpace = slotsW / float(max(4, totalSlots));
  escalaSlot = (totalSlots > 4) ? 0.72 : 0.85;

  for (int i = 0; i < 5; i++) {
    plugBaseX[i] = slotsX + pluginSpace * i + pluginSpace / 2.0;
    plugBaseY[i] = topY + topH * 0.45;
  }
}

void dibujarTopBarDolus(color colG, color colBgPanel, color colAlarma, float now) {
  float margin = width * 0.02;
  float topY = height * 0.03;
  float topH = height * 0.20;

  float hudW = width * 0.26;
  float slotsW = width - hudW - margin * 2 - width * 0.02;
  float slotsX = margin + hudW + width * 0.02;

  float bannerCX = margin + hudW * 0.5;
  float bannerCY = topY + topH * 0.5;
  float exitOffsetDist = topY + topH + 80;
  float pTrans = progresoTransicionTienda;

  if (sentidoTransicionTienda >= 0) {

    float tExit = constrain(pTrans / 0.60, 0.0, 1.0);
    if (tExit < 1.0) {
      float offsetYExit = -(tExit * tExit) * exitOffsetDist;
      pushMatrix();
      translate(0, offsetYExit);
      dibujarPanelPersona(margin, topY, hudW, topH, colG, colBgPanel);
      dibujarContenidoIntegridadSistema(margin, topY, hudW, topH, colG, colAlarma);
      popMatrix();
    }

    float tEnter = constrain((pTrans - 0.15) / 0.85, 0.0, 1.0);
    if (tEnter > 0.0) {
      float bounce = sin(tEnter * PI) * (1.0 - tEnter) * 12.0;
      float offsetYEnter = -(1.0 - easeOutCubic(tEnter)) * exitOffsetDist + bounce;
      pushMatrix();
      translate(0, offsetYEnter);
      dibujarBannerAnimadoTienda(bannerCX, bannerCY, hudW, topH, now);
      popMatrix();
    }
  } else {

    float pSalida = 1.0 - pTrans;

    float tExit = constrain(pSalida / 0.60, 0.0, 1.0);
    if (tExit < 1.0) {
      float offsetYExit = -(tExit * tExit) * exitOffsetDist;
      pushMatrix();
      translate(0, offsetYExit);
      dibujarBannerAnimadoTienda(bannerCX, bannerCY, hudW, topH, now);
      popMatrix();
    }

    float tEnter = constrain((pSalida - 0.15) / 0.85, 0.0, 1.0);
    if (tEnter > 0.0) {
      float bounce = sin(tEnter * PI) * (1.0 - tEnter) * 12.0;
      float offsetYEnter = -(1.0 - easeOutCubic(tEnter)) * exitOffsetDist + bounce;
      pushMatrix();
      translate(0, offsetYEnter);
      dibujarPanelPersona(margin, topY, hudW, topH, colG, colBgPanel);
      dibujarContenidoIntegridadSistema(margin, topY, hudW, topH, colG, colAlarma);
      popMatrix();
    }
  }

  actualizarPosicionesSlotsTienda();

  int totalSlotsRack = limiteMaxSlotsRack();
  float cardW = anchoRectPlugin * escalaSlot;
  float cardH = altoRectPlugin * escalaSlot;
  float[] shopRackOffY = new float[5];
  boolean[] shopRackOculto = new boolean[5];
  for (int k = 0; k < 5; k++) shopRackOculto[k] = true;

  for (int i = 0; i < totalSlotsRack; i++) {
    float cx = plugBaseX[i];
    float cy = plugBaseY[i];

    actualizarJuiceTienda(JUICE_SLOTS_BASE + i, now);

    int invIdx = i - 1;
    boolean hasPlugin = (i == 0) ? (numCatalogoPlugins > 0) : (invIdx >= 0 && invIdx < numInventarioPlugins);
    boolean isFlyingToThisSlot = (vueloTiendaActivo && vueloTiendaTargetSlotIdx == i);
    boolean isSelected = (slotSeleccionadoVenta == i);

    float btnVentaH = 28;
    float btnVentaW = cardW * 0.88;
    float btnVentaY = cy + cardH * 0.5 - btnVentaH * 0.5 - 6;

    boolean hovSlot = !tutorialTiendaActivo && hasPlugin && !isFlyingToThisSlot && evaluarHover(cx, cy, cardW, cardH);
    boolean hovSellBtn = !tutorialTiendaActivo && hasPlugin && isSelected && evaluarHover(cx, btnVentaY, btnVentaW, btnVentaH);

    if (i == 0) {
      if (hovSlot) {
        pluginHoverInspector = 0;
        tipoHoverInspector = "SLOT_MAESTRO";
      }
    } else {
      if (hovSlot || hovSellBtn) {
        pluginHoverInspector = inventarioPlugins[invIdx];
        tipoHoverInspector = "EQUIPADO";
      }
    }

    if (isFlyingToThisSlot) {

      pushMatrix();
      translate(cx, cy);
      scale(escalaSlot);
      stroke(255, 215, 80, 160 + 90 * sin(now * 12.0));
      strokeWeight(4);
      fill(16, 32, 24, 210);
      dibujarFormaAngularJuego(anchoRectPlugin, altoRectPlugin, 26);
      popMatrix();

    } else {
      if (!hasPlugin) {

        pushMatrix();
        translate(cx, cy);
        scale(escalaSlot);
        stroke(colorTema(), 50);
        strokeWeight(4);
        fill(0, 50);
        dibujarFormaAngularJuego(anchoRectPlugin, altoRectPlugin, 26);
        popMatrix();

      } else {

        int pIdx = (i == 0) ? 0 : inventarioPlugins[invIdx];

        float floteMult = isSelected ? 0.35 : 1.0;
        float floteY = (sin(frameCount * 0.02 + plugFaseFlote[i]) * 4.5) * floteMult;
        float liftY = (hovSlot && !isSelected) ? -6.0 : 0.0;
        float yActual = cy + floteY + liftY;
        if (i < 5) {
          shopRackOffY[i] = floteY + liftY;
          shopRackOculto[i] = false;
        }

        pushMatrix();
        translate(cx, yActual);
        scale(1.0 + juiceTScale[JUICE_SLOTS_BASE + i]);
        rotate(juiceTRot[JUICE_SLOTS_BASE + i]);

        PImage imgSlot = plugCatImgSlot[pIdx];
        if (imgSlot == null) imgSlot = plugCatImgBase[pIdx];

        if (imgSlot != null) {
          noStroke();
          fill(0, 145);
          rectMode(CENTER);
          rect(7, 9, imgSlot.width - 4, imgSlot.height - 4, 14);

          imageMode(CENTER);
          noTint();
          image(imgShaderDaltonismo(imgSlot), 0, 0);
        } else {
          pushMatrix();
          scale(escalaSlot);
          stroke(colorTema());
          strokeWeight(4);
          fill(14, 18, 15);
          dibujarFormaAngularJuego(anchoRectPlugin, altoRectPlugin, 26);
          popMatrix();
        }

        if (isSelected) {
          noFill();
          stroke(DOLUS_RED);
          strokeWeight(3.0);
          rectMode(CENTER);
          rect(0, 0, cardW + 4, cardH + 4, 8);
        } else {
          if (hovSlot) {
            noFill();
            stroke(255, 215, 80, 200);
            strokeWeight(2.2);
            rectMode(CENTER);
            rect(0, 0, cardW + 2, cardH + 2, 8);
          }
        }

        float sheenCycle = (now * 0.35 + i * 0.25) % 3.0;
        if (sheenCycle < 0.9) {
          float prog = sheenCycle / 0.9;
          float sy = map(prog, 0.0, 1.0, -cardH * 0.5, cardH * 0.5);
          stroke(255, 255, 255, 55 * sin(prog * PI));
          strokeWeight(2.0);
          line(-cardW * 0.45, sy - 14, cardW * 0.45, sy + 14);
        }

        popMatrix();

        if (isSelected && i > 0) {
          int valorVenta = max(1, plugCatPrecioTokens[pIdx] / 2);

          fill(0, 180);
          noStroke();
          rectMode(CENTER);
          rect(cx, btnVentaY + 2, btnVentaW, btnVentaH, 5);

          fill(hovSellBtn ? color(245, 50, 50) : DOLUS_RED);
          stroke(hovSellBtn ? color(255) : color(255, 140, 140));
          strokeWeight(hovSellBtn ? 2.2 : 1.4);
          rect(cx, btnVentaY, btnVentaW, btnVentaH, 5);

          fill(255);
          if (fuenteRetro != null) textFont(fuenteRetro);
          textSize(11);
          textAlign(CENTER, CENTER);
          text("VENDER +" + valorVenta + "T", cx, btnVentaY - 1);
        }
      }
    }
  }

  dibujarSinergiasVisualesRack(shopRackOculto, shopRackOffY, cardW, cardH);
}

void dibujarLetreroNexusShop(float cx, float cy, color colG, float now) {
  pushStyle();
  pushMatrix();
  translate(cx, cy);

  float wobbleRot = sin(now * 1.8) * 0.020;
  float wobbleScale = 1.0 + sin(now * 3.2) * 0.012;
  rotate(wobbleRot);
  scale(wobbleScale);

  float signW = min(480, width * 0.40);
  float signH = 34;

  rectMode(CENTER);
  fill(0, 140);
  noStroke();
  rect(3, 4, signW, signH, 8);

  fill(8, 22, 16, 245);
  stroke(colG);
  strokeWeight(2.2);
  rect(0, 0, signW, signH, 8);

  fill(255, 215, 80);
  textSize(18);
  textAlign(CENTER, CENTER);
  text("===  TIENDA DE LA RED NEXUS  ===", 0, -1);

  popMatrix();
  popStyle();
}

void dibujarTiendaCuerpoDolus(color colG, color colBgPanel, color colAlarma, float now) {
  float margin = width * 0.02;
  float topY = height * 0.03;
  float topH = height * 0.20;
  float startY = topY + topH + height * 0.02;
  float totalH = height * 0.72;

  float leftW = width * 0.26;
  float mainX = margin + leftW + width * 0.02;
  float mainW = width - mainX - margin;

  float row1H = (totalH - 16) * 0.50;
  float row2H = totalH - row1H - 16;
  float row2Y = startY + row1H + 16;

  float slideOffsetDist = height - startY + 80;
  float pTrans = progresoTransicionTienda;

  if (sentidoTransicionTienda >= 0) {

    float tExit = constrain(pTrans / 0.60, 0.0, 1.0);
    if (tExit < 1.0) {
      float offsetYExit = (tExit * tExit) * slideOffsetDist;
      pushMatrix();
      translate(0, offsetYExit);
      dibujarModuloGameplayInferiorIzq(margin, startY, leftW, totalH, colG, colBgPanel, colAlarma);
      popMatrix();
    }

    float tEnter = constrain((pTrans - 0.15) / 0.85, 0.0, 1.0);
    if (tEnter > 0.0) {
      float bounce = sin(tEnter * PI) * (1.0 - tEnter) * 12.0;
      float offsetYEnter = (1.0 - easeOutCubic(tEnter)) * slideOffsetDist - bounce;
      pushMatrix();
      translate(0, offsetYEnter);
      dibujarModuloTiendaInferiorIzq(margin, startY, leftW, totalH, colG, colBgPanel, colAlarma, now);
      popMatrix();
    }
  } else {

    float pSalida = 1.0 - pTrans;

    float tExit = constrain(pSalida / 0.60, 0.0, 1.0);
    if (tExit < 1.0) {
      float offsetYExit = (tExit * tExit) * slideOffsetDist;
      pushMatrix();
      translate(0, offsetYExit);
      dibujarModuloTiendaInferiorIzq(margin, startY, leftW, totalH, colG, colBgPanel, colAlarma, now);
      popMatrix();
    }

    float tEnter = constrain((pSalida - 0.15) / 0.85, 0.0, 1.0);
    if (tEnter > 0.0) {
      float bounce = sin(tEnter * PI) * (1.0 - tEnter) * 12.0;
      float offsetYEnter = (1.0 - easeOutCubic(tEnter)) * slideOffsetDist - bounce;
      pushMatrix();
      translate(0, offsetYEnter);
      dibujarModuloGameplayInferiorIzq(margin, startY, leftW, totalH, colG, colBgPanel, colAlarma);
      popMatrix();
    }
  }

  float shelfDist = width - mainX + 80;

  if (estadoTienda == TIENDA_ESTADO_NORMAL) {
    actualizarHoverYSeleccionTienda(mainX, startY, mainW, totalH, row1H, row2Y, row2H);
  }

  if (sentidoTransicionTienda >= 0) {

    float tMesaExit = constrain(pTrans / 0.60, 0.0, 1.0);
    if (tMesaExit < 1.0) {
      float mesaOffsetY = (tMesaExit * tMesaExit) * slideOffsetDist;
      pushMatrix();
      translate(0, mesaOffsetY);
      dibujarPanelPersona(mainX, startY, mainW, totalH, colG, colBgPanel);
      popMatrix();
    }

    float tShelfEnter = constrain((pTrans - 0.15) / 0.85, 0.0, 1.0);
    if (tShelfEnter > 0.0) {
      float bounce = sin(tShelfEnter * PI) * (1.0 - tShelfEnter) * 14.0;
      float shelfOffsetX = (1.0 - easeOutCubic(tShelfEnter)) * shelfDist - bounce;
      pushMatrix();
      translate(shelfOffsetX, 0);

      if (estadoTienda == TIENDA_ESTADO_NORMAL) {
        dibujarFilaOfertasPlugins(mainX, startY, mainW, row1H, colG, colBgPanel, colAlarma, now);
        dibujarFilaBoosterPacks(mainX, row2Y, mainW, row2H, colG, colBgPanel, now);
        dibujarCajaDescripcionTienda(mainX, mainW, startY, totalH, row1H, row2Y, row2H, colG, now);
      } else {
        if (estadoTienda == TIENDA_ESTADO_BOOSTER_ANIM) {
          dibujarPanelBoosterAnimacion(mainX, startY, mainW, totalH, colG, colBgPanel, now);
        } else {
          if (estadoTienda == TIENDA_ESTADO_BOOSTER) {
            dibujarPanelBoosterEnTienda(mainX, startY, mainW, totalH, colG, colBgPanel, now);
          }
        }
      }
      popMatrix();
    }

  } else {

    float pSalida = 1.0 - pTrans;

    float tShelfExit = constrain(pSalida / 0.75, 0.0, 1.0);
    if (tShelfExit < 1.0) {
      float shelfOffsetX = (tShelfExit * tShelfExit) * shelfDist;
      pushMatrix();
      translate(shelfOffsetX, 0);

      if (estadoTienda == TIENDA_ESTADO_NORMAL) {
        dibujarFilaOfertasPlugins(mainX, startY, mainW, row1H, colG, colBgPanel, colAlarma, now);
        dibujarFilaBoosterPacks(mainX, row2Y, mainW, row2H, colG, colBgPanel, now);
        dibujarCajaDescripcionTienda(mainX, mainW, startY, totalH, row1H, row2Y, row2H, colG, now);
      } else {
        if (estadoTienda == TIENDA_ESTADO_BOOSTER_ANIM) {
          dibujarPanelBoosterAnimacion(mainX, startY, mainW, totalH, colG, colBgPanel, now);
        } else {
          if (estadoTienda == TIENDA_ESTADO_BOOSTER) {
            dibujarPanelBoosterEnTienda(mainX, startY, mainW, totalH, colG, colBgPanel, now);
          }
        }
      }
      popMatrix();
    }

    float tMesaEnter = constrain((pSalida - 0.15) / 0.85, 0.0, 1.0);
    if (tMesaEnter > 0.0) {
      float bounce = sin(tMesaEnter * PI) * (1.0 - tMesaEnter) * 12.0;
      float mesaOffsetY = (1.0 - easeOutCubic(tMesaEnter)) * slideOffsetDist - bounce;
      pushMatrix();
      translate(0, mesaOffsetY);
      dibujarPanelPersona(mainX, startY, mainW, totalH, colG, colBgPanel);
      popMatrix();
    }
  }
}

void dibujarModuloTiendaInferiorIzq(float startX, float startY, float leftW, float totalH, color colG, color colBgPanel, color colAlarma, float now) {
  pushMatrix();
  translate(startX, startY);

  fill(colBgPanel);
  stroke(colG);
  strokeWeight(2.5);
  dibujarFormaAngularBase(leftW, totalH, 16);
  dibujarTexturaCyberGrid(leftW, totalH, colG);

  fill(colG);
  textSize(12);
  textAlign(LEFT, TOP);
  text("// PANEL DE CONTROL NEXUS", 18, 14);

  float btnContW = leftW - 32;
  float btnContH = 56;
  float btnContY = 52 + btnContH * 0.5;
  actualizarJuiceTienda(JUICE_BTN_CONTINUAR, now);
  boolean hovCont = !tutorialTiendaActivo && evaluarHover(startX + leftW * 0.5, startY + btnContY, btnContW, btnContH);
  String txtContinuarTienda = modoExposicionActivo
    ? obtenerEtiquetaBotonTiendaExpo()
    : ("CONTINUAR A R" + (rondaActual + 1) + " >>");
  dibujarBotonSquishyDolus(txtContinuarTienda, leftW * 0.5, btnContY, btnContW, btnContH, DOLUS_RED, 15, hovCont, JUICE_BTN_CONTINUAR);

  float btnRerollW = leftW - 32;
  float btnRerollH = 50;
  float btnRerollY = btnContY + btnContH * 0.5 + 14 + btnRerollH * 0.5;
  actualizarJuiceTienda(JUICE_BTN_REROLL, now);
  boolean hovReroll = !tutorialTiendaActivo && evaluarHover(startX + leftW * 0.5, startY + btnRerollY, btnRerollW, btnRerollH);
  int costoRerollActual = (voucherStakingPoolActivo && !rerollGratisUsadoEnTienda) ? 0 : costoRerollTienda;
  color cReroll = (tokensDolus >= costoRerollActual) ? DOLUS_GREEN : color(70, 85, 75);
  String txtReroll = (costoRerollActual == 0) ? "REROLL (GRATIS)" : ("REROLL (" + costoRerollActual + " TOKENS)");
  dibujarBotonSquishyDolus(txtReroll, leftW * 0.5, btnRerollY, btnRerollW, btnRerollH, cReroll, 13, hovReroll, JUICE_BTN_REROLL);

  float infoPanelY = btnRerollY + btnRerollH * 0.5 + 16;
  float infoPanelH = totalH - infoPanelY - 16;
  if (infoPanelH > 50) {
    float pCX = leftW * 0.5;

    fill(8, 18, 14, 235);
    stroke(colG, 130);
    strokeWeight(1.8);
    rectMode(CORNER);
    rect(16, infoPanelY, leftW - 32, infoPanelH, 8);

    int sigRonda = rondaActual + 1;
    int proxJefe = ((sigRonda + 2) / 3) * 3;
    int rondasFaltantes = max(0, proxJefe - sigRonda);

    float jefeBoxY = infoPanelY + 16;
    float jefeBoxH = 46;
    float jefeBoxW = leftW - 48;

    fill(36, 12, 16, 235);
    stroke(colAlarma, 190);
    strokeWeight(1.6);
    rectMode(CORNER);
    rect(24, jefeBoxY, jefeBoxW, jefeBoxH, 6);

    fill(colAlarma);
    textSize(16);
    textAlign(CENTER, CENTER);
    String txtJefe = (rondasFaltantes == 0) ? "ENFRENTAMIENTO DE JEFE!" : ("SIGUIENTE JEFE EN R" + proxJefe);
    text(txtJefe, pCX, jefeBoxY + jefeBoxH * 0.5 - 1);

    stroke(colG, 65);
    strokeWeight(1.4);
    line(32, jefeBoxY + jefeBoxH + 12, leftW - 32, jefeBoxY + jefeBoxH + 12);

    fill(255);
    textSize(20);
    textAlign(CENTER, TOP);
    String txtMetaTienda = (sigRonda % 3 == 0)
      ? ("RONDA " + rondaActual + " // SIG: JEFE")
      : ("RONDA " + rondaActual + " // BALANZA: +" + obtenerMetaBalanzaRonda(sigRonda, 0));
    text(txtMetaTienda, pCX, jefeBoxY + jefeBoxH + 20);

    stroke(colG, 65);
    strokeWeight(1.4);
    line(32, jefeBoxY + jefeBoxH + 50, leftW - 32, jefeBoxY + jefeBoxH + 50);

    float tokensZoneTop = jefeBoxY + jefeBoxH + 52;
    float tokensZoneBottom = infoPanelY + infoPanelH - 10;
    float totalZoneH = tokensZoneBottom - tokensZoneTop;

    float tokensCenterY = (totalZoneH >= 170) ? (tokensZoneTop + 36) : (tokensZoneTop + totalZoneH * 0.28);

    fill(140, 195, 175);
    textSize(11);
    textAlign(CENTER, CENTER);
    text("RESERVA DE TOKENS", pCX, tokensCenterY - 20);

    fill(255, 215, 80);
    textSize(int(38 + pulsoTokensUI * 6));
    textAlign(CENTER, CENTER);
    text(tokensDolus + " T", pCX, tokensCenterY + 12);

    float divY = tokensCenterY + 38;
    stroke(colG, 65);
    strokeWeight(1.2);
    line(32, divY, leftW - 32, divY);

    float integTopY = divY + 8;
    boolean alertaCritica = (dispSaludMental <= 25.0 || dispSeguridad <= 25.0 || dispReputacion <= 25.0 || dispPopularidad <= 25.0);
    fill(alertaCritica ? colAlarma : color(140, 195, 175));
    textSize(11);
    textAlign(CENTER, TOP);
    text("INTEGRIDAD DEL SISTEMA", pCX, integTopY + 2);

    float iconsShopY = integTopY + 38;
    float iconSz = min(32.0, (leftW - 48) * 0.145);
    float spanW = leftW - 44;
    float step = spanW / 4.0;
    float iconsStartX = 22 + step * 0.5;

    String[] etiquetasStd = {"SALUD", "SEG", "REP", "POP"};
    float[] vals = {dispSaludMental, dispSeguridad, dispReputacion, dispPopularidad};

    for (int i = 0; i < 4; i++) {
      float ix = iconsStartX + i * step;
      dibujarIconoStatReigns(i, obtenerImgStat(i), etiquetasStd[i], vals[i], ix, iconsShopY, iconSz, 0, pulsoBarraStat[i], color(0), true);
    }
  }

  popMatrix();
}

void dibujarTextoDinamicoOptimizado(String texto, float x, float y, float anchoMax, float altoMax, color colTexto, float tamMaxDeseado) {
  if (texto == null || texto.length() == 0) return;
  pushStyle();
  if (fuenteRetro != null) textFont(fuenteRetro);

  float tamActual = tamMaxDeseado;
  float tamMin = 9.5;
  String[] lineas = new String[64];
  int numLineas = 0;
  float interlineado = tamActual * 1.25;

  while (tamActual >= tamMin) {
    textSize(tamActual);
    interlineado = tamActual * 1.25;
    numLineas = 0;

    String[] parrafos = dividirTexto(texto, "\n");
    int numParrafos = contarTextos(parrafos);
    for (int p = 0; p < numParrafos; p++) {
      String[] palabras = dividirTexto(parrafos[p], " ");
      int numPalabras = contarTextos(palabras);
      String linea = "";
      for (int i = 0; i < numPalabras; i++) {
        String pal = palabras[i];
        String prueba = (linea.length() == 0) ? pal : linea + " " + pal;
        if (textWidth(prueba) > anchoMax && linea.length() > 0) {
          if (numLineas < 64) lineas[numLineas++] = linea;
          linea = pal;
        } else {
          linea = prueba;
        }
      }
      if (linea.length() > 0 && numLineas < 64) lineas[numLineas++] = linea;
    }

    float altoTotal = numLineas * interlineado;
    if (altoTotal <= altoMax) {
      break;
    }
    tamActual -= 0.5;
  }

  textSize(tamActual);
  textAlign(LEFT, TOP);
  fill(colTexto);

  float altoTotal = numLineas * interlineado;
  float offsetY = max(0, (altoMax - altoTotal) * 0.35);

  for (int i = 0; i < numLineas; i++) {
    text(lineas[i], x, y + offsetY + i * interlineado);
  }
  popStyle();
}

void actualizarHoverYSeleccionTienda(float mainX, float startY, float mainW, float totalH, float row1H, float row2Y, float row2H) {
  if (animandoTransicionTienda || tutorialTiendaActivo) {
    shopDescBoxActiva = false;
    shopDescBoxTipo = 0;
    shopDescBoxIdx = -1;
    return;
  }

  float cardH = row1H - 22;
  float btnH = 36;
  float spriteH = cardH - btnH - 8;
  float spriteW = round(spriteH * (71.0 / 95.0));
  float cardW = spriteW;
  float cardSpacing = 18.0;
  float startCardX = 22.0 + cardW * 0.5;

  float rightOfCards = startCardX + 2 * (cardW + cardSpacing) + cardW * 0.5;
  float vCX = rightOfCards + (mainW - rightOfCards) * 0.5;

  float cardHPack = row2H - 22;
  float btnHPack = 36;
  float badgeHPack = 18;
  float gapPack = 6;
  float spriteHPack = cardHPack - btnHPack - badgeHPack - gapPack * 2;
  float spriteWPack = round(spriteHPack * (284.0 / 400.0));
  float packW = spriteWPack;
  float packSpacing = max(24.0, (mainW - 40.0 - 3 * packW) / 4.0);
  float totalPacksW = 3 * packW + 2 * packSpacing;
  float startPackX = (mainW - totalPacksW) * 0.5 + packW * 0.5;

  boolean mouseSobreDescBox = shopDescBoxActiva &&
                              (mouseX >= shopDescBoxX && mouseX <= shopDescBoxX + shopDescBoxW &&
                               mouseY >= shopDescBoxY && mouseY <= shopDescBoxY + shopDescBoxH);

  if (mouseSobreDescBox) {

    return;
  }

  int hoverTipo = 0;
  int hoverIdx = -1;

  for (int i = 0; i < 3; i++) {
    if (tiendaOpciones[i] == -1 || tiendaComprado[i]) continue;
    float cx = mainX + (slideCardX[i] > 10 ? slideCardX[i] : (startCardX + i * (cardW + cardSpacing)));
    float cy = startY + row1H * 0.5 + 4;
    if (evaluarHover(cx, cy, cardW, cardH)) {
      hoverTipo = 1;
      hoverIdx = i;
      break;
    }
  }

  if (hoverTipo == 0 && catalogoVouchersInicializado && voucherTiendaActual >= 0 && voucherTiendaActual < 8 && !vouchComprado[voucherTiendaActual]) {
    float cx = mainX + vCX;
    float cy = startY + row1H * 0.5 + 4;
    if (evaluarHover(cx, cy, cardW, cardH)) {
      hoverTipo = 2;
      hoverIdx = voucherTiendaActual;
    }
  }

  if (hoverTipo == 0) {
    for (int p = 0; p < 3; p++) {
      if (tiendaPacksComprado[p]) continue;
      float pcx = mainX + (slidePackX[p] > 10 ? slidePackX[p] : (startPackX + p * (packW + packSpacing)));
      float pcy = row2Y + row2H * 0.5 + 4;
      if (evaluarHover(pcx, pcy, packW, cardHPack)) {
        hoverTipo = 3;
        hoverIdx = p;
        break;
      }
    }
  }

  if (hoverTipo > 0) {
    shopDescBoxTipo = hoverTipo;
    shopDescBoxIdx = hoverIdx;
    shopDescBoxActiva = true;
  } else {
    if (shopCardSeleccionada >= 0 && shopCardSeleccionada < 3 && tiendaOpciones[shopCardSeleccionada] != -1 && !tiendaComprado[shopCardSeleccionada]) {
      shopDescBoxTipo = 1;
      shopDescBoxIdx = shopCardSeleccionada;
      shopDescBoxActiva = true;
    } else {
      if (shopVoucherSeleccionado && catalogoVouchersInicializado && voucherTiendaActual >= 0 && voucherTiendaActual < 8 && !vouchComprado[voucherTiendaActual]) {
        shopDescBoxTipo = 2;
        shopDescBoxIdx = voucherTiendaActual;
        shopDescBoxActiva = true;
      } else {
        if (shopPackSeleccionado >= 0 && shopPackSeleccionado < 3 && !tiendaPacksComprado[shopPackSeleccionado]) {
          shopDescBoxTipo = 3;
          shopDescBoxIdx = shopPackSeleccionado;
          shopDescBoxActiva = true;
        } else {
          shopDescBoxTipo = 0;
          shopDescBoxIdx = -1;
          shopDescBoxActiva = false;
        }
      }
    }
  }
}

void dibujarFilaOfertasPlugins(float rx, float ry, float rw, float rh, color colG, color colBgPanel, color colAlarma, float now) {
  pushMatrix();
  translate(rx, ry);

  fill(colBgPanel);
  stroke(colG);
  strokeWeight(2.5);
  dibujarFormaAngularBase(rw, rh, 18);
  dibujarTexturaCyberGrid(rw, rh, colG);

  float cardH = rh - 22;
  float btnH = 36;
  float spriteH = cardH - btnH - 8;
  float spriteW = round(spriteH * (71.0 / 95.0));
  float cardW = spriteW;
  float cardSpacing = 18.0;
  float startCardX = 22.0 + cardW * 0.5;

  for (int i = 0; i < 3; i++) {
    targetCardX[i] = startCardX + i * (cardW + cardSpacing);
    slideCardX[i] = lerp(slideCardX[i], targetCardX[i], 0.28);

    float cx = slideCardX[i];
    float cy = rh * 0.5 + 4;

    if (tiendaOpciones[i] == -1 || tiendaComprado[i]) continue;

    int opCatIdx = tiendaOpciones[i];
    boolean isBought = tiendaComprado[i];
    boolean isSelected = (shopCardSeleccionada == i);
    boolean canAfford = tokensDolus >= tiendaPrecios[i];
    color colRare = getRarezaColor(tiendaPrecios[i]);

    boolean isHover = !isBought && (shopDescBoxTipo == 1 && shopDescBoxIdx == i);

    actualizarJuiceTienda(JUICE_CARDS_BASE + i, now);

    pushMatrix();
    translate(cx, cy);

    float targetLift = (isHover || isSelected) ? -10.0 : 0.0;
    hoverCardLift[i] = lerp(hoverCardLift[i], targetLift, 0.30);

    float targetTiltX = 0, targetTiltY = 0;
    if (isHover || isSelected) {
      targetTiltX = constrain(-(mouseY - (ry + cy)) / (cardH * 0.5) * 0.16, -0.22, 0.22);
      targetTiltY = constrain((mouseX - (rx + cx)) / (cardW * 0.5) * 0.16, -0.22, 0.22);
    } else {
      targetTiltX = sin(now * 2.3 + i * 1.4) * 0.025;
      targetTiltY = cos(now * 1.8 + i * 0.9) * 0.025;
    }
    hoverCardTiltX[i] = lerp(hoverCardTiltX[i], targetTiltX, 0.25);
    hoverCardTiltY[i] = lerp(hoverCardTiltY[i], targetTiltY, 0.25);

    translate(0, hoverCardLift[i]);
    scale(((isHover || isSelected) ? 1.05 : 1.0) + juiceTScale[JUICE_CARDS_BASE + i]);
    rotate(hoverCardTiltY[i] + juiceTRot[JUICE_CARDS_BASE + i]);

    rectMode(CENTER);

    float spriteCY = -btnH * 0.5;

    fill(0, 75);
    noStroke();
    ellipse(0, spriteCY + spriteH * 0.5 + 4, spriteW * 0.85, 12);

    if (plugCatImgTienda[opCatIdx] != null) {
      PImage imgTiendaSh = imgShaderDaltonismo(plugCatImgTienda[opCatIdx]);
      imageMode(CENTER);
      if (isBought) {
        tint(110, 160);
        image(imgTiendaSh, 0, spriteCY, spriteW, spriteH);
        noTint();
      } else {
        image(imgTiendaSh, 0, spriteCY, spriteW, spriteH);
      }
    } else {
      fill(red(colRare), green(colRare), blue(colRare), 35);
      stroke(colRare);
      rect(0, spriteCY, spriteW, spriteH, 6);
      fill(colRare);
      textSize(16);
      text(plugCatId[opCatIdx], 0, spriteCY);
    }

    if (isSelected) {
      noFill();
      stroke(255, 215, 80, 210 + 45 * sin(now * 8.0));
      strokeWeight(2.6);
      rect(0, spriteCY, spriteW + 4, spriteH + 4, 6);
    } else {
      if (isHover) {
        noFill();
        stroke(255, 175);
        strokeWeight(1.8);
        rect(0, spriteCY, spriteW + 2, spriteH + 2, 6);
      }
    }

    if (!isBought) {
      float foilSweep = (now * 240 + i * 65) % (spriteW * 2.5) - (spriteW * 1.25);
      if (foilSweep > -spriteW * 0.45 && foilSweep < spriteW * 0.45) {
        fill(255, 255, 255, 24);
        noStroke();
        rect(foilSweep, spriteCY, 18, spriteH - 8, 4);
      }
    }

    if (!isBought && pluginFormaSinergiaConInventario(tiendaOpciones[i])) {
      float pulsoSyn = 0.8 + 0.2 * sin(now * 6.0 + i);
      fill(25, 20, 4, 230);
      stroke(255, 215, 80, 240 * pulsoSyn);
      strokeWeight(1.4);
      rect(0, spriteCY - spriteH * 0.5 + 10, spriteW - 14, 16, 4);
      fill(255, 225, 95);
      textSize(8.5);
      textAlign(CENTER, CENTER);
      text("SINERGIA COMPATIBLE!", 0, spriteCY - spriteH * 0.5 + 9);
    }

    float btnY = spriteCY + spriteH * 0.5 + btnH * 0.5 + 4;
    float btnW = spriteW;

    float btnTopScreen = ry + cy + hoverCardLift[i] + btnY - btnH * 0.5;
    float btnBottomScreen = ry + cy + hoverCardLift[i] + btnY + btnH * 0.5;
    float btnLeftScreen = rx + cx - btnW * 0.5;
    float btnRightScreen = rx + cx + btnW * 0.5;
    boolean hovBtn = !tutorialTiendaActivo && (mouseX >= btnLeftScreen && mouseX <= btnRightScreen && mouseY >= btnTopScreen && mouseY <= btnBottomScreen);

    if (!isBought) {
      if (isSelected) {

        fill(0, 100);
        noStroke();
        rect(1, btnY + 2, btnW, btnH, 6);

        fill(canAfford ? (hovBtn ? color(255, 230, 85) : DOLUS_GOLD) : color(150, 45, 45));
        stroke(canAfford ? (hovBtn ? color(255, 255, 220) : color(255, 245, 185)) : color(220, 80, 80));
        strokeWeight(hovBtn ? 2.6 : 1.6);
        rect(0, btnY, btnW, btnH, 6);

        fill(canAfford ? color(20, 12, 0) : color(255));
        String txtCompra = "COMPRAR (" + tiendaPrecios[i] + " T)";
        float tamTxt = 16.0;
        textSize(tamTxt);
        while (textWidth(txtCompra) > btnW - 12 && tamTxt > 12.0) {
          tamTxt -= 0.5;
          textSize(tamTxt);
        }
        textAlign(CENTER, CENTER);
        text(txtCompra, 0, btnY - 1.5);
      } else {

        fill(10, 20, 16, 210);
        stroke(canAfford ? (isHover ? color(255, 215, 80) : color(130, 160, 140)) : color(140, 50, 50), 180);
        strokeWeight(isHover ? 1.8 : 1.2);
        rect(0, btnY, btnW, btnH, 6);

        fill(canAfford ? (isHover ? color(255, 230, 95) : DOLUS_GOLD) : color(200, 80, 80));
        String txtCoste = "COSTE: " + tiendaPrecios[i] + " T";
        float tamCoste = 15.0;
        textSize(tamCoste);
        while (textWidth(txtCoste) > btnW - 12 && tamCoste > 12.0) {
          tamCoste -= 0.5;
          textSize(tamCoste);
        }
        textAlign(CENTER, CENTER);
        text(txtCoste, 0, btnY - 1.5);
      }
    }

    popMatrix();
  }

  float rightOfCards = startCardX + 2 * (cardW + cardSpacing) + cardW * 0.5;
  float vCX = rightOfCards + (rw - rightOfCards) * 0.5;
  float vCY = rh * 0.5 + 4;

  if (catalogoVouchersInicializado && voucherTiendaActual >= 0 && voucherTiendaActual < 8 && !vouchComprado[voucherTiendaActual]) {
    int vIdx = voucherTiendaActual;
    boolean isVoucherSelected = shopVoucherSeleccionado;
    boolean canAffordVoucher = (tokensDolus >= vouchPrecio[vIdx]);
    boolean isVoucherHover = (shopDescBoxTipo == 2);

    actualizarJuiceTienda(JUICE_EXPLOIT_CARD, now);

    pushMatrix();
    translate(vCX, vCY);

    float targetVLift = (isVoucherHover || isVoucherSelected) ? -10.0 : 0.0;
    hoverVoucherLift = lerp(hoverVoucherLift, targetVLift, 0.30);

    float targetVTiltX = 0, targetVTiltY = 0;
    if (isVoucherHover || isVoucherSelected) {
      targetVTiltX = constrain(-(mouseY - (ry + vCY)) / (cardH * 0.5) * 0.16, -0.22, 0.22);
      targetVTiltY = constrain((mouseX - (rx + vCX)) / (cardW * 0.5) * 0.16, -0.22, 0.22);
    } else {
      targetVTiltX = sin(now * 2.1 + 1.2) * 0.025;
      targetVTiltY = cos(now * 1.7 + 0.8) * 0.025;
    }
    hoverVoucherTiltX = lerp(hoverVoucherTiltX, targetVTiltX, 0.25);
    hoverVoucherTiltY = lerp(hoverVoucherTiltY, targetVTiltY, 0.25);

    translate(0, hoverVoucherLift);
    scale(((isVoucherHover || isVoucherSelected) ? 1.05 : 1.0) + juiceTScale[JUICE_EXPLOIT_CARD]);
    rotate(hoverVoucherTiltY + juiceTRot[JUICE_EXPLOIT_CARD]);

    rectMode(CENTER);

    float spriteCY = -btnH * 0.5;

    fill(0, 75);
    noStroke();
    ellipse(0, spriteCY + spriteH * 0.5 + 4, spriteW * 0.85, 12);

    PImage sprVoucher = obtenerSpriteVoucherCrisp(vouchFrameIndex[vIdx], round(spriteW), round(spriteH));
    if (sprVoucher != null) {
      imageMode(CENTER);
      image(imgShaderDaltonismo(sprVoucher), 0, spriteCY, spriteW, spriteH);
    } else {
      fill(8, 26, 20, 240);
      stroke(0, 230, 160);
      strokeWeight(1.4);
      rect(0, spriteCY, spriteW, spriteH, 6);
    }

    if (isVoucherSelected) {
      noFill();
      stroke(0, 230, 160, 210 + 45 * sin(now * 8.0));
      strokeWeight(2.6);
      rect(0, spriteCY, spriteW + 4, spriteH + 4, 6);
    } else {
      if (isVoucherHover) {
        noFill();
        stroke(0, 230, 160, 175);
        strokeWeight(1.8);
        rect(0, spriteCY, spriteW + 2, spriteH + 2, 6);
      }
    }

    float foilSweepV = (now * 240) % (spriteW * 2.5) - (spriteW * 1.25);
    if (foilSweepV > -spriteW * 0.45 && foilSweepV < spriteW * 0.45) {
      fill(255, 255, 255, 26);
      noStroke();
      rect(foilSweepV, spriteCY, 18, spriteH - 8, 4);
    }

    fill(4, 24, 16, 235);
    stroke(0, 230, 160, 220);
    strokeWeight(1.4);
    rect(0, spriteCY - spriteH * 0.5 + 10, spriteW - 14, 16, 4);
    fill(0, 245, 175);
    textSize(8.5);
    textAlign(CENTER, CENTER);
    text("MODULO RAM // " + vouchTag[vIdx], 0, spriteCY - spriteH * 0.5 + 9);

    float vBtnY = spriteCY + spriteH * 0.5 + btnH * 0.5 + 4;
    float vBtnW = spriteW;

    float vBtnTopScreen = ry + vCY + hoverVoucherLift + vBtnY - btnH * 0.5;
    float vBtnBottomScreen = ry + vCY + hoverVoucherLift + vBtnY + btnH * 0.5;
    float vBtnLeftScreen = rx + vCX - vBtnW * 0.5;
    float vBtnRightScreen = rx + vCX + vBtnW * 0.5;
    boolean hovVBtn = !tutorialTiendaActivo && (mouseX >= vBtnLeftScreen && mouseX <= vBtnRightScreen && mouseY >= vBtnTopScreen && mouseY <= vBtnBottomScreen);

    if (isVoucherSelected) {
      fill(0, 100);
      noStroke();
      rect(1, vBtnY + 2, vBtnW, btnH, 6);

      fill(canAffordVoucher ? (hovVBtn ? color(40, 255, 180) : color(0, 185, 130)) : color(140, 45, 45));
      stroke(canAffordVoucher ? (hovVBtn ? color(240, 255, 250) : color(200, 255, 230)) : color(220, 80, 80));
      strokeWeight(hovVBtn ? 2.6 : 1.6);
      rect(0, vBtnY, vBtnW, btnH, 6);

      fill(canAffordVoucher ? color(10, 20, 15) : color(255));
      String txtVoucher = "COMPRAR (" + vouchPrecio[vIdx] + " T)";
      float tamV = 16.0;
      textSize(tamV);
      while (textWidth(txtVoucher) > vBtnW - 12 && tamV > 12.0) {
        tamV -= 0.5;
        textSize(tamV);
      }
      textAlign(CENTER, CENTER);
      text(txtVoucher, 0, vBtnY - 1.5);
    } else {
      fill(8, 22, 16, 210);
      stroke(canAffordVoucher ? (isVoucherHover ? color(80, 255, 200) : color(0, 185, 130)) : color(140, 50, 50), 180);
      strokeWeight(isVoucherHover ? 1.8 : 1.2);
      rect(0, vBtnY, vBtnW, btnH, 6);

      fill(canAffordVoucher ? (isVoucherHover ? color(120, 255, 215) : color(0, 230, 160)) : color(200, 80, 80));
      String txtCosteV = "COSTE: " + vouchPrecio[vIdx] + " T";
      float tamCosteV = 15.0;
      textSize(tamCosteV);
      while (textWidth(txtCosteV) > vBtnW - 12 && tamCosteV > 12.0) {
        tamCosteV -= 0.5;
        textSize(tamCosteV);
      }
      textAlign(CENTER, CENTER);
      text(txtCosteV, 0, vBtnY - 1.5);
    }

    popMatrix();
  }

  popMatrix();
}

void dibujarFilaBoosterPacks(float rx, float ry, float rw, float rh, color colG, color colBgPanel, float now) {
  pushMatrix();
  translate(rx, ry);

  fill(colBgPanel);
  stroke(DOLUS_PURPLE);
  strokeWeight(2.5);
  dibujarFormaAngularBase(rw, rh, 18);
  dibujarTexturaCyberGrid(rw, rh, DOLUS_PURPLE);

  if (!packsCargados || imgPacks[0] == null) {
    cargarSpritesheetPacks();
  }

  float cardH = rh - 22;
  float btnH = 36;
  float badgeH = 18;
  float gap = 6;
  float spriteH = cardH - btnH - badgeH - gap * 2;
  float spriteW = round(spriteH * (284.0 / 400.0));
  float packW = spriteW;
  float packSpacing = max(24.0, (rw - 40.0 - 3 * packW) / 4.0);
  float totalPacksW = 3 * packW + 2 * packSpacing;
  float startPackX = (rw - totalPacksW) * 0.5 + packW * 0.5;

  for (int p = 0; p < 3; p++) {
    targetPackX[p] = startPackX + p * (packW + packSpacing);
    slidePackX[p] = lerp(slidePackX[p], targetPackX[p], 0.28);

    float pcx = slidePackX[p];
    float pcy = rh * 0.5 + 4;

    if (tiendaPacksComprado[p]) continue;

    int pTipo = tiendaPacksTipo[p];
    boolean isBought = tiendaPacksComprado[p];
    boolean canAfford = (tokensDolus >= tiendaPacksPrecio[p]);
    boolean isSelectedPack = (shopPackSeleccionado == p);
    boolean hovPack = !isBought && (shopDescBoxTipo == 3 && shopDescBoxIdx == p);

    actualizarJuiceTienda(JUICE_PACKS_BASE + p, now);

    pushMatrix();
    translate(pcx, pcy);

    float flotePack = !isBought ? sin(now * 2.2 + p * 1.3) * 3.5 : 0;
    float rotFlote = !isBought ? sin(now * 1.8 + p * 1.0) * 0.025 : 0;

    float targetLift = (hovPack || isSelectedPack) ? -10.0 : 0.0;
    hoverPackLift[p] = lerp(hoverPackLift[p], targetLift, 0.30);

    float targetTiltX = 0, targetTiltY = 0;
    if (hovPack || isSelectedPack) {
      targetTiltX = constrain(-(mouseY - (ry + pcy)) / (cardH * 0.5) * 0.16, -0.22, 0.22);
      targetTiltY = constrain((mouseX - (rx + pcx)) / (packW * 0.5) * 0.16, -0.22, 0.22);
    } else {
      targetTiltX = sin(now * 2.3 + p * 1.4) * 0.025;
      targetTiltY = cos(now * 1.8 + p * 0.9) * 0.025;
    }
    hoverPackTiltX[p] = lerp(hoverPackTiltX[p], targetTiltX, 0.25);
    hoverPackTiltY[p] = lerp(hoverPackTiltY[p], targetTiltY, 0.25);

    translate(0, flotePack + hoverPackLift[p]);
    scale(((hovPack || isSelectedPack) ? 1.05 : 1.0) + juiceTScale[JUICE_PACKS_BASE + p]);
    rotate(hoverPackTiltY[p] + rotFlote + juiceTRot[JUICE_PACKS_BASE + p]);

    rectMode(CENTER);

    float badgeY = -cardH * 0.5 + badgeH * 0.5;
    float spriteCY = badgeY + badgeH * 0.5 + gap + spriteH * 0.5;
    float btnY = spriteCY + spriteH * 0.5 + gap + btnH * 0.5;
    float btnW = spriteW;
    float badgeW = spriteW;

    fill(0, 75);
    noStroke();
    ellipse(0, btnY + btnH * 0.5 + 4, packW * 0.85, 12);

    fill(16, 12, 26, 230);
    stroke(color(255, 215, 80, 220));
    strokeWeight(1.4);
    rect(0, badgeY, badgeW, badgeH, 4);

    fill(color(255, 220, 90));
    textSize(8.5);
    textAlign(CENTER, CENTER);
    text(packSubtitulo[pTipo], 0, badgeY - 1);

    PImage spritePack = (packFrameIndex[pTipo] >= 0 && packFrameIndex[pTipo] < 4) ? imgPacks[packFrameIndex[pTipo]] : null;
    if (spritePack != null) {
      imageMode(CENTER);
      image(imgShaderDaltonismo(spritePack), 0, spriteCY, spriteW, spriteH);
    } else {
      fill(DOLUS_PURPLE);
      stroke(255);
      rect(0, spriteCY, spriteW, spriteH, 8);
    }

    float foilSweep = (now * 220 + p * 70) % (spriteW * 2.5) - (spriteW * 1.25);
    if (foilSweep > -spriteW * 0.45 && foilSweep < spriteW * 0.45) {
      fill(255, 255, 255, 30);
      noStroke();
      rect(foilSweep, spriteCY, 20, spriteH - 8, 4);
    }

    if (isSelectedPack) {
      noFill();
      stroke(255, 220, 100, 240);
      strokeWeight(2.6);
      rect(0, spriteCY, spriteW + 4, spriteH + 4, 6);
    } else {
      if (hovPack) {
        noFill();
        stroke(255, 220, 100, 180);
        strokeWeight(1.8);
        rect(0, spriteCY, spriteW + 2, spriteH + 2, 6);
      }
    }

    float btnTopScreen = ry + pcy + flotePack + hoverPackLift[p] + btnY - btnH * 0.5;
    float btnBottomScreen = ry + pcy + flotePack + hoverPackLift[p] + btnY + btnH * 0.5;
    float btnLeftScreen = rx + pcx - btnW * 0.5;
    float btnRightScreen = rx + pcx + btnW * 0.5;
    boolean hovBtn = !tutorialTiendaActivo && (mouseX >= btnLeftScreen && mouseX <= btnRightScreen && mouseY >= btnTopScreen && mouseY <= btnBottomScreen);

    if (isSelectedPack) {
      fill(0, 100);
      noStroke();
      rect(1, btnY + 2, btnW, btnH, 6);

      fill(canAfford ? (hovBtn ? color(210, 120, 250) : DOLUS_PURPLE) : color(120, 40, 40));
      stroke(canAfford ? (hovBtn ? color(255, 235, 255) : color(255, 200, 255)) : color(200, 60, 60));
      strokeWeight(hovBtn ? 2.6 : 1.6);
      rect(0, btnY, btnW, btnH, 6);

      fill(255);
      String txtPack = "ABRIR (" + tiendaPacksPrecio[p] + " T)";
      float tamP = 16.0;
      textSize(tamP);
      while (textWidth(txtPack) > btnW - 12 && tamP > 12.0) {
        tamP -= 0.5;
        textSize(tamP);
      }
      textAlign(CENTER, CENTER);
      text(txtPack, 0, btnY - 1.5);
    } else {
      fill(16, 10, 26, 210);
      stroke(canAfford ? (hovPack ? color(220, 130, 255) : color(red(DOLUS_PURPLE)*0.8, green(DOLUS_PURPLE)*0.8, blue(DOLUS_PURPLE)*0.8)) : color(140, 50, 50), 180);
      strokeWeight(hovPack ? 1.8 : 1.2);
      rect(0, btnY, btnW, btnH, 6);

      fill(canAfford ? (hovPack ? color(230, 160, 255) : color(200, 120, 240)) : color(200, 80, 80));
      String txtCosteP = "COSTE: " + tiendaPacksPrecio[p] + " T";
      float tamCosteP = 15.0;
      textSize(tamCosteP);
      while (textWidth(txtCosteP) > btnW - 12 && tamCosteP > 12.0) {
        tamCosteP -= 0.5;
        textSize(tamCosteP);
      }
      textAlign(CENTER, CENTER);
      text(txtCosteP, 0, btnY - 1.5);
    }

    popMatrix();
  }

  popMatrix();
}

void dibujarCajaDescripcionTienda(float mainX, float mainW, float startY, float totalH, float row1H, float row2Y, float row2H, color colG, float now) {
  if (!shopDescBoxActiva || shopDescBoxTipo <= 0 || animandoTransicionTienda) {
    return;
  }

  float cardH = row1H - 22;
  float btnH = 36;
  float spriteH = cardH - btnH - 8;
  float spriteW = round(spriteH * (71.0 / 95.0));
  float cardW = spriteW;
  float cardSpacing = 18.0;
  float startCardX = 22.0 + cardW * 0.5;

  float rightOfCards = startCardX + 2 * (cardW + cardSpacing) + cardW * 0.5;
  float vCX = rightOfCards + (mainW - rightOfCards) * 0.5;

  float cardHPack = row2H - 22;
  float btnHPack = 36;
  float badgeHPack = 18;
  float gapPack = 6;
  float spriteHPack = cardHPack - btnHPack - badgeHPack - gapPack * 2;
  float spriteWPack = round(spriteHPack * (284.0 / 400.0));
  float packW = spriteWPack;

  float tipW = 410;
  float tipH = 220;
  float tipX = 0;
  float tipY = 0;

  pushStyle();
  pushMatrix();

  if (shopDescBoxTipo == 1) {

    int idx = shopDescBoxIdx;
    if (idx < 0 || idx >= 3 || tiendaOpciones[idx] == -1 || tiendaComprado[idx]) {
      popMatrix(); popStyle(); return;
    }
    int pSelIdx = tiendaOpciones[idx];
    color colRareSel = getRarezaColor(tiendaPrecios[idx]);
    boolean isSel = (shopCardSeleccionada == idx);

    float selCX = mainX + slideCardX[idx];
    float selCY = startY + row1H * 0.5 + 4;

    tipX = selCX + cardW * 0.5 + 16;
    if (tipX + tipW > mainX + mainW - 16) {
      tipX = selCX - cardW * 0.5 - 16 - tipW;
    }
    tipY = constrain(selCY - tipH * 0.5, startY + 12, startY + row1H - tipH - 12);

    shopDescBoxX = tipX;
    shopDescBoxY = tipY;
    shopDescBoxW = tipW;
    shopDescBoxH = tipH;

    translate(tipX, tipY);
    rectMode(CORNER);

    fill(0, 190);
    noStroke();
    rect(5, 6, tipW, tipH, 8);

    fill(6, 14, 10, 252);
    stroke(colRareSel);
    strokeWeight(2.0);
    rect(0, 0, tipW, tipH, 8);

    fill(red(colRareSel) * 0.35, green(colRareSel) * 0.35, blue(colRareSel) * 0.35, 240);
    noStroke();
    rect(0, 0, tipW, 28, 8, 8, 0, 0);

    fill(255);
    textSize(12);
    textAlign(LEFT, CENTER);
    text(plugCatId[pSelIdx] + " // " + plugCatCategoria[pSelIdx], 12, 14);

    textAlign(RIGHT, CENTER);
    fill(colRareSel);
    text(getRarezaNombre(tiendaPrecios[idx]) + " [" + tiendaPrecios[idx] + " T]", tipW - 12, 14);

    fill(255, 215, 80);
    textSize(11);
    textAlign(LEFT, TOP);
    text("> EFECTO PASIVO (EN COMBATE):", 14, 38);

    dibujarTextoDinamicoOptimizado(
      plugCatDescripcionPasiva[pSelIdx],
      14, 54, tipW - 28, 48, color(225, 240, 230), 14.5
    );

    stroke(colG, 50);
    strokeWeight(1);
    line(14, 110, tipW - 14, 110);

    fill(colG);
    textSize(11);
    textAlign(LEFT, TOP);
    String actHeader = "> HABILIDAD ACTIVA: " + plugCatNombreActiva[pSelIdx];
    if (plugCatCostoTokensActiva[pSelIdx] > 0) actHeader += " [" + plugCatCostoTokensActiva[pSelIdx] + "T]";
    if (plugCatCooldownActivaSegundos[pSelIdx] > 0) actHeader += " [CD: " + plugCatCooldownActivaSegundos[pSelIdx] + "s]";
    text(actHeader, 14, 118);

    dibujarTextoDinamicoOptimizado(
      plugCatDescripcionActiva[pSelIdx],
      14, 134, tipW - 28, 46, color(210, 235, 220), 14.5
    );

    float footY = tipH - 20;
    String compComp = obtenerCompanerosSinergiaCompatible(tiendaOpciones[idx]);
    if (!compComp.equals("")) {
      dibujarTextoSinergiaBanner("SINERGIA COMPATIBLE CON: " + compComp, 14, footY, tipW - 28, 9.5, 255, CENTER);
    } else {
      if (pluginFormaSinergiaConInventario(tiendaOpciones[idx])) {
        dibujarTextoSinergiaBanner("SINERGIA COMPATIBLE CON TU EQUIPO!", 14, footY, tipW - 28, 9.5, 255, CENTER);
      } else {
        if (isSel) {
          fill(255, 215, 80);
          textSize(9.5);
          textAlign(LEFT, CENTER);
          text(">> SELECCIONADO: Pulsa en COMPRAR para instalar <<", 14, footY);
        } else {
          fill(140, 195, 175);
          textSize(9.5);
          textAlign(LEFT, CENTER);
          text(">> Haz CLICK en la carta para desplegar el boton COMPRAR <<", 14, footY);
        }
      }
    }

  } else {
    if (shopDescBoxTipo == 2) {

      if (!catalogoVouchersInicializado || voucherTiendaActual < 0 || voucherTiendaActual >= 8 || vouchComprado[voucherTiendaActual]) {
        popMatrix(); popStyle(); return;
      }
      int vIdx = voucherTiendaActual;
      color colVoucher = color(0, 230, 160);
      boolean isSel = shopVoucherSeleccionado;

      float vScreenCX = mainX + vCX;
      float vScreenCY = startY + row1H * 0.5 + 4;

      tipX = constrain(vScreenCX - cardW * 0.5 - 16 - tipW, mainX + 16, mainX + mainW - tipW - 16);
      tipY = constrain(vScreenCY - tipH * 0.5, startY + 12, startY + row1H - tipH - 12);

      shopDescBoxX = tipX;
      shopDescBoxY = tipY;
      shopDescBoxW = tipW;
      shopDescBoxH = tipH;

      translate(tipX, tipY);
      rectMode(CORNER);

      fill(0, 190);
      noStroke();
      rect(5, 6, tipW, tipH, 8);

      fill(6, 18, 14, 252);
      stroke(colVoucher);
      strokeWeight(2.0);
      rect(0, 0, tipW, tipH, 8);

      fill(0, 70, 48, 240);
      noStroke();
      rect(0, 0, tipW, 28, 8, 8, 0, 0);

      fill(255);
      textSize(12);
      textAlign(LEFT, CENTER);
      text(vouchTag[vIdx] + " // " + vouchNombre[vIdx], 12, 14);

      textAlign(RIGHT, CENTER);
      fill(colVoucher);
      text("MODULO RAM [" + vouchPrecio[vIdx] + " T]", tipW - 12, 14);

      fill(255, 215, 80);
      textSize(11);
      textAlign(LEFT, TOP);
      text("> CATEGORIA: " + vouchSubtitulo[vIdx], 14, 38);

      dibujarTextoDinamicoOptimizado(
        vouchDescripcion[vIdx],
        14, 56, tipW - 28, 108, color(220, 255, 240), 15.0
      );

      float footY = tipH - 20;
      if (isSel) {
        fill(0, 245, 175);
        textSize(9.5);
        textAlign(LEFT, CENTER);
        text(">> SELECCIONADO: Pulsa en COMPRAR para instalar mejora permanente <<", 14, footY);
      } else {
        fill(140, 195, 175);
        textSize(9.5);
        textAlign(LEFT, CENTER);
        text(">> Haz CLICK en el modulo para desplegar el boton COMPRAR <<", 14, footY);
      }

    } else {
      if (shopDescBoxTipo == 3) {

        int p = shopDescBoxIdx;
        if (p < 0 || p >= 3 || tiendaPacksComprado[p]) {
          popMatrix(); popStyle(); return;
        }
        int pTipo = tiendaPacksTipo[p];
        color colPack = DOLUS_PURPLE;
        boolean isSel = (shopPackSeleccionado == p);
        tipH = 200;

        float pScreenCX = mainX + slidePackX[p];
        float pScreenCY = row2Y + row2H * 0.5 + 4;

        tipX = pScreenCX + packW * 0.5 + 16;
        if (tipX + tipW > mainX + mainW - 16) {
          tipX = pScreenCX - packW * 0.5 - 16 - tipW;
        }
        tipY = constrain(pScreenCY - tipH * 0.5, row2Y + 12, row2Y + row2H - tipH - 12);

        shopDescBoxX = tipX;
        shopDescBoxY = tipY;
        shopDescBoxW = tipW;
        shopDescBoxH = tipH;

        translate(tipX, tipY);
        rectMode(CORNER);

        fill(0, 190);
        noStroke();
        rect(5, 6, tipW, tipH, 8);

        fill(14, 8, 22, 252);
        stroke(colPack);
        strokeWeight(2.0);
        rect(0, 0, tipW, tipH, 8);

        fill(red(colPack) * 0.45, green(colPack) * 0.45, blue(colPack) * 0.45, 240);
        noStroke();
        rect(0, 0, tipW, 28, 8, 8, 0, 0);

        fill(255);
        textSize(12);
        textAlign(LEFT, CENTER);
        text(packNombre[pTipo] + " // " + packSubtitulo[pTipo], 12, 14);

        textAlign(RIGHT, CENTER);
        fill(color(230, 160, 255));
        text("BOOSTER PACK [" + tiendaPacksPrecio[p] + " T]", tipW - 12, 14);

        fill(255, 215, 80);
        textSize(11);
        textAlign(LEFT, TOP);
        text("> MECANICA DE APERTURA:", 14, 38);

        dibujarTextoDinamicoOptimizado(
          packDescripcion[pTipo],
          14, 56, tipW - 28, 70, color(235, 220, 255), 14.5
        );

        fill(DOLUS_GOLD);
        textSize(10);
        textAlign(LEFT, CENTER);
        text("* Coste: " + tiendaPacksPrecio[p] + " Tokens. Elige " + packNumElecciones[pTipo] + " de " + packNumOpciones[pTipo] + " protocolos.", 14, tipH - 34);

        float footY = tipH - 16;
        if (isSel) {
          fill(220, 140, 255);
          textSize(9.5);
          textAlign(LEFT, CENTER);
          text(">> SELECCIONADO: Pulsa en ABRIR para desencriptar el sobre <<", 14, footY);
        } else {
          fill(180, 160, 210);
          textSize(9.5);
          textAlign(LEFT, CENTER);
          text(">> Haz CLICK en el sobre para desplegar el boton ABRIR <<", 14, footY);
        }
      }
    }
  }

  popMatrix();
  popStyle();
}

void dibujarPanelBoosterAnimacion(float bx, float by, float bw, float bh, color colG, color colBgPanel, float now) {
  pushMatrix();
  translate(bx, by);

  fill(colBgPanel);
  stroke(DOLUS_PURPLE);
  strokeWeight(2.5);
  dibujarFormaAngularBase(bw, bh, 18);
  dibujarTexturaCyberGrid(bw, bh, DOLUS_PURPLE);

  fill(DOLUS_PURPLE);
  textSize(13);
  textAlign(LEFT, TOP);
  text("// DESENCRIPTANDO MATRIZ DE DATOS // BOOSTER PACK...", 20, 14);

  pushMatrix();
  translate(bw * 0.5, bh * 0.5);
  rotate(now * 0.22);
  fill(DOLUS_PURPLE, 14);
  noStroke();
  for (int i = 0; i < 16; i++) {
    rotate(TWO_PI / 16);
    triangle(0, 0, -35, -bw * 0.65, 35, -bw * 0.65);
  }
  popMatrix();

  popMatrix();

  actualizarYDibujarAnimBooster(now);
}

void dibujarPanelBoosterEnTienda(float bx, float by, float bw, float bh, color colG, color colBgPanel, float now) {
  pushMatrix();
  translate(bx, by);

  fill(colBgPanel);
  stroke(DOLUS_PURPLE);
  strokeWeight(2.5);
  dibujarFormaAngularBase(bw, bh, 18);
  dibujarTexturaCyberGrid(bw, bh, DOLUS_PURPLE);

  pushMatrix();
  translate(bw * 0.5, bh * 0.5);
  rotate(now * 0.18);
  fill(DOLUS_PURPLE, 12);
  noStroke();
  for (int i = 0; i < 16; i++) {
    rotate(TWO_PI / 16);
    triangle(0, 0, -35, -bw * 0.65, 35, -bw * 0.65);
  }
  popMatrix();

  int pTipo = (tipoPackTiendaActual >= 0 && tipoPackTiendaActual < 4) ? tipoPackTiendaActual : 0;

  textAlign(CENTER, TOP);
  textSize(18);
  fill(DOLUS_PURPLE);
  text(packNombre[pTipo] + " // PROTOCOLOS CLASIFICADOS", bw * 0.5, 14);

  textSize(12);
  fill(255);
  String subTextoEleccion = (boosterEleccionesRestantes > 1)
    ? ("ELIGE " + boosterEleccionesRestantes + " PROTOCOLOS PARA TU EQUIPO")
    : "ELIGE 1 PROTOCOLO PARA TU EQUIPO";
  text(subTextoEleccion, bw * 0.5, 36);

  int totalCards = numOpcionesBooster;
  float cardW = (totalCards <= 3) ? min(180.0, (bw - 100.0) / 3.0) : min(148.0, (bw - 80.0) / 5.0);
  float cardH = min(bh * 0.60, round(cardW * (95.0 / 71.0)));
  float gap = (totalCards <= 3) ? 26.0 : 14.0;
  float totalRowW = totalCards * cardW + (totalCards - 1) * gap;
  float startCardX = (bw - totalRowW) * 0.5 + cardW * 0.5;
  float cardCenterY = bh * 0.5 + 4;

  for (int i = 0; i < totalCards; i++) {
    int catIdx = opcionesBooster[i];
    color colRare = getRarezaColor(plugCatPrecioTokens[catIdx]);
    boolean yaTomada = (i < 5 && boosterOpcionTomada[i]);

    if (yaTomada) continue;

    float cx = startCardX + i * (cardW + gap);
    float cy = cardCenterY;

    boolean hov = evaluarHover(bx + cx, by + cy, cardW, cardH);
    if (hov) {
      pluginHoverInspector = catIdx;
      tipoHoverInspector = "BOOSTER_CANDIDATE";
    }

    actualizarJuiceTienda(JUICE_BOOSTER_OPTS_BASE + i, now);

    pushMatrix();
    translate(cx, cy);
    float liftY = hov ? -10.0 : 0.0;
    translate(0, liftY);
    scale((hov ? 1.05 : 1.0) + juiceTScale[JUICE_BOOSTER_OPTS_BASE + i]);
    rotate(juiceTRot[JUICE_BOOSTER_OPTS_BASE + i]);

    rectMode(CENTER);

    float btnH = 28;
    float spriteH = cardH - btnH - 6;
    float spriteW = round(spriteH * (71.0 / 95.0));
    float spriteCY = -btnH * 0.5;

    fill(0, 85);
    noStroke();
    ellipse(0, spriteCY + spriteH * 0.5 + 4, spriteW * 0.85, 12);

    PImage sprite = (plugCatImgTienda[catIdx] != null) ? plugCatImgTienda[catIdx] : ((plugCatImgSpriteRaw[catIdx] != null) ? plugCatImgSpriteRaw[catIdx] : plugCatImgBase[catIdx]);
    if (sprite != null) {
      imageMode(CENTER);
      image(imgShaderDaltonismo(sprite), 0, spriteCY, spriteW, spriteH);
    } else {
      fill(red(colRare), green(colRare), blue(colRare), 40);
      stroke(colRare);
      rect(0, spriteCY, spriteW, spriteH, 6);
      fill(colRare);
      textSize(16);
      textAlign(CENTER, CENTER);
      text(plugCatId[catIdx], 0, spriteCY);
    }

    if (hov) {
      noFill();
      stroke(255, 220, 100, 220);
      strokeWeight(2.4);
      rect(0, spriteCY, spriteW + 4, spriteH + 4, 6);
    }

    float btnY = spriteCY + spriteH * 0.5 + btnH * 0.5 + 3;
    fill(DOLUS_PURPLE);
    stroke(hov ? color(255) : color(255, 180, 255));
    strokeWeight(hov ? 1.8 : 1.2);
    rect(0, btnY, spriteW, btnH, 5);

    fill(255);
    textSize(10);
    textAlign(CENTER, CENTER);
    text("INSTALAR PROTOCOLO", 0, btnY - 1);

    popMatrix();
  }

  float btnSkipW = min(220.0, bw * 0.32);
  float btnSkipH = 32;
  float btnSkipX = bw * 0.5;
  float btnSkipY = bh - btnSkipH * 0.5 - 12;
  boolean hovSkip = evaluarHover(bx + btnSkipX, by + btnSkipY, btnSkipW, btnSkipH);

  dibujarBotonSquishyDolus("OMITIR / SALIR", btnSkipX, btnSkipY, btnSkipW, btnSkipH, color(75, 30, 30), 11, hovSkip, -1);

  popMatrix();
}

void dibujarTerminalDiagnosticoTooltip(int catIdx, String tipo, color colG) {

  if (tipo.equals("TIENDA") || tipo.equals("VOUCHER_INFO") || tipo.equals("BOOSTER_INFO")) return;

  float tipW = 390;
  float tipH = 205;
  float tipX = constrain(mouseX + 20, 25, width - tipW - 25);
  float tipY = constrain(mouseY - tipH - 15, 25, height - tipH - 25);

  if (slotSeleccionadoVenta >= 1 && slotSeleccionadoVenta < 5 && tipo.equals("EQUIPADO")) {
    float topY = height * 0.03;
    float topH = height * 0.20;
    float cx = plugBaseX[slotSeleccionadoVenta];
    tipX = constrain(cx - tipW * 0.5, 25, width - tipW - 25);
    tipY = topY + topH + 12;
  }

  pushStyle();
  pushMatrix();
  translate(tipX, tipY);

  rectMode(CORNER);
  fill(0, 160);
  noStroke();
  rect(4, 5, tipW, tipH, 8);

  fill(6, 14, 10, 252);
  stroke(colG);
  strokeWeight(2.0);
  rect(0, 0, tipW, tipH, 8);

  if (catIdx >= 0 && catIdx < numCatalogoPlugins) {
    color colRare = getRarezaColor(plugCatPrecioTokens[catIdx]);

    fill(colRare);
    stroke(colRare);
    strokeWeight(1);
    line(12, 34, tipW - 12, 34);

    fill(colRare);
    textSize(13);
    textAlign(LEFT, TOP);
    text(plugCatId[catIdx] + " // " + plugCatCategoria[catIdx], 14, 12);

    fill(255, 215, 80);
    textSize(11);
    textAlign(LEFT, TOP);
    text("> EFECTO PASIVO (EN COMBATE):", 14, 40);
    dibujarTextoDinamicoOptimizado(plugCatDescripcionPasiva[catIdx], 14, 56, tipW - 28, 48, color(220), 14.0);

    fill(colG);
    textSize(11);
    textAlign(LEFT, TOP);
    String txtActivaHeader = "> HABILIDAD ACTIVA";
    if (plugCatCostoTokensActiva[catIdx] > 0) txtActivaHeader += " [COSTE: " + plugCatCostoTokensActiva[catIdx] + "T]";
    if (plugCatCooldownActivaSegundos[catIdx] > 0) txtActivaHeader += " [CD: " + plugCatCooldownActivaSegundos[catIdx] + "s]";
    text(txtActivaHeader + ":", 14, 110);
    dibujarTextoDinamicoOptimizado(plugCatDescripcionActiva[catIdx], 14, 126, tipW - 28, 48, color(220), 14.0);

    String compSynActiva = obtenerCompanerosSinergiaActiva(catIdx);
    if (!compSynActiva.equals("")) {
      dibujarTextoSinergiaBanner("SINERGIA ACTIVA CON: " + compSynActiva, 14, tipH - 8, tipW - 28, 10.0, 255, BOTTOM);
    } else {
      if (pluginFormaSinergiaConInventario(catIdx)) {
        String compSynComp = obtenerCompanerosSinergiaCompatible(catIdx);
        String txtComp = !compSynComp.equals("") ? ("SINERGIA COMPATIBLE CON: " + compSynComp) : "* SINERGIA DETECTADA CON TU EQUIPO";
        dibujarTextoSinergiaBanner(txtComp, 14, tipH - 8, tipW - 28, 10.0, 255, BOTTOM);
      }
    }

  } else {
    if (tipo.equals("BOOSTER_INFO")) {
      int pTipo = (tipoPackTiendaActual >= 0 && tipoPackTiendaActual < 4) ? tipoPackTiendaActual : 0;
      fill(DOLUS_PURPLE);
      textSize(14);
      textAlign(LEFT, TOP);
      text(packNombre[pTipo] + " // " + packSubtitulo[pTipo], 14, 12);

      fill(255);
      textSize(11);
      textAlign(LEFT, TOP);
      text("> MECANICA DE APERTURA:", 14, 44);
      dibujarTextoDinamicoOptimizado(packDescripcion[pTipo], 14, 60, tipW - 28, 56, color(210), 14.0);

      fill(DOLUS_GOLD);
      textSize(10);
      text("* Coste: " + packPrecio[pTipo] + " Tokens. Elige " + packNumElecciones[pTipo] + " de " + packNumOpciones[pTipo] + " protocolos.", 14, tipH - 18);

    } else {
      if (tipo.equals("EXPLOIT_INFO") || tipo.equals("VOUCHER_INFO")) {
        if (catalogoVouchersInicializado && voucherTiendaActual >= 0 && voucherTiendaActual < 8) {
          int vIdx = voucherTiendaActual;
          fill(0, 230, 160);
          textSize(14);
          textAlign(LEFT, TOP);
          text("MODULO RAM // " + vouchNombre[vIdx], 14, 12);

          fill(255);
          textSize(11);
          textAlign(LEFT, TOP);
          text("> MEJORA PERMANENTE (VOUCHER):", 14, 44);
          dibujarTextoDinamicoOptimizado(vouchDescripcion[vIdx], 14, 60, tipW - 28, 56, color(210), 14.0);

          fill(0, 230, 160);
          textSize(10);
          text("* Efecto permanente activo durante toda la partida.", 14, tipH - 18);
        }
      }
    }
  }

  popMatrix();
  popStyle();
}

void dibujarBotonSquishyDolus(String texto, float cx, float cy, float bw, float bh, color colBase, float tamTexto, boolean isHover, int juiceIdx) {
  pushStyle();
  pushMatrix();
  translate(cx, cy);

  float escJuice = (juiceIdx >= 0 && juiceIdx < 20) ? juiceTScale[juiceIdx] : 0.0;
  float rotJuice = (juiceIdx >= 0 && juiceIdx < 20) ? juiceTRot[juiceIdx] : 0.0;
  scale((isHover ? 1.04 : 1.0) + escJuice);
  rotate(rotJuice);

  rectMode(CENTER);

  fill(0, 120);
  noStroke();
  rect(2, 4, bw, bh, 6);

  fill(colBase);
  stroke(isHover ? color(255) : color(red(colBase) * 0.6, green(colBase) * 0.6, blue(colBase) * 0.6));
  strokeWeight(isHover ? 2.5 : 1.5);
  rect(0, 0, bw, bh, 6);

  fill(255);
  textSize(tamTexto);
  textAlign(CENTER, CENTER);
  text(texto, 0, -1);

  popMatrix();
  popStyle();
}

void mousePressedTienda() {
  if (animandoTransicionTienda) return;
  if (mousePressedTutorialTienda()) return;
  float now = millis() / 1000.0;
  float margin = width * 0.02;
  float topY = height * 0.03;
  float topH = height * 0.20;
  float startY = topY + topH + height * 0.02;
  float totalH = height * 0.72;

  float leftW = width * 0.26;
  float mainX = margin + leftW + width * 0.02;
  float mainW = width - mainX - margin;

  float row1H = (totalH - 16) * 0.50;
  float row2H = totalH - row1H - 16;
  float row2Y = startY + row1H + 16;
  float halfW = (mainW - 16) * 0.5;

  actualizarPosicionesSlotsTienda();
  int totalSlotsRack = limiteMaxSlotsRack();
  float rackCardW = anchoRectPlugin * escalaSlot;
  float rackCardH = altoRectPlugin * escalaSlot;

  float cxMaster = plugBaseX[0];
  float cyMaster = plugBaseY[0];
  if (evaluarHover(cxMaster, cyMaster, rackCardW, rackCardH)) {
    dispararJuiceTienda(JUICE_SLOTS_BASE + 0, 0.30, random(-0.15, 0.15));
    if (sonidoErrorMsj != null) reproducirSFX(sonidoErrorMsj);
    dispararTextoElastico("SLOT MAESTRO FIJO!", cxMaster, cyMaster - 30, color(255, 215, 80));
    slotSeleccionadoVenta = -1;
    return;
  }

  for (int i = 1; i < totalSlotsRack; i++) {
    int invIdx = i - 1;
    if (invIdx >= 0 && invIdx < numInventarioPlugins) {
      float cx = plugBaseX[i];
      float cy = plugBaseY[i];
      int invCatIdx = inventarioPlugins[invIdx];
      int ganancia = max(1, plugCatPrecioTokens[invCatIdx] / 2);

      float btnVentaH = 28;
      float btnVentaW = rackCardW * 0.88;
      float btnVentaY = cy + rackCardH * 0.5 - btnVentaH * 0.5 - 6;

      boolean clickEnBotonVenta = (slotSeleccionadoVenta == i) && evaluarHover(cx, btnVentaY, btnVentaW, btnVentaH);
      boolean clickEnSlot = evaluarHover(cx, cy, rackCardW, rackCardH);

      if (clickEnBotonVenta) {

        dispararJuiceTienda(JUICE_SLOTS_BASE + i, 0.40, 0.20);
        venderPlugin(invIdx);
        slotSeleccionadoVenta = -1;

        if (sonidoTransferenciaExitosa != null) reproducirSFX(sonidoTransferenciaExitosa);
        dispararExplosionCarta(cx, cy, color(255, 215, 80), false);
        dispararTextoElastico("+" + ganancia + " TOKENS", cx, cy - 30, color(255, 215, 80));
        dispararSacudidaCamara(2.2);
        return;
      } else {
        if (clickEnSlot) {
          if (slotSeleccionadoVenta == i) {

            slotSeleccionadoVenta = -1;
            reproducirTap();
          } else {

            slotSeleccionadoVenta = i;
            dispararJuiceTienda(JUICE_SLOTS_BASE + i, 0.28, -0.10);
            if (sndClickPlugin != null) reproducirSFX(sndClickPlugin);
          }
          return;
        }
      }
    }
  }

  if (estadoTienda == TIENDA_ESTADO_BOOSTER_ANIM) {

    return;
  }

  if (estadoTienda == TIENDA_ESTADO_BOOSTER) {

    float btnSkipW = min(220.0, mainW * 0.32);
    float btnSkipH = 32;
    float btnSkipX = mainX + mainW * 0.5;
    float btnSkipY = startY + totalH - btnSkipH * 0.5 - 12;

    if (evaluarHover(btnSkipX, btnSkipY, btnSkipW, btnSkipH)) {
      reproducirTap();
      estadoTienda = TIENDA_ESTADO_NORMAL;
      slotSeleccionadoVenta = -1;
      return;
    }

    int totalCards = numOpcionesBooster;
    float cardW = (totalCards <= 3) ? min(180.0, (mainW - 100.0) / 3.0) : min(148.0, (mainW - 80.0) / 5.0);
    float cardH = min(totalH * 0.60, round(cardW * (95.0 / 71.0)));
    float gap = (totalCards <= 3) ? 26.0 : 14.0;
    float totalRowW = totalCards * cardW + (totalCards - 1) * gap;
    float startCardX = (mainW - totalRowW) * 0.5 + cardW * 0.5;
    float cardCenterY = totalH * 0.5 + 4;

    for (int i = 0; i < totalCards; i++) {
      if (i < 5 && boosterOpcionTomada[i]) continue;

      float cx = mainX + startCardX + i * (cardW + gap);
      float cy = startY + cardCenterY;

      if (evaluarHover(cx, cy, cardW, cardH)) {
        if (numInventarioPlugins >= limiteMaxPluginsEquipados()) {
          if (sonidoErrorMsj != null) reproducirSFX(sonidoErrorMsj);
          dispararTextoElastico("RANURAS LLENAS (MÁX " + limiteMaxPluginsEquipados() + ")! VENDE UN PLUGIN ARRIBA", mouseX, mouseY, color(255, 70, 70));
          return;
        }

        int elegido = opcionesBooster[i];
        if (yaPoseePlugin(elegido)) {
          if (i < 5) boosterOpcionTomada[i] = true;
          return;
        }
        int targetSlot = constrain(1 + numInventarioPlugins, 1, max(1, limiteMaxSlotsRack() - 1));
        float ex = plugBaseX[targetSlot];
        float ey = plugBaseY[targetSlot];

        agregarInventarioPlugin(elegido);
        registrarPluginDescubierto(elegido);
        sincronizarSlotsEquipados();
        evaluarSinergias();
        reemplazarOfertasDuplicadasEnTienda();
        shopCardSeleccionada = -1;
        shopDescBoxActiva = false;

        if (i < 5) boosterOpcionTomada[i] = true;
        boosterEleccionesRestantes--;

        if (sonidoShopBuy != null) reproducirSFX(sonidoShopBuy);
        else {
          if (sonidoTransferenciaExitosa != null) reproducirSFX(sonidoTransferenciaExitosa);
        }
        if (sndVueloPlugin != null) reproducirSFX(sndVueloPlugin);

        iniciarVueloTienda(elegido, -1, targetSlot, cx, cy, ex, ey);

        dispararExplosionCarta(cx, cy, DOLUS_PURPLE, false);
        dispararTextoElastico("PROTOCOLO INSTALADO!", cx, cy - 30, DOLUS_PURPLE);
        dispararSacudidaCamara(4.0);

        if (boosterEleccionesRestantes <= 0) {
          estadoTienda = TIENDA_ESTADO_NORMAL;
        }
        slotSeleccionadoVenta = -1;
        return;
      }
    }

    slotSeleccionadoVenta = -1;
    return;
  }

  slotSeleccionadoVenta = -1;

  float btnContW = leftW - 32;
  float btnContH = 56;
  float btnContY = startY + 52 + btnContH * 0.5;
  if (evaluarHover(margin + leftW * 0.5, btnContY, btnContW, btnContH)) {
    dispararJuiceTienda(JUICE_BTN_CONTINUAR, 0.35, 0.1);
    reproducirTap();
    avanzarSiguienteRondaDesdeTienda();
    return;
  }

  float btnRerollW = leftW - 32;
  float btnRerollH = 50;
  float btnRerollY = btnContY + btnContH * 0.5 + 14 + btnRerollH * 0.5;
  if (evaluarHover(margin + leftW * 0.5, btnRerollY, btnRerollW, btnRerollH)) {
    int costoRerollActual = (voucherStakingPoolActivo && !rerollGratisUsadoEnTienda) ? 0 : costoRerollTienda;
    if (tokensDolus >= costoRerollActual) {
      tokensDolus -= costoRerollActual;
      if (costoRerollActual == 0) {
        rerollGratisUsadoEnTienda = true;
      } else {
        costoRerollTienda += 3;
      }
      pulsoTokensUI = 1.0;
      dispararJuiceTienda(JUICE_BTN_REROLL, 0.4, -0.15);
      reproducirTap();
      generarOpcionesTienda();

      for (int k = 0; k < 3; k++) {
        slideCardX[k] = targetCardX[k] + 140.0 + k * 45.0;
        dispararJuiceTienda(JUICE_CARDS_BASE + k, 0.35, random(-0.15, 0.15));
        hoverCardLift[k] = 0;
      }

      dispararExplosionCarta(margin + leftW * 0.5, btnRerollY, DOLUS_GREEN, false);
      String txtRerollMsg = (costoRerollActual == 0) ? "REROLL GRATIS!" : ("REROLL! [+" + costoRerollTienda + "T]");
      dispararTextoElastico(txtRerollMsg, margin + leftW * 0.5, btnRerollY - 30, DOLUS_GREEN);
      dispararSacudidaCamara(3.5);
    } else {
      if (sonidoErrorMsj != null) reproducirSFX(sonidoErrorMsj);
      dispararTextoElastico("TOKENS INSUFICIENTES!", margin + leftW * 0.5, btnRerollY - 30, color(255, 70, 70));
    }
    return;
  }

  if (shopDescBoxActiva && mouseX >= shopDescBoxX && mouseX <= shopDescBoxX + shopDescBoxW &&
      mouseY >= shopDescBoxY && mouseY <= shopDescBoxY + shopDescBoxH) {
    return;
  }

  float cardH = row1H - 22;
  float btnH = 36;
  float spriteH = cardH - btnH - 8;
  float spriteW = round(spriteH * (71.0 / 95.0));
  float cardW = spriteW;
  float cardSpacing = 18.0;
  float startCardX = 22.0 + cardW * 0.5;

  for (int i = 0; i < 3; i++) {
    if (tiendaOpciones[i] == -1 || tiendaComprado[i]) continue;
    float cx = mainX + startCardX + i * (cardW + cardSpacing);
    float cy = startY + row1H * 0.5 + 4;
    float spriteCY = -btnH * 0.5;

    float btnW = spriteW;
    float btnY = spriteCY + spriteH * 0.5 + btnH * 0.5 + 4;

    float btnTop = cy + btnY - btnH * 0.5;
    float btnBottom = cy + btnY + btnH * 0.5;
    float btnLeft = cx - btnW * 0.5;
    float btnRight = cx + btnW * 0.5;

    boolean clickEnBoton = (mouseX >= btnLeft && mouseX <= btnRight && mouseY >= btnTop && mouseY <= btnBottom);
    boolean clickEnCarta = (mouseX >= cx - spriteW * 0.5 && mouseX <= cx + spriteW * 0.5 &&
                            mouseY >= cy + spriteCY - spriteH * 0.5 && mouseY <= cy + spriteCY + spriteH * 0.5);

    if (shopCardSeleccionada == i) {
      if (clickEnBoton) {

        dispararJuiceTienda(JUICE_CARDS_BASE + i, 0.45, random(-0.25, 0.25));

        if (numInventarioPlugins >= limiteMaxPluginsEquipados()) {
          if (sonidoErrorMsj != null) reproducirSFX(sonidoErrorMsj);
          dispararTextoElastico("RANURAS LLENAS (MÁX " + limiteMaxPluginsEquipados() + ")!", cx, cy - 40, color(255, 70, 70));
          return;
        }

        if (tokensDolus < tiendaPrecios[i]) {
          if (sonidoErrorMsj != null) reproducirSFX(sonidoErrorMsj);
          dispararTextoElastico("TOKENS INSUFICIENTES!", cx, cy - 40, color(255, 70, 70));
          return;
        }

        int catIndex = tiendaOpciones[i];
        int targetSlot = constrain(1 + numInventarioPlugins, 1, max(1, limiteMaxSlotsRack() - 1));
        float ex = plugBaseX[targetSlot];
        float ey = plugBaseY[targetSlot];

        if (comprarPlugin(i)) {
          if (sonidoShopBuy != null) reproducirSFX(sonidoShopBuy);
          else {
            if (sonidoTransferenciaExitosa != null) reproducirSFX(sonidoTransferenciaExitosa);
          }
          if (sndVueloPlugin != null) reproducirSFX(sndVueloPlugin);

          iniciarVueloTienda(catIndex, i, targetSlot, cx, cy, ex, ey);

          dispararExplosionCarta(cx, cy, colorTema(), false);
          dispararRayoFlourish(cx, cy, colorTema(), 0);
          dispararTextoElastico("COMPRADO!", cx, cy - 40, colorTema());
          dispararSacudidaCamara(2.8);
          shopCardSeleccionada = -1;
          shopDescBoxActiva = false;
        }
        return;

      } else {
        if (clickEnCarta) {

          shopCardSeleccionada = -1;
          if (sndClickPlugin != null) reproducirSFX(sndClickPlugin);
          return;
        }
      }
    } else {
      if (clickEnCarta || clickEnBoton) {

        shopCardSeleccionada = i;
        shopVoucherSeleccionado = false;
        shopPackSeleccionado = -1;
        dispararJuiceTienda(JUICE_CARDS_BASE + i, 0.35, 0.12);
        if (sndClickPlugin != null) reproducirSFX(sndClickPlugin);
        return;
      }
    }
  }

  if (catalogoVouchersInicializado && voucherTiendaActual >= 0 && voucherTiendaActual < 8 && !vouchComprado[voucherTiendaActual]) {
    int vIdx = voucherTiendaActual;
    float rightOfCards = startCardX + 2 * (cardW + cardSpacing) + cardW * 0.5;
    float vCX = mainX + rightOfCards + (mainW - rightOfCards) * 0.5;
    float vCY = startY + row1H * 0.5 + 4;
    float spriteCY = -btnH * 0.5;
    float vBtnY = spriteCY + spriteH * 0.5 + btnH * 0.5 + 4;
    float vBtnW = spriteW;

    float vBtnTop = vCY + vBtnY - btnH * 0.5;
    float vBtnBottom = vCY + vBtnY + btnH * 0.5;
    float vBtnLeft = vCX - vBtnW * 0.5;
    float vBtnRight = vCX + vBtnW * 0.5;

    boolean clickEnBoton = (mouseX >= vBtnLeft && mouseX <= vBtnRight && mouseY >= vBtnTop && mouseY <= vBtnBottom);
    boolean clickEnCarta = (mouseX >= vCX - spriteW * 0.5 && mouseX <= vCX + spriteW * 0.5 &&
                            mouseY >= vCY + spriteCY - spriteH * 0.5 && mouseY <= vCY + spriteCY + spriteH * 0.5);

    if (shopVoucherSeleccionado) {
      if (clickEnBoton) {
        dispararJuiceTienda(JUICE_EXPLOIT_CARD, 0.45, random(-0.25, 0.25));

        if (tokensDolus < vouchPrecio[vIdx]) {
          if (sonidoErrorMsj != null) reproducirSFX(sonidoErrorMsj);
          dispararTextoElastico("TOKENS INSUFICIENTES!", vCX, vCY - 40, color(255, 70, 70));
          return;
        }

        if (comprarVoucher(voucherTiendaActual)) {
          if (sonidoShopBuy != null) reproducirSFX(sonidoShopBuy);
          else {
            if (sonidoHerramientaUso != null) reproducirSFX(sonidoHerramientaUso);
          }
          dispararExplosionCarta(vCX, vCY, color(0, 230, 160), false);
          dispararRayoFlourish(vCX, vCY, color(0, 230, 160), 0);
          dispararTextoElastico("!" + vouchNombre[vIdx] + " INSTALADO EN RAM!", vCX, vCY - 40, color(0, 230, 160));
          dispararSacudidaCamara(2.0);
          shopVoucherSeleccionado = false;
          shopCardSeleccionada = -1;
          shopDescBoxActiva = false;
        }
        return;

      } else {
        if (clickEnCarta) {
          shopVoucherSeleccionado = false;
          if (sndClickPlugin != null) reproducirSFX(sndClickPlugin);
          return;
        }
      }
    } else {
      if (clickEnCarta || clickEnBoton) {
        shopVoucherSeleccionado = true;
        shopCardSeleccionada = -1;
        shopPackSeleccionado = -1;
        dispararJuiceTienda(JUICE_EXPLOIT_CARD, 0.35, 0.12);
        if (sndClickPlugin != null) reproducirSFX(sndClickPlugin);
        return;
      }
    }
  }

  float cardHPack = row2H - 22;
  float btnHPack = 36;
  float badgeHPack = 18;
  float gapPack = 6;
  float spriteHPack = cardHPack - btnHPack - badgeHPack - gapPack * 2;
  float spriteWPack = round(spriteHPack * (284.0 / 400.0));
  float packW = spriteWPack;
  float packSpacing = max(24.0, (mainW - 40.0 - 3 * packW) / 4.0);
  float totalPacksW = 3 * packW + 2 * packSpacing;
  float startPackX = (mainW - totalPacksW) * 0.5 + packW * 0.5;

  for (int p = 0; p < 3; p++) {
    if (tiendaPacksComprado[p]) continue;
    float pcx = mainX + startPackX + p * (packW + packSpacing);
    float pcy = row2Y + row2H * 0.5 + 4;

    float btnW = spriteWPack;
    float badgeY = -cardHPack * 0.5 + badgeHPack * 0.5;
    float spriteCY = badgeY + badgeHPack * 0.5 + gapPack + spriteHPack * 0.5;
    float btnY = spriteCY + spriteHPack * 0.5 + gapPack + btnHPack * 0.5;

    float btnTop = pcy + btnY - btnHPack * 0.5;
    float btnBottom = pcy + btnY + btnHPack * 0.5;
    float btnLeft = pcx - btnW * 0.5;
    float btnRight = pcx + btnW * 0.5;

    boolean clickEnBoton = (mouseX >= btnLeft && mouseX <= btnRight && mouseY >= btnTop && mouseY <= btnBottom);
    boolean clickEnPack = (mouseX >= pcx - packW * 0.5 && mouseX <= pcx + packW * 0.5 &&
                           mouseY >= pcy - cardHPack * 0.5 && mouseY <= pcy + cardHPack * 0.5);

    if (shopPackSeleccionado == p) {
      if (clickEnBoton) {
        dispararJuiceTienda(JUICE_PACKS_BASE + p, 0.40, 0.20);

        if (tokensDolus < tiendaPacksPrecio[p]) {
          if (sonidoErrorMsj != null) reproducirSFX(sonidoErrorMsj);
          dispararTextoElastico("TOKENS INSUFICIENTES!", pcx, pcy - 30, color(255, 70, 70));
          return;
        }

        tokensDolus -= tiendaPacksPrecio[p];
        pulsoTokensUI = 1.0;
        tiendaPacksComprado[p] = true;
        boosterPackComprado = true;
        tipoPackTiendaActual = tiendaPacksTipo[p];
        precioBoosterPack = tiendaPacksPrecio[p];

        if (sonidoShopBuy != null) reproducirSFX(sonidoShopBuy);
        dispararExplosionCarta(pcx, pcy, DOLUS_PURPLE, false);
        dispararSacudidaCamara(4.0);

        iniciarAnimBoosterPack(tiendaPacksTipo[p], pcx, pcy, mainX + mainW * 0.5, startY + totalH * 0.5);
        estadoTienda = TIENDA_ESTADO_BOOSTER_ANIM;
        shopPackSeleccionado = -1;
        shopCardSeleccionada = -1;
        shopVoucherSeleccionado = false;
        shopDescBoxActiva = false;
        return;

      } else {
        if (clickEnPack) {
          shopPackSeleccionado = -1;
          if (sndClickPlugin != null) reproducirSFX(sndClickPlugin);
          return;
        }
      }
    } else {
      if (clickEnPack || clickEnBoton) {
        shopPackSeleccionado = p;
        shopCardSeleccionada = -1;
        shopVoucherSeleccionado = false;
        dispararJuiceTienda(JUICE_PACKS_BASE + p, 0.35, 0.12);
        if (sndClickPlugin != null) reproducirSFX(sndClickPlugin);
        return;
      }
    }
  }

  shopCardSeleccionada = -1;
  shopVoucherSeleccionado = false;
  shopPackSeleccionado = -1;
  shopDescBoxActiva = false;
  shopDescBoxTipo = 0;
  shopDescBoxIdx = -1;
}

void abrirBoosterPackUnboxing(int packIdx) {
  estadoTienda = TIENDA_ESTADO_BOOSTER;
  numOpcionesBooster = 0;

  if (packIdx < 0 || packIdx >= 4) packIdx = 0;
  boosterEleccionesRestantes = packNumElecciones[packIdx];
  for (int i = 0; i < 5; i++) {
    boosterOpcionTomada[i] = false;
  }

  int[] disponibles = new int[32];
  int numDisponibles = 0;
  for (int i = 1; i < numCatalogoPlugins; i++) {
    if (yaPoseePlugin(i)) continue;
    boolean enEstanteriaTienda = false;
    for (int t = 0; t < 3; t++) {
      if (!tiendaComprado[t] && tiendaOpciones[t] == i) {
        enEstanteriaTienda = true;
        break;
      }
    }
    if (!enEstanteriaTienda && numDisponibles < 32) {
      disponibles[numDisponibles++] = i;
    }
  }
  if (numDisponibles < packNumOpciones[packIdx]) {
    for (int i = 1; i < numCatalogoPlugins; i++) {
      if (!yaPoseePlugin(i) && !arrayContieneInt(disponibles, numDisponibles, i) && numDisponibles < 32) {
        disponibles[numDisponibles++] = i;
      }
    }
  }

  int needed = min(packNumOpciones[packIdx], numDisponibles);
  while (numOpcionesBooster < needed && numDisponibles > 0) {
    int idx = int(random(numDisponibles));
    if (numOpcionesBooster < 16) {
      opcionesBooster[numOpcionesBooster++] = disponibles[idx];
    }
    for (int k = idx; k < numDisponibles - 1; k++) {
      disponibles[k] = disponibles[k + 1];
    }
    numDisponibles--;
  }

  for (int i = 0; i < 5; i++) {
    dispararJuiceTienda(JUICE_BOOSTER_OPTS_BASE + i, 0.5, random(-0.25, 0.25));
  }
}

void abrirBoosterPackUnboxing() {
  abrirBoosterPackUnboxing(tipoPackTiendaActual);
}

void avanzarSiguienteRondaDesdeTienda() {
  if (animandoTransicionTienda) return;
  animandoTransicionTienda = true;
  sentidoTransicionTienda = -1;
  progresoTransicionTienda = 1.0;
  if (sonidoPausaApertura != null) reproducirSFX(sonidoPausaApertura);
}

void finalizarSalidaTienda() {
  animandoTransicionTienda = false;
  sentidoTransicionTienda = 0;
  progresoTransicionTienda = 0.0;

  iniciarNuevaRonda();
  sincronizarSlotsEquipados();
  recargarDatosPlugins();

  if (estadoPantalla == PANTALLA_TRANSICION_JEFE || estadoPantalla == PANTALLA_TRANSICION) {

  } else {
    estadoPantalla = PANTALLA_JUEGO;
    if (comboActual >= 10) {
      estadoMusicaGameplay = 1;
      reproducirMusicaUnica(musicaGameplayIntenso);
    } else {
      estadoMusicaGameplay = 0;
      reproducirMusicaUnica(musicaGameplayInicial);
    }
  }
}

color getRarezaColor(int precio) {
  if (precio <= 30) return color(150);
  if (precio <= 48) return color(50, 150, 255);
  if (precio <= 78) return color(50, 255, 100);
  if (precio <= 105) return color(200, 50, 255);
  if (precio <= 140) return color(255, 200, 50);
  return color(255, 50, 50);
}

String getRarezaNombre(int precio) {
  if (precio <= 30) return "COMUN";
  if (precio <= 48) return "RARO";
  if (precio <= 78) return "SUPER RARO";
  if (precio <= 105) return "EPICO";
  if (precio <= 140) return "LEGENDARIO";
  return "MITICO";
}
