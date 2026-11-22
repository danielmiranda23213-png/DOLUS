
int[] slotsPluginEquipado = {0, -1, -1, -1, -1};

int[] cooldownActivaRestante = {0, 0, 0, 0, 0};

boolean bulletTimeActivo = false;
int bulletTimeDuracionRestante = 0;

boolean jackpotBinarioActivo = false;
int jackpotDuracionRestante = 0;

boolean jammingActivo = false;
int jammingDuracionRestante = 0;

boolean rachaImparableActiva = false;
int rachaDuracionRestante = 0;

boolean invisibleActivo = false;
int invisibleDuracionRestante = 0;

boolean modoAutomaticoActivo = false;
int modoAutomaticoDuracionRestante = 0;

boolean singularidadActiva = false;
int singularidadDuracionRestante = 0;

boolean doppelgangerActivo = false;

boolean trampaDesplegadaActiva = false;

int virusErroresTolerados = 0;

boolean rescatePopUsado = false;
boolean rescateSegUsado = false;
boolean rescateRepUsado = false;
boolean rescateSalUsado = false;

int parasitoErroresAbsorbidos = 0;

float cristalizadorBonusPermanente = 0.0;
int comboRecordPartida = 0;

float multiplicadorRecompensas = 1.0;

boolean pluginEquipado(int tipoPlugin) {
  int totalSlots = limiteMaxSlotsRack();
  for (int i = 1; i < totalSlots; i++) {
    if (jefeActivo == 4 && i == slotSilenciadoAlgoritmo) continue;
    if (slotsPluginEquipado[i] >= 0 && slotsPluginEquipado[i] < numCatalogoPlugins) {
      if (plugCatTipoPlugin[slotsPluginEquipado[i]] == tipoPlugin) return true;
    }
  }
  return false;
}

int slotConPlugin(int tipoPlugin) {
  int totalSlots = limiteMaxSlotsRack();
  for (int i = 1; i < totalSlots; i++) {
    if (jefeActivo == 4 && i == slotSilenciadoAlgoritmo) continue;
    if (slotsPluginEquipado[i] >= 0 && slotsPluginEquipado[i] < numCatalogoPlugins) {
      if (plugCatTipoPlugin[slotsPluginEquipado[i]] == tipoPlugin) return i;
    }
  }
  return -1;
}

void sincronizarSlotsEquipados() {
  int totalSlots = limiteMaxSlotsRack();
  int[] prevSlots = new int[5];
  int[] prevCD = new int[5];
  for (int i = 0; i < 5; i++) {
    prevSlots[i] = slotsPluginEquipado[i];
    prevCD[i] = cooldownActivaRestante[i];
  }
  slotsPluginEquipado[0] = 0;
  cooldownActivaRestante[0] = 0;
  for (int s = 1; s < 5; s++) {
    int invIdx = s - 1;
    if (s < totalSlots && invIdx < numInventarioPlugins) {
      int catIdx = inventarioPlugins[invIdx];
      slotsPluginEquipado[s] = catIdx;
      int cdConservado = 0;
      for (int k = 1; k < 5; k++) {
        if (prevSlots[k] == catIdx) {
          cdConservado = prevCD[k];
          break;
        }
      }
      cooldownActivaRestante[s] = cdConservado;
    } else {
      slotsPluginEquipado[s] = -1;
      cooldownActivaRestante[s] = 0;
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
  recargarDatosPlugins();
}

void actualizarTemporizadoresPlugins() {

  for (int i = 0; i < 5; i++) {
    if (cooldownActivaRestante[i] > 0) cooldownActivaRestante[i]--;
  }

  if (bulletTimeActivo) { bulletTimeDuracionRestante--; if (bulletTimeDuracionRestante <= 0) bulletTimeActivo = false; }
  if (jackpotBinarioActivo) { jackpotDuracionRestante--; if (jackpotDuracionRestante <= 0) jackpotBinarioActivo = false; }
  if (jammingActivo) { jammingDuracionRestante--; if (jammingDuracionRestante <= 0) jammingActivo = false; }
  if (rachaImparableActiva) { rachaDuracionRestante--; if (rachaDuracionRestante <= 0) rachaImparableActiva = false; }
  if (invisibleActivo) { invisibleDuracionRestante--; if (invisibleDuracionRestante <= 0) invisibleActivo = false; }
  if (modoAutomaticoActivo) { modoAutomaticoDuracionRestante--; if (modoAutomaticoDuracionRestante <= 0) modoAutomaticoActivo = false; }
  if (singularidadActiva) { singularidadDuracionRestante--; if (singularidadDuracionRestante <= 0) singularidadActiva = false; }

  multiplicadorRecompensas = 1.0;

  if (pluginEquipado(10)) multiplicadorRecompensas += (comboActual / 5) * 0.10;

  if (pluginEquipado(15)) multiplicadorRecompensas += 0.25;

  if (pluginEquipado(20)) multiplicadorRecompensas += 2.0;

  multiplicadorRecompensas += cristalizadorBonusPermanente;

  if (voucherBusOverclockActivo) multiplicadorRecompensas *= 1.35;
}

void resetearEstadosPlugins() {
  slotsPluginEquipado[0] = 0;
  cooldownActivaRestante[0] = 0;
  for (int i = 1; i < 5; i++) {
    slotsPluginEquipado[i] = -1;
    cooldownActivaRestante[i] = 0;
  }
  bulletTimeActivo = false;
  jackpotBinarioActivo = false;
  jammingActivo = false;
  rachaImparableActiva = false;
  invisibleActivo = false;
  modoAutomaticoActivo = false;
  singularidadActiva = false;
  doppelgangerActivo = false;
  trampaDesplegadaActiva = false;
  virusErroresTolerados = 0;
  rescatePopUsado = false;
  rescateSegUsado = false;
  rescateRepUsado = false;
  rescateSalUsado = false;
  parasitoErroresAbsorbidos = 0;
  cristalizadorBonusPermanente = 0.0;
  comboRecordPartida = 0;
  multiplicadorRecompensas = 1.0;

  rondaActual = 1;
  reiniciarVouchersPartida();
  mensajesProcesadosRonda = 0;
  mensajesPorRonda = 8;
  rondaCompletada = false;
  jefeActivo = 0;
  numInventarioPlugins = 0;
  if (conservarPluginsTrasDerrota && numPluginsConservadosDerrota > 0) {
    int maxEq = limiteMaxPluginsEquipados();
    for (int i = 0; i < numPluginsConservadosDerrota; i++) {
      int idx = pluginsConservadosDerrota[i];
      if (idx >= 1 && idx < numCatalogoPlugins && !arrayContieneInt(inventarioPlugins, numInventarioPlugins, idx) && numInventarioPlugins < maxEq && numInventarioPlugins < 16) {
        inventarioPlugins[numInventarioPlugins++] = idx;
      }
    }
  }
  tiendaOpciones = new int[]{-1, -1, -1};
  tiendaPrecios = new int[]{0, 0, 0};
  tiendaComprado = new boolean[]{false, false, false};
  limpiarColaEventos();
}

int[] pluginsConservadosDerrota = new int[16];
int numPluginsConservadosDerrota = 0;
boolean conservarPluginsTrasDerrota = false;

void guardarPluginsTrasDerrota() {
  numPluginsConservadosDerrota = 0;
  for (int i = 0; i < numInventarioPlugins; i++) {
    int idx = inventarioPlugins[i];
    if (idx >= 1 && idx < numCatalogoPlugins && !arrayContieneInt(pluginsConservadosDerrota, numPluginsConservadosDerrota, idx) && numPluginsConservadosDerrota < 16) {
      pluginsConservadosDerrota[numPluginsConservadosDerrota++] = idx;
    }
  }
  conservarPluginsTrasDerrota = (numPluginsConservadosDerrota > 0);
}

void limpiarPluginsConservadosDerrota() {
  numPluginsConservadosDerrota = 0;
  conservarPluginsTrasDerrota = false;
}

void activarHabilidadPlugin(int slotIndex) {
  if (slotIndex <= 0 || slotIndex >= 4) return;

  if (jefeActivo == 4 && slotIndex == slotSilenciadoAlgoritmo) {
    if (sonidoErrorMsj != null) reproducirSFX(sonidoErrorMsj);
    juiceSlotPlugin(slotIndex);
    dispararTextoElastico("NODO SILENCIADO!", width * 0.15, leftPanelSlotY[slotIndex], color(255, 70, 70));
    return;
  }

  int catIndex = slotsPluginEquipado[slotIndex];
  if (catIndex == -1) return;

  if (plugCatCostoTokensActiva[catIndex] < 0 && plugCatCooldownActivaSegundos[catIndex] < 0 && !plugCatEsConsumible[catIndex]) return;

  int costoReal = max(0, plugCatCostoTokensActiva[catIndex]);
  if (tokensDolus < costoReal) {
    if (sonidoErrorMsj != null) reproducirSFX(sonidoErrorMsj);
    juiceSlotPlugin(slotIndex);
    dispararTextoElastico("FALTAN TOKENS", width * 0.15, leftPanelSlotY[slotIndex], color(255, 70, 70));
    return;
  }
  if (cooldownActivaRestante[slotIndex] > 0) {
    if (sonidoErrorMsj != null) reproducirSFX(sonidoErrorMsj);
    juiceSlotPlugin(slotIndex);
    return;
  }

  tokensDolus -= costoReal;
  pulsoTokensUI = 1.0;
  juiceSlotPlugin(slotIndex);
  dispararMarcoRayosPlugin(slotIndex, colorTema());
  dispararTextoElastico("!" + plugCatNombreActiva[catIndex] + "!", width * 0.15, leftPanelSlotY[slotIndex], colorTema());
  if (sndClickPlugin != null) reproducirSFX(sndClickPlugin);
  if (plugCatCooldownActivaSegundos[catIndex] > 0) {
    int segs = plugCatCooldownActivaSegundos[catIndex];
    if (voucherBusOverclockActivo) segs = max(1, segs / 2);
    cooldownActivaRestante[slotIndex] = segs * 60;
  }

  switch (plugCatTipoPlugin[catIndex]) {
    case 1:
      for (int i = numColaMensajes - 1; i >= 0; i--) {
        if (msgTipoMaldad[colaMensajes[i]] == 2) {
          eliminarColaMensajeEn(i);
        }
      }
      break;
    case 2:
      bulletTimeActivo = true;
      bulletTimeDuracionRestante = 480;
      break;
    case 3:
      doppelgangerActivo = true;
      break;
    case 4:
      jackpotBinarioActivo = true;
      jackpotDuracionRestante = 900;
      break;
    case 5:
      for (int i = 0; i < numColaMensajes; i++) {
        msgTipoMaldad[colaMensajes[i]] = 0;
      }
      statSeguridad -= 15;
      statSeguridad = constrain(statSeguridad, 0, 100);
      pulsarBarraStat(1);
      break;
    case 6:
      if (mensajeActivo >= 0) {
        msgVerificado[mensajeActivo] = true;
        juiceCartaActiva(0.25);
      }
      break;
    case 7:
      statSaludMental = constrain(statSaludMental + 10, 0, 100);
      pulsarBarraStat(0);
      break;
    case 8:
      jammingActivo = true;
      jammingDuracionRestante = 600;
      break;
    case 9:
      statSaludMental += 25;
      statSaludMental = constrain(statSaludMental, 0, 100);
      pulsarBarraStat(0);
      break;
    case 10:
      rachaImparableActiva = true;
      rachaDuracionRestante = 1200;
      break;
    case 11:
      trampaDesplegadaActiva = true;
      break;
    case 12:
      for (int i = 0; i < 3; i++) {
        String[] rems = {"Inocente_A", "Amigo_B", "User_Inocente"};
        String[] conts = {"Hola!", "Mira esto", "Buen post"};
        int r = int(random(3));
        encolarMensaje(crearMensajeDolus(rems[r], conts[r], 0));
      }
      break;
    case 13:
      invisibleActivo = true;
      invisibleDuracionRestante = 720;
      statPopularidad -= 5;
      statPopularidad = constrain(statPopularidad, 0, 100);
      pulsarBarraStat(3);
      break;
    case 14:
      statPopularidad = 50;
      statSeguridad = 50;
      statReputacion = 50;
      statSaludMental = 50;
      slotsPluginEquipado[slotIndex] = -1;
      break;
    case 15:
      limpiarColaMensajes();
      triggerGlitchProfesional();
      break;
    case 16:
      modoAutomaticoActivo = true;
      modoAutomaticoDuracionRestante = 600;
      break;
    case 17:
      tokensDolus += (comboActual / 2) * (sinergiaActiva(4) ? 2 : 1);
      comboActual = 0;
      break;
    case 18:
      comboActual *= 2;
      statSaludMental -= 20;
      statSaludMental = constrain(statSaludMental, 0, 100);
      pulsarBarraStat(0);
      break;
    case 19:
      for (int i = numColaMensajes - 1; i >= 0; i--) {
        if (msgTipoMaldad[colaMensajes[i]] == 1) {
          eliminarColaMensajeEn(i);
          statSaludMental += 3;
        }
      }
      statSaludMental = constrain(statSaludMental, 0, 100);
      pulsarBarraStat(0);
      break;
    case 20:
      singularidadActiva = true;
      singularidadDuracionRestante = 300;
      statPopularidad = 75;
      statSeguridad = 75;
      statReputacion = 75;
      statSaludMental = 75;
      comboActual = 10;
      break;
    case 101:
      {
        int cantQ = min(3, numColaMensajes);
        for (int k = 0; k < cantQ; k++) {
          eliminarColaMensajeEn(0);
          balanzaEstabilidad++;
        }
      }
      break;
    case 102:
      statSaludMental += 25;
      pulsarBarraStat(0);
      break;
    case 103:
      for (int i = 0; i < numColaMensajes; i++) {
        int mj = colaMensajes[i];
        if (msgTipoMaldad[mj] != 0) msgContenido[mj] = "[ALERTA PELIGRO] " + msgContenido[mj];
      }
      break;
    case 104:
      vidasJugador++;
      break;
  }

  if (plugCatEsConsumible[catIndex] || plugCatTipoPlugin[catIndex] == 14) {
    for (int i = 0; i < numInventarioPlugins; i++) {
      if (inventarioPlugins[i] == catIndex) {
        eliminarInventarioPluginEn(i);
        break;
      }
    }
    for (int i = 1; i < numPluginsJugador; i++) {
      if (plugCatId[pluginsJugador[i]].equals(plugCatId[catIndex])) {
        for (int k = i; k < numPluginsJugador - 1; k++) {
          pluginsJugador[k] = pluginsJugador[k + 1];
        }
        numPluginsJugador--;
        break;
      }
    }
    sincronizarSlotsEquipados();
    recargarDatosPlugins();
  }
  evaluarSinergias();
}

int rondaActual = 1;
int mensajesProcesadosRonda = 0;
int mensajesPorRonda = 8;
boolean rondaCompletada = false;
float timerTransicionTienda = 0;

float progresoTransicionTienda = 1.0;
boolean animandoTransicionTienda = false;
int sentidoTransicionTienda = 0;
final float VELOCIDAD_TRANSICION_TIENDA = 0.048;

boolean animandoSalidaLiquidacion = false;
float progresoSalidaLiquidacion = 0.0;

int[] inventarioPlugins = new int[16];
int numInventarioPlugins = 0;

void agregarInventarioPlugin(int catIdx) {
  if (numInventarioPlugins < 16) {
    inventarioPlugins[numInventarioPlugins++] = catIdx;
  }
}

void eliminarInventarioPluginEn(int pos) {
  if (pos < 0 || pos >= numInventarioPlugins) return;
  for (int i = pos; i < numInventarioPlugins - 1; i++) {
    inventarioPlugins[i] = inventarioPlugins[i + 1];
  }
  numInventarioPlugins--;
}

int[] tiendaOpciones = {-1, -1, -1};
int[] tiendaPrecios = {0, 0, 0};
PImage[] imagenesTienda = new PImage[3];
boolean[] tiendaComprado = {false, false, false};

boolean yaPoseePlugin(int catIndex) {
  if (catIndex == 0) return true;
  for (int j = 0; j < numInventarioPlugins; j++) {
    if (inventarioPlugins[j] == catIndex) return true;
  }
  return false;
}

void reemplazarOfertasDuplicadasEnTienda() {
  for (int i = 0; i < 3; i++) {
    if (tiendaOpciones[i] == -1 || tiendaComprado[i]) continue;
    if (!yaPoseePlugin(tiendaOpciones[i])) continue;

    int[] disponibles = new int[32];
    int numDisponibles = 0;
    for (int c = 1; c < numCatalogoPlugins; c++) {
      if (yaPoseePlugin(c)) continue;
      boolean yaEnOtroSlot = false;
      for (int s = 0; s < 3; s++) {
        if (s != i && tiendaOpciones[s] == c) {
          yaEnOtroSlot = true;
          break;
        }
      }
      if (!yaEnOtroSlot && numDisponibles < 32) {
        disponibles[numDisponibles++] = c;
      }
    }

    if (numDisponibles > 0) {
      int[] urna = new int[64];
      int numUrna = 0;
      for (int k = 0; k < numDisponibles; k++) {
        int cand = disponibles[k];
        int peso = pluginFormaSinergiaConInventario(cand) ? 3 : 1;
        for (int w = 0; w < peso; w++) {
          if (numUrna < 64) urna[numUrna++] = cand;
        }
      }
      int elegido = urna[int(random(numUrna))];
      tiendaOpciones[i] = elegido;
      tiendaPrecios[i] = plugCatPrecioTokens[elegido];
      imagenesTienda[i] = plugCatImgTienda[elegido];
    } else {
      tiendaOpciones[i] = -1;
      tiendaPrecios[i] = 0;
      tiendaComprado[i] = true;
    }
  }
}

void generarOpcionesTienda() {
  int[] disponibles = new int[32];
  int numDisponibles = 0;
  for (int i = 1; i < numCatalogoPlugins; i++) {
    if (!yaPoseePlugin(i) && numDisponibles < 32) {
      disponibles[numDisponibles++] = i;
    }
  }

  for (int i = 0; i < 3; i++) {
    if (numDisponibles > 0) {
      int[] urna = new int[64];
      int numUrna = 0;
      for (int k = 0; k < numDisponibles; k++) {
        int cand = disponibles[k];
        int peso = pluginFormaSinergiaConInventario(cand) ? 3 : 1;
        for (int w = 0; w < peso; w++) {
          if (numUrna < 64) urna[numUrna++] = cand;
        }
      }
      int elegido = urna[int(random(numUrna))];
      for (int k = numDisponibles - 1; k >= 0; k--) {
        if (disponibles[k] == elegido) {
          for (int m = k; m < numDisponibles - 1; m++) {
            disponibles[m] = disponibles[m + 1];
          }
          numDisponibles--;
        }
      }

      tiendaOpciones[i] = elegido;
      tiendaPrecios[i] = plugCatPrecioTokens[elegido];
      imagenesTienda[i] = plugCatImgTienda[elegido];
    } else {
      tiendaOpciones[i] = -1;
      tiendaPrecios[i] = 0;
    }
    tiendaComprado[i] = false;
  }
}

boolean comprarPlugin(int indiceTienda) {
  if (indiceTienda < 0 || indiceTienda >= 3) return false;
  if (tiendaOpciones[indiceTienda] == -1) return false;
  if (tiendaComprado[indiceTienda]) return false;
  int catIndex = tiendaOpciones[indiceTienda];
  if (yaPoseePlugin(catIndex)) {
    reemplazarOfertasDuplicadasEnTienda();
    return false;
  }
  if (tokensDolus < tiendaPrecios[indiceTienda]) return false;
  if (numInventarioPlugins >= limiteMaxPluginsEquipados()) return false;

  tokensDolus -= tiendaPrecios[indiceTienda];
  pulsoTokensUI = 1.0;
  agregarInventarioPlugin(catIndex);
  tiendaComprado[indiceTienda] = true;
  registrarPluginDescubierto(catIndex);

  sincronizarSlotsEquipados();
  int nuevoSlot = constrain(numInventarioPlugins, 1, max(1, limiteMaxSlotsRack() - 1));
  juiceSlotPlugin(nuevoSlot);
  evaluarSinergias();
  reproducirTap();
  return true;
}

void venderPlugin(int inventarioIndex) {
  if (inventarioIndex < 0 || inventarioIndex >= numInventarioPlugins) return;
  int catIndex = inventarioPlugins[inventarioIndex];
  int precioVenta = plugCatPrecioTokens[catIndex] / 2;
  tokensDolus += precioVenta;
  pulsoTokensUI = 1.0;
  fijarProgresoMaximoLogro(8, tokensDolus);
  eliminarInventarioPluginEn(inventarioIndex);

  sincronizarSlotsEquipados();
  evaluarSinergias();
  reproducirTap();
}

int obtenerMetaBalanzaRonda(int ronda, int jefe) {
  if (modoExposicionActivo) {
    if (jefe == 0) return 7;
    if (jefe == 1) return 4;
    if (jefe == 2) return 6;
    if (jefe == 3) return 4;
    if (jefe == 4) return 4;
    return 4;
  }
  if (jefe != 0) return 6;
  if (ronda <= 1) return 8;
  if (ronda == 2) return 10;
  return min(16, 10 + (ronda - 2));
}

int obtenerMetaBalanzaActual() {
  return obtenerMetaBalanzaRonda(rondaActual, jefeActivo);
}

int calcularMensajesPorRonda(int ronda) {
  return obtenerMetaBalanzaRonda(ronda, 0);
}

void iniciarNuevaRonda() {
  rondaActual++;
  mensajesProcesadosRonda = 0;
  cartasGeneradasEnRonda = 0;
  rondaCompletada = false;
  timerTransicionTienda = 0;
  liquidacionCalculada = false;
  tokensInicioRonda = tokensDolus;
  liqFarmRonda = 0;
  limpiarColaMensajes();
  mensajeActivo = -1;
  numCartasSaliendo = 0;
  numParticulasRielSwipe = 0;
  numRayosRielSwipe = 0;
  comboMaximoRonda = 0;
  balanzaEstabilidad = 0;
  ultimoEmpujonActivo = false;
  ultimoEmpujonAnunciado = false;
  resetearMensajesUsadosRonda();
  jefeActivo = 0;
  conversanteActual = 0;
  jefePendiente = 0;
  guiaErrorActiva = false;
  mostrandoTutorialIngame = false;
  if (rondaActual > 1) {
    mostrandoTutorial = false;
  }

  mensajesPorRonda = calcularMensajesPorRonda(rondaActual);
  if (modoExposicionActivo) {
    directivaRondaActual = 0;
    if (rondaActual >= 2 && rondaActual <= 5) {
      iniciarEncuentroJefeEnPartida(rondaActual - 1);
    }
    return;
  }
  elegirDirectivaRonda();

  if (rondaActual % 3 == 0) {
    int bossIndex = ((rondaActual / 3 - 1) % 4) + 1;
    iniciarEncuentroJefeEnPartida(bossIndex);
  } else {
    if (rondaActual == 4 && !dialogoAscensoRonda5Visto) {
      dialogoAscensoRonda5Visto = true;
      iniciarDialogoAscensoRonda5();
    } else {
      if (!mostrandoTutorial) {
        dispararShowcaseDirectiva();
      }
    }
  }
}

void iniciarEncuentroJefeEnPartida(int tipoJefe) {
  detenerTodaMusica();
  mostrandoTutorial = false;
  mostrandoTutorialIngame = false;
  guiaErrorActiva = false;
  animandoShowcaseDirectiva = false;
  conversanteActual = tipoJefe;
  fasePluginsActiva = false;
  alphaAparicionJimbo = 1.0;
  animandoAparicionChat = false;
  progresoAparicionChat = 1.0;
  if (tipoJefe == 1) construirArbolJefe1(nombreJugador);
  else {
    if (tipoJefe == 2) construirArbolJefe2(nombreJugador);
    else {
      if (tipoJefe == 3) construirArbolJefe3(nombreJugador);
      else {
        if (tipoJefe == 4) construirArbolJefe4(nombreJugador);
      }
    }
  }
  iniciarCargaJefe(tipoJefe);
  estadoPantalla = PANTALLA_TRANSICION_JEFE;
}

void iniciarDialogoAscensoRonda5() {
  detenerTodaMusica();
  reproducirMusicaUnica(musicaMenu);
  mostrandoTutorial = false;
  mostrandoTutorialIngame = false;
  guiaErrorActiva = false;
  animandoShowcaseDirectiva = false;
  conversanteActual = 0;
  fasePluginsActiva = false;
  dialogoAbierto = false;
  alphaAparicionJimbo = 0.0;
  animandoAparicionChat = true;
  progresoAparicionChat = 0.0;
  construirArbolAdminRonda5(nombreJugador);
  estadoPantalla = PANTALLA_TRANSICION;
}

void iniciarCinematicaJefe(int tipoJefe) {
  detenerTodaMusica();
  detenerPistaSiSuena(sonidoAbsorcionTransicionVortice, null);
  detenerPistaSiSuena(sonidoNexusCargarBarra, null);
  detenerPistaSiSuena(sonidoDisrupcion1, null);
  detenerPistaSiSuena(sonidoDisrupcion2, null);
  detenerPistaSiSuena(sonidoTransferenciaExitosa, null);
  detenerPistaSiSuena(sonidoEstaticaTituloDolus, null);

  succionando = false;
  progresoSuccion = 0.0;
  escupiendoMenu = false;
  progresoEscupidoMenu = 0.0;
  quemandoDificultad = false;
  progresoQuemarDificultad = 0.0;
  animandoDificultad = false;
  progresoDificultad = 0.0;
  seleccionadoParaJugar = false;
  animandoTVOff = false;
  glitchActivo = false;
  mostrandoSplash = false;
  menuDaltonismoAbierto = false;
  juegoPausado = false;
  rondaCompletada = false;
  numCartasSaliendo = 0;
  balanzaEstabilidad = 0;
  ejecutandoLinkStart = false;
  progresoLinkStart = 0.0;
  intensidadSuccionFondo = 0.0;
  ejecutandoCargaNexus = false;
  ejecutandoPantallaCargaMeta = false;

  dificultadSeleccionada = 1;
  dificultadSeleccionadaPendiente = 1;
  inicializarJuego(1);
  terminarTutorial();
  mostrandoTutorial = false;

  if (numCatalogoPlugins == 0) {
    inicializarCatalogoPlugins();
  }
  if (numPluginsJugador == 0 && numCatalogoPlugins > 0) {
    pluginsJugador[0] = 0;
    numPluginsJugador = 1;
  }
  recargarDatosPlugins();
  inicializarPluginsGameplay();
  inicializarSinergias();
  evaluarSinergias();

  rondaActual = tipoJefe * 3;
  mensajesPorRonda = calcularMensajesPorRonda(rondaActual);
  mensajesProcesadosRonda = 0;
  comboActual = 0;
  comboMaximoRonda = 0;

  statSaludMental = 100;
  statSeguridad = 100;
  statReputacion = 100;
  statPopularidad = 100;
  vidasJugador = 3;
  tokensDolus = max(tokensDolus, 20);

  conversanteActual = tipoJefe;
  fasePluginsActiva = false;
  alphaAparicionJimbo = 1.0;
  animandoAparicionChat = false;
  progresoAparicionChat = 1.0;

  if (tipoJefe == 1) construirArbolJefe1(nombreJugador);
  else {
    if (tipoJefe == 2) construirArbolJefe2(nombreJugador);
    else {
      if (tipoJefe == 3) construirArbolJefe3(nombreJugador);
      else {
        if (tipoJefe == 4) construirArbolJefe4(nombreJugador);
      }
    }
  }

  iniciarCargaJefe(tipoJefe);
  estadoPantalla = PANTALLA_TRANSICION_JEFE;
  dispararTextoElastico("JEFE " + tipoJefe + " (NORMAL)", width * 0.5, height * 0.22, colorTema());
}

void verificarFinDeRonda() {
  if (modoFeriaActivo) return;
  int metaBal = obtenerMetaBalanzaActual();
  boolean metaBalanzaGanada = (balanzaEstabilidad >= metaBal);
  if (metaBalanzaGanada && !rondaCompletada && !estadoTransicionJefe) {
    if (jefeActivo != 0 && vidasJefe > 1) {

      estadoTransicionJefe = true;
      timerTransicionJefe = 180;
      vidasJefe = 1;
      faseCombateJefe = 2;
      dispararBarkAleatorioJefe(jefeActivo, 3);
      balanzaEstabilidad = 0;
      pulsoBalanzaUI = 1.0;
      anomaliasEncontradas = 0;
      ratingDeepfake = 0;
      dispararSacudidaCamara(12.0);

      limpiarColaMensajes();
      return;
    }

    if (jefeActivo == 3 && !modoExposicionActivo) {
      iniciarSecuenciaGlitchEscapeDeepfake();
      return;
    }

    rondaCompletada = true;
    timerTransicionTienda = 0;
    liquidacionCalculada = false;
    guardarPartidaActual();
    if (jefeActivo == 4) {
      ultimoJefeDerrotado = true;
    }
    if (jefeActivo != 0) {
      registrarProgresoLogro(9, 1);
    }
    if (jefeActivo == 1 && !recompensaJefe1Entregada) {
      viralidadDesbloqueada = true;
      recompensaJefe1Entregada = true;
    }
    if (jefeActivo == 2 && !recompensaJefe2Entregada) {
      librePensadorDesbloqueado = true;
      recompensaJefe2Entregada = true;
    }
    if (jefeActivo == 3 && !recompensaJefe3Entregada) {
      gafasPresentadorDesbloqueadas = true;
      recompensaJefe3Entregada = true;
    }
  } else {
    if (balanzaEstabilidad <= -metaBal && !rondaCompletada && !estadoTransicionJefe) {
      if (voucherLazarusActivo && !lazarusUsadoEnPartida) {
        lazarusUsadoEnPartida = true;
        balanzaEstabilidad = 0;
        statSaludMental = max(statSaludMental, 60.0);
        statPopularidad = max(statPopularidad, 60.0);
        statSeguridad   = max(statSeguridad, 60.0);
        statReputacion  = max(statReputacion, 60.0);
        vidasJugador    = max(vidasJugador, 1);
        dispararExplosionCarta(width * 0.5, height * 0.5, color(0, 230, 160), true);
        dispararTextoElastico("PROTOCOLO LAZARUS ACTIVADO! BALANZA RESTAURADA", width * 0.5, height * 0.35, color(0, 230, 160));
        dispararSacudidaCamara(6.0);
        if (sonidoShopBuy != null) reproducirSFX(sonidoShopBuy);
        return;
      }

      vidasJugador = -1;
      dispararGameOver(4, "La balanza se ha inclinado totalmente hacia el Algoritmo.\nHas perdido el control de la red.");
    }
  }
}
