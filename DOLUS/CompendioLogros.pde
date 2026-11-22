
final int PANTALLA_COMPENDIO = 12;

boolean compendioInicializado = false;
boolean animandoCompendio = false;
float progresoCompendio = 0.0;
boolean abiertoCompendioDesdePausa = false;
int pestanaCompendio = 0;
int indiceCompendioHover = -1;
int indiceCompendioSeleccionado = 0;

final int TOTAL_LOGROS = 10;
boolean[] logroDesbloqueado = new boolean[10];
int[] logroProgreso = new int[10];
int[] logroMeta = new int[10];
String[] logroNombres = new String[10];
String[] logroDescripciones = new String[10];
String[] logroRecompensas = new String[10];

boolean[] pluginDescubierto = new boolean[20];
boolean[] sinergiaDescubierta = new boolean[6];
boolean[] jefeDescubierto = new boolean[5];

int[] colaToastsLogros = new int[16];
int numColaToastsLogros = 0;
int logroToastActual = -1;
int timerToastLogro = 0;
final int DURACION_TOAST_LOGRO = 210;

void inicializarCompendioYLogros() {
  if (imgLogroIcono == null) {
    imgLogroIcono = cargarImagenSegura("achievements_icon.png");
  }
  if (compendioInicializado) return;
  compendioInicializado = true;

  logroNombres[0] = "GUARDIAN DEL FEED";
  logroDescripciones[0] = "Rechaza con exito 15 amenazas de Trolls o Malware en tu feed.";
  logroRecompensas[0] = "RANGO: MODERADOR SENIOR";
  logroMeta[0] = 15;

  logroNombres[1] = "RACHA DE FUEGO";
  logroDescripciones[1] = "Alcanza un Combo impecable de x25 o superior en una partida.";
  logroRecompensas[1] = "RANGO: SINAPSIS IGNEA";
  logroMeta[1] = 25;

  logroNombres[2] = "CAZADOR DE VIRUS";
  logroDescripciones[2] = "Supera con éxito 5 alertas QTE de Malware o Hack de Precisión.";
  logroRecompensas[2] = "RANGO: CORTAFUEGOS HUMANO";
  logroMeta[2] = 5;

  logroNombres[3] = "MANOS LIMPIAS";
  logroDescripciones[3] = "Rechaza 5 Cartas de Soborno Dorado sin ceder a la corrupción.";
  logroRecompensas[3] = "RANGO: INCORRUPTIBLE";
  logroMeta[3] = 5;

  logroNombres[4] = "PACTO CORRUPTO";
  logroDescripciones[4] = "Acepta 5 Sobornos Dorados corporativos y sobrevive al castigo.";
  logroRecompensas[4] = "RANGO: MERCENARIO DE DATOS";
  logroMeta[4] = 5;

  logroNombres[5] = "ARTIFICIERO";
  logroDescripciones[5] = "Desactiva con éxito 5 Cartas Bomba antes de que detonen.";
  logroRecompensas[5] = "RANGO: NERVIOS DE ACERO";
  logroMeta[5] = 5;

  logroNombres[6] = "CRIPTOANALISTA";
  logroDescripciones[6] = "Descifra al 100% y modera con éxito 5 Cartas Encriptadas.";
  logroRecompensas[6] = "RANGO: DECODIFICADOR";
  logroMeta[6] = 5;

  logroNombres[7] = "ARQUITECTO DE RED";
  logroDescripciones[7] = "Descubre 2 Sinergias distintas combinando Plugins compatibles.";
  logroRecompensas[7] = "RANGO: INGENIERO NEXUS";
  logroMeta[7] = 2;

  logroNombres[8] = "MAGNATE DIGITAL";
  logroDescripciones[8] = "Acumula 100 o más Tokens simultáneos durante una partida.";
  logroRecompensas[8] = "RANGO: BALLENA CRIPTO";
  logroMeta[8] = 100;

  logroNombres[9] = "CAÍDA DEL SISTEMA";
  logroDescripciones[9] = "Sobrevive y derrota a 3 Jefes de la Red Nexus en combate.";
  logroRecompensas[9] = "RANGO: EJECUTOR ROOT";
  logroMeta[9] = 3;

  for (int i = 0; i < TOTAL_LOGROS; i++) {
    logroDesbloqueado[i] = false;
    logroProgreso[i] = 0;
  }
  for (int i = 0; i < 20; i++) {
    pluginDescubierto[i] = (i == 0);
  }
  for (int i = 0; i < 6; i++) {
    sinergiaDescubierta[i] = false;
  }
  for (int i = 0; i < 5; i++) {
    jefeDescubierto[i] = false;
  }
}

void desbloquearLogro(int id) {
  inicializarCompendioYLogros();
  if (id < 0 || id >= TOTAL_LOGROS) return;
  if (logroDesbloqueado[id]) return;

  logroDesbloqueado[id] = true;
  logroProgreso[id] = logroMeta[id];
  if (numColaToastsLogros < 16) {
    colaToastsLogros[numColaToastsLogros++] = id;
  }
}

void registrarProgresoLogro(int id, int cantidad) {
  inicializarCompendioYLogros();
  if (id < 0 || id >= TOTAL_LOGROS) return;
  if (logroDesbloqueado[id] || cantidad <= 0) return;

  logroProgreso[id] = min(logroMeta[id], logroProgreso[id] + cantidad);
  if (logroProgreso[id] >= logroMeta[id]) {
    desbloquearLogro(id);
  }
}

void fijarProgresoMaximoLogro(int id, int valorActual) {
  inicializarCompendioYLogros();
  if (id < 0 || id >= TOTAL_LOGROS) return;
  if (logroDesbloqueado[id]) return;

  int nuevoValor = constrain(valorActual, 0, logroMeta[id]);
  if (nuevoValor > logroProgreso[id]) {
    logroProgreso[id] = nuevoValor;
  }
  if (logroProgreso[id] >= logroMeta[id]) {
    desbloquearLogro(id);
  }
}

void registrarPluginDescubierto(int idPlugin) {
  inicializarCompendioYLogros();
  if (idPlugin >= 0) {
    int idxMap = (idPlugin < 16) ? idPlugin : (1 + (idPlugin % 15));
    pluginDescubierto[idxMap] = true;
  }
}

void registrarSinergiaDescubierta(int idSinergia) {
  inicializarCompendioYLogros();
  if (idSinergia >= 0 && idSinergia < 6) {
    sinergiaDescubierta[idSinergia] = true;
  }
  int totalSinergias = 0;
  for (int i = 0; i < 6; i++) {
    if (sinergiaDescubierta[i]) totalSinergias++;
  }
  fijarProgresoMaximoLogro(7, totalSinergias);
}

void registrarJefeDescubierto(int idJefe) {
  inicializarCompendioYLogros();
  if (idJefe >= 1 && idJefe <= 4) {
    jefeDescubierto[idJefe] = true;
  }
}

void desbloquearTodoCompendioDebug() {
  inicializarCompendioYLogros();
  for (int i = 0; i < TOTAL_LOGROS; i++) {
    if (!logroDesbloqueado[i]) {
      desbloquearLogro(i);
      break;
    }
  }
  for (int i = 0; i < 16; i++) pluginDescubierto[i] = true;
  for (int i = 0; i < 6; i++) sinergiaDescubierta[i] = true;
  for (int i = 1; i <= 4; i++) jefeDescubierto[i] = true;
}

int contarLogrosDesbloqueados() {
  inicializarCompendioYLogros();
  int c = 0;
  for (int i = 0; i < TOTAL_LOGROS; i++) {
    if (logroDesbloqueado[i]) c++;
  }
  return c;
}

int contarPluginsDescubiertos() {
  inicializarCompendioYLogros();
  int c = 0;
  int maxP = min(16, numCatalogoPlugins);
  if (maxP == 0) maxP = 16;
  for (int i = 0; i < maxP; i++) {
    if (pluginDescubierto[i]) c++;
  }
  return c;
}

void actualizarYDibujarToastLogro() {
  if (logroToastActual == -1 && numColaToastsLogros > 0) {
    logroToastActual = colaToastsLogros[0];
    for (int i = 0; i < numColaToastsLogros - 1; i++) {
      colaToastsLogros[i] = colaToastsLogros[i + 1];
    }
    numColaToastsLogros--;
    timerToastLogro = DURACION_TOAST_LOGRO;
    dispararRayoEntrePuntos(width - 26, 62, width - 436, 62, color(255, 215, 80), 74.0, 4);
    reproducirLogro();
  }
  if (logroToastActual == -1) return;

  timerToastLogro--;
  if (timerToastLogro <= 0) {
    logroToastActual = -1;
    return;
  }

  float tEntrada = constrain((DURACION_TOAST_LOGRO - timerToastLogro) / 22.0, 0, 1);
  float tSalida = constrain(timerToastLogro / 22.0, 0, 1);
  float factor = (timerToastLogro > DURACION_TOAST_LOGRO - 22) ? easeOutBack(tEntrada) : easeInCubic(tSalida);

  float tw = 410;
  float th = 84;
  float tx = width - tw * 0.5 - 26;
  float ty = lerp(-60, 62, factor);

  pushStyle();
  pushMatrix();
  translate(int(tx), int(ty));
  rectMode(CENTER);

  color colOro = color(255, 215, 80);
  color colG = colorTema();

  noStroke();
  fill(0, 210);
  rect(6, 8, tw, th, 12);

  fill(8, 20, 14, 248);
  stroke(colOro);
  strokeWeight(3);
  rect(0, 0, tw, th, 12);

  fill(colOro, 40 + sin(frameCount * 0.2) * 20);
  stroke(colOro);
  strokeWeight(2);
  rect(-tw * 0.5 + 42, 0, 52, 52, 10);
  if (imgLogroIcono != null) {
    imageMode(CENTER);
    image(imgShaderDaltonismo(imgLogroIcono), -tw * 0.5 + 42, 0, 40, 40);
  } else {
    fill(colOro);
    textAlign(CENTER, CENTER);
    if (fuenteRetro != null) textFont(fuenteRetro);
    textSize(24);
    text("*", -tw * 0.5 + 42, -2);
  }

  int framesAnim = DURACION_TOAST_LOGRO - timerToastLogro;
  textSize(12);
  dibujarTextoCascada("LOGRO DESBLOQUEADO!", -tw * 0.5 + 80, -20, framesAnim, colOro, LEFT, 1);

  textSize(17);
  dibujarTextoCascada(logroNombres[logroToastActual], -tw * 0.5 + 80, 2, max(0, framesAnim - 6), color(255), LEFT, 2);

  fill(190, 225, 205);
  textAlign(LEFT, CENTER);
  textSize(11);
  text(logroRecompensas[logroToastActual], -tw * 0.5 + 80, 24);

  popMatrix();
  popStyle();
}

void dibujarVentanaCompendioSuperpuesta() {
  inicializarCompendioYLogros();
  if (numCatalogoPlugins == 0) {
    inicializarCatalogoPlugins();
  }

  if (animandoCompendio) {
    progresoCompendio += 0.04;
    if (progresoCompendio >= 1.0) {
      progresoCompendio = 1.0;
      animandoCompendio = false;
    }
  }

  pushStyle();
  fill(0, 195 * progresoCompendio);
  rectMode(CORNER);
  noStroke();
  rect(0, 0, width, height);

  float anchoPanel = 1140;
  float altoPanel = 700;
  float grosorBorde = 14;

  pushMatrix();
  translate(width / 2, height / 2);

  dibujarInteriorCajaDisuelta(anchoPanel, altoPanel, progresoCompendio);
  dibujarMarcoProcedural(anchoPanel, altoPanel, grosorBorde, progresoCompendio);

  if (fuenteRetro != null) textFont(fuenteRetro);
  color colG = colorTema();
  color colOro = color(255, 215, 80);

  textAlign(CENTER, CENTER);
  textSize(30);
  fillConAlpha(colG, 255 * progresoCompendio);
  text("COMPENDIO Y LOGROS NEXUS", 0, -altoPanel / 2 + 40);

  dibujarBotonCerrar(anchoPanel, altoPanel, progresoCompendio);

  if (progresoCompendio > 0.25) {

    String[] nombresPestanas = {
      "LOGROS (" + contarLogrosDesbloqueados() + "/" + TOTAL_LOGROS + ")",
      "PLUGINS (" + contarPluginsDescubiertos() + "/16)",
      "SINERGIAS Y JEFES"
    };
    float tabW = 310;
    float tabH = 40;
    float tabY = -altoPanel / 2 + 92;

    for (int t = 0; t < 3; t++) {
      float tabX = (t - 1) * (tabW + 24);
      boolean hovTab = evaluarHover(width / 2 + tabX, height / 2 + tabY, tabW, tabH);
      boolean activa = (pestanaCompendio == t);

      pushMatrix();
      translate(tabX, tabY);
      if (hovTab) scale(1.04);
      rectMode(CENTER);
      stroke(activa ? colOro : (hovTab ? color(255) : colG), 255 * progresoCompendio);
      strokeWeight(activa ? 3 : 1.8);
      fill(activa ? color(22, 55, 38, 245 * progresoCompendio) : (hovTab ? color(16, 40, 28, 230 * progresoCompendio) : color(8, 20, 14, 220 * progresoCompendio)));
      rect(0, 0, tabW, tabH, 8);

      fill(activa ? colOro : color(230), 255 * progresoCompendio);
      textSize(16);
      textAlign(CENTER, CENTER);
      text(nombresPestanas[t], 0, -2);
      popMatrix();
    }

    indiceCompendioHover = -1;

    if (pestanaCompendio == 0) {
      dibujarPestanaLogros(anchoPanel, altoPanel, colG, colOro);
    } else {
      if (pestanaCompendio == 1) {
        dibujarPestanaPluginsCompendio(anchoPanel, altoPanel, colG, colOro);
      } else {
        dibujarPestanaSinergiasYJefes(anchoPanel, altoPanel, colG, colOro);
      }
    }
  }

  popMatrix();
  popStyle();
}

void dibujarPestanaLogros(float anchoPanel, float altoPanel, color colG, color colOro) {
  int cols = 2;
  int filas = 5;
  float cardW = 495;
  float cardH = 74;
  float espX = 28;
  float espY = 12;
  float startY = -altoPanel / 2 + 168;

  for (int i = 0; i < TOTAL_LOGROS; i++) {
    int col = i % cols;
    int fila = i / cols;
    float cx = (col == 0 ? -1 : 1) * (cardW * 0.5 + espX * 0.5);
    float cy = startY + fila * (cardH + espY);

    boolean desb = logroDesbloqueado[i];
    boolean hov = evaluarHover(width / 2 + cx, height / 2 + cy, cardW, cardH);
    if (hov) {
      indiceCompendioHover = i;
      indiceCompendioSeleccionado = i;
    }
    boolean sel = (indiceCompendioSeleccionado == i);

    pushMatrix();
    translate(cx, cy);
    if (hov) scale(1.02);
    rectMode(CENTER);

    stroke(desb ? colOro : (sel ? colG : color(60, 90, 75)), 240 * progresoCompendio);
    strokeWeight(sel || hov ? 2.5 : 1.5);
    fill(desb ? color(18, 42, 28, 235 * progresoCompendio) : color(8, 16, 12, 215 * progresoCompendio));
    rect(0, 0, cardW, cardH, 10);

    fill(desb ? colOro : color(40, 60, 50), 230 * progresoCompendio);
    noStroke();
    rect(-cardW * 0.5 + 36, 0, 44, 44, 8);
    if (desb && imgLogroIcono != null) {
      imageMode(CENTER);
      tint(255, 255 * progresoCompendio);
      image(imgShaderDaltonismo(imgLogroIcono), -cardW * 0.5 + 36, 0, 34, 34);
      noTint();
    } else {
      fill(desb ? color(10, 20, 14) : color(130), 255 * progresoCompendio);
      textAlign(CENTER, CENTER);
      textSize(20);
      text(desb ? "*" : "?", -cardW * 0.5 + 36, -2);
    }

    textAlign(LEFT, TOP);
    fill(desb ? colOro : color(170), 255 * progresoCompendio);
    textSize(15);
    text(logroNombres[i], -cardW * 0.5 + 70, -cardH * 0.5 + 12);

    fill(desb ? color(230, 245, 235) : color(135), 255 * progresoCompendio);
    textSize(12);
    text(logroDescripciones[i], -cardW * 0.5 + 70, -cardH * 0.5 + 34);

    int metaActual = max(1, logroMeta[i]);
    int progActual = desb ? metaActual : constrain(logroProgreso[i], 0, metaActual);

    fill(desb ? colG : color(120, 155, 138), 235 * progresoCompendio);
    textSize(11);
    String lineaEstado = desb
      ? logroRecompensas[i]
      : ("PROGRESO: " + progActual + "/" + metaActual + "  //  BLOQUEADO");
    text(lineaEstado, -cardW * 0.5 + 70, -cardH * 0.5 + 52);

    if (desb) {
      textAlign(RIGHT, TOP);
      fill(colG, 245 * progresoCompendio);
      textSize(11);
      text("COMPLETADO", cardW * 0.5 - 16, -cardH * 0.5 + 13);
    } else {
      float barW = 104;
      float barH = 6;
      float barCX = cardW * 0.5 - 16 - barW * 0.5;
      float barCY = -cardH * 0.5 + 58;
      float ratioProg = float(progActual) / float(metaActual);
      rectMode(CENTER);
      noStroke();
      fill(20, 36, 28, 220 * progresoCompendio);
      rect(barCX, barCY, barW, barH, 3);
      if (ratioProg > 0.0) {
        rectMode(CORNER);
        fill(colOro, 225 * progresoCompendio);
        rect(barCX - barW * 0.5, barCY - barH * 0.5, max(4, barW * ratioProg), barH, 3);
      }
      rectMode(CENTER);
    }

    popMatrix();
  }

  fill(180, 220, 200, 230 * progresoCompendio);
  textAlign(CENTER, CENTER);
  textSize(13);
  text("PROTOTIPO DE SESION: Los logros se desbloquean en vivo mientras juegas (F3 + [L] para probar toast).", 0, altoPanel * 0.5 - 32);
}

void dibujarPestanaPluginsCompendio(float anchoPanel, float altoPanel, color colG, color colOro) {
  int cols = 4;
  float cardW = 238;
  float cardH = 86;
  float espX = 18;
  float espY = 14;
  float startX = -((cols - 1) * (cardW + espX)) * 0.5;
  float startY = -altoPanel / 2 + 170;

  int totalP = min(16, numCatalogoPlugins);
  for (int i = 0; i < totalP; i++) {
    int col = i % cols;
    int fila = i / cols;
    float cx = startX + col * (cardW + espX);
    float cy = startY + fila * (cardH + espY);

    boolean desc = pluginDescubierto[i];
    boolean hov = evaluarHover(width / 2 + cx, height / 2 + cy, cardW, cardH);
    if (hov) {
      indiceCompendioHover = i;
      indiceCompendioSeleccionado = i;
    }
    boolean sel = (indiceCompendioSeleccionado == i);

    pushMatrix();
    translate(cx, cy);
    if (hov) scale(1.04);
    rectMode(CENTER);

    stroke(desc ? (sel ? colOro : colG) : color(60, 85, 70), 240 * progresoCompendio);
    strokeWeight(sel || hov ? 2.6 : 1.5);
    fill(desc ? color(14, 34, 24, 235 * progresoCompendio) : color(8, 15, 11, 210 * progresoCompendio));
    rect(0, 0, cardW, cardH, 10);

    textAlign(LEFT, TOP);
    fill(desc ? colOro : color(120), 255 * progresoCompendio);
    textSize(13);
    text(plugCatId[i] + (desc ? " // DESCUBIERTO" : " // ENCRIPTADO"), -cardW * 0.5 + 14, -cardH * 0.5 + 12);

    fill(desc ? color(255) : color(130), 255 * progresoCompendio);
    textSize(14);
    String nombreCorto = desc ? plugCatNombrePasiva[i] : "??? [CLASIFICADO]";
    if (i == 0 && desc) nombreCorto = "DOLUS PASSKEY";
    text(nombreCorto, -cardW * 0.5 + 14, -cardH * 0.5 + 34);

    fill(desc ? colG : color(95), 220 * progresoCompendio);
    textSize(11);
    text(desc ? ("COSTO TIENDA: " + plugCatPrecioTokens[i] + "T") : "Adquierelo en la tienda", -cardW * 0.5 + 14, -cardH * 0.5 + 58);

    popMatrix();
  }

  int idx = constrain(indiceCompendioSeleccionado, 0, max(0, totalP - 1));
  if (idx < totalP) {
    boolean descSel = pluginDescubierto[idx];
    float boxY = altoPanel * 0.5 - 72;
    rectMode(CENTER);
    fill(6, 16, 12, 245 * progresoCompendio);
    stroke(descSel ? colOro : colG, 200 * progresoCompendio);
    strokeWeight(2);
    rect(0, boxY, 1010, 92, 10);

    textAlign(LEFT, TOP);
    fill(descSel ? colOro : color(160), 255 * progresoCompendio);
    textSize(15);
    text(descSel ? (plugCatId[idx] + " - " + plugCatCategoria[idx]) : (plugCatId[idx] + " - ARCHIVO BLOQUEADO EN RED NEXUS"), -485, boxY - 34);

    textSize(13);
    String infoPasiva = descSel ? ("PASIVA [" + plugCatNombrePasiva[idx] + "]: " + plugCatDescripcionPasiva[idx]) : "Compra o equipa este plugin en una partida para desencriptar sus especificaciones.";
    dibujarLineaDolus(infoPasiva, -485, boxY - 10, color(230, 245, 235, 255 * progresoCompendio), LEFT);

    textSize(13);
    String infoActiva = descSel ? ("ACTIVA [" + plugCatNombreActiva[idx] + "]: " + plugCatDescripcionActiva[idx]) : "Pista: Disponible en el catalogo de la Tienda de Plugins.";
    dibujarLineaDolus(infoActiva, -485, boxY + 14, color(colG, 240 * progresoCompendio), LEFT);
  }
}

void dibujarPestanaSinergiasYJefes(float anchoPanel, float altoPanel, color colG, color colOro) {
  String[] synNombres = {
    "SYN.01 RED ESPECIALISTA (Firewall + Antena)",
    "SYN.02 CAOS CUANTICO (Overclock + Acelerador)",
    "SYN.03 SIMBIOSIS OSCURA (Virus + Parasito)",
    "SYN.04 FORTUNA PERFECTA (Iman + Cristalizador)",
    "SYN.05 TRINIDAD DEFENSIVA (Mascara + Proxy + Jammer)"
  };
  String[] synEfectos = {
    "Los paquetes de malware detectados en la red se auto-destruyen.",
    "Genera +2 Tokens pasivamente cada 10 segundos de operacion.",
    "La perdida pasiva de Salud Mental por corrupcion se reduce a 0.",
    "El bono de Combo Maximo se multiplica x2 al liquidar la ronda.",
    "Otorga inmunidad total contra penalizaciones de Reputacion."
  };

  textAlign(LEFT, TOP);
  fill(colOro, 255 * progresoCompendio);
  textSize(18);
  text("SINERGIAS DE RED (5 COMBINACIONES)", -510, -altoPanel / 2 + 135);

  for (int s = 0; s < 5; s++) {
    float sy = -altoPanel / 2 + 202 + s * 78;
    boolean desc = sinergiaDescubierta[s];
    rectMode(CENTER);
    stroke(desc ? colOro : colG, (desc ? 240 : 120) * progresoCompendio);
    strokeWeight(desc ? 2.2 : 1.2);
    fill(desc ? color(20, 44, 30, 230 * progresoCompendio) : color(8, 18, 13, 210 * progresoCompendio));
    rect(-250, sy, 520, 64, 8);

    textAlign(LEFT, TOP);
    fill(desc ? colOro : color(190), 255 * progresoCompendio);
    textSize(13);
    text(synNombres[s] + (desc ? " [DESCUBIERTA]" : ""), -496, sy - 22);

    fill(desc ? color(235) : color(145), 240 * progresoCompendio);
    textSize(11);
    text(synEfectos[s], -496, sy + 4);
  }

  String[] bossNombres = {
    "JEFE 1: LA TENDENCIA VIRAL",
    "JEFE 2: LA CAMARA DE ECO",
    "JEFE 3: LA DESINFORMACION",
    "JEFE 4: EL ALGORITMO SUPREMO"
  };
  String[] bossAmenazas = {
    "Fiebre de FOMO: Drena Popularidad si tardas mas de 2.5s en decidir.",
    "Rebote Acustico: Oculta remitentes y exige mantener el flujo constante.",
    "Gaslighting Total: Distorsiona las barras de estadisticas con datos falsos.",
    "Control Absoluto: Silencia ranuras de Plugins al azar en cada paquete."
  };

  textAlign(LEFT, TOP);
  fill(color(255, 95, 95), 255 * progresoCompendio);
  textSize(18);
  text("AMENAZAS / JEFES NEXUS (4 ENTIDADES)", 40, -altoPanel / 2 + 135);

  for (int b = 0; b < 4; b++) {
    float by = -altoPanel / 2 + 210 + b * 96;
    boolean visto = jefeDescubierto[b + 1];
    rectMode(CENTER);
    stroke(visto ? color(255, 95, 95) : color(90, 60, 60), 230 * progresoCompendio);
    strokeWeight(visto ? 2.2 : 1.4);
    fill(visto ? color(38, 12, 16, 230 * progresoCompendio) : color(14, 10, 12, 210 * progresoCompendio));
    rect(275, by, 470, 78, 10);

    textAlign(LEFT, TOP);
    fill(visto ? color(255, 130, 130) : color(175), 255 * progresoCompendio);
    textSize(14);
    text(bossNombres[b] + (visto ? " // REGISTRADO" : " // SIN DATOS"), 55, by - 26);

    fill(visto ? color(240, 225, 225) : color(135), 240 * progresoCompendio);
    textSize(12);
    text(bossAmenazas[b], 55, by - 2);
  }
}

void mousePressedCompendio() {
  if (animandoCompendio) return;

  float anchoPanel = 1140;
  float altoPanel = 700;
  float tabW = 310;
  float tabH = 40;
  float tabY = -altoPanel / 2 + 92;

  for (int t = 0; t < 3; t++) {
    float tabX = (t - 1) * (tabW + 24);
    if (evaluarHover(width / 2 + tabX, height / 2 + tabY, tabW, tabH)) {
      reproducirTap();
      pestanaCompendio = t;
      indiceCompendioSeleccionado = 0;
      return;
    }
  }

  if (hoverBotonCerrar(anchoPanel, altoPanel)) {
    reproducirTap();
    if (abiertoCompendioDesdePausa) {
      estadoPantalla = pantallaOrigenPausa;
      estadoPausa = 2;
      abiertoCompendioDesdePausa = false;
    } else {
      estadoPantalla = PANTALLA_MENU;
    }
  }
}
