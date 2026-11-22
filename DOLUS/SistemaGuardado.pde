
int[] slotInfoId = {1, 2, 3};
boolean[] slotInfoOcupado = {false, false, false};
String[] slotInfoNombre = {"User_Name", "User_Name", "User_Name"};
String[] slotInfoFecha = {"", "", ""};
int[] slotInfoRonda = {1, 1, 1};
int[] slotInfoDificultad = {1, 1, 1};
float[] slotInfoSaludMental = {50.0, 50.0, 50.0};
float[] slotInfoSeguridad = {50.0, 50.0, 50.0};
float[] slotInfoReputacion = {50.0, 50.0, 50.0};
float[] slotInfoPopularidad = {50.0, 50.0, 50.0};
int[] slotInfoTokens = {0, 0, 0};
int[] slotInfoComboMax = {0, 0, 0};
int[] slotInfoVidas = {1, 1, 1};
int[] slotInfoNumPlugins = {0, 0, 0};
boolean[] slotInfoSecretoRocio = {false, false, false};
boolean[] slotInfoCompletado = {false, false, false};
String[] slotInfoEstadoTexto = {"NUEVA PARTIDA", "NUEVA PARTIDA", "NUEVA PARTIDA"};

int ranuraGuardadoActiva = 1;
int ranuraSeleccionadaHover = -1;

boolean modalNombreActivo = false;
int slotParaNuevoJuego = 1;
String bufferInputNombre = "";
boolean secretoRocioActivado = false;

String feedbackGuardadoTexto = "";
int feedbackGuardadoTimer = 0;
color feedbackGuardadoCol = color(0, 255, 150);

String notifSecretoTexto = "";
int notifSecretoTimer = 0;

String[] leerLineasRanuraSegura(int slot) {
  try {
    return loadStrings(dataPath("save_slot_" + slot + ".json"));
  } catch (Exception e) {
    return null;
  }
}

boolean esArchivoFormatoKV(String[] lineas) {
  if (lineas == null) return false;
  int n = contarTextos(lineas);
  for (int i = 0; i < n; i++) {
    String ln = strTrim(lineas[i]);
    if (ln.length() == 0) continue;
    if (ln.equals("formato=KV1") || ln.equals("ocupado=false")) return true;
    return false;
  }
  return false;
}

String unirLineasParaJson(String[] lineas) {
  if (lineas == null) return "";
  int n = contarTextos(lineas);
  String res = "";
  for (int i = 0; i < n; i++) {
    res += lineas[i] + "\n";
  }
  return res;
}

String kvObtenerValor(String[] lineas, String clave, String def) {
  if (lineas == null) return def;
  String pref = clave + "=";
  int n = contarTextos(lineas);
  for (int i = 0; i < n; i++) {
    String ln = strTrim(lineas[i]);
    if (strStartsWith(ln, pref)) {
      return ln.substring(pref.length(), ln.length());
    }
  }
  return def;
}

String jsonLegacyObtenerRaw(String todo, String clave) {
  if (todo == null || todo.length() == 0) return "";
  String buscado = "\"" + clave + "\"";
  int pos = strIndexOf(todo, buscado);
  if (pos < 0) return "";
  int p = pos + buscado.length();
  int len = todo.length();
  while (p < len && !todo.substring(p, p + 1).equals(":")) {
    p++;
  }
  if (p >= len) return "";
  p++;
  while (p < len) {
    String c = todo.substring(p, p + 1);
    if (c.equals(" ") || c.equals("\t") || c.equals("\n") || c.equals("\r")) {
      p++;
    } else {
      break;
    }
  }
  if (p >= len) return "";
  String ini = todo.substring(p, p + 1);
  if (ini.equals("\"")) {
    p++;
    String res = "";
    while (p < len) {
      String c = todo.substring(p, p + 1);
      if (c.equals("\\") && p + 1 < len) {
        res += todo.substring(p + 1, p + 2);
        p += 2;
      } else {
        if (c.equals("\"")) {
          break;
        } else {
          res += c;
          p++;
        }
      }
    }
    return res;
  } else {
    if (ini.equals("[")) {
      p++;
      String res = "";
      while (p < len) {
        String c = todo.substring(p, p + 1);
        if (c.equals("]")) break;
        res += c;
        p++;
      }
      return res;
    } else {
      String res = "";
      while (p < len) {
        String c = todo.substring(p, p + 1);
        if (c.equals(",") || c.equals("}") || c.equals("\n") || c.equals("\r")) break;
        res += c;
        p++;
      }
      return strTrim(res);
    }
  }
}

String saveLeerStr(String[] lineas, String todoJson, boolean esKV, String clave, String def) {
  if (esKV) {
    return kvObtenerValor(lineas, clave, def);
  }
  String r = jsonLegacyObtenerRaw(todoJson, clave);
  return (r.equals("") ? def : r);
}

int saveLeerInt(String[] lineas, String todoJson, boolean esKV, String clave, int def) {
  String s = saveLeerStr(lineas, todoJson, esKV, clave, "");
  s = strTrim(s);
  if (s.length() == 0) return def;
  return parseInt(s, def);
}

float saveLeerFloat(String[] lineas, String todoJson, boolean esKV, String clave, float def) {
  String s = saveLeerStr(lineas, todoJson, esKV, clave, "");
  s = strTrim(s);
  if (s.length() == 0) return def;
  return parseFloat(s, def);
}

boolean saveLeerBool(String[] lineas, String todoJson, boolean esKV, String clave, boolean def) {
  String s = strToLower(strTrim(saveLeerStr(lineas, todoJson, esKV, clave, "")));
  if (s.equals("true")) return true;
  if (s.equals("false")) return false;
  return def;
}

void inicializarSistemaGuardado() {
  for (int i = 0; i < 3; i++) {
    slotInfoId[i] = i + 1;
  }
  refrescarRanurasGuardado();
}

void refrescarRanurasGuardado() {
  for (int s = 1; s <= 3; s++) {
    int idxSlot = s - 1;
    slotInfoId[idxSlot] = s;
    String[] lineas = leerLineasRanuraSegura(s);
    int numLineas = contarTextos(lineas);
    if (lineas == null || numLineas == 0) {
      slotInfoOcupado[idxSlot] = false;
      slotInfoNombre[idxSlot] = "User_Name";
      slotInfoFecha[idxSlot] = "";
      slotInfoRonda[idxSlot] = 1;
      slotInfoDificultad[idxSlot] = 1;
      slotInfoSaludMental[idxSlot] = 50.0;
      slotInfoSeguridad[idxSlot] = 50.0;
      slotInfoReputacion[idxSlot] = 50.0;
      slotInfoPopularidad[idxSlot] = 50.0;
      slotInfoTokens[idxSlot] = 0;
      slotInfoComboMax[idxSlot] = 0;
      slotInfoVidas[idxSlot] = 1;
      slotInfoNumPlugins[idxSlot] = 0;
      slotInfoSecretoRocio[idxSlot] = false;
      slotInfoCompletado[idxSlot] = false;
      slotInfoEstadoTexto[idxSlot] = "RANURA VACIA";
      continue;
    }

    try {
      boolean esKV = esArchivoFormatoKV(lineas);
      String todoJson = esKV ? "" : unirLineasParaJson(lineas);
      boolean ocupado = saveLeerBool(lineas, todoJson, esKV, "ocupado", true);
      if (!ocupado) {
        slotInfoOcupado[idxSlot] = false;
        slotInfoNombre[idxSlot] = "User_Name";
        slotInfoFecha[idxSlot] = "";
        slotInfoRonda[idxSlot] = 1;
        slotInfoDificultad[idxSlot] = 1;
        slotInfoSaludMental[idxSlot] = 50.0;
        slotInfoSeguridad[idxSlot] = 50.0;
        slotInfoReputacion[idxSlot] = 50.0;
        slotInfoPopularidad[idxSlot] = 50.0;
        slotInfoTokens[idxSlot] = 0;
        slotInfoComboMax[idxSlot] = 0;
        slotInfoVidas[idxSlot] = 1;
        slotInfoNumPlugins[idxSlot] = 0;
        slotInfoSecretoRocio[idxSlot] = false;
        slotInfoCompletado[idxSlot] = false;
        slotInfoEstadoTexto[idxSlot] = "RANURA VACIA";
        continue;
      }

      slotInfoOcupado[idxSlot] = true;
      slotInfoNombre[idxSlot] = saveLeerStr(lineas, todoJson, esKV, "nombreJugador", "User_Name");
      slotInfoFecha[idxSlot] = saveLeerStr(lineas, todoJson, esKV, "fecha", "");
      slotInfoDificultad[idxSlot] = saveLeerInt(lineas, todoJson, esKV, "dificultad", 1);
      slotInfoSecretoRocio[idxSlot] = saveLeerBool(lineas, todoJson, esKV, "secretoRocio", false);

      slotInfoSaludMental[idxSlot] = saveLeerFloat(lineas, todoJson, esKV, "saludMental", 50.0);
      slotInfoSeguridad[idxSlot]   = saveLeerFloat(lineas, todoJson, esKV, "seguridad", 50.0);
      slotInfoReputacion[idxSlot]  = saveLeerFloat(lineas, todoJson, esKV, "reputacion", 50.0);
      slotInfoPopularidad[idxSlot] = saveLeerFloat(lineas, todoJson, esKV, "popularidad", 50.0);
      slotInfoTokens[idxSlot]      = saveLeerInt(lineas, todoJson, esKV, "tokens", 0);
      slotInfoVidas[idxSlot]       = saveLeerInt(lineas, todoJson, esKV, "vidas", 1);
      slotInfoComboMax[idxSlot]    = saveLeerInt(lineas, todoJson, esKV, "comboMax", 0);

      String invRaw = strTrim(saveLeerStr(lineas, todoJson, esKV, "inventarioPlugins", ""));
      if (invRaw.length() > 0) {
        String[] invPartes = dividirTexto(invRaw, ",");
        int cntInv = 0;
        int nPartes = contarTextos(invPartes);
        for (int p = 0; p < nPartes; p++) {
          if (strTrim(invPartes[p]).length() > 0) cntInv++;
        }
        slotInfoNumPlugins[idxSlot] = cntInv + 1;
      } else {
        slotInfoNumPlugins[idxSlot] = 1;
      }

      slotInfoRonda[idxSlot] = saveLeerInt(lineas, todoJson, esKV, "rondaActual", 1);
      slotInfoCompletado[idxSlot] = saveLeerBool(lineas, todoJson, esKV, "completada", false);
      boolean enEpilogo = saveLeerBool(lineas, todoJson, esKV, "enEpilogo", false);
      if (slotInfoCompletado[idxSlot]) {
        slotInfoEstadoTexto[idxSlot] = "COMPLETADO";
      } else {
        if (enEpilogo) {
          slotInfoEstadoTexto[idxSlot] = "EPILOGO: HABITACION";
        } else {
          slotInfoEstadoTexto[idxSlot] = "RONDA " + slotInfoRonda[idxSlot] + "/5";
        }
      }
    } catch (Exception e) {
      slotInfoOcupado[idxSlot] = false;
      slotInfoEstadoTexto[idxSlot] = "ERROR DE LECTURA";
    }
  }
}

void guardarPartidaEnSlot(int slot) {
  if (slot < 1 || slot > 3) return;
  try {
    String fechaStr = nf(year(), 4) + "-" + nf(month(), 2) + "-" + nf(day(), 2) + " " + nf(hour(), 2) + ":" + nf(minute(), 2);
    boolean enEpilogo = (estadoPantalla == PANTALLA_HABITACION || estadoPantalla == PANTALLA_CINEMATICA_FINAL || estadoPantalla == PANTALLA_GLITCH_ESCAPE);

    String invStr = "";
    for (int i = 0; i < numInventarioPlugins; i++) {
      if (i > 0) invStr += ",";
      invStr += inventarioPlugins[i];
    }

    String vouchStr = "";
    for (int v = 0; v < 8; v++) {
      if (v > 0) vouchStr += ",";
      boolean comp = (catalogoVouchersInicializado && vouchComprado[v]);
      vouchStr += (comp ? "true" : "false");
    }

    String nomSafe = strReplace(strReplace(nombreJugador, "\n", " "), "\r", " ");

    String[] salida = new String[29];
    salida[0]  = "formato=KV1";
    salida[1]  = "slot=" + slot;
    salida[2]  = "ocupado=true";
    salida[3]  = "nombreJugador=" + nomSafe;
    salida[4]  = "secretoRocio=" + (secretoRocioActivado ? "true" : "false");
    salida[5]  = "dificultad=" + dificultadSeleccionada;
    salida[6]  = "fecha=" + fechaStr;
    salida[7]  = "saludMental=" + statSaludMental;
    salida[8]  = "seguridad=" + statSeguridad;
    salida[9]  = "reputacion=" + statReputacion;
    salida[10] = "popularidad=" + statPopularidad;
    salida[11] = "tokens=" + tokensDolus;
    salida[12] = "vidas=" + vidasJugador;
    salida[13] = "combo=" + comboActual;
    salida[14] = "comboMax=" + comboMaximoRonda;
    salida[15] = "balanza=" + balanzaEstabilidad;
    salida[16] = "rondaActual=" + rondaActual;
    salida[17] = "mensajesProcesados=" + mensajesProcesadosRonda;
    salida[18] = "jefeActivo=" + jefeActivo;
    salida[19] = "ultimoJefeDerrotado=" + (ultimoJefeDerrotado ? "true" : "false");
    salida[20] = "enEpilogo=" + (enEpilogo ? "true" : "false");
    salida[21] = "habEstadoPuzle=" + habEstadoPuzle;
    salida[22] = "puz1Completado=" + (puz1Completado ? "true" : "false");
    salida[23] = "puz2Completado=" + (puz2Completado ? "true" : "false");
    salida[24] = "habTieneCelular=" + ((habEstadoPuzle >= 2) ? "true" : "false");
    salida[25] = "completada=" + (habBatallaFinalCompletada ? "true" : "false");
    salida[26] = "estadoPantalla=" + estadoPantalla;
    salida[27] = "inventarioPlugins=" + invStr;
    salida[28] = "vouchers=" + vouchStr;

    saveStrings(dataPath("save_slot_" + slot + ".json"), salida);
    refrescarRanurasGuardado();

    feedbackGuardadoTexto = "PARTIDA GUARDADA EN RANURA " + slot;
    feedbackGuardadoTimer = 180;
    feedbackGuardadoCol = color(0, 255, 150);
  } catch (Exception e) {
    println("[SISTEMA GUARDADO ERROR] " + e.getMessage());
  }
}

void guardarPartidaActual() {
  if (modoFeriaActivo || modoExposicionActivo) return;
  if (ranuraGuardadoActiva < 1 || ranuraGuardadoActiva > 3) ranuraGuardadoActiva = 1;
  guardarPartidaEnSlot(ranuraGuardadoActiva);
}

boolean cargarPartidaSlot(int slot) {
  if (slot < 1 || slot > 3) return false;
  String[] lineas = leerLineasRanuraSegura(slot);
  if (lineas == null || contarTextos(lineas) == 0) return false;

  try {
    boolean esKV = esArchivoFormatoKV(lineas);
    String todoJson = esKV ? "" : unirLineasParaJson(lineas);
    if (!saveLeerBool(lineas, todoJson, esKV, "ocupado", true)) return false;

    reiniciarPartidaCompleta();
    ranuraGuardadoActiva = slot;

    nombreJugador = saveLeerStr(lineas, todoJson, esKV, "nombreJugador", "User_Name");
    secretoRocioActivado = saveLeerBool(lineas, todoJson, esKV, "secretoRocio", false);
    dificultadSeleccionada = saveLeerInt(lineas, todoJson, esKV, "dificultad", 1);

    construirArbolAdmin(nombreJugador);
    construirArbolAdminRonda5(nombreJugador);
    construirArbolJefe1(nombreJugador);
    construirArbolJefe2(nombreJugador);
    construirArbolJefe3(nombreJugador);
    construirArbolJefe4(nombreJugador);

    statSaludMental    = saveLeerFloat(lineas, todoJson, esKV, "saludMental", 50.0);
    statSeguridad      = saveLeerFloat(lineas, todoJson, esKV, "seguridad", 50.0);
    statReputacion     = saveLeerFloat(lineas, todoJson, esKV, "reputacion", 50.0);
    statPopularidad    = saveLeerFloat(lineas, todoJson, esKV, "popularidad", 50.0);
    dispSaludMental    = statSaludMental;
    dispSeguridad      = statSeguridad;
    dispReputacion     = statReputacion;
    dispPopularidad    = statPopularidad;
    tokensDolus        = saveLeerInt(lineas, todoJson, esKV, "tokens", 0);
    vidasJugador       = saveLeerInt(lineas, todoJson, esKV, "vidas", 1);
    comboActual        = saveLeerInt(lineas, todoJson, esKV, "combo", 0);
    comboMaximoRonda   = saveLeerInt(lineas, todoJson, esKV, "comboMax", 0);
    balanzaEstabilidad = saveLeerInt(lineas, todoJson, esKV, "balanza", 0);

    numInventarioPlugins = 0;
    String invRaw = strTrim(saveLeerStr(lineas, todoJson, esKV, "inventarioPlugins", ""));
    if (invRaw.length() > 0) {
      String[] invPartes = dividirTexto(invRaw, ",");
      int nInv = contarTextos(invPartes);
      for (int i = 0; i < nInv; i++) {
        String tok = strTrim(invPartes[i]);
        if (tok.length() > 0) {
          int idx = parseInt(tok, -1);
          if (idx >= 1 && idx < numCatalogoPlugins) {
            agregarInventarioPlugin(idx);
          }
        }
      }
    }

    numPluginsJugador = 0;
    if (numCatalogoPlugins > 0) {
      pluginsJugador[numPluginsJugador++] = 0;
    }
    for (int i = 0; i < numInventarioPlugins; i++) {
      int idx = inventarioPlugins[i];
      if (idx >= 0 && idx < numCatalogoPlugins && numPluginsJugador < 16) {
        pluginsJugador[numPluginsJugador++] = idx;
      }
    }
    sincronizarSlotsEquipados();
    recargarDatosPlugins();
    inicializarPluginsGameplay();
    evaluarSinergias();

    String vouchRaw = strTrim(saveLeerStr(lineas, todoJson, esKV, "vouchers", ""));
    if (vouchRaw.length() > 0 && catalogoVouchersInicializado) {
      String[] vPartes = dividirTexto(vouchRaw, ",");
      int nV = min(8, contarTextos(vPartes));
      for (int v = 0; v < nV; v++) {
        vouchComprado[v] = strToLower(strTrim(vPartes[v])).equals("true");
      }
    }

    rondaActual = saveLeerInt(lineas, todoJson, esKV, "rondaActual", 1);
    mensajesProcesadosRonda = saveLeerInt(lineas, todoJson, esKV, "mensajesProcesados", 0);
    jefeActivo = saveLeerInt(lineas, todoJson, esKV, "jefeActivo", 0);
    ultimoJefeDerrotado = saveLeerBool(lineas, todoJson, esKV, "ultimoJefeDerrotado", false);
    boolean enEpilogo = saveLeerBool(lineas, todoJson, esKV, "enEpilogo", false);
    habEstadoPuzle = saveLeerInt(lineas, todoJson, esKV, "habEstadoPuzle", 0);
    puz1Completado = saveLeerBool(lineas, todoJson, esKV, "puz1Completado", false);
    puz2Completado = saveLeerBool(lineas, todoJson, esKV, "puz2Completado", false);
    boolean completada = saveLeerBool(lineas, todoJson, esKV, "completada", false);

    habBatallaFinalCompletada = completada;
    limpiarPluginsConservadosDerrota();
    tutorialTiendaVisto = (rondaActual > 1);
    tutorialTiendaActivo = false;
    detenerTodaMusica();

    if (enEpilogo && !completada) {
      iniciarHabitacionFinal();
      estadoPantalla = PANTALLA_HABITACION;
    } else {
      estadoPantalla = PANTALLA_JUEGO;
      reproducirMusicaUnica(musicaGameplayInicial);
    }

    juegoPausado = false;
    fasePluginsActiva = false;

    dispararTextoElastico("PARTIDA CARGADA // AGENTE: " + nombreJugador, width * 0.5, height * 0.30, color(0, 255, 175));
    if (sonidoTransferenciaExitosa != null) reproducirSFX(sonidoTransferenciaExitosa);
    return true;
  } catch (Exception e) {
    println("[SISTEMA GUARDADO ERROR] Fallo al cargar ranura " + slot + ": " + e.getMessage());
    return false;
  }
}

void borrarSlot(int slot) {
  if (slot < 1 || slot > 3) return;
  try {
    String[] vacio = {"formato=KV1", "ocupado=false"};
    saveStrings(dataPath("save_slot_" + slot + ".json"), vacio);
    if (slot == ranuraGuardadoActiva) {
      limpiarPluginsConservadosDerrota();
    }
    reproducirTap();
    refrescarRanurasGuardado();
    dispararTextoElastico("RANURA " + slot + " BORRADA", width * 0.5, height * 0.30, color(255, 90, 90));
  } catch (Exception e) {
    println("[SISTEMA GUARDADO ERROR] " + e.getMessage());
  }
}

void verificarYActivarSecretoNombre(String nom) {
  if (nom != null && strEqualsIgnoreCase(strTrim(nom), "rocio")) {
    activarSecretoRocio();
  }
}

void activarSecretoRocio() {
  secretoRocioActivado = true;
  tokensDolus += 150;
  statSaludMental = min(100.0, statSaludMental + 25.0);
  statSeguridad   = min(100.0, statSeguridad + 25.0);
  statReputacion  = min(100.0, statReputacion + 25.0);
  statPopularidad = min(100.0, statPopularidad + 25.0);
  dispSaludMental = statSaludMental;
  dispSeguridad   = statSeguridad;
  dispReputacion  = statReputacion;
  dispPopularidad = statPopularidad;
  vidasJugador += 1;

  int extraIdx = otorgarPluginAleatorioExtra();
  String nomP = (extraIdx >= 0 && extraIdx < numCatalogoPlugins)
      ? (plugCatId[extraIdx] + " - " + plugCatNombrePasiva[extraIdx])
      : "SOBRECARGA";

  notifSecretoTexto = "SECRETO ACTIVADO! BIENVENIDA ROCÍO // +150 TOKENS +STATS +PLUGIN: " + nomP;
  notifSecretoTimer = 400;
  if (sonidoTransferenciaExitosa != null) reproducirSFX(sonidoTransferenciaExitosa);
  dispararTextoElastico("SECRETO ROCÍO ACTIVADO!", width * 0.5, height * 0.22, color(255, 215, 80));
  println("[SECRETO] Rocio desbloqueado. Plugin extra: " + nomP);
}

void aplicarBonusRocioSiActivo() {
  if (!secretoRocioActivado) return;
  tokensDolus += 150;
  statSaludMental = max(75.0, statSaludMental + 25.0);
  statSeguridad   = max(75.0, statSeguridad + 25.0);
  statReputacion  = max(75.0, statReputacion + 25.0);
  statPopularidad = max(75.0, statPopularidad + 25.0);
  dispSaludMental = statSaludMental;
  dispSeguridad   = statSeguridad;
  dispReputacion  = statReputacion;
  dispPopularidad = statPopularidad;
  vidasJugador += 1;

  otorgarPluginAleatorioExtra();
}

int otorgarPluginAleatorioExtra() {
  if (numCatalogoPlugins <= 1) return -1;
  int[] pool = new int[32];
  int numPool = 0;
  for (int i = 1; i < numCatalogoPlugins; i++) {
    if (!arrayContieneInt(inventarioPlugins, numInventarioPlugins, i)) {
      if (numPool < 32) pool[numPool++] = i;
    }
  }
  if (numPool == 0) return -1;
  int elegido = pool[int(random(numPool))];
  agregarInventarioPlugin(elegido);

  numPluginsJugador = 0;
  pluginsJugador[numPluginsJugador++] = 0;
  for (int i = 0; i < numInventarioPlugins; i++) {
    int idx = inventarioPlugins[i];
    if (idx >= 0 && idx < numCatalogoPlugins && numPluginsJugador < 16) {
      pluginsJugador[numPluginsJugador++] = idx;
    }
  }
  sincronizarSlotsEquipados();
  recargarDatosPlugins();
  inicializarPluginsGameplay();
  evaluarSinergias();
  return elegido;
}

void actualizarYDibujarPantallaSlots() {
  pushStyle();
  background(4, 9, 8);

  stroke(18, 48, 32, 60);
  strokeWeight(1);
  for (int x = 0; x < width; x += 40) line(x, 0, x, height);
  for (int y = 0; y < height; y += 40) line(0, y, width, y);

  float cx = width * 0.5;

  textAlign(CENTER, TOP);
  if (fuenteRetro != null) textFont(fuenteRetro);

  fill(colorTema());
  textSize(36);
  text("ARCHIVOS DE AGENTE // SELECCION DE RANURA", cx, 40);

  fill(160, 210, 185);
  textSize(14);
  text("SELECCIONA UNA RANURA PARA CONTINUAR TU MISION O COMENZAR UN NUEVO REGISTRO", cx, 86);

  float cardW = min(340, width * 0.28);
  float cardH = 430;
  float cardY = height * 0.50 - cardH * 0.50 + 15;
  float espacio = min(370, width * 0.30);

  ranuraSeleccionadaHover = -1;

  for (int i = 0; i < 3; i++) {
    float cardX = cx + (i - 1) * espacio;

    boolean hover = (mouseX >= cardX - cardW * 0.5 && mouseX <= cardX + cardW * 0.5 &&
                     mouseY >= cardY && mouseY <= cardY + cardH);
    if (hover && !modalNombreActivo) ranuraSeleccionadaHover = i + 1;

    rectMode(CENTER);
    fill(hover ? color(10, 28, 20, 245) : color(6, 16, 12, 235));
    stroke(hover ? color(70, 255, 160) : color(28, 140, 80, 160));
    strokeWeight(hover ? 2.2 : 1.4);
    rect(cardX, cardY + cardH * 0.5, cardW, cardH, 8);

    fill(14, 38, 26);
    noStroke();
    rect(cardX, cardY + 22, cardW - 8, 36, 6);

    textAlign(CENTER, CENTER);
    textSize(18);
    fill(hover ? color(255) : color(180, 240, 200));
    text("RANURA 0" + (i + 1), cardX, cardY + 20);

    if (!slotInfoOcupado[i]) {

      textAlign(CENTER, CENTER);
      textSize(16);
      fill(120, 150, 135);
      text("[RANURA VACIA]", cardX, cardY + cardH * 0.40);
      textSize(12);
      fill(90, 120, 105);
      text("Sin registro de agente.\nListo para nueva transmision.", cardX, cardY + cardH * 0.48);

      float btnW = cardW - 40;
      float btnH = 44;
      float btnY = cardY + cardH - 45;
      boolean hovBtn = (mouseX >= cardX - btnW * 0.5 && mouseX <= cardX + btnW * 0.5 &&
                        mouseY >= btnY - btnH * 0.5 && mouseY <= btnY + btnH * 0.5 && !modalNombreActivo);
      if (hovBtn) cursorSobreElementoClicable = true;

      rectMode(CENTER);
      fill(hovBtn ? color(30, 210, 110) : color(18, 110, 60));
      stroke(hovBtn ? color(255) : color(70, 255, 150));
      strokeWeight(1.5);
      rect(cardX, btnY, btnW, btnH, 6);

      fill(255);
      textSize(16);
      text("NUEVA PARTIDA", cardX, btnY - 2);
    } else {

      textAlign(LEFT, TOP);
      float leftX = cardX - cardW * 0.5 + 20;
      float curY = cardY + 52;

      fill(70, 255, 175);
      textSize(17);
      text("AGENTE: " + slotInfoNombre[i], leftX, curY); curY += 24;

      fill(140, 180, 160);
      textSize(11);
      text("FECHA: " + slotInfoFecha[i], leftX, curY); curY += 20;

      fill(255, 215, 80);
      textSize(13);
      text("ESTADO: " + slotInfoEstadoTexto[i], leftX, curY); curY += 22;

      String difNom = (slotInfoDificultad[i] == 2) ? "DIFICIL" : ((slotInfoDificultad[i] == 3) ? "IMPOSIBLE" : "NORMAL");
      fill(160, 210, 230);
      textSize(12);
      text("MODO: " + difNom + " | VIDAS: " + slotInfoVidas[i], leftX, curY); curY += 22;

      float bW = (cardW - 44) * 0.5 - 6;
      epDibujarMiniBarraStatSlots("SALUD", slotInfoSaludMental[i], leftX, curY, bW, color(80, 255, 150));
      epDibujarMiniBarraStatSlots("SEGURIDAD", slotInfoSeguridad[i], leftX + bW + 12, curY, bW, color(70, 200, 255));
      curY += 34;
      epDibujarMiniBarraStatSlots("REPUTACION", slotInfoReputacion[i], leftX, curY, bW, color(255, 215, 80));
      epDibujarMiniBarraStatSlots("POPULARIDAD", slotInfoPopularidad[i], leftX + bW + 12, curY, bW, color(255, 140, 210));
      curY += 36;

      fill(220, 240, 230);
      textSize(12);
      text("TOKENS: " + slotInfoTokens[i] + "  |  PLUGINS: " + slotInfoNumPlugins[i], leftX, curY); curY += 20;

      if (slotInfoSecretoRocio[i]) {
        fill(255, 160, 230);
        textSize(11);
        text("[SECRETO ROCIO ACTIVO]", leftX, curY);
      }
      curY += 20;

      float btnW = cardW - 40;
      float btnH = 38;
      float btnY = cardY + cardH - 64;

      boolean hovCargar = (mouseX >= cardX - btnW * 0.5 && mouseX <= cardX + btnW * 0.5 &&
                           mouseY >= btnY - btnH * 0.5 && mouseY <= btnY + btnH * 0.5 && !modalNombreActivo);
      if (hovCargar) cursorSobreElementoClicable = true;

      rectMode(CENTER);
      if (slotInfoCompletado[i]) {
        fill(hovCargar ? color(40, 160, 90) : color(20, 90, 50));
        stroke(70, 255, 150);
        rect(cardX, btnY, btnW, btnH, 5);
        fill(255);
        textAlign(CENTER, CENTER);
        textSize(14);
        text("REINICIAR PARTIDA", cardX, btnY - 2);
      } else {
        fill(hovCargar ? color(30, 200, 110) : color(18, 120, 65));
        stroke(hovCargar ? color(255) : color(80, 255, 170));
        rect(cardX, btnY, btnW, btnH, 5);
        fill(255);
        textAlign(CENTER, CENTER);
        textSize(15);
        text("CONTINUAR PARTIDA", cardX, btnY - 2);
      }

      float btnBorrarW = cardW - 40;
      float btnBorrarH = 26;
      float btnBorrarY = cardY + cardH - 24;
      boolean hovBorrar = (mouseX >= cardX - btnBorrarW * 0.5 && mouseX <= cardX + btnBorrarW * 0.5 &&
                           mouseY >= btnBorrarY - btnBorrarH * 0.5 && mouseY <= btnBorrarY + btnBorrarH * 0.5 && !modalNombreActivo);
      if (hovBorrar) cursorSobreElementoClicable = true;

      rectMode(CENTER);
      fill(hovBorrar ? color(160, 30, 30) : color(45, 14, 14));
      stroke(hovBorrar ? color(255, 120, 120) : color(160, 60, 60));
      rect(cardX, btnBorrarY, btnBorrarW, btnBorrarH, 4);

      textAlign(CENTER, CENTER);
      textSize(11);
      fill(hovBorrar ? color(255) : color(220, 160, 160));
      text("BORRAR RANURA", cardX, btnBorrarY - 2);
    }
  }

  float backW = 280;
  float backH = 42;
  float backY = height - 42;
  boolean hovBack = (mouseX >= cx - backW * 0.5 && mouseX <= cx + backW * 0.5 &&
                     mouseY >= backY - backH * 0.5 && mouseY <= backY + backH * 0.5 && !modalNombreActivo);
  if (hovBack) cursorSobreElementoClicable = true;

  rectMode(CENTER);
  fill(hovBack ? color(30, 60, 50) : color(14, 28, 22));
  stroke(hovBack ? color(120, 255, 200) : color(60, 140, 100));
  strokeWeight(1.5);
  rect(cx, backY, backW, backH, 6);

  textAlign(CENTER, CENTER);
  textSize(16);
  fill(hovBack ? color(255) : color(180, 225, 200));
  text("VOLVER AL MENU PRINCIPAL", cx, backY - 2);

  if (modalNombreActivo) {
    dibujarModalInputNombre();
  }

  if (feedbackGuardadoTimer > 0) {
    feedbackGuardadoTimer--;
    textAlign(CENTER, CENTER);
    textSize(16);
    fill(feedbackGuardadoCol);
    text(feedbackGuardadoTexto, cx, height - 85);
  } else {
    if (notifSecretoTimer > 0) {
      notifSecretoTimer--;
      textAlign(CENTER, CENTER);
      textSize(15);
      fill(255, 215, 80);
      text(notifSecretoTexto, cx, height - 85);
    }
  }

  popStyle();
}

void epDibujarMiniBarraStatSlots(String lbl, float val, float x, float y, float w, color col) {
  textAlign(LEFT, TOP);
  textSize(9);
  fill(160, 190, 175);
  text(lbl + ": " + int(val) + "%", x, y);

  rectMode(CORNER);
  fill(10, 24, 18);
  stroke(col, 120);
  strokeWeight(1);
  rect(x, y + 13, w, 7, 2);

  noStroke();
  fill(col);
  rect(x + 1, y + 14, (w - 2) * constrain(val / 100.0, 0.0, 1.0), 5, 2);
}

void dibujarModalInputNombre() {
  rectMode(CORNER);
  noStroke();
  fill(0, 0, 0, 225);
  rect(0, 0, width, height);

  float cx = width * 0.5;
  float cy = height * 0.5;
  float mw = min(580, width * 0.70);
  float mh = 310;

  rectMode(CENTER);
  fill(8, 22, 16, 250);
  stroke(40, 240, 140);
  strokeWeight(2.5);
  rect(cx, cy, mw, mh, 10);

  fill(16, 44, 30);
  noStroke();
  rect(cx, cy - mh * 0.5 + 24, mw - 8, 42, 8);

  textAlign(CENTER, CENTER);
  textSize(18);
  fill(70, 255, 175);
  text(">_ REGISTRO DE IDENTIFICADOR DE RED", cx, cy - mh * 0.5 + 22);

  fill(195, 235, 215);
  textSize(13);
  text("Ingresa tu nombre de agente para iniciar en la Ranura 0" + slotParaNuevoJuego + ".\nEste nombre reemplazara a \"User_Name\" en toda la red.", cx, cy - 65);

  float boxW = mw - 80;
  float boxH = 50;
  float boxY = cy - 2;

  rectMode(CENTER);
  fill(4, 12, 9);
  stroke(60, 255, 160);
  strokeWeight(2);
  rect(cx, boxY, boxW, boxH, 6);

  String displayTxt = bufferInputNombre;
  boolean parpadeo = ((millis() / 450) % 2 == 0);
  if (parpadeo) displayTxt += "_";

  textAlign(CENTER, CENTER);
  textSize(22);
  if (bufferInputNombre.equals("")) {
    fill(100, 140, 120);
    text("User_Name" + (parpadeo ? "_" : ""), cx, boxY - 2);
  } else {
    fill(255);
    text(displayTxt, cx, boxY - 2);
  }

  if (strEqualsIgnoreCase(strTrim(bufferInputNombre), "rocio")) {
    fill(255, 215, 80);
    textSize(12);
    text("★ SECRETO DETECTADO! BONIFICACIÓN Y PLUGIN EXTRA GARANTIZADOS ★", cx, cy + 42);
  } else {
    fill(130, 170, 150);
    textSize(11);
    text("Presiona [ENTER] para confirmar o [ESC] para cancelar", cx, cy + 42);
  }

  float btnW = (boxW - 20) * 0.5;
  float btnH = 40;
  float btnY = cy + 98;

  float btnConfX = cx - btnW * 0.5 - 10;
  float btnCancX = cx + btnW * 0.5 + 10;

  boolean hovConf = (mouseX >= btnConfX - btnW * 0.5 && mouseX <= btnConfX + btnW * 0.5 &&
                     mouseY >= btnY - btnH * 0.5 && mouseY <= btnY + btnH * 0.5);
  boolean hovCanc = (mouseX >= btnCancX - btnW * 0.5 && mouseX <= btnCancX + btnW * 0.5 &&
                     mouseY >= btnY - btnH * 0.5 && mouseY <= btnY + btnH * 0.5);

  if (hovConf || hovCanc) cursorSobreElementoClicable = true;

  rectMode(CENTER);
  fill(hovConf ? color(40, 220, 120) : color(22, 130, 70));
  stroke(hovConf ? color(255) : color(80, 255, 170));
  rect(btnConfX, btnY, btnW, btnH, 5);

  fill(255);
  textSize(15);
  text("CONFIRMAR Y JUGAR", btnConfX, btnY - 2);

  fill(hovCanc ? color(160, 40, 40) : color(60, 20, 20));
  stroke(hovCanc ? color(255, 120, 120) : color(180, 60, 60));
  rect(btnCancX, btnY, btnW, btnH, 5);

  fill(255);
  textSize(15);
  text("CANCELAR", btnCancX, btnY - 2);
}

void confirmarCreacionNuevaPartida() {
  String nombreElegido = strTrim(bufferInputNombre);
  if (nombreElegido.equals("")) {
    nombreElegido = "User_Name";
  }

  ranuraGuardadoActiva = slotParaNuevoJuego;
  nombreJugador = nombreElegido;
  modalNombreActivo = false;

  construirArbolAdmin(nombreJugador);
  construirArbolAdminRonda5(nombreJugador);
  construirArbolJefe1(nombreJugador);
  construirArbolJefe2(nombreJugador);
  construirArbolJefe3(nombreJugador);
  construirArbolJefe4(nombreJugador);

  secretoRocioActivado = false;
  verificarYActivarSecretoNombre(nombreJugador);

  reproducirTap();
  reproducirSFX(sonidoAbsorcionVortice);

  estadoPantalla = PANTALLA_DIFICULTAD;
  animandoDificultad = true;
  progresoDificultad = 0.0;
  progresoQuemarDificultad = 0.0;
  seleccionadoParaJugar = false;
}

void mousePressedPantallaSlots() {
  float cx = width * 0.5;

  if (modalNombreActivo) {
    float cy = height * 0.5;
    float mw = min(580, width * 0.70);
    float boxW = mw - 80;
    float btnW = (boxW - 20) * 0.5;
    float btnH = 40;
    float btnY = cy + 98;

    float btnConfX = cx - btnW * 0.5 - 10;
    float btnCancX = cx + btnW * 0.5 + 10;

    if (mouseX >= btnConfX - btnW * 0.5 && mouseX <= btnConfX + btnW * 0.5 &&
        mouseY >= btnY - btnH * 0.5 && mouseY <= btnY + btnH * 0.5) {
      confirmarCreacionNuevaPartida();
      return;
    }

    if (mouseX >= btnCancX - btnW * 0.5 && mouseX <= btnCancX + btnW * 0.5 &&
        mouseY >= btnY - btnH * 0.5 && mouseY <= btnY + btnH * 0.5) {
      modalNombreActivo = false;
      reproducirTap();
      return;
    }
    return;
  }

  float cardW = min(340, width * 0.28);
  float cardH = 430;
  float cardY = height * 0.50 - cardH * 0.50 + 15;
  float espacio = min(370, width * 0.30);

  for (int i = 0; i < 3; i++) {
    float cardX = cx + (i - 1) * espacio;

    if (!slotInfoOcupado[i]) {
      float btnW = cardW - 40;
      float btnH = 44;
      float btnY = cardY + cardH - 45;
      if (mouseX >= cardX - btnW * 0.5 && mouseX <= cardX + btnW * 0.5 &&
          mouseY >= btnY - btnH * 0.5 && mouseY <= btnY + btnH * 0.5) {
        slotParaNuevoJuego = i + 1;
        bufferInputNombre = "";
        modalNombreActivo = true;
        reproducirTap();
        return;
      }
    } else {
      float btnW = cardW - 40;
      float btnH = 38;
      float btnY = cardY + cardH - 64;
      if (mouseX >= cardX - btnW * 0.5 && mouseX <= cardX + btnW * 0.5 &&
          mouseY >= btnY - btnH * 0.5 && mouseY <= btnY + btnH * 0.5) {
        if (slotInfoCompletado[i]) {
          slotParaNuevoJuego = i + 1;
          bufferInputNombre = slotInfoNombre[i];
          modalNombreActivo = true;
          reproducirTap();
        } else {
          cargarPartidaSlot(i + 1);
        }
        return;
      }

      float btnBorrarW = cardW - 40;
      float btnBorrarH = 26;
      float btnBorrarY = cardY + cardH - 24;
      if (mouseX >= cardX - btnBorrarW * 0.5 && mouseX <= cardX + btnBorrarW * 0.5 &&
          mouseY >= btnBorrarY - btnBorrarH * 0.5 && mouseY <= btnBorrarY + btnBorrarH * 0.5) {
        borrarSlot(i + 1);
        return;
      }
    }
  }

  float backW = 280;
  float backH = 42;
  float backY = height - 42;
  if (mouseX >= cx - backW * 0.5 && mouseX <= cx + backW * 0.5 &&
      mouseY >= backY - backH * 0.5 && mouseY <= backY + backH * 0.5) {
    reproducirTap();
    estadoPantalla = PANTALLA_MENU;
    escupiendoMenu = true;
    progresoEscupidoMenu = 0.0;
    return;
  }
}

void keyPressedPantallaSlots() {
  if (modalNombreActivo) {
    if (key == ENTER || key == RETURN) {
      confirmarCreacionNuevaPartida();
      return;
    }
    if (key == ESC) {
      key = 0;
      modalNombreActivo = false;
      reproducirTap();
      return;
    }
    if (key == BACKSPACE) {
      if (bufferInputNombre.length() > 0) {
        bufferInputNombre = bufferInputNombre.substring(0, bufferInputNombre.length() - 1);
        reproducirTap();
      }
      return;
    }
    if (key >= 32 && key <= 126 && bufferInputNombre.length() < 16) {
      bufferInputNombre += key;
      reproducirTap();
      return;
    }
    return;
  }

  if (key == ESC) {
    key = 0;
    estadoPantalla = PANTALLA_MENU;
    escupiendoMenu = true;
    progresoEscupidoMenu = 0.0;
  }
}
