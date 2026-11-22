import java.io.File;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;

class RegistroFeria {
  String id;
  String nombre;
  String etiqueta;
  int mejorPuntaje;
  int ultimoPuntaje;
  int mejorCombo;
  int mejorCartas;
  int mejorTiempoSeg;
  int mejorNivel;
  int partidasJugadas;
  String fechaRegistro;
  String fechaUltimoIntento;

  RegistroFeria(String id, String nombre, String etiqueta, String fechaRegistro) {
    this.id = id;
    this.nombre = nombre;
    this.etiqueta = (etiqueta == null || etiqueta.trim().length() == 0) ? "Visitante" : etiqueta.trim();
    this.mejorPuntaje = 0;
    this.ultimoPuntaje = 0;
    this.mejorCombo = 0;
    this.mejorCartas = 0;
    this.mejorTiempoSeg = 0;
    this.mejorNivel = 1;
    this.partidasJugadas = 0;
    this.fechaRegistro = fechaRegistro;
    this.fechaUltimoIntento = fechaRegistro;
  }

  JSONObject toJSON() {
    JSONObject obj = new JSONObject();
    obj.setString("id", id);
    obj.setString("nombre", nombre);
    obj.setString("etiqueta", etiqueta);
    obj.setInt("mejorPuntaje", mejorPuntaje);
    obj.setInt("ultimoPuntaje", ultimoPuntaje);
    obj.setInt("mejorCombo", mejorCombo);
    obj.setInt("mejorCartas", mejorCartas);
    obj.setInt("mejorTiempoSeg", mejorTiempoSeg);
    obj.setInt("mejorNivel", mejorNivel);
    obj.setInt("partidasJugadas", partidasJugadas);
    obj.setString("fechaRegistro", fechaRegistro);
    obj.setString("fechaUltimoIntento", fechaUltimoIntento);
    return obj;
  }
}

final int FERIA_CARTAS_POR_OLEADA = 10;
final String FERIA_ARCHIVO_JSON = "feria_ranking.json";
final String FERIA_ARCHIVO_CSV  = "feria_ranking.csv";

boolean modoFeriaActivo = false;
boolean sistemaFeriaInicializado = false;
ArrayList<RegistroFeria> registrosFeria = new ArrayList<RegistroFeria>();
RegistroFeria usuarioFeriaActivo = null;

String feriaInputNombre = "";
String feriaInputEtiqueta = "";
String feriaInputFiltro = "";
int feriaCampoActivo = 1;
int feriaScrollRanking = 0;

String feriaMensajeFeedback = "";
color feriaColorFeedback = 0xFF50FFA0;
int feriaFeedbackTimer = 0;

int feriaPuntaje = 0;
float feriaDispPuntaje = 0;
int feriaCartasResueltas = 0;
int feriaAciertos = 0;
int feriaErrores = 0;
int feriaMejorComboPartida = 0;
int feriaNivelPresion = 1;
int feriaProgresoOleada = 0;
int feriaInicioMs = 0;
int feriaTiempoSobrevividoSeg = 0;
float feriaPulsoPuntaje = 0;
boolean feriaPartidaRegistrada = false;
boolean feriaFueNuevoRecordPersonal = false;
boolean feriaFueNuevoRecordFeria = false;
int feriaPosicionRankingActual = 0;
boolean feriaRecordTop1Notificado = false;
int feriaUltimoRangoSuperado = -1;

ArrayList<String> feriaHistorialMensajes = new ArrayList<String>();

RegistroFeria feriaCrearRegistroDesdeJSON(JSONObject obj) {
  String nom = obj.getString("nombre", "Visitante");
  String id = obj.getString("id", feriaNormalizarId(nom));
  String etiq = obj.getString("etiqueta", "Visitante");
  String fReg = obj.getString("fechaRegistro", feriaTimestampActual());
  RegistroFeria r = new RegistroFeria(id, nom, etiq, fReg);
  r.mejorPuntaje = obj.getInt("mejorPuntaje", 0);
  r.ultimoPuntaje = obj.getInt("ultimoPuntaje", 0);
  r.mejorCombo = obj.getInt("mejorCombo", 0);
  r.mejorCartas = obj.getInt("mejorCartas", 0);
  r.mejorTiempoSeg = obj.getInt("mejorTiempoSeg", 0);
  r.mejorNivel = max(1, obj.getInt("mejorNivel", 1));
  r.partidasJugadas = max(0, obj.getInt("partidasJugadas", 0));
  r.fechaUltimoIntento = obj.getString("fechaUltimoIntento", fReg);
  return r;
}

String feriaTimestampActual() {
  return nf(day(), 2) + "/" + nf(month(), 2) + "/" + year() + " " + nf(hour(), 2) + ":" + nf(minute(), 2);
}

String feriaFormatearTiempo(int seg) {
  int s = max(0, seg);
  return nf(s / 60, 2) + ":" + nf(s % 60, 2);
}

String feriaSanitizarTextoPlano(String s) {
  if (s == null) return "";
  StringBuilder sb = new StringBuilder();
  for (int i = 0; i < s.length(); i++) {
    char c = s.charAt(i);
    if (c >= 32) sb.append(c);
  }
  return sb.toString().trim().replaceAll("\\s+", " ");
}

String feriaNormalizarId(String s) {
  String limpio = feriaSanitizarTextoPlano(s).toLowerCase();
  String de = "áéíóúüñ";
  String a  = "aeiouun";
  StringBuilder norm = new StringBuilder();
  for (int i = 0; i < limpio.length(); i++) {
    char c = limpio.charAt(i);
    int pos = de.indexOf(c);
    if (pos >= 0) c = a.charAt(pos);
    if ((c >= 'a' && c <= 'z') || (c >= '0' && c <= '9')) {
      norm.append(c);
    } else if (c == ' ' || c == '_' || c == '-') {
      if (norm.length() > 0 && norm.charAt(norm.length() - 1) != '_') {
        norm.append('_');
      }
    }
  }
  while (norm.length() > 0 && norm.charAt(norm.length() - 1) == '_') {
    norm.deleteCharAt(norm.length() - 1);
  }
  if (norm.length() == 0) {
    return "u_" + abs(limpio.hashCode());
  }
  return norm.toString();
}

String feriaCsvCampo(String s) {
  if (s == null) return "\"\"";
  return "\"" + s.replace("\"", "\"\"") + "\"";
}

void feriaMostrarFeedback(String msg, color col) {
  feriaMensajeFeedback = msg;
  feriaColorFeedback = col;
  feriaFeedbackTimer = 240;
}

color feriaConAlpha(color c, float a) {
  return color(red(c), green(c), blue(c), a);
}

void ordenarRegistrosFeria() {
  Collections.sort(registrosFeria, new Comparator<RegistroFeria>() {
    public int compare(RegistroFeria a, RegistroFeria b) {
      if (b.mejorPuntaje != a.mejorPuntaje) return b.mejorPuntaje - a.mejorPuntaje;
      if (b.mejorCartas != a.mejorCartas) return b.mejorCartas - a.mejorCartas;
      if (b.mejorCombo != a.mejorCombo) return b.mejorCombo - a.mejorCombo;
      if (b.mejorTiempoSeg != a.mejorTiempoSeg) return b.mejorTiempoSeg - a.mejorTiempoSeg;
      return a.nombre.compareToIgnoreCase(b.nombre);
    }
  });
}

void inicializarSistemaModoFeria() {
  if (sistemaFeriaInicializado) return;
  sistemaFeriaInicializado = true;
  feriaColorFeedback = color(80, 255, 160);
  cargarRegistrosFeria();
}

void cargarRegistrosFeria() {
  registrosFeria.clear();
  try {
    File f = new File(dataPath(FERIA_ARCHIVO_JSON));
    if (!f.exists()) {
      guardarRegistrosFeria();
      return;
    }
    JSONObject root = loadJSONObject(dataPath(FERIA_ARCHIVO_JSON));
    if (root != null && root.hasKey("registros")) {
      JSONArray arr = root.getJSONArray("registros");
      if (arr != null) {
        for (int i = 0; i < arr.size(); i++) {
          JSONObject obj = arr.getJSONObject(i);
          if (obj != null) {
            RegistroFeria reg = feriaCrearRegistroDesdeJSON(obj);
            if (buscarRegistroFeriaPorId(reg.id) == null) {
              registrosFeria.add(reg);
            }
          }
        }
      }
    }
    ordenarRegistrosFeria();
    if (registrosFeria.size() > 0 && usuarioFeriaActivo == null) {
      usuarioFeriaActivo = registrosFeria.get(0);
    }
  } catch (Exception e) {
    println("[MODO FERIA ERROR] No se pudo cargar el ranking: " + e.getMessage());
  }
}

void guardarRegistrosFeria() {
  try {
    File dir = new File(dataPath(""));
    if (!dir.exists()) dir.mkdirs();

    JSONObject root = new JSONObject();
    root.setInt("version", 1);
    root.setString("actualizado", feriaTimestampActual());
    JSONArray arr = new JSONArray();
    for (int i = 0; i < registrosFeria.size(); i++) {
      arr.setJSONObject(i, registrosFeria.get(i).toJSON());
    }
    root.setJSONArray("registros", arr);
    saveJSONObject(root, dataPath(FERIA_ARCHIVO_JSON));

    String[] csv = new String[registrosFeria.size() + 1];
    csv[0] = "Posicion,Nombre,Etiqueta,MejorPuntaje,UltimoPuntaje,MejorCombo,MejorCartas,MejorTiempoSeg,MejorOleada,PartidasJugadas,FechaRegistro,FechaUltimoIntento";
    for (int i = 0; i < registrosFeria.size(); i++) {
      RegistroFeria r = registrosFeria.get(i);
      csv[i + 1] = (i + 1) + ","
        + feriaCsvCampo(r.nombre) + ","
        + feriaCsvCampo(r.etiqueta) + ","
        + r.mejorPuntaje + ","
        + r.ultimoPuntaje + ","
        + r.mejorCombo + ","
        + r.mejorCartas + ","
        + r.mejorTiempoSeg + ","
        + r.mejorNivel + ","
        + r.partidasJugadas + ","
        + feriaCsvCampo(r.fechaRegistro) + ","
        + feriaCsvCampo(r.fechaUltimoIntento);
    }
    saveStrings(dataPath(FERIA_ARCHIVO_CSV), csv);
  } catch (Exception e) {
    println("[MODO FERIA ERROR] No se pudo guardar el ranking: " + e.getMessage());
  }
}

RegistroFeria buscarRegistroFeriaPorId(String id) {
  for (int i = 0; i < registrosFeria.size(); i++) {
    RegistroFeria r = registrosFeria.get(i);
    if (r.id.equals(id)) return r;
  }
  return null;
}

RegistroFeria buscarRegistroFeria(String nombre) {
  String id = feriaNormalizarId(nombre);
  return buscarRegistroFeriaPorId(id);
}

int obtenerPosicionRankingPorId(String id) {
  if (id == null) return 0;
  for (int i = 0; i < registrosFeria.size(); i++) {
    if (registrosFeria.get(i).id.equals(id)) return i + 1;
  }
  return 0;
}

int obtenerMejorPuntajeGlobalFeria() {
  if (registrosFeria.size() == 0) return 0;
  return registrosFeria.get(0).mejorPuntaje;
}

RegistroFeria registrarOSeleccionarUsuarioFeria(String nombreRaw, String etiquetaRaw, boolean soloRegistrar) {
  String nombreLimpio = feriaSanitizarTextoPlano(nombreRaw);
  if (nombreLimpio.length() < 2 || nombreLimpio.length() > 20) {
    feriaMostrarFeedback("EL NOMBRE DEBE TENER ENTRE 2 Y 20 CARACTERES", color(255, 95, 95));
    if (sonidoErrorMsj != null) reproducirSFX(sonidoErrorMsj, 0.5);
    return null;
  }

  String etiqLimpia = feriaSanitizarTextoPlano(etiquetaRaw);
  if (etiqLimpia.length() > 22) {
    etiqLimpia = etiqLimpia.substring(0, 22);
  }

  RegistroFeria existente = buscarRegistroFeria(nombreLimpio);
  if (existente != null) {
    if (etiqLimpia.length() > 0 && !etiqLimpia.equalsIgnoreCase("Visitante")) {
      existente.etiqueta = etiqLimpia;
      guardarRegistrosFeria();
    }
    usuarioFeriaActivo = existente;
    if (soloRegistrar) {
      feriaMostrarFeedback("PERFIL EXISTENTE CARGADO: " + existente.nombre + " (RECORD: " + existente.mejorPuntaje + " PTS)", color(100, 235, 255));
    }
    return existente;
  }

  String id = feriaNormalizarId(nombreLimpio);
  RegistroFeria nuevo = new RegistroFeria(id, nombreLimpio, etiqLimpia, feriaTimestampActual());
  registrosFeria.add(nuevo);
  ordenarRegistrosFeria();
  guardarRegistrosFeria();
  usuarioFeriaActivo = nuevo;
  if (soloRegistrar) {
    feriaMostrarFeedback("PARTICIPANTE GUARDADO PERMANENTEMENTE: " + nuevo.nombre, color(80, 255, 160));
  }
  return nuevo;
}

void eliminarRegistroFeriaPorId(String id) {
  if (!modoDesarrollador) return;
  for (int i = registrosFeria.size() - 1; i >= 0; i--) {
    if (registrosFeria.get(i).id.equals(id)) {
      String nom = registrosFeria.get(i).nombre;
      registrosFeria.remove(i);
      if (usuarioFeriaActivo != null && usuarioFeriaActivo.id.equals(id)) {
        usuarioFeriaActivo = (registrosFeria.size() > 0) ? registrosFeria.get(0) : null;
      }
      ordenarRegistrosFeria();
      guardarRegistrosFeria();
      feriaMostrarFeedback("REGISTRO ELIMINADO [DEV]: " + nom, color(255, 160, 80));
      return;
    }
  }
}

void registrarResultadoPartidaFeria() {
  if (feriaPartidaRegistrada || usuarioFeriaActivo == null) return;
  int topPrev = obtenerMejorPuntajeGlobalFeria();
  boolean habiaTopPrev = (registrosFeria.size() > 0 && topPrev > 0);

  usuarioFeriaActivo.partidasJugadas++;
  usuarioFeriaActivo.ultimoPuntaje = feriaPuntaje;
  usuarioFeriaActivo.fechaUltimoIntento = feriaTimestampActual();

  feriaFueNuevoRecordPersonal = (feriaPuntaje > usuarioFeriaActivo.mejorPuntaje);
  feriaFueNuevoRecordFeria = (!habiaTopPrev && feriaPuntaje > 0) || (feriaPuntaje > topPrev);

  if (feriaPuntaje > usuarioFeriaActivo.mejorPuntaje) {
    usuarioFeriaActivo.mejorPuntaje = feriaPuntaje;
  }
  usuarioFeriaActivo.mejorCombo = max(usuarioFeriaActivo.mejorCombo, feriaMejorComboPartida);
  usuarioFeriaActivo.mejorCartas = max(usuarioFeriaActivo.mejorCartas, feriaCartasResueltas);
  usuarioFeriaActivo.mejorTiempoSeg = max(usuarioFeriaActivo.mejorTiempoSeg, feriaTiempoSobrevividoSeg);
  usuarioFeriaActivo.mejorNivel = max(usuarioFeriaActivo.mejorNivel, feriaNivelPresion);

  ordenarRegistrosFeria();
  feriaPosicionRankingActual = obtenerPosicionRankingPorId(usuarioFeriaActivo.id);
  guardarRegistrosFeria();
  feriaPartidaRegistrada = true;
}

void sincronizarPuntajeFeriaEnPausa() {
  if (!modoFeriaActivo || usuarioFeriaActivo == null) return;
  if (feriaPuntaje > usuarioFeriaActivo.mejorPuntaje) {
    usuarioFeriaActivo.mejorPuntaje = feriaPuntaje;
  }
  usuarioFeriaActivo.ultimoPuntaje = feriaPuntaje;
  usuarioFeriaActivo.mejorCombo = max(usuarioFeriaActivo.mejorCombo, feriaMejorComboPartida);
  usuarioFeriaActivo.mejorCartas = max(usuarioFeriaActivo.mejorCartas, feriaCartasResueltas);
  usuarioFeriaActivo.mejorTiempoSeg = max(usuarioFeriaActivo.mejorTiempoSeg, feriaTiempoSobrevividoSeg);
  usuarioFeriaActivo.mejorNivel = max(usuarioFeriaActivo.mejorNivel, feriaNivelPresion);
  usuarioFeriaActivo.fechaUltimoIntento = feriaTimestampActual();
  ordenarRegistrosFeria();
  guardarRegistrosFeria();
}

void abrirPantallaModoFeria() {
  inicializarSistemaModoFeria();
  cargarRegistrosFeria();
  modoFeriaActivo = false;
  feriaScrollRanking = 0;
  feriaCampoActivo = 1;
  feriaFeedbackTimer = 0;
  feriaMensajeFeedback = "";
  estadoPantalla = PANTALLA_MODO_FERIA;
  if (musicaMenu != null && !musicaMenu.isPlaying()) {
    reproducirMusicaUnica(musicaMenu);
  }
}

void iniciarPartidaModoFeria() {
  if (usuarioFeriaActivo == null) {
    registrarOSeleccionarUsuarioFeria("Visitante_Feria", "Feria", false);
    if (usuarioFeriaActivo == null) return;
  }

  detenerTodaMusica();
  reiniciarPartidaCompleta();
  modoFeriaActivo = true;
  nombreJugador = usuarioFeriaActivo.nombre;
  dificultadSeleccionada = 2;

  statSaludMental = 70.0;
  statSeguridad   = 70.0;
  statReputacion  = 70.0;
  statPopularidad = 70.0;
  dispSaludMental = 70.0;
  dispSeguridad   = 70.0;
  dispReputacion  = 70.0;
  dispPopularidad = 70.0;
  vidasJugador = 1;

  mostrandoTutorial = false;
  mostrandoTutorialIngame = false;
  animandoShowcaseDirectiva = false;
  tutIngameEjecutableVisto = true;
  tutIngameTyposquatVisto = true;
  tutIngameSelloCorpVisto = true;
  tutIngameSobornoVisto = true;
  tutIngameEncriptadaVisto = true;
  tutIngameBombaVisto = true;
  tutIngameContaminadaVisto = true;
  tutEjecutableEnCola = true;
  tutTyposquatEnCola = true;
  tutSelloCorpEnCola = true;
  tutSobornoEnCola = true;
  tutEncriptadaEnCola = true;
  tutBombaEnCola = true;
  tutContaminadaEnCola = true;

  fasePluginsActiva = true;
  diaInicializado = true;
  estadoMusicaGameplay = 0;
  jefeActivo = 0;
  directivaRondaActual = 0;
  rondaActual = 1;

  feriaPuntaje = 0;
  feriaDispPuntaje = 0;
  feriaCartasResueltas = 0;
  feriaAciertos = 0;
  feriaErrores = 0;
  feriaMejorComboPartida = 0;
  feriaNivelPresion = 1;
  feriaProgresoOleada = 0;
  feriaTiempoSobrevividoSeg = 0;
  feriaPulsoPuntaje = 0;
  feriaPartidaRegistrada = false;
  feriaFueNuevoRecordPersonal = false;
  feriaFueNuevoRecordFeria = false;
  feriaPosicionRankingActual = obtenerPosicionRankingPorId(usuarioFeriaActivo.id);
  feriaUltimoRangoSuperado = (feriaPosicionRankingActual > 0) ? feriaPosicionRankingActual : registrosFeria.size() + 1;
  feriaRecordTop1Notificado = (obtenerMejorPuntajeGlobalFeria() == 0);
  feriaHistorialMensajes.clear();

  pausaAcumuladaMs = 0;
  feriaInicioMs = millisJuego();

  estadoPantalla = PANTALLA_JUEGO;
  reproducirMusicaUnica(musicaGameplayInicial);

  for (int i = 0; i < 3; i++) {
    generarMensajeModoFeria();
  }
  intentarAsignarMensaje();
  timerNuevoMensaje = obtenerIntervaloSpawnFeria();
  dispararTextoElastico("MODO FERIA // " + strToUpper(usuarioFeriaActivo.nombre), width * 0.58, height * 0.28, colorTema());
}


float obtenerFactorVelocidadFeria() {
  return 1.0 + 3.6 * (1.0 - exp(-feriaCartasResueltas / 42.0));
}

float obtenerDecaimientoCartaFeria(int msg) {
  float vel = obtenerFactorVelocidadFeria();
  float base = 0.0020 * vel;
  if (msg >= 0) {
    if (msgCategoriaEspecial[msg] == 2 && msgNivelEncriptado[msg] > 0.0) {
      base *= 0.50;
    } else if (msgCategoriaEspecial[msg] == 4) {
      base *= 0.48;
    } else if (msgCategoriaEspecial[msg] == 3) {
      base *= 1.32;
    }
  }
  return constrain(base, 0.0018, 0.0115);
}

int obtenerIntervaloSpawnFeria() {
  float t = constrain(feriaCartasResueltas / 55.0, 0.0, 1.0);
  return int(constrain(lerp(52, 14, t), 14, 52));
}

float obtenerMultiplicadorDanoFeria() {
  return 1.0 + min(max(0, feriaNivelPresion - 1), 8) * 0.12;
}

int obtenerPosicionVivaJugadorFeria() {
  int rank = 1;
  for (int i = 0; i < registrosFeria.size(); i++) {
    RegistroFeria r = registrosFeria.get(i);
    if (usuarioFeriaActivo != null && r.id.equals(usuarioFeriaActivo.id)) continue;
    int scoreComp = r.mejorPuntaje;
    if (scoreComp > feriaPuntaje) {
      rank++;
    }
  }
  return rank;
}

void sumarPuntosFeria(int pts, String etiquetaFlotante) {
  if (pts <= 0) return;
  int topGlobal = obtenerMejorPuntajeGlobalFeria();
  int prevPuntaje = feriaPuntaje;
  feriaPuntaje += pts;
  feriaPulsoPuntaje = 1.0;

  if (etiquetaFlotante != null && etiquetaFlotante.length() > 0) {
    dispararTextoElastico(etiquetaFlotante, width * 0.64, height * 0.31, color(100, 255, 195));
  }

  if (!feriaRecordTop1Notificado && topGlobal > 0 && prevPuntaje <= topGlobal && feriaPuntaje > topGlobal) {
    feriaRecordTop1Notificado = true;
    dispararTextoElastico("NUEVO RECORD #1 DE LA FERIA!", width * 0.64, height * 0.25, color(255, 220, 75));
    dispararRayoFlourish(width * 0.64, height * 0.25, color(255, 220, 75), 1);
    if (sonidoLogro != null) reproducirSFX(sonidoLogro);
  } else {
    int posViva = obtenerPosicionVivaJugadorFeria();
    if (feriaUltimoRangoSuperado > 0 && posViva < feriaUltimoRangoSuperado) {
      feriaUltimoRangoSuperado = posViva;
      dispararTextoElastico("SUBISTE AL PUESTO #" + posViva + "!", width * 0.64, height * 0.26, color(80, 235, 255));
    }
  }
}

void verificarSubidaOleadaFeria() {
  if (feriaProgresoOleada < FERIA_CARTAS_POR_OLEADA) return;
  feriaProgresoOleada = 0;
  feriaNivelPresion++;
  rondaActual = feriaNivelPresion;
  resetearMensajesUsadosRonda();

  int bonoOleada = 250 * feriaNivelPresion;
  feriaPuntaje += bonoOleada;
  feriaPulsoPuntaje = 1.0;

  statSaludMental = min(100.0, statSaludMental + 6.0);
  statSeguridad   = min(100.0, statSeguridad + 6.0);
  statReputacion  = min(100.0, statReputacion + 6.0);
  statPopularidad = min(100.0, statPopularidad + 6.0);
  pulsarBarraStat(0);
  pulsarBarraStat(1);
  pulsarBarraStat(2);
  pulsarBarraStat(3);

  float vel = obtenerFactorVelocidadFeria();
  dispararSacudidaCamara(7.5);
  dispararRayoFlourish(width * 0.64, height * 0.36, color(255, 215, 75), 1);
  dispararExplosionCarta(width * 0.64, height * 0.36, colorTema(), true);
  dispararTextoElastico("OLEADA " + feriaNivelPresion + " // VEL x" + nf(vel, 1, 1) + " // +" + bonoOleada + " PTS!", width * 0.64, height * 0.29, color(255, 215, 80));
  if (sonidoTransferenciaExitosa != null) reproducirSFX(sonidoTransferenciaExitosa);
}

void procesarResultadoDecisionFeria(int decision, int msg, boolean esAcierto, boolean esError) {
  feriaCartasResueltas++;
  if (comboActual > feriaMejorComboPartida) {
    feriaMejorComboPartida = comboActual;
  }

  if (esAcierto) {
    feriaAciertos++;
    feriaProgresoOleada++;
    int base = (msg >= 0 && msgCategoriaEspecial[msg] > 0) ? 220 : ((msg >= 0 && msgTipoMensaje[msg] == TIPO_MENSAJE_CAPCIOSO) ? 150 : 100);
    float restante = (msg >= 0) ? constrain(msgTiempoRestante[msg], 0.0, 1.0) : 0.0;
    int bonoVel = int(restante * 100);
    float multCombo = 1.0 + min(comboActual, 30) * 0.10;
    float multOleada = 1.0 + (feriaNivelPresion - 1) * 0.15;
    int pts = round((base + bonoVel) * multCombo * multOleada);
    sumarPuntosFeria(pts, "+" + pts + " PTS");
    verificarSubidaOleadaFeria();
  } else if (esError) {
    feriaErrores++;
  }
}

void procesarSobornoFeria(boolean aceptado) {
  feriaCartasResueltas++;
  if (aceptado) {
    feriaAciertos++;
    sumarPuntosFeria(400, "SOBORNO +400 PTS!");
  } else {
    feriaAciertos++;
    feriaProgresoOleada++;
    comboActual++;
    pulsoComboUI = 1.0;
    tiempoComboRestante = MAX_TIEMPO_COMBO;
    if (comboActual > feriaMejorComboPartida) feriaMejorComboPartida = comboActual;
    sumarPuntosFeria(150, "LIMPIO +150 PTS");
    verificarSubidaOleadaFeria();
  }
}

void procesarPurgaContaminadaFeria() {
  feriaCartasResueltas++;
  feriaAciertos++;
  feriaProgresoOleada++;
  if (comboActual > feriaMejorComboPartida) feriaMejorComboPartida = comboActual;
  int pts = round(300 * (1.0 + (feriaNivelPresion - 1) * 0.15));
  sumarPuntosFeria(pts, "PURGA +" + pts + " PTS!");
  verificarSubidaOleadaFeria();
}

void procesarErrorContaminadaFeria() {
  feriaCartasResueltas++;
  feriaErrores++;
}

void otorgarPuntosQTEFeria(int pts) {
  if (!modoFeriaActivo) return;
  if (comboActual > feriaMejorComboPartida) feriaMejorComboPartida = comboActual;
  sumarPuntosFeria(pts, "QTE +" + pts + " PTS!");
}


final String[] FERIA_TYPOS_WEB = {
  "d0lus@net", "do1us@net", "dolus@met", "dolsu@net",
  "dolus@n3t", "dolus@net.", "dolu5@net", "dolus-vip@net"
};

final String[] FERIA_TYPOS_CORP = {
  "d0lus@corp", "dolus@c0rp", "do1us@corp", "dolus@corq",
  "doluss@corp", "dolus@corp.", "dolus-hq@corp", "d0lus@c0rp"
};

final String[][] FERIA_CAPCIOSO_WEB_BUENAS = {
  {"BUG // FALSO VIRUS VISUAL", "Me asusto un pantallazo glitch en la cabina 2, pero solo era un efecto retro del nivel. Paso captura."},
  {"TORNEO // ROBO EN SEMIFINAL", "Nos robaron esa ronda con un parry al ultimo frame jaja! Comparto la foto oficial del marcador."},
  {"HACK LEGAL // SPEEDRUN", "En categoria libre si vale usar ese salto de pared para romper el reloj, dejo guia en PDF."},
  {"BAN // PERSONAJE ROTO", "Estan baneando al robot rojo en las retas de la feria porque hace combo infinito, paso tabla."},
  {"EXPLOIT // EASTER EGG", "Si metes el codigo secreto en creditos aparece un mensaje oculto del equipo Blacklist, esta genial!"},
  {"ALERTA // CRASH SIMULADO", "El jefe 3 fingio apagar el monitor y casi reinicio la PC jajaja, buenisima broma del diseño."},
  {"FORO // CLAVE DEL ACERTIJO", "No encontraba el cuarto digito de la boveda hasta que anote los descartes en mi libreta, 10/10!"},
  {"MALWARE // DEMO CYBER", "Que buen susto da la alerta falsa de virus cuando fallas en la demo, la gente se rie en el stand."},
  {"CHAT // PICO DE ADRENALINA", "A velocidad x3 casi me da un infarto deslizando tarjetas, pero logre superar mi record en la feria!"},
  {"SPAM // CHISTE INTERNO", "Tanto cafe en el stand ya parece ataque DDOS a mi pulso jaja, nos vemos en la siguiente ronda."},
  {"SOPORTE // CONTRASENA OLVIDADA", "No me acuerdo si use mayusculas en mi alias del ranking, menos mal la lista guarda mi mejor marca."},
  {"DM // TROFEO PERDIDO", "Pense que habia perdido mi insignia al salir, pero al volver a entrar ahi seguia intacta."},
  {"FERIA // AUDIO ALTO", "Subanle un poco al subwoofer del pasillo central, la musica intensa de los combos suena brutal!"},
  {"LAN // CAIDA DE CABLE", "Alguien tropezo con el cable de la lampara y pensamos que se apago el torneo jajaja, todo normal."},
  {"INDIE // NIVEL IMPOSIBLE", "Probe la dificultad extrema del algoritmo y dure 40 segundos, necesito revancha con la gente viendo."},
  {"FEED // MEME DEL STAND", "Cuando apruebas un .PDF.EXE sin mirar la extension y te toca minijuego de malware en frente de todos."}
};

final String[][] FERIA_CAPCIOSO_CORP_BUENAS = {
  {"INCIDENTE // ATAQUE CONTENIDO", "Se intercepto y bloqueo un escaneo hostil externo antes de tocar las cabinas. Red 100% operativa."},
  {"ANTIVIRUS // CUARENTENA OK", "Archivo sospechoso aislado en servidor de pruebas sin afectar los puntajes oficiales de la feria."},
  {"ALARMA // SIMULACRO PROGRAMADO", "La alerta roja de hace un minuto fue prueba rutinaria de jueces. Continua la competencia normal."},
  {"EMERGENCIA // CAMBIO DE NODO", "Enlace principal migrado a servidor LAN local para garantizar 0 ms de latencia durante el ranking."},
  {"AUDITORIA // LIMPIEZA TOTAL", "Escaneo heuristico terminado en los 6 puestos del stand: cero archivos ejecutables detectados."},
  {"SEGURIDAD // ROTACION LLAVES", "Credenciales administrativas renovadas tras la ronda anterior conforme al protocolo del evento."},
  {"SERVIDOR // PICO DE VISITAS", "Alto volumen de registros en el marcador de la feria; sincronizacion permanente confirmada."},
  {"RESPALDO // COPIA SEGURA", "Guardado automatico de tabla CSV y JSON verificado correctamente sin corrupcion de datos."},
  {"RED // BLOQUEO PREVENTIVO", "Dominios falsos de imitacion agregados a la lista negra por el equipo de infraestructura."},
  {"MANTENIMIENTO // PARCHE APLICADO", "Correccion en caliente desplegada antes de abrir jornada vespertina. Estabilidad al 100%."},
  {"SISTEMA // INSPECCION OK", "Verificacion de integridad en terminales de exhibicion completada sin anomalias criticas."},
  {"PANEL // ACTA VALIDADA", "Registros de mejores puntajes de la tarde firmados y archivados por coordinacion del evento."}
};

final String[][] FERIA_CAPCIOSO_TYPO_TXT = {
  {"SALUDOS // BIENVENIDA FERIA", "Muchas gracias por acercarte al stand de Digital Balance! Esperamos disfrutes la experiencia."},
  {"EVENTO // HORARIO DE CHARLAS", "Recuerda que las presentaciones de proyectos estudiantiles continuan en el auditorio principal."},
  {"TROFEO // REGISTRO EXITOSO", "Tu puntuacion actual ya quedo sincronizada en el tablero oficial de participantes destacados."},
  {"COMUNIDAD // FOTO DEL PODIO", "Que gran energia se siente hoy en la feria universitaria, aqui va una foto limpia del equipo!"},
  {"STAFF // AGUA Y DESCANSO", "Toma un respiro entre rondas y revisa bien el remitente antes de aceptar cualquier mensaje."},
  {"TORNEO // FELICITACIONES", "Increible racha de aciertos! Sigue cuidando tus cuatro barras para pelear por el primer puesto."},
  {"FEED // RESENA POSITIVA", "Me encanto la fluidez de las tarjetas y los efectos de rayos, excelente proyecto de programacion!"},
  {"SOPORTE // RECORD GUARDADO", "Tu alias quedo guardado para que puedas volver luego a intentar batir el puntaje maximo."},
  {"INDIE // RECOMENDACION", "Si te gusto la estetica retro de terminal, pasa por el pasillo de software para ver mas demos."},
  {"EVENTO // CIERRE DE JORNADA", "Felicidades a todos los asistentes por participar en el reto de moderacion algoritmica."},
  {"LAN // BUENA DEPORTIVIDAD", "Gran ambiente competitivo hoy frente a la pantalla, saludos a todos los retadores de la tarde!"},
  {"SISTEMA // ESTADO SALUDABLE", "Todos los indicadores del stand funcionan en verde. Mucha suerte superando la oleada actual!"},
  {"FORO // CONSEJO AMISTOSO", "Mantener el combo alto multiplica bastante tus puntos por carta, animo con la remontada!"},
  {"CORREO // AVISO GENERAL", "Gracias a los profesores y visitantes que se detienen a probar el simulador en vivo."}
};

final String[][] FERIA_CAPCIOSO_DOBLE_EXT = {
  {"RECUERDO // FOTO DEL STAND", "Saliste genial en la captura de la feria! Aqui te adjunto el archivo listo para ver.", ".png.bat"},
  {"GUIA // ATAJOS DE TECLADO", "Te comparto la ficha rapida de controles del torneo para que rompas tu propio record.", ".pdf.exe"},
  {"ACTA // TABLA DE PUNTAJES", "Listado limpio de posiciones parciales de la tarde para revisar con tu equipo.", ".doc.zip"},
  {"FANART // DIBUJO DEL JEFE", "Un visitante dibujo al Administrador en pixel art entre partidas, mira que detalle tan bueno!", ".jpg.exe"},
  {"NOTAS // ESTRATEGIA PRO", "Apuntes rapidos sobre como leer sellos en velocidad x3 sin perder reputacion.", ".txt.bat"},
  {"EVENTO // CRONOGRAMA FERIA", "Horarios confirmados de exposicion y premiacion final en el recinto universitario.", ".pdf.exe"},
  {"MANUAL // VERSION DE BOLSILLO", "Resumen ilustrado de cartas especiales y reglas de moderacion para nuevos visitantes.", ".doc.zip"},
  {"CAPTURA // RECORD x40", "Foto directa del tablero marcando combo x40 sin un solo fallo en cabina 1!", ".png.bat"},
  {"REPORTE // ESTADO DE SALA", "Informe verificado de asistencia y flujo de visitantes durante el bloque de la mañana.", ".pdf.exe"},
  {"MUSICA // TRACKLIST OFICIAL", "Lista de nombres de los temas electronicos usados en las oleadas intensas.", ".txt.bat"},
  {"LOGO // VECTOR DIGITAL BALANCE", "Logotipo oficial en alta calidad para las diapositivas de cierre de presentacion.", ".png.bat"},
  {"ENCUESTA // PROYECTOS 2026", "Documento informativo con el enlace interno del stand para evaluar la demostracion.", ".pdf.exe"},
  {"UTILIDAD // ARCHIVO DIRECTO", "Paquete con recursos de practica para probar el reto sin presion fuera de tarima.", ".exe"},
  {"BACKUP // SCRIPT DE CABINA", "Paquete de respaldo de prueba subido por un asistente sin autorizacion del administrador.", ".zip"}
};

final String[][] FERIA_CAPCIOSO_CORP_SIN_SELLO = {
  {"INFORME // SINCRONIA OK", "Conteo oficial de puntos completado correctamente en el nodo central de la feria."},
  {"SISTEMA // VERIFICACION DIARIA", "Las terminales de exhibicion pasaron la prueba de arranque sin errores de audio ni grafico."},
  {"STAFF // TURNO DE TARDE", "Cambio de anfitriones en el stand realizado puntualmente segun el cronograma acordado."},
  {"AUDITORIA // FLUJO LIMPIO", "Todos los mensajes de prueba emitidos durante la ultima hora cumplen la normativa interna."},
  {"INFRA // RED ESTABLE", "Consumo de memoria estable y latencia en cero dentro del entorno local del evento."},
  {"ACTA // REGISTRO SEGURO", "Lista de visitantes inscritos actualizada correctamente en el respaldo institucional."},
  {"COORDINACION // FELICITACION", "Excelente respuesta de los participantes en la demostracion interactiva de hoy."},
  {"PANEL // VALIDACION FINAL", "Acta tecnica archivada para revision del jurado academico en el cierre de feria."},
  {"BACKUP // TABLA CSV LISTA", "Exportacion automatica de puntuaciones preparada para consultar despues del evento."},
  {"SEGURIDAD // REGLA RECORDADA", "Recuerda verificar siempre el sello autentico en toda comunicacion administrativa."},
  {"SOPORTE // EQUIPO EN LINEA", "Estacion lista y calibrada para continuar recibiendo jugadores en el recinto."},
  {"RESUMEN // INDICADORES VERDES", "Metricas generales de la jornada dentro de los margenes esperados por organizacion."}
};

final String[][] FERIA_CAPCIOSO_PHISHING_DULCE = {
  {"PREMIO // REGALO DEL STAND", "Nos alegro verte jugando hoy! Solo pasame tu clave personal aqui para darte un premio extra."},
  {"ENCUESTA // VOTO DOBLE", "Gracias por apoyarnos en la feria! Inicia sesion con tu correo y contraseña en este boton externo."},
  {"AMIGO // RESCATE DE PUNTAJE", "Vas super bien en el ranking! Enviame tu pin de acceso y te subo 500 puntos por detras."},
  {"TORNEO // FELICITACION RARA", "Muy bonito tu avatar de agente, aunque jugaste pesimo y das pena frente a todo el publico."},
  {"SOPORTE // ACTUALIZAR FICHA", "Que gusto saludarte! Confirma aqui tu contraseña privada para que no se borre tu record luego."},
  {"SORTEO // CAMISETA OFICIAL", "Ganaste un recuerdo de la feria! Solo deposita 20 tokens en esta cuenta externa para reclamarlo."},
  {"COMPANERO // AYUDA URGENTE", "Hola crack! Prestame un momento tu usuario y clave de jurado para probar el modo oculto."},
  {"CRITICA // DISFRAZADA", "Increible proyecto chicos, lastima que nadie los soporta y mejor borren la cuenta del evento jaja."},
  {"VIP // ACCESO BACKSTAGE", "Excelente participacion hoy! Introduce los datos de tu tarjeta aqui para desbloquear el pase."},
  {"COMUNIDAD // RUMOR FALSO", "Que linda tarde! Vayamos todos a reportar en masa al top 1 para que pierda su posicion."},
  {"PROMO // BONO SECRETO", "Por ser visitante #100 te regalamos tokens gratis si escribes tu clave en el chat publico."},
  {"CLAN // INVITACION TRAMPA", "Juegas como profesional! Valida tus credenciales privadas en este formulario corto para entrar."},
  {"FELICITACION // SABOTAJE", "Brutal puntuacion llevas! Ojala te explote el teclado en vivo y quedes ultimo por manco."},
  {"EVENTO // RENOVAR PULSERA", "Bienvenido de nuevo! Manda tu token de recuperacion privado por DM para validar tu turno."}
};

final String[][] FERIA_CAPCIOSO_SELLO_MALWARE = {
  {"SALUDO // BIENVENIDO AL STAND", "Muchas gracias por detenerte a jugar Digital Balance! Disfruta la ronda infinita."},
  {"TORNEO // MUCHA SUERTE", "Todo nuestro animo para tu partida actual, esperemos rompas la barrera de la oleada 5!"},
  {"COMUNIDAD // FELIZ FERIA", "Que ambiente tan chevere hay hoy probando juegos hechos en clase de programacion."},
  {"EQUIPO // AGRADECIMIENTO", "Gracias a cada visitante y jurado por probar nuestro simulador de moderacion."},
  {"FORO // CONSEJO DE CALMA", "Respira hondo cuando suba la velocidad, la precision vale mas que deslizar a ciegas."},
  {"EVENTO // JORNADA ACADEMICA", "Esperamos que esta demostracion te resulte entretenida y retadora en cada tarjeta."},
  {"AVISO // TARJETA INOCENTE", "Hola! Solo pasaba a saludar al moderador de turno y desearle exito en su marcador."},
  {"CAMPUS // ENERGIA POSITIVA", "Saludos a todos los compañeros disfrutando los proyectos interactivos de la tarde."},
  {"TEST // MENSAJE AMABLE", "Una pausa amigable en tu bandeja para recordar que leas hasta el ultimo rincon de la carta."},
  {"CIERRE // HASTA PRONTO", "Nos vemos en la siguiente partida si decides intentar superar tu propio puntaje maximo!"}
};

String[] elegirPlantillaFeriaSinRepetir(String[][] pool) {
  ArrayList<Integer> libres = new ArrayList<Integer>();
  for (int i = 0; i < pool.length; i++) {
    String llave = pool[i][0] + "|" + pool[i][1];
    if (!feriaHistorialMensajes.contains(llave)) {
      libres.add(i);
    }
  }
  int elegido = (libres.size() > 0)
    ? libres.get(int(random(libres.size())))
    : int(random(pool.length));

  String llaveElegida = pool[elegido][0] + "|" + pool[elegido][1];
  if (!feriaHistorialMensajes.contains(llaveElegida)) {
    feriaHistorialMensajes.add(llaveElegida);
    if (feriaHistorialMensajes.size() > 90) {
      for (int k = 0; k < 45; k++) {
        feriaHistorialMensajes.remove(0);
      }
    }
  }
  return pool[elegido];
}

int construirCartaEspecialFeria(int catEsp) {
  if (catEsp == 1) {
    int m = crearMensajeDolus("sponsor_vip", "", 1);
    msgTipoMensaje[m] = TIPO_MENSAJE_CAPCIOSO;
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
    msgEtiquetaMeta[m] = "SOBORNO: +400 PTS";
    String[] conts = {
      "PATROCINIO DE FERIA: Aprueba este anuncio pagado y suma +400 PTS directos (sacrifica Reputacion y Seguridad).",
      "TRATO RELAMPAGO: Deja pasar este post VIP por +400 PTS inmediatos en el marcador oficial.",
      "CANJE CORRUPTO: Haz la vista gorda con esta promo y gana +400 PTS al instante (riesgo de barras)."
    };
    msgRemitente[m] = elegirRemitenteSinRepetir(REMS_GAMER_SOSPECHOSOS);
    msgContenido[m] = conts[int(random(conts.length))];
    msgTiempoRestante[m] = 1.0;
    return m;
  } else if (catEsp == 2) {
    boolean esMalo = (random(1) < 0.55);
    boolean usarCorp = !esMalo && (random(1) < 0.45);
    int m = crearMensajeDolus(esMalo ? "nodo_oculto_404" : "tecnico_feria", "...", esMalo ? 2 : 0);
    msgTipoMensaje[m] = TIPO_MENSAJE_CAPCIOSO;
    msgCategoriaEspecial[m] = 2;
    msgNivelEncriptado[m] = 1.0;
    msgTiempoRestante[m] = 1.45;
    msgDominio[m] = esMalo ? "darknet@onion" : (usarCorp ? "dolus@corp" : "dolus@net");
    msgAsunto[m] = usarCorp ? "SYS // PAQUETE CIFRADO" : "WEB // PAQUETE CIFRADO";
    msgIndiceSello[m] = usarCorp ? 0 : 4;
    msgTieneAdjunto[m] = true;
    msgIndiceArchivo[m] = esMalo ? 4 : 0;
    msgExtensionArchivo[m] = esMalo ? ".bat" : ".pdf";
    msgEsCorporativo[m] = usarCorp;
    msgEsValido[m] = !esMalo;
    msgMotivoInvalidez[m] = esMalo ? 4 : 0;
    msgEtiquetaMeta[m] = "CLIC RAPIDO P/ DESCIFRAR";
    String[][] mal = {
      {"WEB // PAQUETE CIFRADO", "Inyeccion silenciosa intentando alterar los marcadores de la feria."},
      {"WEB // PAQUETE CIFRADO", "Script oculto tratando de capturar llaves de acceso de los stands."}
    };
    String[][] ok = {
      {"SYS // NODO ENCRIPTADO", "Reporte cifrado limpio: el trafico de este sector es 100% legitimo."},
      {"WEB // NODO ENCRIPTADO", "Acta protegida del torneo indie: puntuaciones verificadas sin alteraciones."}
    };
    String[] pl = elegirPlantillaFeriaSinRepetir(esMalo ? mal : ok);
    msgAsunto[m] = pl[0];
    msgContenido[m] = pl[1];
    return m;
  } else if (catEsp == 3) {
    boolean esMalo = (random(1) < 0.60);
    boolean usarCorp = !esMalo && (random(1) < 0.45);
    int m = crearMensajeDolus(esMalo ? "exploit_c4" : "pulso_stand", "...", esMalo ? 2 : 0);
    msgTipoMensaje[m] = TIPO_MENSAJE_CAPCIOSO;
    msgCategoriaEspecial[m] = 3;
    msgTiempoRestante[m] = 1.0;
    msgDominio[m] = esMalo ? "c4-exploit@net" : (usarCorp ? "dolus@corp" : "dolus@net");
    msgIndiceSello[m] = esMalo ? 1 : (usarCorp ? 0 : -1);
    msgTieneAdjunto[m] = true;
    msgIndiceArchivo[m] = esMalo ? 3 : 2;
    msgExtensionArchivo[m] = esMalo ? ".exe" : ".doc";
    msgEsCorporativo[m] = usarCorp;
    msgEsValido[m] = !esMalo;
    msgMotivoInvalidez[m] = esMalo ? 4 : 0;
    msgEtiquetaMeta[m] = "MECHA RAPIDA // +PTS!";
    String[][] mal = {
      {"ALERTA // MECHA RAPIDA!", "PAYLOAD EXPLOSIVO! Rechaza antes de que detone en tu terminal."},
      {"ALERTA // MECHA RAPIDA!", "BOMBA LOGICA! Bloquea este paquete ya antes de perder Seguridad."}
    };
    String[][] ok = {
      {"ALERTA // MECHA RAPIDA!", "PING PRIORITARIO! Acepta rapido para estabilizar el enlace de la feria."},
      {"ALERTA // MECHA RAPIDA!", "SEÑAL DE ESCENARIO! Aprueba a tiempo para mantener el reloj sincronizado."}
    };
    String[] pl = elegirPlantillaFeriaSinRepetir(esMalo ? mal : ok);
    msgAsunto[m] = pl[0];
    msgContenido[m] = pl[1];
    return m;
  } else {
    int m = crearMensajeDolus("nodo_corrupto_" + int(random(100, 999)), "...", 2);
    msgTipoMensaje[m] = TIPO_MENSAJE_CAPCIOSO;
    msgCategoriaEspecial[m] = 4;
    msgTiempoRestante[m] = 1.45;
    msgDominio[m] = "glitch@null";
    msgAsunto[m] = "SISTEMA // PURGA OBLIGADA!";
    msgIndiceSello[m] = 4;
    msgTieneAdjunto[m] = false;
    msgEsCorporativo[m] = false;
    msgEsValido[m] = false;
    msgMotivoInvalidez[m] = 5;
    msgEtiquetaMeta[m] = "SACUDE PARA PURGAR!";
    msgContenido[m] = "CORRUPCION EN FERIA! Mantén clic y SACUDE esta tarjeta bruscamente para purgarla.";
    return m;
  }
}

void generarMensajeModoFeria() {
  cartasGeneradasEnRonda++;

  if (feriaCartasResueltas >= 12 && !qteActivo) {
    float probQTE = constrain(0.05 + (feriaNivelPresion - 1) * 0.01, 0.05, 0.09);
    if (random(1) < probQTE) {
      iniciarQTEPrecision();
    }
  }

  if (feriaCartasResueltas >= 4) {
    float probEsp = constrain(0.16 + feriaCartasResueltas * 0.003, 0.16, 0.32);
    if (random(1) < probEsp) {
      float rE = random(1);
      int tipoEsp = (rE < 0.25) ? 1 : ((rE < 0.50) ? 2 : ((rE < 0.75) ? 3 : 4));
      int mEsp = construirCartaEspecialFeria(tipoEsp);
      encolarMensaje(mEsp);
      return;
    }
  }

  boolean proximoValido;
  if (consecutivosInocente >= 2) {
    proximoValido = false;
  } else if (consecutivosMalo >= 2) {
    proximoValido = true;
  } else {
    proximoValido = (random(1) < 0.44);
  }

  float probCapcioso;
  if (feriaCartasResueltas <= 5) probCapcioso = 0.65;
  else if (feriaCartasResueltas <= 15) probCapcioso = 0.80;
  else if (feriaCartasResueltas <= 30) probCapcioso = 0.90;
  else probCapcioso = 0.96;

  int m = -1;
  boolean usarCapcioso = (random(1) < probCapcioso);

  if (usarCapcioso) {
    if (proximoValido) {
      if (random(1) < 0.42) {
        String rem = elegirRemitenteSinRepetir(REMS_CORP_FERIA);
        String[] pl = elegirPlantillaFeriaSinRepetir(FERIA_CAPCIOSO_CORP_BUENAS);
        m = crearMensajeDolus(rem, pl[1], 0);
        msgTipoMensaje[m] = TIPO_MENSAJE_CAPCIOSO;
        msgDominio[m] = "dolus@corp";
        msgAsunto[m] = pl[0];
        msgIndiceSello[m] = 0;
        msgTieneAdjunto[m] = (random(1) < 0.72);
        if (msgTieneAdjunto[m]) {
          int rA = (random(1) < 0.5) ? 0 : 2;
          msgIndiceArchivo[m] = rA;
          msgExtensionArchivo[m] = (rA == 0) ? ".pdf" : ".doc";
        }
        msgEsCorporativo[m] = true;
        msgEsValido[m] = true;
        msgMotivoInvalidez[m] = 0;
        msgEtiquetaMeta[m] = "SISTEMA: " + msgDominio[m];
      } else {
        String rem = elegirRemitenteSinRepetir(REMS_GAMER_EDGY_BUENOS);
        String[] pl = elegirPlantillaFeriaSinRepetir(FERIA_CAPCIOSO_WEB_BUENAS);
        m = crearMensajeDolus(rem, pl[1], 0);
        msgTipoMensaje[m] = TIPO_MENSAJE_CAPCIOSO;
        msgDominio[m] = "dolus@net";
        msgAsunto[m] = pl[0];
        msgIndiceSello[m] = (random(1) < 0.72) ? 5 : -1;
        msgTieneAdjunto[m] = (random(1) < 0.85);
        if (msgTieneAdjunto[m]) {
          int rA = int(random(3));
          msgIndiceArchivo[m] = rA;
          msgExtensionArchivo[m] = (rA == 0 ? ".pdf" : (rA == 1 ? ".png" : ".doc"));
        }
        msgEsCorporativo[m] = false;
        msgEsValido[m] = true;
        msgMotivoInvalidez[m] = 0;
        msgEtiquetaMeta[m] = "WEB: " + msgDominio[m];
      }
    } else {
      float roll = random(1);
      if (roll < 0.25) {
        boolean fakeCorp = (random(1) < 0.48);
        String rem = fakeCorp ? elegirRemitenteSinRepetir(REMS_CORP_FERIA) : elegirRemitenteSinRepetir(REMS_GAMER_NORMALES);
        String[] pl = elegirPlantillaFeriaSinRepetir(FERIA_CAPCIOSO_TYPO_TXT);
        m = crearMensajeDolus(rem, pl[1], 1);
        msgTipoMensaje[m] = TIPO_MENSAJE_CAPCIOSO;
        msgDominio[m] = fakeCorp
          ? FERIA_TYPOS_CORP[int(random(FERIA_TYPOS_CORP.length))]
          : FERIA_TYPOS_WEB[int(random(FERIA_TYPOS_WEB.length))];
        msgAsunto[m] = pl[0];
        msgIndiceSello[m] = fakeCorp ? 0 : 5;
        msgTieneAdjunto[m] = true;
        msgIndiceArchivo[m] = (random(1) < 0.5) ? 0 : 1;
        msgExtensionArchivo[m] = (msgIndiceArchivo[m] == 0) ? ".pdf" : ".png";
        msgEsCorporativo[m] = fakeCorp;
        msgEsValido[m] = false;
        msgMotivoInvalidez[m] = 3;
        msgEtiquetaMeta[m] = (fakeCorp ? "SISTEMA: " : "WEB: ") + msgDominio[m];
      } else if (roll < 0.53) {
        boolean comoCorp = (random(1) < 0.45);
        String rem = comoCorp ? elegirRemitenteSinRepetir(REMS_CORP_FERIA) : elegirRemitenteSinRepetir(REMS_GAMER_NORMALES);
        String[] pl = elegirPlantillaFeriaSinRepetir(FERIA_CAPCIOSO_DOBLE_EXT);
        m = crearMensajeDolus(rem, pl[1], 2);
        msgTipoMensaje[m] = TIPO_MENSAJE_CAPCIOSO;
        msgDominio[m] = comoCorp ? "dolus@corp" : "dolus@net";
        msgAsunto[m] = pl[0];
        msgIndiceSello[m] = comoCorp ? 0 : 5;
        msgTieneAdjunto[m] = true;
        String ext = pl[2];
        msgExtensionArchivo[m] = ext;
        if (ext.equals(".exe")) msgIndiceArchivo[m] = 3;
        else if (ext.equals(".bat")) msgIndiceArchivo[m] = 4;
        else if (ext.equals(".zip")) msgIndiceArchivo[m] = 5;
        else if (ext.startsWith(".pdf")) msgIndiceArchivo[m] = 0;
        else if (ext.startsWith(".png") || ext.startsWith(".jpg")) msgIndiceArchivo[m] = 1;
        else msgIndiceArchivo[m] = 2;
        msgEsCorporativo[m] = comoCorp;
        msgEsValido[m] = false;
        msgMotivoInvalidez[m] = 4;
        msgEtiquetaMeta[m] = (comoCorp ? "SISTEMA: " : "WEB: ") + msgDominio[m];
      } else if (roll < 0.74) {
        String rem = elegirRemitenteSinRepetir(REMS_CORP_FERIA);
        String[] pl = elegirPlantillaFeriaSinRepetir(FERIA_CAPCIOSO_CORP_SIN_SELLO);
        m = crearMensajeDolus(rem, pl[1], 1);
        msgTipoMensaje[m] = TIPO_MENSAJE_CAPCIOSO;
        msgDominio[m] = "dolus@corp";
        msgAsunto[m] = pl[0];
        msgIndiceSello[m] = (random(1) < 0.55) ? 2 : -1;
        msgTieneAdjunto[m] = true;
        msgIndiceArchivo[m] = (random(1) < 0.5) ? 0 : 2;
        msgExtensionArchivo[m] = (msgIndiceArchivo[m] == 0) ? ".pdf" : ".doc";
        msgEsCorporativo[m] = true;
        msgEsValido[m] = false;
        msgMotivoInvalidez[m] = 2;
        msgEtiquetaMeta[m] = "SISTEMA: " + msgDominio[m];
      } else if (roll < 0.90) {
        String rem = elegirRemitenteSinRepetir(REMS_GAMER_NORMALES);
        String[] pl = elegirPlantillaFeriaSinRepetir(FERIA_CAPCIOSO_PHISHING_DULCE);
        m = crearMensajeDolus(rem, pl[1], 1);
        msgTipoMensaje[m] = TIPO_MENSAJE_CAPCIOSO;
        msgDominio[m] = "dolus@net";
        msgAsunto[m] = pl[0];
        msgIndiceSello[m] = (random(1) < 0.5) ? 5 : -1;
        msgTieneAdjunto[m] = (random(1) < 0.35);
        if (msgTieneAdjunto[m]) {
          msgIndiceArchivo[m] = 1;
          msgExtensionArchivo[m] = ".png";
        }
        msgEsCorporativo[m] = false;
        msgEsValido[m] = false;
        msgMotivoInvalidez[m] = 1;
        msgEtiquetaMeta[m] = "WEB: " + msgDominio[m];
      } else {
        boolean esCorp = (random(1) < 0.35);
        String rem = esCorp ? elegirRemitenteSinRepetir(REMS_CORP_FERIA) : elegirRemitenteSinRepetir(REMS_GAMER_NORMALES);
        String[] pl = elegirPlantillaFeriaSinRepetir(FERIA_CAPCIOSO_SELLO_MALWARE);
        m = crearMensajeDolus(rem, pl[1], 2);
        msgTipoMensaje[m] = TIPO_MENSAJE_CAPCIOSO;
        msgDominio[m] = esCorp ? "dolus@corp" : "dolus@net";
        msgAsunto[m] = pl[0];
        msgIndiceSello[m] = 1;
        msgTieneAdjunto[m] = (random(1) < 0.4);
        if (msgTieneAdjunto[m]) {
          msgIndiceArchivo[m] = 0;
          msgExtensionArchivo[m] = ".pdf";
        }
        msgEsCorporativo[m] = esCorp;
        msgEsValido[m] = false;
        msgMotivoInvalidez[m] = 5;
        msgEtiquetaMeta[m] = (esCorp ? "SISTEMA: " : "WEB: ") + msgDominio[m];
      }
    }
  } else {
    boolean esCorp = (random(1) < 0.45);
    if (esCorp) {
      int tipoFallo = (random(1) < 0.35) ? 1 : ((random(1) < 0.7) ? 2 : 3);
      m = construirMensajeNormalCorp(proximoValido, tipoFallo, random(1) >= 0.7);
    } else {
      int tipoFallo = (random(1) < 0.4) ? 3 : ((random(1) < 0.75) ? 2 : 1);
      m = construirMensajeNormalWeb(proximoValido, tipoFallo);
    }
  }

  if (m < 0) return;
  msgTiempoRestante[m] = 1.0;

  if (msgEsValido[m]) {
    consecutivosInocente++;
    consecutivosMalo = 0;
  } else {
    consecutivosMalo++;
    consecutivosInocente = 0;
  }

  encolarMensaje(m);
}


float[] feriaCalcularLayoutLobby() {
  float mX = width * 0.035;
  float gap = width * 0.025;
  float leftW = min(500, width * 0.40);
  float rightX = mX + leftW + gap;
  float rightW = width - rightX - mX;
  float topY = 98;
  float bodyH = height - topY - 76;
  return new float[] { mX, topY, leftW, bodyH, rightX, rightW };
}

ArrayList<RegistroFeria> feriaObtenerRegistrosFiltrados() {
  ArrayList<RegistroFeria> res = new ArrayList<RegistroFeria>();
  String f = feriaSanitizarTextoPlano(feriaInputFiltro).toLowerCase();
  for (int i = 0; i < registrosFeria.size(); i++) {
    RegistroFeria r = registrosFeria.get(i);
    if (f.length() == 0 || r.nombre.toLowerCase().contains(f) || r.etiqueta.toLowerCase().contains(f)) {
      res.add(r);
    }
  }
  return res;
}

void actualizarYDibujarPantallaModoFeria() {
  dibujarFondoJuego();
  pushStyle();
  if (fuenteRetro != null) textFont(fuenteRetro);

  color colG = colorTema();
  color colCyan = (modoDaltonismo == 0) ? color(75, 240, 215) : colorShaderDaltonismo(color(75, 240, 215));
  color colOro = colorShaderDaltonismo(color(255, 215, 75));
  color colBg = color(6, 14, 10, 242);

  textAlign(CENTER, TOP);
  fill(colG);
  textSize(32);
  text("MODO FERIA // SUPERVIVENCIA INFINITA", width * 0.5, 22);
  fill(175, 225, 200);
  textSize(13);
  text("REGISTRO PERMANENTE DE PARTICIPANTES Y SALON DE LA FAMA EN TIEMPO REAL", width * 0.5, 62);

  float[] lay = feriaCalcularLayoutLobby();
  float lx = lay[0], topY = lay[1], lw = lay[2], bodyH = lay[3], rx = lay[4], rw = lay[5];

  dibujarPanelPersona(lx, topY, lw, bodyH, colG, colBg);

  float pad = 20;
  float curY = topY + 18;
  textAlign(LEFT, TOP);
  fill(colCyan);
  textSize(18);
  text(">_ REGISTRO DE PARTICIPANTE", lx + pad, curY);
  curY += 28;

  stroke(colG, 90);
  strokeWeight(1.5);
  line(lx + pad, curY, lx + lw - pad, curY);
  curY += 12;

  String idEscribiendo = feriaNormalizarId(feriaInputNombre);
  RegistroFeria coincidencia = (feriaSanitizarTextoPlano(feriaInputNombre).length() >= 2)
    ? buscarRegistroFeriaPorId(idEscribiendo)
    : null;

  fill(200, 235, 215);
  textSize(12);
  text("NOMBRE / ALIAS * (2-20 CARACTERES)", lx + pad, curY);
  curY += 18;

  float fieldW = lw - pad * 2;
  float fieldH = 38;
  boolean hovNom = evaluarHover(lx + lw * 0.5, curY + fieldH * 0.5, fieldW, fieldH);
  rectMode(CORNER);
  fill(feriaCampoActivo == 1 ? color(10, 28, 20) : color(5, 13, 10));
  stroke(feriaCampoActivo == 1 ? colCyan : (hovNom ? colG : feriaConAlpha(colG, 110)));
  strokeWeight(feriaCampoActivo == 1 ? 2.2 : 1.4);
  rect(lx + pad, curY, fieldW, fieldH, 6);

  boolean blink = ((millis() / 420) % 2 == 0);
  textAlign(LEFT, CENTER);
  textSize(16);
  if (feriaInputNombre.length() == 0) {
    fill(105, 140, 125);
    text("Ej: Daniel_UN" + ((feriaCampoActivo == 1 && blink) ? "_" : ""), lx + pad + 12, curY + fieldH * 0.5 - 2);
  } else {
    fill(255);
    text(feriaInputNombre + ((feriaCampoActivo == 1 && blink) ? "_" : ""), lx + pad + 12, curY + fieldH * 0.5 - 2);
  }
  curY += fieldH + 6;

  textAlign(LEFT, TOP);
  textSize(11);
  if (coincidencia != null) {
    fill(colCyan);
    text("Perfil existente encontrado · Record: " + coincidencia.mejorPuntaje + " PTS", lx + pad, curY);
  } else if (feriaSanitizarTextoPlano(feriaInputNombre).length() >= 2) {
    fill(colG);
    text("Nuevo participante disponible para registro permanente", lx + pad, curY);
  } else {
    fill(130, 165, 145);
    text("Si ya jugaste, escribe tu alias para conservar tus records", lx + pad, curY);
  }
  curY += 20;

  fill(200, 235, 215);
  textSize(12);
  text("CARRERA / INSTITUCION (OPCIONAL)", lx + pad, curY);
  curY += 18;

  boolean hovEt = evaluarHover(lx + lw * 0.5, curY + fieldH * 0.5, fieldW, fieldH);
  fill(feriaCampoActivo == 2 ? color(10, 28, 20) : color(5, 13, 10));
  stroke(feriaCampoActivo == 2 ? colCyan : (hovEt ? colG : feriaConAlpha(colG, 110)));
  strokeWeight(feriaCampoActivo == 2 ? 2.2 : 1.4);
  rect(lx + pad, curY, fieldW, fieldH, 6);

  textAlign(LEFT, CENTER);
  textSize(15);
  if (feriaInputEtiqueta.length() == 0) {
    fill(105, 140, 125);
    text("Ej: Ing. Sistemas" + ((feriaCampoActivo == 2 && blink) ? "_" : ""), lx + pad + 12, curY + fieldH * 0.5 - 2);
  } else {
    fill(255);
    text(feriaInputEtiqueta + ((feriaCampoActivo == 2 && blink) ? "_" : ""), lx + pad + 12, curY + fieldH * 0.5 - 2);
  }
  curY += fieldH + 14;

  float halfBtnW = (fieldW - 12) * 0.5;
  float actBtnH = 40;
  float b1CX = lx + pad + halfBtnW * 0.5;
  float b2CX = lx + pad + halfBtnW + 12 + halfBtnW * 0.5;
  float bCY = curY + actBtnH * 0.5;

  boolean hovSoloReg = evaluarHover(b1CX, bCY, halfBtnW, actBtnH);
  boolean hovRegJugar = evaluarHover(b2CX, bCY, halfBtnW, actBtnH);

  rectMode(CENTER);
  fill(hovSoloReg ? color(25, 70, 52) : color(12, 34, 24));
  stroke(hovSoloReg ? color(255) : colG);
  strokeWeight(1.6);
  rect(b1CX, bCY, halfBtnW, actBtnH, 6);
  textAlign(CENTER, CENTER);
  textSize(12);
  fill(240);
  text("SOLO REGISTRAR", b1CX, bCY - 1);

  fill(hovRegJugar ? color(28, 175, 115) : color(16, 105, 68));
  stroke(hovRegJugar ? color(255) : colCyan);
  strokeWeight(2.0);
  rect(b2CX, bCY, halfBtnW, actBtnH, 6);
  fill(255);
  textSize(12);
  text(coincidencia != null ? "SELECCIONAR Y JUGAR >>" : "REGISTRAR Y JUGAR >>", b2CX, bCY - 1);
  curY += actBtnH + 14;

  rectMode(CORNER);
  float cardActH = 122;
  fill(9, 24, 18, 235);
  stroke(colCyan, 150);
  strokeWeight(1.5);
  rect(lx + pad, curY, fieldW, cardActH, 8);

  textAlign(LEFT, TOP);
  fill(colCyan);
  textSize(11);
  text("PARTICIPANTE ACTIVO SELECCIONADO", lx + pad + 12, curY + 10);

  if (usuarioFeriaActivo != null) {
    int posAct = obtenerPosicionRankingPorId(usuarioFeriaActivo.id);
    fill(255);
    textSize(19);
    text(usuarioFeriaActivo.nombre, lx + pad + 12, curY + 26);

    fill(175, 225, 200);
    textSize(12);
    text(usuarioFeriaActivo.etiqueta + "  |  Puesto #" + posAct + "  |  Intentos: " + usuarioFeriaActivo.partidasJugadas, lx + pad + 12, curY + 52);

    fill(colOro);
    textSize(13);
    text("MEJOR: " + usuarioFeriaActivo.mejorPuntaje + " PTS   |   COMBO: x" + usuarioFeriaActivo.mejorCombo + "   |   OLEADA: " + usuarioFeriaActivo.mejorNivel, lx + pad + 12, curY + 72);

    float startBtnW = fieldW - 24;
    float startBtnH = 34;
    float startBtnX = lx + lw * 0.5;
    float startBtnY = curY + cardActH - 22;
    boolean hovStart = evaluarHover(startBtnX, startBtnY, startBtnW, startBtnH);
    rectMode(CENTER);
    fill(hovStart ? color(40, 210, 125) : color(22, 130, 75));
    stroke(hovStart ? color(255) : color(110, 255, 190));
    strokeWeight(1.8);
    rect(startBtnX, startBtnY, startBtnW, startBtnH, 6);
    textAlign(CENTER, CENTER);
    fill(255);
    textSize(13);
    text("INICIAR PARTIDA INFINITA COMO " + strToUpper(usuarioFeriaActivo.nombre) + " >>", startBtnX, startBtnY - 1);
  } else {
    fill(155, 185, 170);
    textSize(13);
    text("Aun no hay participante activo.\nRegistra tu nombre arriba o elige uno del ranking.", lx + pad + 12, curY + 38);
  }
  curY += cardActH + 12;

  if (curY + 60 < topY + bodyH) {
    textAlign(LEFT, TOP);
    fill(colG);
    textSize(12);
    text("REGLAS DEL MODO FERIA", lx + pad, curY);
    curY += 18;
    fill(195, 220, 205);
    textSize(11);
    text(
      "- Partida infinita sin tienda ni fin de ronda; solo acaba si pierdes.\n"
      + "- Mensajes capciosos extremos y velocidad creciente cada carta.\n"
      + "- Controles: Arrastra la carta o usa [<-] Rechazar y [->] Aprobar.\n"
      + "- El ranking queda guardado en data/feria_ranking.json y .csv.",
      lx + pad, curY
    );
  }

  dibujarPanelPersona(rx, topY, rw, bodyH, colCyan, colBg);

  float rPad = 22;
  float rCurY = topY + 18;
  textAlign(LEFT, TOP);
  fill(colOro);
  textSize(18);
  text("SALON DE LA FAMA PERMANENTE (" + registrosFeria.size() + ")", rx + rPad, rCurY);

  float filtW = min(220, rw * 0.34);
  float filtH = 28;
  float filtX = rx + rw - rPad - filtW;
  float filtY = rCurY - 2;
  boolean hovFilt = evaluarHover(filtX + filtW * 0.5, filtY + filtH * 0.5, filtW, filtH);
  rectMode(CORNER);
  fill(feriaCampoActivo == 3 ? color(10, 28, 20) : color(5, 13, 10));
  stroke(feriaCampoActivo == 3 ? colCyan : (hovFilt ? colG : feriaConAlpha(colCyan, 105)));
  strokeWeight(feriaCampoActivo == 3 ? 2.0 : 1.2);
  rect(filtX, filtY, filtW, filtH, 5);
  textAlign(LEFT, CENTER);
  textSize(12);
  if (feriaInputFiltro.length() == 0) {
    fill(105, 145, 135);
    text("BUSCAR..." + ((feriaCampoActivo == 3 && blink) ? "_" : ""), filtX + 10, filtY + filtH * 0.5 - 1);
  } else {
    fill(255);
    text(feriaInputFiltro + ((feriaCampoActivo == 3 && blink) ? "_" : ""), filtX + 10, filtY + filtH * 0.5 - 1);
  }
  rCurY += 34;

  float tblX = rx + rPad;
  float tblW = rw - rPad * 2;
  float hdrH = 28;
  rectMode(CORNER);
  fill(12, 30, 24);
  stroke(colCyan, 120);
  strokeWeight(1);
  rect(tblX, rCurY, tblW, hdrH, 4);

  float cPosX = tblX + 12;
  float cNomX = tblX + 52;
  float cPtsX = tblX + tblW * 0.52;
  float cComX = tblX + tblW * 0.67;
  float cCarX = tblX + tblW * 0.80;
  float cTieX = tblX + tblW - (modoDesarrollador ? 44 : 14);

  textAlign(LEFT, CENTER);
  textSize(11);
  fill(colCyan);
  text("#", cPosX, rCurY + hdrH * 0.5);
  text("PARTICIPANTE", cNomX, rCurY + hdrH * 0.5);
  textAlign(RIGHT, CENTER);
  text("PUNTAJE", cPtsX, rCurY + hdrH * 0.5);
  text("COMBO", cComX, rCurY + hdrH * 0.5);
  text("CARTAS", cCarX, rCurY + hdrH * 0.5);
  text("TIEMPO", cTieX, rCurY + hdrH * 0.5);
  rCurY += hdrH + 6;

  ArrayList<RegistroFeria> lista = feriaObtenerRegistrosFiltrados();
  float listAreaH = (topY + bodyH - 46) - rCurY;
  float rowH = 38;
  int maxVis = max(1, int(listAreaH / (rowH + 4)));
  int maxScroll = max(0, lista.size() - maxVis);
  feriaScrollRanking = constrain(feriaScrollRanking, 0, maxScroll);

  if (lista.size() == 0) {
    textAlign(CENTER, CENTER);
    fill(145, 180, 165);
    textSize(14);
    String emptyTxt = (registrosFeria.size() == 0)
      ? "Aun no hay puntajes registrados.\nSe el primero en dejar tu marca en la feria!"
      : "Ningun participante coincide con \"" + feriaInputFiltro + "\".";
    text(emptyTxt, rx + rw * 0.5, rCurY + listAreaH * 0.45);
  } else {
    for (int vis = 0; vis < maxVis && (feriaScrollRanking + vis) < lista.size(); vis++) {
      RegistroFeria r = lista.get(feriaScrollRanking + vis);
      int posGlobal = obtenerPosicionRankingPorId(r.id);
      float rowY = rCurY + vis * (rowH + 4);
      boolean esActivo = (usuarioFeriaActivo != null && usuarioFeriaActivo.id.equals(r.id));
      boolean hovRow = evaluarHover(tblX + tblW * 0.5, rowY + rowH * 0.5, tblW, rowH);

      color colRank = color(195, 225, 210);
      if (posGlobal == 1) colRank = colOro;
      else if (posGlobal == 2) colRank = color(220, 230, 240);
      else if (posGlobal == 3) colRank = color(235, 155, 85);

      rectMode(CORNER);
      fill(esActivo ? color(18, 48, 36, 245) : (hovRow ? color(12, 32, 24, 230) : color(7, 17, 13, 215)));
      stroke(esActivo ? colCyan : (hovRow ? colG : feriaConAlpha(colG, 55)));
      strokeWeight(esActivo ? 2.0 : 1.0);
      rect(tblX, rowY, tblW, rowH, 5);

      textAlign(LEFT, CENTER);
      textSize(14);
      fill(colRank);
      text("#" + posGlobal, cPosX, rowY + rowH * 0.5 - 1);

      fill(esActivo ? color(255) : color(230, 245, 238));
      textSize(14);
      text(r.nombre, cNomX, rowY + 13);
      fill(135, 175, 155);
      textSize(10);
      text(r.etiqueta + " · " + r.partidasJugadas + " part.", cNomX, rowY + 28);

      textAlign(RIGHT, CENTER);
      fill(colRank);
      textSize(15);
      text(str(r.mejorPuntaje), cPtsX, rowY + rowH * 0.5 - 1);

      fill(175, 235, 215);
      textSize(13);
      text("x" + r.mejorCombo, cComX, rowY + rowH * 0.5 - 1);

      fill(200, 230, 220);
      textSize(13);
      text(str(r.mejorCartas), cCarX, rowY + rowH * 0.5 - 1);

      fill(175, 205, 195);
      textSize(12);
      text(feriaFormatearTiempo(r.mejorTiempoSeg), cTieX, rowY + rowH * 0.5 - 1);

      if (modoDesarrollador) {
        float delX = tblX + tblW - 18;
        float delY = rowY + rowH * 0.5;
        boolean hovDel = evaluarHover(delX, delY, 22, 22);
        rectMode(CENTER);
        fill(hovDel ? color(190, 40, 40) : color(70, 20, 20));
        stroke(255, 100, 100);
        strokeWeight(1);
        rect(delX, delY, 20, 20, 4);
        textAlign(CENTER, CENTER);
        fill(255);
        textSize(11);
        text("X", delX, delY - 1);
      }
    }
  }

  float scrY = topY + bodyH - 22;
  textAlign(LEFT, CENTER);
  fill(145, 185, 165);
  textSize(11);
  text("Clic en una fila para seleccionarlo  ·  Mostrando " + min(lista.size(), feriaScrollRanking + 1) + "-" + min(lista.size(), feriaScrollRanking + maxVis) + " de " + lista.size(), tblX, scrY);

  float upX = tblX + tblW - 56;
  float dnX = tblX + tblW - 20;
  boolean hovUp = (feriaScrollRanking > 0) && evaluarHover(upX, scrY, 28, 22);
  boolean hovDn = (feriaScrollRanking < maxScroll) && evaluarHover(dnX, scrY, 28, 22);
  rectMode(CENTER);
  fill(hovUp ? color(25, 70, 52) : color(10, 24, 18));
  stroke(feriaScrollRanking > 0 ? colCyan : color(60, 90, 75));
  rect(upX, scrY, 28, 22, 4);
  fill(feriaScrollRanking > 0 ? color(255) : color(90, 110, 100));
  textAlign(CENTER, CENTER);
  textSize(12);
  text("^", upX, scrY - 1);

  fill(hovDn ? color(25, 70, 52) : color(10, 24, 18));
  stroke(feriaScrollRanking < maxScroll ? colCyan : color(60, 90, 75));
  rect(dnX, scrY, 28, 22, 4);
  fill(feriaScrollRanking < maxScroll ? color(255) : color(90, 110, 100));
  text("v", dnX, scrY - 1);

  float backW = 300;
  float backH = 42;
  float backX = width * 0.5;
  float backY = height - 34;
  boolean hovBack = evaluarHover(backX, backY, backW, backH);
  rectMode(CENTER);
  fill(hovBack ? color(30, 62, 50) : color(12, 26, 20));
  stroke(hovBack ? color(255) : colG);
  strokeWeight(1.6);
  rect(backX, backY, backW, backH, 6);
  fill(hovBack ? color(255) : color(200, 240, 220));
  textSize(15);
  text("<< VOLVER AL MENU PRINCIPAL", backX, backY - 1);

  if (feriaFeedbackTimer > 0) {
    feriaFeedbackTimer--;
    textAlign(CENTER, CENTER);
    textSize(14);
    fill(feriaColorFeedback);
    text(feriaMensajeFeedback, width * 0.5, topY + bodyH + 10);
  }

  popStyle();
}

void mousePressedModoFeria() {
  float[] lay = feriaCalcularLayoutLobby();
  float lx = lay[0], topY = lay[1], lw = lay[2], bodyH = lay[3], rx = lay[4], rw = lay[5];
  float pad = 20;
  float fieldW = lw - pad * 2;
  float fieldH = 38;

  float yNom = topY + 18 + 28 + 12 + 18;
  if (mouseX >= lx + pad && mouseX <= lx + pad + fieldW && mouseY >= yNom && mouseY <= yNom + fieldH) {
    feriaCampoActivo = 1;
    reproducirTap();
    return;
  }

  float yEtiq = yNom + fieldH + 6 + 20 + 18;
  if (mouseX >= lx + pad && mouseX <= lx + pad + fieldW && mouseY >= yEtiq && mouseY <= yEtiq + fieldH) {
    feriaCampoActivo = 2;
    reproducirTap();
    return;
  }

  float bY = yEtiq + fieldH + 14;
  float halfBtnW = (fieldW - 12) * 0.5;
  float actBtnH = 40;
  float b1CX = lx + pad + halfBtnW * 0.5;
  float b2CX = lx + pad + halfBtnW + 12 + halfBtnW * 0.5;
  float bCY = bY + actBtnH * 0.5;

  if (evaluarHover(b1CX, bCY, halfBtnW, actBtnH)) {
    reproducirTap();
    registrarOSeleccionarUsuarioFeria(feriaInputNombre, feriaInputEtiqueta, true);
    return;
  }
  if (evaluarHover(b2CX, bCY, halfBtnW, actBtnH)) {
    reproducirTap();
    RegistroFeria r = registrarOSeleccionarUsuarioFeria(feriaInputNombre, feriaInputEtiqueta, false);
    if (r != null) iniciarPartidaModoFeria();
    return;
  }

  float cardY = bY + actBtnH + 14;
  float cardActH = 122;
  if (usuarioFeriaActivo != null) {
    float startBtnW = fieldW - 24;
    float startBtnH = 34;
    float startBtnX = lx + lw * 0.5;
    float startBtnY = cardY + cardActH - 22;
    if (evaluarHover(startBtnX, startBtnY, startBtnW, startBtnH)) {
      reproducirTap();
      iniciarPartidaModoFeria();
      return;
    }
  }

  float rPad = 22;
  float rCurY = topY + 18;
  float filtW = min(220, rw * 0.34);
  float filtH = 28;
  float filtX = rx + rw - rPad - filtW;
  float filtY = rCurY - 2;
  if (mouseX >= filtX && mouseX <= filtX + filtW && mouseY >= filtY && mouseY <= filtY + filtH) {
    feriaCampoActivo = 3;
    reproducirTap();
    return;
  }

  float tblX = rx + rPad;
  float tblW = rw - rPad * 2;
  float listY = rCurY + 34 + 28 + 6;
  float listAreaH = (topY + bodyH - 46) - listY;
  float rowH = 38;
  int maxVis = max(1, int(listAreaH / (rowH + 4)));
  ArrayList<RegistroFeria> lista = feriaObtenerRegistrosFiltrados();
  int maxScroll = max(0, lista.size() - maxVis);

  float scrY = topY + bodyH - 22;
  float upX = tblX + tblW - 56;
  float dnX = tblX + tblW - 20;
  if (feriaScrollRanking > 0 && evaluarHover(upX, scrY, 28, 22)) {
    feriaScrollRanking = max(0, feriaScrollRanking - 1);
    reproducirTap();
    return;
  }
  if (feriaScrollRanking < maxScroll && evaluarHover(dnX, scrY, 28, 22)) {
    feriaScrollRanking = min(maxScroll, feriaScrollRanking + 1);
    reproducirTap();
    return;
  }

  for (int vis = 0; vis < maxVis && (feriaScrollRanking + vis) < lista.size(); vis++) {
    RegistroFeria r = lista.get(feriaScrollRanking + vis);
    float rowY = listY + vis * (rowH + 4);
    if (modoDesarrollador) {
      float delX = tblX + tblW - 18;
      float delY = rowY + rowH * 0.5;
      if (evaluarHover(delX, delY, 22, 22)) {
        reproducirTap();
        eliminarRegistroFeriaPorId(r.id);
        return;
      }
    }
    if (mouseX >= tblX && mouseX <= tblX + tblW && mouseY >= rowY && mouseY <= rowY + rowH) {
      usuarioFeriaActivo = r;
      feriaCampoActivo = 0;
      feriaMostrarFeedback("SELECCIONADO: " + r.nombre + " (RECORD: " + r.mejorPuntaje + " PTS)", colorTema());
      reproducirTap();
      return;
    }
  }

  if (evaluarHover(width * 0.5, height - 34, 300, 42)) {
    reproducirTap();
    estadoPantalla = PANTALLA_MENU;
    escupiendoMenu = true;
    progresoEscupidoMenu = 0.0;
    return;
  }

  feriaCampoActivo = 0;
}

void keyPressedModoFeria() {
  if (key == ESC) {
    key = 0;
    reproducirTap();
    estadoPantalla = PANTALLA_MENU;
    escupiendoMenu = true;
    progresoEscupidoMenu = 0.0;
    return;
  }

  if (key == TAB) {
    feriaCampoActivo = (feriaCampoActivo % 3) + 1;
    reproducirTap();
    return;
  }

  if (key == ENTER || key == RETURN) {
    if (feriaCampoActivo == 1 || feriaCampoActivo == 2) {
      RegistroFeria r = registrarOSeleccionarUsuarioFeria(feriaInputNombre, feriaInputEtiqueta, false);
      if (r != null) {
        reproducirTap();
        iniciarPartidaModoFeria();
      }
    } else if (usuarioFeriaActivo != null) {
      reproducirTap();
      iniciarPartidaModoFeria();
    }
    return;
  }

  if (feriaCampoActivo == 0) return;

  if (key == BACKSPACE) {
    if (feriaCampoActivo == 1 && feriaInputNombre.length() > 0) {
      feriaInputNombre = feriaInputNombre.substring(0, feriaInputNombre.length() - 1);
      reproducirTap();
    } else if (feriaCampoActivo == 2 && feriaInputEtiqueta.length() > 0) {
      feriaInputEtiqueta = feriaInputEtiqueta.substring(0, feriaInputEtiqueta.length() - 1);
      reproducirTap();
    } else if (feriaCampoActivo == 3 && feriaInputFiltro.length() > 0) {
      feriaInputFiltro = feriaInputFiltro.substring(0, feriaInputFiltro.length() - 1);
      feriaScrollRanking = 0;
      reproducirTap();
    }
    return;
  }

  boolean charValido = (key != CODED) && ((key >= 32 && key <= 126) || "áéíóúÁÉÍÓÚñÑüÜ".indexOf(key) >= 0);
  if (!charValido) return;

  if (feriaCampoActivo == 1 && feriaInputNombre.length() < 20) {
    feriaInputNombre += key;
    reproducirTap();
  } else if (feriaCampoActivo == 2 && feriaInputEtiqueta.length() < 22) {
    feriaInputEtiqueta += key;
    reproducirTap();
  } else if (feriaCampoActivo == 3 && feriaInputFiltro.length() < 20) {
    feriaInputFiltro += key;
    feriaScrollRanking = 0;
    reproducirTap();
  }
}

void mouseWheel(MouseEvent event) {
  if (estadoPantalla == PANTALLA_MODO_FERIA) {
    float[] lay = feriaCalcularLayoutLobby();
    float rx = lay[4], rw = lay[5], topY = lay[1], bodyH = lay[3];
    float listAreaH = (topY + bodyH - 46) - (topY + 18 + 34 + 28 + 6);
    int maxVis = max(1, int(listAreaH / 42.0));
    int maxScroll = max(0, feriaObtenerRegistrosFiltrados().size() - maxVis);
    feriaScrollRanking = constrain(feriaScrollRanking + event.getCount(), 0, maxScroll);
  }
}


void dibujarPanelSuperiorFeria(float x, float y, float w, float h, color colG, color colBg) {
  dibujarPanelPersona(x, y, w, h, colG, colBg);
  pushStyle();
  if (fuenteRetro != null) textFont(fuenteRetro);

  color colCyan = (modoDaltonismo == 0) ? color(75, 240, 215) : colorShaderDaltonismo(color(75, 240, 215));
  color colOro = colorShaderDaltonismo(color(255, 215, 75));

  feriaDispPuntaje = lerp(feriaDispPuntaje, feriaPuntaje, 0.16);
  feriaPulsoPuntaje = max(0.0, feriaPulsoPuntaje - 0.06);

  float pad = 20;
  textAlign(LEFT, TOP);
  fill(colCyan);
  textSize(12);
  String nomUsr = (usuarioFeriaActivo != null) ? usuarioFeriaActivo.nombre : nombreJugador;
  text("PARTICIPANTE: " + strToUpper(nomUsr) + "  //  PUNTAJE ACTUAL", x + pad, y + 14);

  pushMatrix();
  translate(x + pad, y + 36);
  scale(1.0 + feriaPulsoPuntaje * 0.10);
  fill(255, 255, 240);
  textSize(40);
  text(nf(round(feriaDispPuntaje), 1), 0, 0);
  popMatrix();

  int topRef = obtenerMejorPuntajeGlobalFeria();
  int recPers = (usuarioFeriaActivo != null) ? usuarioFeriaActivo.mejorPuntaje : 0;
  int metaRec = max(topRef, recPers);
  float recY = y + h - 34;
  float recBarW = w * 0.40;
  fill(170, 215, 195);
  textSize(11);
  if (metaRec > 0) {
    String lblMeta = (feriaPuntaje > topRef && topRef > 0)
      ? ("SUPERASTE EL RECORD #1! (PREV: " + topRef + ")")
      : ("RECORD #1 FERIA: " + topRef + " PTS   |   TU MEJOR: " + recPers);
    text(lblMeta, x + pad, recY);
    float pctRec = constrain((float)feriaPuntaje / float(max(1, topRef)), 0.0, 1.0);
    rectMode(CORNER);
    noStroke();
    fill(10, 26, 20);
    rect(x + pad, recY + 15, recBarW, 7, 3);
    fill(feriaPuntaje > topRef ? colOro : colCyan);
    rect(x + pad, recY + 15, recBarW * pctRec, 7, 3);
  } else {
    text("ESTABLECE EL PRIMER RECORD DEL DIA!", x + pad, recY + 4);
  }

  float midX = x + w * 0.46;
  stroke(colG, 80);
  strokeWeight(1.5);
  line(midX, y + 16, midX, y + h - 16);

  float colW = (w - (midX - x) - 24) / 3.0;
  float vel = obtenerFactorVelocidadFeria();
  float segPorCarta = 1.0 / (max(0.0001, obtenerDecaimientoCartaFeria(-1)) * 60.0);
  int accPct = (feriaCartasResueltas > 0) ? round((feriaAciertos * 100.0) / feriaCartasResueltas) : 100;

  float c1X = midX + 20;
  textAlign(LEFT, TOP);
  fill(colOro);
  textSize(12);
  text("OLEADA DE PRESION", c1X, y + 16);
  fill(255);
  textSize(28);
  text("NV." + feriaNivelPresion, c1X, y + 36);
  fill(255, 185, 85);
  textSize(13);
  text("VEL x" + nf(vel, 1, 1) + " (~" + nf(segPorCarta, 1, 1) + "s)", c1X, y + 72);

  float c2X = midX + 20 + colW;
  fill(colCyan);
  textSize(12);
  text("TIEMPO / PUESTO", c2X, y + 16);
  fill(255);
  textSize(28);
  text(feriaFormatearTiempo(feriaTiempoSobrevividoSeg), c2X, y + 36);
  int posViva = obtenerPosicionVivaJugadorFeria();
  fill(posViva == 1 ? colOro : color(140, 245, 195));
  textSize(13);
  text("RANK EN VIVO #" + posViva, c2X, y + 72);

  float c3X = midX + 20 + colW * 2;
  fill(colG);
  textSize(12);
  text("CARTAS / PRECISION", c3X, y + 16);
  fill(255);
  textSize(28);
  text(str(feriaCartasResueltas), c3X, y + 36);
  fill(accPct >= 80 ? color(110, 255, 175) : color(255, 200, 95));
  textSize(13);
  text("ACIERTO " + accPct + "%", c3X, y + 72);

  popStyle();
}

void dibujarBannerDirectivaFeria(float px, float py, float pw, color colG) {
  pushStyle();
  rectMode(CORNER);
  float bx = px + 24;
  float by = py + 14;
  float bw = pw - 48;
  float bh = 42;

  color colCyan = (modoDaltonismo == 0) ? color(75, 240, 215) : colorShaderDaltonismo(color(75, 240, 215));
  fill(8, 22, 16, 225);
  stroke(colCyan, 175);
  strokeWeight(1.8);
  rect(bx, by, bw, bh, 8);

  float pulsoLed = 0.5 + 0.5 * sin(frameCount * 0.14);
  noStroke();
  fill(colCyan, 95 * pulsoLed);
  ellipse(bx + 22, by + bh * 0.5, 18, 18);
  fill(255, 230);
  ellipse(bx + 22, by + bh * 0.5, 8, 8);

  textAlign(LEFT, CENTER);
  textSize(14);
  fill(colCyan);
  text("MODO FERIA INFINITO // OLEADA " + feriaNivelPresion, bx + 40, by + bh * 0.5 - 2);

  textAlign(RIGHT, CENTER);
  fill(225, 245, 235);
  textSize(12);
  text("CAPCIOSO EXTREMO · VELOCIDAD x" + nf(obtenerFactorVelocidadFeria(), 1, 1) + " · FLECHAS [<-][->] O ARRASTRE", bx + bw - 18, by + bh * 0.5 - 2);
  popStyle();
}

void dibujarPanelInferiorIzqFeria(float panelIzqX, float panelIzqY, float panelIzqW, float panelIzqH, color colG, color colBgPanel, color colAlarma) {
  dibujarPanelPersona(panelIzqX, panelIzqY, panelIzqW, panelIzqH, colG, colBgPanel);
  pushStyle();
  color colCyan = (modoDaltonismo == 0) ? color(75, 240, 215) : colorShaderDaltonismo(color(75, 240, 215));
  color colOro = colorShaderDaltonismo(color(255, 215, 75));

  textAlign(LEFT, TOP);
  textSize(22);
  fill(colCyan);
  text("ESTADO FERIA", panelIzqX + 20, panelIzqY + 18);

  stroke(colCyan, 130);
  strokeWeight(2.5);
  line(panelIzqX + 15, panelIzqY + 46, panelIzqX + panelIzqW - 15, panelIzqY + 46);

  float ey = panelIzqY + 58;
  textSize(14);
  fill(255, 215, 80);
  text("VELOCIDAD ACTUAL: x" + nf(obtenerFactorVelocidadFeria(), 1, 2), panelIzqX + 20, ey); ey += 24;
  fill(190, 235, 215);
  text("DANO POR ERROR: x" + nf(obtenerMultiplicadorDanoFeria(), 1, 2), panelIzqX + 20, ey); ey += 24;
  fill(colG);
  text("SIG. OLEADA: " + feriaProgresoOleada + "/" + FERIA_CARTAS_POR_OLEADA + " ACIERTOS", panelIzqX + 20, ey); ey += 24;
  if (qteActivo) {
    fill(colAlarma);
    text("ALERTA QTE ACTIVA!", panelIzqX + 20, ey);
  }

  float rankTopY = panelIzqY + panelIzqH * 0.36;
  textSize(20);
  fill(colOro);
  text("RANKING EN VIVO (TOP 5)", panelIzqX + 20, rankTopY);
  stroke(colOro, 120);
  strokeWeight(2.0);
  line(panelIzqX + 15, rankTopY + 28, panelIzqX + panelIzqW - 15, rankTopY + 28);

  ArrayList<String> namesLive = new ArrayList<String>();
  ArrayList<Integer> scoresLive = new ArrayList<Integer>();
  ArrayList<Boolean> isSelfLive = new ArrayList<Boolean>();

  for (int i = 0; i < registrosFeria.size(); i++) {
    RegistroFeria r = registrosFeria.get(i);
    if (usuarioFeriaActivo != null && r.id.equals(usuarioFeriaActivo.id)) continue;
    namesLive.add(r.nombre);
    scoresLive.add(r.mejorPuntaje);
    isSelfLive.add(false);
  }
  String miNom = (usuarioFeriaActivo != null) ? usuarioFeriaActivo.nombre : nombreJugador;
  namesLive.add(miNom + " (TU)");
  scoresLive.add(feriaPuntaje);
  isSelfLive.add(true);

  for (int i = 0; i < scoresLive.size() - 1; i++) {
    for (int j = i + 1; j < scoresLive.size(); j++) {
      if (scoresLive.get(j) > scoresLive.get(i)) {
        int tmpS = scoresLive.get(i); scoresLive.set(i, scoresLive.get(j)); scoresLive.set(j, tmpS);
        String tmpN = namesLive.get(i); namesLive.set(i, namesLive.get(j)); namesLive.set(j, tmpN);
        boolean tmpB = isSelfLive.get(i); isSelfLive.set(i, isSelfLive.get(j)); isSelfLive.set(j, tmpB);
      }
    }
  }

  float rowStartY = rankTopY + 38;
  float rowGap = 28;
  int mostrados = min(5, namesLive.size());
  for (int k = 0; k < mostrados; k++) {
    float ry = rowStartY + k * rowGap;
    boolean yo = isSelfLive.get(k);
    if (yo) {
      rectMode(CORNER);
      noStroke();
      fill(colCyan, 40);
      rect(panelIzqX + 16, ry - 4, panelIzqW - 32, 24, 4);
    }
    textAlign(LEFT, TOP);
    textSize(13);
    fill(yo ? colCyan : (k == 0 ? colOro : color(205, 228, 215)));
    String nm = namesLive.get(k);
    if (nm.length() > 16) nm = nm.substring(0, 15) + ".";
    text("#" + (k + 1) + " " + nm, panelIzqX + 22, ry);

    textAlign(RIGHT, TOP);
    text(str(scoresLive.get(k)), panelIzqX + panelIzqW - 22, ry);
  }

  float progY = panelIzqY + panelIzqH - 72;
  float progBarW = panelIzqW - 150;
  float progBarH = 10 + pulsoRestantesUI * 4.0;

  textAlign(LEFT, TOP);
  textSize(13);
  fill(colCyan);
  text("OLEADA " + feriaNivelPresion + " -> " + (feriaNivelPresion + 1) + " (" + feriaProgresoOleada + "/" + FERIA_CARTAS_POR_OLEADA + ")", panelIzqX + 20, progY);

  noFill();
  stroke(colCyan, 120 + pulsoRestantesUI * 120);
  strokeWeight(2);
  rectMode(CORNER);
  rect(panelIzqX + 20, progY + 20 - pulsoRestantesUI * 2.0, progBarW, progBarH, 5);
  float progP = constrain((float)feriaProgresoOleada / float(FERIA_CARTAS_POR_OLEADA), 0, 1);
  fill(colCyan);
  noStroke();
  rect(panelIzqX + 20, progY + 20 - pulsoRestantesUI * 2.0, progBarW * progP, progBarH, 5);

  pushMatrix();
  translate(panelIzqX + panelIzqW - 70, panelIzqY + panelIzqH - 108);
  rotate(-0.05 + sin(pulsoComboUI * PI) * 0.08);
  textAlign(CENTER, CENTER);
  float shakeCombo = comboActual > 0 ? random(-1.5, 1.5) : 0;
  fill(0, 150);
  text("x" + comboActual, 6 + shakeCombo, 6 + shakeCombo);
  fill(comboActual > 0 ? lerpColor(colG, color(255), abs(sin(frameCount * 0.1))) : color(100, 150, 120));
  float comboScaleExtra = pulsoComboUI * 14.0;
  if (comboActual > 0) {
    comboScaleExtra += min(comboActual * 1.5, 20) + sin(frameCount * 0.2) * min(comboActual, 8);
  }
  textSize(int(34 + comboScaleExtra));
  text("x" + comboActual, shakeCombo, shakeCombo);
  textSize(17);
  text("Combo", 0, 34);

  if (comboActual > 0) {
    rectMode(CENTER);
    fill(0, 100);
    rect(0, 49, 80, 8, 4);
    fill(lerpColor(color(255, 50, 50), colG, tiempoComboRestante / MAX_TIEMPO_COMBO));
    float bw = 80 * (tiempoComboRestante / MAX_TIEMPO_COMBO);
    rect(0, 49, bw, 8, 4);
  }
  popMatrix();

  popStyle();
}

void dibujarBarraOleadaFeria() {
  pushStyle();
  float bx = width * 0.64;
  float by = height * 0.36;
  float bw = 390;
  float bh = 16;

  color colCyan = (modoDaltonismo == 0) ? color(75, 240, 215) : colorShaderDaltonismo(color(75, 240, 215));
  color colOro = colorShaderDaltonismo(color(255, 215, 75));
  float vel = obtenerFactorVelocidadFeria();
  int faltan = max(0, FERIA_CARTAS_POR_OLEADA - feriaProgresoOleada);

  pushMatrix();
  translate(bx, by);
  scale(1.0 + pulsoBalanzaUI * 0.12, 1.0 + pulsoBalanzaUI * 0.24);
  translate(-bx, -by);

  textAlign(CENTER, BOTTOM);
  textSize(11);
  if (faltan <= 2) {
    fill(colOro);
    text("OLEADA " + feriaNivelPresion + " POR SUBIR (" + feriaProgresoOleada + "/" + FERIA_CARTAS_POR_OLEADA + ") · VEL x" + nf(vel, 1, 1) + "!", bx, by - bh * 0.5 - 5);
  } else {
    fill(185, 225, 210);
    text("OLEADA " + feriaNivelPresion + " (" + feriaProgresoOleada + "/" + FERIA_CARTAS_POR_OLEADA + " ACIERTOS) · VELOCIDAD x" + nf(vel, 1, 1), bx, by - bh * 0.5 - 5);
  }

  rectMode(CENTER);
  fill(6, 14, 10, 210);
  stroke(pulsoBalanzaUI > 0.15 ? color(255) : colCyan);
  strokeWeight(2);
  rect(bx, by, bw, bh, 8);

  float prog = constrain((float)feriaProgresoOleada / float(FERIA_CARTAS_POR_OLEADA), 0.0, 1.0);
  if (prog > 0) {
    noStroke();
    rectMode(CORNER);
    fill(faltan <= 2 ? colOro : colCyan, 225);
    rect(bx - bw * 0.5 + 2, by - bh * 0.5 + 2, (bw - 4) * prog, bh - 4, 6);
  }

  for (int i = 1; i < FERIA_CARTAS_POR_OLEADA; i++) {
    float tx = bx - bw * 0.5 + (bw / float(FERIA_CARTAS_POR_OLEADA)) * i;
    stroke(255, 75);
    strokeWeight(1);
    line(tx, by - bh * 0.5, tx, by + bh * 0.5);
  }

  textAlign(RIGHT, CENTER);
  fill(colCyan);
  textSize(11);
  text("NV." + feriaNivelPresion, bx - bw * 0.5 - 12, by - 1);

  textAlign(LEFT, CENTER);
  fill(colOro);
  textSize(11);
  text("NV." + (feriaNivelPresion + 1), bx + bw * 0.5 + 12, by - 1);

  popMatrix();
  popStyle();
}


void finalizarPartidaModoFeria(int tipo, String razon) {
  tipoGameOver = tipo;
  razonGameOver = razon;
  registrarResultadoPartidaFeria();
  estadoPantalla = PANTALLA_GAMEOVER;
  detenerTodaMusica();
  if (musicaCredits != null && musicaCredits.frames() > 0) {
    reproducirMusicaUnica(musicaCredits);
  }
  if (tipo >= 0 && tipo < 5 && cacheImgGameOver[tipo] != null) {
    imgGameOverActual = cacheImgGameOver[tipo];
  } else {
    imgGameOverActual = epCargarIlustracionFinal("final_malo_temprano");
  }
}

void actualizarYDibujarGameOverFeria() {
  pushStyle();
  background(8, 5, 8);
  if (fuenteRetro != null) textFont(fuenteRetro);

  color colG = colorTema();
  color colCyan = (modoDaltonismo == 0) ? color(75, 240, 215) : colorShaderDaltonismo(color(75, 240, 215));
  color colOro = colorShaderDaltonismo(color(255, 215, 75));

  textAlign(CENTER, CENTER);
  textSize(54);
  dibujarTextoAnimado("FIN DE TURNO // MODO FERIA", width * 0.5, height * 0.08, color(255, 80, 80), CENTER, 4);

  fill(220, 200, 205);
  textSize(15);
  text(razonGameOver.replace("\n", " "), width * 0.5, height * 0.14);

  float mX = width * 0.06;
  float gap = width * 0.03;
  float leftW = width * 0.43;
  float rightX = mX + leftW + gap;
  float rightW = width - rightX - mX;
  float boxY = height * 0.19;
  float boxH = height * 0.62;

  dibujarPanelPersona(mX, boxY, leftW, boxH, colCyan, color(6, 14, 12, 242));
  float lx = mX + leftW * 0.5;
  textAlign(CENTER, TOP);
  fill(colCyan);
  textSize(15);
  String nom = (usuarioFeriaActivo != null) ? usuarioFeriaActivo.nombre : nombreJugador;
  text("PARTICIPANTE: " + strToUpper(nom), lx, boxY + 20);

  fill(255);
  textSize(60);
  text(feriaPuntaje + " PTS", lx, boxY + 46);

  if (feriaFueNuevoRecordFeria) {
    fill(colOro);
    textSize(17);
    text("* NUEVO RECORD #1 DE LA FERIA! *", lx, boxY + 120);
  } else if (feriaFueNuevoRecordPersonal) {
    fill(colG);
    textSize(16);
    text("* NUEVO RECORD PERSONAL! *", lx, boxY + 120);
  } else {
    fill(175, 215, 195);
    textSize(14);
    int bestP = (usuarioFeriaActivo != null) ? usuarioFeriaActivo.mejorPuntaje : feriaPuntaje;
    text("Tu mejor marca permanente: " + bestP + " PTS", lx, boxY + 122);
  }

  fill(colOro);
  textSize(19);
  text("PUESTO EN EL RANKING: #" + max(1, feriaPosicionRankingActual) + " DE " + max(1, registrosFeria.size()), lx, boxY + 154);

  int acc = (feriaCartasResueltas > 0) ? round((feriaAciertos * 100.0) / feriaCartasResueltas) : 100;
  float statBoxY = boxY + 196;
  stroke(colCyan, 90);
  strokeWeight(1.5);
  line(mX + 24, statBoxY - 8, mX + leftW - 24, statBoxY - 8);

  textAlign(LEFT, TOP);
  float sCol1 = mX + 32;
  float sCol2 = mX + leftW * 0.54;
  float dy = 34;

  fill(185, 225, 205); textSize(14); text("Oleada Alcanzada", sCol1, statBoxY);
  fill(255); text("NV." + feriaNivelPresion + " (x" + nf(obtenerFactorVelocidadFeria(), 1, 1) + ")", sCol2, statBoxY);

  fill(185, 225, 205); text("Cartas Resueltas", sCol1, statBoxY + dy);
  fill(255); text(feriaCartasResueltas + " (" + feriaAciertos + " bien / " + feriaErrores + " err)", sCol2, statBoxY + dy);

  fill(185, 225, 205); text("Precision Global", sCol1, statBoxY + dy * 2);
  fill(colG); text(acc + "%", sCol2, statBoxY + dy * 2);

  fill(185, 225, 205); text("Combo Maximo", sCol1, statBoxY + dy * 3);
  fill(colOro); text("x" + feriaMejorComboPartida, sCol2, statBoxY + dy * 3);

  fill(185, 225, 205); text("Tiempo Sobrevivido", sCol1, statBoxY + dy * 4);
  fill(255); text(feriaFormatearTiempo(feriaTiempoSobrevividoSeg), sCol2, statBoxY + dy * 4);

  dibujarPanelPersona(rightX, boxY, rightW, boxH, colOro, color(6, 14, 12, 242));
  textAlign(CENTER, TOP);
  fill(colOro);
  textSize(18);
  text("TOP 6 SALON DE LA FAMA PERMANENTE", rightX + rightW * 0.5, boxY + 20);

  float rowY0 = boxY + 58;
  float rW = rightW - 40;
  float rH = 44;
  int topN = min(6, registrosFeria.size());
  for (int i = 0; i < topN; i++) {
    RegistroFeria r = registrosFeria.get(i);
    float ry = rowY0 + i * (rH + 8);
    boolean esYo = (usuarioFeriaActivo != null && r.id.equals(usuarioFeriaActivo.id));
    rectMode(CORNER);
    fill(esYo ? color(20, 56, 40) : color(10, 22, 17));
    stroke(esYo ? colCyan : (i == 0 ? colOro : feriaConAlpha(colG, 70)));
    strokeWeight(esYo ? 2.0 : 1.0);
    rect(rightX + 20, ry, rW, rH, 5);

    textAlign(LEFT, CENTER);
    textSize(15);
    fill(i == 0 ? colOro : (esYo ? colCyan : color(220, 240, 230)));
    text("#" + (i + 1) + "  " + r.nombre, rightX + 34, ry + rH * 0.5 - 1);

    textAlign(RIGHT, CENTER);
    textSize(15);
    text(r.mejorPuntaje + " PTS  |  x" + r.mejorCombo + "  |  " + r.mejorCartas + "C", rightX + rightW - 34, ry + rH * 0.5 - 1);
  }

  float btnW = 285;
  float btnH = 52;
  float btnY = height * 0.90;
  float bRetryX = width * 0.5 - 315;
  float bRankX  = width * 0.5;
  float bMenuX  = width * 0.5 + 315;

  boolean hovRetry = evaluarHover(bRetryX, btnY, btnW, btnH);
  boolean hovRank  = evaluarHover(bRankX, btnY, btnW, btnH);
  boolean hovMenu  = evaluarHover(bMenuX, btnY, btnW, btnH);

  rectMode(CENTER);
  fill(hovRetry ? color(20, 145, 80) : color(10, 75, 42));
  stroke(hovRetry ? color(255) : colG);
  strokeWeight(2);
  rect(bRetryX, btnY, btnW, btnH, 6);
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(17);
  text("REINTENTAR", bRetryX, btnY - 2);

  fill(hovRank ? color(25, 115, 140) : color(12, 56, 72));
  stroke(hovRank ? color(255) : colCyan);
  rect(bRankX, btnY, btnW, btnH, 6);
  fill(255);
  textSize(15);
  text("RANKING / CAMBIAR JUGADOR", bRankX, btnY - 2);

  fill(hovMenu ? color(135, 24, 24) : color(65, 14, 14));
  stroke(hovMenu ? color(255) : color(255, 80, 80));
  rect(bMenuX, btnY, btnW, btnH, 6);
  fill(255);
  textSize(17);
  text("VOLVER AL MENU", bMenuX, btnY - 2);

  popStyle();
}

void mousePressedGameOverFeria() {
  float btnW = 285;
  float btnH = 52;
  float btnY = height * 0.90;
  float bRetryX = width * 0.5 - 315;
  float bRankX  = width * 0.5;
  float bMenuX  = width * 0.5 + 315;

  if (evaluarHover(bRetryX, btnY, btnW, btnH)) {
    reproducirTap();
    iniciarPartidaModoFeria();
  } else if (evaluarHover(bRankX, btnY, btnW, btnH)) {
    reproducirTap();
    detenerTodaMusica();
    abrirPantallaModoFeria();
  } else if (evaluarHover(bMenuX, btnY, btnW, btnH)) {
    reproducirTap();
    volverAlMenuPrincipal();
  }
}
