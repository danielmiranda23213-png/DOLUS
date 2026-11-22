
boolean arrastrando_mensaje = false;
float swipeInicioX = 0, swipeInicioY = 0;
float swipeActualX = 0, swipeActualY = 0;
float swipeVelX = 0, swipeVelY = 0;
float swipeOffsetX = 0, swipeOffsetY = 0;
float SWIPE_THRESHOLD = 120;
float SWIPE_THRESHOLD_DOWN = 100;

final float SWIPE_SPRING_RIGIDEZ = 0.36;
final float SWIPE_SPRING_AMORT = 0.64;
final float SWIPE_PESO_ROT = 0.00145;

float swipePosX = 0, swipePosY = 0;
float swipeSpringVelX = 0, swipeSpringVelY = 0;
float swipeTargetX = 0, swipeTargetY = 0;
float swipePuntoAgarreRelY = 0;
boolean swipeCruzoUmbral = false;
float swipeFlashUmbral = 0;

float cardEscalaX = 1.0, cardEscalaY = 1.0;
float cardVelEscalaX = 0, cardVelEscalaY = 0;
float rielSpotlightAlpha = 0;
float frenesiSwipeVisual = 0;

int consecutivosInocente = 0;
int consecutivosMalo = 0;

float cardScaleActual = 1.0;
float cardScaleObjetivo = 1.0;
boolean cardHover = false;
boolean cardGrabbed = false;
float cardFloteAngulo = 0;

float cardEntradaProgreso = 0;
boolean cardEntrando = true;

float obtenerPanelGameX() {
  return width * 0.30;
}

float obtenerPanelGameW() {
  return width * 0.69;
}

float obtenerPanelGameY() {
  float breath = sin(frameCount * 0.04) * 4.0;
  return height * 0.29 - breath * 0.5;
}

float obtenerPanelGameH() {
  return height * 0.69;
}

float obtenerPosicionRielSwipeX(int decision) {
  return (decision == 0) ? (obtenerPanelGameX() + obtenerPanelGameW() - 10) : (obtenerPanelGameX() + 10);
}

int[] csMsg = new int[16];
int[] csDecision = new int[16];
float[] csX = new float[16];
float[] csY = new float[16];
float[] csVX = new float[16];
float[] csVY = new float[16];
float[] csRot = new float[16];
float[] csEscBase = new float[16];
float[] csStretchWarpX = new float[16];
float[] csSquashWarpY = new float[16];
float[] csTiempoVuelo = new float[16];
float[] csFlashSalida = new float[16];
float[] csAlpha = new float[16];
boolean[] csCruzoRiel = new boolean[16];
boolean[] csFueraDePanel = new boolean[16];
float[][] csHistX = new float[16][9];
float[][] csHistY = new float[16][9];
float[][] csHistAncho = new float[16][9];
int numCartasSaliendo = 0;

void agregarCartaSaliendo(int m, int dec, float startX, float startY, float velIniX, float velIniY, float startRot, float startEsc) {
  if (numCartasSaliendo >= 16) return;
  int idx = numCartasSaliendo;
  csMsg[idx] = m;
  csDecision[idx] = dec;
  csX[idx] = startX;
  csY[idx] = startY;
  csVX[idx] = velIniX;
  csVY[idx] = velIniY;
  csRot[idx] = startRot;
  csEscBase[idx] = startEsc;
  csStretchWarpX[idx] = 1.0;
  csSquashWarpY[idx] = 1.0;
  csTiempoVuelo[idx] = 0;
  csFlashSalida[idx] = 1.0;
  csAlpha[idx] = 255.0;
  csCruzoRiel[idx] = false;
  csFueraDePanel[idx] = false;
  for (int i = 0; i < 9; i++) {
    csHistX[idx][i] = startX;
    csHistY[idx][i] = startY;
    csHistAncho[idx][i] = 275.0 * 0.42;
  }
  numCartasSaliendo++;
}

void eliminarCartaSaliendoEn(int idx) {
  if (idx < 0 || idx >= numCartasSaliendo) return;
  for (int i = idx; i < numCartasSaliendo - 1; i++) {
    csMsg[i] = csMsg[i + 1];
    csDecision[i] = csDecision[i + 1];
    csX[i] = csX[i + 1];
    csY[i] = csY[i + 1];
    csVX[i] = csVX[i + 1];
    csVY[i] = csVY[i + 1];
    csRot[i] = csRot[i + 1];
    csEscBase[i] = csEscBase[i + 1];
    csStretchWarpX[i] = csStretchWarpX[i + 1];
    csSquashWarpY[i] = csSquashWarpY[i + 1];
    csTiempoVuelo[i] = csTiempoVuelo[i + 1];
    csFlashSalida[i] = csFlashSalida[i + 1];
    csAlpha[i] = csAlpha[i + 1];
    csCruzoRiel[i] = csCruzoRiel[i + 1];
    csFueraDePanel[i] = csFueraDePanel[i + 1];
    for (int t = 0; t < 9; t++) {
      csHistX[i][t] = csHistX[i + 1][t];
      csHistY[i][t] = csHistY[i + 1][t];
      csHistAncho[i][t] = csHistAncho[i + 1][t];
    }
  }
  numCartasSaliendo--;
}

void actualizarCartaSaliendo(int idx) {
  if (csDecision[idx] == 2) {
    csX[idx] += csVX[idx];
    csY[idx] += csVY[idx];
    csVY[idx] += 0.9;
    csEscBase[idx] *= 0.97;
    csAlpha[idx] -= 16.0;
    if (csAlpha[idx] <= 0) csFueraDePanel[idx] = true;
    return;
  }

  for (int i = 8; i > 0; i--) {
    csHistX[idx][i] = csHistX[idx][i - 1];
    csHistY[idx][i] = csHistY[idx][i - 1];
    csHistAncho[idx][i] = csHistAncho[idx][i - 1] * 0.90;
  }
  csHistX[idx][0] = csX[idx];
  csHistY[idx][0] = csY[idx];
  csHistAncho[idx][0] = 275.0 * 0.36 * csEscBase[idx] * csSquashWarpY[idx];

  csTiempoVuelo[idx] += 1.0;
  csFlashSalida[idx] = max(0, csFlashSalida[idx] - 0.14);

  float pY = obtenerPanelGameY();
  float pH = obtenerPanelGameH();
  float rielX = obtenerPosicionRielSwipeX(csDecision[idx]);
  float metaX = (csDecision[idx] == 0) ? (rielX + 360) : (rielX - 360);
  float metaY = constrain(csY[idx], pY + pH * 0.18, pY + pH * 0.82);

  float dx = metaX - csX[idx];
  float dy = metaY - csY[idx];
  float distMeta = max(1.0, sqrt(dx * dx + dy * dy));
  float nx = dx / distMeta;
  float ny = dy / distMeta;

  float distAlRiel = abs(rielX - csX[idx]);
  float bonusFrenesi = 1.0 + frenesiSwipeVisual * 0.35;

  float rapidezDeseada = (32.0 + pow(csTiempoVuelo[idx], 2.05) * 6.8 + 3600.0 / max(55.0, distAlRiel)) * bonusFrenesi;
  float factorHoming = constrain(0.48 + csTiempoVuelo[idx] * 0.12, 0.48, 0.98);
  csRot[idx] = lerp(csRot[idx], (csDecision[idx] == 0 ? 0.16 : -0.16), 0.22);

  csVX[idx] = lerp(csVX[idx], nx * rapidezDeseada, factorHoming);
  csVY[idx] = lerp(csVY[idx], ny * rapidezDeseada, factorHoming);

  float rapidezActual = sqrt(csVX[idx] * csVX[idx] + csVY[idx] * csVY[idx]);
  csStretchWarpX[idx] = 1.0 + constrain((rapidezActual - 18.0) / 68.0, 0, 0.62);
  csSquashWarpY[idx] = 1.0 - constrain((rapidezActual - 18.0) / 105.0, 0, 0.54);
  csEscBase[idx] = constrain(map(distAlRiel, 0, 260, 0.62, 0.98), 0.58, 1.0);

  float prevX = csX[idx];
  csX[idx] += csVX[idx];
  csY[idx] += csVY[idx];

  if (!csCruzoRiel[idx]) {
    boolean atravesoDer = (csDecision[idx] == 0 && prevX < rielX && csX[idx] >= rielX) || (csDecision[idx] == 0 && csX[idx] >= rielX);
    boolean atravesoIzq = (csDecision[idx] == 1 && prevX > rielX && csX[idx] <= rielX) || (csDecision[idx] == 1 && csX[idx] <= rielX);
    if (atravesoDer || atravesoIzq) {
      csCruzoRiel[idx] = true;
      int catEsp = (csMsg[idx] >= 0) ? msgCategoriaEspecial[csMsg[idx]] : 0;
      detonarCruceRielSwipe(csDecision[idx], rielX, constrain(csY[idx], pY + 55, pY + pH - 55), catEsp);
    }
  }

  if ((csDecision[idx] == 0 && csX[idx] > rielX + 340) || (csDecision[idx] == 1 && csX[idx] < rielX - 340)) {
    csFueraDePanel[idx] = true;
  }
}

float[] pRielX = new float[192];
float[] pRielY = new float[192];
float[] pRielVX = new float[192];
float[] pRielVY = new float[192];
float[] pRielTam = new float[192];
float[] pRielRot = new float[192];
float[] pRielVRot = new float[192];
float[] pRielVida = new float[192];
float[] pRielVidaMax = new float[192];
color[] pRielCol = new color[192];
boolean[] pRielEsFragmento = new boolean[192];
int numParticulasRielSwipe = 0;

void agregarParticulaRielSwipe(float px, float py, float pvx, float pvy, color c, boolean frag) {
  if (numParticulasRielSwipe >= 192) return;
  int idx = numParticulasRielSwipe;
  pRielX[idx] = px;
  pRielY[idx] = py;
  pRielVX[idx] = pvx;
  pRielVY[idx] = pvy;
  pRielCol[idx] = c;
  pRielEsFragmento[idx] = frag;
  pRielTam[idx] = frag ? random(8, 15) : random(5, 11);
  pRielRot[idx] = random(TWO_PI);
  pRielVRot[idx] = random(-0.28, 0.28);
  pRielVidaMax[idx] = random(16, 30);
  pRielVida[idx] = pRielVidaMax[idx];
  numParticulasRielSwipe++;
}

void eliminarParticulaRielSwipeEn(int idx) {
  if (idx < 0 || idx >= numParticulasRielSwipe) return;
  for (int i = idx; i < numParticulasRielSwipe - 1; i++) {
    pRielX[i] = pRielX[i + 1];
    pRielY[i] = pRielY[i + 1];
    pRielVX[i] = pRielVX[i + 1];
    pRielVY[i] = pRielVY[i + 1];
    pRielTam[i] = pRielTam[i + 1];
    pRielRot[i] = pRielRot[i + 1];
    pRielVRot[i] = pRielVRot[i + 1];
    pRielVida[i] = pRielVida[i + 1];
    pRielVidaMax[i] = pRielVidaMax[i + 1];
    pRielCol[i] = pRielCol[i + 1];
    pRielEsFragmento[i] = pRielEsFragmento[i + 1];
  }
  numParticulasRielSwipe--;
}

void actualizarParticulaRielSwipe(int idx) {
  pRielX[idx] += pRielVX[idx];
  pRielY[idx] += pRielVY[idx];
  pRielVY[idx] += 0.26;
  pRielVX[idx] *= 0.93;
  pRielVY[idx] *= 0.95;
  pRielRot[idx] += pRielVRot[idx];
  pRielVida[idx] -= 1.0;
}

void dibujarParticulaRielSwipe(int idx, float shX, float shY) {
  float p = constrain(pRielVida[idx] / pRielVidaMax[idx], 0, 1);
  pushStyle();
  pushMatrix();
  translate(pRielX[idx] + shX, pRielY[idx] + shY);
  rotate(pRielRot[idx]);
  rectMode(CENTER);
  if (pRielEsFragmento[idx]) {
    noFill();
    stroke(pRielCol[idx], 245 * p);
    strokeWeight(1.8);
    rect(0, 0, pRielTam[idx] * p, pRielTam[idx] * 0.62 * p, 2);
  } else {
    noStroke();
    fill(lerpColor(pRielCol[idx], color(255), p * 0.45), 245 * p);
    rect(0, 0, pRielTam[idx] * p, pRielTam[idx] * p, 2);
  }
  popMatrix();
  popStyle();
}

float[] rRielX = new float[32];
float[] rRielY = new float[32];
float[] rRielDirAdentro = new float[32];
float[] rRielAlcanceInicial = new float[32];
float[] rRielDesvioY = new float[32];
float[] rRielAncho = new float[32];
color[] rRielCol = new color[32];
int[] rRielAge = new int[32];
int[] rRielTotalFrames = new int[32];
boolean[] rRielFlip = new boolean[32];
int[] rRielOffsetFrame = new int[32];
int numRayosRielSwipe = 0;

void agregarRayoRielSwipe(float rx, float ry, float dirIn, float alcance, float dy, float grosor, color c, int duracion) {
  if (numRayosRielSwipe >= 32) return;
  int idx = numRayosRielSwipe;
  rRielX[idx] = rx;
  rRielY[idx] = ry;
  rRielDirAdentro[idx] = dirIn;
  rRielAlcanceInicial[idx] = alcance;
  rRielDesvioY[idx] = dy;
  rRielAncho[idx] = grosor;
  rRielCol[idx] = c;
  rRielAge[idx] = 0;
  rRielTotalFrames[idx] = max(10, duracion);
  rRielFlip[idx] = random(1) < 0.5;
  rRielOffsetFrame[idx] = int(random(LIGHTNING_FRAMES));
  numRayosRielSwipe++;
}

void eliminarRayoRielSwipeEn(int idx) {
  if (idx < 0 || idx >= numRayosRielSwipe) return;
  for (int i = idx; i < numRayosRielSwipe - 1; i++) {
    rRielX[i] = rRielX[i + 1];
    rRielY[i] = rRielY[i + 1];
    rRielDirAdentro[i] = rRielDirAdentro[i + 1];
    rRielAlcanceInicial[i] = rRielAlcanceInicial[i + 1];
    rRielDesvioY[i] = rRielDesvioY[i + 1];
    rRielAncho[i] = rRielAncho[i + 1];
    rRielCol[i] = rRielCol[i + 1];
    rRielAge[i] = rRielAge[i + 1];
    rRielTotalFrames[i] = rRielTotalFrames[i + 1];
    rRielFlip[i] = rRielFlip[i + 1];
    rRielOffsetFrame[i] = rRielOffsetFrame[i + 1];
  }
  numRayosRielSwipe--;
}

void dibujarRayoRielSwipe(int idx, float shX, float shY) {
  float prog = constrain(float(rRielAge[idx]) / float(rRielTotalFrames[idx]), 0.0, 1.0);
  float alcanceActual = lerp(rRielAlcanceInicial[idx], 34.0, prog * prog);
  float origX = rRielX[idx] + rRielDirAdentro[idx] * alcanceActual + shX;
  float origY = rRielY[idx] + rRielDesvioY[idx] * (1.0 - prog * 0.65) + shY;
  float destX = rRielX[idx] + shX;
  float destY = rRielY[idx] + shY;

  int sprIdx = (rRielOffsetFrame[idx] + rRielAge[idx] / 2) % LIGHTNING_FRAMES;
  float alpha01 = (rRielAge[idx] > rRielTotalFrames[idx] - 5) ? map(rRielAge[idx], rRielTotalFrames[idx] - 5, rRielTotalFrames[idx], 1.0, 0.0) : 1.0;
  dibujarSpriteRayoEntrePuntos(origX, origY, destX, destY, sprIdx, rRielFlip[idx], rRielAncho[idx], rRielCol[idx], alpha01);
}

int[] colaMensajes = new int[32];
int numColaMensajes = 0;

void encolarMensaje(int msgId) {
  if (numColaMensajes >= 32) return;
  colaMensajes[numColaMensajes] = msgId;
  numColaMensajes++;
}

void insertarColaMensaje(int pos, int msgId) {
  if (numColaMensajes >= 32) return;
  int p = constrain(pos, 0, numColaMensajes);
  for (int i = numColaMensajes; i > p; i--) {
    colaMensajes[i] = colaMensajes[i - 1];
  }
  colaMensajes[p] = msgId;
  numColaMensajes++;
}

void eliminarColaMensajeEn(int idx) {
  if (idx < 0 || idx >= numColaMensajes) return;
  for (int i = idx; i < numColaMensajes - 1; i++) {
    colaMensajes[i] = colaMensajes[i + 1];
  }
  numColaMensajes--;
}

void limpiarColaMensajes() {
  numColaMensajes = 0;
}

float statPopularidad = 50.0;
float statSeguridad = 50.0;
float statReputacion = 50.0;
float statSaludMental = 50.0;
float dispPopularidad = 50.0;
float dispSeguridad = 50.0;
float dispReputacion = 50.0;
float dispSaludMental = 50.0;

int balanzaEstabilidad = 0;
float dispBalanzaEstabilidad = 0.0;
int vidasJugador = 1;
boolean ultimoEmpujonActivo = false;
boolean ultimoEmpujonAnunciado = false;

boolean esUltimoEmpujonActivo() {
  if (modoFeriaActivo) return false;
  if (jefeActivo != 0 || rondaCompletada) return false;
  int metaBal = max(1, obtenerMetaBalanzaActual());
  int umbral = max(2, metaBal - 3);
  return (balanzaEstabilidad >= umbral);
}

int comboActual = 0;
int comboMaximoRonda = 0;
float tiempoComboRestante = 0;
final float MAX_TIEMPO_COMBO = 240.0;
int tokensDolus = 0;

int directivaRondaActual = 0;

final int FRAMES_FIN_LIQUIDACION = 66;
boolean liquidacionCalculada = false;
int tokensInicioRonda = 0;
int liqFarmRonda = 0;
int liqPromIntegridad = 50;
int liqBase = 0;
int liqComboBonus = 0;
int liqIntegridadBonus = 0;
int liqInteres = 0;
int liqTotal = 0;

int estadoMusicaGameplay = 0;
boolean mostrarTextoComboMaestro = false;
int timerComboMaestro = 0;

boolean diaInicializado = false;

String[] msgRemitente = new String[128];
String[] msgContenido = new String[128];
int[] msgTipoMaldad = new int[128];
float[] msgTiempoRestante = new float[128];
boolean[] msgVerificado = new boolean[128];
int[] msgCategoriaEspecial = new int[128];
float[] msgNivelEncriptado = new float[128];
boolean[] msgFueDesencriptado = new boolean[128];
float[] msgEnergiaSacudida = new float[128];
int[] msgUltimoSentidoSacudida = new int[128];
int[] msgConteoSacudidasCompletas = new int[128];
int[] msgFrameUltimaSacudida = new int[128];
String[] msgEtiquetaMeta = new String[128];
int[] msgSemillaAvatar = new int[128];
String[] msgDominio = new String[128];
String[] msgAsunto = new String[128];
int[] msgIndiceSello = new int[128];
int[] msgIndiceArchivo = new int[128];
String[] msgExtensionArchivo = new String[128];
boolean[] msgTieneAdjunto = new boolean[128];
boolean[] msgEsCorporativo = new boolean[128];
boolean[] msgEsValido = new boolean[128];
int[] msgMotivoInvalidez = new int[128];
int[] msgTipoMensaje = new int[128];

String[][] msgLineasCacheadas = new String[128][32];
int[] msgNumLineasCacheadas = new int[128];
float[] msgTamTextoCache = new float[128];
String[] msgTextoCacheRef = new String[128];
float[] msgAnchoCacheRef = new float[128];
String[] msgCacheTextoCifrado = new String[128];
int[] msgBloqueFrameCifrado = new int[128];
float[] msgUltimoNivelCifradoCache = new float[128];

int cursorPoolMensajeFijo = 0;
int cursorPoolMensaje = 16;

void inicializarSlotMensajeDolus(int id, String rem, String cont, int maldad) {
  msgRemitente[id] = (rem != null) ? rem : "Anonimo";
  msgContenido[id] = (cont != null) ? cont : "...";
  msgTipoMaldad[id] = maldad;
  msgTiempoRestante[id] = 1.0;
  msgVerificado[id] = false;
  msgCategoriaEspecial[id] = 0;
  msgNivelEncriptado[id] = 0.0;
  msgFueDesencriptado[id] = false;
  msgEnergiaSacudida[id] = 0.0;
  msgUltimoSentidoSacudida[id] = 0;
  msgConteoSacudidasCompletas[id] = 0;
  msgFrameUltimaSacudida[id] = 0;
  msgSemillaAvatar[id] = int(random(100, 999));

  msgDominio[id] = "dolus@net";
  msgAsunto[id] = "FEED // RED SOCIAL";
  msgIndiceSello[id] = -1;
  msgIndiceArchivo[id] = 0;
  msgExtensionArchivo[id] = ".pdf";
  msgTieneAdjunto[id] = false;
  msgEsCorporativo[id] = false;
  msgEsValido[id] = (maldad == 0);
  msgMotivoInvalidez[id] = (maldad == 0) ? 0 : (maldad == 2 ? 4 : 1);
  msgTipoMensaje[id] = TIPO_MENSAJE_NORMAL;

  if (maldad == 0) msgEtiquetaMeta[id] = "RED: dolus@net";
  else {
    if (maldad == 1) msgEtiquetaMeta[id] = "TRAFICO: HOSTIL";
    else {
      if (maldad == 2) msgEtiquetaMeta[id] = "ADJ: EJECUTABLE";
      else msgEtiquetaMeta[id] = "RED: DESCONOCIDA";
    }
  }

  msgNumLineasCacheadas[id] = 0;
  msgTamTextoCache[id] = 19.0;
  msgTextoCacheRef[id] = "";
  msgAnchoCacheRef[id] = -1.0;
  msgCacheTextoCifrado[id] = "";
  msgBloqueFrameCifrado[id] = -1;
  msgUltimoNivelCifradoCache[id] = -1.0;
}

int crearMensajeDolus(String rem, String cont, int maldad) {
  int id = cursorPoolMensaje;
  cursorPoolMensaje++;
  if (cursorPoolMensaje >= 128) cursorPoolMensaje = 16;
  inicializarSlotMensajeDolus(id, rem, cont, maldad);
  return id;
}

int crearMensajeDolusFijo(String rem, String cont, int maldad) {
  int id = cursorPoolMensajeFijo;
  cursorPoolMensajeFijo++;
  if (cursorPoolMensajeFijo >= 16) cursorPoolMensajeFijo = 0;
  inicializarSlotMensajeDolus(id, rem, cont, maldad);
  return id;
}

int mensajeActivo = -1;

int[] bandejaMensajes = new int[32];
int numBandejaMensajes = 0;

int timerNuevoMensaje = 0;
int intervaloMensajes = 180;
int cartasGeneradasEnRonda = 0;

void elegirDirectivaRonda() {
  if (jefeActivo != 0) {
    directivaRondaActual = 0;
    return;
  }
  if (rondaActual == 1) {

    directivaRondaActual = (random(1) < 0.5) ? 2 : 4;
  } else {
    directivaRondaActual = int(random(1, 5));
  }
}

String obtenerNombreDirectiva() {
  if (directivaRondaActual == 1) return "DIRECTIVA: CAZA DE EJECUTABLES";
  if (directivaRondaActual == 2) return "DIRECTIVA: CERO TOLERANCIA TROLL";
  if (directivaRondaActual == 3) return "DIRECTIVA: AUDITORIA ANTICORRUPCION";
  if (directivaRondaActual == 4) return "DIRECTIVA: RESPUESTA VELOZ";
  return "DIRECTIVA: FLUJO ESTANDAR";
}

String obtenerDescDirectiva() {
  if (directivaRondaActual == 1) return "Rechazar Malware (.EXE) otorga +3 Tokens extra";
  if (directivaRondaActual == 2) return "Rechazar Trolls recupera +6 Salud Mental y +2 Combo";
  if (directivaRondaActual == 3) return "Rechazar Sobornos Dorados da +8 Tokens limpios";
  if (directivaRondaActual == 4) return "Decidir con >65% de barra de tiempo da +2 Tokens";
  return "Modera el trafico y cuida las 4 barras de integridad";
}

boolean animandoShowcaseDirectiva = false;
int tipoShowcaseActivo = 0;
int frameShowcaseEntrada = 0;
float progresoHoldShowcase = 0.0;
boolean presionandoHoldShowcase = false;
boolean showcaseConfirmado = false;
int frameShowcaseSalida = 0;
float pulsoDirectivaBanner = 0.0;

void dispararShowcaseDirectiva() {
  if (jefeActivo != 0 || mostrandoTutorial) return;
  tipoShowcaseActivo = 0;
  animandoShowcaseDirectiva = true;
  frameShowcaseEntrada = 0;
  progresoHoldShowcase = 0.0;
  presionandoHoldShowcase = false;
  showcaseConfirmado = false;
  frameShowcaseSalida = 0;
  if (stingerTransicion != null) reproducirSFX(stingerTransicion);
  else reproducirTap();
}

void dispararShowcaseMecanicaJefe(int tipoJefe) {
  tipoShowcaseActivo = tipoJefe;
  animandoShowcaseDirectiva = true;
  frameShowcaseEntrada = 0;
  progresoHoldShowcase = 0.0;
  presionandoHoldShowcase = false;
  showcaseConfirmado = false;
  frameShowcaseSalida = 0;
  if (stingerTransicion != null) reproducirSFX(stingerTransicion);
  else reproducirTap();
}

void saltarShowcaseDirectiva() {
  if (!animandoShowcaseDirectiva) return;
  progresoHoldShowcase = 1.0;
  showcaseConfirmado = true;
  frameShowcaseSalida = 0;
  reproducirClickUI(true);
}

void actualizarShowcaseDirectiva() {
  if (!animandoShowcaseDirectiva || mostrandoTutorial) return;

  if (frameShowcaseEntrada < 16) {
    frameShowcaseEntrada++;
  } else {
    if (!showcaseConfirmado) {

      boolean holdActivo = presionandoHoldShowcase || mousePressed;
      if (holdActivo) {
        progresoHoldShowcase = min(1.0, progresoHoldShowcase + 0.038);
        float cx = width * 0.58;
        float cy = height * 0.40 + 112;
        color cEfecto = (tipoShowcaseActivo > 0) ? color(255, 60, 60) : colorTema();
        if (frameCount % 4 == 0) {
          dispararExplosionCarta(cx + random(-22, 22), cy + random(-22, 22), cEfecto, false);
        }
        if (frameCount % 6 == 0) {
          reproducirTap();
        }
        if (progresoHoldShowcase >= 1.0) {
          showcaseConfirmado = true;
          frameShowcaseSalida = 0;
          reproducirClickUI(true);
          dispararExplosionCarta(cx, cy, cEfecto, true);
          dispararSacudidaCamara(4.5);
        }
      } else {
        progresoHoldShowcase = max(0.0, progresoHoldShowcase - 0.06);
      }
    } else {

      frameShowcaseSalida++;
      if (frameShowcaseSalida >= 20) {
        animandoShowcaseDirectiva = false;
        frameShowcaseEntrada = 0;
        frameShowcaseSalida = 0;
        progresoHoldShowcase = 0.0;
        showcaseConfirmado = false;
        presionandoHoldShowcase = false;
        pulsoDirectivaBanner = 1.0;

        if (tipoShowcaseActivo > 0) {
          int jefeAIniciar = tipoShowcaseActivo;
          tipoShowcaseActivo = 0;
          inicializarJefe(jefeAIniciar);
        }
      }
    }
  }
}

void dibujarShowcaseDirectiva() {
  if (!animandoShowcaseDirectiva || mostrandoTutorial) return;

  pushStyle();
  rectMode(CORNER);

  float cx = width * 0.58;
  float cy = height * 0.40;
  float w = 640;
  float h = 136;

  float escala = 1.0;
  float xBox = cx;
  float yBox = cy;
  float angulo = 0.0;
  float alphaBox = 255.0;
  float alphaFondo = 180.0;

  if (frameShowcaseEntrada < 16) {

    float tEntrada = frameShowcaseEntrada / 16.0;
    float zoomProg = 1.0 - pow(1.0 - tEntrada, 3.0);
    escala = 0.25 + 0.90 * zoomProg;
    if (frameShowcaseEntrada >= 11) {
      escala = 1.15 - 0.15 * ((frameShowcaseEntrada - 11.0) / 5.0);
    }
    alphaFondo = min(180, frameShowcaseEntrada * 12.0);
  } else {
    if (!showcaseConfirmado) {

      float pulso = sin(frameCount * 0.12) * 0.012;
      escala = 1.0 + pulso + progresoHoldShowcase * 0.035;
      angulo = sin(frameCount * 0.08) * 0.006;
      alphaFondo = 180.0;
    } else {

      float tSalida = frameShowcaseSalida / 20.0;
      float curva = pow(tSalida, 2.8);
      xBox = cx + curva * (width * 0.85);
      yBox = cy - curva * 140.0;
      angulo = curva * 0.24;
      escala = 1.0 + curva * 0.28;
      alphaBox = constrain((1.0 - pow(tSalida, 3.0)) * 255.0, 0, 255);
      alphaFondo = (1.0 - tSalida) * 180.0;
    }
  }

  if (alphaFondo > 1.0) {
    noStroke();
    fill(4, 8, 12, alphaFondo);
    rect(0, 0, width, height);
  }

  pushMatrix();
  translate(xBox, yBox);
  rotate(angulo);
  scale(escala);

  rectMode(CENTER);
  color colTemaAct = colorTema();
  if (tipoShowcaseActivo == 1) colTemaAct = color(255, 45, 175);
  else {
    if (tipoShowcaseActivo == 2) colTemaAct = color(0, 220, 255);
    else {
      if (tipoShowcaseActivo == 3) colTemaAct = color(255, 180, 45);
      else {
        if (tipoShowcaseActivo == 4) colTemaAct = color(255, 55, 55);
      }
    }
  }

  noStroke();
  fill(0, 160 * (alphaBox / 255.0));
  rect(10, 12, w, h, 14);

  fill(10, 18, 24, 242 * (alphaBox / 255.0));
  stroke(colTemaAct, 240 * (alphaBox / 255.0));
  strokeWeight(2.5);
  rect(0, 0, w, h, 14);

  stroke(colTemaAct, 28 * (alphaBox / 255.0));
  strokeWeight(1);
  for (float ly = -h * 0.45; ly < h * 0.45; ly += 14) {
    line(-w * 0.46, ly, w * 0.46, ly);
  }

  rectMode(CORNER);
  noStroke();
  fill(red(colTemaAct), green(colTemaAct), blue(colTemaAct), 60 * (alphaBox / 255.0));
  rect(-w * 0.5 + 24, -h * 0.5 + 14, 185, 22, 4);

  textAlign(CENTER, CENTER);
  if (fuenteRetro != null) textFont(fuenteRetro);
  textSize(11);
  fill(colTemaAct, 255 * (alphaBox / 255.0));
  String tagL = (tipoShowcaseActivo > 0) ? "// ALERTA AMENAZA //" : "// DIRECTIVA RONDA " + rondaActual + " //";
  text(tagL, -w * 0.5 + 116, -h * 0.5 + 25);

  textAlign(RIGHT, CENTER);
  fill(240, 245, 220, 200 * (alphaBox / 255.0));
  textSize(11);
  String tagR = (tipoShowcaseActivo > 0) ? "[ PROTOCOLO DE JEFE ]" : "[ REGLA DEL SISTEMA ]";
  text(tagR, w * 0.5 - 28, -h * 0.5 + 25);

  textAlign(CENTER, CENTER);
  textSize(22);
  fill(255, 255, 240, 255 * (alphaBox / 255.0));
  String titShowcase = obtenerNombreDirectiva();
  String descShowcase = obtenerDescDirectiva();
  if (tipoShowcaseActivo == 1) {
    titShowcase = "TENDENCIA VIRAL // [FIEBRE VIRAL]";
    descShowcase = modoExposicionActivo
      ? "Feed acelerado con clones virales. Sobrevive 16s o alcanza 4 aciertos sin colapsar tus stats."
      : "Feed acelerado a tope con clones virales. Sobrevive 60s sin colapsar tus stats.";
  } else {
    if (tipoShowcaseActivo == 2) {
      titShowcase = "CAMARA DE ECO // [INERCIA DE ECO]";
      descShowcase = modoExposicionActivo
        ? "Repetir direccion consecutivamente drena salud mental. Alterna y halla 2 anomalias."
        : "Repetir direccion consecutivamente drena salud mental. Alterna y halla 3 anomalias.";
    } else {
      if (tipoShowcaseActivo == 3) {
        titShowcase = "MR. DEEPFAKE // [CEBO DORADO]";
        descShowcase = "Deepfakes con premios falsos. Pulsa [ESPACIO] para usar tu escaner antes de decidir.";
      } else {
        if (tipoShowcaseActivo == 4) {
          titShowcase = "EL ALGORITMO SUPREMO // [SUPRESION]";
          descShowcase = "Supresion de Nodo: Bloqueara y anulara un plugin equipado al azar durante el combate.";
        }
      }
    }
  }
  text(titShowcase, 0, -14);

  stroke(colTemaAct, 180 * (alphaBox / 255.0));
  strokeWeight(1.8);
  line(-w * 0.42, 8, w * 0.42, 8);

  noStroke();
  textSize(13.5);
  fill(210, 245, 230, 245 * (alphaBox / 255.0));
  text(descShowcase, 0, 36);

  float yCirculo = 112;
  float diametro = 38;

  stroke(colTemaAct, 110 * (alphaBox / 255.0));
  strokeWeight(2.0);
  line(-70, h * 0.5, -70, yCirculo - 24);
  line(70, h * 0.5, 70, yCirculo - 24);

  rectMode(CENTER);
  noStroke();
  fill(0, 150 * (alphaBox / 255.0));
  rect(4, yCirculo + 4, 340, 48, 14);

  fill(8, 14, 20, 245 * (alphaBox / 255.0));
  stroke(colTemaAct, 220 * (alphaBox / 255.0));
  strokeWeight(2.0);
  rect(0, yCirculo, 340, 48, 14);

  float bounceY = sin(frameCount * 0.24) * 3.5;
  float yFlechaSuperior = yCirculo - 32 + bounceY;
  textAlign(CENTER, CENTER);
  if (progresoHoldShowcase <= 0.01) {
    float alphaPrompt = (180 + sin(frameCount * 0.28) * 75) * (alphaBox / 255.0);
    fill(colTemaAct, alphaPrompt);
    textSize(11.5);
    String promptTxt = (tipoShowcaseActivo > 0) ? "v  MANTEN AQUI PARA INICIAR COMBATE  v" : "v  MANTEN AQUI PARA CONTINUAR  v";
    text(promptTxt, 0, yFlechaSuperior);
  } else {
    fill(255, 255, 240, 255 * (alphaBox / 255.0));
    textSize(12);
    String cargaTxt = (tipoShowcaseActivo > 0) ? ">> SINCRONIZANDO COMBATE: " : ">> CARGANDO SISTEMA: ";
    text(cargaTxt + int(progresoHoldShowcase * 100) + "% <<", 0, yFlechaSuperior);
  }

  for (int i = 0; i < 3; i++) {

    float arrowXLeft = -56 - i * 20;
    float alphaArrowL = map(sin(frameCount * 0.22 + (2 - i) * 0.8), -1, 1, 90, 255);
    stroke(colTemaAct, alphaArrowL * (alphaBox / 255.0));
    strokeWeight(2.5);
    noFill();
    beginShape();
    vertex(arrowXLeft - 6, yCirculo - 9);
    vertex(arrowXLeft + 4, yCirculo);
    vertex(arrowXLeft - 6, yCirculo + 9);
    endShape();

    float arrowXRight = 56 + i * 20;
    float alphaArrowR = map(sin(frameCount * 0.22 + (2 - i) * 0.8), -1, 1, 90, 255);
    stroke(colTemaAct, alphaArrowR * (alphaBox / 255.0));
    strokeWeight(2.5);
    noFill();
    beginShape();
    vertex(arrowXRight + 6, yCirculo - 9);
    vertex(arrowXRight - 4, yCirculo);
    vertex(arrowXRight + 6, yCirculo + 9);
    endShape();
  }

  noFill();
  stroke(colTemaAct, 70 * (alphaBox / 255.0));
  strokeWeight(3.5);
  ellipse(0, yCirculo, diametro, diametro);

  if (progresoHoldShowcase > 0.005) {
    stroke(showcaseConfirmado ? color(255) : colTemaAct, 255 * (alphaBox / 255.0));
    strokeWeight(4.5);
    arc(0, yCirculo, diametro, diametro, -HALF_PI, -HALF_PI + TWO_PI * progresoHoldShowcase);
  }

  noStroke();
  fill(colTemaAct, (60 + 195 * progresoHoldShowcase) * (alphaBox / 255.0));
  float rCore = (16 + 8 * progresoHoldShowcase);
  ellipse(0, yCirculo, rCore, rCore);

  fill(200, 220, 210, 140 * (alphaBox / 255.0));
  textSize(9.5);
  text("[ MANTEN CLIC O ESPACIO ]", 0, yCirculo + 32);

  popMatrix();
  popStyle();
}

String obtenerTextoMostradoCarta(int msg) {
  if (msg < 0) return "";
  if (msgCategoriaEspecial[msg] == 2 && msgNivelEncriptado[msg] > 0.05) {
    int bloque = frameCount / 4;
    if (bloque != msgBloqueFrameCifrado[msg] || abs(msgNivelEncriptado[msg] - msgUltimoNivelCifradoCache[msg]) > 0.04) {
      msgBloqueFrameCifrado[msg] = bloque;
      msgUltimoNivelCifradoCache[msg] = msgNivelEncriptado[msg];
      msgCacheTextoCifrado[msg] = cifrarTextoParcial(msgContenido[msg], msgNivelEncriptado[msg]);
    }
    return msgCacheTextoCifrado[msg];
  }
  return msgContenido[msg];
}

void asegurarCacheTextoCarta(int msg, String textoMostrar, float anchoMax, float altoMax, float tamMax) {
  if (msg < 0 || textoMostrar == null) return;
  if (msgTextoCacheRef[msg].equals(textoMostrar) && abs(msgAnchoCacheRef[msg] - anchoMax) < 1.0 && msgNumLineasCacheadas[msg] > 0) return;

  msgTextoCacheRef[msg] = textoMostrar;
  msgAnchoCacheRef[msg] = anchoMax;
  msgNumLineasCacheadas[msg] = 0;
  if (textoMostrar.length() == 0) return;

  pushStyle();
  if (fuenteRetro != null) textFont(fuenteRetro);
  float tamActual = tamMax;
  float tamMin = 10;

  while (tamActual >= tamMin) {
    textSize(int(tamActual));
    float interlineado = tamActual * 1.28;
    msgNumLineasCacheadas[msg] = 0;

    String[] bloques = dividirTexto(textoMostrar, "\n");
    int numBloques = contarTextos(bloques);
    for (int b = 0; b < numBloques; b++) {
      String[] palabras = dividirTexto(bloques[b], " ");
      int numPalabras = contarTextos(palabras);
      String linea = "";
      for (int i = 0; i < numPalabras; i++) {
        String pal = palabras[i];
        String prueba = (linea.length() == 0) ? pal : linea + " " + pal;
        if (textWidth(prueba) > anchoMax && linea.length() > 0) {
          if (msgNumLineasCacheadas[msg] < 32) {
            msgLineasCacheadas[msg][msgNumLineasCacheadas[msg]] = linea;
            msgNumLineasCacheadas[msg]++;
          }
          linea = pal;
        } else {
          linea = prueba;
        }
      }
      if (linea.length() > 0 && msgNumLineasCacheadas[msg] < 32) {
        msgLineasCacheadas[msg][msgNumLineasCacheadas[msg]] = linea;
        msgNumLineasCacheadas[msg]++;
      }
    }

    if (msgNumLineasCacheadas[msg] * interlineado <= altoMax) {
      break;
    }
    tamActual -= 1.5;
  }
  msgTamTextoCache[msg] = int(max(tamMin, tamActual));
  popStyle();
}

String cifrarTextoParcial(String original, float nivel) {
  if (original == null) return "";
  if (nivel <= 0.05) return original;
  String[] glifos = {"#", "?", "@", "0", "1", "X", "%", "&"};
  String res = "";
  int n = original.length();
  for (int i = 0; i < n; i++) {
    String ch = original.substring(i, i + 1);
    if (ch.equals(" ")) {
      res = res + " ";
    } else {
      float umbral = ((i * 37 + frameCount / 4) % 100) / 100.0;
      if (umbral < nivel) {
        int idxG = (i * 13 + frameCount / 3) % 8;
        res = res + glifos[idxG];
      } else {
        res = res + ch;
      }
    }
  }
  return res;
}

int obtenerImpactoPrevistoStat(int statIdx, int dirSwipe) {
  if (mensajeActivo < 0) return 0;

  if (msgCategoriaEspecial[mensajeActivo] == 2 && msgNivelEncriptado[mensajeActivo] > 0.35) {
    return 1;
  }
  if (msgCategoriaEspecial[mensajeActivo] == 4) {
    return 0;
  }
  int m = msgTipoMaldad[mensajeActivo];
  int cat = msgCategoriaEspecial[mensajeActivo];

  if (cat == 1) {
    if (dirSwipe == 0) {
      if (statIdx == 1 || statIdx == 2) return 2;
      return 0;
    } else {
      if (statIdx == 2) return 1;
      return 0;
    }
  }

  if (dirSwipe == 0) {
    if (m == 0) {
      if (statIdx == 3) return 2;
      if (statIdx == 0 || statIdx == 2) return 1;
    } else {
      if (m == 1) {
        if (statIdx == 0 || statIdx == 2) return 2;
        if (statIdx == 3) return 1;
      } else {
        if (m == 2 || m == 5) {
          if (statIdx == 1 || statIdx == 0) return 2;
        }
      }
    }
  } else {
    if (dirSwipe == 1) {
      if (m == 0) {
        if (statIdx == 3) return 2;
        if (statIdx == 0) return 1;
      } else {
        if (m == 1) {
          if (statIdx == 0) return 2;
        } else {
          if (m == 2 || m == 5) {
            if (statIdx == 1) return 2;
          }
        }
      }
    }
  }
  return 0;
}

void inicializarDiaDolus() {
  estadoMusicaGameplay = 0;
  mostrarTextoComboMaestro = false;
  timerComboMaestro = 0;
  reproducirMusicaUnica(musicaGameplayInicial);

  statPopularidad = 50.0;
  statSeguridad = 50.0;
  statReputacion = 50.0;
  statSaludMental = 50.0;
  dispPopularidad = 50.0;
  dispSeguridad = 50.0;
  dispReputacion = 50.0;
  dispSaludMental = 50.0;

  balanzaEstabilidad = 0;
  dispBalanzaEstabilidad = 0.0;
  ultimoEmpujonActivo = false;
  ultimoEmpujonAnunciado = false;
  resetearMensajesUsadosRonda();
  vidasJugador = 1;

  comboActual = 0;
  comboMaximoRonda = 0;
  reiniciarMarcoFuegoDolus();
  tokensDolus = 0;
  tokensInicioRonda = 0;
  liqFarmRonda = 0;
  liqPromIntegridad = 50;
  liquidacionCalculada = false;
  numBandejaMensajes = 0;
  limpiarColaMensajes();
  numCartasSaliendo = 0;
  numParticulasRielSwipe = 0;
  numRayosRielSwipe = 0;
  numParticulasJuego = 0;
  limpiarColaEventos();
  arrastrando_mensaje = false;
  swipePosX = 0; swipePosY = 0;
  swipeSpringVelX = 0; swipeSpringVelY = 0;
  swipeOffsetX = 0; swipeOffsetY = 0;
  rielSpotlightAlpha = 0;
  frenesiSwipeVisual = 0;
  animandoSalidaLiquidacion = false;
  progresoSalidaLiquidacion = 0.0;
  mensajeActivo = -1;
  timerNuevoMensaje = 45;
  cartasGeneradasEnRonda = 0;
  consecutivosInocente = 0;
  consecutivosMalo = 0;

  int jefePrevio = jefeActivo;
  resetearEstadosPlugins();
  if (jefePrevio != 0) {
    inicializarJefe(jefePrevio);
  } else {
    elegirDirectivaRonda();
  }
  inicializarPluginsGameplay();
  inicializarSinergias();
  evaluarSinergias();
}

void reproducirTickLiquidacion(float pitch, boolean tieneBono) {
  if (sndHoverPlugin != null) {
    reproducirSFXConTono(sndHoverPlugin, tieneBono ? pitch : 0.80, tieneBono ? 0.60 : 0.28);
  }
  if (tieneBono && sonidoCursorClick1 != null && sonidoCursorClick1.frames() > 0) {
    reproducirSFXConTono(sonidoCursorClick1, constrain(pitch * 0.96, 0.85, 1.45), 0.85);
  } else {
    if (!tieneBono && sonidoCursorClick2 != null && sonidoCursorClick2.frames() > 0) {
      reproducirSFXConTono(sonidoCursorClick2, 0.82, 0.45);
    }
  }
}

void actualizarLiquidacionRonda() {
  if (animandoSalidaLiquidacion) {
    progresoSalidaLiquidacion += 0.065;
    if (progresoSalidaLiquidacion >= 1.0) {
      progresoSalidaLiquidacion = 1.0;
      animandoSalidaLiquidacion = false;
      boolean irAEpilogoFinal = (jefeActivo == 4 && ultimoJefeDerrotado);
      rondaCompletada = false;
      liquidacionCalculada = false;
      timerTransicionTienda = 0;
      limpiarColaMensajes();
      tutEjecutableEnCola = tutIngameEjecutableVisto;
      tutTyposquatEnCola = tutIngameTyposquatVisto;
      tutSelloCorpEnCola = tutIngameSelloCorpVisto;
      tutSobornoEnCola = tutIngameSobornoVisto;
      tutEncriptadaEnCola = tutIngameEncriptadaVisto;
      tutBombaEnCola = tutIngameBombaVisto;
      tutContaminadaEnCola = tutIngameContaminadaVisto;
      numCartasSaliendo = 0;
      numParticulasRielSwipe = 0;
      numRayosRielSwipe = 0;
      rielSpotlightAlpha = 0;
      mensajeActivo = -1;
      jefeActivo = 0;
      conversanteActual = 0;
      jefePendiente = 0;
      if (jefeActivo == 3) {
        iniciarSecuenciaGlitchEscapeDeepfake();
        return;
      }
      if (irAEpilogoFinal) {
        iniciarCinematicaFinalVR();
      } else {
        estadoPantalla = PANTALLA_TIENDA;
        animandoTransicionTienda = true;
        sentidoTransicionTienda = 1;
        progresoTransicionTienda = 0.0;
      }
    }
    return;
  }

  timerTransicionTienda += 1.0;
  if (!liquidacionCalculada) {
    liquidacionCalculada = true;
    detenerTodaMusica();
    if (stingerTransicion != null) reproducirSFX(stingerTransicion);
    estadoMusicaGameplay = -1;

    for (int i = numEventosJuego - 1; i >= 0; i--) {
      if (evTipo[i] == 4) {
        tokensDolus = max(0, tokensDolus + evValorExtra[i]);
        eliminarEventoJuegoEn(i);
      }
    }

    liqFarmRonda = tokensDolus - tokensInicioRonda;
    liqBase = modoExposicionActivo ? (75 + rondaActual * 10) : (6 + rondaActual * 2);
    liqComboBonus = (comboMaximoRonda / 2) * (sinergiaActiva(4) ? 2 : 1);
    float promInt = (statPopularidad + statSeguridad + statReputacion + statSaludMental) * 0.25;
    liqPromIntegridad = int(constrain(promInt, 0, 100));
    liqIntegridadBonus = (promInt >= 65.0) ? 5 : ((promInt >= 45.0) ? 2 : 0);
    liqInteres = min(15, max(0, tokensDolus) / 10);
    liqTotal = liqBase + liqComboBonus + liqIntegridadBonus + liqInteres;

    generarOpcionesTienda();
  }

  int f = int(timerTransicionTienda);
  if (f == 11) {

    dispararSacudidaCamara(13.0);
    dispararExplosionCarta(width * 0.5, height * 0.5, colorTema(), true);
    dispararRayoFlourish(width * 0.5, height * 0.5, colorTema(), 1);
    if (sonidoHerramientaUso != null) reproducirSFX(sonidoHerramientaUso);
    else reproducirClickUI(false);
  } else {
    if (f == 14) {
      reproducirTickLiquidacion(0.95, liqBase > 0);
      dispararSacudidaCamara(liqBase > 0 ? 2.6 : 1.0);
    } else {
      if (f == 23) {
        reproducirTickLiquidacion(1.10, liqComboBonus > 0);
        dispararSacudidaCamara(liqComboBonus > 0 ? 2.6 : 1.0);
      } else {
        if (f == 32) {
          reproducirTickLiquidacion(1.25, liqIntegridadBonus > 0);
          dispararSacudidaCamara(liqIntegridadBonus > 0 ? 2.6 : 1.0);
        } else {
          if (f == 41) {
            reproducirTickLiquidacion(1.40, liqInteres > 0);
            dispararSacudidaCamara(liqInteres > 0 ? 2.6 : 1.0);
          } else {
            if (f == 53) {
              reproducirTickLiquidacion(1.62, true);
              if (sonidoTransferenciaExitosa != null) reproducirSFX(sonidoTransferenciaExitosa);
              dispararSacudidaCamara(6.5);
              dispararExplosionCarta(width * 0.5, height * 0.5 + 82, color(255, 215, 80), false);
              dispararRayoFlourish(width * 0.5, height * 0.5 + 82, color(255, 215, 80), 0);
            } else {
              if (f == FRAMES_FIN_LIQUIDACION) {
                reproducirClickUI(false);
                dispararSacudidaCamara(1.8);
              }
            }
          }
        }
      }
    }
  }
}

void confirmarLiquidacionRonda() {
  if (!rondaCompletada) return;

  if (timerTransicionTienda < FRAMES_FIN_LIQUIDACION) {
    return;
  }
  if (animandoSalidaLiquidacion) return;

  tokensDolus = max(0, tokensDolus + liqTotal);
  pulsoTokensUI = 1.0;
  fijarProgresoMaximoLogro(8, tokensDolus);
  reproducirClickUI(true);
  if (!ultimoJefeDerrotado) {
    reproducirMusicaUnica(musicaMenu);
  }

  if (sndCardFan == null) {
    sndCardFan = cargarSonido("cardFan2.ogg");
  }
  if (sndCardFan != null) {
    reproducirSFX(sndCardFan);
  } else {
    if (sndVueloPlugin != null) {
      reproducirSFX(sndVueloPlugin);
    }
  }

  animandoSalidaLiquidacion = true;
  progresoSalidaLiquidacion = 0.0;
}

void actualizarLogicaDolus() {
  if (animandoShowcaseDirectiva) {
    actualizarShowcaseDirectiva();
    return;
  }
  actualizarColaEventos();
  actualizarJuiceYCamara();

  if (rondaCompletada) {
    actualizarAnimacionSalidaSwipe();
    actualizarLiquidacionRonda();
    return;
  }

  if (comboActual > comboMaximoRonda) {
    comboMaximoRonda = comboActual;
  }
  if (comboActual > 0) {
    fijarProgresoMaximoLogro(1, comboActual);
  }

  if (modoFeriaActivo) {
    feriaTiempoSobrevividoSeg = max(feriaTiempoSobrevividoSeg, (millisJuego() - feriaInicioMs) / 1000);
    if ((feriaNivelPresion >= 3 || comboActual >= 8) && (estadoMusicaGameplay == 0 || estadoMusicaGameplay == -1)) {
      estadoMusicaGameplay = 1;
      if (stingerTransicion != null) reproducirSFX(stingerTransicion);
      reproducirMusicaUnica(musicaGameplayIntenso);
    }
  } else {
    if (comboActual >= 10 && (estadoMusicaGameplay == 0 || estadoMusicaGameplay == -1)) {
      estadoMusicaGameplay = 1;
      if (stingerTransicion != null) reproducirSFX(stingerTransicion);
      if (jefeActivo == 0) {
        reproducirMusicaUnica(musicaGameplayIntenso);
      }
    } else {
      if (comboActual < 10 && estadoMusicaGameplay == 1) {
        estadoMusicaGameplay = 0;
        if (stingerTransicion != null) reproducirSFX(stingerTransicion);
        if (jefeActivo == 0) {
          reproducirMusicaUnica(musicaGameplayInicial);
        }
      }
    }
  }

  if (!diaInicializado) {
    inicializarDiaDolus();
    diaInicializado = true;
  }

  if (!modoFeriaActivo && !mostrandoTutorial && !mostrandoTutorialIngame && mensajeActivo >= 0 && !cardEntrando && jefeActivo == 0) {
    verificarDisparoTutorialIngame(mensajeActivo);
  }

  if (mostrandoTutorial || mostrandoTutorialIngame) {
    actualizarAnimacionesCarta();
    return;
  }

  if (juegoPausadoPorPlugin()) {
    return;
  }

  actualizarTemporizadoresPlugins();

  if (singularidadActiva) return;

  if (mensajeActivo >= 0 && msgCategoriaEspecial[mensajeActivo] == 2 && msgNivelEncriptado[mensajeActivo] > 0.0) {
    if (frameCount % 18 == 0 && cardHover) {
      dispararExplosionCarta(width * 0.64 + random(-100, 100), height * 0.45 + random(-50, 50), color(0, 240, 255), false);
    }
  }

  if (sinergiaActiva(2) && frameCount % 600 == 0) {
    encolarEvento(1, 4, "", 0, 0, color(255, 215, 80), 2);
    dispararTextoElastico("SYN CAOS +2T", width * 0.15, height * 0.24, color(255, 215, 80));
  }

  if (modoFeriaActivo) {
    intervaloMensajes = obtenerIntervaloSpawnFeria();
    ultimoEmpujonActivo = false;
  } else if (modoExposicionActivo) {
    intervaloMensajes = 42;
    ultimoEmpujonActivo = false;
  } else {
    intervaloMensajes = int(map(statPopularidad, 0, 100, 120, 30));
    if (pluginEquipado(2)) intervaloMensajes *= 1.25;
    if (pluginEquipado(12)) intervaloMensajes *= 0.7;
    if (pluginEquipado(20)) intervaloMensajes *= 0.5;
    boolean ahoraEmpujon = esUltimoEmpujonActivo();
    if (ahoraEmpujon && !ultimoEmpujonActivo) {
      ultimoEmpujonActivo = true;
      limpiarColaMensajes();
      timerNuevoMensaje = min(timerNuevoMensaje, 12);
      if (!ultimoEmpujonAnunciado) {
        ultimoEmpujonAnunciado = true;
        dispararTextoElastico("ULTIMO EMPUJON!", width * 0.64, height * 0.30, color(255, 215, 70));
        dispararSacudidaCamara(5.5);
      }
    } else {
      if (!ahoraEmpujon) {
        ultimoEmpujonActivo = false;
      }
    }
    if (ultimoEmpujonActivo) {
      intervaloMensajes = int(intervaloMensajes * 0.72);
    }
    intervaloMensajes = max(14, intervaloMensajes);
  }

  if (comboActual > 0) {
    tiempoComboRestante--;
    if (tiempoComboRestante <= 0) {
      comboActual = 0;
    }
  }

  if (jefeActivo == 1) {
    if (faseJefe1 == 1) intervaloMensajes = 60;
    else {
      if (faseJefe1 == 2) intervaloMensajes = 45;
      else {
        if (faseJefe1 == 3) intervaloMensajes = 30;
      }
    }
  }

  actualizarLogicaJefes();

  if (estadoTransicionJefe) {
    return;
  }

  if (!jammingActivo && !invisibleActivo) {
    timerNuevoMensaje--;
    if (timerNuevoMensaje <= 0 && numColaMensajes < (modoExposicionActivo ? 2 : 6)) {
      generarMensajeAleatorio();
      timerNuevoMensaje = intervaloMensajes;
    }
  }

  intentarAsignarMensaje();
  if (!modoFeriaActivo && !mostrandoTutorial && !mostrandoTutorialIngame && mensajeActivo >= 0 && !cardEntrando && jefeActivo == 0) {
    verificarDisparoTutorialIngame(mensajeActivo);
    if (mostrandoTutorialIngame) {
      actualizarAnimacionesCarta();
      return;
    }
  }
  actualizarAnimacionSalidaSwipe();

  if (!bulletTimeActivo && !invisibleActivo) {
    if (!modoFeriaActivo && !modoExposicionActivo) {
      for (int i = numColaMensajes - 1; i >= 0; i--) {
        int m = colaMensajes[i];

        float velDecaimiento = map(statSaludMental, 100, 0, 0.0006, 0.0012);
        if (pluginEquipado(1) && msgTipoMaldad[m] == 2) velDecaimiento *= 0.6;
        if (voucherSpamFilterActivo && (msgTipoMaldad[m] == 1 || msgTipoMaldad[m] == 5 || msgTipoMaldad[m] == 7)) velDecaimiento *= 0.60;
        msgTiempoRestante[m] -= velDecaimiento;

        if (msgTiempoRestante[m] <= 0) {
          if (pluginEquipado(7)) {
            statSaludMental += 2.0;
            pulsarBarraStat(0);
            int slBucle = slotConPlugin(7);
            if (slBucle != -1) {
              juiceSlotPlugin(slBucle);
              dispararMarcoRayosPlugin(slBucle, color(100, 255, 200));
            }
          } else {
            statSaludMental -= 5.0;
            pulsarBarraStat(0);
            comboActual = 0;
          }
          eliminarColaMensajeEn(i);
        }
      }
    }

    if (mensajeActivo >= 0) {
      float decActiva;
      if (modoFeriaActivo) {
        decActiva = obtenerDecaimientoCartaFeria(mensajeActivo);
      } else {
        int metaBalDec = obtenerMetaBalanzaActual();
        float ventajaDec = (jefeActivo == 0) ? constrain((float)balanzaEstabilidad / max(1, metaBalDec), 0.0, 1.0) : 0.0;
        float factorRonda = (rondaActual == 1) ? 0.55 : ((rondaActual == 2) ? 0.70 : ((rondaActual == 3) ? 0.85 : 1.0));
        factorRonda *= (1.0 + pow(ventajaDec, 1.1) * 0.85);
        decActiva = 0.0019 * factorRonda;
        if (msgCategoriaEspecial[mensajeActivo] == 2 && msgNivelEncriptado[mensajeActivo] > 0.0) {
          decActiva *= 0.45;
        } else {
          if (msgCategoriaEspecial[mensajeActivo] == 4) {
            decActiva *= 0.45;
          } else {
            if (msgCategoriaEspecial[mensajeActivo] == 3) {
              decActiva *= 1.35;
            } else {
              if (ventajaDec > 0.5 && (msgTipoMensaje[mensajeActivo] == TIPO_MENSAJE_CAPCIOSO || msgMotivoInvalidez[mensajeActivo] == 3)) {
                decActiva *= 0.88;
              }
            }
          }
        }
        if (jefeActivo == 1) {
          decActiva += min(comboActual, 15) * 0.00015;
        }
        if (pluginEquipado(1) && msgTipoMaldad[mensajeActivo] == 2) {
          decActiva *= 0.6;
        }
        if (voucherSpamFilterActivo && (msgTipoMaldad[mensajeActivo] == 1 || msgTipoMaldad[mensajeActivo] == 5 || msgTipoMaldad[mensajeActivo] == 7)) {
          decActiva *= 0.60;
        }
      }
      if (modoExposicionActivo) {
        decActiva *= 0.65;
      }
      msgTiempoRestante[mensajeActivo] -= decActiva;

      if (pluginEquipado(16) && msgTipoMaldad[mensajeActivo] == 0 && msgCategoriaEspecial[mensajeActivo] != 1 && msgCategoriaEspecial[mensajeActivo] != 4 && msgTiempoRestante[mensajeActivo] < 0.15) {
        int slBot = slotConPlugin(16);
        if (slBot != -1) {
          juiceSlotPlugin(slBot);
          dispararMarcoRayosPlugin(slBot, colorTema());
        }
        iniciarSalidaSwipe(0, 25, 0);
      } else {
        if (msgTiempoRestante[mensajeActivo] <= 0) {
          if (msgCategoriaEspecial[mensajeActivo] == 4) {
            fallarCartaContaminada(mensajeActivo);
          } else {
            swipeOffsetX = 0; swipeOffsetY = 0;
            iniciarSalidaSwipe(2, 0, 15);
          }
        }
      }
    }
  }

  if (mensajeActivo >= 0 && msgCategoriaEspecial[mensajeActivo] == 4) {
    if (frameCount - msgFrameUltimaSacudida[mensajeActivo] > 45 && msgEnergiaSacudida[mensajeActivo] > 0.0) {
      msgEnergiaSacudida[mensajeActivo] = max(0.0, msgEnergiaSacudida[mensajeActivo] - 0.006);
      msgConteoSacudidasCompletas[mensajeActivo] = int(msgEnergiaSacudida[mensajeActivo] * 4.0);
    }
  }

  statPopularidad = constrain(statPopularidad, 0, 100);
  statSeguridad   = constrain(statSeguridad, 0, 100);
  statReputacion  = constrain(statReputacion, 0, 100);
  statSaludMental = constrain(statSaludMental, 0, 100);
  tokensDolus     = max(0, tokensDolus);

  if (voucherDeepFocusActivo) {
    statSaludMental = max(30.0, statSaludMental);
    if (comboActual >= 10) {
      statSaludMental = min(100.0, statSaludMental + 0.04);
    }
  }

  verificarGameOverStats();

  actualizarAnimacionesCarta();
}

void impulsarEscalaCarta(float sx, float sy) {
  cardVelEscalaX += (sx - 1.0) * 0.55;
  cardVelEscalaY += (sy - 1.0) * 0.55;
}

float calcularRotacionCartaActiva(float centroCartaX) {
  float factorTorque = 1.0 - swipePuntoAgarreRelY * 0.42;
  float rotDrag = swipePosX * SWIPE_PESO_ROT * factorTorque + swipeSpringVelX * 0.0012;
  float rotHover = (!arrastrando_mensaje && cardHover) ? ((mouseX - centroCartaX) / 250.0) * 0.032 : 0;
  float rotIdle = (!arrastrando_mensaje) ? sin(cardFloteAngulo * 0.7) * 0.010 : 0;
  return rotDrag + rotHover + rotIdle + cartaActivaJuiceRot;
}

void detonarCruceRielSwipe(int decision, float rielX, float cruceY, int catCarta) {
  float dirRebote = (decision == 0) ? -1.0 : 1.0;
  color cImpacto = (decision == 0)
    ? ((catCarta == 1) ? color(255, 225, 75) : colorTema())
    : color(255, 165, 65);

  if (numParticulasRielSwipe < 160) {
    int cantParticulas = 20 + int(frenesiSwipeVisual * 8);
    for (int i = 0; i < cantParticulas; i++) {
      float ang = atan2(random(-1.15, 1.15), dirRebote * random(0.45, 1.40));
      float vel = random(6.5, 23.0);
      agregarParticulaRielSwipe(
        rielX, cruceY + random(-42, 42),
        cos(ang) * vel, sin(ang) * vel,
        cImpacto, (i % 3 == 0)
      );
    }
  }

  if (numRayosRielSwipe < 12) {
    reproducirActivacionRayo();
    agregarRayoRielSwipe(
      rielX, cruceY, dirRebote,
      random(135, 175), random(-12, 12),
      68.0, cImpacto, 13
    );
    if (catCarta == 1 || catCarta == 3) {
      color colExtra = (catCarta == 1)
        ? ((decision == 0) ? color(255, 225, 75) : color(100, 255, 200))
        : color(255, 180, 40);
      agregarRayoRielSwipe(
        rielX, cruceY + random(-22, 22), dirRebote,
        random(160, 200), random(-22, 22),
        84.0, colExtra, 16
      );
    }
  }
  dispararSacudidaCamara(min(9.0, 4.2 + frenesiSwipeVisual * 2.5));
}

void actualizarAnimacionesCarta() {
  cardFloteAngulo += 0.05;
  swipeFlashUmbral = max(0, swipeFlashUmbral - 0.09);
  frenesiSwipeVisual = max(0, frenesiSwipeVisual - 0.008);

  float objSpot = (arrastrando_mensaje && mensajeActivo >= 0) ? 1.0 : 0.0;
  rielSpotlightAlpha = lerp(rielSpotlightAlpha, objSpot, 0.20);
  if (rielSpotlightAlpha < 0.006) rielSpotlightAlpha = 0.0;

  if (arrastrando_mensaje && mensajeActivo >= 0) {
    float rawX = mouseX - swipeInicioX;
    float rawY = (mouseY - swipeInicioY) * 0.58;

    float ratioMag = abs(rawX) / SWIPE_THRESHOLD;
    float tironExtraX = 0;
    if (ratioMag > 0.70) {
      float pMag = constrain((ratioMag - 0.70) / 0.65, 0, 1);
      float signo = (rawX > 0) ? 1.0 : -1.0;
      tironExtraX = signo * (pMag * pMag) * 34.0;
    }

    swipeTargetX = rawX + tironExtraX;
    swipeTargetY = rawY;

    boolean ahoraEnUmbral = abs(rawX) >= SWIPE_THRESHOLD;
    if (ahoraEnUmbral && !swipeCruzoUmbral) {
      swipeCruzoUmbral = true;
      swipeFlashUmbral = 1.0;
      impulsarEscalaCarta(1.10, 0.91);
    } else {
      if (!ahoraEnUmbral && swipeCruzoUmbral) {
        swipeCruzoUmbral = false;
        impulsarEscalaCarta(0.95, 1.05);
      }
    }
  } else {
    swipeTargetX = 0;
    swipeTargetY = 0;
  }

  float fuerzaX = (swipeTargetX - swipePosX) * SWIPE_SPRING_RIGIDEZ;
  float fuerzaY = (swipeTargetY - swipePosY) * SWIPE_SPRING_RIGIDEZ;
  swipeSpringVelX = (swipeSpringVelX + fuerzaX) * SWIPE_SPRING_AMORT;
  swipeSpringVelY = (swipeSpringVelY + fuerzaY) * SWIPE_SPRING_AMORT;
  swipePosX += swipeSpringVelX;
  swipePosY += swipeSpringVelY;

  if (!arrastrando_mensaje && abs(swipePosX) < 0.35 && abs(swipeSpringVelX) < 0.35) swipePosX = 0;
  if (!arrastrando_mensaje && abs(swipePosY) < 0.35 && abs(swipeSpringVelY) < 0.35) swipePosY = 0;

  swipeOffsetX = swipePosX;
  swipeOffsetY = swipePosY;

  float baseEsc = arrastrando_mensaje ? 1.055 : (cardHover ? 1.035 : 1.0);
  float engancheMag = arrastrando_mensaje ? constrain((abs(swipePosX) - SWIPE_THRESHOLD * 0.75) / 140.0, 0, 0.11) : 0;
  float rapidez = constrain(abs(swipeSpringVelX) * 0.0022, 0, 0.08) + engancheMag;
  float objEscX = baseEsc + rapidez + cartaActivaJuice;
  float objEscY = baseEsc - rapidez * 0.65 + cartaActivaJuice * 0.5;

  cardVelEscalaX = (cardVelEscalaX + (objEscX - cardEscalaX) * 0.34) * 0.66;
  cardVelEscalaY = (cardVelEscalaY + (objEscY - cardEscalaY) * 0.34) * 0.66;
  cardEscalaX += cardVelEscalaX;
  cardEscalaY += cardVelEscalaY;
  cardScaleActual = cardEscalaX;

  if (cardEntrando && mensajeActivo >= 0) {
    cardEntradaProgreso = lerp(cardEntradaProgreso, 1.0, 0.28);
    if (cardEntradaProgreso > 0.98) {
      cardEntradaProgreso = 1.0;
      cardEntrando = false;
    }
  }
}

void intentarAsignarMensaje() {
  if (mensajeActivo < 0 && numColaMensajes > 0) {
    mensajeActivo = colaMensajes[0];
    eliminarColaMensajeEn(0);
    cardEntradaProgreso = 0;
    cardEntrando = true;
    swipePosX = 0;
    swipePosY = 18;
    swipeSpringVelX = 0;
    swipeSpringVelY = -4.8;
    swipeOffsetX = 0;
    swipeOffsetY = 18;
    cardEscalaX = 0.93;
    cardEscalaY = 0.93;
    impulsarEscalaCarta(1.08, 0.93);
    swipeCruzoUmbral = false;
    cartaActivaJuiceRot = random(-0.025, 0.025);
    if (jefeActivo == 4) {
      rotarSlotSilenciadoAlgoritmo();
    }
  }
}

void actualizarAnimacionSalidaSwipe() {
  for (int i = numCartasSaliendo - 1; i >= 0; i--) {
    actualizarCartaSaliendo(i);
    if (csFueraDePanel[i]) {
      eliminarCartaSaliendoEn(i);
    }
  }
  for (int i = numParticulasRielSwipe - 1; i >= 0; i--) {
    actualizarParticulaRielSwipe(i);
    if (pRielVida[i] <= 0) {
      eliminarParticulaRielSwipeEn(i);
    }
  }
  for (int i = numRayosRielSwipe - 1; i >= 0; i--) {
    rRielAge[i]++;
    if (rRielAge[i] >= rRielTotalFrames[i]) {
      eliminarRayoRielSwipeEn(i);
    }
  }
}

int crearCartaEspecial(int catEspecial) {
  boolean permitirCorp = (rondaActual >= 4);
  if (catEspecial == 1) {
    int m = crearMensajeDolus("sponsor_vip", "...", 1);
    msgTipoMensaje[m] = TIPO_MENSAJE_NORMAL;
    msgCategoriaEspecial[m] = 1;
    msgDominio[m] = "dolus@net";
    msgAsunto[m] = "CONTRATO // PATROCINIO VIP";
    msgIndiceSello[m] = 3;
    msgTieneAdjunto[m] = true;
    msgIndiceArchivo[m] = 1;
    msgExtensionArchivo[m] = ".png";
    msgEsCorporativo[m] = false;
    msgEsValido[m] = false;
    msgMotivoInvalidez[m] = 1;
    msgEtiquetaMeta[m] = "SOBORNO: +28 TOKENS";
    aplicarPlantillaEspecialFeria(m, 1, true, false);
    return m;
  } else {
    if (catEspecial == 2) {
      boolean esMalo = (random(1) < 0.55);
      boolean usarCorp = permitirCorp && !esMalo;
      int m = crearMensajeDolus("nodo_oculto", "...", esMalo ? 2 : 0);
      msgTipoMensaje[m] = TIPO_MENSAJE_NORMAL;
      msgCategoriaEspecial[m] = 2;
      msgNivelEncriptado[m] = 1.0;
      msgTiempoRestante[m] = 1.55;
      msgDominio[m] = esMalo ? "darknet@onion" : (usarCorp ? "dolus@corp" : "dolus@net");
      msgAsunto[m] = usarCorp ? "SYS // NODO ENCRIPTADO" : "WEB // NODO ENCRIPTADO";
      msgIndiceSello[m] = usarCorp ? 0 : 4;
      msgTieneAdjunto[m] = true;
      msgIndiceArchivo[m] = esMalo ? 4 : 0;
      msgExtensionArchivo[m] = esMalo ? ".bat" : ".pdf";
      msgEsCorporativo[m] = usarCorp;
      msgEsValido[m] = !esMalo;
      msgMotivoInvalidez[m] = esMalo ? 4 : 0;
      msgEtiquetaMeta[m] = "CLIC RAPIDO P/ DESCIFRAR";
      aplicarPlantillaEspecialFeria(m, 2, esMalo, usarCorp);
      return m;
    } else {
      if (catEspecial == 3) {
        boolean esMalo = (random(1) < 0.65);
        boolean usarCorp = permitirCorp && !esMalo;
        int m = crearMensajeDolus("exploit_c4", "...", esMalo ? 2 : 0);
        msgTipoMensaje[m] = TIPO_MENSAJE_NORMAL;
        msgCategoriaEspecial[m] = 3;
        msgDominio[m] = esMalo ? "c4-exploit@net" : (usarCorp ? "dolus@corp" : "dolus@net");
        msgAsunto[m] = "ALERTA // MECHA RAPIDA!";
        msgIndiceSello[m] = esMalo ? 1 : (usarCorp ? 0 : -1);
        msgTieneAdjunto[m] = true;
        msgIndiceArchivo[m] = esMalo ? 3 : 2;
        msgExtensionArchivo[m] = esMalo ? ".exe" : ".doc";
        msgEsCorporativo[m] = usarCorp;
        msgEsValido[m] = !esMalo;
        msgMotivoInvalidez[m] = esMalo ? 4 : 0;
        msgEtiquetaMeta[m] = "MECHA RAPIDA: +6 TOKENS!";
        aplicarPlantillaEspecialFeria(m, 3, esMalo, usarCorp);
        return m;
      } else {
        int m = crearMensajeDolus("nodo_corrupto", "...", 2);
        msgTipoMensaje[m] = TIPO_MENSAJE_NORMAL;
        msgCategoriaEspecial[m] = 4;
        msgTiempoRestante[m] = 1.55;
        msgDominio[m] = "glitch@null";
        msgAsunto[m] = "SISTEMA // PURGA OBLIGADA!";
        msgIndiceSello[m] = 4;
        msgTieneAdjunto[m] = false;
        msgEsCorporativo[m] = false;
        msgEsValido[m] = false;
        msgMotivoInvalidez[m] = 5;
        msgEtiquetaMeta[m] = "SACUDE PARA PURGAR!";
        aplicarPlantillaEspecialFeria(m, 4, true, false);
        return m;
      }
    }
  }
}

void forzarCartaEspecialDebug(int catEspecial) {
  int m = crearCartaEspecial(catEspecial);
  mensajeActivo = m;
  cardEntradaProgreso = 0;
  cardEntrando = true;
  swipePosX = 0;
  swipePosY = 18;
  swipeSpringVelX = 0;
  swipeSpringVelY = -4.8;
  impulsarEscalaCarta(1.10, 0.90);
}

void generarMensajeAleatorio() {
  if (modoFeriaActivo) {
    generarMensajeModoFeria();
    return;
  }
  if (modoExposicionActivo) {
    generarMensajeModoExposicion();
    return;
  }
  cartasGeneradasEnRonda++;

  if (random(1) < 0.08 && !qteActivo) {
    iniciarQTEPrecision();
  }

  boolean forzarIntroEjecutable = (jefeActivo == 0 && rondaActual >= 2 && !tutIngameEjecutableVisto && !tutEjecutableEnCola && cartasGeneradasEnRonda >= 2);
  boolean forzarIntroSelloCorp  = (jefeActivo == 0 && !forzarIntroEjecutable && rondaActual >= 4 && !tutIngameSelloCorpVisto && !tutSelloCorpEnCola && cartasGeneradasEnRonda >= 2);
  boolean forzarIntroTyposquat  = (jefeActivo == 0 && !forzarIntroEjecutable && !forzarIntroSelloCorp && rondaActual >= 4 && !tutIngameTyposquatVisto && !tutTyposquatEnCola && cartasGeneradasEnRonda >= 6);
  boolean forzandoTutorial = (forzarIntroEjecutable || forzarIntroTyposquat || forzarIntroSelloCorp);
  boolean enUltimoEmpujon = esUltimoEmpujonActivo();

  int especialForzado = 0;
  if (jefeActivo == 0 && !forzandoTutorial && !enUltimoEmpujon) {
    if (rondaActual >= 2 && !tutIngameSobornoVisto && !tutSobornoEnCola && cartasGeneradasEnRonda >= 6) {
      especialForzado = 1;
    } else {
      if (rondaActual >= 4 && !tutIngameEncriptadaVisto && !tutEncriptadaEnCola && cartasGeneradasEnRonda >= 11) {
        especialForzado = 2;
      } else {
        if (rondaActual >= 5 && !tutIngameBombaVisto && !tutBombaEnCola && cartasGeneradasEnRonda >= 3) {
          especialForzado = 3;
        } else {
          if (rondaActual >= 5 && !tutIngameContaminadaVisto && !tutContaminadaEnCola && cartasGeneradasEnRonda >= 9) {
            especialForzado = 4;
          }
        }
      }
    }
  }

  if (rondaActual >= 2 && jefeActivo == 0 && !forzandoTutorial && !enUltimoEmpujon) {
    float probEspecial = constrain(0.18 + (rondaActual - 2) * 0.04, 0.18, 0.42);
    if (especialForzado > 0 || random(1) < probEspecial) {
      int tipoEsp = especialForzado;
      if (tipoEsp == 0) {
        if (rondaActual <= 3) {
          tipoEsp = 1;
        } else {
          if (rondaActual == 4) {
            float rEsp = random(1);
            tipoEsp = (rEsp < 0.35) ? 1 : ((rEsp < 0.70) ? 2 : 3);
          } else {
            float rEsp = random(1);
            tipoEsp = (rEsp < 0.25) ? 1 : ((rEsp < 0.50) ? 2 : ((rEsp < 0.75) ? 3 : 4));
          }
        }
      }
      if (tipoEsp == 1) tutSobornoEnCola = true;
      else {
        if (tipoEsp == 2) tutEncriptadaEnCola = true;
        else {
          if (tipoEsp == 3) tutBombaEnCola = true;
          else {
            if (tipoEsp == 4) tutContaminadaEnCola = true;
          }
        }
      }

      int mEsp = crearCartaEspecial(tipoEsp);
      if (pluginEquipado(8)) msgTiempoRestante[mEsp] += 0.25;
      encolarMensaje(mEsp);
      return;
    }
  }

  int metaBalGen = obtenerMetaBalanzaActual();
  float ventajaBal = (jefeActivo == 0) ? constrain((float)balanzaEstabilidad / max(1, metaBalGen), 0.0, 1.0) : 0.0;
  boolean permitirCorp = (rondaActual >= 4);

  boolean proximoValido = true;
  if (forzandoTutorial) {
    proximoValido = false;
  } else {
    if (consecutivosInocente >= 2) {
      proximoValido = false;
    } else {
      if (consecutivosMalo >= 2) {
        proximoValido = true;
      } else {
        if (enUltimoEmpujon) {
          proximoValido = (random(1) < 0.42);
        } else {
          float probValido = lerp(0.52, 0.36, ventajaBal);
          proximoValido = (random(1) < probValido);
        }
      }
    }
  }

  int m = -1;

  if (forzandoTutorial) {
    if (forzarIntroSelloCorp) {
      tutSelloCorpEnCola = true;
      m = construirMensajeNormalCorp(false, 1, false);
    } else {
      if (forzarIntroEjecutable) {
        tutEjecutableEnCola = true;
        m = construirMensajeNormalWeb(false, 2);
      } else {
        tutTyposquatEnCola = true;
        m = construirMensajeNormalWeb(false, 3);
      }
    }
  } else {
    if (enUltimoEmpujon) {
      if (proximoValido) {
        m = construirMensajeCapciosoBueno(permitirCorp, true);
      } else {
        if (random(1) < 0.68) {
          m = construirMensajeCapciosoMalo(rondaActual, permitirCorp);
        } else {
          boolean esCorpEmp = permitirCorp && (random(1) < 0.45);
          if (esCorpEmp) {
            float rF = random(1);
            int tipoFalloCorp = (rF < 0.32) ? 1 : ((rF < 0.68) ? 2 : ((rF < 0.90) ? 3 : 4));
            m = construirMensajeNormalCorp(false, tipoFalloCorp, random(1) >= 0.75);
          } else {
            int tipoFalloWeb = 1;
            if (rondaActual <= 1) tipoFalloWeb = 1;
            else {
              if (rondaActual <= 3) tipoFalloWeb = (random(1) < 0.75) ? 2 : 1;
              else {
                float rW = random(1);
                tipoFalloWeb = (rW < 0.48) ? 3 : ((rW < 0.84) ? 2 : 4);
              }
            }
            m = construirMensajeNormalWeb(false, tipoFalloWeb);
          }
        }
      }
    } else {
      float probCapcioso = (rondaActual <= 1) ? 0.22 : ((rondaActual <= 3) ? 0.30 : lerp(0.32, 0.46, ventajaBal));
      if (random(1) < probCapcioso) {
        m = proximoValido
          ? construirMensajeCapciosoBueno(permitirCorp, false)
          : construirMensajeCapciosoMalo(rondaActual, permitirCorp);
      } else {
        boolean esCorp = permitirCorp && (random(1) < lerp(0.45, 0.58, ventajaBal));
        if (esCorp) {
          int tipoFalloCorp = 1;
          if (!proximoValido) {
            float rF = random(1);
            if (ventajaBal >= 0.60) {
              if (rF < 0.34) tipoFalloCorp = 1;
              else {
                if (rF < 0.72) tipoFalloCorp = 2;
                else {
                  if (rF < 0.93) tipoFalloCorp = 3;
                  else tipoFalloCorp = 4;
                }
              }
            } else {
              if (rF < 0.42) tipoFalloCorp = 1;
              else {
                if (rF < 0.68) tipoFalloCorp = 2;
                else {
                  if (rF < 0.90) tipoFalloCorp = 3;
                  else tipoFalloCorp = 4;
                }
              }
            }
          }
          m = construirMensajeNormalCorp(proximoValido, tipoFalloCorp, random(1) >= 0.78);
        } else {
          int tipoFalloWeb = 1;
          if (!proximoValido) {
            if (rondaActual <= 1) {
              tipoFalloWeb = 1;
            } else {
              if (rondaActual <= 3) {
                if (jefeActivo == 0 && ventajaBal >= 0.30) {
                  tipoFalloWeb = (random(1) < lerp(0.55, 0.80, ventajaBal)) ? 2 : 1;
                } else {
                  tipoFalloWeb = (random(1) < 0.50) ? 2 : 1;
                }
              } else {
                if (jefeActivo == 0 && ventajaBal >= 0.60) {
                  float rW = random(1);
                  if (rW < 0.50) tipoFalloWeb = 3;
                  else {
                    if (rW < 0.85) tipoFalloWeb = 2;
                    else tipoFalloWeb = 4;
                  }
                } else {
                  if (jefeActivo == 0 && ventajaBal >= 0.30) {
                    float rW = random(1);
                    if (rW < 0.38) tipoFalloWeb = 3;
                    else {
                      if (rW < 0.75) tipoFalloWeb = 2;
                      else tipoFalloWeb = 1;
                    }
                  } else {
                    float rW = random(1);
                    if (rW < 0.36) tipoFalloWeb = 3;
                    else {
                      if (rW < 0.68) tipoFalloWeb = 2;
                      else {
                        if (rW < 0.92) tipoFalloWeb = 1;
                        else tipoFalloWeb = 4;
                      }
                    }
                  }
                }
              }
            }
          }
          m = construirMensajeNormalWeb(proximoValido, tipoFalloWeb);
        }
      }
    }
  }

  if (m < 0) return;

  if (msgEsCorporativo[m]) tutSelloCorpEnCola = true;
  if (!msgEsValido[m] && msgMotivoInvalidez[m] == 4) tutEjecutableEnCola = true;
  if (!msgEsValido[m] && msgMotivoInvalidez[m] == 3) tutTyposquatEnCola = true;

  if (pluginEquipado(13) && msgTipoMaldad[m] == 2 && !forzandoTutorial) {
    if (random(1) < 0.40) {
      msgTipoMaldad[m] = 0;
      msgEsValido[m] = true;
      msgMotivoInvalidez[m] = 0;
      msgIndiceSello[m] = msgEsCorporativo[m] ? 0 : -1;
      msgDominio[m] = msgEsCorporativo[m] ? "dolus@corp" : "dolus@net";
      if (msgIndiceArchivo[m] == 3 || msgIndiceArchivo[m] == 4 || msgIndiceArchivo[m] == 5) {
        msgIndiceArchivo[m] = 0;
        msgExtensionArchivo[m] = ".pdf";
      }
      msgContenido[m] = "[TRAFICO PURIFICADO POR ANTIVIRUS HEURISTICO] Paquete limpio y verificado.";
      msgEtiquetaMeta[m] = msgEsCorporativo[m] ? ("SISTEMA: " + msgDominio[m]) : ("WEB: " + msgDominio[m]);
    }
  }

  if (msgEsValido[m]) {
    consecutivosInocente++;
    consecutivosMalo = 0;
  } else {
    consecutivosMalo++;
    consecutivosInocente = 0;
  }

  if (pluginEquipado(8)) msgTiempoRestante[m] = 1.35;

  aplicarModificadoresJefeEnGeneracion(m);

  encolarMensaje(m);
}

void hacerClickDesencriptarCarta() {
  if (mensajeActivo < 0 || msgCategoriaEspecial[mensajeActivo] != 2) return;
  if (msgNivelEncriptado[mensajeActivo] <= 0.0) return;

  float decremento = 0.25;
  msgNivelEncriptado[mensajeActivo] = max(0.0, msgNivelEncriptado[mensajeActivo] - decremento);

  impulsarEscalaCarta(1.08, 0.93);
  juiceCartaActiva(0.16);
  reproducirTap();
  dispararExplosionCarta(mouseX, mouseY, color(0, 240, 255), false);
  dispararSacudidaCamara(2.5);

  int pct = int((1.0 - msgNivelEncriptado[mensajeActivo]) * 100);
  dispararTextoElastico(pct + "% HACK", mouseX + random(-12, 12), mouseY - 20, color(0, 240, 255));

  if (msgNivelEncriptado[mensajeActivo] <= 0.0 && !msgFueDesencriptado[mensajeActivo]) {
    msgNivelEncriptado[mensajeActivo] = 0.0;
    msgFueDesencriptado[mensajeActivo] = true;
    msgVerificado[mensajeActivo] = true;
    juiceCartaActiva(0.35);
    impulsarEscalaCarta(1.15, 0.88);
    dispararSacudidaCamara(6.0);
    dispararExplosionCarta(width * 0.64, height * 0.45, color(0, 255, 220), true);
    dispararRayoFlourish(width * 0.64, height * 0.45, color(0, 255, 220), 0);
    dispararTextoElastico("DESCIFRADO! +4T BONUS", width * 0.64, height * 0.36, color(0, 255, 220));
    if (sonidoTransferenciaExitosa != null) reproducirSFX(sonidoTransferenciaExitosa);
    else reproducirTap();
  }
}

void detectarSacudidaCarta(int msg) {
  if (msg < 0 || msgCategoriaEspecial[msg] != 4) return;
  if (!arrastrando_mensaje) return;

  float umbralX = 35.0;
  float velMinima = 6.0;

  if (swipePosX > umbralX && swipeVelX > velMinima) {
    if (msgUltimoSentidoSacudida[msg] == -1) {
      msgConteoSacudidasCompletas[msg]++;
      msgEnergiaSacudida[msg] = min(1.0, msgConteoSacudidasCompletas[msg] / 4.0);
      msgFrameUltimaSacudida[msg] = frameCount;
      dispararSacudidaCamara(4.5);
      dispararExplosionCarta(mouseX, mouseY, color(255, 30, 180), false);
      reproducirClickUI(true);
      impulsarEscalaCarta(1.12, 0.88);
      int pct = int(msgEnergiaSacudida[msg] * 100);
      dispararTextoElastico(pct + "% PURGA", mouseX + random(-10, 10), mouseY - 22, color(255, 40, 180));
      msgUltimoSentidoSacudida[msg] = 1;
    } else {
      if (msgUltimoSentidoSacudida[msg] == 0) {
        msgUltimoSentidoSacudida[msg] = 1;
      }
    }
  }

  else {
    if (swipePosX < -umbralX && swipeVelX < -velMinima) {
      if (msgUltimoSentidoSacudida[msg] == 1) {
        msgConteoSacudidasCompletas[msg]++;
        msgEnergiaSacudida[msg] = min(1.0, msgConteoSacudidasCompletas[msg] / 4.0);
        msgFrameUltimaSacudida[msg] = frameCount;
        dispararSacudidaCamara(4.5);
        dispararExplosionCarta(mouseX, mouseY, color(40, 255, 140), false);
        reproducirClickUI(true);
        impulsarEscalaCarta(1.12, 0.88);
        int pct = int(msgEnergiaSacudida[msg] * 100);
        dispararTextoElastico(pct + "% PURGA", mouseX + random(-10, 10), mouseY - 22, color(40, 255, 140));
        msgUltimoSentidoSacudida[msg] = -1;
      } else {
        if (msgUltimoSentidoSacudida[msg] == 0) {
          msgUltimoSentidoSacudida[msg] = -1;
        }
      }
    }
  }

  if (msgEnergiaSacudida[msg] >= 1.0) {
    purgarCartaContaminada(msg);
  }
}

void purgarCartaContaminada(int msg) {
  dispararExplosionCarta(width * 0.64, height * 0.45, color(255, 30, 180), true);
  dispararExplosionCarta(width * 0.64, height * 0.45, color(40, 255, 140), true);
  dispararSacudidaCamara(7.0);
  dispararRayoFlourish(width * 0.64, height * 0.45, color(255, 30, 180), 0);
  dispararTextoElastico("PURGADA! +8 TOKENS", width * 0.64, height * 0.36, color(40, 255, 140));

  if (sonidoTransferenciaExitosa != null) reproducirSFX(sonidoTransferenciaExitosa);
  else {
    if (sonidoDecisionCorrecta != null) reproducirSFX(sonidoDecisionCorrecta);
  }

  tokensDolus += 8;
  pulsoTokensUI = 1.0;
  comboActual++;
  pulsoComboUI = 1.0;
  tiempoComboRestante = MAX_TIEMPO_COMBO;
  if (comboActual > comboMaximoRonda) comboMaximoRonda = comboActual;
  if (modoFeriaActivo) {
    procesarPurgaContaminadaFeria();
  } else if (modoExposicionActivo) {
    balanzaEstabilidad = min(obtenerMetaBalanzaActual(), balanzaEstabilidad + 1);
    pulsoBalanzaUI = 1.0;
  }

  mensajesProcesadosRonda++;
  pulsoRestantesUI = 1.0;
  mensajeActivo = -1;
  arrastrando_mensaje = false;
  cardGrabbed = false;
  verificarFinDeRonda();
  if (!rondaCompletada && !estadoTransicionJefe) {
    if (numColaMensajes == 0 && !jammingActivo && !invisibleActivo) {
      generarMensajeAleatorio();
      timerNuevoMensaje = intervaloMensajes;
    }
    intentarAsignarMensaje();
  }
}

void fallarCartaContaminada(int msg) {
  int rStat = int(random(4));
  String nombreStat = "SALUD MENTAL";
  if (rStat == 0) {
    statSaludMental = max(0, statSaludMental - 28);
    pulsarBarraStat(0);
    nombreStat = "SALUD MENTAL";
  } else {
    if (rStat == 1) {
      statSeguridad = max(0, statSeguridad - 28);
      pulsarBarraStat(1);
      nombreStat = "SEGURIDAD";
    } else {
      if (rStat == 2) {
        statReputacion = max(0, statReputacion - 28);
        pulsarBarraStat(2);
        nombreStat = "REPUTACION";
      } else {
        statPopularidad = max(0, statPopularidad - 28);
        pulsarBarraStat(3);
        nombreStat = "POPULARIDAD";
      }
    }
  }
  comboActual = 0;
  if (modoFeriaActivo) {
    procesarErrorContaminadaFeria();
  }
  dispararSacudidaCamara(9.5);
  dispararExplosionCarta(width * 0.64, height * 0.45, color(255, 30, 40), true);
  dispararTextoElastico("CONTAMINACIÓN! -28 " + nombreStat, width * 0.64, height * 0.38, color(255, 50, 50));
  if (sonidoErrorMsj != null) reproducirSFX(sonidoErrorMsj);
  dispararGuiaErrorTexto("Esa tarjeta estaba {R}contaminada{/}, " + nombreJugador + ". Tenías que sacudirla rápido para purgarla.");

  mensajesProcesadosRonda++;
  pulsoRestantesUI = 1.0;
  mensajeActivo = -1;
  arrastrando_mensaje = false;
  cardGrabbed = false;
  verificarFinDeRonda();
  if (!rondaCompletada && !estadoTransicionJefe) {
    if (numColaMensajes == 0 && !jammingActivo && !invisibleActivo) {
      generarMensajeAleatorio();
      timerNuevoMensaje = intervaloMensajes;
    }
    intentarAsignarMensaje();
  }
}

void mousePressedDolus() {
  if (animandoTransicionTienda) return;
  if (animandoShowcaseDirectiva) {
    presionandoHoldShowcase = true;
    return;
  }
  if (mostrandoTutorial || mostrandoTutorialIngame) return;
  if (rondaCompletada) {
    if (animandoSalidaLiquidacion) return;

    if (timerTransicionTienda >= FRAMES_FIN_LIQUIDACION) {
      if (evaluarHover(width * 0.5, height * 0.5 + 194, 500, 62)) {
        confirmarLiquidacionRonda();
      }
    }
    return;
  }

  float pIzqX = width * 0.02;
  float pIzqW = width * 0.26;
  float slotW = pIzqW - 40;

  for (int i = 1; i < 4; i++) {
    if (leftPanelSlotY != null && leftPanelSlotY[i] > 0) {
      if (mouseX >= pIzqX + 20 && mouseX <= pIzqX + 20 + slotW &&
          mouseY >= leftPanelSlotY[i] && mouseY <= leftPanelSlotY[i] + 28) {
        activarHabilidadPlugin(i);
        return;
      }
    }
  }

  if (pluginAbierto != -1 || pluginHover != -1) {
    mousePressedPluginsGameplay();
    if (pluginAbierto != -1) return;
  }

  if (mensajeActivo >= 0) {

    if (msgCategoriaEspecial[mensajeActivo] == 2 && msgNivelEncriptado[mensajeActivo] > 0.0 && cardHover) {
      hacerClickDesencriptarCarta();
      return;
    }
    float panelGameX = obtenerPanelGameX();
    float panelGameW = obtenerPanelGameW();
    float panelGameY = obtenerPanelGameY();
    float panelGameH = obtenerPanelGameH();

    if (mouseX >= panelGameX && mouseX <= panelGameX + panelGameW &&
        mouseY >= panelGameY && mouseY <= panelGameY + panelGameH) {
      arrastrando_mensaje = true;
      cardGrabbed = true;
      swipeCruzoUmbral = false;
      reproducirClickUI(false);
      swipeInicioX = mouseX - swipePosX;
      swipeInicioY = mouseY - swipePosY;
      swipeActualX = mouseX;
      swipeActualY = mouseY;
      swipeVelX = 0;
      swipeVelY = 0;
      float centroCartaY = panelGameY + panelGameH * 0.45;
      swipePuntoAgarreRelY = constrain((mouseY - (centroCartaY + swipePosY)) / (275.0 * 0.5), -1.0, 1.0);
      impulsarEscalaCarta(1.06, 0.94);
    }
  }
}

void mouseDraggedDolus() {
  if (animandoShowcaseDirectiva) return;
  if (mostrandoTutorial || mostrandoTutorialIngame || rondaCompletada) return;
  if (arrastrando_mensaje && mensajeActivo >= 0) {
    float prevX = swipeActualX;
    float prevY = swipeActualY;
    swipeActualX = mouseX;
    swipeActualY = mouseY;
    swipeVelX = lerp(swipeVelX, swipeActualX - prevX, 0.55);
    swipeVelY = lerp(swipeVelY, swipeActualY - prevY, 0.55);

    if (msgCategoriaEspecial[mensajeActivo] == 4) {
      detectarSacudidaCarta(mensajeActivo);
    }
  }
}

void mouseReleasedDolus() {
  if (animandoShowcaseDirectiva) {
    presionandoHoldShowcase = false;
    return;
  }
  if (mostrandoTutorial || mostrandoTutorialIngame || rondaCompletada) return;
  cardGrabbed = false;
  if (arrastrando_mensaje && mensajeActivo >= 0) {
    if (msgCategoriaEspecial[mensajeActivo] == 4) {
      arrastrando_mensaje = false;
      cardGrabbed = false;
      swipePosX = 0;
      swipePosY = 0;
      msgUltimoSentidoSacudida[mensajeActivo] = 0;
      dispararTextoElastico("NO DESLIZAR: SACUDE LA TARJETA!", width * 0.64, height * 0.42, color(255, 60, 180));
      dispararSacudidaCamara(3.0);
      if (sonidoErrorMsj != null) reproducirSFX(sonidoErrorMsj, 0.4);
      return;
    }
    float rawX = mouseX - swipeInicioX;
    arrastrando_mensaje = false;
    reproducirClickUI(true);

    boolean swipeDer = (swipePosX >= SWIPE_THRESHOLD) || (rawX >= SWIPE_THRESHOLD) || (swipePosX > 55 && swipeVelX > 11);
    boolean swipeIzq = (swipePosX <= -SWIPE_THRESHOLD) || (rawX <= -SWIPE_THRESHOLD) || (swipePosX < -55 && swipeVelX < -11);

    if (swipeDer) {

      iniciarSalidaSwipe(0, max(swipeVelX, swipeSpringVelX), swipeVelY);
    } else {
      if (swipeIzq) {

        iniciarSalidaSwipe(1, min(swipeVelX, swipeSpringVelX), swipeVelY);
      } else {
        impulsarEscalaCarta(0.92, 1.08);
      }
    }
  }
}

void iniciarSalidaSwipe(int decision, float velX, float velY) {
  if (mensajeActivo < 0) return;
  int saliente = mensajeActivo;
  mensajeActivo = -1;
  arrastrando_mensaje = false;
  cardGrabbed = false;

  float cardX = obtenerPanelGameX() + obtenerPanelGameW() * 0.5;
  float cardY = obtenerPanelGameY() + obtenerPanelGameH() * 0.45;
  float rotActual = calcularRotacionCartaActiva(cardX);

  if (numCartasSaliendo >= 10) {
    eliminarCartaSaliendoEn(0);
  }

  if (decision == 2) {
    agregarCartaSaliendo(saliente, 2, cardX + swipePosX, cardY + swipePosY, 0, max(12.0, velY), rotActual, cardEscalaX);
  } else {
    float dir = (decision == 0) ? 1.0 : -1.0;
    float salidaVX = dir * max(20.0, abs(velX) * 1.25 + 16.0);
    float salidaVY = constrain(velY * 0.55, -14, 14);
    agregarCartaSaliendo(
      saliente, decision,
      cardX + swipePosX, cardY + swipePosY,
      salidaVX, salidaVY, rotActual, cardEscalaX
    );
    frenesiSwipeVisual = min(1.5, frenesiSwipeVisual + 0.28);
    dispararSacudidaCamara(2.0);
  }

  swipePosX = 0;
  swipePosY = 0;
  swipeSpringVelX = 0;
  swipeSpringVelY = 0;
  swipeOffsetX = 0;
  swipeOffsetY = 0;
  swipeVelX = 0;
  swipeVelY = 0;

  procesarDecision(decision, saliente);
  if (!rondaCompletada && !estadoTransicionJefe) {
    if (numColaMensajes == 0 && !jammingActivo && !invisibleActivo) {
      generarMensajeAleatorio();
      timerNuevoMensaje = intervaloMensajes;
    }
    intentarAsignarMensaje();
  }
}

void procesarDecision(int decision, int msg) {
  if (msg < 0) return;
  if (modoFeriaActivo && decision == 2) {
    float md = obtenerMultiplicadorDanoFeria();
    statSaludMental -= 12 * md;
    statSeguridad -= 6 * md;
    pulsarBarraStat(0);
    pulsarBarraStat(1);
    comboActual = 0;
    if (sonidoErrorMsj != null) reproducirSFX(sonidoErrorMsj);
    dispararSacudidaCamara(7.5);
    dispararTextoElastico("TIEMPO AGOTADO!", width * 0.64, height * 0.42, color(255, 70, 70));
    dispararGuiaErrorAdmin(2, msg);
    procesarResultadoDecisionFeria(2, msg, false, true);
    mensajesProcesadosRonda++;
    pulsoRestantesUI = 1.0;
    return;
  }
  int maldad = msgTipoMaldad[msg];
  boolean esAcierto = (decision == 0 && msgEsValido[msg]) || (decision != 0 && !msgEsValido[msg]);
  boolean esError = !esAcierto;

  float cxPopup = width * 0.64;
  float cyPopup = height * 0.42;

  if (msgCategoriaEspecial[msg] == 1 && jefeActivo == 0) {
    if (decision == 0) {

      int danoRep = (directivaRondaActual == 3) ? 24 : 14;
      if (!sinergiaActiva(5)) statReputacion -= danoRep;
      statSeguridad -= 10;
      pulsarBarraStat(2);
      pulsarBarraStat(1);
      dispararSacudidaCamara(6.0);
      if (statReputacion > 0 && statSeguridad > 0) {
        registrarProgresoLogro(4, 1);
      }
      if (sonidoDecisionCorrecta != null) reproducirSFX(sonidoDecisionCorrecta);
      encolarEvento(2, 6, "", cxPopup, cyPopup, color(255, 215, 0), 8);
      if (modoFeriaActivo) {
        procesarSobornoFeria(true);
      } else {
        if (modoExposicionActivo) {
          balanzaEstabilidad = min(obtenerMetaBalanzaActual(), balanzaEstabilidad + 1);
          pulsoBalanzaUI = 1.0;
        }
        encolarEvento(5, 4, "", 0, 0, color(255, 215, 0), 28);
        encolarEvento(7, 1, "SOBORNO ACEPTADO +28T!", cxPopup, cyPopup, color(255, 215, 0), 0);
      }
      mensajesProcesadosRonda++;
      pulsoRestantesUI = 1.0;
      verificarFinDeRonda();
      return;
    } else {
      if (decision == 1) {

        esAcierto = true;
        esError = false;
        int bonoLimpio = (directivaRondaActual == 3) ? 8 : 3;
        statReputacion += 6;
        pulsarBarraStat(2);
        registrarProgresoLogro(3, 1);
        encolarEvento(3, 6, "", cxPopup, cyPopup, color(100, 255, 180), 4);
        if (modoFeriaActivo) {
          if (sonidoDecisionCorrecta != null) reproducirSFX(sonidoDecisionCorrecta);
          procesarSobornoFeria(false);
          mensajesProcesadosRonda++;
          pulsoRestantesUI = 1.0;
          return;
        } else {
          encolarEvento(6, 4, "", 0, 0, color(100, 255, 180), bonoLimpio);
          encolarEvento(9, 1, "SOBORNO RECHAZADO +" + bonoLimpio + "T!", cxPopup, cyPopup - 28, color(100, 255, 200), 0);
        }
      }
    }
  }

  if (jefeActivo == 1) {
    if (faseCombateJefe == 1) {
      if (decision == 0) {
        intervaloMensajes = max(10, intervaloMensajes - 5);

        if (modoExposicionActivo) {
          int copiaExpo = expoClonarCartaViral(msg);
          if (numColaMensajes < 4) insertarColaMensaje(min(1, numColaMensajes), copiaExpo);
        } else {
          int copia1 = crearMensajeDolus(msgRemitente[msg], msgContenido[msg], msgTipoMaldad[msg]);
          int copia2 = crearMensajeDolus(msgRemitente[msg], msgContenido[msg], msgTipoMaldad[msg]);
          if (numColaMensajes < 6) insertarColaMensaje(min(1, numColaMensajes), copia1);
          if (numColaMensajes < 6) insertarColaMensaje(min(1, numColaMensajes), copia2);
        }
      } else {
        statReputacion -= 10;
        pulsarBarraStat(2);
        comboActual = 0;
      }
    } else {
      if (faseCombateJefe == 2) {
        if (maldad == 6) {
          if (decision == 0) {
            esAcierto = false;
            esError = false;
            statSaludMental += 15;
            statPopularidad += 15;
            pulsarBarraStat(0);
            pulsarBarraStat(3);
            balanzaEstabilidad -= 1;
          } else {
            esAcierto = true;
            esError = false;
            statPopularidad -= 20;
            pulsarBarraStat(3);
            balanzaEstabilidad += 1;
          }
        }
      }
    }
  }

  if (jefeActivo == 2) {
    if (decision == ultimaDireccionEco) {
      rachaMismaDireccionEco++;
    } else {
      if (rachaMismaDireccionEco >= 3) {
        encolarEvento(4, 1, "RUPTURA DE ECO!", cxPopup, height * 0.35, color(0, 255, 255), 0);
      }
      ultimaDireccionEco = decision;
      rachaMismaDireccionEco = 1;
    }

    if (rachaMismaDireccionEco >= 3 && maldad != 4) {
      statSaludMental -= 2;
      pulsarBarraStat(0);
      encolarEvento(3, 1, "INERCIA DE ECO -2", cxPopup, height * 0.35, color(0, 200, 255), 0);
    }

    if (maldad == 0) {
      if (decision == 0) {
        esAcierto = false;
        esError = false;
        statSaludMental -= 5;
        statPopularidad += 2;
        pulsarBarraStat(0);
        pulsarBarraStat(3);
        comboActual = 0;
      } else {
        esAcierto = true;
        esError = false;
        if (faseCombateJefe == 2) {
          statSaludMental -= 5;
          pulsarBarraStat(0);
        } else {
          statSaludMental += 1;
          pulsarBarraStat(0);
          if (faseJefe2 >= 2) {
            if (tokensDolus > 0) tokensDolus--;
            else { statSeguridad -= 2; pulsarBarraStat(1); }
          }
        }
      }
    } else {
      if (maldad == 7) {
        if (decision == 0) {
          esAcierto = false;
          esError = true;
          statSeguridad -= 50;
          pulsarBarraStat(1);
          comboActual = 0;
        } else {
          esAcierto = true;
          esError = false;
          statSaludMental -= 5;
          pulsarBarraStat(0);
        }
      } else {
        if (maldad == 4) {
          if (decision == 0) {
            esAcierto = true;
            esError = false;
            statSeguridad -= 20;
            pulsarBarraStat(1);
            anomaliasEncontradas++;
            destelloAnomalia = true;
            dispararSacudidaCamara(10.0);

            if (anomaliasEncontradas == 1) faseJefe2 = 2;
            if (anomaliasEncontradas == 2) faseJefe2 = 3;
            int metaAnom = modoExposicionActivo ? 2 : 3;
            if (anomaliasEncontradas >= metaAnom) {
               if (!modoExposicionActivo) rondaCompletada = true;
               balanzaEstabilidad = obtenerMetaBalanzaActual();
            }
          } else {
            esError = true;
            esAcierto = false;
            statSaludMental -= 25;
            pulsarBarraStat(0);
            comboActual = 0;
          }
        }
      }
    }
  }

  if (jefeActivo == 3) {
    int decisionReal = decision;
    if (faseCombateJefe == 2) {
      if ((frameCount / 180) % 2 == 0) decisionReal = (decision == 0) ? 1 : 0;
      gaslightingActivo = true;
    } else {
      if (faseJefe3 == 3) {
        decisionReal = (decision == 0) ? 1 : 0;
      }
    }

    if (maldad == 5) {
      if (decisionReal == 0) {
        esAcierto = false;
        esError = true;
        statSeguridad -= 25;
        statSaludMental -= 15;
        pulsarBarraStat(1);
        pulsarBarraStat(0);
        comboActual = 0;
        ratingDeepfake++;
        balanzaEstabilidad -= 1;
        if (faseCombateJefe == 1) gaslightingActivo = true;
      } else {
        esAcierto = true;
        esError = false;
        statPopularidad += 5;
        pulsarBarraStat(3);
        balanzaEstabilidad += 1;

        if (balanzaEstabilidad >= 2 && faseJefe3 == 1) faseJefe3 = 2;
        if (!modoExposicionActivo && balanzaEstabilidad >= 4 && faseJefe3 == 2) faseJefe3 = 3;
      }
    } else {
      if (maldad == 0) {
        if (decisionReal == 0) {
          esAcierto = true;
          esError = false;
          statSaludMental += 5;
          pulsarBarraStat(0);
        } else {
          esAcierto = false;
          esError = true;
          statPopularidad -= 10;
          pulsarBarraStat(3);
          comboActual = 0;
        }
      }
    }
  }

  if (esAcierto && sonidoDecisionCorrecta != null) reproducirSFX(sonidoDecisionCorrecta);
  if (esError && sonidoErrorMsj != null) reproducirSFX(sonidoErrorMsj);

  if (trampaDesplegadaActiva && decision == 0 && maldad != 0) {
    statPopularidad += 10 * multiplicadorRecompensas;
    statSeguridad += 10 * multiplicadorRecompensas;
    statReputacion += 10 * multiplicadorRecompensas;
    statSaludMental += 10 * multiplicadorRecompensas;
    trampaDesplegadaActiva = false;
    esError = false;
    int slHoneypot = slotConPlugin(11);
    if (slHoneypot != -1) encolarEvento(4, 3, "TRAMPA!", width * 0.15, leftPanelSlotY[slHoneypot], colorTema(), slHoneypot);
  } else {
    if (esError && voucherKernelShieldActivo && !kernelShieldUsadoEnRonda) {
      kernelShieldUsadoEnRonda = true;
      esError = false;
      dispararTextoElastico("KERNEL SHIELD ABSORBIÓ EL ERROR!", width * 0.5, height * 0.45, color(0, 230, 160));
      dispararExplosionCarta(width * 0.5, height * 0.5, color(0, 230, 160), false);
      dispararSacudidaCamara(2.8);
    } else {
      if (esError && doppelgangerActivo) {
        doppelgangerActivo = false;
        esError = false;
        int slMascara = slotConPlugin(3);
        if (slMascara != -1) encolarEvento(4, 3, "ESPEJO!", width * 0.15, leftPanelSlotY[slMascara], colorTema(), slMascara);
      }
    }
  }

  float multDano = 1.0;
  if (modoFeriaActivo) multDano *= obtenerMultiplicadorDanoFeria();
  if (voucherExpansionDIMMActivo) multDano *= 0.70;
  if (esError && pluginEquipado(18)) {
    multDano = 0.5;
    int slPar = slotConPlugin(18);
    if (slPar != -1) encolarEvento(4, 3, "", 0, 0, colorTema(), slPar);
    parasitoErroresAbsorbidos++;
    if (parasitoErroresAbsorbidos % 3 == 0) {
      int rStat = int(random(4));
      if (rStat == 0) statPopularidad -= 10;
      else {
        if (rStat == 1) statSeguridad -= 10;
        else {
          if (rStat == 2) statReputacion -= 10;
          else statSaludMental -= 10;
        }
      }
    }
  }

  float multRepDano = pluginEquipado(3) ? 0.5 : 1.0;

  if (jefeActivo != 2 && jefeActivo != 3) {
    if (decision == 0) {
      if (maldad == 0) {
        statPopularidad += 5 * multiplicadorRecompensas;
        statReputacion += 2 * multiplicadorRecompensas;
        statSaludMental += 2 * multiplicadorRecompensas;
        encolarEvento(6, 2, "", 0, 0, color(255), 3);
        encolarEvento(8, 2, "", 0, 0, color(255), 2);
        encolarEvento(10, 2, "", 0, 0, color(255), 0);
      } else {
        if (esError && maldad == 1) {
          statPopularidad += 2 * multiplicadorRecompensas;
          statReputacion -= 5 * multRepDano * multDano;
          statSaludMental -= 5 * multDano;
          encolarEvento(6, 2, "", 0, 0, color(255), 2);
          encolarEvento(8, 2, "", 0, 0, color(255), 0);
        } else {
          if (esError && maldad == 2) {
            statSeguridad -= 15 * multDano;
            statSaludMental -= 10 * multDano;
            encolarEvento(6, 2, "", 0, 0, color(255), 1);
            encolarEvento(8, 2, "", 0, 0, color(255), 0);
            iniciarQTEMalware();
          }
        }
      }
    } else {
      if (decision == 1) {
        if (esError && maldad == 0) {
          statPopularidad -= 5 * multDano;
          statSaludMental += 2 * multiplicadorRecompensas;
          encolarEvento(6, 2, "", 0, 0, color(255), 3);
        } else {
          if (!esError && maldad == 1) {
            statSaludMental += (pluginEquipado(11) ? 8 : 5) * multiplicadorRecompensas;
            encolarEvento(6, 2, "", 0, 0, color(255), 0);
            if (pluginEquipado(11)) {
              int slHP = slotConPlugin(11);
              if (slHP != -1) encolarEvento(4, 3, "", 0, 0, colorTema(), slHP);
            }
          } else {
            if (!esError && maldad == 2) {
              statSeguridad += (pluginEquipado(11) ? 8 : 5) * multiplicadorRecompensas;
              encolarEvento(6, 2, "", 0, 0, color(255), 1);
              if (pluginEquipado(11)) {
                int slHP = slotConPlugin(11);
                if (slHP != -1) encolarEvento(4, 3, "", 0, 0, colorTema(), slHP);
              }
            }
          }
        }
      }
    }
  }

  if (esAcierto) {
    if (decision != 2 && msgCategoriaEspecial[msg] != 1 && (maldad == 1 || maldad == 2 || maldad == 5 || maldad == 6 || maldad == 7)) {
      registrarProgresoLogro(0, 1);
    }
    comboActual++;
    pulsoComboUI = 1.0;
    tiempoComboRestante = MAX_TIEMPO_COMBO;
    if (jefeActivo != 0 && (comboActual == 5 || comboActual == 10)) {
      dispararBarkAleatorioJefe(jefeActivo, 2);
    }
    int tokensGanados = 1 + (comboActual / 5);
    if (voucherCertAuthActivo && (maldad == 1 || maldad == 2 || maldad == 5 || maldad == 6 || maldad == 7)) {
      tokensGanados += 2;
    }

    if (msgCategoriaEspecial[msg] == 2 && msgFueDesencriptado[msg]) {
      tokensGanados += 4;
      if (decision != 2) {
        registrarProgresoLogro(6, 1);
      }
    } else {
      if (msgCategoriaEspecial[msg] == 3) {
        tokensGanados += 6;
        comboActual += 2;
        if (decision != 2) {
          registrarProgresoLogro(5, 1);
        }
        encolarEvento(2, 1, "BOMBA DESACTIVADA +6T!", cxPopup, cyPopup - 30, color(255, 200, 60), 0);
      }
    }

    if (jefeActivo == 0) {
      if (directivaRondaActual == 1 && decision == 1 && maldad == 2) {
        tokensGanados += 3;
      } else {
        if (directivaRondaActual == 2 && decision == 1 && maldad == 1) {
          statSaludMental += 6;
          comboActual += 2;
          pulsarBarraStat(0);
        } else {
          if (directivaRondaActual == 4 && msgTiempoRestante[msg] > 0.65) {
            tokensGanados += 2;
          }
        }
      }
    }

    fijarProgresoMaximoLogro(1, comboActual);

    if (jefeActivo == 1) {
      if (comboActual % 5 == 0) {
        tokensGanados += 1;
        juiceCartaActiva(0.20);
      }
      if (decision == 0 && faseJefe1 >= 2 && !modoExposicionActivo) {
        if (numColaMensajes < 6) {
          int clon1 = crearMensajeDolus(msgRemitente[msg], msgContenido[msg], msgTipoMaldad[msg]);
          msgTiempoRestante[clon1] = msgTiempoRestante[msg] * 0.8;
          encolarMensaje(clon1);
        }
        if (faseJefe1 == 3 && numColaMensajes < 6) {
          int clon2 = crearMensajeDolus(msgRemitente[msg], msgContenido[msg], msgTipoMaldad[msg]);
          msgTiempoRestante[clon2] = msgTiempoRestante[msg] * 0.6;
          encolarMensaje(clon2);
        }
      }
    }

    if (viralidadDesbloqueada) {
      tokensGanados *= 2;
      comboActual++;
    }

    if (librePensadorDesbloqueado && decision == 1) {
      tokensGanados += 2;
      statSaludMental += 2;
    }

    if (gafasPresentadorDesbloqueadas && decision == 1 && maldad == 2) {
      statPopularidad += 5;
      statSeguridad += 5;
    }

    int delayPlugin = 4;
    if (pluginEquipado(4)) {
      tokensGanados += 1;
      int sl = slotConPlugin(4);
      if (sl != -1) { encolarEvento(delayPlugin, 3, "S" + (sl + 1) + " +1T", width * 0.22, leftPanelSlotY[sl], color(255, 215, 80), sl); delayPlugin += 6; }
    }
    if (pluginEquipado(12)) {
      tokensGanados += 1;
      int sl = slotConPlugin(12);
      if (sl != -1) { encolarEvento(delayPlugin, 3, "S" + (sl + 1) + " +1T", width * 0.22, leftPanelSlotY[sl], color(100, 240, 255), sl); delayPlugin += 6; }
    }
    if (pluginEquipado(20)) {
      tokensGanados += 2;
      int sl = slotConPlugin(20);
      if (sl != -1) { encolarEvento(delayPlugin, 3, "S" + (sl + 1) + " +2T", width * 0.22, leftPanelSlotY[sl], color(255, 110, 255), sl); delayPlugin += 6; }
    }
    if (jackpotBinarioActivo) tokensGanados *= 2;

    if (comboActual > comboMaximoRonda) {
      comboMaximoRonda = comboActual;
    }

    if (!modoFeriaActivo) {
      encolarEvento(delayPlugin + 1, 6, "", cxPopup, height * 0.55, color(255, 220, 90), min(tokensGanados, 8));
      encolarEvento(delayPlugin + 3, 4, "", 0, 0, color(255), tokensGanados);
      if (tokensGanados > 0) {
        encolarEvento(delayPlugin + 6, 1, "+" + tokensGanados + " TOKENS", cxPopup, cyPopup, color(80, 255, 140), 0);
      } else {
        encolarEvento(delayPlugin + 6, 1, "+COMBO x" + comboActual, cxPopup, cyPopup, color(100, 220, 255), 0);
      }
    }
  } else {
    if (esError) {
      if (jefeActivo != 0 && random(1) < 0.65) {
        dispararBarkAleatorioJefe(jefeActivo, 1);
      } else {
        if (jefeActivo == 0) {
          dispararGuiaErrorAdmin(decision, msg);
        }
      }
      dispararSacudidaCamara(8.5);
      dispararExplosionCarta(cxPopup, height * 0.55, color(255, 50, 50), true);
      dispararTextoElastico("ERROR!", cxPopup, cyPopup, color(255, 70, 70));
      if (rachaImparableActiva) {

      } else {
        if (pluginEquipado(5) && virusErroresTolerados < 1) {
          virusErroresTolerados++;
          int slVir = slotConPlugin(5);
          if (slVir != -1) {
            juiceSlotPlugin(slVir);
            dispararMarcoRayosPlugin(slVir, color(255, 70, 70));
          }
        } else {
          comboActual = 0;
        }
      }
    }
  }

  if (modoFeriaActivo) {
    procesarResultadoDecisionFeria(decision, msg, esAcierto, esError);
  } else {
    int metaBal = obtenerMetaBalanzaActual();
    if (esAcierto) {
      balanzaEstabilidad = min(metaBal, balanzaEstabilidad + 1);
      pulsoBalanzaUI = 1.0;
    } else {
      if (esError) {
        balanzaEstabilidad = max(-metaBal, balanzaEstabilidad - 1);
        pulsoBalanzaUI = 1.0;
      }
    }
  }
  if (pluginEquipado(17) && comboActual > comboRecordPartida) {
    comboRecordPartida = comboActual;
    cristalizadorBonusPermanente = min(0.15, cristalizadorBonusPermanente + 0.01);
    int slCrist = slotConPlugin(17);
    if (slCrist != -1) {
      juiceSlotPlugin(slCrist);
      dispararMarcoRayosPlugin(slCrist, color(200, 100, 255));
    }
  }

  if (pluginEquipado(14)) {
    int slBat = slotConPlugin(14);
    boolean rescateUsado = false;
    if (statPopularidad <= 0 && !rescatePopUsado) { statPopularidad = 25; rescatePopUsado = true; rescateUsado = true; }
    if (statSeguridad <= 0 && !rescateSegUsado) { statSeguridad = 25; rescateSegUsado = true; rescateUsado = true; }
    if (statReputacion <= 0 && !rescateRepUsado) { statReputacion = 25; rescateRepUsado = true; rescateUsado = true; }
    if (statSaludMental <= 0 && !rescateSalUsado) { statSaludMental = 25; rescateSalUsado = true; rescateUsado = true; }
    if (rescateUsado && slBat != -1) {
      juiceSlotPlugin(slBat);
      dispararMarcoRayosPlugin(slBat, color(255, 220, 70));
    }
  }

  mensajesProcesadosRonda++;
  pulsoRestantesUI = 1.0;
  verificarFinDeRonda();
  if (modoExposicionActivo && jefeActivo == 0 && !rondaCompletada) {
    verificarQTEExposicion(mensajesProcesadosRonda);
  }
}
