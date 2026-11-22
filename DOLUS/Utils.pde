
color colorTemaActual = color(39, 236, 72);
int frameUltimoColorTema = -1;

color colorTemaObjetivo() {
  if (estadoPantalla == 8 && comboActual >= 10) return color(255, 65, 25);
  int bTarget = 0;
  if (estadoPantalla == 8 && jefeActivo > 0) {
    bTarget = jefeActivo;
  } else {
    if (estadoPantalla == 6 && conversanteActual > 0) {
      bTarget = conversanteActual;
    } else {
      if (estadoPantalla == 11 && jefePendiente > 0) {
        bTarget = jefePendiente;
      }
    }
  }
  if (bTarget > 0) {
    if (modoDaltonismo == 0) {
      if (bTarget == 1) return color(255, 65, 195);
      if (bTarget == 2) return color(255, 185, 35);
      if (bTarget == 3) return color(175, 95, 255);
      if (bTarget == 4) return color(255, 45, 75);
    }
  }
  if (modoDaltonismo == 1) return color(230, 200, 80);
  if (modoDaltonismo == 2) return color(255, 230, 50);
  if (modoDaltonismo == 3) return color(220, 150, 255);
  return color(39, 236, 72);
}

color colorTema() {
  color obj = colorTemaObjetivo();
  if (frameCount != frameUltimoColorTema) {
    frameUltimoColorTema = frameCount;
    colorTemaActual = lerpColor(colorTemaActual, obj, 0.08);
  }
  return colorTemaActual;
}

color colorRellenoSlider() {
  if (modoDaltonismo == 1) return color(210, 180, 50);
  if (modoDaltonismo == 2) return color(230, 200, 30);
  if (modoDaltonismo == 3) return color(190, 120, 220);
  return color(29, 196, 60);
}

color colorBitTunel() {
  if (modoDaltonismo == 1) return color(230, 190, 50);
  if (modoDaltonismo == 2) return color(240, 210, 30);
  if (modoDaltonismo == 3) return color(190, 120, 255);
  return color(39, 236, 72);
}

color colorBitNexus(boolean alarma) {
  if (modoDaltonismo == 1) return alarma ? color(255, 100, 30) : color(230, 190, 50);
  if (modoDaltonismo == 2) return alarma ? color(255, 120, 20) : color(240, 210, 30);
  if (modoDaltonismo == 3) return alarma ? color(255, 50, 180) : color(190, 120, 255);
  return alarma ? color(255, 40, 40) : color(39, 236, 72);
}

void fillTema(float alpha) {
  color c = colorTema();
  fill(red(c), green(c), blue(c), alpha);
}

void strokeTema(float alpha) {
  color c = colorTema();
  stroke(red(c), green(c), blue(c), alpha);
}

void fillConAlpha(color c, float alpha) {
  fill(red(c), green(c), blue(c), alpha);
}

void strokeConAlpha(color c, float alpha) {
  stroke(red(c), green(c), blue(c), alpha);
}

String obtenerTextoDaltonismo() {
  if (modoDaltonismo == 0) return "NO";
  if (modoDaltonismo == 1) return "PROTANOPIA (ROJO)";
  if (modoDaltonismo == 2) return "DEUTERANOPIA (VERDE)";
  return "TRITANOPIA (AZUL)";
}

SoundFile cargarSonido(String nombreArchivo) {
  try {
    SoundFile sf = new SoundFile(this, nombreArchivo);
    if (sf.frames() <= 0) {
      if (strEndsWith(nombreArchivo, ".ogg") || strEndsWith(nombreArchivo, ".mp3")) {
        int punto = strLastIndexOf(nombreArchivo, ".");
        String altWav = (punto >= 0 ? nombreArchivo.substring(0, punto) : nombreArchivo) + ".wav";
        try {
          SoundFile sfWav = new SoundFile(this, altWav);
          if (sfWav.frames() > 0) return sfWav;
        } catch (Exception ignored) {}
      }
      println("archivo de audio con 0 frames ignorado: " + nombreArchivo);
      return null;
    }
    return sf;
  } catch (Exception e) {
    if (strEndsWith(nombreArchivo, ".ogg") || strEndsWith(nombreArchivo, ".mp3")) {
      int punto = strLastIndexOf(nombreArchivo, ".");
      String altWav = (punto >= 0 ? nombreArchivo.substring(0, punto) : nombreArchivo) + ".wav";
      try {
        SoundFile sfWav = new SoundFile(this, altWav);
        if (sfWav.frames() > 0) return sfWav;
      } catch (Exception ignored) {}
    }
    println("no se pudo cargar: " + nombreArchivo);
    return null;
  }
}

float volumenFinalSFX() {
  return constrain(pow(volumenMaestro, 2) * pow(volumenSFX, 2), 0.0, 1.0);
}

float volumenFinalMusica() {
  return constrain(volumenMaestro * volumenMusica, 0.0, 1.0);
}

float factorMusicaTransicion = 1.0;

boolean musicaEnTransicionDificultad() {
  return (estadoPantalla == PANTALLA_DIFICULTAD && quemandoDificultad && seleccionadoParaJugar)
      || ejecutandoLinkStart
      || ejecutandoCargaNexus
      || ejecutandoPantallaCargaMeta;
}

void actualizarAtenuacionMusicaTransicion() {
  if (animandoTVOff) return;
  float objetivo = musicaEnTransicionDificultad() ? 0.10 : 1.0;
  if (abs(factorMusicaTransicion - objetivo) > 0.002) {
    float vel = (objetivo < factorMusicaTransicion) ? 0.14 : 0.08;
    factorMusicaTransicion = lerp(factorMusicaTransicion, objetivo, vel);
    if (abs(factorMusicaTransicion - objetivo) <= 0.003) {
      factorMusicaTransicion = objetivo;
    }
    actualizarVolumenesAudio();
  }
}

boolean musicaSilenciadaPorPausa() {
  return pausaActiva()
      || (estadoPantalla == PANTALLA_OPCIONES && abiertoDesdePausa)
      || (estadoPantalla == PANTALLA_COMPENDIO && abiertoCompendioDesdePausa);
}

void actualizarVolumenesAudio() {
  float volM = musicaSilenciadaPorPausa() ? 0.0 : volumenFinalMusica();
  float volMenu = constrain(volM * factorMusicaTransicion, 0.0, 1.0);
  if (musicaMenu != null) musicaMenu.amp(volMenu);
  if (musicaGameplayInicial != null) musicaGameplayInicial.amp(volM);
  if (musicaGameplayIntenso != null) musicaGameplayIntenso.amp(volM);
  if (musicaJefeTendencia != null) musicaJefeTendencia.amp(volM);
  if (musicaJefeCamara != null) musicaJefeCamara.amp(volM);
  if (musicaJefeDesinformacion != null) musicaJefeDesinformacion.amp(volM);
  if (musicaJefeAdmin != null) musicaJefeAdmin.amp(volM);
  if (musicaCredits != null) musicaCredits.amp(volM);
}

void detenerPistaSiSuena(SoundFile pista, SoundFile excepto) {
  if (pista != null && pista != excepto && pista.isPlaying()) {
    pista.stop();
  }
}

void detenerTodaMusica() {
  detenerPistaSiSuena(musicaMenu, null);
  detenerPistaSiSuena(musicaGameplayInicial, null);
  detenerPistaSiSuena(musicaGameplayIntenso, null);
  detenerPistaSiSuena(musicaJefeTendencia, null);
  detenerPistaSiSuena(musicaJefeCamara, null);
  detenerPistaSiSuena(musicaJefeDesinformacion, null);
  detenerPistaSiSuena(musicaJefeAdmin, null);
  detenerPistaSiSuena(musicaCredits, null);
  if (sonidoLightningLoop != null && sonidoLightningLoop.isPlaying()) {
    sonidoLightningLoop.stop();
  }
}

void reproducirMusicaUnica(SoundFile pista) {
  detenerPistaSiSuena(musicaMenu, pista);
  detenerPistaSiSuena(musicaGameplayInicial, pista);
  detenerPistaSiSuena(musicaGameplayIntenso, pista);
  detenerPistaSiSuena(musicaJefeTendencia, pista);
  detenerPistaSiSuena(musicaJefeCamara, pista);
  detenerPistaSiSuena(musicaJefeDesinformacion, pista);
  detenerPistaSiSuena(musicaJefeAdmin, pista);
  detenerPistaSiSuena(musicaCredits, pista);
  if (pista != null && !pista.isPlaying()) {
    pista.loop();
  }
  actualizarVolumenesAudio();
}

SoundFile ultimoSFXReproducido = null;
int ultimoTiempoSFXMs = -100;
int ultimoTiempoClickUIMs = -100;
int ultimoTipoClickUI = -1;

PImage cargarImagenSegura(String nombreArchivo) {
  if (nombreArchivo == null || nombreArchivo.length() == 0) return null;
  try {
    return loadImage(nombreArchivo);
  } catch (Exception e) {
    return null;
  }
}

void reproducirSFXConTono(SoundFile s, float pitch, float multiplicador) {
  if (s == null || s.frames() <= 0) return;
  float vol = constrain(volumenFinalSFX() * multiplicador, 0.0, 1.0);
  if (s == sonidoGlitchFuerte) {
    vol *= 0.28;
  }
  if (vol <= 0.001) return;
  if (s.isPlaying()) {
    s.stop();
  }
  s.play(pitch, vol);
}

void reproducirSFX(SoundFile s, float multiplicador) {
  if (s == null || s.frames() <= 0) return;
  int ahora = millis();
  if (s == ultimoSFXReproducido && (ahora - ultimoTiempoSFXMs) < 35) return;
  ultimoSFXReproducido = s;
  ultimoTiempoSFXMs = ahora;
  reproducirSFXConTono(s, 1.0, multiplicador);
}

void reproducirSFX(SoundFile s) {
  reproducirSFX(s, 1.0);
}

boolean alternadorCursorClick = false;

void reproducirClickUI(boolean usarVariante2) {
  int tipo = usarVariante2 ? 2 : 1;
  int ahora = millis();
  if (tipo == ultimoTipoClickUI && (ahora - ultimoTiempoClickUIMs) < 40) return;
  SoundFile elegido = usarVariante2 ? sonidoCursorClick2 : sonidoCursorClick1;
  if (elegido == null || elegido.frames() <= 0) {
    elegido = (sonidoCursorClick1 != null && sonidoCursorClick1.frames() > 0) ? sonidoCursorClick1 : sonidoTap;
  }
  if (elegido == null || elegido.frames() <= 0) return;
  ultimoTipoClickUI = tipo;
  ultimoTiempoClickUIMs = ahora;
  reproducirSFXConTono(elegido, random(0.95, 1.06), 1.0);
}

void reproducirTap() {
  if (millis() - ultimoTiempoSonidoTap > intervaloMinimoTap) {
    alternadorCursorClick = !alternadorCursorClick;
    if (sonidoCursorClick1 != null || sonidoCursorClick2 != null) {
      reproducirClickUI(alternadorCursorClick);
    } else {
      reproducirSFX(sonidoTap);
    }
    ultimoTiempoSonidoTap = millis();
  }
}

int ultimoTiempoDialogoIn = -1000;
int ultimoTiempoSonidoLogro = -1000;

void reproducirDialogoIn() {
  if (millis() - ultimoTiempoDialogoIn < 400) return;
  if (sonidoDialogoIn == null || sonidoDialogoIn.frames() <= 0) return;
  reproducirSFXConTono(sonidoDialogoIn, random(0.98, 1.03), 1.0);
  ultimoTiempoDialogoIn = millis();
}

void reproducirLogro() {
  if (millis() - ultimoTiempoSonidoLogro < 450) return;
  if (sonidoLogro != null && sonidoLogro.frames() > 0) {
    reproducirSFXConTono(sonidoLogro, 1.0, 1.0);
    ultimoTiempoSonidoLogro = millis();
  } else {
    if (sonidoTransferenciaExitosa != null) {
      reproducirSFX(sonidoTransferenciaExitosa);
      ultimoTiempoSonidoLogro = millis();
    } else {
      if (sonidoDecisionCorrecta != null) {
        reproducirSFX(sonidoDecisionCorrecta);
        ultimoTiempoSonidoLogro = millis();
      }
    }
  }
}

PImage imgCursorBase;
PImage imgCursorDedo;
boolean cursorSobreElementoClicable = false;
int estadoCursorActual = -1;

PImage prepararCursor32(PImage orig) {
  if (orig == null) return null;
  if (orig.width == 32 && orig.height == 32) return orig;
  PImage lienzo = createImage(32, 32, ARGB);
  lienzo.loadPixels();
  orig.loadPixels();
  for (int i = 0; i < 32 * 32; i++) {
    lienzo.pixels[i] = color(0, 0);
  }
  int wMax = min(32, orig.width);
  int hMax = min(32, orig.height);
  for (int y = 0; y < hMax; y++) {
    for (int x = 0; x < wMax; x++) {
      lienzo.pixels[y * 32 + x] = orig.pixels[y * orig.width + x];
    }
  }
  lienzo.updatePixels();
  return lienzo;
}

void inicializarCursorPersonalizado() {
  estadoCursorActual = -1;
  cursorSobreElementoClicable = false;
  actualizarCursorPersonalizado();
}

int ultimoTiempoCursorHover = -1000;

void reproducirCursorHover() {
  if (millis() - ultimoTiempoCursorHover < 50) return;
  if (sonidoCursorHover != null && sonidoCursorHover.frames() > 0) {
    reproducirSFXConTono(sonidoCursorHover, random(0.98, 1.04), 0.75);
    ultimoTiempoCursorHover = millis();
  }
}

int ultimoModoDaltonismoCursor = -1;

void actualizarCursorPersonalizado() {
  int nuevoEstado = cursorSobreElementoClicable ? 1 : 0;
  if (nuevoEstado != estadoCursorActual || modoDaltonismo != ultimoModoDaltonismoCursor) {
    boolean cambioEstado = (nuevoEstado != estadoCursorActual);
    estadoCursorActual = nuevoEstado;
    ultimoModoDaltonismoCursor = modoDaltonismo;
    if (estadoCursorActual == 1) {
      if (cambioEstado) reproducirCursorHover();
      PImage curDedo = imgCursorShaderDaltonismo(imgCursorDedo);
      if (curDedo != null) {
        cursor(curDedo, 8, 1);
      } else {
        cursor(HAND);
      }
    } else {
      PImage curBase = imgCursorShaderDaltonismo(imgCursorBase);
      if (curBase != null) {
        cursor(curBase, 8, 5);
      } else {
        cursor(ARROW);
      }
    }
  }
}

boolean evaluarHover(float x, float y, float w, float h) {
  boolean hov = (mouseX >= x - w/2 && mouseX <= x + w/2 && mouseY >= y - h/2 && mouseY <= y + h/2);
  if (hov) cursorSobreElementoClicable = true;
  return hov;
}

float xBotonCerrarRel(float anchoPanel) { return anchoPanel / 2 - 40; }
float yBotonCerrarRel(float altoPanel)  { return -altoPanel / 2 + 40; }

boolean hoverBotonCerrar(float anchoPanel, float altoPanel) {
  return evaluarHover(width / 2 + xBotonCerrarRel(anchoPanel),
                      height / 2 + yBotonCerrarRel(altoPanel), 40, 40);
}

void dibujarBotonCerrar(float anchoPanel, float altoPanel, float progreso) {
  float xB = xBotonCerrarRel(anchoPanel);
  float yB = yBotonCerrarRel(altoPanel);
  boolean hover = hoverBotonCerrar(anchoPanel, altoPanel);
  boolean presionado = hover && mousePressed;

  pushStyle();
  pushMatrix();
  translate(xB, yB);
  if (presionado) translate(0, 3);
  else {
    if (hover) scale(1.15);
  }

  stroke(hover ? color(255) : color(220, 50, 50), 255 * progreso);
  strokeWeight(2);
  fill(presionado ? color(140, 10, 10, 255 * progreso)
                  : (hover ? color(200, 30, 30, 230 * progreso) : color(80, 20, 20, 200 * progreso)));
  rectMode(CENTER);
  rect(0, 0, 40, 40, 8);

  fill(255, 255 * progreso);
  textAlign(CENTER, CENTER);
  textSize(22);
  text("X", 0, -2);
  popMatrix();
  popStyle();
}

int contarTextos(String[] arr) {
  if (arr == null) return 0;
  int total = 0;
  for (String s : arr) {
    if (s == null) break;
    total++;
  }
  return total;
}

int contarPlantillas2D(String[][] arr) {
  if (arr == null) return 0;
  int total = 0;
  for (String[] fila : arr) {
    if (fila == null) break;
    total++;
  }
  return total;
}

int contarEnteros(int[] arr) {
  if (arr == null) return 0;
  int total = 0;
  for (int n : arr) {
    total++;
  }
  return total;
}

boolean arrayContieneInt(int[] arr, int count, int val) {
  if (arr == null) return false;
  for (int i = 0; i < count; i++) {
    if (arr[i] == val) return true;
  }
  return false;
}

boolean arrayContieneTexto(String[] arr, int count, String val) {
  if (arr == null || val == null) return false;
  for (int i = 0; i < count; i++) {
    if (arr[i] != null && arr[i].equals(val)) return true;
  }
  return false;
}

int strIndexOfFrom(String s, String busq, int desde) {
  if (s == null || busq == null) return -1;
  int nS = s.length();
  int nB = busq.length();
  if (nB == 0) return (desde >= 0 && desde <= nS) ? desde : -1;
  if (desde < 0) desde = 0;
  for (int i = desde; i <= nS - nB; i++) {
    if (s.substring(i, i + nB).equals(busq)) return i;
  }
  return -1;
}

int strIndexOf(String s, String busq) {
  return strIndexOfFrom(s, busq, 0);
}

int strLastIndexOf(String s, String busq) {
  if (s == null || busq == null) return -1;
  int nS = s.length();
  int nB = busq.length();
  if (nB == 0) return nS;
  for (int i = nS - nB; i >= 0; i--) {
    if (s.substring(i, i + nB).equals(busq)) return i;
  }
  return -1;
}

boolean strEndsWith(String s, String sufijo) {
  if (s == null || sufijo == null) return false;
  int nS = s.length();
  int nF = sufijo.length();
  if (nF > nS) return false;
  return s.substring(nS - nF, nS).equals(sufijo);
}

boolean strStartsWith(String s, String prefijo) {
  if (s == null || prefijo == null) return false;
  int nS = s.length();
  int nP = prefijo.length();
  if (nP > nS) return false;
  return s.substring(0, nP).equals(prefijo);
}

boolean strEsDigito(String ch) {
  if (ch == null || ch.length() != 1) return false;
  return ch.compareTo("0") >= 0 && ch.compareTo("9") <= 0;
}

String strToUpper(String s) {
  if (s == null) return null;
  String mins = "abcdefghijklmnopqrstuvwxyzáéíóúñü";
  String mays = "ABCDEFGHIJKLMNOPQRSTUVWXYZÁÉÍÓÚÑÜ";
  String res = "";
  int n = s.length();
  int nMap = mins.length();
  for (int i = 0; i < n; i++) {
    String ch = s.substring(i, i + 1);
    boolean convertido = false;
    for (int j = 0; j < nMap; j++) {
      if (ch.equals(mins.substring(j, j + 1))) {
        res = res + mays.substring(j, j + 1);
        convertido = true;
        break;
      }
    }
    if (!convertido) {
      res = res + ch;
    }
  }
  return res;
}

String strToLower(String s) {
  if (s == null) return null;
  String mins = "abcdefghijklmnopqrstuvwxyzáéíóúñü";
  String mays = "ABCDEFGHIJKLMNOPQRSTUVWXYZÁÉÍÓÚÑÜ";
  String res = "";
  int n = s.length();
  int nMap = mins.length();
  for (int i = 0; i < n; i++) {
    String ch = s.substring(i, i + 1);
    boolean convertido = false;
    for (int j = 0; j < nMap; j++) {
      if (ch.equals(mays.substring(j, j + 1))) {
        res = res + mins.substring(j, j + 1);
        convertido = true;
        break;
      }
    }
    if (!convertido) {
      res = res + ch;
    }
  }
  return res;
}

String strTrim(String s) {
  if (s == null) return null;
  int ini = 0;
  int fin = s.length();
  while (ini < fin) {
    String ch = s.substring(ini, ini + 1);
    if (ch.equals(" ") || ch.equals("\t") || ch.equals("\n") || ch.equals("\r")) {
      ini++;
    } else {
      break;
    }
  }
  while (fin > ini) {
    String ch = s.substring(fin - 1, fin);
    if (ch.equals(" ") || ch.equals("\t") || ch.equals("\n") || ch.equals("\r")) {
      fin--;
    } else {
      break;
    }
  }
  return s.substring(ini, fin);
}

boolean strEqualsIgnoreCase(String a, String b) {
  if (a == null && b == null) return true;
  if (a == null || b == null) return false;
  return strToLower(a).equals(strToLower(b));
}

String strReplace(String s, String busq, String reemp) {
  if (s == null) return "";
  if (busq == null || busq.length() == 0) return s;
  String r = (reemp != null) ? reemp : "";
  String out = "";
  int i = 0;
  int n = s.length();
  int nb = busq.length();
  while (i < n) {
    if (i + nb <= n && s.substring(i, i + nb).equals(busq)) {
      out = out + r;
      i += nb;
    } else {
      out = out + s.substring(i, i + 1);
      i++;
    }
  }
  return out;
}

String[] dividirTexto(String texto, String sep) {
  String[] partes = new String[512];
  if (texto == null) return partes;
  int count = 0;
  String actual = "";
  int n = texto.length();
  for (int i = 0; i < n; i++) {
    String ch = texto.substring(i, i + 1);
    if (ch.equals(sep)) {
      if (count < 512) {
        partes[count] = actual;
        count++;
      }
      actual = "";
    } else {
      actual = actual + ch;
    }
  }
  if (count < 512) {
    partes[count] = actual;
  }
  return partes;
}

boolean contieneTexto(String texto, String buscado) {
  if (texto == null || buscado == null) return false;
  int nTexto = texto.length();
  int nBuscado = buscado.length();
  if (nBuscado > nTexto) return false;
  for (int i = 0; i <= nTexto - nBuscado; i++) {
    if (texto.substring(i, i + nBuscado).equals(buscado)) {
      return true;
    }
  }
  return false;
}

String aMayusculaQTE(String c) {
  if (c == null) return "";
  if (c.equals("e")) return "E";
  if (c.equals("r")) return "R";
  if (c.equals("q")) return "Q";
  if (c.equals("w")) return "W";
  if (c.equals("a")) return "A";
  if (c.equals("s")) return "S";
  if (c.equals("d")) return "D";
  return c;
}

void dibujarTextoConSaltosDeLinea(String texto, float x, float y, float anchoMax, float alturaLinea) {
  String[] palabras = dividirTexto(texto, " ");
  int totalPalabras = contarTextos(palabras);
  String lineaActual = "";
  float yActual = y;

  for (int i = 0; i < totalPalabras; i++) {
    String pal = palabras[i];
    String candidata = (lineaActual.length() == 0) ? pal : lineaActual + " " + pal;

    if (textWidth(candidata) > anchoMax && lineaActual.length() > 0) {
      dibujarLineaOndulada(lineaActual, x, yActual);
      yActual += alturaLinea;
      lineaActual = pal;
    } else {
      lineaActual = candidata;
    }
  }

  if (lineaActual.length() > 0) {
    dibujarLineaOndulada(lineaActual, x, yActual);
  }
}

void reiniciarPartidaCompleta() {
  modoFeriaActivo = false;
  modoExposicionActivo = false;
  diaInicializado = false;

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
  vidasJugador = 1;

  rondaActual = 1;
  mensajesProcesadosRonda = 0;
  mensajesPorRonda = 8;
  rondaCompletada = false;
  animandoTransicionTienda = false;
  sentidoTransicionTienda = 0;
  progresoTransicionTienda = 0.0;
  animandoSalidaLiquidacion = false;
  progresoSalidaLiquidacion = 0.0;
  tokensDolus = 0;
  tokensInicioRonda = 0;
  comboActual = 0;
  comboMaximoRonda = 0;
  reiniciarMarcoFuegoDolus();
  liqFarmRonda = 0;
  liqPromIntegridad = 50;
  liquidacionCalculada = false;
  consecutivosInocente = 0;
  consecutivosMalo = 0;
  cartasGeneradasEnRonda = 0;
  dialogoAscensoRonda5Visto = false;

  razonGameOver = "";
  tipoGameOver = 0;
  imgGameOverActual = null;

  reiniciarVouchersPartida();

  resetearEstadosPlugins();
  numPluginsJugador = 0;
  if (numCatalogoPlugins > 0) {
    pluginsJugador[numPluginsJugador++] = 0;
  }
  numInventarioPlugins = 0;
  recargarDatosPlugins();

  inicializarTienda();
  ultimaRondaTienda = -1;
  costoRerollTienda = 12;
  boosterPackComprado = false;
  exploitComprado = false;
  shopCardSeleccionada = -1;
  shopVoucherSeleccionado = false;
  shopPackSeleccionado = -1;
  shopDescBoxActiva = false;
  shopDescBoxTipo = 0;
  shopDescBoxIdx = -1;
  for (int p = 0; p < 3; p++) {
    tiendaPacksComprado[p] = false;
  }

  resetearEstadoJefes();
  resetearEstadoEpilogo();

  numBandejaMensajes = 0;
  limpiarColaMensajes();
  numCartasSaliendo = 0;
  numParticulasRielSwipe = 0;
  numRayosRielSwipe = 0;
  numParticulasJuego = 0;
  limpiarColaEventos();
  arrastrando_mensaje = false;
  mensajeActivo = -1;
  timerNuevoMensaje = 45;
  qteActivo = false;
  qteTipo = 0;
  qteTimer = 0;
  juegoPausado = false;
  fasePluginsActiva = false;
}

boolean suprimirMetaChatAlVolverMenu = false;

void volverAlMenuPrincipal() {
  modoFeriaActivo = false;
  modoExposicionActivo = false;
  estadoPantalla = PANTALLA_MENU;
  progresoEntrada = 0.0;
  animandoEntrada = true;
  animandoDificultad = false;
  progresoDificultad = 0.0;
  animandoTVOff = false;
  progresoTV = 0.0;
  menuDaltonismoAbierto = false;

  if (suprimirMetaChatAlVolverMenu || habBatallaFinalCompletada) {
    metaMensajePendiente = false;
    lineasActualesMeta = null;
    suprimirMetaChatAlVolverMenu = false;
  } else {
    chequearProgresoMetaJuego();
  }

  ejecutandoCargaNexus = false;
  ejecutandoLinkStart = false;
  modoAlarmaError = false;

  caracteresVisibles = 0;
  glitchActivo = false;
  textoGlitcheado = "DOLUS";
  ultimoTiempoEscritura = millis();
  ultimoTiempoSonidoTeclado = millis();

  intensidadSuccionFondo = 0.0;
  succionando = false;
  escupiendoMenu = false;
  quemandoDificultad = false;
  factorMusicaTransicion = 1.0;

  reiniciarPartidaCompleta();

  reproducirMusicaUnica(musicaMenu);
}

int estadoTransicionMenu = 0;
float progresoTransicionMenu = 0;
int temporizadorCierreMenu = 0;

void iniciarTransicionMenu() {
  estadoTransicionMenu = 1;
  progresoTransicionMenu = 0.0;
}

void actualizarYDibujarCompuertas() {
  if (estadoTransicionMenu == 0) return;

  if (estadoTransicionMenu == 1) {
    progresoTransicionMenu += 0.035;
    if (progresoTransicionMenu >= 1.0) {
      progresoTransicionMenu = 1.0;
      estadoTransicionMenu = 2;
      temporizadorCierreMenu = 25;
      volverAlMenuPrincipal();
    }
  }
  else {
    if (estadoTransicionMenu == 2) {
      temporizadorCierreMenu--;
      if (temporizadorCierreMenu <= 0) {
        estadoTransicionMenu = 3;
      }
    }
    else {
      if (estadoTransicionMenu == 3) {
        progresoTransicionMenu -= 0.04;
        if (progresoTransicionMenu <= 0.0) {
          progresoTransicionMenu = 0.0;
          estadoTransicionMenu = 0;
        }
      }
    }
  }

  pushStyle();

  color cPanel   = color(14, 18, 15);
  color cVerde   = colorTema();
  color cVerdeOsc= color(red(cVerde)*0.47, green(cVerde)*0.47, blue(cVerde)*0.47);
  color cVerdeMedio = color(red(cVerde)*0.7, green(cVerde)*0.7, blue(cVerde)*0.7);
  color cDetalle = color(6, 10, 8);

  float factor = (estadoTransicionMenu == 1) ? easeInBack(progresoTransicionMenu) : easeOutBack(progresoTransicionMenu);
  float rebote = 0;

  if (estadoTransicionMenu == 2) {
    rebote = sin(temporizadorCierreMenu * 0.7) * (temporizadorCierreMenu * 0.25);
  }

  float yCentro = height / 2.0;
  float yTopOffset = map(factor, 0, 1, -yCentro - 60, 0) + rebote;
  float yBotOffset = map(factor, 0, 1, yCentro + 60, 0) - rebote;

  pushMatrix();

  if (estadoTransicionMenu == 2) {
    float intensidad = max(0, temporizadorCierreMenu - 15) * 0.7;
    translate(cos(temporizadorCierreMenu * 2.1) * intensidad, sin(temporizadorCierreMenu * 1.7) * intensidad);
  }

  pushMatrix();
  translate(0, yTopOffset);
  dibujarCompuertaTop(yCentro, cPanel, cVerdeOsc, cDetalle, cVerdeMedio, cVerde);
  popMatrix();

  pushMatrix();
  translate(0, yBotOffset);
  dibujarCompuertaBot(yCentro, cPanel, cVerdeOsc, cDetalle, cVerdeMedio, cVerde);
  popMatrix();

  if (estadoTransicionMenu == 1 && progresoTransicionMenu > 0.85) {
    fill(cVerde);
    float anchoLinea = map(progresoTransicionMenu, 0.85, 1.0, width * 0.1, width * 0.35);
    rectMode(CORNER);
    noStroke();
    rect(width / 2.0 - anchoLinea / 2.0, yCentro - 1, anchoLinea, 2);
  } else {
    if (estadoTransicionMenu == 2 && temporizadorCierreMenu > 15) {
      float exp = map(temporizadorCierreMenu, 25, 15, 0, 1);
      float anchoFlash = map(easeOutCubic(exp), 0, 1, width * 0.15, width);
      float altoFlash = map(exp, 0, 1, 14, 0);

      rectMode(CORNER);
      noStroke();
      fill(red(cVerde), green(cVerde), blue(cVerde), 255 * (1 - exp));
      rect(width / 2.0 - anchoFlash / 2.0, yCentro - altoFlash / 2.0, anchoFlash, altoFlash);

      fill(255, 255 * (1 - exp));
      rect(width / 2.0 - anchoFlash * 0.2, yCentro - altoFlash * 0.25, anchoFlash * 0.4, altoFlash * 0.5);
    }
  }

  popMatrix();
  popStyle();
}

void dibujarCompuertaTop(float yCorte, color cPanel, color cVerdeOsc, color cDetalle, color cVerdeMedio, color cVerde) {
  fill(cPanel);
  stroke(cVerdeOsc);
  strokeWeight(3);
  beginShape();
  vertex(-10, -10);
  vertex(width + 10, -10);
  vertex(width + 10, yCorte);
  vertex(width / 2.0 + 150, yCorte);
  vertex(width / 2.0 + 120, yCorte - 40);
  vertex(width / 2.0 - 120, yCorte - 40);
  vertex(width / 2.0 - 150, yCorte);
  vertex(-10, yCorte);
  endShape(CLOSE);

  noStroke();
  fill(cDetalle);
  beginShape();
  vertex(width * 0.1, -10);
  vertex(width * 0.15, -10);
  vertex(width * 0.15 + 40, yCorte - 60);
  vertex(width * 0.1 + 40, yCorte - 60);
  endShape(CLOSE);

  rectMode(CORNER);
  fill(cVerdeMedio);
  rect(width / 2.0 - 80, yCorte - 25, 45, 4);
  rect(width / 2.0 - 25, yCorte - 25, 12, 4);

  fill(cVerde);
  rect(width * 0.85, yCorte - 70, 8, 8);
  rect(width * 0.85 + 14, yCorte - 70, 8, 8);

  stroke(cVerde, 60);
  strokeWeight(1);
  line(width / 2.0 - 120, yCorte - 50, width / 2.0 + 120, yCorte - 50);
}

void dibujarCompuertaBot(float yCorte, color cPanel, color cVerdeOsc, color cDetalle, color cVerdeMedio, color cVerde) {
  fill(cPanel);
  stroke(cVerdeOsc);
  strokeWeight(3);
  beginShape();
  vertex(width + 10, height + 10);
  vertex(-10, height + 10);
  vertex(-10, yCorte);
  vertex(width / 2.0 - 150, yCorte);
  vertex(width / 2.0 - 120, yCorte - 40);
  vertex(width / 2.0 + 120, yCorte - 40);
  vertex(width / 2.0 + 150, yCorte);
  vertex(width + 10, yCorte);
  endShape(CLOSE);

  noStroke();
  fill(cDetalle);
  beginShape();
  vertex(width * 0.75, height + 10);
  vertex(width * 0.8, height + 10);
  vertex(width * 0.8 - 40, yCorte + 60);
  vertex(width * 0.75 - 40, yCorte + 60);
  endShape(CLOSE);

  rectMode(CORNER);
  fill(cVerdeMedio);
  rect(width / 2.0 + 35, yCorte + 20, 50, 4);
  rect(width / 2.0 + 95, yCorte + 20, 8, 4);

  fill(cVerde);
  rect(width * 0.2, yCorte + 50, 30, 4);

  stroke(cVerde, 60);
  strokeWeight(1);
  line(width / 2.0 - 140, yCorte + 35, width * 0.15, yCorte + 35);
}

float easeInCubic(float x) {
  return x * x * x;
}

float easeOutCubic(float x) {
  return 1 - pow(1 - x, 3);
}

float easeInBack(float x) {
  float c1 = 1.70158;
  float c3 = c1 + 1;
  return c3 * x * x * x - c1 * x * x;
}

float easeOutBack(float x) {
  return 1.0 - easeInBack(1.0 - x);
}

float easeOutBounce(float t) {
  t = constrain(t, 0.0, 1.0);
  float n1 = 7.5625;
  float d1 = 2.75;
  if (t < 1.0 / d1) {
    return n1 * t * t;
  } else {
    if (t < 2.0 / d1) {
      t -= 1.5 / d1;
      return n1 * t * t + 0.75;
    } else {
      if (t < 2.5 / d1) {
        t -= 2.25 / d1;
        return n1 * t * t + 0.9375;
      } else {
        t -= 2.625 / d1;
        return n1 * t * t + 0.984375;
      }
    }
  }
}

float easeOutElastic(float t) {
  t = constrain(t, 0.0, 1.0);
  if (t <= 0.0) return 0.0;
  if (t >= 1.0) return 1.0;
  return pow(2.0, -10.0 * t) * sin((t * 10.0 - 0.75) * (TWO_PI / 3.0)) + 1.0;
}

String[] popElasticoTexto = new String[16];
float[] popElasticoX = new float[16];
float[] popElasticoY = new float[16];
float[] popElasticoTimer = new float[16];
color[] popElasticoCol = new color[16];
float[] popElasticoEscalaBoost = new float[16];
int[] popElasticoConteoBatch = new int[16];
int numPopupsElasticos = 0;

void eliminarPopupElastico(int idx) {
  for (int k = idx; k < numPopupsElasticos - 1; k++) {
    popElasticoTexto[k] = popElasticoTexto[k + 1];
    popElasticoX[k] = popElasticoX[k + 1];
    popElasticoY[k] = popElasticoY[k + 1];
    popElasticoTimer[k] = popElasticoTimer[k + 1];
    popElasticoCol[k] = popElasticoCol[k + 1];
    popElasticoEscalaBoost[k] = popElasticoEscalaBoost[k + 1];
    popElasticoConteoBatch[k] = popElasticoConteoBatch[k + 1];
  }
  if (numPopupsElasticos > 0) numPopupsElasticos--;
}

void dispararTextoElastico(String txt, float x, float y, color c) {
  if (txt == null || txt.length() == 0) return;

  for (int i = 0; i < numPopupsElasticos; i++) {
    if (popElasticoTimer[i] > 0.58 && dist(popElasticoX[i], popElasticoY[i], x, y) < 65) {
      popElasticoX[i] = lerp(popElasticoX[i], x, 0.5);
      popElasticoY[i] = lerp(popElasticoY[i], y, 0.5);
      popElasticoTimer[i] = 1.0;
      popElasticoConteoBatch[i]++;
      popElasticoEscalaBoost[i] = min(1.45, 1.0 + (popElasticoConteoBatch[i] - 1) * 0.14);
      popElasticoTexto[i] = txt + (popElasticoConteoBatch[i] > 1 ? " x" + popElasticoConteoBatch[i] : "");
      popElasticoCol[i] = c;
      return;
    }
  }

  if (numPopupsElasticos >= 8) {
    eliminarPopupElastico(0);
  }
  if (numPopupsElasticos < 16) {
    int idx = numPopupsElasticos;
    popElasticoTexto[idx] = txt;
    popElasticoX[idx] = x;
    popElasticoY[idx] = y;
    popElasticoTimer[idx] = 1.0;
    popElasticoCol[idx] = c;
    popElasticoEscalaBoost[idx] = 1.0;
    popElasticoConteoBatch[idx] = 1;
    numPopupsElasticos++;
  }
}

void dibujarTextoElasticoFlotante() {
  if (numPopupsElasticos == 0) return;

  pushStyle();
  if (fuenteRetro != null) textFont(fuenteRetro);
  textAlign(CENTER, CENTER);
  textSize(24);

  for (int i = numPopupsElasticos - 1; i >= 0; i--) {
    popElasticoTimer[i] -= 0.025;
    if (popElasticoTimer[i] <= 0) {
      eliminarPopupElastico(i);
      continue;
    }

    float t = 1.0 - popElasticoTimer[i];
    float escX = 1.0;
    float escY = 1.0;
    if (t < 0.2) {
      float p = t / 0.2;
      escX = lerp(1.6, 0.85, p);
      escY = lerp(0.5, 1.25, p);
    } else {
      if (t < 0.45) {
        float p = (t - 0.2) / 0.25;
        escX = lerp(0.85, 1.05, p);
        escY = lerp(1.25, 0.95, p);
      }
    }
    escX *= popElasticoEscalaBoost[i];
    escY *= popElasticoEscalaBoost[i];

    float alphaP = constrain(popElasticoTimer[i] * 380, 0, 255);
    float subY = popElasticoY[i] - easeOutCubic(t) * 55;

    pushMatrix();
    translate(int(popElasticoX[i]), int(subY));
    rotate(sin(t * 14.0) * 0.07 * popElasticoTimer[i]);
    scale(escX, escY);
    fill(0, alphaP);
    text(popElasticoTexto[i], 3, 3);
    fill(red(popElasticoCol[i]), green(popElasticoCol[i]), blue(popElasticoCol[i]), alphaP);
    text(popElasticoTexto[i], 0, 0);
    popMatrix();
  }
  popStyle();
}

boolean esPuntuacionKeyword(String ch) {
  return ch.equals(".") || ch.equals(",") || ch.equals(":") || ch.equals(";") || ch.equals("(") || ch.equals(")") ||
         ch.equals("[") || ch.equals("]") || ch.equals("{") || ch.equals("}") || ch.equals("!") || ch.equals("?") ||
         ch.equals("\"") || ch.equals("*") || ch.equals("/");
}

color getDolusKeywordColor(String palabra, color colBase) {
  if (palabra == null || palabra.length() == 0) return colBase;
  float a = alpha(colBase);

  int ini = 0;
  while (ini < palabra.length()) {
    String ch = palabra.substring(ini, ini + 1);
    if (esPuntuacionKeyword(ch)) {
      ini++;
    } else break;
  }
  int fin = palabra.length();
  while (fin > ini) {
    String ch = palabra.substring(fin - 1, fin);
    if (esPuntuacionKeyword(ch)) {
      fin--;
    } else break;
  }
  if (ini >= fin) return colBase;

  String clave = palabra.substring(ini, fin);
  String lower = strToLower(clave);

  if (lower.equals("tokens") || lower.equals("token") || lower.equals("t")) {
    return color(255, 215, 80, a);
  }

  if (lower.equals("salud") || lower.equals("mental")) {
    return color(253, 95, 85, a);
  }
  if (lower.equals("seguridad")) {
    return color(56, 189, 248, a);
  }
  if (lower.equals("popularidad")) {
    return color(200, 130, 255, a);
  }
  if (lower.equals("reputacion")) {
    return color(251, 146, 60, a);
  }
  if (lower.equals("estadisticas") || lower.equals("estadistica") || lower.equals("stats") || lower.equals("stat")) {
    return color(120, 230, 255, a);
  }

  if (lower.equals("combo") || lower.equals("racha")) {
    return color(250, 204, 21, a);
  }

  if (lower.equals("game") || lower.equals("over") || lower.equals("vida") || lower.equals("vidas")) {
    return color(245, 60, 60, a);
  }

  if (lower.equals("malware") || lower.equals("troll") || lower.equals("trolls") ||
      lower.equals("virus") || lower.equals("amenaza") || lower.equals("amenazas") ||
      lower.equals("corrupcion") || lower.equals("spam") || lower.equals("fuga") ||
      lower.equals("fugas") || lower.equals("desinformacion")) {
    return color(253, 120, 130, a);
  }

  if (lower.equals("inocente") || lower.equals("inocentes") || lower.equals("aliado") || lower.equals("aliados")) {
    return color(140, 230, 180, a);
  }

  boolean tieneDigito = false;
  for (int d = 0; d < lower.length(); d++) {
    if (strEsDigito(lower.substring(d, d + 1))) {
      tieneDigito = true;
      break;
    }
  }
  if (tieneDigito) {
    if (strEndsWith(lower, "t")) return color(255, 215, 80, a);
    return color(74, 222, 128, a);
  }
  if (clave.equals("+") || clave.equals("-") || clave.equals("x")) {
    return color(74, 222, 128, a);
  }

  return colBase;
}

void dibujarLineaDolus(String linea, float x, float y, color colBase, int alignX) {
  if (linea == null || linea.length() == 0) return;
  String[] palabras = dividirTexto(linea, " ");
  int totalPalabras = contarTextos(palabras);
  if (totalPalabras == 0) return;

  float espW = textWidth(" ");
  float anchoTotal = 0;
  for (int i = 0; i < totalPalabras; i++) {
    anchoTotal += textWidth(palabras[i]);
    if (i < totalPalabras - 1) anchoTotal += espW;
  }

  float cursorX = x;
  if (alignX == CENTER) {
    cursorX = x - anchoTotal * 0.5;
  } else {
    if (alignX == RIGHT) {
      cursorX = x - anchoTotal;
    }
  }

  for (int i = 0; i < totalPalabras; i++) {
    String pal = palabras[i];
    color colPalabra = getDolusKeywordColor(pal, colBase);

    fill(0, 160);
    text(pal, cursorX + 1.2, y + 1.2);

    fill(colPalabra);
    text(pal, cursorX, y);

    cursorX += textWidth(pal) + espW;
  }
}

void dibujarLineaDolus(String linea, float x, float y, color colBase) {
  dibujarLineaDolus(linea, x, y, colBase, LEFT);
}

void dibujarCajaTextoAuto(String texto, float cx, float cy, float anchoMax, float altoMax, float tamMax, color colTexto) {
  if (texto == null || texto.length() == 0) return;
  pushStyle();
  if (fuenteRetro != null) textFont(fuenteRetro);

  float tamActual = tamMax;
  float tamMin = 10;
  String[] lineasFinales = new String[128];
  int numLineasFinales = 0;
  float interlineado = tamActual * 1.28;

  while (tamActual >= tamMin) {
    textSize(tamActual);
    interlineado = tamActual * 1.28;
    numLineasFinales = 0;

    String[] bloques = dividirTexto(texto, "\n");
    int numBloques = contarTextos(bloques);
    for (int b = 0; b < numBloques; b++) {
      String[] palabras = dividirTexto(bloques[b], " ");
      int numPalabras = contarTextos(palabras);
      String linea = "";
      for (int i = 0; i < numPalabras; i++) {
        String pal = palabras[i];
        String prueba = (linea.length() == 0) ? pal : linea + " " + pal;
        if (textWidth(prueba) > anchoMax && linea.length() > 0) {
          if (numLineasFinales < 128) {
            lineasFinales[numLineasFinales] = linea;
            numLineasFinales++;
          }
          linea = pal;
        } else {
          linea = prueba;
        }
      }
      if (linea.length() > 0 && numLineasFinales < 128) {
        lineasFinales[numLineasFinales] = linea;
        numLineasFinales++;
      }
    }

    float altoTotal = numLineasFinales * interlineado;
    if (altoTotal <= altoMax) {
      break;
    }
    tamActual -= 1.5;
  }

  textSize(tamActual);
  textAlign(LEFT, CENTER);

  float altoBloque = numLineasFinales * interlineado;
  float startY = cy - (altoBloque / 2.0) + (interlineado / 2.0);

  for (int i = 0; i < numLineasFinales; i++) {
    dibujarLineaDolus(lineasFinales[i], cx, startY + i * interlineado, colTexto, CENTER);
  }
  popStyle();
}

void dibujarLineaOndulada(String linea, float x, float y) {
  float cursorX = x;
  for (int i = 0; i < linea.length(); i++) {
    String ch = linea.substring(i, i + 1);
    float dy = sin(frameCount * 0.12 + i * 0.45) * 1.8;
    text(ch, cursorX, y + dy);
    cursorX += textWidth(ch);
  }
}

void dibujarTextoCascada(String txt, float x, float y, float framesDesdeInicio, color colBase, int alignX, int modoOngoing) {
  if (txt == null || txt.length() == 0) return;
  pushStyle();
  int n = txt.length();
  float anchoTotal = textWidth(txt);
  float startX = x;
  if (alignX == CENTER) startX = x - anchoTotal * 0.5;
  else {
    if (alignX == RIGHT) startX = x - anchoTotal;
  }

  float cursorX = startX;
  float timeSec = frameCount / 60.0;
  float alphaBase = alpha(colBase);

  textAlign(CENTER, CENTER);

  for (int idx = 0; idx < n; idx++) {
    String ch = txt.substring(idx, idx + 1);
    float wChar = textWidth(ch);
    float charCenterX = cursorX + wChar * 0.5;
    cursorX += wChar;

    float t = constrain((framesDesdeInicio - idx * 1.15) / 10.0, 0.0, 1.0);
    if (t <= 0.01) continue;

    float e = easeOutBack(t);
    float inv = 1.0 - e;
    float signoPar = (idx % 2 == 0) ? 1.0 : -1.0;

    float offY = -inv * 18.0;
    float offX = inv * 8.0 * signoPar;
    float rot = radians(95.0) * inv * signoPar;
    float scX = 1.0;
    float scY = 1.0;
    float alphaC = constrain(t * 2.6, 0.0, 1.0) * alphaBase;
    color colFinal = colBase;

    if (t > 0.72 && t < 1.0) {
      float sDrop = (t - 0.72) / 0.28;
      float squish = sin(sDrop * PI) * 0.18;
      scX *= (1.0 + squish);
      scY *= (1.0 - squish);
    }

    if (modoOngoing == 1 || modoOngoing == 3) {

      float phaseW = timeSec * 3.2 + idx * 0.65;
      offY += sin(phaseW) * 2.2;
      rot += sin(timeSec * 2.2 * PI + idx * 0.5) * radians(4.5);
    }
    if (modoOngoing == 2 || modoOngoing == 3) {

      float period = 0.55;
      float phaseSp = ((idx * 37 + 13) % 100) / 100.0 * period;
      float local = (timeSec + phaseSp) % period;
      if (local < 0.22) {
        float sSp = sin((local / 0.22) * PI);
        colFinal = lerpColor(colBase, color(255, 255, 215), sSp * 0.85);
        float pop = 1.0 + sSp * 0.24;
        scX *= pop;
        scY *= pop;
      }
    }
    if (modoOngoing == 4) {

      offX += sin(timeSec * 38.0 + idx * 9.1) * 1.4;
      offY += cos(timeSec * 34.0 + idx * 5.7) * 1.4;
    }

    pushMatrix();
    translate(charCenterX + offX, y + offY);
    rotate(rot);
    scale(scX, scY);
    fill(0, alphaC * 0.7);
    text(ch, 2, 2);
    fill(red(colFinal), green(colFinal), blue(colFinal), alphaC);
    text(ch, 0, 0);
    popMatrix();
  }
  popStyle();
}

int longitudCadenaSegura(String s) {
  if (s == null) return 0;
  return s.length();
}

void dibujarTextoAnimado(String txt, float x, float y, color colBase, int alignX, int modoOngoing) {
  dibujarTextoCascada(txt, x, y, 999.0, colBase, alignX, modoOngoing);
}
