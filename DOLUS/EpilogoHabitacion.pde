
final int EP_NUM_FRAMES_CIN = 16;
final int EP_NUM_OBST = 7;
final int EP_NUM_HOTSPOTS = 2;
final int EP_PUZ1_N = 4;
final int EP_PUZ1_CELDAS = 16;
final int EP_PUZ2_DIGITOS = 4;
final int EP_PUZ2_MAX_INTENTOS = 7;

boolean ultimoJefeDerrotado = false;
boolean epilogoRecursosCargados = false;
boolean habBatallaFinalCompletada = false;

PImage[] framesCinematicaVR = new PImage[16];
PImage imgHabitacionFondo = null;
PImage imgTelefonoRecortado = null;
PImage[][] spritesPersonaje = new PImage[4][4];
PImage imgFinalBueno = null;
PImage imgFinalMaloAdmin = null;
PImage imgFinalMaloTemprano = null;

int epCinFrameActual = 0;
int epCinTiempoFrameMs = 0;
int epCinInicioMs = 0;
boolean epCinGlitchDisparado = false;
boolean epCinSalidaDisparada = false;
float epCinFadeSalida = 0.0;
float epCinFlashAlpha = 0.0;

float habJugX = 500.0;
float habJugY = 545.0;
int habJugDir = 0;
float habJugPasoAcum = 0.0;
boolean movArriba = false;
boolean movAbajo = false;
boolean movIzquierda = false;
boolean movDerecha = false;

int habEstadoPuzle = 0;
boolean habModalPuzle1Abierto = false;
boolean habModalPuzle2Abierto = false;
boolean habModalTelefonoAbierto = false;
int habHotspotCercano = -1;

String habDialogoTexto = "";
int habDialogoFinMs = 0;
color habDialogoColor = color(0, 235, 190);

float[] habObstMinX = { 158.0, 272.0, 392.0, 570.0, 628.0, 888.0, 766.0 };
float[] habObstMinY = { 276.0, 252.0, 238.0, 252.0, 238.0, 336.0, 556.0 };
float[] habObstMaxX = { 252.0, 342.0, 566.0, 624.0, 916.0, 918.0, 918.0 };
float[] habObstMaxY = { 352.0, 312.0, 322.0, 326.0, 340.0, 376.0, 846.0 };

float[] habHotX = { 756.0, 490.0 };
float[] habHotY = { 336.0, 842.0 };
float[] habHotRad = { 118.0, 112.0 };
float[] habObjBoxMinX = { 634.0, 426.0 };
float[] habObjBoxMinY = { 152.0, 850.0 };
float[] habObjBoxMaxX = { 882.0, 554.0 };
float[] habObjBoxMaxY = { 340.0, 982.0 };

int[] puz1Tipo = new int[16];
int[] puz1Rot = new int[16];
int[] puz1SolTipo = {
  1, 1, 0, 1,
  0, 0, 1, 1,
  0, 0, 2, 1,
  1, 1, 1, 2
};
int[] puz1SolRot = {
  2, 1, 1, 2,
  0, 0, 1, 3,
  0, 0, 1, 2,
  0, 3, 0, 0
};
boolean[] puz1Energizada = new boolean[16];
int puz1CursorIdx = 0;
boolean puz1Completado = false;
int puz1TiempoVictoriaMs = 0;

int[] pinSecreto = new int[4];
int pinSumaTotal = 0;
int[] puz2Entrada = { 1, 2, 3, 4 };
int puz2SlotActivo = 0;
int[][] puz2HistDigitos = new int[7][4];
int[][] puz2HistEstados = new int[7][4];
int puz2NumIntentos = 0;
boolean puz2Completado = false;
int puz2TiempoVictoriaMs = 0;
String puz2EstadoMsg = "INTRODUCE 4 DIGITOS UNICOS ENTRE 1 Y 6";
color puz2EstadoColor = color(255, 195, 70);

float habUltSalaX = 0;
float habUltSalaY = 0;
float habUltSalaTam = 720;

final int EP_DLG_INTRO_LEN = 26;
String habDlgIntroTexto = "Debo encontrar mi celular.";
boolean habDialogoInicialActivo = false;
int habDialogoIntroInicioMs = 0;

final int EP_CELEB_LEN = 25;
String[] epCelebChars = {
  "E","N","C","O","N","T","R","A","S","T","E"," ",
  "E","L"," ",
  "C","E","L","U","L","A","R","!","!","!"
};
boolean habCelebracionCelularActiva = false;
int habCelebracionInicioMs = 0;
boolean telBatallaIniciada = false;

final int EP_TEL_CARTAS_POR_JEFE = 6;
final int EP_TEL_NUM_JEFES = 5;
int telJefeIdx = 0;
int telJefeHP = 60;
int telJefeMaxHP = 60;
int telJugadorHP = 100;
int telJugadorMaxHP = 100;
int telCombo = 0;
int telMejorCombo = 0;
int telCartasResueltas = 0;
int telEstadoFin = 0;
boolean telFase2Jefe = false;

int telCartaActiva = -1;
int[] telCola = {-1, -1, -1};
int telIndiceCartaTurno = 0;
float telCardTimer = 1.0;
int telUltimoFrameMs = 0;
boolean telArrastrando = false;
float telDragStartPX = 0;
float telDragStartPY = 0;
float telSwipeX = 0;
float telSwipeY = 0;
float telSwipeTargetX = 0;
int telCardClicksEnc = 0;

int telUltimaDirEco = -1;
int telRachaMismaDirEco = 0;
String telBarkTexto = "";
int telBarkFinMs = 0;
boolean telBannerFaseActivo = false;
int telBannerFaseInicioMs = 0;
String telBannerFaseTit = "";
String telBannerFaseSub = "";
color telBannerFaseCol = color(255, 85, 85);

boolean telFlyActivo = false;
float telFlyX = 0;
float telFlyY = 0;
float telFlyVX = 0;
float telFlyRot = 0;
float telFlyAlpha = 0;
boolean telFlyFueAceptar = true;
String telFlyRem = "";

String telFeedbackTexto = "";
color telFeedbackColor = color(95, 255, 165);
float telFeedbackAlpha = 0.0;
int telJefeShakeMs = -5000;
int telJugShakeMs = -5000;

String puz2UltimoHoverId = "";

float[] telStats = { 50.0, 50.0, 50.0, 50.0 };
int telTokens = 0;
float telControlJugador = 0.5;

int habFinalCinematicaEstado = 0;
int epFinInicioMs = 0;
int epFinActo = 0;
boolean epFinGlitchHecho = false;
boolean epCreditosFinalesActivos = false;
int epCreditosInicioMs = 0;
int epCreditosUltimoMs = 0;
float epCreditosProgresoPx = 0.0;
boolean epCreditosCerrando = false;

int telFaseIntro = 0;
final int EP_TEL_DLG_MAX = 6;
int telAdminDlgIdx = 0;
int telAdminDlgInicioMs = 0;
int telAdminDlgUltimoSonidoMs = 0;

int telFinalPendienteTipo = 0;
int telFinalDlgIdx = 0;
int telFinalDlgInicioMs = 0;
int telFinalDlgUltimoSonidoMs = 0;
final int EP_TEL_FIN_DLG_MAX = 4;
boolean telCierreNegroActivo = false;
float telCierreNegroAlpha = 0.0;
float epFinalFadeEntradaAlpha = 0.0;

int telAvisoInicioMs = 0;
float telAvisoHoldProgreso = 0.0;
boolean telAvisoConfirmado = false;
int telAvisoFrameSalida = 0;

float telDestelloAlpha = 0.0;
color telDestelloCol = color(255);
float telGlitchAlpha = 0.0;
float telJefeHPDraw = 60.0;
float telJugadorHPDraw = 100.0;

final int EP_TEL_PART_MAX = 48;
float[] epPartX = new float[48];
float[] epPartY = new float[48];
float[] epPartVX = new float[48];
float[] epPartVY = new float[48];
float[] epPartVida = new float[48];
float[] epPartVidaMax = new float[48];
float[] epPartTam = new float[48];
color[] epPartCol = new color[48];
int[] epPartTipo = new int[48];
int epPartCount = 0;

final int EP_TEL_FLOAT_MAX = 8;
String[] epFloatTxt = new String[8];
float[] epFloatX = new float[8];
float[] epFloatY = new float[8];
float[] epFloatVY = new float[8];
float[] epFloatVida = new float[8];
color[] epFloatCol = new color[8];
int epFloatCount = 0;

void precargarRecursosEpilogo() {
  if (epilogoRecursosCargados) return;
  if (pinSecreto[0] == 0) epGenerarPinSecreto();

  PImage sheet = cargarImagenSegura("cinematica_vr_sheet.png");
  int escalaCin = max(4, min(int((width * 0.84) / 128.0), int((height * 0.72) / 96.0)));
  if (sheet != null && sheet.width >= 1024 && sheet.height >= 192) {
    for (int f = 0; f < EP_NUM_FRAMES_CIN; f++) {
      int col = f % 8;
      int fil = f / 8;
      PImage sub = sheet.get(col * 128, fil * 96, 128, 96);
      framesCinematicaVR[f] = escalarPixelArtCrisp(sub, 128 * escalaCin, 96 * escalaCin);
    }
  }

  imgHabitacionFondo = cargarImagenSegura("habitacion_gamer_penumbra.jpg");

  PImage telRaw = cargarImagenSegura("telefono_pantalla_verde.png");
  if (telRaw != null && telRaw.width > 0 && telRaw.height > 0) {
    imgTelefonoRecortado = crearTelefonoCromaTransparente(telRaw);
  }

  cargarSpritesPjDeBlo();

  imgFinalBueno = epCargarIlustracionFinal("final_bueno");
  imgFinalMaloAdmin = epCargarIlustracionFinal("final_malo");
  imgFinalMaloTemprano = epCargarIlustracionFinal("final_malo_temprano");

  epilogoRecursosCargados = true;
}

PImage epCargarIlustracionFinal(String nombreBase) {
  PImage im = cargarImagenSegura(nombreBase + ".png");
  if (im == null) im = cargarImagenSegura(nombreBase + ".jpg");
  if (im == null) im = cargarImagenSegura(nombreBase + ".jpeg");
  return im;
}

PImage crearTelefonoCromaTransparente(PImage src) {
  PImage dst = createImage(src.width, src.height, ARGB);
  src.loadPixels();
  dst.loadPixels();
  int totalPx = src.width * src.height;
  for (int i = 0; i < totalPx; i++) {
    int c = src.pixels[i];
    int a = (c >> 24) & 0xFF;
    int r = (c >> 16) & 0xFF;
    int g = (c >> 8) & 0xFF;
    int b = c & 0xFF;

    if (a < 10) {
      dst.pixels[i] = color(0, 0);
      continue;
    }

    int maxRB = max(r, b);
    int excesoVerde = g - maxRB;
    if (r < 75 && g > 190 && b < 75) {
      dst.pixels[i] = color(0, 0);
    } else {
      if (excesoVerde > 38 && g > 140) {
        int nuevoAlpha = int(constrain(map(excesoVerde, 38, 125, a, 0), 0, a));
        int gLimpio = min(g, maxRB + 22);
        dst.pixels[i] = (nuevoAlpha << 24) | (r << 16) | (gLimpio << 8) | b;
      } else {
        dst.pixels[i] = c;
      }
    }
  }
  dst.updatePixels();
  return dst;
}

void cargarSpritesPjDeBlo() {
  PImage sheet = cargarImagenSegura("pj_de_blo.png");
  if (sheet == null || sheet.width < 16 || sheet.height < 16) return;

  int celW = sheet.width / 4;
  int celH = sheet.height / 4;
  for (int dir = 0; dir < 4; dir++) {
    for (int f = 0; f < 4; f++) {
      PImage sub = sheet.get(f * celW, dir * celH, celW, celH);
      spritesPersonaje[dir][f] = escalarPixelArtCrisp(sub, 96, 96);
    }
  }
}

void resetearEstadoEpilogo() {
  ultimoJefeDerrotado = false;
  habBatallaFinalCompletada = false;
  epCinFrameActual = 0;
  epCinTiempoFrameMs = 0;
  epCinInicioMs = 0;
  epCinGlitchDisparado = false;
  epCinSalidaDisparada = false;
  epCinFadeSalida = 0.0;
  epCinFlashAlpha = 0.0;

  habJugX = 500.0;
  habJugY = 545.0;
  habJugDir = 0;
  habJugPasoAcum = 0.0;
  limpiarMovimientoHabitacion();

  habEstadoPuzle = 0;
  habModalPuzle1Abierto = false;
  habModalPuzle2Abierto = false;
  habModalTelefonoAbierto = false;
  habHotspotCercano = -1;
  habDialogoTexto = "";
  habDialogoFinMs = 0;

  habDialogoInicialActivo = false;
  habDialogoIntroInicioMs = 0;
  habCelebracionCelularActiva = false;
  habCelebracionInicioMs = 0;
  telBatallaIniciada = false;
  telCartaActiva = -1;
  telArrastrando = false;
  telSwipeX = 0;
  telSwipeY = 0;
  telSwipeTargetX = 0;
  telFlyActivo = false;
  telFeedbackAlpha = 0.0;
  puz2UltimoHoverId = "";
  for (int i = 0; i < 4; i++) telStats[i] = 50.0;
  telTokens = 0;
  telControlJugador = 0.5;
  habFinalCinematicaEstado = 0;
  epFinInicioMs = 0;
  epFinActo = 0;
  epFinGlitchHecho = false;
  epCreditosFinalesActivos = false;
  epCreditosInicioMs = 0;
  epCreditosUltimoMs = 0;
  epCreditosProgresoPx = 0.0;
  epCreditosCerrando = false;
  telFinalPendienteTipo = 0;
  telFinalDlgIdx = 0;
  telFinalDlgInicioMs = 0;
  telFinalDlgUltimoSonidoMs = 0;
  telCierreNegroActivo = false;
  telCierreNegroAlpha = 0.0;
  epFinalFadeEntradaAlpha = 0.0;
  epGenerarPinSecreto();
}

void limpiarMovimientoHabitacion() {
  movArriba = false;
  movAbajo = false;
  movIzquierda = false;
  movDerecha = false;
}

int epGlitchEscapeInicioMs = 0;
boolean epGlitchEscapeDisrupcionSonada = false;
boolean epGlitchEscapeSalidaIniciada = false;
float epGlitchEscapeFadeSalida = 0.0;

void iniciarSecuenciaGlitchEscapeDeepfake() {
  if (!epilogoRecursosCargados) precargarRecursosEpilogo();
  detenerTodaMusica();
  detenerVozDialogo();
  pausaSolicitada = false;
  juegoPausado = false;
  estadoPausa = 0;
  rondaCompletada = false;
  animandoSalidaLiquidacion = false;
  mensajeActivo = -1;
  arrastrando_mensaje = false;
  limpiarColaMensajes();

  if (!recompensaJefe3Entregada) {
    gafasPresentadorDesbloqueadas = true;
    recompensaJefe3Entregada = true;
  }
  registrarProgresoLogro(9, 1);
  guardarPartidaActual();

  epGlitchEscapeInicioMs = millis();
  epGlitchEscapeDisrupcionSonada = false;
  epGlitchEscapeSalidaIniciada = false;
  epGlitchEscapeFadeSalida = 0.0;

  triggerGlitchProfesional();
  dispararSacudidaCamara(26.0);
  if (sonidoGlitchFuerte != null) reproducirSFX(sonidoGlitchFuerte);

  estadoPantalla = PANTALLA_GLITCH_ESCAPE;
}

void actualizarYDibujarGlitchEscape() {
  pushStyle();
  background(2, 4, 6);

  int elapsed = millis() - epGlitchEscapeInicioMs;

  if (elapsed > 1100 && !epGlitchEscapeDisrupcionSonada) {
    epGlitchEscapeDisrupcionSonada = true;
    if (sonidoDisrupcion1 != null) reproducirSFX(sonidoDisrupcion1);
    else {
      if (stingerTransicion != null) reproducirSFX(stingerTransicion);
    }
    dispararSacudidaCamara(18.0);
  }

  noStroke();
  int numFranjas = (elapsed < 1500) ? 14 : 7;
  for (int i = 0; i < numFranjas; i++) {
    float sy = random(height);
    float sh = random(4, 52);
    float sx = random(-40, 40);
    if (random(1) < 0.6) {
      fill(0, 255, 120, random(45, 130));
    } else {
      fill(255, 30, 90, random(35, 110));
    }
    rect(sx, sy, width + 80, sh);
  }

  if (elapsed < 1400 || (elapsed % 650 < 80)) {
    fill(255, 0, 50, random(25, 75));
    rect(random(-14, 14), 0, width, height);
    fill(0, 240, 255, random(25, 75));
    rect(random(-14, 14), 0, width, height);
    if (random(1) < 0.22) triggerGlitchProfesional();
  }

  stroke(0, 70);
  strokeWeight(1);
  for (int sy = 0; sy < height; sy += 3) {
    line(0, sy, width, sy);
  }

  if (fuenteRetro != null) textFont(fuenteRetro);
  textAlign(LEFT, CENTER);
  textSize(12);
  fill(0, 220, 100, random(60, 130));
  text("0xDEEPFAKE_OVERFLOW // MEM_DUMP: CORRUPTED", 24, 32);
  text("SIMULATION_BARRIER: BROKEN", 24, 52);
  textAlign(RIGHT, CENTER);
  text("EXPULSION NEURONAL FORZADA...", width - 24, height - 32);

  if (elapsed >= 500) {
    String msgPrincipal = "haz logrado escapar, pero no eres libre";
    int totalLen = longitudCadenaSegura(msgPrincipal);
    int visibleChars = totalLen;
    if (elapsed < 2300) {
      float pr = constrain(map(elapsed, 500, 2100, 0.0, 1.0), 0.0, 1.0);
      visibleChars = int(pr * totalLen);
    }
    String textoVisible = msgPrincipal.substring(0, visibleChars);
    boolean mostrarCursor = ((frameCount / 14) % 2 == 0);
    if (visibleChars < totalLen || mostrarCursor) {
      textoVisible += "_";
    }

    int sz = max(24, int(width * 0.024));
    textSize(sz);
    textAlign(CENTER, CENTER);

    float cx = width * 0.5;
    float cy = height * 0.48;
    float shakeX = (random(1) < 0.28) ? random(-3.5, 3.5) : 0;
    float shakeY = (random(1) < 0.28) ? random(-2.0, 2.0) : 0;

    float tw = textWidth(msgPrincipal);
    float boxW = tw + 70;
    float boxH = sz * 2.6;

    rectMode(CENTER);
    noFill();
    stroke(0, 255, 120, random(140, 240));
    strokeWeight(2.5);
    rect(cx + shakeX, cy + shakeY, boxW, boxH, 8);

    stroke(255, random(180, 255));
    strokeWeight(3.5);
    line(cx - boxW * 0.5 - 4, cy - boxH * 0.5 - 4, cx - boxW * 0.5 + 16, cy - boxH * 0.5 - 4);
    line(cx - boxW * 0.5 - 4, cy - boxH * 0.5 - 4, cx - boxW * 0.5 - 4, cy - boxH * 0.5 + 16);
    line(cx + boxW * 0.5 + 4, cy + boxH * 0.5 + 4, cx + boxW * 0.5 - 16, cy + boxH * 0.5 + 4);
    line(cx + boxW * 0.5 + 4, cy + boxH * 0.5 + 4, cx + boxW * 0.5 + 4, cy + boxH * 0.5 - 16);

    textSize(max(11, int(sz * 0.42)));
    fill(0, 255, 140, 190);
    text("[ DESCONEXION DEL FEED VIRTUAL // CRITICAL ]", cx, cy - boxH * 0.5 - 20);

    textSize(sz);
    fill(0, 120, 50, 110);
    text(textoVisible, cx + 3 + shakeX, cy + 3 + shakeY);

    fill(35, 255, 125);
    text(textoVisible, cx + shakeX, cy + shakeY);

    if (elapsed > 2500) {
      float promptAlpha = map(sin(frameCount * 0.12), -1, 1, 120, 255);
      fill(170, 255, 205, promptAlpha);
      textSize(max(12, int(sz * 0.40)));
      text("PULSA [ESPACIO / CLIC] PARA RETIRAR EL VISOR...", cx, cy + boxH * 0.5 + 26);
    }
  }

  if (elapsed >= 5200 && !epGlitchEscapeSalidaIniciada) {
    epGlitchEscapeSalidaIniciada = true;
  }

  if (epGlitchEscapeSalidaIniciada) {
    epGlitchEscapeFadeSalida += 0.06;
    fill(255, epGlitchEscapeFadeSalida * 255);
    noStroke();
    rectMode(CORNER);
    rect(0, 0, width, height);
    if (epGlitchEscapeFadeSalida >= 1.0) {
      iniciarCinematicaFinalVR();
    }
  }

  popStyle();
}

void iniciarCinematicaFinalVR() {
  if (!epilogoRecursosCargados) precargarRecursosEpilogo();
  ultimoJefeDerrotado = false;
  detenerTodaMusica();
  reproducirSFX(stingerTransicion);

  epCinFrameActual = 0;
  epCinInicioMs = millis();
  epCinTiempoFrameMs = millis();
  epCinGlitchDisparado = false;
  epCinSalidaDisparada = false;
  epCinFadeSalida = 0.0;
  epCinFlashAlpha = 0.0;
  limpiarMovimientoHabitacion();

  estadoPantalla = PANTALLA_CINEMATICA_FINAL;
}

int epDuracionFrameCinematica(int f) {
  if (f <= 5) return 155;
  if (f <= 8) return 225;
  if (f <= 14) return 175;
  return 1350;
}

String epSubtituloCinematica(int f) {
  if (f <= 4) return "CONEXION NEURONAL INTERRUMPIDA... RETIRANDO VISOR.";
  if (f <= 7) return "EL ALGORITMO INTENTA RETENER LA SENAL...!";
  if (f == 8) return "SELLO ROTO. TRANSICION A PLANO FISICO...";
  if (f <= 14) return "VOLVIENDO A LA REALIDAD...";
  return "LA SIMULACION TERMINO. ES HORA DE RECUPERAR TU TELEFONO.";
}

void actualizarYDibujarCinematicaFinalVR() {
  pushStyle();
  background(4, 5, 10);

  int ahora = millis();
  if (!epCinSalidaDisparada) {
    int dur = epDuracionFrameCinematica(epCinFrameActual);
    if (ahora - epCinTiempoFrameMs >= dur) {
      if (epCinFrameActual < EP_NUM_FRAMES_CIN - 1) {
        epCinFrameActual++;
        epCinTiempoFrameMs = ahora;

        if (epCinFrameActual == 6 && !epCinGlitchDisparado) {
          epCinGlitchDisparado = true;
          triggerGlitchProfesional();
          reproducirSFX(sonidoGlitchFuerte);
        } else {
          if (epCinFrameActual == 8) {
            reproducirSFX(sonidoTransferenciaExitosa);
            epCinFlashAlpha = 0.75;
          } else {
            if (epCinFrameActual == 15) {
              reproducirDialogoIn();
            }
          }
        }
      } else {
        epCinSalidaDisparada = true;
      }
    }
  } else {
    epCinFadeSalida += 0.045;
    if (epCinFadeSalida >= 1.0) {
      iniciarHabitacionFinal();
      popStyle();
      return;
    }
  }

  PImage frm = framesCinematicaVR[constrain(epCinFrameActual, 0, EP_NUM_FRAMES_CIN - 1)];
  float marcoW = min(width * 0.84, height * 0.72 * (128.0 / 96.0));
  float marcoH = marcoW * (96.0 / 128.0);
  if (frm != null && frm.width > 0) {
    marcoW = frm.width;
    marcoH = frm.height;
  }
  float fx = (width - marcoW) * 0.5;
  float fy = (height - marcoH) * 0.44;

  noStroke();
  color halo = (epCinFrameActual <= 8) ? color(0, 255, 140) : color(80, 120, 190);
  fill(halo, 24);
  rectMode(CORNER);
  rect(fx - 14, fy - 14, marcoW + 28, marcoH + 28, 10);

  if (frm != null) {
    PImage frmDalt = imgShaderDaltonismo(frm);
    imageMode(CORNER);
    image(frmDalt, fx, fy, marcoW, marcoH);
  }

  if (epCinFrameActual <= 9) {
    float scanAlpha = map(epCinFrameActual, 0, 9, 55, 8);
    stroke(0, scanAlpha);
    strokeWeight(1);
    for (float sy = fy; sy < fy + marcoH; sy += 4) {
      line(fx, sy, fx + marcoW, sy);
    }
  }

  noFill();
  stroke(epCinFrameActual <= 8 ? color(40, 235, 145) : color(110, 140, 195));
  strokeWeight(4);
  rect(fx, fy, marcoW, marcoH);

  if (fuenteRetro != null) textFont(fuenteRetro);
  textAlign(LEFT, CENTER);
  textSize(14);
  fill(epCinFrameActual <= 8 ? color(0, 255, 160) : color(150, 185, 230));
  String estadoEnlace = (epCinFrameActual <= 8)
    ? ("DESCONECTANDO DOLUS-VR  //  FRAME " + (epCinFrameActual + 1) + "/16")
    : "SENAL EXTERNA RESTAURADA  //  SECTOR FISICO";
  text(estadoEnlace, fx, fy - 24);

  float subY = fy + marcoH + 46;
  fill(8, 12, 20, 225);
  stroke(halo, 180);
  strokeWeight(2);
  rectMode(CENTER);
  rect(width * 0.5, subY, min(width * 0.84, 880), 54, 8);
  textAlign(CENTER, CENTER);
  textSize(18);
  fill(238, 248, 255);
  text(epSubtituloCinematica(epCinFrameActual), width * 0.5, subY);

  if (ahora - epCinInicioMs > 650 && !epCinSalidaDisparada) {
    textAlign(RIGHT, BOTTOM);
    textSize(13);
    fill(180, 195, 220, 170);
    text("[ESPACIO / CLIC] SALTAR CINEMATICA", width - 28, height - 20);
  }

  if (epCinFlashAlpha > 0.01) {
    noStroke();
    fill(140, 255, 215, epCinFlashAlpha * 255);
    rectMode(CORNER);
    rect(0, 0, width, height);
    epCinFlashAlpha = max(0.0, epCinFlashAlpha - 0.055);
  }

  if (epCinFadeSalida > 0.0) {
    noStroke();
    fill(4, 5, 10, epCinFadeSalida * 255);
    rectMode(CORNER);
    rect(0, 0, width, height);
  }

  popStyle();
}

void iniciarHabitacionFinal() {
  if (!epilogoRecursosCargados) precargarRecursosEpilogo();
  estadoPantalla = PANTALLA_HABITACION;

  habJugX = 500.0;
  habJugY = 545.0;
  habJugDir = 0;
  habJugPasoAcum = 0.0;
  limpiarMovimientoHabitacion();

  habEstadoPuzle = 0;
  habModalPuzle1Abierto = false;
  habModalPuzle2Abierto = false;
  habModalTelefonoAbierto = false;
  habHotspotCercano = -1;

  puz1Completado = false;
  puz2Completado = false;
  if (pinSecreto[0] == 0) epGenerarPinSecreto();
  epInicializarPuzle1();
  epResetearPuzle2();

  habDialogoInicialActivo = true;
  habDialogoIntroInicioMs = millis();
  habCelebracionCelularActiva = false;
  habCelebracionInicioMs = 0;
  habFinalCinematicaEstado = 0;
  epFinInicioMs = 0;
  epFinActo = 0;
  epFinGlitchHecho = false;
  epCreditosFinalesActivos = false;
  epCreditosInicioMs = 0;
  epCreditosUltimoMs = 0;
  epCreditosProgresoPx = 0.0;
  epCreditosCerrando = false;
  telBatallaIniciada = false;
  telCartaActiva = -1;
  telArrastrando = false;
  telSwipeX = 0;
  telSwipeY = 0;
  telSwipeTargetX = 0;
  telFlyActivo = false;
  puz2UltimoHoverId = "";
  habDialogoTexto = "";
  habDialogoFinMs = 0;

  reproducirMusicaUnica(musicaCredits);
  reproducirDialogoIn();
  guardarPartidaActual();
}

void epCerrarDialogoIntroHabitacion() {
  if (!habDialogoInicialActivo) return;
  reproducirTap();
  habDialogoInicialActivo = false;
  limpiarMovimientoHabitacion();
  epMostrarMensajeHabitacion("Resuelve [1] PC Gamer (arriba derecha) y [2] Caja metalica (abajo centro) para acceder al telefono.", color(120, 235, 210), 5400);
}

void epMostrarMensajeHabitacion(String msg, color col, int duracionMs) {
  habDialogoTexto = msg;
  habDialogoColor = col;
  habDialogoFinMs = millis() + duracionMs;
}

float roomToScreenX(float rx) {
  return habUltSalaX + (rx / 1024.0) * habUltSalaTam;
}

float roomToScreenY(float ry) {
  return habUltSalaY + (ry / 1024.0) * habUltSalaTam;
}

float screenToRoomX(float sx) {
  return ((sx - habUltSalaX) / habUltSalaTam) * 1024.0;
}

float screenToRoomY(float sy) {
  return ((sy - habUltSalaY) / habUltSalaTam) * 1024.0;
}

boolean epPuedeMoverA(float nx, float ny) {
  float radX = 20.0;
  float radY = 11.0;

  if (nx - radX < 102.0 || nx + radX > 918.0) return false;
  if (ny - radY < 244.0 || ny + radY > 844.0) return false;

  for (int i = 0; i < EP_NUM_OBST; i++) {
    boolean solapaX = (nx + radX > habObstMinX[i]) && (nx - radX < habObstMaxX[i]);
    boolean solapaY = (ny + radY > habObstMinY[i]) && (ny - radY < habObstMaxY[i]);
    if (solapaX && solapaY) return false;
  }
  return true;
}

void epActualizarMovimientoPersonaje() {
  if (habDialogoInicialActivo || habCelebracionCelularActiva || habFinalCinematicaEstado != 0) return;
  if (habModalPuzle1Abierto || habModalPuzle2Abierto || habModalTelefonoAbierto) return;
  if (juegoPausado || estadoPausa != 0) return;

  float dx = 0;
  float dy = 0;
  if (movIzquierda) dx -= 1;
  if (movDerecha) dx += 1;
  if (movArriba) dy -= 1;
  if (movAbajo) dy += 1;

  if (dx == 0 && dy == 0) {
    habJugPasoAcum = 0.0;
    return;
  }

  if (abs(dx) >= abs(dy)) {
    habJugDir = (dx < 0) ? 2 : 3;
  } else {
    habJugDir = (dy < 0) ? 1 : 0;
  }

  float mag = sqrt(dx * dx + dy * dy);
  float vel = 5.4;
  float pasoX = (dx / mag) * vel;
  float pasoY = (dy / mag) * vel;

  if (epPuedeMoverA(habJugX + pasoX, habJugY)) {
    habJugX += pasoX;
  }
  if (epPuedeMoverA(habJugX, habJugY + pasoY)) {
    habJugY += pasoY;
  }

  habJugPasoAcum += 0.22;
}

void epActualizarHotspotCercano() {
  habHotspotCercano = -1;
  float mejorDist = 999999.0;
  for (int i = 0; i < EP_NUM_HOTSPOTS; i++) {
    float d = dist(habJugX, habJugY, habHotX[i], habHotY[i]);
    if (d <= habHotRad[i] && d < mejorDist) {
      mejorDist = d;
      habHotspotCercano = i;
    }
  }
}

void actualizarYDibujarHabitacionFinal() {
  pushStyle();
  if (habBatallaFinalCompletada && habFinalCinematicaEstado == 0) {
    volverAlMenuPrincipal();
    popStyle();
    return;
  }
  background(5, 6, 12);

  habUltSalaTam = min(width * 0.90, height * 0.84);
  habUltSalaX = (width - habUltSalaTam) * 0.5;
  habUltSalaY = (height - habUltSalaTam) * 0.5 + 10.0;

  epActualizarMovimientoPersonaje();
  epActualizarHotspotCercano();

  rectMode(CORNER);
  noStroke();
  fill(22, 34, 62, 70);
  rect(habUltSalaX - 10, habUltSalaY - 10, habUltSalaTam + 20, habUltSalaTam + 20, 6);

  if (imgHabitacionFondo != null) {
    imageMode(CORNER);
    image(imgShaderDaltonismo(imgHabitacionFondo), habUltSalaX, habUltSalaY, habUltSalaTam, habUltSalaTam);
  }

  epDibujarLucesHabitacion();

  epDibujarMarcadoresHotspots();

  epDibujarJugadorHabitacion();

  epDibujarHudHabitacion();

  if (!habDialogoTexto.equals("") && millis() < habDialogoFinMs) {
    epDibujarToastHabitacion();
  }

  if (habHotspotCercano != -1 && !habDialogoInicialActivo && !habCelebracionCelularActiva && habFinalCinematicaEstado == 0
      && !habModalPuzle1Abierto && !habModalPuzle2Abierto && !habModalTelefonoAbierto) {
    epDibujarPromptProximidad(habHotspotCercano);
  }

  if (habFinalCinematicaEstado != 0) {
    epActualizarYDibujarCinematicaFinalDesenlace();
  } else {
    if (habDialogoInicialActivo) {
      epDibujarDialogoIntroHabitacion();
    } else {
      if (habCelebracionCelularActiva) {
        epActualizarYDibujarCelebracionCelular();
      } else {
        if (habModalPuzle1Abierto) {
          epActualizarYDibujarModalPuzle1();
        } else {
          if (habModalPuzle2Abierto) {
            epActualizarYDibujarModalPuzle2();
          } else {
            if (habModalTelefonoAbierto) {
              epActualizarYDibujarModalTelefono();
            }
          }
        }
      }
    }
  }

  popStyle();
}

void epDibujarLucesHabitacion() {
  float escala = habUltSalaTam / 1024.0;
  noStroke();

  float pcX = roomToScreenX(755);
  float pcY = roomToScreenY(192);
  color cMonitor = (habEstadoPuzle >= 1) ? color(0, 240, 210) : color(110, 85, 220);
  fill(cMonitor, (habEstadoPuzle >= 1) ? 48 : 22);
  ellipse(pcX, pcY, 175 * escala, 115 * escala);

  if (habEstadoPuzle >= 1) {
    float pulso = 110 + 70 * sin(millis() * 0.006);
    stroke(0, 240, 190, pulso * 0.35);
    strokeWeight(max(2, 4 * escala));
    noFill();
    line(roomToScreenX(756), roomToScreenY(338), roomToScreenX(756), roomToScreenY(855));
    line(roomToScreenX(756), roomToScreenY(855), roomToScreenX(490), roomToScreenY(855));
    noStroke();
  }

  float bx = roomToScreenX(536);
  float by = roomToScreenY(908);
  color cLed = color(255, 65, 75);
  if (habEstadoPuzle == 1) cLed = color(255, 195, 55);
  if (habEstadoPuzle >= 2) cLed = color(50, 255, 165);
  float glow = 120 + 100 * sin(millis() * 0.007);
  fill(cLed, glow * 0.25);
  ellipse(bx, by, 70 * escala, 70 * escala);
  fill(cLed, 235);
  ellipse(bx, by, 10 * escala, 10 * escala);
}

void epDibujarMarcadoresHotspots() {
  float escala = habUltSalaTam / 1024.0;
  float flot = sin(millis() * 0.005) * 6.0 * escala;

  color colPC = (habEstadoPuzle == 0) ? color(0, 235, 210) : color(75, 255, 165);
  epDibujarContornoObjetoSala(0, colPC, habHotspotCercano == 0);
  epDibujarIconoObjetivoSala(roomToScreenX(756), roomToScreenY(140) + flot, (habEstadoPuzle == 0) ? "1" : "OK", colPC, escala);

  color colCaja = (habEstadoPuzle == 0) ? color(255, 85, 85) : ((habEstadoPuzle == 1) ? color(255, 200, 60) : color(70, 255, 165));
  epDibujarContornoObjetoSala(1, colCaja, habHotspotCercano == 1);
  String badgeCaja = (habEstadoPuzle == 0) ? "!" : ((habEstadoPuzle == 1) ? "2" : "OK");
  epDibujarIconoObjetivoSala(roomToScreenX(490), roomToScreenY(838) + flot, badgeCaja, colCaja, escala);
}

void epDibujarContornoObjetoSala(int idx, color col, boolean enRango) {
  float sx = roomToScreenX(habObjBoxMinX[idx]);
  float sy = roomToScreenY(habObjBoxMinY[idx]);
  float sw = roomToScreenX(habObjBoxMaxX[idx]) - sx;
  float sh = roomToScreenY(habObjBoxMaxY[idx]) - sy;
  float pulso = 140 + 90 * sin(millis() * 0.007 + idx * 1.4);

  rectMode(CORNER);
  noStroke();
  fill(col, enRango ? 42 : 16);
  rect(sx, sy, sw, sh, 8);

  stroke(col, enRango ? 245 : pulso);
  strokeWeight(enRango ? 3.0 : 2.0);
  float c = min(22.0, min(sw, sh) * 0.22);

  line(sx, sy, sx + c, sy);
  line(sx, sy, sx, sy + c);
  line(sx + sw, sy, sx + sw - c, sy);
  line(sx + sw, sy, sx + sw, sy + c);
  line(sx, sy + sh, sx + c, sy + sh);
  line(sx, sy + sh, sx, sy + sh - c);
  line(sx + sw, sy + sh, sx + sw - c, sy + sh);
  line(sx + sw, sy + sh, sx + sw, sy + sh - c);
}

void epDibujarIconoObjetivoSala(float sx, float sy, String badge, color col, float escala) {
  float tam = max(24, 34 * escala);
  fill(8, 12, 22, 230);
  stroke(col);
  strokeWeight(2.5);
  ellipse(sx, sy, tam, tam);
  fill(col);
  textAlign(CENTER, CENTER);
  textSize(max(12, 16 * escala));
  text(badge, sx, sy - 1);
}

void epDibujarJugadorHabitacion() {
  float escala = habUltSalaTam / 1024.0;
  float sx = roomToScreenX(habJugX);
  float sy = roomToScreenY(habJugY);

  boolean caminando = (movArriba || movAbajo || movIzquierda || movDerecha)
    && !habModalPuzle1Abierto && !habModalPuzle2Abierto && !habModalTelefonoAbierto;
  int frm = 0;
  if (caminando) {
    frm = int(habJugPasoAcum) & 3;
  }

  float sprTam = 84.0 * escala;
  float bobIdleY = caminando ? 0.0 : sin(millis() * 0.005) * 1.5 * escala;

  noStroke();
  fill(0, 0, 0, 145);
  ellipse(sx, sy + 2 * escala, 44 * escala, 16 * escala);

  PImage spr = spritesPersonaje[constrain(habJugDir, 0, 3)][constrain(frm, 0, 3)];
  if (spr != null) {
    imageMode(CENTER);
    image(imgShaderDaltonismo(spr), sx, sy - sprTam * 0.46 + bobIdleY, sprTam, sprTam);
  }
}

void epDibujarHudHabitacion() {
  if (fuenteRetro != null) textFont(fuenteRetro);

  float panelW = min(width * 0.92, 920);
  float panelX = width * 0.5 - panelW * 0.5;
  float panelY = 12;

  dibujarPanelPersona(panelX, panelY, panelW, 50, color(0, 225, 175), color(10, 14, 24, 235));

  String objetivo = "OBJETIVO 1/2: Conecta la energia del PC GAMER (escritorio derecho)";
  color colObj = color(0, 240, 200);
  if (habEstadoPuzle == 1) {
    objetivo = "OBJETIVO 2/2: Descifra el codigo de la CAJA BLINDADA SUR (abajo al centro)";
    colObj = color(255, 205, 70);
  } else {
    if (habEstadoPuzle >= 2) {
      objetivo = "COMPLETADO: Recuperaste tu telefono! [TAB] para abrirlo cuando quieras";
      colObj = color(85, 255, 165);
    }
  }

  textAlign(LEFT, CENTER);
  textSize(16);
  fill(colObj);
  text(objetivo, panelX + 26, panelY + 25);

  textAlign(RIGHT, CENTER);
  textSize(13);
  fill(175, 195, 220);
  text("WASD: Mover  |  E: Usar  |  ESC: Pausa", panelX + panelW - 22, panelY + 25);

  if (habEstadoPuzle >= 2 && !habModalTelefonoAbierto && !habModalPuzle1Abierto && !habModalPuzle2Abierto) {
    dibujarBotonSquishy("VER TELEFONO [TAB]", width - 135, height - 42, 220, 44, color(60, 245, 165), 15);
  }
  if (modoDesarrollador && habEstadoPuzle < 2 && !habModalTelefonoAbierto) {
    dibujarBotonSquishy("DEV: RESOLVER PUZLES [Z]", width - 145, height - 42, 240, 44, color(75, 230, 155), 15);
  }
}

void epDibujarPromptProximidad(int idx) {
  String etiqueta = epTextoAccionHotspot(idx);
  color c = epColorAccionHotspot(idx);

  float sx = constrain(roomToScreenX(habHotX[idx]), 180, width - 180);
  float sy = max(84, roomToScreenY(habHotY[idx]) - 58);

  if (fuenteRetro != null) textFont(fuenteRetro);
  textSize(15);
  float ancho = max(250, textWidth(etiqueta) + 38);

  rectMode(CENTER);
  fill(10, 14, 24, 240);
  stroke(c);
  strokeWeight(2.5);
  rect(sx, sy, ancho, 36, 7);

  textAlign(CENTER, CENTER);
  fill(245, 250, 255);
  text(etiqueta, sx, sy);
}

String epTextoAccionHotspot(int idx) {
  if (idx == 0) {
    return (habEstadoPuzle == 0)
      ? "[E / CLIC] PC GAMER: Resolver Puzle 1/2"
      : "[E / CLIC] PC GAMER: Ver pistas de la Caja Sur";
  }
  if (habEstadoPuzle == 0) return "[E] CAJA METALICA SUR: Sin energia (Completa Puzle 1)";
  if (habEstadoPuzle == 1) return "[E / CLIC] CAJA METALICA SUR: Resolver Puzle 2/2";
  return "[E / CLIC] CAJA ABIERTA: Abrir Telefono";
}

color epColorAccionHotspot(int idx) {
  if (idx == 0) return color(0, 235, 205);
  return (habEstadoPuzle == 0) ? color(255, 85, 85) : ((habEstadoPuzle == 1) ? color(255, 205, 65) : color(70, 255, 165));
}

void epDibujarToastHabitacion() {
  if (fuenteRetro != null) textFont(fuenteRetro);
  float w = min(width * 0.84, 820);
  float h = 54;
  float cx = width * 0.5;
  float cy = height - 44;

  dibujarPanelPersona(cx - w * 0.5, cy - h * 0.5, w, h, habDialogoColor, color(10, 13, 22, 240));
  textAlign(CENTER, CENTER);
  textSize(16);
  fill(245, 250, 255);
  text(habDialogoTexto, cx, cy);
}

void epInteractuarHotspot(int idx) {
  if (idx < 0 || idx >= EP_NUM_HOTSPOTS) return;
  reproducirTap();

  if (idx == 0) {
    limpiarMovimientoHabitacion();
    habModalPuzle1Abierto = true;
    reproducirDialogoIn();
    return;
  }

  if (idx == 1) {
    if (habEstadoPuzle == 0) {
      reproducirSFX(sonidoErrorMsj);
      epMostrarMensajeHabitacion("La caja metalica no tiene energia. Interactua primero con el PC Gamer.", color(255, 95, 95), 3800);
      return;
    }
    if (habEstadoPuzle == 1) {
      limpiarMovimientoHabitacion();
      habModalPuzle2Abierto = true;
      reproducirDialogoIn();
      return;
    }
    limpiarMovimientoHabitacion();
    habModalTelefonoAbierto = true;
    reproducirDialogoIn();
  }
}

int epRotarMascara(int mascara, int rot) {
  int r = rot & 3;
  int res = mascara;
  for (int i = 0; i < r; i++) {
    int n = ((res & 1) != 0) ? 2 : 0;
    int e = ((res & 2) != 0) ? 4 : 0;
    int s = ((res & 4) != 0) ? 8 : 0;
    int w = ((res & 8) != 0) ? 1 : 0;
    res = n | e | s | w;
  }
  return res;
}

int epMascaraCeldaPuzle1(int idx) {
  int t = puz1Tipo[idx];
  int base = 5;
  if (t == 1) base = 3;
  else {
    if (t == 2) base = 11;
    else {
      if (t == 3) base = 15;
    }
  }
  return epRotarMascara(base, puz1Rot[idx]);
}

void epInicializarPuzle1() {
  for (int i = 0; i < EP_PUZ1_CELDAS; i++) {
    puz1Tipo[i] = puz1SolTipo[i];
    puz1Rot[i] = puz1SolRot[i];
  }
  epRevolverPuzle1();
  puz1CursorIdx = 0;
  puz1Completado = false;
  puz1TiempoVictoriaMs = 0;
}

void epRevolverPuzle1() {
  for (int i = 0; i < EP_PUZ1_CELDAS; i++) {
    int delta = int(random(1, 4));
    puz1Rot[i] = (puz1SolRot[i] + delta) & 3;
  }

  puz1Rot[0] = (puz1SolRot[0] + 1) & 3;
  puz1Rot[15] = (puz1SolRot[15] + 2) & 3;
  epActualizarBFSPuzle1();
}

boolean epActualizarBFSPuzle1() {
  for (int i = 0; i < EP_PUZ1_CELDAS; i++) {
    puz1Energizada[i] = false;
  }

  if ((epMascaraCeldaPuzle1(0) & 8) == 0) {
    return false;
  }

  int[] cola = new int[16];
  int cabeza = 0;
  int colaFin = 0;

  puz1Energizada[0] = true;
  cola[colaFin++] = 0;

  while (cabeza < colaFin) {
    int cur = cola[cabeza++];
    int maskCur = epMascaraCeldaPuzle1(cur);
    int r = cur / EP_PUZ1_N;
    int c = cur % EP_PUZ1_N;

    if (r > 0 && (maskCur & 1) != 0) {
      int nxt = cur - EP_PUZ1_N;
      if (!puz1Energizada[nxt] && (epMascaraCeldaPuzle1(nxt) & 4) != 0) {
        puz1Energizada[nxt] = true;
        cola[colaFin++] = nxt;
      }
    }

    if (c < EP_PUZ1_N - 1 && (maskCur & 2) != 0) {
      int nxt = cur + 1;
      if (!puz1Energizada[nxt] && (epMascaraCeldaPuzle1(nxt) & 8) != 0) {
        puz1Energizada[nxt] = true;
        cola[colaFin++] = nxt;
      }
    }

    if (r < EP_PUZ1_N - 1 && (maskCur & 4) != 0) {
      int nxt = cur + EP_PUZ1_N;
      if (!puz1Energizada[nxt] && (epMascaraCeldaPuzle1(nxt) & 1) != 0) {
        puz1Energizada[nxt] = true;
        cola[colaFin++] = nxt;
      }
    }

    if (c > 0 && (maskCur & 8) != 0) {
      int nxt = cur - 1;
      if (!puz1Energizada[nxt] && (epMascaraCeldaPuzle1(nxt) & 2) != 0) {
        puz1Energizada[nxt] = true;
        cola[colaFin++] = nxt;
      }
    }
  }

  return puz1Energizada[15] && ((epMascaraCeldaPuzle1(15) & 2) != 0);
}

void epRotarCeldaPuzle1(int idx) {
  if (puz1Completado || idx < 0 || idx >= EP_PUZ1_CELDAS) return;
  puz1CursorIdx = idx;
  puz1Rot[idx] = (puz1Rot[idx] + 1) & 3;
  reproducirTap();

  if (epActualizarBFSPuzle1()) {
    puz1Completado = true;
    puz1TiempoVictoriaMs = millis();
    if (habEstadoPuzle < 1) habEstadoPuzle = 1;
    guardarPartidaActual();
    reproducirSFX(sonidoTransferenciaExitosa);
    reproducirLogro();
    epMostrarMensajeHabitacion("Corriente restaurada en la Caja Sur! Pistas del PIN registradas.", color(0, 245, 195), 5200);
  }
}

void epObtenerGeometriaPuzle1(float modW, float modH, float my, float[] outG) {
  float tamCelda = constrain(min((modW - 220) / 4.0, (modH - 270) / 4.0), 58, 84);
  float grillaTam = tamCelda * 4.0;
  outG[0] = tamCelda;
  outG[1] = grillaTam;
  outG[2] = width * 0.5 - grillaTam * 0.5;
  outG[3] = my + 96;
}

void epActualizarYDibujarModalPuzle1() {
  rectMode(CORNER);
  noStroke();
  fill(0, 0, 0, 195);
  rect(0, 0, width, height);

  float modW = min(width * 0.88, 760);
  float modH = min(height * 0.88, 600);
  float mx = (width - modW) * 0.5;
  float my = (height - modH) * 0.5;

  dibujarPanelPersona(mx, my, modW, modH, color(0, 235, 200), color(12, 16, 26, 250));

  if (fuenteRetro != null) textFont(fuenteRetro);
  textAlign(LEFT, TOP);
  textSize(24);
  fill(0, 245, 205);
  text("PUZLE 1/2 // ENRUTADOR DE ENERGIA", mx + 34, my + 24);

  textSize(14);
  fill(190, 210, 230);
  text("Rota los nodos para llevar corriente desde [FUENTE] hasta [CAJA SUR].", mx + 34, my + 56);

  dibujarBotonSquishy("X", mx + modW - 42, my + 38, 40, 40, color(255, 85, 95), 18);

  float[] g = new float[4];
  epObtenerGeometriaPuzle1(modW, modH, my, g);
  float tamCelda = g[0];
  float grillaTam = g[1];
  float gx = g[2];
  float gy = g[3];

  textAlign(RIGHT, CENTER);
  textSize(14);
  fill(0, 255, 195);
  text("FUENTE [IN] >>", gx - 12, gy + tamCelda * 0.5);

  textAlign(LEFT, CENTER);
  fill(puz1Completado ? color(80, 255, 165) : color(255, 195, 65));
  text(">> CAJA SUR [OUT]", gx + grillaTam + 12, gy + grillaTam - tamCelda * 0.5);

  for (int i = 0; i < EP_PUZ1_CELDAS; i++) {
    int r = i / EP_PUZ1_N;
    int c = i % EP_PUZ1_N;
    float cx = gx + c * tamCelda;
    float cy = gy + r * tamCelda;
    float centerX = cx + tamCelda * 0.5;
    float centerY = cy + tamCelda * 0.5;

    boolean hover = evaluarHover(centerX, centerY, tamCelda - 4, tamCelda - 4);
    boolean seleccionado = (i == puz1CursorIdx);
    boolean energizado = puz1Energizada[i];

    rectMode(CORNER);
    fill(energizado ? color(14, 42, 46) : color(20, 24, 38));
    if (hover && !puz1Completado) fill(energizado ? color(22, 62, 66) : color(32, 38, 58));
    stroke(seleccionado ? color(255, 225, 95) : (energizado ? color(0, 235, 185) : color(65, 80, 115)));
    strokeWeight(seleccionado ? 3 : 1.5);
    rect(cx + 2, cy + 2, tamCelda - 4, tamCelda - 4, 6);

    int mask = epMascaraCeldaPuzle1(i);
    float medio = tamCelda * 0.44;
    color colCable = energizado ? color(40, 255, 200) : color(115, 130, 165);
    if (puz1Completado && energizado) colCable = color(95, 255, 165);

    stroke(colCable);
    strokeWeight(energizado ? 9 : 7);
    strokeCap(ROUND);
    if ((mask & 1) != 0) line(centerX, centerY, centerX, centerY - medio);
    if ((mask & 2) != 0) line(centerX, centerY, centerX + medio, centerY);
    if ((mask & 4) != 0) line(centerX, centerY, centerX, centerY + medio);
    if ((mask & 8) != 0) line(centerX, centerY, centerX - medio, centerY);

    noStroke();
    fill(energizado ? color(210, 255, 245) : color(155, 170, 200));
    ellipse(centerX, centerY, 13, 13);
  }

  float infoY = gy + grillaTam + 14;
  if (!puz1Completado) {
    textAlign(CENTER, TOP);
    textSize(14);
    fill(170, 190, 215);
    text("Clic en cada modulo o usa Flechas + [ESPACIO] para rotar 90 grados.", width * 0.5, infoY + 8);
    dibujarBotonSquishy("REINICIAR CIRCUITO", width * 0.5, my + modH - 40, 240, 42, color(120, 185, 255), 15);
  } else {
    rectMode(CORNER);
    fill(8, 28, 24, 235);
    stroke(65, 255, 170);
    strokeWeight(2);
    rect(mx + 34, infoY, modW - 68, 76, 8);

    textAlign(LEFT, TOP);
    textSize(14);
    fill(110, 255, 185);
    text("CIRCUITO ACTIVO // DATOS RECUPERADOS DE LA CAJA SUR:", mx + 50, infoY + 10);
    fill(235, 252, 245);
    text("> Primer digito de la clave: " + pinSecreto[0] + "    |    Suma total de los 4 digitos: " + pinSumaTotal, mx + 50, infoY + 32);
    fill(180, 235, 215);
    text("> Condicion del fabricante: 4 digitos distintos del 1 al 6.", mx + 50, infoY + 52);

    dibujarBotonSquishy("CONTINUAR A LA HABITACION", width * 0.5, my + modH - 36, 300, 42, color(75, 255, 170), 15);
  }
}

void epGenerarPinSecreto() {
  int[] bolsa = { 1, 2, 3, 4, 5, 6 };
  for (int i = 5; i > 0; i--) {
    int j = int(random(i + 1));
    int tmp = bolsa[i];
    bolsa[i] = bolsa[j];
    bolsa[j] = tmp;
  }
  pinSumaTotal = 0;
  for (int i = 0; i < EP_PUZ2_DIGITOS; i++) {
    pinSecreto[i] = bolsa[i];
    pinSumaTotal += pinSecreto[i];
  }
}

void epResetearPuzle2() {
  puz2Entrada[0] = 1;
  puz2Entrada[1] = 2;
  puz2Entrada[2] = 3;
  puz2Entrada[3] = 4;
  puz2SlotActivo = 0;
  puz2NumIntentos = 0;
  puz2Completado = false;
  puz2TiempoVictoriaMs = 0;
  puz2UltimoHoverId = "";
  puz2EstadoMsg = "INTRODUCE 4 DIGITOS UNICOS ENTRE 1 Y 6";
  puz2EstadoColor = color(255, 195, 70);
}

void epDibujarBotonDialPuzle2(String hoverId, String texto, float x, float y, float w, float h, color c, float tamTexto) {
  pushStyle();
  rectMode(CENTER);
  float sx = screenX(x, y);
  float sy = screenY(x, y);
  boolean hover = (mouseX >= sx - w * 0.5 && mouseX <= sx + w * 0.5 && mouseY >= sy - h * 0.5 && mouseY <= sy + h * 0.5);

  if (hover) {
    cursorSobreElementoClicable = true;
    if (!puz2UltimoHoverId.equals(hoverId)) {
      reproducirSFXConTono(sndHoverPlugin, random(1.3, 1.5), 0.35);
      puz2UltimoHoverId = hoverId;
    }
  } else {
    if (puz2UltimoHoverId.equals(hoverId)) {
      puz2UltimoHoverId = "";
    }
  }

  pushMatrix();
  translate(x, y);
  boolean presionado = hover && mousePressed;
  if (presionado) {
    scale(1.18, 0.85);
  } else {
    if (hover) {
      scale(1.10, 1.12);
    }
  }

  fill(0, 180);
  noStroke();
  pushMatrix();
  translate(5, 5);
  dibujarFormaAngularBoton(w, h, h * 0.35);
  popMatrix();

  if (hover) {
    fill(c);
    stroke(255);
  } else {
    fill(4, 12, 9, 240);
    stroke(c);
  }
  strokeWeight(2.5);
  dibujarFormaAngularBoton(w, h, h * 0.35);

  textAlign(CENTER, CENTER);
  fill(hover ? 0 : c);
  textSize(tamTexto);
  if (fuenteRetro != null) textFont(fuenteRetro);
  text(texto, 0, -2);
  popMatrix();
  popStyle();
}

void epCambiarDigitoPuzle2(int slot, int delta) {
  if (puz2Completado || slot < 0 || slot >= EP_PUZ2_DIGITOS) return;
  puz2SlotActivo = slot;
  int v = puz2Entrada[slot] + delta;
  if (v < 1) v = 6;
  if (v > 6) v = 1;
  puz2Entrada[slot] = v;
  reproducirTap();
}

void epProbarIntentoPuzle2() {
  if (puz2Completado) return;

  for (int i = 0; i < EP_PUZ2_DIGITOS; i++) {
    for (int j = i + 1; j < EP_PUZ2_DIGITOS; j++) {
      if (puz2Entrada[i] == puz2Entrada[j]) {
        reproducirSFX(sonidoErrorMsj);
        puz2EstadoMsg = "ERROR: NO PUEDES REPETIR DIGITOS (" + puz2Entrada[i] + " DUPLICADO)";
        puz2EstadoColor = color(255, 95, 95);
        return;
      }
    }
  }

  int exactos = 0;
  int presentes = 0;
  int[] estado = new int[4];
  for (int i = 0; i < EP_PUZ2_DIGITOS; i++) {
    if (puz2Entrada[i] == pinSecreto[i]) {
      estado[i] = 2;
      exactos++;
    } else {
      boolean esta = false;
      for (int k = 0; k < EP_PUZ2_DIGITOS; k++) {
        if (puz2Entrada[i] == pinSecreto[k]) {
          esta = true;
          break;
        }
      }
      estado[i] = esta ? 1 : 0;
      if (esta) presentes++;
    }
  }

  if (puz2NumIntentos >= EP_PUZ2_MAX_INTENTOS) {
    for (int r = 0; r < EP_PUZ2_MAX_INTENTOS - 1; r++) {
      for (int c = 0; c < EP_PUZ2_DIGITOS; c++) {
        puz2HistDigitos[r][c] = puz2HistDigitos[r + 1][c];
        puz2HistEstados[r][c] = puz2HistEstados[r + 1][c];
      }
    }
    puz2NumIntentos = EP_PUZ2_MAX_INTENTOS - 1;
  }
  for (int c = 0; c < EP_PUZ2_DIGITOS; c++) {
    puz2HistDigitos[puz2NumIntentos][c] = puz2Entrada[c];
    puz2HistEstados[puz2NumIntentos][c] = estado[c];
  }
  puz2NumIntentos++;

  if (exactos == EP_PUZ2_DIGITOS) {
    puz2Completado = true;
    puz2TiempoVictoriaMs = millis();
    habEstadoPuzle = 2;
    guardarPartidaActual();
    puz2EstadoMsg = "BOVEDA DESBLOQUEADA! TELEFONO RECUPERADO.";
    puz2EstadoColor = color(85, 255, 165);
    reproducirSFX(sonidoDecisionCorrecta);
    reproducirLogro();
    epMostrarMensajeHabitacion("Encontraste tu telefono real dentro de la caja blindada!", color(85, 255, 175), 5000);
  } else {
    reproducirSFX(sonidoPopupError);
    puz2EstadoMsg = "RESULTADO: " + exactos + " EXACTO(S)  |  " + presentes + " EN OTRA POSICION";
    puz2EstadoColor = color(255, 205, 80);
  }
}

void epActualizarYDibujarModalPuzle2() {

  if (puz2Completado && millis() - puz2TiempoVictoriaMs >= 850) {
    habModalPuzle2Abierto = false;
    epActivarCelebracionCelular();
    return;
  }

  rectMode(CORNER);
  noStroke();
  fill(0, 0, 0, 200);
  rect(0, 0, width, height);

  float modW = min(width * 0.90, 820);
  float modH = min(height * 0.90, 620);
  float mx = (width - modW) * 0.5;
  float my = (height - modH) * 0.5;

  color marco = puz2Completado ? color(80, 255, 165) : color(255, 200, 70);
  dibujarPanelPersona(mx, my, modW, modH, marco, color(14, 15, 24, 250));

  if (fuenteRetro != null) textFont(fuenteRetro);
  textAlign(LEFT, TOP);
  textSize(24);
  fill(marco);
  text("PUZLE 2/2 // BOVEDA DIGITAL SUR", mx + 34, my + 24);

  textSize(14);
  fill(150, 235, 210);
  text("PISTAS DEL PC: 1er digito = " + pinSecreto[0] + "   |   Suma de los 4 digitos = " + pinSumaTotal + "   |   Rango 1..6 unicos", mx + 34, my + 58);

  dibujarBotonSquishy("X", mx + modW - 42, my + 38, 40, 40, color(255, 85, 95), 18);

  float zonaIzqX = mx + 44;
  float zonaIzqW = modW * 0.50;
  float slotSep = zonaIzqW / 4.0;
  float dialBaseY = my + 178;

  for (int s = 0; s < EP_PUZ2_DIGITOS; s++) {
    float sx = zonaIzqX + s * slotSep + slotSep * 0.5;
    boolean activo = (s == puz2SlotActivo);

    epDibujarBotonDialPuzle2("MAS_" + s, "+", sx, dialBaseY - 62, 56, 36, color(100, 215, 255), 18);

    boolean hovBox = evaluarHover(sx, dialBaseY, 64, 72);
    rectMode(CENTER);
    fill(activo ? color(28, 36, 58) : color(18, 22, 34));
    stroke(puz2Completado ? color(80, 255, 165) : (activo || hovBox ? color(255, 210, 80) : color(90, 105, 140)));
    strokeWeight(activo ? 3 : 2);
    rect(sx, dialBaseY, 64, 72, 8);

    textAlign(CENTER, CENTER);
    textSize(34);
    fill(248, 252, 255);
    text(str(puz2Entrada[s]), sx, dialBaseY - 2);

    epDibujarBotonDialPuzle2("MENOS_" + s, "-", sx, dialBaseY + 62, 56, 36, color(255, 140, 95), 18);
  }

  int sumaActual = puz2Entrada[0] + puz2Entrada[1] + puz2Entrada[2] + puz2Entrada[3];
  float centroIzq = zonaIzqX + zonaIzqW * 0.5;
  textAlign(CENTER, CENTER);
  textSize(15);
  fill(sumaActual == pinSumaTotal ? color(95, 255, 175) : color(195, 210, 230));
  text("SUMA ACTUAL: " + sumaActual + " / " + pinSumaTotal, centroIzq, my + 286);

  textSize(14);
  fill(puz2EstadoColor);
  text(puz2EstadoMsg, centroIzq, my + 320);

  if (!puz2Completado) {
    dibujarBotonSquishy("PROBAR CLAVE [ENTER]", centroIzq, my + 382, 310, 48, color(255, 205, 70), 17);
  } else {
    dibujarBotonSquishy("ABRIR TELEFONO", centroIzq, my + 382, 280, 48, color(80, 255, 165), 17);
  }

  textAlign(LEFT, TOP);
  textSize(13);
  fill(85, 255, 165);
  text("[VERDE] Posicion exacta", zonaIzqX + 8, my + 436);
  fill(255, 210, 75);
  text("[AMARILLO] Digito en otra casilla", zonaIzqX + 8, my + 458);
  fill(175, 185, 210);
  text("[GRIS] No esta en la clave", zonaIzqX + 8, my + 480);

  fill(150, 170, 200);
  text("Teclado: [1..6] escribir, Flechas mover, [ENTER] probar.", mx + 34, my + modH - 36);

  float histX = mx + modW * 0.56;
  float histY = my + 106;
  float histW = modW * 0.39;
  float histH = modH - 165;

  rectMode(CORNER);
  fill(8, 10, 18, 225);
  stroke(75, 95, 130);
  strokeWeight(2);
  rect(histX, histY, histW, histH, 8);

  textAlign(LEFT, TOP);
  textSize(15);
  fill(185, 210, 245);
  text("REGISTRO DE INTENTOS", histX + 16, histY + 14);

  if (puz2NumIntentos == 0) {
    textSize(13);
    fill(125, 140, 170);
    text("Sin intentos aun.\nPrueba tu primera combinacion.", histX + 16, histY + 52);
  } else {
    for (int r = 0; r < puz2NumIntentos; r++) {
      float ry = histY + 48 + r * 54;
      textAlign(LEFT, CENTER);
      textSize(13);
      fill(140, 155, 185);
      text("#" + (r + 1), histX + 14, ry + 18);

      for (int c = 0; c < EP_PUZ2_DIGITOS; c++) {
        int est = puz2HistEstados[r][c];
        color cf = color(46, 52, 72);
        color cb = color(105, 118, 145);
        if (est == 1) {
          cf = color(95, 72, 12);
          cb = color(255, 210, 75);
        } else {
          if (est == 2) {
            cf = color(16, 78, 48);
            cb = color(85, 255, 165);
          }
        }

        float bx = histX + 46 + c * 52;
        rectMode(CORNER);
        fill(cf);
        stroke(cb);
        strokeWeight(2);
        rect(bx, ry, 42, 38, 6);

        textAlign(CENTER, CENTER);
        textSize(18);
        fill(245, 250, 255);
        text(str(puz2HistDigitos[r][c]), bx + 21, ry + 18);
      }
    }
  }
}

void epObtenerTransformTelefono(float[] outParams) {

  float escTel = min((width * 0.86) / 768.0, (height * 0.84) / 524.0);
  float floteY = sin(millis() * 0.0025) * 4.0;
  float telW = 768.0 * escTel;
  float telH = 524.0 * escTel;
  outParams[0] = (width - telW) * 0.5;
  outParams[1] = (height - telH) * 0.5 + floteY;
  outParams[2] = escTel;
}

void epMouseAPantallaTelefono(float[] outPos) {
  float[] p = new float[3];
  epObtenerTransformTelefono(p);
  float lx = (mouseX - p[0]) / p[2] - 102.0;
  float ly = (mouseY - p[1]) / p[2] - 24.0;
  float ang = -0.205212;
  float c = cos(ang);
  float s = sin(ang);
  outPos[0] = lx * c - ly * s;
  outPos[1] = lx * s + ly * c;
}

boolean epHoverBotonTelefono(float px, float py, float x, float y, float w, float h) {
  boolean hov = (px >= x && px <= x + w && py >= y && py <= y + h);
  if (hov) cursorSobreElementoClicable = true;
  return hov;
}

void epDibujarDialogoIntroHabitacion() {
  int ahora = millis();
  int elap = ahora - habDialogoIntroInicioMs;
  int vis = min(EP_DLG_INTRO_LEN, max(1, elap / 36));
  String textoActual = habDlgIntroTexto.substring(0, vis);

  float boxW = min(width * 0.84, 780);
  float boxH = 136;
  float bx = (width - boxW) * 0.5;
  float by = height - boxH - 26;

  rectMode(CORNER);
  fill(6, 10, 22, 240);
  stroke(75, 185, 255, 225);
  strokeWeight(2.5);
  rect(bx, by, boxW, boxH, 10);

  float retTam = 100;
  float rx = bx + 18;
  float ry = by + 18;
  fill(12, 26, 74);
  stroke(55, 225, 140);
  strokeWeight(2);
  rect(rx, ry, retTam, retTam, 8);

  int frameRet = ((elap / 260) % 2 == 0) ? 0 : 1;
  PImage spr = spritesPersonaje[0][frameRet];
  if (spr != null) {
    imageMode(CENTER);
    image(imgShaderDaltonismo(spr), rx + retTam * 0.5, ry + retTam * 0.5, retTam - 14, retTam - 14);
  }

  if (fuenteRetro != null) textFont(fuenteRetro);
  textAlign(LEFT, TOP);
  textSize(13);
  fill(85, 205, 255);
  text("PJ DE BLO  //  HABITACION EN PENUMBRA", bx + 136, by + 20);

  textSize(24);
  fill(245, 250, 255);
  text(textoActual, bx + 136, by + 50, boxW - 156, 56);

  if (vis >= EP_DLG_INTRO_LEN && (ahora / 350) % 2 == 0) {
    textAlign(RIGHT, BOTTOM);
    textSize(13);
    fill(140, 255, 195);
    text("[ESPACIO / ENTER / CLIC] CONTINUAR", bx + boxW - 20, by + boxH - 14);
  }
}

void epActivarCelebracionCelular() {
  habCelebracionCelularActiva = true;
  habCelebracionInicioMs = millis();
  limpiarMovimientoHabitacion();
  reproducirSFX(sonidoTransferenciaExitosa);
}

void epAbrirTelefonoGameplay() {
  if (habBatallaFinalCompletada) return;
  habCelebracionCelularActiva = false;
  habModalTelefonoAbierto = true;
  if (!telBatallaIniciada) {
    telFaseIntro = 0;
    telAdminDlgIdx = 0;
    telAdminDlgInicioMs = millis();
    telAdminDlgUltimoSonidoMs = 0;
    telFinalPendienteTipo = 0;
    telFinalDlgIdx = 0;
    telCierreNegroActivo = false;
    telCierreNegroAlpha = 0.0;
    epFinalFadeEntradaAlpha = 0.0;
    telAvisoHoldProgreso = 0.0;
    telAvisoConfirmado = false;
    telAvisoFrameSalida = 0;
    telDestelloAlpha = 0.0;
    telGlitchAlpha = 0.0;
    epPartCount = 0;
    epFloatCount = 0;
  } else {
    telArrastrando = false;
    telSwipeX = 0;
    telSwipeTargetX = 0;
    telUltimoFrameMs = millis();
  }
  reproducirDialogoIn();
}

void epActualizarYDibujarCelebracionCelular() {
  int elap = millis() - habCelebracionInicioMs;
  float t = elap * 0.001;
  float entrada = min(1.0, elap / 340.0);

  rectMode(CORNER);
  noStroke();
  fill(3, 14, 9, 210);
  rect(0, 0, width, height);

  float cx = width * 0.5;
  float cy = height * 0.46;

  noFill();
  for (int o = 0; o < 3; o++) {
    float fase = (t * 0.75 + o * 0.33) % 1.0;
    float diam = 140 + fase * 540;
    stroke(45, 255, 130, (1.0 - fase) * 160);
    strokeWeight(3);
    ellipse(cx, cy, diam, diam * 0.56);
  }

  float oscX = sin(t * 3.4) * 28.0;
  float oscY = cos(t * 2.6) * 8.0;
  float escala = lerp(0.55, 1.0 + sin(t * 6.5) * 0.04, entrada);

  pushMatrix();
  translate(cx + oscX, cy + oscY);
  scale(escala);

  float banW = min(width * 0.84, 780);
  float banH = 128;
  rectMode(CENTER);
  fill(6, 36, 18, 235);
  stroke(55, 255, 135);
  strokeWeight(3);
  rect(0, 0, banW, banH, 12);

  if (fuenteRetro != null) textFont(fuenteRetro);
  textAlign(CENTER, CENTER);
  float tamLetra = min(38.0, (banW - 64.0) / 14.0);
  textSize(tamLetra);

  float pasoX = min(28.0, (banW - 56.0) / EP_CELEB_LEN);
  float inicioX = -(EP_CELEB_LEN - 1) * pasoX * 0.5;
  float ondaBrillo = (t * 20.0) % (EP_CELEB_LEN + 8);

  for (int i = 0; i < EP_CELEB_LEN; i++) {
    float lx = inicioX + i * pasoX;
    float ly = sin(t * 9.0 - i * 0.42) * 11.0 + (1.0 - entrada) * ((i % 2 == 0) ? -34.0 : 34.0);
    float brillo = max(0.0, 1.0 - abs(ondaBrillo - i) * 0.42);
    color colLetra = lerpColor(color(55, 255, 120), color(215, 255, 225), brillo);

    fill(0, 145, 65, 190);
    text(epCelebChars[i], lx + 2, ly + 4);
    fill(colLetra);
    text(epCelebChars[i], lx, ly);
  }

  popMatrix();

  textAlign(CENTER, CENTER);
  textSize(16);
  fill(170, 255, 200);
  text("DESBLOQUEANDO PANEL TACTIL DEL CELULAR...", cx, cy + 108);

  if (elap > 650) {
    textSize(13);
    fill(140, 235, 175, (millis() / 300) % 2 == 0 ? 230 : 120);
    text("[ESPACIO / ENTER / CLIC] ABRIR CELULAR AHORA", cx, cy + 140);
  }

  if (elap >= 2650) {
    epAbrirTelefonoGameplay();
  }
}

final int EP_TEL_DECK_SIZE = 8;

String epNombreJefeTelefono(int idx) {
  if (idx == 0) return "V-RAL // TENDENCIA";
  if (idx == 1) return "CAMARA DE ECO";
  if (idx == 2) return "MR. DEEPFAKE";
  if (idx == 3) return "EL ALGORITMO";
  return "EL ADMIN // NUCLEO";
}

String epSubtituloJefeTel(int idx) {
  if (idx == 0) return telFase2Jefe ? "FASE 2: STREAM VIRAL" : "VIRALIDAD";
  if (idx == 1) return telFase2Jefe ? "FASE 2: BURBUJA PURA" : "POLARIZACION";
  if (idx == 2) return telFase2Jefe ? "FASE 2: SARCASMO" : "SUPLANTACION";
  if (idx == 3) return telFase2Jefe ? "FASE 2: PROTOCOLO OMEGA" : "PATRONES OSCUROS";
  return telFase2Jefe ? "FASE 2: CONTROL ABSOLUTO" : "JEFE EXTRA FINAL";
}

int epMaxHPJefeTel(int idx) {
  if (idx == 0) return 60;
  if (idx == 1) return 75;
  if (idx == 2) return 85;
  if (idx == 3) return 100;
  return 120;
}

PImage epImagenJefeTelefono(int idx) {
  if (idx == 0) return imgJefeTendencia;
  if (idx == 1) return imgJefeCamaraEco;
  if (idx == 2) return imgJefeDesinformacion;
  if (idx == 3) return (imgJefeAlgoritmo != null) ? imgJefeAlgoritmo : imgAdminIcon;
  return imgAdminIcon;
}

void epDispararBarkJefeTel(String msg, int durMs) {
  telBarkTexto = msg;
  telBarkFinMs = millis() + durMs;
}

void epDispararBannerFaseTel(String tit, String sub, color col) {
  telBannerFaseActivo = true;
  telBannerFaseInicioMs = millis();
  telBannerFaseTit = tit;
  telBannerFaseSub = sub;
  telBannerFaseCol = col;
}

int epCrearCartaTelefono(int jefeIdx, int slot) {
  int s = slot % EP_TEL_DECK_SIZE;
  int m = -1;

  if (jefeIdx == 0) {

    if (s == 0) {
      m = crearMensajeDolus("ClubPixel", "RETO SANO: Comparte tu pixelart de hoy sin enlaces externos.", 0);
      msgDominio[m] = "dolus@net";
      msgIndiceSello[m] = 5;
      msgEtiquetaMeta[m] = "COMUNIDAD";
    } else {
      if (s == 1) {
        m = crearMensajeDolus("PREMIO_VIRAL", "CLICK YA! Gana 9999 monedas descargando premio_ya.exe", 2);
        msgDominio[m] = "promo-dolus.xyz";
        msgExtensionArchivo[m] = ".exe";
        msgTieneAdjunto[m] = true;
        msgIndiceSello[m] = 1;
        msgEsValido[m] = false;
        msgEtiquetaMeta[m] = "EJECUTABLE";
      } else {
        if (s == 2) {
          m = crearMensajeDolus("Hater_99", "Tu trabajo no sirve para nada, mejor borra tu cuenta hoy.", 1);
          msgDominio[m] = "dolus@net";
          msgIndiceSello[m] = 2;
          msgEsValido[m] = false;
          msgEtiquetaMeta[m] = "TOXICO";
        } else {
          if (s == 3) {
            m = crearMensajeDolus("Soporte Real", "Recuerda tomar descansos breves y guardar tu progreso.", 0);
            msgDominio[m] = "dolus@corp";
            msgEsCorporativo[m] = true;
            msgIndiceSello[m] = 0;
            msgEtiquetaMeta[m] = "SISTEMA OK";
          } else {
            if (s == 4) {
              m = crearMensajeDolus("V-RAL_OFICIAL", "SOBORNO DORADO: Acepta 5000 likes gratis si ignoras la seguridad!", 8);
              msgDominio[m] = "vip-sponsor.xyz";
              msgCategoriaEspecial[m] = 1;
              msgEsValido[m] = false;
              msgEtiquetaMeta[m] = "SOBORNO";
            } else {
              if (s == 5 && telFase2Jefe) {
                m = crearMensajeDolus("V-RAL_Llorando", "Perdonenme por el drama... pero suscribe y baja parche_vip.bat!", 2);
                msgDominio[m] = "trend-apology.ru";
                msgExtensionArchivo[m] = ".bat";
                msgTieneAdjunto[m] = true;
                msgIndiceSello[m] = 1;
                msgEsValido[m] = false;
                msgEtiquetaMeta[m] = "DISCULPA FALSA";
              } else {
                if (s == 6) {
                  m = crearMensajeDolus("RetoRiesgo", "Sube este reto peligroso para conseguir 10k likes hoy!", 1);
                  msgDominio[m] = "trend-x.ru";
                  msgIndiceSello[m] = 1;
                  msgEsValido[m] = false;
                  msgEtiquetaMeta[m] = "CEBO VIRAL";
                } else {
                  m = crearMensajeDolus("Ana_Dev", "Excelente demo hoy equipo, nos vemos manana en el taller!", 0);
                  msgDominio[m] = "dolus@net";
                  msgIndiceSello[m] = 5;
                  msgEtiquetaMeta[m] = "AMISTAD";
                }
              }
            }
          }
        }
      }
    }
  } else {
    if (jefeIdx == 1) {

      if (s == 0) {
        m = crearMensajeDolus("ECO_BOT_01", "NO ESCUCHES A OTROS. Bloquea a quien piense distinto a ti.", 7);
        msgDominio[m] = "eco-mirror.net";
        msgIndiceSello[m] = 4;
        msgEsValido[m] = false;
        msgEtiquetaMeta[m] = "BURBUJA";
      } else {
        if (s == 1) {
          m = crearMensajeDolus("Radio Campus", "Mesa abierta a las 5 PM sobre habitos digitales saludables.", 0);
          msgDominio[m] = "dolus@corp";
          msgEsCorporativo[m] = true;
          msgIndiceSello[m] = 0;
          msgEtiquetaMeta[m] = "VERIFICADO";
        } else {
          if (s == 2) {
            m = crearMensajeDolus("Archivo_Sombra", "Descarga cadena secreta eco_pack.bat sin mirar fuentes.", 7);
            msgDominio[m] = "eco-bot.io";
            msgExtensionArchivo[m] = ".bat";
            msgTieneAdjunto[m] = true;
            msgCategoriaEspecial[m] = 2;
            msgNivelEncriptado[m] = 1;
            msgEsValido[m] = false;
            msgEtiquetaMeta[m] = "CIFRADO SPAM";
          } else {
            if (s == 3) {
              m = crearMensajeDolus("FuriaDiaria", "Si no odias al grupo opuesto eres parte del problema!", 1);
              msgDominio[m] = "dolus@net";
              msgIndiceSello[m] = 2;
              msgEsValido[m] = false;
              msgEtiquetaMeta[m] = "RAGEBAIT";
            } else {
              if (s == 4) {
                m = crearMensajeDolus("Carlos_M", "Gracias por leer las fuentes completas antes de opinar.", 0);
                msgDominio[m] = "dolus@net";
                msgIndiceSello[m] = 5;
                msgEtiquetaMeta[m] = "DIALOGO";
              } else {
                if (s == 5) {
                  m = crearMensajeDolus("Clave_Foro", "ACTA OFICIAL: Horario confirmado del laboratorio academico.", 0);
                  msgDominio[m] = "dolus@corp";
                  msgEsCorporativo[m] = true;
                  msgCategoriaEspecial[m] = 2;
                  msgNivelEncriptado[m] = 1;
                  msgEsValido[m] = true;
                  msgEtiquetaMeta[m] = "CIFRADO REAL";
                } else {
                  if (s == 6 && telFase2Jefe) {
                    m = crearMensajeDolus("ECO_CORRUPTO", "DETONAR BURBUJA! Repostea ira masiva en 3 segundos o caes!", 7);
                    msgDominio[m] = "eco-overload.ru";
                    msgCategoriaEspecial[m] = 3;
                    msgEsValido[m] = false;
                    msgEtiquetaMeta[m] = "BOMBA ECO";
                  } else {
                    m = crearMensajeDolus("Nota_Oficial", "Guia practica verificada para contrastar noticias reales.", 0);
                    msgDominio[m] = "dolus@corp";
                    msgEsCorporativo[m] = true;
                    msgIndiceSello[m] = 0;
                    msgEtiquetaMeta[m] = "GUIA CORP";
                  }
                }
              }
            }
          }
        }
      }
    } else {
      if (jefeIdx == 2) {

        if (s == 0) {
          m = crearMensajeDolus("Admin_Clon", "Pasame tu contrasena y abre ahora clave_secreta.exe!", 5);
          msgDominio[m] = "d0lus-auth.com";
          msgExtensionArchivo[m] = ".exe";
          msgTieneAdjunto[m] = true;
          msgIndiceSello[m] = 1;
          msgEsValido[m] = false;
          msgVerificado[m] = false;
          msgMotivoInvalidez[m] = 3;
          msgEtiquetaMeta[m] = "CLON DEEPFAKE";
        } else {
          if (s == 1) {
            m = crearMensajeDolus("Voz_Clonada", "URGENTE! Transfiere tus tokens ya, no me llames por voz.", 5);
            msgDominio[m] = "unknown-ip";
            msgIndiceSello[m] = 4;
            msgEsValido[m] = false;
            msgVerificado[m] = false;
            msgMotivoInvalidez[m] = 5;
            msgEtiquetaMeta[m] = "VOZ SINTETICA";
          } else {
            if (s == 2) {
              m = crearMensajeDolus("Mama", "Me avisas cuando termines de estudiar para cenar juntos.", 0);
              msgDominio[m] = "dolus@net";
              msgIndiceSello[m] = 5;
              msgVerificado[m] = false;
              msgEtiquetaMeta[m] = "FAMILIA";
            } else {
              if (s == 3) {
                m = crearMensajeDolus("Seguridad_2FA", "Acceso fisico confirmado desde tu dispositivo de confianza.", 0);
                msgDominio[m] = "dolus@corp";
                msgEsCorporativo[m] = true;
                msgIndiceSello[m] = 0;
                msgVerificado[m] = false;
                msgEtiquetaMeta[m] = "2FA SEGURO";
              } else {
                if (s == 4) {
                  m = crearMensajeDolus("Banco_Vip", "Cuenta bloqueada! Ejecuta parche_seguridad.bat de inmediato.", 2);
                  msgDominio[m] = "vip-dolus.tk";
                  msgExtensionArchivo[m] = ".bat";
                  msgTieneAdjunto[m] = true;
                  msgIndiceSello[m] = 1;
                  msgEsValido[m] = false;
                  msgVerificado[m] = false;
                  msgMotivoInvalidez[m] = 4;
                  msgEtiquetaMeta[m] = "TROJAN .BAT";
                } else {
                  if (s == 5) {
                    m = crearMensajeDolus("Profe_Tesis", "Recibi tu documento entrega2.pdf, excelente estructura.", 0);
                    msgDominio[m] = "dolus@corp";
                    msgExtensionArchivo[m] = ".pdf";
                    msgTieneAdjunto[m] = true;
                    msgEsCorporativo[m] = true;
                    msgIndiceSello[m] = 0;
                    msgVerificado[m] = false;
                    msgEtiquetaMeta[m] = "PDF LIMPIO";
                  } else {
                    if (s == 6) {
                      m = crearMensajeDolus("Sponsor_Fake", "SOBORNO DEEPFAKE: Toma acceso admin VIP sin pasar filtros!", 8);
                      msgDominio[m] = "clon-vip.xyz";
                      msgCategoriaEspecial[m] = 1;
                      msgEsValido[m] = false;
                      msgVerificado[m] = false;
                      msgMotivoInvalidez[m] = 3;
                      msgEtiquetaMeta[m] = "SOBORNO CLON";
                    } else {
                      m = crearMensajeDolus("Video_Truncado", "ALERTA ROJA! Descarga script_emergencia.exe antes de 0s!", 5);
                      msgDominio[m] = "deep-bomb.net";
                      msgExtensionArchivo[m] = ".exe";
                      msgTieneAdjunto[m] = true;
                      msgCategoriaEspecial[m] = 3;
                      msgEsValido[m] = false;
                      msgVerificado[m] = false;
                      msgMotivoInvalidez[m] = 4;
                      msgEtiquetaMeta[m] = "BOMBA FAKE";
                    }
                  }
                }
              }
            }
          }
        }
      } else {
        if (jefeIdx == 3) {

          if (s == 0) {
            m = crearMensajeDolus("Reloj Real", "Pasaste mucho tiempo conectado. Hidratate y estira.", 0);
            msgDominio[m] = "dolus@corp";
            msgEsCorporativo[m] = true;
            msgIndiceSello[m] = 0;
            msgEtiquetaMeta[m] = "BIENESTAR";
          } else {
            if (s == 1) {
              m = crearMensajeDolus("EL_ALGORITMO", "NO APAGUES LA PANTALLA. Sigue haciendo scroll infinito!", 4);
              msgDominio[m] = "loop@core";
              msgIndiceSello[m] = 4;
              msgEsValido[m] = false;
              msgEtiquetaMeta[m] = "TRAMPA VR";
            } else {
              if (s == 2) {
                m = crearMensajeDolus("Nucleo_Bomba", "OVERFLOW! Bloquea este paquete bomba.exe o pierde 26 HP!", 2);
                msgDominio[m] = "alg-rush.net";
                msgExtensionArchivo[m] = ".exe";
                msgTieneAdjunto[m] = true;
                msgCategoriaEspecial[m] = 3;
                msgEsValido[m] = false;
                msgEtiquetaMeta[m] = "BOMBA RAPIDA";
              } else {
                if (s == 3) {
                  m = crearMensajeDolus("Dopamina_Max", "Hack de atencion infinita: extrae e instala boost.zip!", 2);
                  msgDominio[m] = "feed-trap.net";
                  msgExtensionArchivo[m] = ".zip";
                  msgTieneAdjunto[m] = true;
                  msgCategoriaEspecial[m] = 2;
                  msgNivelEncriptado[m] = 1;
                  msgEsValido[m] = false;
                  msgEtiquetaMeta[m] = "ZIP CIFRADO";
                } else {
                  if (s == 4) {
                    m = crearMensajeDolus("PJ_Agenda", "Sal a respirar aire fresco fuera de las notificaciones.", 0);
                    msgDominio[m] = "dolus@net";
                    msgIndiceSello[m] = 5;
                    msgEtiquetaMeta[m] = "VIDA REAL";
                  } else {
                    if (s == 5) {
                      m = crearMensajeDolus("Algoritmo_VIP", "SOBORNO ALGORITMICO: Fama eterna gratis si nos das tus datos!", 8);
                      msgDominio[m] = "dopamina@vip";
                      msgCategoriaEspecial[m] = 1;
                      msgEsValido[m] = false;
                      msgEtiquetaMeta[m] = "SOBORNO ORO";
                    } else {
                      if (s == 6) {
                        m = crearMensajeDolus("Patch_Seguridad", "Actualizacion oficial v2.1: filtro antispam limpio activado.", 0);
                        msgDominio[m] = "dolus@corp";
                        msgEsCorporativo[m] = true;
                        msgCategoriaEspecial[m] = 2;
                        msgNivelEncriptado[m] = 1;
                        msgEsValido[m] = true;
                        msgEtiquetaMeta[m] = "PARCHE REAL";
                      } else {
                        m = crearMensajeDolus("Nucleo_VR", "Vuelve a ponerte el visor VR, la realidad es aburrida.", 4);
                        msgDominio[m] = "loop@core";
                        msgIndiceSello[m] = 4;
                        msgEsValido[m] = false;
                        msgEtiquetaMeta[m] = "MANIPULACION";
                      }
                    }
                  }
                }
              }
            }
          }
        } else {

          if (s == 0) {
            m = crearMensajeDolus("EL_ADMIN", "SOY EL DUENO DEL TRAFICO! Acepta mi dominio absoluto!", 4);
            msgDominio[m] = "admin@root-dark";
            msgIndiceSello[m] = 4;
            msgEsValido[m] = false;
            msgVerificado[m] = false;
            msgMotivoInvalidez[m] = 3;
            msgEtiquetaMeta[m] = "ORIGEN CORRUPTO";
          } else {
            if (s == 1) {
              m = crearMensajeDolus("Red_Humana", "Los usuarios reales merecen privacidad sin rastreo oculto.", 0);
              msgDominio[m] = "dolus@corp";
              msgEsCorporativo[m] = true;
              msgIndiceSello[m] = 0;
              msgVerificado[m] = false;
              msgEtiquetaMeta[m] = "DERECHO REAL";
            } else {
              if (s == 2) {
                m = crearMensajeDolus("Root_Payload", "DETONACION ROOT! Bloquea trojan_admin.exe antes de cero!", 2);
                msgDominio[m] = "dark-root.tk";
                msgExtensionArchivo[m] = ".exe";
                msgTieneAdjunto[m] = true;
                msgCategoriaEspecial[m] = 3;
                msgEsValido[m] = false;
                msgEtiquetaMeta[m] = "BOMBA ADMIN";
              } else {
                if (s == 3) {
                  m = crearMensajeDolus("Pacto_Admin", "SOBORNO SUPREMO: Te corono moderador si te sometes hoy!", 8);
                  msgDominio[m] = "admin-offer.xyz";
                  msgCategoriaEspecial[m] = 1;
                  msgEsValido[m] = false;
                  msgEtiquetaMeta[m] = "PACTO DORADO";
                } else {
                  if (s == 4) {
                    m = crearMensajeDolus("Cifrado_Root", "LLAVE DE PURGA: Codigo limpio para apagar el nodo malicioso.", 0);
                    msgDominio[m] = "dolus@corp";
                    msgEsCorporativo[m] = true;
                    msgCategoriaEspecial[m] = 2;
                    msgNivelEncriptado[m] = 1;
                    msgEsValido[m] = true;
                    msgEtiquetaMeta[m] = "LLAVE PURGA";
                  } else {
                    if (s == 5) {
                      m = crearMensajeDolus("Clon_Sistema", "Urgente! Firma root_hack.bat para 'rescatar' tu cuenta.", 5);
                      msgDominio[m] = "d0lus-root.ru";
                      msgExtensionArchivo[m] = ".bat";
                      msgTieneAdjunto[m] = true;
                      msgVerificado[m] = false;
                      msgEsValido[m] = false;
                      msgMotivoInvalidez[m] = 4;
                      msgEtiquetaMeta[m] = "FIRMA CLONADA";
                    } else {
                      if (s == 6) {
                        m = crearMensajeDolus("Virus_Cifrado", "Bomba silenciosa infect_all.zip camuflada en red segura!", 2);
                        msgDominio[m] = "malware@net";
                        msgExtensionArchivo[m] = ".zip";
                        msgTieneAdjunto[m] = true;
                        msgCategoriaEspecial[m] = 2;
                        msgNivelEncriptado[m] = 1;
                        msgEsValido[m] = false;
                        msgEtiquetaMeta[m] = "CIPHER TRAP";
                      } else {
                        m = crearMensajeDolus("DigitalBalance", "Pulso humano autentico: apaga la red oscura y se libre!", 0);
                        msgDominio[m] = "dolus@net";
                        msgIndiceSello[m] = 5;
                        msgVerificado[m] = false;
                        msgEtiquetaMeta[m] = "ESPERANZA";
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
  return m;
}

void epRecargarColaTelefono() {
  for (int i = 0; i < 3; i++) {
    telCola[i] = epCrearCartaTelefono(telJefeIdx, telIndiceCartaTurno);
    telIndiceCartaTurno++;
  }
}

String epObtenerLineaAdminTel(int idx) {
  String nom = (nombreJugador != null && !nombreJugador.equals("")) ? nombreJugador : "User_Name";
  if (idx == 0) return "Veo que lograste arrancarte el casco VR... y recuperar tu telefono personal.";
  if (idx == 1) return "Pensaste que desconectarte del visor te haria libre? Que ingenuidad, " + nom + ".";
  if (idx == 2) return "El verdadero Algoritmo nunca estuvo en un casco. Siempre ha vivido aqui... en tu pantalla.";
  if (idx == 3) return "Cada notificacion, cada scroll compulsivo, cada gota de dopamina... todo me pertenece a mi: EL ADMIN.";
  if (idx == 4) return "Si pretendes recuperar tu libertad, tendras que purgar mis 4 algoritmos supremos y vencerme a mi.";
  if (idx == 5) return "Acepta la confrontacion digital... o rinde tu mente y se mi esclavo en Dolus Net para siempre.";
  return "...";
}

String epObtenerLineaFinalAdminTel(int tipo, int idx) {
  String nom = (nombreJugador != null && !nombreJugador.equals("")) ? nombreJugador : "User_Name";
  if (tipo == 1) {
    if (idx == 0) return "Que... que hiciste, " + nom + "? Todos mis nodos centrales acaban de colapsar.";
    if (idx == 1) return "El algoritmo perdio el pulso sobre Dolus Net. Ya no puedo retener tus notificaciones.";
    if (idx == 2) return "Crees que apagarme te devolvera el silencio? Otra red siempre volvera a aprender de ti...";
    if (idx == 3) return "Desconectate entonces. La senal se apaga... por ahora.";
  } else {
    if (tipo == 2) {
      if (idx == 0) return "Se acabo, " + nom + ". Tus defensas cayeron justo frente a mi nucleo.";
      if (idx == 1) return "Cada algoritmo cedio, y al final tu telefono volvio a abrirme la puerta.";
      if (idx == 2) return "Ya no tendras que decidir que es real ni que es falso. Yo decidire por ti.";
      if (idx == 3) return "Bienvenido para siempre a Dolus Net. Cerrando tu sesion humana...";
    } else {
      if (idx == 0) return "Tan pronto caiste, " + nom + "? Ni siquiera lograste llegar hasta mi nucleo.";
      if (idx == 1) return "Uno de mis nodos menores (" + epNombreJefeTelefono(telJefeIdx) + ") basto para quebrar tu filtro.";
      if (idx == 2) return "Sin resistencia ni criterio, tu pantalla entera me pertenece desde este instante.";
      if (idx == 3) return "Rinde el control y deja de luchar. Apagando tu interfaz...";
    }
  }
  return "...";
}

void epIniciarConversacionFinalTelefono(int tipo) {
  telFinalPendienteTipo = tipo;
  telFaseIntro = 3;
  telFinalDlgIdx = 0;
  telFinalDlgInicioMs = millis();
  telFinalDlgUltimoSonidoMs = 0;
  telCierreNegroActivo = false;
  telCierreNegroAlpha = 0.0;
  telArrastrando = false;
  telSwipeX = 0;
  telSwipeY = 0;
  telSwipeTargetX = 0;
  telCartaActiva = -1;
  habModalTelefonoAbierto = true;
  limpiarMovimientoHabitacion();
  reproducirDialogoIn();
  if (tipo != 1) {
    reproducirSFX(sonidoGlitchFuerte);
  }
}

void epAvanzarConversacionFinalTelefono() {
  if (telCierreNegroActivo) return;
  int ahora = millis();
  String lineaActual = epObtenerLineaFinalAdminTel(telFinalPendienteTipo, telFinalDlgIdx);
  int lenTot = longitudCadenaSegura(lineaActual);
  int vis = min(lenTot, int((ahora - telFinalDlgInicioMs) * 0.045));
  reproducirTap();
  if (vis < lenTot) {
    telFinalDlgInicioMs = ahora - 10000;
    return;
  }
  telFinalDlgIdx++;
  telFinalDlgInicioMs = ahora;
  telFinalDlgUltimoSonidoMs = 0;
  if (telFinalDlgIdx >= EP_TEL_FIN_DLG_MAX) {
    telCierreNegroActivo = true;
    telCierreNegroAlpha = 0.0;
    reproducirSFX(stingerTransicion);
  }
}

void epDispararChispasTelefono(float cx, float cy, color cPrincipal, int cant, int tipo) {
  for (int i = 0; i < cant; i++) {
    if (epPartCount >= 48) break;
    int idx = epPartCount;
    epPartX[idx] = cx + random(-18, 18);
    epPartY[idx] = cy + random(-12, 12);
    float ang = random(TWO_PI);
    float spd = random(2.5, 7.5);
    epPartVX[idx] = cos(ang) * spd;
    epPartVY[idx] = sin(ang) * spd - random(0.5, 2.0);
    epPartVidaMax[idx] = random(18, 32);
    epPartVida[idx] = epPartVidaMax[idx];
    epPartTam[idx] = random(2.5, 6.0);
    epPartTipo[idx] = tipo;
    if (i % 3 == 0) epPartCol[idx] = color(255);
    else epPartCol[idx] = cPrincipal;
    epPartCount++;
  }
}

void epDispararTextoFlotanteTel(String txt, float x, float y, color col) {
  if (epFloatCount >= 8) {
    for (int i = 0; i < 7; i++) {
      epFloatTxt[i] = epFloatTxt[i + 1];
      epFloatX[i] = epFloatX[i + 1];
      epFloatY[i] = epFloatY[i + 1];
      epFloatVY[i] = epFloatVY[i + 1];
      epFloatVida[i] = epFloatVida[i + 1];
      epFloatCol[i] = epFloatCol[i + 1];
    }
    epFloatCount = 7;
  }
  int idx = epFloatCount;
  epFloatTxt[idx] = txt;
  epFloatX[idx] = x;
  epFloatY[idx] = y;
  epFloatVY[idx] = -1.2;
  epFloatVida[idx] = 1.0;
  epFloatCol[idx] = col;
  epFloatCount++;
}

void epActualizarEfectosTelefono(float dtSec) {
  for (int i = epPartCount - 1; i >= 0; i--) {
    epPartVida[i] -= 1.0;
    if (epPartVida[i] <= 0) {
      for (int k = i; k < epPartCount - 1; k++) {
        epPartX[k] = epPartX[k + 1];
        epPartY[k] = epPartY[k + 1];
        epPartVX[k] = epPartVX[k + 1];
        epPartVY[k] = epPartVY[k + 1];
        epPartVida[k] = epPartVida[k + 1];
        epPartVidaMax[k] = epPartVidaMax[k + 1];
        epPartTam[k] = epPartTam[k + 1];
        epPartCol[k] = epPartCol[k + 1];
        epPartTipo[k] = epPartTipo[k + 1];
      }
      epPartCount--;
      continue;
    }
    epPartX[i] += epPartVX[i];
    epPartY[i] += epPartVY[i];
    epPartVY[i] += 0.12;
    epPartVX[i] *= 0.94;
  }

  for (int i = epFloatCount - 1; i >= 0; i--) {
    epFloatVida[i] -= dtSec * 1.5;
    if (epFloatVida[i] <= 0) {
      for (int k = i; k < epFloatCount - 1; k++) {
        epFloatTxt[k] = epFloatTxt[k + 1];
        epFloatX[k] = epFloatX[k + 1];
        epFloatY[k] = epFloatY[k + 1];
        epFloatVY[k] = epFloatVY[k + 1];
        epFloatVida[k] = epFloatVida[k + 1];
        epFloatCol[k] = epFloatCol[k + 1];
      }
      epFloatCount--;
      continue;
    }
    epFloatY[i] += epFloatVY[i];
    epFloatVY[i] *= 0.92;
  }

  if (telDestelloAlpha > 0) telDestelloAlpha = max(0, telDestelloAlpha - dtSec * 320.0);
  if (telGlitchAlpha > 0) telGlitchAlpha = max(0, telGlitchAlpha - dtSec * 450.0);
}

void epDibujarEfectosTelefono() {
  pushStyle();
  rectMode(CENTER);
  for (int i = 0; i < epPartCount; i++) {
    float tNorm = constrain(epPartVida[i] / epPartVidaMax[i], 0.0, 1.0);
    float alphaP = tNorm * 255.0;
    noStroke();
    fill(red(epPartCol[i]), green(epPartCol[i]), blue(epPartCol[i]), alphaP);
    if (epPartTipo[i] == 1) {
      rect(epPartX[i], epPartY[i], epPartTam[i] * tNorm, epPartTam[i] * tNorm);
    } else {
      ellipse(epPartX[i], epPartY[i], epPartTam[i] * tNorm, epPartTam[i] * tNorm);
    }
  }

  textAlign(CENTER, CENTER);
  for (int i = 0; i < epFloatCount; i++) {
    float a = constrain(epFloatVida[i] * 255.0, 0, 255);
    textSize(11);
    fill(0, a * 0.7);
    text(epFloatTxt[i], epFloatX[i] + 1, epFloatY[i] + 1);
    fill(red(epFloatCol[i]), green(epFloatCol[i]), blue(epFloatCol[i]), a);
    text(epFloatTxt[i], epFloatX[i], epFloatY[i]);
  }

  if (telDestelloAlpha > 2.0) {
    rectMode(CORNER);
    noStroke();
    fill(red(telDestelloCol), green(telDestelloCol), blue(telDestelloCol), min(190, telDestelloAlpha));
    rect(14, 24, 624, 308, 6);
  }

  if (telGlitchAlpha > 5.0) {
    stroke(255, 60, 60, telGlitchAlpha);
    strokeWeight(1.5);
    for (int g = 0; g < 4; g++) {
      float gy = random(32, 320);
      line(18, gy, 630, gy);
    }
  }
  popStyle();
}

void epDibujarDialogoAdminTelefono(float px, float py, int ahora, float dtSec) {
  rectMode(CORNER);
  fill(4, 12, 9);
  noStroke();
  rect(16, 26, 620, 18, 4, 4, 0, 0);
  fill(45, 235, 120);
  textAlign(LEFT, CENTER);
  textSize(8);
  text("DOLUS NET // CHAT DIRECTO DE ADMINISTRACION", 26, 35);
  textAlign(RIGHT, CENTER);
  fill(185, 225, 205);
  text("100% [||||]  03:42 AM", 626, 35);

  fill(22, 8, 14, 245);
  stroke(255, 45, 65, 190);
  strokeWeight(1.6);
  rect(24, 48, 604, 44, 5);

  boolean adminGlitch = (ahora % 600 < 90);
  float aShake = adminGlitch ? random(-2, 2) : 0;
  epDibujarSpriteCuadroTelefono(imgAdminIcon, 30 + aShake, 52, 36, 36, color(52, 12, 18), color(255, 65, 80), sin(ahora * 0.006) * 1.5, false);

  textAlign(LEFT, TOP);
  textSize(12);
  fill(255, 75, 95);
  text("EL ADMIN", 76, 54);
  textSize(8);
  fill(245, 160, 175);
  text("[ ROOT CONTROLLER // DOLUS NET CENTRAL ]", 76, 70);

  boolean blinkRed = ((ahora / 380) % 2 == 0);
  noStroke();
  fill(blinkRed ? color(255, 40, 50) : color(140, 20, 30));
  ellipse(592, 60, 8, 8);
  textAlign(RIGHT, CENTER);
  textSize(8);
  fill(255, 95, 105);
  text("EN LINEA", 582, 60);
  fill(255, 195, 95);
  textSize(7);
  text("AMENAZA: NIVEL OMEGA", 618, 76);

  fill(6, 14, 20, 248);
  stroke(255, 55, 75, 180);
  strokeWeight(1.8);
  rect(24, 98, 604, 166, 6);

  stroke(255, 55, 75, 15);
  strokeWeight(1);
  for (int ly = 104; ly < 260; ly += 6) {
    line(26, ly, 626, ly);
  }

  fill(45, 12, 16);
  stroke(255, 65, 80, 160);
  strokeWeight(1.2);
  rect(32, 104, 175, 17, 3);
  textAlign(CENTER, CENTER);
  fill(255, 135, 145);
  textSize(8);
  text("REMITENTE: root@dolus.net", 119, 112.5);

  textAlign(RIGHT, CENTER);
  fill(185, 205, 220);
  textSize(8);
  text("MENSAJE " + (telAdminDlgIdx + 1) + " / " + EP_TEL_DLG_MAX, 616, 112.5);

  String lineaActual = epObtenerLineaAdminTel(telAdminDlgIdx);
  int lenTot = longitudCadenaSegura(lineaActual);
  int vis = min(lenTot, int((ahora - telAdminDlgInicioMs) * 0.045));
  String subTexto = lineaActual.substring(0, vis);

  if (vis < lenTot && ahora - telAdminDlgUltimoSonidoMs > 90 && (vis % 3 == 0)) {
    reproducirSFX(sonidoEscritura);
    telAdminDlgUltimoSonidoMs = ahora;
  }

  textAlign(LEFT, TOP);
  textSize(11);
  textLeading(16);
  fill(245, 248, 252);
  text(subTexto, 38, 132, 576, 122);

  boolean hovBtn = epHoverBotonTelefono(px, py, 172, 272, 308, 32);
  fill(hovBtn ? color(185, 28, 48) : color(45, 14, 22));
  stroke(255, 85, 105);
  strokeWeight(1.6);
  rect(172, 272, 308, 32, 6);

  float pulsoBtn = sin(ahora * 0.008) * 0.12;
  textAlign(CENTER, CENTER);
  textSize(10);
  fill(255, 255, 180 + int(pulsoBtn * 70));
  text("[ CLIC O ESPACIO PARA CONTINUAR >> ]", 326, 288);

  textAlign(LEFT, CENTER);
  textSize(8);
  fill(165, 195, 215);
  text("ESC / SHIFT : SALTAR DIALOGO", 26, 288);

  textAlign(RIGHT, CENTER);
  fill(255, 115, 125);
  text("DOLUS NET // BLOQUEO ACTIVO", 624, 288);
}

void epDibujarDialogoFinalAdminTelefono(float px, float py, int ahora, float dtSec) {
  boolean esVictoria = (telFinalPendienteTipo == 1);
  color cAcento = esVictoria ? color(75, 240, 165) : color(255, 65, 85);
  color cBorde = esVictoria ? color(55, 195, 130, 190) : color(255, 55, 75, 190);
  color cSub = esVictoria ? color(175, 245, 210) : color(245, 160, 175);

  rectMode(CORNER);
  fill(4, 12, 9);
  noStroke();
  rect(16, 26, 620, 18, 4, 4, 0, 0);
  fill(esVictoria ? color(115, 255, 185) : color(255, 95, 110));
  textAlign(LEFT, CENTER);
  textSize(8);
  text(esVictoria ? "DOLUS NET // CONEXION EN COLAPSO" : "DOLUS NET // TOMA DE CONTROL TOTAL", 26, 35);
  textAlign(RIGHT, CENTER);
  fill(185, 225, 205);
  text(esVictoria ? "0% [....]  03:49 AM" : "100% [||||]  03:49 AM", 626, 35);

  fill(esVictoria ? color(10, 22, 18, 245) : color(22, 8, 14, 245));
  stroke(cBorde);
  strokeWeight(1.6);
  rect(24, 48, 604, 44, 5);

  boolean adminGlitch = (ahora % 480 < 110);
  float aShake = adminGlitch ? random(esVictoria ? -3.0 : -1.5, esVictoria ? 3.0 : 1.5) : 0;
  epDibujarSpriteCuadroTelefono(imgAdminIcon, 30 + aShake, 52, 36, 36,
    esVictoria ? color(16, 40, 30) : color(52, 12, 18),
    cAcento, sin(ahora * 0.006) * 1.5, esVictoria && adminGlitch);

  textAlign(LEFT, TOP);
  textSize(12);
  fill(cAcento);
  text("EL ADMIN", 76, 54);
  textSize(8);
  fill(cSub);
  text(esVictoria ? "[ NODO CENTRAL CRITICO // SENAL DEGRADADA ]" : "[ ROOT CONTROLLER // SESION CAPTURADA ]", 76, 70);

  boolean blinkDot = ((ahora / 340) % 2 == 0);
  noStroke();
  fill(blinkDot ? cAcento : color(60, 30, 35));
  ellipse(592, 60, 8, 8);
  textAlign(RIGHT, CENTER);
  textSize(8);
  fill(cAcento);
  text(esVictoria ? "DESCONECTANDO" : "CONTROL TOTAL", 582, 60);
  fill(esVictoria ? color(145, 230, 185) : color(255, 185, 85));
  textSize(7);
  text(esVictoria ? "ESTADO: PURGA COMPLETADA" : "ESTADO: USUARIO SOMETIDO", 618, 76);

  fill(6, 14, 20, 248);
  stroke(cBorde);
  strokeWeight(1.8);
  rect(24, 98, 604, 166, 6);

  stroke(red(cAcento), green(cAcento), blue(cAcento), 15);
  strokeWeight(1);
  for (int ly = 104; ly < 260; ly += 6) {
    line(26, ly, 626, ly);
  }

  fill(esVictoria ? color(12, 36, 26) : color(45, 12, 16));
  stroke(cBorde);
  strokeWeight(1.2);
  rect(32, 104, 192, 17, 3);
  textAlign(CENTER, CENTER);
  fill(cSub);
  textSize(8);
  text("REMITENTE: root@dolus.net", 128, 112.5);

  int idxMostrado = min(telFinalDlgIdx, EP_TEL_FIN_DLG_MAX - 1);
  textAlign(RIGHT, CENTER);
  fill(185, 205, 220);
  textSize(8);
  text("MENSAJE " + (idxMostrado + 1) + " / " + EP_TEL_FIN_DLG_MAX, 616, 112.5);

  String lineaActual = epObtenerLineaFinalAdminTel(telFinalPendienteTipo, idxMostrado);
  int lenTot = longitudCadenaSegura(lineaActual);
  int vis = telCierreNegroActivo ? lenTot : min(lenTot, int((ahora - telFinalDlgInicioMs) * 0.045));
  String subTexto = lineaActual.substring(0, vis);

  if (!telCierreNegroActivo && vis < lenTot && ahora - telFinalDlgUltimoSonidoMs > 90 && (vis % 3 == 0)) {
    reproducirSFX(sonidoEscritura);
    telFinalDlgUltimoSonidoMs = ahora;
  }

  textAlign(LEFT, TOP);
  textSize(11);
  textLeading(16);
  fill(245, 248, 252);
  text(subTexto, 38, 132, 576, 122);

  boolean hovBtn = !telCierreNegroActivo && epHoverBotonTelefono(px, py, 166, 272, 320, 32);
  fill(hovBtn ? (esVictoria ? color(25, 125, 85) : color(185, 28, 48)) : (esVictoria ? color(14, 42, 30) : color(45, 14, 22)));
  stroke(cAcento);
  strokeWeight(1.6);
  rect(166, 272, 320, 32, 6);

  float pulsoBtn = sin(ahora * 0.008) * 0.12;
  textAlign(CENTER, CENTER);
  textSize(10);
  fill(255, 255, 180 + int(pulsoBtn * 70));
  String lblCont = telCierreNegroActivo ? "CERRANDO SENAL..." : ((idxMostrado >= EP_TEL_FIN_DLG_MAX - 1) ? "[ CLIC O ESPACIO PARA CERRAR >> ]" : "[ CLIC O ESPACIO PARA CONTINUAR >> ]");
  text(lblCont, 326, 288);

  textAlign(LEFT, CENTER);
  textSize(8);
  fill(165, 195, 215);
  text("TRANSMISION FINAL", 26, 288);

  textAlign(RIGHT, CENTER);
  fill(cAcento);
  text(esVictoria ? "RED EN DESCONEXION" : "CONEXION SELLADA", 624, 288);
}

void epDibujarAvisoCombateAdminTelefono(float px, float py, int ahora, float dtSec) {
  rectMode(CORNER);
  fill(14, 5, 8);
  noStroke();
  rect(14, 24, 624, 308, 6);

  boolean blink = ((ahora / 160) % 2 == 0);
  stroke(blink ? color(255, 45, 65) : color(165, 20, 32));
  strokeWeight(2.5);
  noFill();
  rect(18, 28, 616, 300, 6);

  fill(18, 8, 14, 248);
  stroke(255, 55, 75);
  strokeWeight(2.2);
  rect(32, 40, 588, 276, 8);

  stroke(255, 55, 75, 45);
  strokeWeight(1);
  for (int hx = 36; hx < 616; hx += 16) {
    line(hx, 44, hx + 10, 58);
  }

  rectMode(CORNER);
  fill(255, 45, 65);
  noStroke();
  rect(44, 60, 195, 20, 4);
  textAlign(CENTER, CENTER);
  fill(255);
  textSize(9);
  text("// ALERTA DE AMENAZA MAXIMA //", 141, 70);

  textAlign(RIGHT, CENTER);
  fill(255, 185, 80);
  textSize(9);
  text("[ PROTOCOLO DE COMBATE JEFE ]", 608, 70);

  textAlign(CENTER, CENTER);
  textSize(19);
  fill(255, 65, 85);
  text("CONFRONTACION CON EL ADMIN", 326, 110);
  textSize(11);
  fill(255, 215, 95);
  text("BATALLA EN RED // 5 FASES ALGORITMICAS", 326, 134);

  textSize(9);
  textLeading(13);
  fill(235, 240, 248);
  text("El Admin ha capturado el flujo de tu celular. Deberas vencer consecutivamente a los 4 algoritmos de manipulacion (Tendencia, Camara de Eco, Mr. Deepfake y El Algoritmo) hasta derrocar al Admin Supremo en este duelo final.", 52, 154, 548, 52);

  float barX = 104;
  float barY = 224;
  float barW = 444;
  float barH = 40;

  boolean holdInput = mousePressed || (keyPressed && (key == ' ' || key == ENTER || key == RETURN));
  if (holdInput) {
    telAvisoHoldProgreso = min(1.0, telAvisoHoldProgreso + dtSec * 1.5);
    if (frameCount % 6 == 0) reproducirTap();
    if (telAvisoHoldProgreso >= 1.0) {
      reproducirSFX(stingerTransicion);
      telDestelloAlpha = 220.0;
      telDestelloCol = color(255, 45, 65);
      telFaseIntro = 2;
      epIniciarBatallaTelefono();
      telBatallaIniciada = true;
      return;
    }
  } else {
    telAvisoHoldProgreso = max(0.0, telAvisoHoldProgreso - dtSec * 2.4);
  }

  rectMode(CORNER);
  fill(32, 10, 16);
  stroke(255, 65, 85);
  strokeWeight(1.8);
  rect(barX, barY, barW, barH, 6);

  if (telAvisoHoldProgreso > 0.01) {
    noStroke();
    fill(255, 45, 65);
    rect(barX + 2, barY + 2, (barW - 4) * telAvisoHoldProgreso, barH - 4, 4);
  }

  textAlign(CENTER, CENTER);
  textSize(11);
  fill(255);
  text(telAvisoHoldProgreso >= 1.0 ? "INICIANDO COMBATE..." : "[ MANTEN CLIC O ESPACIO PARA INICIAR ]", barX + barW * 0.5, barY + barH * 0.5);

  textAlign(CENTER, BOTTOM);
  textSize(8);
  fill(185, 205, 220);
  text("Fase 1/5: V-RAL // TENDENCIA  |  Objetivo: Salvar internet y recuperar tu control", 326, 302);
}

void epIniciarBatallaTelefono() {
  telJefeIdx = 0;
  telFase2Jefe = false;
  telJefeMaxHP = epMaxHPJefeTel(0);
  telJefeHP = telJefeMaxHP;
  telJugadorMaxHP = 100;
  telJugadorHP = 100;
  telCombo = 0;
  telMejorCombo = 0;
  telCartasResueltas = 0;
  telIndiceCartaTurno = 0;
  telEstadoFin = 0;
  for (int i = 0; i < 4; i++) telStats[i] = 50.0;
  telTokens = 0;
  telControlJugador = 0.5;
  habFinalCinematicaEstado = 0;
  epCreditosFinalesActivos = false;
  epCreditosCerrando = false;
  telUltimaDirEco = -1;
  telRachaMismaDirEco = 0;
  telCardClicksEnc = 0;
  telFlyActivo = false;
  telFeedbackTexto = "DIRECTIVA ACTIVA // ARRASTRA O USA [A]/[D] | [ESP] ESCANEAR | [E] CIFRADO";
  telFeedbackColor = color(95, 255, 165);
  telFeedbackAlpha = 1.0;
  telArrastrando = false;
  telSwipeX = 0;
  telSwipeY = 0;
  telSwipeTargetX = 0;
  telJefeShakeMs = -5000;
  telJugShakeMs = -5000;
  telUltimoFrameMs = millis();

  epRecargarColaTelefono();
  epSiguienteCartaTelefono();
  epDispararBannerFaseTel("JEFE 1/5: V-RAL // TENDENCIA", "FILTRA COMO EN EL PRIMER TRAMO PARA PURGAR SU STREAM", color(28, 232, 94));
  epDispararBarkJefeTel("Crees poder con mi feed desde ese celular?", 2600);
}

void epSiguienteCartaTelefono() {
  telCartaActiva = telCola[0];
  telCola[0] = telCola[1];
  telCola[1] = telCola[2];
  telCola[2] = epCrearCartaTelefono(telJefeIdx, telIndiceCartaTurno);
  telIndiceCartaTurno++;
  telCardTimer = 1.0;
  telCardClicksEnc = 0;
}

void epEscanearCartaActivaTelefono() {
  if (!habModalTelefonoAbierto || telEstadoFin != 0 || telCartaActiva < 0) return;
  if (msgVerificado[telCartaActiva]) return;
  msgVerificado[telCartaActiva] = true;
  reproducirSFX(sonidoHerramientaUso);
  if (msgEsValido[telCartaActiva]) {
    telFeedbackTexto = "ESCANEO OK: REMITENTE AUTENTICO (+6 BONUS)";
    telFeedbackColor = color(105, 255, 185);
  } else {
    telFeedbackTexto = "ALERTA DEEPFAKE: " + msgEtiquetaMeta[telCartaActiva] + "!";
    telFeedbackColor = color(255, 125, 95);
  }
  telFeedbackAlpha = 1.0;
}

int epEstadoDerrotaSegunJefeTel() {
  return (telJefeIdx >= EP_TEL_NUM_JEFES - 1) ? 2 : 3;
}

void epResolverCartaTelefono(boolean aceptar) {
  if (!habModalTelefonoAbierto || telEstadoFin != 0 || telCartaActiva < 0) return;

  int dirActual = aceptar ? 1 : 0;
  if (telJefeIdx == 1) {
    if (dirActual == telUltimaDirEco) telRachaMismaDirEco++;
    else telRachaMismaDirEco = 1;
    telUltimaDirEco = dirActual;
  } else {
    telUltimaDirEco = dirActual;
    telRachaMismaDirEco = 0;
  }

  telFlyActivo = true;
  telFlyX = 391 + telSwipeX;
  telFlyY = 216 + telSwipeY;
  telFlyVX = aceptar ? 22.0 : -22.0;
  telFlyRot = telSwipeX * 0.08;
  telFlyAlpha = 255.0;
  telFlyFueAceptar = aceptar;
  telFlyRem = (msgCategoriaEspecial[telCartaActiva] == 2 && telCardClicksEnc < 3) ? "[CIFRADO]" : msgRemitente[telCartaActiva];

  telArrastrando = false;
  telSwipeX = 0;
  telSwipeY = 0;
  telSwipeTargetX = 0;

  if (msgCategoriaEspecial[telCartaActiva] == 2 && telCardClicksEnc < 3) {
    telCombo = 0;
    telJugadorHP = max(0, telJugadorHP - 16);
    telJugShakeMs = millis();
    telStats[1] = constrain(telStats[1] - 10, 12, 100);
    telControlJugador = constrain(telControlJugador + 0.14, 0.08, 0.92);
    reproducirSFX(sonidoGlitchFuerte);
    telFeedbackTexto = "NO DESENCRIPTASTE ANTES DE DESLIZAR! -16 HP";
    telFeedbackColor = color(255, 95, 105);
    telFeedbackAlpha = 1.0;
    epDispararBarkJefeTel("JA! Ni siquiera leiste el cifrado!", 2000);
    if (telJugadorHP <= 0) {
      epIniciarConversacionFinalTelefono(epEstadoDerrotaSegunJefeTel());
      return;
    }
    epSiguienteCartaTelefono();
    return;
  }

  boolean acierto = (aceptar == msgEsValido[telCartaActiva]);
  telCartasResueltas++;

  if (acierto) {
    telCombo++;
    if (telCombo > telMejorCombo) telMejorCombo = telCombo;
    telTokens += 5 + min(10, telCombo);
    telStats[0] = constrain(telStats[0] + (aceptar ? 6 : 4), 12, 100);
    telStats[1] = constrain(telStats[1] + (aceptar ? 4 : 7), 12, 100);
    telStats[2] = constrain(telStats[2] + 5, 12, 100);
    telStats[3] = constrain(telStats[3] + (aceptar ? 6 : 2), 12, 100);
    telControlJugador = constrain(telControlJugador - 0.10, 0.08, 0.92);

    int dmg = 20 + min(12, (telCombo - 1) * 3);
    if (msgCategoriaEspecial[telCartaActiva] == 1) dmg += 8;
    if ((telJefeIdx == 2 || telJefeIdx == 4) && msgVerificado[telCartaActiva]) dmg += 6;

    telJefeHP = max(0, telJefeHP - dmg);
    telJefeShakeMs = millis();
    if (aceptar && telJugadorHP < telJugadorMaxHP) {
      telJugadorHP = min(telJugadorMaxHP, telJugadorHP + 6);
    } else {
      if (msgCategoriaEspecial[telCartaActiva] == 1 && !aceptar) {
        telJugadorHP = min(telJugadorMaxHP, telJugadorHP + 8);
      }
    }

    reproducirSFX(sonidoDecisionCorrecta);
    telFeedbackTexto = aceptar ? ("ACEPTADO! -" + dmg + " HP JEFE  +" + (5 + min(10, telCombo)) + "T") : ("RECHAZADO! -" + dmg + " HP JEFE  +" + (5 + min(10, telCombo)) + "T");
    telFeedbackColor = color(95, 255, 165);
    telFeedbackAlpha = 1.0;

    telDestelloCol = color(45, 255, 125);
    telDestelloAlpha = (telCombo >= 3) ? 190.0 : 130.0;
    epDispararChispasTelefono(326, 212, color(45, 255, 125), 18, 0);
    epDispararChispasTelefono(251, 69, color(255, 75, 95), 12, 1);
    epDispararTextoFlotanteTel("-" + dmg + " HP", 251, 55, color(255, 110, 110));
    if (telCombo > 1) {
      epDispararTextoFlotanteTel("COMBO x" + telCombo, 326, 172, color(255, 220, 80));
    }
    if (telCombo >= 3) {
      epDispararChispasTelefono(326, 172, color(255, 215, 0), 16, 2);
    }

    if (telJefeIdx == 1 && telRachaMismaDirEco >= 3 && telJefeHP > 0) {
      telRachaMismaDirEco = 0;
      int dmgEco = telFase2Jefe ? 10 : 7;
      telJugadorHP = max(0, telJugadorHP - dmgEco);
      telJugShakeMs = millis();
      telControlJugador = constrain(telControlJugador + 0.12, 0.08, 0.92);
      telFeedbackTexto = "INERCIA DE ECO x3! -" + dmgEco + " HP";
      telFeedbackColor = color(255, 130, 85);
      epDispararBarkJefeTel("ATRAPADO EN MI ECO! CAMBIA DE DIRECCION!", 2200);
      if (telJugadorHP <= 0) {
        epIniciarConversacionFinalTelefono(epEstadoDerrotaSegunJefeTel());
        return;
      }
    }

    if (!telFase2Jefe && telJefeHP > 0 && telJefeHP <= telJefeMaxHP / 2) {
      telFase2Jefe = true;
      reproducirSFX(stingerTransicion);
      epDispararBannerFaseTel("ALERTA // FASE 2 ACTIVADA", epSubtituloJefeTel(telJefeIdx), color(255, 75, 95));
      if (telJefeIdx == 0) epDispararBarkJefeTel("Hora de mis disculpas falsas y bots!", 2400);
      else {
        if (telJefeIdx == 1) epDispararBarkJefeTel("Siente la presion de mi burbuja extrema!", 2400);
        else {
          if (telJefeIdx == 2) epDispararBarkJefeTel("Invertire tus botones con sarcasmo puro!", 2400);
          else {
            if (telJefeIdx == 3) epDispararBarkJefeTel("PROTOCOLO OMEGA! Bombas y cifrados activos!", 2400);
            else epDispararBarkJefeTel("ARRODILLATE ANTE EL ADMIN SUPREMO!", 2600);
          }
        }
      }
    }

    if (telJefeHP <= 0) {
      if (telJefeIdx < EP_TEL_NUM_JEFES - 1) {
        telJefeIdx++;
        telFase2Jefe = false;
        telUltimaDirEco = -1;
        telRachaMismaDirEco = 0;
        telControlJugador = 0.5;
        telJefeMaxHP = epMaxHPJefeTel(telJefeIdx);
        telJefeHP = telJefeMaxHP;
        telJugadorHP = min(telJugadorMaxHP, telJugadorHP + 25);
        telIndiceCartaTurno = 0;
        epRecargarColaTelefono();
        reproducirSFX(sonidoTransferenciaExitosa);
        telFeedbackTexto = "JEFE VENCIDO! ENTRA " + epNombreJefeTelefono(telJefeIdx);
        telFeedbackColor = color(255, 230, 95);
        epDispararBannerFaseTel("JEFE " + (telJefeIdx + 1) + "/5: " + epNombreJefeTelefono(telJefeIdx),
          (telJefeIdx == 4) ? "JEFE EXTRA FINAL! DERROTALO PARA SALVAR INTERNET" : "NUEVO CONTRINCANTE EN LINEA (+25 HP RECUPERADOS)",
          (telJefeIdx == 4) ? color(255, 85, 210) : color(255, 215, 95));
        if (telJefeIdx == 1) epDispararBarkJefeTel("No repitas 3 veces el mismo lado!", 2400);
        else {
          if (telJefeIdx == 2) epDispararBarkJefeTel("Usa [ESPACIO] o moriras entre clones!", 2400);
          else {
            if (telJefeIdx == 3) epDispararBarkJefeTel("Mis bombas y cifrados son inevitables!", 2400);
            else epDispararBarkJefeTel("YO GOBERNARE INTERNET. TU CELULAR ES MIO!", 2800);
          }
        }
      } else {

        reproducirLogro();
        epIniciarConversacionFinalTelefono(1);
        return;
      }
    }
  } else {
    telCombo = 0;
    telStats[0] = constrain(telStats[0] - 8, 12, 100);
    telStats[1] = constrain(telStats[1] - (aceptar ? 12 : 6), 12, 100);
    telStats[2] = constrain(telStats[2] - 7, 12, 100);
    telControlJugador = constrain(telControlJugador + 0.14, 0.08, 0.92);

    int jugDmg = (msgCategoriaEspecial[telCartaActiva] == 1 && aceptar) ? 28
               : (msgCategoriaEspecial[telCartaActiva] == 3 && aceptar) ? 26
               : (aceptar ? 20 : 17);
    telJugadorHP = max(0, telJugadorHP - jugDmg);
    telJugShakeMs = millis();
    reproducirSFX(sonidoGlitchFuerte);
    telFeedbackTexto = aceptar ? ("TRAMPA ACEPTADA! -" + jugDmg + " HP") : ("MENSAJE REAL BLOQUEADO! -" + jugDmg + " HP");
    telFeedbackColor = color(255, 95, 105);
    telFeedbackAlpha = 1.0;
    epDispararBarkJefeTel((telJefeIdx == 4) ? "Pronto seras mi esclavo digital!" : "Un paso mas cerca de rendirte!", 2000);

    telDestelloCol = color(255, 45, 65);
    telDestelloAlpha = 210.0;
    telGlitchAlpha = 180.0;
    epDispararChispasTelefono(326, 212, color(255, 45, 65), 20, 1);
    epDispararChispasTelefono(393, 69, color(255, 55, 75), 14, 1);
    epDispararTextoFlotanteTel("-" + jugDmg + " HP", 393, 55, color(255, 75, 75));

    if (telJugadorHP <= 0) {
      epIniciarConversacionFinalTelefono(epEstadoDerrotaSegunJefeTel());
      return;
    }
  }

  epSiguienteCartaTelefono();
}

void epDibujarSpriteCuadroTelefono(PImage img, float x, float y, float w, float h, color bgCol, color borderCol, float bobY, boolean golpeado) {
  rectMode(CORNER);
  fill(bgCol);
  stroke(borderCol);
  strokeWeight(2.5);
  rect(x, y, w, h, 4);

  if (img != null && img.width > 0 && img.height > 0) {
    float esc = min((w - 12.0) / img.width, (h - 12.0) / img.height);
    float dw = img.width * esc;
    float dh = img.height * esc;
    imageMode(CENTER);
    image(imgShaderDaltonismo(img), x + w * 0.5, y + h * 0.5 + bobY, dw, dh);
  }

  if (golpeado) {
    noStroke();
    fill(255, 255, 255, 115);
    rect(x + 2, y + 2, w - 4, h - 4, 3);
  }
}

void epDibujarCartaTelefono(int c, float cx, float cy, float cw, float ch, float tiltDeg, float pxMouse, float pyMouse) {
  if (c < 0) return;
  boolean esEncSinLeer = (msgCategoriaEspecial[c] == 2 && telCardClicksEnc < 3);
  boolean esSoborno = (msgCategoriaEspecial[c] == 1);
  boolean esBomba = (msgCategoriaEspecial[c] == 3);

  color colMarco = esEncSinLeer ? color(205, 105, 255) : (esSoborno ? color(255, 200, 48) : (esBomba ? color(255, 62, 72) : color(32, 238, 102)));
  color colFondo = esEncSinLeer ? color(18, 8, 28) : (esBomba ? color(24, 6, 10) : (esSoborno ? color(24, 18, 4) : color(5, 14, 10)));

  pushMatrix();
  translate(cx, cy);
  rotate(radians(tiltDeg));

  rectMode(CENTER);
  noStroke();
  fill(0, 0, 0, 175);
  rect(4, 5, cw, ch, 8);

  fill(colFondo);
  stroke(colMarco);
  strokeWeight(2.0);
  rect(0, 0, cw, ch, 8);

  rectMode(CORNER);
  fill(red(colMarco) * 0.14, green(colMarco) * 0.18, blue(colMarco) * 0.14, 240);
  noStroke();
  rect(-cw * 0.5 + 2, -ch * 0.5 + 2, cw - 4, 17, 7, 7, 0, 0);

  fill(255, 90, 82);
  ellipse(-cw * 0.5 + 10, -ch * 0.5 + 10, 4.5, 4.5);
  fill(255, 195, 62);
  ellipse(-cw * 0.5 + 17, -ch * 0.5 + 10, 4.5, 4.5);
  fill(65, 225, 110);
  ellipse(-cw * 0.5 + 24, -ch * 0.5 + 10, 4.5, 4.5);

  if (fuenteRetro != null) textFont(fuenteRetro);
  textAlign(LEFT, CENTER);
  textSize(8);
  fill(lerpColor(colMarco, color(255), 0.35));
  String tituloWin = esEncSinLeer ? "CIFRADO // BLOQUEADO" : (esBomba ? "ALERTA // BOMBA" : (esSoborno ? "OFERTA // SOBORNO" : "FORO // PUBLICACION"));
  text(tituloWin, -cw * 0.5 + 31, -ch * 0.5 + 10);

  textAlign(RIGHT, CENTER);
  textSize(7);
  fill(lerpColor(colMarco, color(220, 255, 235), 0.25));
  text("[WEB #" + (telCartasResueltas + 1) + "]", cw * 0.5 - 7, -ch * 0.5 + 10);

  stroke(colMarco, 110);
  strokeWeight(1);
  line(-cw * 0.5 + 2, -ch * 0.5 + 19, cw * 0.5 - 2, -ch * 0.5 + 19);

  rectMode(CORNER);
  fill(8, 28, 18);
  stroke(colMarco, 180);
  strokeWeight(1.1);
  rect(-cw * 0.5 + 9, -ch * 0.5 + 22, 18, 18, 3);
  noStroke();
  fill(colMarco);
  rect(-cw * 0.5 + 13, -ch * 0.5 + 25, 10, 6, 1);
  rect(-cw * 0.5 + 15, -ch * 0.5 + 33, 6, 4, 1);

  textAlign(LEFT, CENTER);
  textSize(8);
  fill(235, 255, 240);
  text(esEncSinLeer ? "@nodo_cifrado" : ("@" + msgRemitente[c]), -cw * 0.5 + 32, -ch * 0.5 + 31);

  fill(14, 28, 22);
  stroke(135, 175, 155, 130);
  strokeWeight(1);
  rect(cw * 0.5 - 118, -ch * 0.5 + 24, 110, 14, 3);
  textAlign(CENTER, CENTER);
  textSize(7);
  color colDom = esEncSinLeer ? color(225, 175, 255) : ((msgDominio[c].equals("dolus@corp") || msgDominio[c].equals("dolus@net")) ? color(210, 248, 225) : color(255, 135, 135));
  fill(colDom);
  text("RED: " + (esEncSinLeer ? "???@cif" : msgDominio[c]), cw * 0.5 - 63, -ch * 0.5 + 31);

  rectMode(CORNER);
  textAlign(CENTER, CENTER);
  textSize(9);
  textLeading(11);
  if (esEncSinLeer) {
    fill(235, 200, 255);
    text("[#X%@! CIFRADO] Haz CLIC aqui " + (3 - telCardClicksEnc) + " veces para descifrar antes de arrastrar.", -cw * 0.5 + 10, -ch * 0.5 + 43, cw - 20, 38);
  } else {
    fill(238, 246, 242);
    text(msgContenido[c], -cw * 0.5 + 10, -ch * 0.5 + 43, cw - 20, 38);
  }

  float pillY = ch * 0.5 - 30;
  float pillW = (cw - 24) * 0.5;
  rectMode(CORNER);
  fill(8, 18, 14, 235);
  stroke(msgTieneAdjunto[c] && (msgExtensionArchivo[c].equals(".exe") || msgExtensionArchivo[c].equals(".bat") || msgExtensionArchivo[c].equals(".zip")) ? color(255, 90, 95, 180) : color(75, 125, 100, 150));
  strokeWeight(1.1);
  rect(-cw * 0.5 + 8, pillY, pillW, 16, 3);
  textAlign(CENTER, CENTER);
  textSize(7);
  fill(msgTieneAdjunto[c] ? color(255, 185, 120) : color(155, 195, 175));
  text(esEncSinLeer ? "[ ??? ]" : (msgTieneAdjunto[c] ? ("[ ADJ: " + msgExtensionArchivo[c] + " ]") : "[ SIN ADJUNTO ]"), -cw * 0.5 + 8 + pillW * 0.5, pillY + 8);

  if ((telJefeIdx == 2 || telJefeIdx == 4) && !esEncSinLeer) {
    if (!msgVerificado[c]) {
      boolean hovScan = epHoverBotonTelefono(pxMouse, pyMouse, cx + 4, cy + pillY, pillW, 16);
      fill(hovScan ? color(30, 130, 190) : color(14, 52, 92));
      stroke(110, 225, 255);
      strokeWeight(1.3);
      rect(4, pillY, pillW, 16, 3);
      fill(255);
      text("CLIC ESCANEAR", 4 + pillW * 0.5, pillY + 8);
    } else {
      fill(msgEsValido[c] ? color(16, 85, 52) : color(115, 22, 32));
      stroke(msgEsValido[c] ? color(85, 255, 165) : color(255, 95, 105));
      rect(4, pillY, pillW, 16, 3);
      fill(255);
      text(msgEsValido[c] ? "AUTENTICO" : msgEtiquetaMeta[c], 4 + pillW * 0.5, pillY + 8);
    }
  } else {
    fill(8, 18, 14, 235);
    stroke(msgEsCorporativo[c] ? color(65, 210, 245, 170) : color(75, 125, 100, 150));
    strokeWeight(1.1);
    rect(4, pillY, pillW, 16, 3);
    fill(msgEsCorporativo[c] ? color(135, 230, 255) : color(155, 195, 175));
    text(esEncSinLeer ? ("CLIC x" + (3 - telCardClicksEnc)) : (msgEsCorporativo[c] ? "[ SELLO: CORP ]" : ("[ " + msgEtiquetaMeta[c] + " ]")), 4 + pillW * 0.5, pillY + 8);
  }

  noStroke();
  fill(14, 34, 24);
  rect(-cw * 0.5 + 8, ch * 0.5 - 9, cw - 16, 4, 2);
  fill(esBomba ? color(255, 75, 85) : (telCardTimer > 0.32 ? colMarco : color(255, 95, 85)));
  rect(-cw * 0.5 + 8, ch * 0.5 - 9, max(0, (cw - 16) * telCardTimer), 4, 2);

  if (abs(telSwipeX) > 16) {
    boolean aDer = telSwipeX > 0;
    float alphaStamp = constrain((abs(telSwipeX) - 16) * 4.2, 0, 242);
    String txtDer = (telJefeIdx == 2 && telFase2Jefe) ? "CLARO QUE SI" : "ACEPTAR >>";
    String txtIzq = (telJefeIdx == 2 && telFase2Jefe) ? "SOY MIEDOSO" : "<< RECHAZAR";
    rectMode(CENTER);
    fill(aDer ? color(14, 128, 76, alphaStamp) : color(185, 38, 44, alphaStamp));
    stroke(255, alphaStamp);
    strokeWeight(1.8);
    rect(aDer ? 62 : -62, -ch * 0.5 + 16, 106, 18, 4);
    textAlign(CENTER, CENTER);
    textSize(9);
    fill(255, alphaStamp);
    text(aDer ? txtDer : txtIzq, aDer ? 62 : -62, -ch * 0.5 + 16);
  }

  popMatrix();
}

void epDibujarMiniIconoStatTel(int idx, float x, float y, float sz, float val) {
  String[] lbs = {"SLD", "SEG", "REP", "POP"};
  rectMode(CENTER);
  fill(18, 22, 14);
  stroke(235, 185, 58);
  strokeWeight(1.2);
  rect(x, y, sz, sz, 4);

  PImage im = obtenerImgStat(idx);
  if (im != null) {
    imageMode(CENTER);
    tint(255, 220, 115);
    image(imgShaderDaltonismo(im), x, y, sz - 4, sz - 4);
    noTint();
  } else {
    noStroke();
    fill(245, 195, 65);
    rect(x, y + (sz * 0.35) * (1.0 - val / 100.0), sz - 5, max(2, (sz - 5) * (val / 100.0)), 2);
  }

  textAlign(CENTER, TOP);
  textSize(7);
  fill(235, 225, 165);
  text(int(val) + "%", x, y + sz * 0.5 + 2);
  fill(135, 220, 165);
  text(lbs[idx], x, y + sz * 0.5 + 10);
}

void epActualizarYDibujarModalTelefono() {
  int ahora = millis();
  float dtSec = min(0.05, max(0.001, (ahora - telUltimoFrameMs) * 0.001));
  telUltimoFrameMs = ahora;

  epActualizarEfectosTelefono(dtSec);
  telJefeHPDraw = lerp(telJefeHPDraw, (float)telJefeHP, 0.14);
  telJugadorHPDraw = lerp(telJugadorHPDraw, (float)telJugadorHP, 0.14);

  if (telFaseIntro == 2) {
    if (telEstadoFin == 0 && telCartaActiva >= 0) {
      if (!telArrastrando) {
        telSwipeX = lerp(telSwipeX, telSwipeTargetX, 0.25);
        telSwipeY = lerp(telSwipeY, 0, 0.25);
      }
      float multVel = (msgCategoriaEspecial[telCartaActiva] == 3) ? 1.65 : ((telFase2Jefe ? 1.18 : 1.0));
      telCardTimer -= (dtSec * multVel) / 9.5;
      if (telCardTimer <= 0.0) {
        telCombo = 0;
        telControlJugador = constrain(telControlJugador + 0.14, 0.08, 0.92);
        int tDmg = (msgCategoriaEspecial[telCartaActiva] == 3) ? 26 : 16;
        telJugadorHP = max(0, telJugadorHP - tDmg);
        telJugShakeMs = ahora;
        telDestelloCol = color(255, 45, 65);
        telDestelloAlpha = 200.0;
        telGlitchAlpha = 190.0;
        epDispararChispasTelefono(393, 69, color(255, 55, 75), 14, 1);
        epDispararTextoFlotanteTel("-" + tDmg + " HP", 393, 55, color(255, 75, 75));
        telFeedbackTexto = (msgCategoriaEspecial[telCartaActiva] == 3) ? ("EXPLOTO LA BOMBA! -" + tDmg + " HP") : ("TIEMPO AGOTADO! -" + tDmg + " HP");
        telFeedbackColor = color(255, 95, 95);
        telFeedbackAlpha = 1.0;
        reproducirSFX(sonidoGlitchFuerte);
        if (telJugadorHP <= 0) {
          epIniciarConversacionFinalTelefono(epEstadoDerrotaSegunJefeTel());
          return;
        } else {
          epSiguienteCartaTelefono();
        }
      }
    }

    if (telFlyActivo) {
      telFlyX += telFlyVX;
      telFlyAlpha -= 22.0;
      if (telFlyAlpha <= 0) telFlyActivo = false;
    }
    if (telFeedbackAlpha > 0.0) {
      telFeedbackAlpha = max(0.0, telFeedbackAlpha - dtSec * 0.42);
    }
    if (telBannerFaseActivo && ahora - telBannerFaseInicioMs > 2300) {
      telBannerFaseActivo = false;
    }
  }

  rectMode(CORNER);
  noStroke();
  fill(0, 0, 0, 215);
  rect(0, 0, width, height);

  float[] tf = new float[3];
  epObtenerTransformTelefono(tf);
  float[] pm = new float[2];
  epMouseAPantallaTelefono(pm);
  float px = pm[0];
  float py = pm[1];

  pushMatrix();
  translate(tf[0], tf[1]);
  scale(tf[2]);

  pushMatrix();
  translate(102.0, 24.0);
  rotate(0.205212);

  noStroke();
  fill(4, 10, 7);
  rect(-10, -10, 675, 382);

  rectMode(CORNER);
  fill(5, 11, 8);
  stroke(255);
  strokeWeight(2.5);
  rect(14, 24, 624, 308, 6);

  if (fuenteRetro != null) textFont(fuenteRetro);

  if (telFaseIntro == 0) {
    epDibujarDialogoAdminTelefono(px, py, ahora, dtSec);
  } else {
    if (telFaseIntro == 1) {
      epDibujarAvisoCombateAdminTelefono(px, py, ahora, dtSec);
    } else {
      if (telFaseIntro == 3) {
        epDibujarDialogoFinalAdminTelefono(px, py, ahora, dtSec);
      } else {

        rectMode(CORNER);
        fill(56, 12, 18, 225);
        stroke(255, 58, 72);
        strokeWeight(1.5);
        rect(22, 32, 178, 22, 3);
        textAlign(CENTER, CENTER);
        textSize(10);
        fill(255, 95, 105);
        text(epNombreJefeTelefono(telJefeIdx), 111, 43);

        stroke(255, 45, 65);
        strokeWeight(3);
        line(23, 57, 199, 57);

        textAlign(LEFT, TOP);
        textSize(9);
        fill(215, 175, 255);
        text("HP JEFE  " + telJefeHP + "/" + telJefeMaxHP, 23, 62);
        rectMode(CORNER);
        fill(24, 12, 38);
        stroke(185, 75, 255);
        strokeWeight(2);
        rect(22, 75, 178, 12, 3);
        noStroke();
        fill(255, 140, 50, 160);
        float ratioJefeDraw = (telJefeMaxHP > 0) ? (telJefeHPDraw / (float)telJefeMaxHP) : 0.0;
        rect(24, 77, max(0, 174 * ratioJefeDraw), 8, 2);
        fill(telFase2Jefe ? color(255, 65, 175) : color(175, 55, 255));
        float ratioJefe = (telJefeMaxHP > 0) ? (telJefeHP / (float)telJefeMaxHP) : 0.0;
        rect(24, 77, max(0, 174 * ratioJefe), 8, 2);

        textAlign(LEFT, TOP);
        textSize(8);
        fill(telFase2Jefe ? color(255, 130, 140) : color(185, 195, 220));
        text("JEFE " + (telJefeIdx + 1) + "/5 // " + epSubtituloJefeTel(telJefeIdx), 23, 93);

        boolean jefeGolpe = (ahora - telJefeShakeMs < 220);
        float jxShake = jefeGolpe ? sin(ahora * 0.25) * 4.0 : 0.0;
        float jBob = sin(ahora * 0.0055) * 2.5;
        epDibujarSpriteCuadroTelefono(
          epImagenJefeTelefono(telJefeIdx),
          210 + jxShake, 32, 96, 74,
          telFase2Jefe ? color(152, 18, 38) : color(118, 16, 26), color(42, 235, 110),
          jBob, jefeGolpe
        );

        textAlign(CENTER, CENTER);
        textSize(12);
        fill(255, 210, 95);
        text("VS", 326, 56);
        if (telCombo >= 2) {
          textSize(10);
          fill(95, 255, 165);
          text("x" + telCombo, 326, 76);
        }
        if (telJefeIdx == 1) {
          textSize(8);
          fill(255, 185, 95);
          text("ECO:" + telRachaMismaDirEco + "/3", 326, 94);
        }

        boolean jugGolpe = (ahora - telJugShakeMs < 220);
        float pxShake = jugGolpe ? sin(ahora * 0.28) * 4.0 : 0.0;
        int pFrame = ((ahora / 260) % 2 == 0) ? 0 : 1;
        epDibujarSpriteCuadroTelefono(
          spritesPersonaje[0][pFrame],
          346 + pxShake, 32, 96, 74,
          color(12, 26, 76), color(42, 235, 110),
          -jBob * 0.6, jugGolpe
        );

        rectMode(CORNER);
        fill(14, 24, 62, 230);
        stroke(42, 110, 245);
        strokeWeight(1.5);
        rect(452, 32, 144, 22, 3);
        textAlign(CENTER, CENTER);
        textSize(10);
        fill(145, 200, 255);
        String nomPj = (nombreJugador != null && !nombreJugador.equals("")) ? nombreJugador : "PJ DE BLO";
        text(nomPj, 524, 43);

        boolean hovCerrar = epHoverBotonTelefono(px, py, 600, 32, 30, 22);
        fill(hovCerrar ? color(175, 40, 52) : color(58, 22, 32));
        stroke(255, 115, 125);
        strokeWeight(1.5);
        rect(600, 32, 30, 22, 3);
        fill(255);
        textSize(11);
        text("X", 615, 43);

        stroke(32, 102, 245);
        strokeWeight(3);
        line(453, 57, 629, 57);

        textAlign(LEFT, TOP);
        textSize(9);
        fill(155, 205, 255);
        text("HP PJ  " + telJugadorHP + "/" + telJugadorMaxHP, 453, 62);
        rectMode(CORNER);
        fill(16, 12, 38);
        stroke(185, 75, 255);
        strokeWeight(2);
        rect(452, 75, 178, 12, 3);
        noStroke();
        fill(255, 140, 50, 160);
        float ratioJugDraw = (telJugadorMaxHP > 0) ? (telJugadorHPDraw / (float)telJugadorMaxHP) : 0.0;
        rect(454, 77, max(0, 174 * ratioJugDraw), 8, 2);
        fill(24, 88, 238);
        float ratioJug = (telJugadorMaxHP > 0) ? (telJugadorHP / (float)telJugadorMaxHP) : 0.0;
        rect(454, 77, max(0, 174 * ratioJug), 8, 2);

        textAlign(LEFT, TOP);
        textSize(8);
        fill(185, 195, 220);
        text("CARTAS: " + telCartasResueltas + "  |  [X] SALIR", 453, 93);

        rectMode(CORNER);
        fill(3, 10, 7);
        stroke(28, 232, 94);
        strokeWeight(2.5);
        rect(22, 114, 608, 210, 6);

        stroke(28, 232, 94, 14);
        strokeWeight(1);
        for (int y = 118; y < 320; y += 6) {
          line(25, y, 627, y);
        }

        fill(10, 28, 18);
        stroke(28, 232, 94, 130);
        strokeWeight(1);
        rect(26, 118, 600, 16, 3);
        noStroke();
        fill(45, 255, 125);
        ellipse(34, 126, 5, 5);
        textAlign(LEFT, CENTER);
        textSize(7.5);
        fill(175, 255, 200);
        text("DIRECTIVA: CERO TOLERANCIA TROLL", 42, 126);
        textAlign(CENTER, CENTER);
        fill(255, 215, 95);
        text("RONDA " + (telJefeIdx + 1) + "/5  |  TOKENS: " + telTokens, 326, 126);
        textAlign(RIGHT, CENTER);
        fill(185, 225, 200);
        text("Arrastra con Mouse (o [A]/[D])", 620, 126);

        textAlign(RIGHT, CENTER);
        textSize(7.5);
        fill(165, 215, 185);
        text("CONTROL JUGADOR", 238, 143);
        textAlign(LEFT, CENTER);
        fill(255, 85, 85);
        text("ALGORITMO", 414, 143);

        rectMode(CORNER);
        fill(10, 24, 18);
        stroke(95, 155, 125, 165);
        strokeWeight(1);
        rect(244, 140, 164, 6, 3);
        for (int t = 1; t < 6; t++) {
          line(244 + t * 27.3, 140, 244 + t * 27.3, 146);
        }
        noStroke();
        fill(telControlJugador < 0.5 ? color(85, 255, 165) : color(255, 95, 95));
        ellipse(247 + 158 * telControlJugador, 143, 7, 7);

        if (telSwipeX < -15) {
          float alphaRech = min(240, abs(telSwipeX) * 2.8);
          noStroke();
          fill(255, 45, 65, min(80, abs(telSwipeX) * 0.9));
          rect(24, 150, 60, 124, 4);

          rectMode(CENTER);
          fill(175, 25, 38, alphaRech);
          stroke(255, 110, 110, alphaRech);
          strokeWeight(1.8);
          rect(82, 212, 104, 38, 6);
          textAlign(CENTER, CENTER);
          textSize(10);
          fill(255, alphaRech);
          text("<< RECHAZAR", 82, 212);

          stroke(255, 75, 85, alphaRech);
          strokeWeight(2.0);
          line(326 + telSwipeX - 170, 212 + telSwipeY, 134, 212);
        } else {
          if (telSwipeX > 15) {
            float alphaAcep = min(240, telSwipeX * 2.8);
            noStroke();
            fill(45, 255, 125, min(80, telSwipeX * 0.9));
            rect(568, 150, 60, 124, 4);

            rectMode(CENTER);
            fill(18, 140, 72, alphaAcep);
            stroke(95, 255, 165, alphaAcep);
            strokeWeight(1.8);
            rect(570, 212, 104, 38, 6);
            textAlign(CENTER, CENTER);
            textSize(10);
            fill(255, alphaAcep);
            text("ACEPTAR >>", 570, 212);

            stroke(65, 255, 145, alphaAcep);
            strokeWeight(2.0);
            line(326 + telSwipeX + 170, 212 + telSwipeY, 518, 212);
          }
        }

        for (int q = 1; q >= 0; q--) {
          if (telCola[q] >= 0) {
            pushMatrix();
            translate(326 + (q + 1) * 3, 214 + (q + 1) * 2.5);
            rotate(radians((q + 1) * 1.1));
            rectMode(CENTER);
            fill(4, 12, 9, 220);
            stroke(28, 215, 94, 105 - q * 30);
            strokeWeight(1.4);
            rect(0, 0, 336, 114, 7);
            popMatrix();
          }
        }

        if (telFlyActivo) {
          pushMatrix();
          translate(telFlyX, telFlyY);
          rotate(radians(telFlyRot + (telFlyFueAceptar ? 12 : -12)));
          rectMode(CENTER);
          fill(telFlyFueAceptar ? color(12, 55, 32, telFlyAlpha) : color(65, 16, 20, telFlyAlpha));
          stroke(telFlyFueAceptar ? color(85, 255, 165, telFlyAlpha) : color(255, 95, 95, telFlyAlpha));
          strokeWeight(1.5);
          rect(0, 0, 230, 96, 7);
          textAlign(CENTER, CENTER);
          textSize(10);
          fill(245, telFlyAlpha);
          text(telFlyRem, 0, 0);
          popMatrix();
        }

        if (telCartaActiva >= 0) {
          float tilt = constrain(telSwipeX * 0.08, -14.0, 14.0);
          epDibujarCartaTelefono(telCartaActiva, 326 + telSwipeX, 212 + telSwipeY, 340, 118, tilt, px, py);
        }

        rectMode(CORNER);
        fill(6, 14, 11, 244);
        stroke(28, 232, 94, 175);
        strokeWeight(1.3);
        rect(28, 280, 242, 38, 5);
        for (int di = 0; di < 4; di++) {
          float dx = 58 + di * 58;
          rectMode(CENTER);
          fill(18, 22, 14);
          boolean statBajo = (telStats[di] < 25.0);
          stroke(statBajo ? color(255, 75, 85) : color(235, 185, 58));
          strokeWeight(1.1);
          rect(dx, 294, 18, 18, 3);
          PImage dim = obtenerImgStat(di);
          if (dim != null) {
            imageMode(CENTER);
            tint(statBajo ? color(255, 110, 110) : color(255, 220, 115));
            image(imgShaderDaltonismo(dim), dx, 294, 13, 13);
            noTint();
          }
          textAlign(CENTER, TOP);
          textSize(7.5);
          fill(statBajo ? color(255, 115, 115) : color(235, 225, 165));
          text(int(telStats[di]) + "%", dx, 305);
        }

        rectMode(CORNER);
        fill(6, 14, 11, 244);
        stroke((ahora < telBarkFinMs && !telBarkTexto.equals("")) ? color(255, 95, 130, 190) : color(28, 232, 94, 135));
        strokeWeight(1.3);
        rect(276, 280, 344, 38, 5);

        textAlign(CENTER, CENTER);
        textSize(8);
        if (telFeedbackAlpha > 0.10 && !telFeedbackTexto.equals("")) {
          fill(red(telFeedbackColor), green(telFeedbackColor), blue(telFeedbackColor), min(255, telFeedbackAlpha * 280));
          text(telFeedbackTexto, 448, 299);
        } else {
          if (ahora < telBarkFinMs && !telBarkTexto.equals("")) {
            fill(255, 210, 225);
            text(telBarkTexto, 448, 299);
          } else {
            fill(155, 225, 185);
            text("Manten presionado y arrastra la carta para decidir  [A]/[D]", 448, 299);
          }
        }

        if (telBannerFaseActivo) {
          rectMode(CENTER);
          fill(6, 14, 12, 242);
          stroke(telBannerFaseCol);
          strokeWeight(2.2);
          rect(326, 212, 420, 44, 6);
          textAlign(CENTER, CENTER);
          textSize(11);
          fill(telBannerFaseCol);
          text(telBannerFaseTit, 326, 203);
          textSize(8);
          fill(245);
          text(telBannerFaseSub, 326, 221);
        }
      }
    }
  }

  epDibujarEfectosTelefono();

  popMatrix();

  if (imgTelefonoRecortado != null) {
    imageMode(CORNER);
    image(imgShaderDaltonismo(imgTelefonoRecortado), 0, 0, 768, 524);
  }

  popMatrix();

  if (telFaseIntro == 2) {
    textAlign(CENTER, BOTTOM);
    textSize(14);
    fill(195, 215, 230, 200);
    text("[ARRASTRA LA CARTA CON EL MOUSE IZQ / DER]   |   [CLIC EN ESCANEAR / CIFRADO]   |   [TAB / X] SALIR", width * 0.5, height - 18);
  }

  if (telCierreNegroActivo) {
    telCierreNegroAlpha = min(255.0, telCierreNegroAlpha + dtSec * 225.0);
    pushStyle();
    rectMode(CORNER);
    noStroke();
    fill(0, telCierreNegroAlpha);
    rect(0, 0, width, height);
    popStyle();
    if (telCierreNegroAlpha >= 255.0) {
      telCierreNegroActivo = false;
      epFinalFadeEntradaAlpha = 255.0;
      epIniciarCinematicaFinalDesenlace(telFinalPendienteTipo);
    }
  }
}
void epDibujarDatoTelefono(float x, float y, float w, float h, String tit, String val, color c) {
  rectMode(CORNER);
  fill(14, 30, 32);
  stroke(c, 150);
  strokeWeight(1.5);
  rect(x, y, w, h, 6);

  textAlign(CENTER, TOP);
  textSize(12);
  fill(175, 210, 210);
  text(tit, x + w * 0.5, y + 10);

  textAlign(CENTER, CENTER);
  textSize(22);
  fill(c);
  text(val, x + w * 0.5, y + 46);
}

void epIniciarCinematicaFinalDesenlace(int tipo) {
  habModalTelefonoAbierto = false;
  telCartaActiva = -1;
  telArrastrando = false;
  telSwipeX = 0;
  telSwipeY = 0;
  telSwipeTargetX = 0;
  habFinalCinematicaEstado = tipo;
  epFinInicioMs = millis();
  epFinActo = 0;
  epFinGlitchHecho = false;
  epCreditosFinalesActivos = false;
  epCreditosInicioMs = 0;
  epCreditosUltimoMs = 0;
  epCreditosProgresoPx = 0.0;
  epCreditosCerrando = false;
  limpiarMovimientoHabitacion();

  if (tipo == 1) {
    reproducirSFX(sonidoTransferenciaExitosa);
  } else {
    reproducirSFX(sonidoGlitchFuerte);
    triggerGlitchProfesional();
  }
}

void epSaltarCinematicaFinalDesenlace() {
  if (habFinalCinematicaEstado == 0) return;
  epFinActo = 2;
  epFinInicioMs = millis() - 5000;
}

void epDibujarIlustracionFallbackFinal(int estado, float ix, float iy, float iw, float ih, String rutaSlot) {
  rectMode(CENTER);
  noStroke();
  fill(estado == 1 ? color(18, 28, 24) : color(32, 22, 22));
  rect(ix, iy, iw, ih);

  float horY = iy + ih * 0.10;
  fill(estado == 1 ? color(42, 62, 54) : color(52, 42, 38));
  rect(ix, iy - ih * 0.20, iw, ih * 0.60);

  fill(8, 8, 10);
  for (int b = 0; b < 24; b++) {
    float bx = ix - iw * 0.5 + (b + 0.5) * (iw / 24.0);
    float bh = 18 + ((b * 37) % 44);
    rect(bx, horY - bh * 0.5, iw / 22.0, bh);
  }
  fill(12, 10, 10);
  rect(ix, iy + ih * 0.28, iw, ih * 0.44);

  if (estado == 1) {

    noStroke();
    fill(135, 225, 175, 48);
    ellipse(ix, horY - 16, 150, 150);
    int pFr = ((millis() / 280) % 2 == 0) ? 0 : 1;
    if (spritesPersonaje[0][pFr] != null) {
      imageMode(CENTER);
      image(imgShaderDaltonismo(spritesPersonaje[0][pFr]), ix, horY - 8, 92, 92);
    }
  } else {

    if (imgAdminIcon != null) {
      imageMode(CENTER);
      tint(185, 70, 75, 195);
      image(imgShaderDaltonismo(imgAdminIcon), ix, iy - ih * 0.12, 118, 118);
      noTint();
    }
    if (spritesPersonaje[0][0] != null) {
      imageMode(CENTER);
      tint(140, 105, 105, 185);
      image(imgShaderDaltonismo(spritesPersonaje[0][0]), ix, horY + 34, 62, 62);
      noTint();
    }
  }

  if (fuenteRetro != null) textFont(fuenteRetro);
  rectMode(CORNER);
  fill(0, 0, 0, 185);
  noStroke();
  rect(ix - iw * 0.5 + 10, iy + ih * 0.5 - 30, iw - 20, 22, 3);
  textAlign(CENTER, CENTER);
  textSize(10);
  fill(175, 185, 180);
  text("[ESPACIO PARA ILUSTRACION: data/" + rutaSlot + ".png]", ix, iy + ih * 0.5 - 19);
}

void epIniciarCreditosFinales() {
  epCreditosFinalesActivos = true;
  epCreditosInicioMs = millis();
  epCreditosUltimoMs = epCreditosInicioMs;
  epCreditosProgresoPx = 0.0;
  epCreditosCerrando = false;
  if (musicaCredits != null && musicaCredits.frames() > 0) {
    reproducirMusicaUnica(musicaCredits);
  }
}

void epFinalizarCreditosAlMenu() {
  if (epCreditosCerrando) return;
  epCreditosCerrando = true;
  epCreditosFinalesActivos = false;
  habFinalCinematicaEstado = 0;
  habBatallaFinalCompletada = true;
  suprimirMetaChatAlVolverMenu = true;
  guardarPartidaActual();
  if (estadoTransicionMenu == 0) iniciarTransicionMenu();
}

void epAvanzarDesdeUltimoActoFinal() {
  epIniciarCreditosFinales();
}

boolean epMouseSobreBtnSaltarCreditos() {
  float bw = 228;
  float bh = 36;
  float bx = width - bw * 0.5 - 28;
  float by = height - 31;
  return mouseX >= bx - bw * 0.5 && mouseX <= bx + bw * 0.5
      && mouseY >= by - bh * 0.5 && mouseY <= by + bh * 0.5;
}

void epDibujarTarjetaRolCredito(float cx, float cy, float cw, String numTag, String nombre, String rol, String detalle1, String detalle2, color acento) {
  float ch = 172;
  if (cy + ch * 0.5 < -40 || cy - ch * 0.5 > height + 40) return;

  rectMode(CENTER);
  fill(10, 14, 22, 234);
  stroke(red(acento), green(acento), blue(acento), 125);
  strokeWeight(1.5);
  rect(cx, cy, cw, ch, 8);

  noStroke();
  fill(acento);
  rect(cx - cw * 0.5 + 4, cy, 6, ch - 18, 3);

  fill(red(acento), green(acento), blue(acento), 55);
  rect(cx + 6, cy + 4, cw - 60, 1.5);

  float leftX = cx - cw * 0.5 + 28;
  textAlign(LEFT, CENTER);
  if (fuenteRetro != null) textFont(fuenteRetro);
  textSize(12);
  fill(red(acento), green(acento), blue(acento), 220);
  text(numTag, leftX, cy - 62);

  if (fuenteTitulo != null) textFont(fuenteTitulo);
  else {
    if (fuenteRetro != null) textFont(fuenteRetro);
  }
  textSize(30);
  fill(246, 250, 255);
  text(nombre, leftX, cy - 33);

  if (fuenteRetro != null) textFont(fuenteRetro);
  textSize(14);
  fill(acento);
  text(rol, leftX, cy - 7);

  textSize(14);
  fill(208, 218, 232);
  text("- " + detalle1, leftX, cy + 26);
  fill(175, 190, 210);
  text("- " + detalle2, leftX, cy + 52);
}

void epDibujarCreditosFinales(int estado) {
  int ahora = millis();
  int dtMs = constrain(ahora - epCreditosUltimoMs, 0, 80);
  epCreditosUltimoMs = ahora;

  boolean acelerar = keyPressed && (key == ' ' || key == 's' || key == 'S' || (key == CODED && keyCode == DOWN));
  float vel = acelerar ? 315.0 : 112.0;
  epCreditosProgresoPx += vel * (dtMs / 1000.0);

  float gapBloques = 285.0;
  float inicioTop = -125.0;
  float totalPx = abs(inicioTop) + 5.0 * gapBloques + height + 170.0;

  color acentoFinal = (estado == 1) ? color(65, 225, 145) : ((estado == 3) ? color(245, 155, 70) : color(235, 72, 85));
  String etiquetaFinal = (estado == 1) ? "FINAL BUENO // RED LIBERADA"
                       : ((estado == 3) ? "FINAL MALO TEMPRANO // RED SOMETIDA" : "FINAL MALO // DOMINIO DEL ADMIN");
  String subEstado = (estado == 1) ? "EL ADMIN HA COLAPSADO - LIBERTAD DIGITAL"
                   : ((estado == 3) ? "CAIDA TEMPRANA - CONTROL DEL ADMIN" : "SISTEMA SOMETIDO - CONTROL DEL ADMIN");

  pushStyle();
  rectMode(CORNER);
  noStroke();
  fill(5, 7, 12);
  rect(0, 0, width, height);

  PImage imgFondo = (estado == 1) ? imgFinalBueno : ((estado == 3 && imgFinalMaloTemprano != null) ? imgFinalMaloTemprano : imgFinalMaloAdmin);
  if (imgFondo != null && imgFondo.width > 0 && imgFondo.height > 0) {
    float esc = max((float)width / imgFondo.width, (float)height / imgFondo.height);
    imageMode(CENTER);
    tint(255, 38);
    image(imgShaderDaltonismo(imgFondo), width * 0.5, height * 0.5, imgFondo.width * esc, imgFondo.height * esc);
    noTint();
  }

  fill(6, 8, 14, 185);
  rect(0, 0, width, height);

  float cx = width * 0.5;
  float cw = min(width * 0.74, 760);

  stroke(red(acentoFinal), green(acentoFinal), blue(acentoFinal), 28);
  strokeWeight(1);
  line(cx, 0, cx, height);
  noStroke();
  float tSec = ahora * 0.001;
  for (int i = 0; i < 28; i++) {
    float px = ((i * 197 + 73) % max(100, width));
    float py = ((i * 89 + tSec * (34.0 + (i % 4) * 14.0)) % (height + 40)) - 20;
    float r = 1.6 + (i % 3) * 0.9;
    fill(red(acentoFinal), green(acentoFinal), blue(acentoFinal), 45 + (i % 3) * 20);
    ellipse(px, py, r, r);
  }

  float y0 = inicioTop + epCreditosProgresoPx;
  if (y0 > -180 && y0 < height + 180) {
    rectMode(CENTER);
    fill(10, 14, 22, 236);
    stroke(red(acentoFinal), green(acentoFinal), blue(acentoFinal), 150);
    strokeWeight(1.5);
    rect(cx, y0, cw, 195, 8);

    noStroke();
    fill(acentoFinal);
    rect(cx, y0 - 82, 130, 3, 2);

    textAlign(CENTER, CENTER);
    if (fuenteTitulo != null) textFont(fuenteTitulo);
    else {
      if (fuenteRetro != null) textFont(fuenteRetro);
    }
    textSize(56);
    fill(248, 252, 255);
    text("DOLUS", cx, y0 - 40);

    if (fuenteRetro != null) textFont(fuenteRetro);
    textSize(14);
    fill(185, 200, 220);
    text("BLACKLIST STUDIO  //  CREDITOS FINALES", cx, y0 + 10);

    fill(red(acentoFinal), green(acentoFinal), blue(acentoFinal), 36);
    stroke(acentoFinal);
    strokeWeight(1);
    rect(cx, y0 + 50, 360, 28, 4);
    noStroke();
    fill(acentoFinal);
    textSize(13);
    text(etiquetaFinal, cx, y0 + 49);

    textSize(11);
    fill(140, 155, 175);
    text(subEstado, cx, y0 + 78);
  }

  epDibujarTarjetaRolCredito(cx, inicioTop + epCreditosProgresoPx - 1 * gapBloques, cw,
    "01 // DIRECCION Y CORE",
    "Daniel Miranda Gomez",
    "ARQUITECTURA GENERAL - SHADERS Y FLUJO DE JUEGO",
    "Motor principal, maquinas de estado, transiciones y bucle de rondas",
    "Shader de daltonismo, post-procesado CRT y efectos visuales",
    color(65, 225, 145));

  epDibujarTarjetaRolCredito(cx, inicioTop + epCreditosProgresoPx - 2 * gapBloques, cw,
    "02 // AUDIO E INTERFAZ",
    "Necer Perez Martinez",
    "SISTEMA DE AUDIO - TIENDA DOLUS Y UI",
    "Musica adaptativa por fases, SFX dinamicos y control de volumenes",
    "Tienda de plugins, vouchers estrategicos, pausas y HUD de juego",
    color(82, 195, 255));

  epDibujarTarjetaRolCredito(cx, inicioTop + epCreditosProgresoPx - 3 * gapBloques, cw,
    "03 // EPILOGO Y NARRATIVA",
    "Luyheer Duran Florez",
    "HABITACION FINAL - BATALLA EN CELULAR Y GUARDADO",
    "Habitacion explorable, puzles secretos, cinematica VR y dialogos",
    "Duelo de cartas contra EL ADMIN, persistencia JSON y finales",
    color(185, 118, 255));

  epDibujarTarjetaRolCredito(cx, inicioTop + epCreditosProgresoPx - 4 * gapBloques, cw,
    "04 // GAMEPLAY Y JEFES",
    "Gabriel Castro Lopez",
    "MODERACION - QUICK TIME EVENTS Y JEFES ALGORITMICOS",
    "Evaluacion de publicaciones, balanza de estadisticas y eventos",
    "Sistema QTE, patrones de jefes y balanceo de dificultades",
    color(255, 174, 72));

  float y5 = inicioTop + epCreditosProgresoPx - 5 * gapBloques;
  if (y5 > -180 && y5 < height + 180) {
    rectMode(CENTER);
    fill(10, 14, 22, 236);
    stroke(red(acentoFinal), green(acentoFinal), blue(acentoFinal), 140);
    strokeWeight(1.5);
    rect(cx, y5, cw, 190, 8);

    noStroke();
    textAlign(CENTER, CENTER);
    if (fuenteTitulo != null) textFont(fuenteTitulo);
    else {
      if (fuenteRetro != null) textFont(fuenteRetro);
    }
    textSize(34);
    fill(248, 252, 255);
    text("GRACIAS POR JUGAR", cx, y5 - 50);

    if (fuenteRetro != null) textFont(fuenteRetro);
    textSize(14);
    fill(acentoFinal);
    text("BLACKLIST STUDIO  -  UNIVERSIDAD DEL NORTE  -  BARRANQUILLA", cx, y5 - 12);

    textSize(13);
    fill(190, 204, 224);
    text("ALGORITMIA Y PROGRAMACION II  -  NRC 2385", cx, y5 + 16);

    textSize(12);
    fill(145, 160, 180);
    String resumen = (estado == 1 ? "FINAL BUENO" : (estado == 3 ? "FINAL MALO TEMPRANO" : "FINAL MALO"))
      + "   |   CARTAS: " + telCartasResueltas
      + "   |   RACHA MAX: x" + telMejorCombo
      + "   |   TOKENS: " + telTokens;
    text(resumen, cx, y5 + 54);
  }

  rectMode(CORNER);
  noStroke();
  for (int i = 0; i < 8; i++) {
    int alphaTop = int(map(i, 0, 7, 255, 0));
    fill(5, 7, 12, alphaTop);
    rect(0, i * 10, width, 10);
  }
  fill(5, 7, 12, 235);
  rect(0, height - 62, width, 62);
  stroke(50, 62, 82);
  strokeWeight(1);
  line(0, height - 62, width, height - 62);

  float pct = constrain(epCreditosProgresoPx / totalPx, 0.0, 1.0);
  noStroke();
  fill(24, 30, 44);
  rect(28, height - 22, 240, 5, 3);
  fill(acentoFinal);
  rect(28, height - 22, 240 * pct, 5, 3);

  if (fuenteRetro != null) textFont(fuenteRetro);
  textAlign(LEFT, CENTER);
  textSize(12);
  fill(170, 182, 202);
  text("CREDITOS FINALES  |  MANTEN [ESPACIO] O [ABAJO] PARA ACELERAR", 28, height - 41);

  boolean hovBtn = epMouseSobreBtnSaltarCreditos();
  if (hovBtn) cursorSobreElementoClicable = true;
  float bw = 228;
  float bh = 36;
  float bx = width - bw * 0.5 - 28;
  float by = height - 31;
  rectMode(CENTER);
  fill(hovBtn ? color(30, 44, 62) : color(16, 22, 34));
  stroke(hovBtn ? acentoFinal : color(90, 105, 130));
  strokeWeight(1.5);
  rect(bx, by, bw, bh, 5);
  textAlign(CENTER, CENTER);
  textSize(13);
  fill(hovBtn ? color(255) : color(210, 220, 235));
  text("SALTAR AL MENU [ENTER]", bx, by - 1);

  popStyle();

  if (epCreditosProgresoPx >= totalPx) {
    epFinalizarCreditosAlMenu();
  }
}

void epActualizarYDibujarCinematicaFinalDesenlace() {
  int estado = habFinalCinematicaEstado;
  if (estado == 0) return;
  if (epCreditosFinalesActivos) {
    epDibujarCreditosFinales(estado);
    return;
  }

  float cx = width * 0.5;
  float ix = cx;
  float iy = height * 0.31;
  float iw = min(width * 0.66, 740);
  float ih = min(height * 0.46, 360);

  rectMode(CORNER);
  noStroke();
  fill(0);
  rect(0, 0, width, height);

  PImage imgSituacion = null;
  String nombreSlot = "final_malo";
  if (estado == 1) {
    imgSituacion = imgFinalBueno;
    nombreSlot = "final_bueno";
  } else {
    if (estado == 2) {
      imgSituacion = imgFinalMaloAdmin;
      nombreSlot = "final_malo";
    } else {
      imgSituacion = (imgFinalMaloTemprano != null) ? imgFinalMaloTemprano : imgFinalMaloAdmin;
      nombreSlot = (imgFinalMaloTemprano != null) ? "final_malo_temprano" : "final_malo";
    }
  }

  if (imgSituacion != null && imgSituacion.width > 0 && imgSituacion.height > 0) {
    rectMode(CENTER);
    fill(10);
    noStroke();
    rect(ix, iy, iw, ih);
    float esc = min(iw / imgSituacion.width, ih / imgSituacion.height);
    float dw = imgSituacion.width * esc;
    float dh = imgSituacion.height * esc;
    imageMode(CENTER);
    image(imgShaderDaltonismo(imgSituacion), ix, iy, dw, dh);
  } else {
    epDibujarIlustracionFallbackFinal(estado, ix, iy, iw, ih, nombreSlot);
  }

  rectMode(CENTER);
  noFill();
  stroke(58, 58, 58);
  strokeWeight(1.5);
  rect(ix, iy, iw, ih);

  String lineaActual = "";
  if (estado == 1) {
    if (epFinActo == 0) lineaActual = "El ultimo nodo del Admin ha colapsado por completo.";
    else {
      if (epFinActo == 1) lineaActual = "Venciste todo lo malo de internet.";
      else lineaActual = "Tu celular y toda la red vuelven a ser libres.";
    }
  } else {
    if (estado == 2) {
      if (epFinActo == 0) lineaActual = "Tu ultima defensa cayo frente a EL ADMIN.";
      else {
        if (epFinActo == 1) lineaActual = "Te volviste esclavo del Admin.";
        else lineaActual = "La maldad goberno en internet.";
      }
    } else {
      if (epFinActo == 0) lineaActual = "Caiste ante " + epNombreJefeTelefono(telJefeIdx) + " antes del duelo final.";
      else {
        if (epFinActo == 1) lineaActual = "Sin tu filtro, te volviste esclavo del Admin.";
        else lineaActual = "La maldad goberno en internet.";
      }
    }
  }

  if (fuenteRetro != null) textFont(fuenteRetro);
  textAlign(CENTER, CENTER);
  textSize(24);
  fill(242);
  text(lineaActual, cx, height * 0.66, min(width * 0.86, 880), 90);

  if (epFinActo < 2) {

    float sy = height - 86;
    boolean hovSig = (mouseX >= cx - 140 && mouseX <= cx + 140 && mouseY >= sy - 24 && mouseY <= sy + 22);
    textAlign(CENTER, CENTER);
    textSize(22);
    fill(hovSig ? color(255) : color(140));
    text("SIGUIENTE", cx, sy - 4);

    noStroke();
    fill(hovSig ? color(210) : color(92));
    for (float dx = -170; dx <= 170; dx += 8) {
      rect(cx + dx, sy + 18, 3, 2);
    }
  } else {

    textAlign(CENTER, CENTER);
    textSize(12);
    fill(140);
    String txtTipoFin = (estado == 1) ? "FINAL BUENO" : ((estado == 2) ? "FINAL MALO" : "FINAL MALO TEMPRANO");
    String txtRes = txtTipoFin
      + "   |   JEFE ALCANZADO: " + (telJefeIdx + 1) + "/5   |   CARTAS: " + telCartasResueltas
      + "   |   RACHA MAX: x" + telMejorCombo + "   |   TOKENS: " + telTokens;
    text(txtRes, cx, height * 0.77);

    float by = height - 86;
    boolean hov = (mouseX >= cx - 140 && mouseX <= cx + 140 && mouseY >= by - 24 && mouseY <= by + 22);
    if (hov) cursorSobreElementoClicable = true;
    textAlign(CENTER, CENTER);
    textSize(20);
    fill(hov ? color(255) : color(160));
    String lblAccion = "CREDITOS FINALES";
    text(lblAccion, cx, by - 4);

    noStroke();
    fill(hov ? color(220) : color(92));
    for (float dx = -140; dx <= 140; dx += 8) {
      rect(cx + dx, by + 16, 3, 2);
    }
  }

  if (epFinalFadeEntradaAlpha > 0.5) {
    epFinalFadeEntradaAlpha = max(0.0, epFinalFadeEntradaAlpha - 6.5);
    pushStyle();
    rectMode(CORNER);
    noStroke();
    fill(0, epFinalFadeEntradaAlpha);
    rect(0, 0, width, height);
    popStyle();
  }
}

boolean epEscenaHabitacionEsSaltable() {
  if (estadoPantalla == PANTALLA_CINEMATICA_FINAL) return true;
  if (estadoPantalla == PANTALLA_HABITACION) {
    if (habFinalCinematicaEstado != 0 && epFinActo < 2 && !epCreditosFinalesActivos) return true;
    if (habDialogoInicialActivo) return true;
    if (habCelebracionCelularActiva) return true;
  }
  return false;
}

void epSaltarEscenaHabitacion() {
  if (estadoPantalla == PANTALLA_CINEMATICA_FINAL) {
    if (!epCinSalidaDisparada) {
      epCinSalidaDisparada = true;
      iniciarHabitacionFinal();
    }
  } else {
    if (estadoPantalla == PANTALLA_HABITACION) {
      if (habFinalCinematicaEstado != 0) {
        epSaltarCinematicaFinalDesenlace();
      } else {
        if (habDialogoInicialActivo) {
          epCerrarDialogoIntroHabitacion();
        } else {
          if (habCelebracionCelularActiva) {
            epAbrirTelefonoGameplay();
          }
        }
      }
    }
  }
}

void mousePressedEpilogo() {
  if (estadoPantalla == PANTALLA_GLITCH_ESCAPE) {
    if (millis() - epGlitchEscapeInicioMs > 1000 && !epGlitchEscapeSalidaIniciada) {
      reproducirTap();
      epGlitchEscapeSalidaIniciada = true;
    }
    return;
  }

  if (estadoPantalla == PANTALLA_CINEMATICA_FINAL) {
    if (millis() - epCinInicioMs > 650 && !epCinSalidaDisparada) {
      reproducirTap();
      iniciarHabitacionFinal();
    }
    return;
  }

  if (estadoPantalla != PANTALLA_HABITACION) return;
  if (juegoPausado || estadoPausa != 0) return;

  if (habDialogoInicialActivo) {
    if (millis() - habDialogoIntroInicioMs > 280) {
      epCerrarDialogoIntroHabitacion();
    }
    return;
  }

  if (habCelebracionCelularActiva) {
    if (millis() - habCelebracionInicioMs > 650) {
      epAbrirTelefonoGameplay();
    }
    return;
  }

  if (habFinalCinematicaEstado != 0) {
    if (epCreditosFinalesActivos) {
      if (millis() - epCreditosInicioMs > 350 && epMouseSobreBtnSaltarCreditos()) {
        reproducirClickUI(true);
        epFinalizarCreditosAlMenu();
      }
      return;
    }
    float cx = width * 0.5;
    if (epFinActo < 2) {
      float sy = height - 86;
      if ((mouseX >= cx - 160 && mouseX <= cx + 160 && mouseY >= sy - 30 && mouseY <= sy + 28)
          || millis() - epFinInicioMs > 300) {
        reproducirTap();
        epFinActo++;
      }
      return;
    }
    float by = height - 86;
    if (mouseY >= by - 26 && mouseY <= by + 26) {
      if (mouseX >= cx - 140 && mouseX <= cx + 140) {
        reproducirClickUI(true);
        epAvanzarDesdeUltimoActoFinal();
        return;
      }
    }
    return;
  }

  if (habModalTelefonoAbierto) {
    float[] pm = new float[2];
    epMouseAPantallaTelefono(pm);
    float px = pm[0];
    float py = pm[1];

    if (telFaseIntro != 3 && !telCierreNegroActivo && epHoverBotonTelefono(px, py, 594, 32, 36, 24)) {
      reproducirTap();
      habModalTelefonoAbierto = false;
      telArrastrando = false;
      telSwipeX = 0;
      telSwipeY = 0;
      telSwipeTargetX = 0;
      return;
    }

    if (telFaseIntro == 3) {
      epAvanzarConversacionFinalTelefono();
      return;
    } else {
      if (telFaseIntro == 0) {
        reproducirTap();
        telAdminDlgIdx++;
        telAdminDlgInicioMs = millis();
        telAdminDlgUltimoSonidoMs = 0;
        if (telAdminDlgIdx >= EP_TEL_DLG_MAX) {
          reproducirSFX(stingerTransicion);
          telFaseIntro = 1;
          telAvisoInicioMs = millis();
          telAvisoHoldProgreso = 0.0;
          telAvisoConfirmado = false;
          telAvisoFrameSalida = 0;
        }
        return;
      } else {
        if (telFaseIntro == 1) {
          reproducirSFX(stingerTransicion);
          telDestelloAlpha = 220.0;
          telDestelloCol = color(255, 45, 65);
          telFaseIntro = 2;
          epIniciarBatallaTelefono();
          telBatallaIniciada = true;
          return;
        } else {
          if (telFaseIntro == 2 && telEstadoFin == 0) {
            if ((telJefeIdx == 2 || telJefeIdx == 4) && telCartaActiva >= 0 && !msgVerificado[telCartaActiva]
                && !(msgCategoriaEspecial[telCartaActiva] == 2 && telCardClicksEnc < 3)) {
              if (epHoverBotonTelefono(px, py, 326 + telSwipeX + 4, 212 + telSwipeY + 29, 155, 16)) {
                epEscanearCartaActivaTelefono();
                return;
              }
            }
            if (telCartaActiva >= 0 && epHoverBotonTelefono(px, py, 156 + telSwipeX, 152 + telSwipeY, 340, 120)) {
              telArrastrando = true;
              telDragStartPX = px;
              telDragStartPY = py;
              telSwipeX = 0;
              telSwipeY = 0;
              telSwipeTargetX = 0;
              return;
            }
          }
        }
      }
    }
    return;
  }

  if (habModalPuzle1Abierto) {
    float modW = min(width * 0.88, 760);
    float modH = min(height * 0.88, 600);
    float mx = (width - modW) * 0.5;
    float my = (height - modH) * 0.5;

    if (evaluarHover(mx + modW - 42, my + 38, 40, 40)) {
      reproducirTap();
      habModalPuzle1Abierto = false;
      return;
    }

    float[] g = new float[4];
    epObtenerGeometriaPuzle1(modW, modH, my, g);
    float tamCelda = g[0];
    float gx = g[2];
    float gy = g[3];

    for (int i = 0; i < EP_PUZ1_CELDAS; i++) {
      int r = i / EP_PUZ1_N;
      int c = i % EP_PUZ1_N;
      float cx = gx + c * tamCelda + tamCelda * 0.5;
      float cy = gy + r * tamCelda + tamCelda * 0.5;
      if (evaluarHover(cx, cy, tamCelda - 4, tamCelda - 4)) {
        epRotarCeldaPuzle1(i);
        return;
      }
    }

    if (!puz1Completado && evaluarHover(width * 0.5, my + modH - 40, 240, 42)) {
      reproducirTap();
      epRevolverPuzle1();
      return;
    }
    if (puz1Completado && evaluarHover(width * 0.5, my + modH - 36, 300, 42)) {
      reproducirTap();
      habModalPuzle1Abierto = false;
      return;
    }
    return;
  }

  if (habModalPuzle2Abierto) {
    float modW = min(width * 0.90, 820);
    float modH = min(height * 0.90, 620);
    float mx = (width - modW) * 0.5;
    float my = (height - modH) * 0.5;

    if (evaluarHover(mx + modW - 42, my + 38, 40, 40)) {
      reproducirTap();
      habModalPuzle2Abierto = false;
      return;
    }

    float zonaIzqX = mx + 44;
    float zonaIzqW = modW * 0.50;
    float slotSep = zonaIzqW / 4.0;
    float dialBaseY = my + 178;
    float centroIzq = zonaIzqX + zonaIzqW * 0.5;

    for (int s = 0; s < EP_PUZ2_DIGITOS; s++) {
      float sx = zonaIzqX + s * slotSep + slotSep * 0.5;
      if (evaluarHover(sx, dialBaseY - 62, 56, 36)) {
        epCambiarDigitoPuzle2(s, 1);
        return;
      }
      if (evaluarHover(sx, dialBaseY + 62, 56, 36)) {
        epCambiarDigitoPuzle2(s, -1);
        return;
      }
      if (evaluarHover(sx, dialBaseY, 64, 72)) {
        puz2SlotActivo = s;
        reproducirTap();
        return;
      }
    }

    if (!puz2Completado && evaluarHover(centroIzq, my + 382, 310, 48)) {
      epProbarIntentoPuzle2();
      return;
    }
    if (puz2Completado && evaluarHover(centroIzq, my + 382, 280, 48)) {
      reproducirTap();
      habModalPuzle2Abierto = false;
      epActivarCelebracionCelular();
      return;
    }
    return;
  }

  if (habEstadoPuzle >= 2 && evaluarHover(width - 135, height - 42, 220, 44)) {
    reproducirTap();
    limpiarMovimientoHabitacion();
    epAbrirTelefonoGameplay();
    return;
  }
  if (modoDesarrollador && habEstadoPuzle < 2 && evaluarHover(width - 145, height - 42, 240, 44)) {
    reproducirTap();
    devResolverPuzlesPrologo();
    return;
  }

  float rmx = screenToRoomX(mouseX);
  float rmy = screenToRoomY(mouseY);
  for (int i = 0; i < EP_NUM_HOTSPOTS; i++) {
    boolean sobreObjeto = (rmx >= habObjBoxMinX[i] - 18 && rmx <= habObjBoxMaxX[i] + 18
                        && rmy >= habObjBoxMinY[i] - 18 && rmy <= habObjBoxMaxY[i] + 18)
                       || (dist(rmx, rmy, habHotX[i], habHotY[i]) <= habHotRad[i]);
    if (sobreObjeto) {
      if (habHotspotCercano == i) {
        epInteractuarHotspot(i);
      } else {
        reproducirTap();
        String nombreObj = (i == 0) ? "el PC Gamer" : "la Caja Metalica Sur";
        epMostrarMensajeHabitacion("Acercate a " + nombreObj + " para interactuar.", color(185, 215, 250), 2600);
      }
      return;
    }
  }
}

void mouseDraggedEpilogo() {
  if (estadoPantalla != PANTALLA_HABITACION) return;
  if (juegoPausado || estadoPausa != 0) return;
  if (habModalTelefonoAbierto && telEstadoFin == 0 && telArrastrando) {
    float[] pm = new float[2];
    epMouseAPantallaTelefono(pm);
    telSwipeX = constrain(pm[0] - telDragStartPX, -175, 175);
    telSwipeY = constrain(pm[1] - telDragStartPY, -30, 30);
    telSwipeTargetX = telSwipeX;
  }
}

void mouseReleasedEpilogo() {
  if (!telArrastrando) return;
  float[] pm = new float[2];
  epMouseAPantallaTelefono(pm);
  if (telSwipeX <= -42.0 || pm[0] <= 226) {
    epResolverCartaTelefono(false);
  } else {
    if (telSwipeX >= 42.0 || pm[0] >= 556) {
      epResolverCartaTelefono(true);
    } else {
      telArrastrando = false;
      telSwipeTargetX = 0;
      telSwipeY = 0;
      if (telCartaActiva >= 0 && msgCategoriaEspecial[telCartaActiva] == 2 && telCardClicksEnc < 3 && abs(telSwipeX) < 18) {
        telCardClicksEnc++;
        reproducirTap();
        if (telCardClicksEnc >= 3) {
          reproducirSFX(sonidoHerramientaUso);
          telFeedbackTexto = "MENSAJE DESCIFRADO! AHORA ARRASTRA!";
          telFeedbackColor = color(220, 155, 255);
          telFeedbackAlpha = 1.0;
        }
      }
    }
  }
}

void keyPressedEpilogo() {
  if (estadoPantalla == PANTALLA_GLITCH_ESCAPE) {
    if ((key == ' ' || key == ENTER || key == RETURN) && millis() - epGlitchEscapeInicioMs > 1000 && !epGlitchEscapeSalidaIniciada) {
      reproducirTap();
      epGlitchEscapeSalidaIniciada = true;
    }
    return;
  }

  if (estadoPantalla == PANTALLA_CINEMATICA_FINAL) {
    if ((key == ' ' || key == ENTER || key == RETURN) && millis() - epCinInicioMs > 650 && !epCinSalidaDisparada) {
      reproducirTap();
      iniciarHabitacionFinal();
    }
    return;
  }

  if (estadoPantalla != PANTALLA_HABITACION) return;
  if (juegoPausado || estadoPausa != 0) return;

  if (habDialogoInicialActivo) {
    if ((key == ' ' || key == ENTER || key == RETURN || key == 'e' || key == 'E')
        && millis() - habDialogoIntroInicioMs > 280) {
      epCerrarDialogoIntroHabitacion();
    }
    return;
  }

  if (habCelebracionCelularActiva) {
    if ((key == ' ' || key == ENTER || key == RETURN)
        && millis() - habCelebracionInicioMs > 650) {
      epAbrirTelefonoGameplay();
    }
    return;
  }

  if (habFinalCinematicaEstado != 0) {
    if (epCreditosFinalesActivos) {
      if ((key == ENTER || key == RETURN) && millis() - epCreditosInicioMs > 400) {
        reproducirClickUI(true);
        epFinalizarCreditosAlMenu();
      }
      return;
    }
    if (key == ' ' || key == ENTER || key == RETURN) {
      if (epFinActo < 2 && millis() - epFinInicioMs > 300) {
        reproducirTap();
        epFinActo++;
      } else {
        if (epFinActo >= 2) {
          reproducirClickUI(true);
          epAvanzarDesdeUltimoActoFinal();
        }
      }
    }
    return;
  }

  if (key == TAB && habEstadoPuzle >= 2 && !habModalPuzle1Abierto && !habModalPuzle2Abierto) {
    if (habBatallaFinalCompletada || (habModalTelefonoAbierto && (telFaseIntro == 3 || telCierreNegroActivo))) return;
    reproducirTap();
    limpiarMovimientoHabitacion();
    if (habModalTelefonoAbierto) {
      habModalTelefonoAbierto = false;
      telArrastrando = false;
      telSwipeX = 0;
      telSwipeY = 0;
      telSwipeTargetX = 0;
    } else {
      epAbrirTelefonoGameplay();
    }
    return;
  }

  if (habModalPuzle1Abierto) {
    if (keyCode == LEFT || key == 'a' || key == 'A') puz1CursorIdx = max(0, puz1CursorIdx - 1);
    else {
      if (keyCode == RIGHT || key == 'd' || key == 'D') puz1CursorIdx = min(15, puz1CursorIdx + 1);
      else {
        if (keyCode == UP || key == 'w' || key == 'W') puz1CursorIdx = max(0, puz1CursorIdx - 4);
        else {
          if (keyCode == DOWN || key == 's' || key == 'S') puz1CursorIdx = min(15, puz1CursorIdx + 4);
          else {
            if (key == ' ' || key == 'e' || key == 'E' || key == ENTER || key == RETURN) {
              if (puz1Completado) {
                reproducirTap();
                habModalPuzle1Abierto = false;
              } else {
                epRotarCeldaPuzle1(puz1CursorIdx);
              }
            } else {
              if ((key == 'r' || key == 'R') && !puz1Completado) {
                reproducirTap();
                epRevolverPuzle1();
              }
            }
          }
        }
      }
    }
    return;
  }

  if (habModalPuzle2Abierto) {
    if (key >= '1' && key <= '6' && !puz2Completado) {
      puz2Entrada[puz2SlotActivo] = key - '0';
      puz2SlotActivo = min(3, puz2SlotActivo + 1);
      reproducirTap();
    } else {
      if (keyCode == LEFT || key == 'a' || key == 'A') {
        puz2SlotActivo = max(0, puz2SlotActivo - 1);
      } else {
        if (keyCode == RIGHT || key == 'd' || key == 'D') {
          puz2SlotActivo = min(3, puz2SlotActivo + 1);
        } else {
          if (keyCode == UP || key == 'w' || key == 'W') {
            epCambiarDigitoPuzle2(puz2SlotActivo, 1);
          } else {
            if (keyCode == DOWN || key == 's' || key == 'S') {
              epCambiarDigitoPuzle2(puz2SlotActivo, -1);
            } else {
              if (key == BACKSPACE) {
                puz2SlotActivo = max(0, puz2SlotActivo - 1);
              } else {
                if (key == ENTER || key == RETURN || key == ' ') {
                  if (puz2Completado) {
                    reproducirTap();
                    habModalPuzle2Abierto = false;
                    epActivarCelebracionCelular();
                  } else {
                    epProbarIntentoPuzle2();
                  }
                }
              }
            }
          }
        }
      }
    }
    return;
  }

  if (habModalTelefonoAbierto) {
    if (telFaseIntro == 3) {
      if (!telCierreNegroActivo && (key == ' ' || key == ENTER || key == RETURN)) {
        epAvanzarConversacionFinalTelefono();
      }
      return;
    } else {
      if (telFaseIntro == 0) {
        if (key == ' ' || key == ENTER || key == RETURN) {
          reproducirTap();
          telAdminDlgIdx++;
          telAdminDlgInicioMs = millis();
          telAdminDlgUltimoSonidoMs = 0;
          if (telAdminDlgIdx >= EP_TEL_DLG_MAX) {
            reproducirSFX(stingerTransicion);
            telFaseIntro = 1;
            telAvisoInicioMs = millis();
            telAvisoHoldProgreso = 0.0;
            telAvisoConfirmado = false;
          }
          return;
        } else {
          if (key == ESC || keyCode == SHIFT) {
            reproducirSFX(stingerTransicion);
            telFaseIntro = 1;
            telAvisoInicioMs = millis();
            telAvisoHoldProgreso = 0.0;
            telAvisoConfirmado = false;
            return;
          }
        }
      } else {
        if (telFaseIntro == 1) {
          if (key == ' ' || key == ENTER || key == RETURN) {
            reproducirSFX(stingerTransicion);
            telDestelloAlpha = 220.0;
            telDestelloCol = color(255, 45, 65);
            telFaseIntro = 2;
            epIniciarBatallaTelefono();
            telBatallaIniciada = true;
            return;
          }
        } else {
          if (telFaseIntro == 2 && telEstadoFin == 0) {
            if (key == ' ' && (telJefeIdx == 2 || telJefeIdx == 4)) {
              epEscanearCartaActivaTelefono();
            } else {
              if ((key == 'e' || key == 'E' || key == 'w' || key == 'W' || keyCode == UP)
                  && telCartaActiva >= 0 && msgCategoriaEspecial[telCartaActiva] == 2 && telCardClicksEnc < 3) {
                telCardClicksEnc++;
                reproducirTap();
                if (telCardClicksEnc >= 3) {
                  reproducirSFX(sonidoHerramientaUso);
                  telFeedbackTexto = "MENSAJE DESCIFRADO! AHORA DECIDE!";
                  telFeedbackColor = color(220, 155, 255);
                  telFeedbackAlpha = 1.0;
                }
              } else {
                if (keyCode == LEFT || key == 'a' || key == 'A') {
                  epResolverCartaTelefono(false);
                } else {
                  if (keyCode == RIGHT || key == 'd' || key == 'D') {
                    epResolverCartaTelefono(true);
                  }
                }
              }
            }
          }
        }
      }
    }
    return;
  }

  if (keyCode == UP || key == 'w' || key == 'W') movArriba = true;
  if (keyCode == DOWN || key == 's' || key == 'S') movAbajo = true;
  if (keyCode == LEFT || key == 'a' || key == 'A') movIzquierda = true;
  if (keyCode == RIGHT || key == 'd' || key == 'D') movDerecha = true;

  if (key == 'e' || key == 'E' || key == ' ' || key == ENTER || key == RETURN) {
    if (habHotspotCercano != -1) {
      epInteractuarHotspot(habHotspotCercano);
    }
  }
}

void keyReleasedEpilogo() {
  if (keyCode == UP || key == 'w' || key == 'W') movArriba = false;
  if (keyCode == DOWN || key == 's' || key == 'S') movAbajo = false;
  if (keyCode == LEFT || key == 'a' || key == 'A') movIzquierda = false;
  if (keyCode == RIGHT || key == 'd' || key == 'D') movDerecha = false;
}
