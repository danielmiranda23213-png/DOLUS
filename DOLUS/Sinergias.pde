String[] synCatId = new String[8];
String[] synCatNombre = new String[8];
String[] synCatDescripcion = new String[8];
int[][] synCatPluginsReq = new int[8][];
int[] synCatEfectoId = new int[8];
int numCatalogoSinergias = 0;

int[] sinergiasActivas = new int[8];
int numSinergiasActivas = 0;

void agregarSinergiaCatalogo(String id, String nombre, String descripcion, int[] reqs, int efectoId) {
  if (numCatalogoSinergias >= 8) return;
  int idx = numCatalogoSinergias;
  synCatId[idx] = id;
  synCatNombre[idx] = nombre;
  synCatDescripcion[idx] = descripcion;
  synCatPluginsReq[idx] = reqs;
  synCatEfectoId[idx] = efectoId;
  numCatalogoSinergias++;
}

void inicializarSinergias() {
  numCatalogoSinergias = 0;

  agregarSinergiaCatalogo("SYN.01", "RED ESPECIALISTA", "Combina Firewall (N.02) y Antena (N.09). Los mensajes de malware se auto-destruyen.", new int[]{1, 8}, 1);

  agregarSinergiaCatalogo("SYN.02", "CAOS CUÁNTICO", "Combina Overclock (N.03) y Acelerador (N.13). Genera 2 tokens pasivamente cada 10s.", new int[]{2, 12}, 2);

  agregarSinergiaCatalogo("SYN.03", "SIMBIOSIS OSCURA", "Combina Virus (N.06) y Parásito (N.19). La pérdida de salud mental se reduce a 0.", new int[]{5, 18}, 3);

  agregarSinergiaCatalogo("SYN.04", "FORTUNA PERFECTA", "Combina Imán (N.05) y Cristalizador (N.18). El combo máximo se multiplica x2 al liquidar.", new int[]{4, 17}, 4);

  agregarSinergiaCatalogo("SYN.05", "TRINIDAD DEFENSIVA", "Combina Máscara (N.04), Proxy (N.14) y Jammer (N.20). Inmunidad a reputación negativa.", new int[]{3, 13, 19}, 5);
}

void evaluarSinergias() {
  numSinergiasActivas = 0;
  for (int s = 0; s < numCatalogoSinergias; s++) {
    boolean sinergiaCumplida = true;
    int numReqs = contarEnteros(synCatPluginsReq[s]);
    for (int r = 0; r < numReqs; r++) {
      int reqId = synCatPluginsReq[s][r];
      if (!pluginEquipado(reqId)) {
        sinergiaCumplida = false;
        break;
      }
    }
    if (sinergiaCumplida && numSinergiasActivas < 8) {
      sinergiasActivas[numSinergiasActivas] = s;
      numSinergiasActivas++;
      registrarSinergiaDescubierta(synCatEfectoId[s] - 1);
    }
  }
}

boolean sinergiaActiva(int efectoId) {
  for (int i = 0; i < numSinergiasActivas; i++) {
    int s = sinergiasActivas[i];
    if (synCatEfectoId[s] == efectoId) return true;
  }
  return false;
}

boolean tieneTipoPluginPoseido(int tipoBuscado) {
  if (pluginEquipado(tipoBuscado)) return true;
  for (int i = 0; i < numInventarioPlugins; i++) {
    int idx = inventarioPlugins[i];
    if (idx >= 0 && idx < numCatalogoPlugins) {
      if (plugCatTipoPlugin[idx] == tipoBuscado) return true;
    }
  }
  return false;
}

boolean pluginFormaSinergiaConInventario(int catIndex) {
  if (catIndex < 0 || catIndex >= numCatalogoPlugins) return false;
  int candTipo = plugCatTipoPlugin[catIndex];
  if (candTipo <= 0) return false;

  for (int s = 0; s < numCatalogoSinergias; s++) {
    boolean estaEnReceta = false;
    boolean tieneCompanero = false;
    int numReqs = contarEnteros(synCatPluginsReq[s]);
    for (int r = 0; r < numReqs; r++) {
      int reqId = synCatPluginsReq[s][r];
      if (reqId == candTipo) {
        estaEnReceta = true;
      } else {
        if (tieneTipoPluginPoseido(reqId)) {
          tieneCompanero = true;
        }
      }
    }
    if (estaEnReceta && tieneCompanero) return true;
  }
  return false;
}

String obtenerNombreCortoPlugin(int catIndex) {
  if (catIndex < 0 || catIndex >= numCatalogoPlugins) return "";
  String raw = plugCatCategoria[catIndex];
  if (raw == null) return "";
  int sep = strIndexOf(raw, " - ");
  return (sep > 0) ? raw.substring(0, sep) : raw;
}

String obtenerCompanerosSinergiaActiva(int catIndex) {
  if (catIndex <= 0 || catIndex >= numCatalogoPlugins) return "";
  int tipoPlug = plugCatTipoPlugin[catIndex];
  String[] companeros = new String[16];
  int numComp = 0;
  for (int a = 0; a < numSinergiasActivas; a++) {
    int s = sinergiasActivas[a];
    int numReqs = contarEnteros(synCatPluginsReq[s]);
    boolean participa = false;
    for (int r = 0; r < numReqs; r++) {
      if (synCatPluginsReq[s][r] == tipoPlug) { participa = true; break; }
    }
    if (!participa) continue;
    for (int r = 0; r < numReqs; r++) {
      int reqId = synCatPluginsReq[s][r];
      if (reqId == tipoPlug) continue;
      String nomComp = obtenerNombreCortoPlugin(reqId);
      if (!nomComp.equals("") && !arrayContieneTexto(companeros, numComp, nomComp) && numComp < 16) {
        companeros[numComp] = nomComp;
        numComp++;
      }
    }
  }
  if (numComp == 0) return "";
  String out = "";
  for (int i = 0; i < numComp; i++) {
    if (i > 0) out += " + ";
    out += companeros[i];
  }
  return out;
}

String obtenerCompanerosSinergiaCompatible(int catIndex) {
  if (catIndex <= 0 || catIndex >= numCatalogoPlugins) return "";
  int tipoPlug = plugCatTipoPlugin[catIndex];
  String[] companeros = new String[16];
  int numComp = 0;
  for (int s = 0; s < numCatalogoSinergias; s++) {
    int numReqs = contarEnteros(synCatPluginsReq[s]);
    boolean estaEnReceta = false;
    for (int r = 0; r < numReqs; r++) {
      if (synCatPluginsReq[s][r] == tipoPlug) { estaEnReceta = true; break; }
    }
    if (!estaEnReceta) continue;
    for (int r = 0; r < numReqs; r++) {
      int reqId = synCatPluginsReq[s][r];
      if (reqId != tipoPlug && tieneTipoPluginPoseido(reqId)) {
        String nomComp = obtenerNombreCortoPlugin(reqId);
        if (!nomComp.equals("") && !arrayContieneTexto(companeros, numComp, nomComp) && numComp < 16) {
          companeros[numComp] = nomComp;
          numComp++;
        }
      }
    }
  }
  if (numComp == 0) return "";
  String out = "";
  for (int i = 0; i < numComp; i++) {
    if (i > 0) out += " + ";
    out += companeros[i];
  }
  return out;
}

boolean slotPerteneceASinergiaActiva(int slotIndex) {
  if (slotsPluginEquipado == null || slotIndex <= 0 || slotIndex >= 5) return false;
  int catIdx = slotsPluginEquipado[slotIndex];
  if (catIdx <= 0 || catIdx >= numCatalogoPlugins) return false;
  int tipoPlug = plugCatTipoPlugin[catIdx];
  for (int a = 0; a < numSinergiasActivas; a++) {
    int s = sinergiasActivas[a];
    int numReqs = contarEnteros(synCatPluginsReq[s]);
    for (int r = 0; r < numReqs; r++) {
      if (synCatPluginsReq[s][r] == tipoPlug) return true;
    }
  }
  return false;
}
