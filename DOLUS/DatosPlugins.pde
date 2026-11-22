String[] plugCatId = new String[32];
String[] plugCatCategoria = new String[32];
String[] plugCatEstado = new String[32];
String[] plugCatDescripcion = new String[32];
String[] plugCatArchivoImagen = new String[32];

String[] plugCatNombrePasiva = new String[32];
String[] plugCatDescripcionPasiva = new String[32];
String[] plugCatNombreActiva = new String[32];
String[] plugCatDescripcionActiva = new String[32];
int[] plugCatCostoTokensActiva = new int[32];
int[] plugCatCooldownActivaSegundos = new int[32];
int[] plugCatTipoPlugin = new int[32];
boolean[] plugCatEsDoubleFilo = new boolean[32];
int[] plugCatPrecioTokens = new int[32];
boolean[] plugCatEsConsumible = new boolean[32];

PImage[] plugCatImgBase = new PImage[32];
PImage[] plugCatImgSlot = new PImage[32];
PImage[] plugCatImgZoom = new PImage[32];
PImage[] plugCatImgTienda = new PImage[32];
PImage[] plugCatImgIntro = new PImage[32];
PImage[] plugCatImgSpriteRaw = new PImage[32];
int[] plugCatSheetCol = new int[32];
int[] plugCatSheetRow = new int[32];

int numCatalogoPlugins = 0;

void agregarPluginCatalogo(String id, String categoria, String estado, String descripcion, String archivoImagen,
                           String nombrePasiva, String descripcionPasiva, String nombreActiva, String descripcionActiva,
                           int costoTokensActiva, int cooldownActivaSegundos, int tipoPlugin, boolean esDoubleFilo, int precioTokens) {
  if (numCatalogoPlugins >= 32) return;
  int idx = numCatalogoPlugins;
  plugCatId[idx] = id;
  plugCatCategoria[idx] = categoria;
  plugCatEstado[idx] = estado;
  plugCatDescripcion[idx] = descripcion;
  plugCatArchivoImagen[idx] = archivoImagen;
  plugCatNombrePasiva[idx] = nombrePasiva;
  plugCatDescripcionPasiva[idx] = descripcionPasiva;
  plugCatNombreActiva[idx] = nombreActiva;
  plugCatDescripcionActiva[idx] = descripcionActiva;
  plugCatCostoTokensActiva[idx] = costoTokensActiva;
  plugCatCooldownActivaSegundos[idx] = cooldownActivaSegundos;
  plugCatTipoPlugin[idx] = tipoPlugin;
  plugCatEsDoubleFilo[idx] = esDoubleFilo;
  plugCatPrecioTokens[idx] = precioTokens;
  plugCatEsConsumible[idx] = false;
  plugCatImgBase[idx] = null;
  plugCatImgSlot[idx] = null;
  plugCatImgZoom[idx] = null;
  plugCatImgTienda[idx] = null;
  plugCatImgIntro[idx] = null;
  plugCatImgSpriteRaw[idx] = null;
  plugCatSheetCol[idx] = -1;
  plugCatSheetRow[idx] = -1;
  numCatalogoPlugins++;
}

void inicializarCatalogoPlugins() {
  numCatalogoPlugins = 0;

  agregarPluginCatalogo(
    "N.01",
    "(Dolus Passcard ID: 001)",
    "ACTIVO",
    "LLAVE DE IDENTIDAD MAESTRA EMITIDA POR EL ADMINISTRADOR.\nAUTORIZA EL ENLACE CRIPTOGRÁFICO DIRECTO CON LA RED NEXUS.",
    "pluginimg_01.png",
    "Enlace Primario", "Mantiene la conexión activa con la red. Sin efectos pasivos adicionales en combate.",
    "Sin Activa", "No dispone de subrutinas de ejecución manual registradas.",
    -1, -1, 0, false, 0
  );

  agregarPluginCatalogo(
    "N.02", "FIREWALL NEURAL - DEFENSA // SEGURIDAD", "ACTIVO",
    "MATRIZ DEFENSIVA DE AISLAMIENTO PREVENTIVO.\nAMORTIGUA EL AVANCE DE CORRUPCIÓN Y PERMITE\nPURGAR CÓDIGO HOSTIL EN TIEMPO REAL.",
    "pluginimg_01.png",
    "Filtro Sináptico", "El Malware entrante decae 40% más lento, otorgando mayor ventana de reacción.",
    "Purga de Red", "Elimina inmediatamente todo el Malware activo sin penalizar tu Seguridad.",
    4, -1, 1, false, 36
  );

  agregarPluginCatalogo(
    "N.03", "OVERCLOCK CORTICAL - OFENSIVA // VELOCIDAD", "ACTIVO",
    "ACELERADOR NEURONAL DE FRECUENCIA EXPERIMENTAL.\nALTERA LA TASA DE PROCESAMIENTO MENTAL PARA\nCONGELAR CRISIS Y TOMAR CONTROL ABSOLUTO.",
    "pluginimg_01.png",
    "Sinapsis Acelerada", "Los paquetes entrantes se desplazan 25% más lento hacia el umbral crítico.",
    "Bullet Time Digital", "Congela el decaimiento de todas las Estadísticas durante 8s completos.",
    -1, 45, 2, false, 54
  );

  agregarPluginCatalogo(
    "N.04", "MÁSCARA DE DOLUS - ENGAÑO // SOCIAL", "ACTIVO",
    "MODULADOR DE IDENTIDAD EN RED Y CAMUFLAJE DIGITAL.\nREDUCE EL IMPACTO DE ERRORES PÚBLICOS MEDIANTE\nUN RASTRO CLANDESTINO DOBLADO.",
    "pluginimg_01.png",
    "Identidad Espejo", "Reduce un -50% cualquier penalización sufrida en tu Reputación.",
    "Doppelganger", "Absorbe y anula por completo el próximo error cometido, evitando pérdidas.",
    6, -1, 3, false, 40
  );

  agregarPluginCatalogo(
    "N.05", "IMÁN DE DATOS - UTILIDAD // RECURSOS", "ACTIVO",
    "EXTRACTOR DE MICROTRANSACCIONES OPTIMIZADO.\nCANALIZA FUGAS DE DATOS EN LA RED PARA\nMAXIMIZAR LA COSECHA DE FONDOS.",
    "pluginimg_01.png",
    "Sifón Digital", "Otorga +1 Token adicional por cada decisión correcta tomada.",
    "Jackpot Binario", "Duplica la obtención de todos los Tokens durante 15s ininterrumpidos.",
    -1, 60, 4, false, 68
  );

  agregarPluginCatalogo(
    "N.06", "VIRUS CAMUFLADO - PELIGRO // DOBLE FILO", "ACTIVO",
    "INYECCIÓN DE CÓDIGO HOSTIL DE ALTA INESTABILIDAD.\nPROTEGE LA RACHA DE TRABAJO PERO CORROE\nSILENCIOSAMENTE LA INTEGRIDAD DEL USUARIO.",
    "pluginimg_01.png",
    "Corrupción Latente", "Tolera 1 error sin romper tu Combo, a costa de perder -0.5 de Salud por segundo.",
    "Detonación Viral", "Convierte todos los paquetes en pantalla en Inocentes, pero drena -15 de Seguridad.",
    6, -1, 5, true, 24
  );

  agregarPluginCatalogo(
    "N.07", "ORÁCULO PREDICTIVO - INTELIGENCIA // ANÁLISIS", "ACTIVO",
    "PROCESADOR HEURÍSTICO DE APRENDIZAJE PROFUNDO.\nANALIZA FIRMAS CRIPTOGRÁFICAS PARA REVELAR LA\nVERDAD DETRÁS DE CADA NOTIFICACIÓN.",
    "pluginimg_01.png",
    "Previsión Estadística", "El indicador visual anticipa la naturaleza del mensaje con 70% de precisión.",
    "Escaneo Profundo", "Revela al 100% el tipo exacto y la intención real del mensaje actual.",
    4, -1, 6, false, 42
  );

  agregarPluginCatalogo(
    "N.08", "BUCLE TEMPORAL - MANIPULACIÓN // TIEMPO", "ACTIVO",
    "DISTORSIONADOR CRONOMÉTRICO DE MEMORIA VOLÁTIL.\nTRANSFORMA LA DESATENCIÓN EN RECOMPENSA Y\nPERMITE REVERTIR DECISIONES FATALES.",
    "pluginimg_01.png",
    "Eco Residual", "Cuando un mensaje expira por tiempo, otorga +2 de Salud en lugar de perder -5.",
    "Reversión Cuántica", "Deshace instantáneamente la última decisión errónea y restaura sus efectos.",
    10, -1, 7, false, 92
  );

  agregarPluginCatalogo(
    "N.09", "ANTENA PIRATA - INTERCEPTACIÓN // RED", "ACTIVO",
    "INTERCEPTOR DE ESPECTRO DE BANDA ANCHA NO AUTORIZADO.\nPRECARGA LOS BUFFERS DE ENTRADA Y BLOQUEA\nEL TRÁFICO HOSTIL CUANDO SE SATURA LA RED.",
    "pluginimg_01.png",
    "Escucha Pasiva", "Todos los paquetes entrantes comienzan con +20% de tiempo en su barra de vida.",
    "Jamming Total", "Bloquea el ingreso de nuevos paquetes a la red durante 10s para aliviar presión.",
    -1, 30, 8, false, 28
  );

  agregarPluginCatalogo(
    "N.10", "ESTABILIZADOR PSÍQUICO - RESTAURACIÓN // SALUD MENTAL", "ACTIVO",
    "DISPOSITIVO DE RETROALIMENTACIÓN BIO-DIGITAL.\nMONITOREA NIVELES DE CORTISOL COGNITIVO PARA\nEVITAR EL COLAPSO NERVIOSO DEL OPERADOR.",
    "pluginimg_01.png",
    "Homeostasis", "Regenera +0.3 de Salud Mental por segundo mientras tu nivel esté por debajo de 50.",
    "Dosis de Cordura", "Inyecta un impulso restaurador de +25 puntos directos a tu Salud Mental.",
    5, -1, 9, false, 30
  );

  agregarPluginCatalogo(
    "N.11", "COMBO BREAKER - COMBATE // MOMENTUM", "ACTIVO",
    "CATALIZADOR DE ENERGÍA CINÉTICA Y ENFOQUE CONTINUO.\nELEVA EXPONENCIALMENTE LA RECOMPENSA DE LA CADENCIA\nPERFECTA Y BLINDA EL RITMO EN CRISIS.",
    "pluginimg_01.png",
    "Momentum Crítico", "Incrementa un +10% las recompensas obtenidas por cada 5 aciertos de Combo acumulados.",
    "Racha Imparable", "Vuelve tu Combo completamente indestructible durante 20s frente a cualquier fallo.",
    -1, 90, 10, false, 72
  );

  agregarPluginCatalogo(
    "N.12", "TRAMPA DE HONEYPOT - ESTRATEGIA // CONTRAATAQUE", "ACTIVO",
    "ENTORNO SEÑUELO AISLADO PARA ATRAER ATACANTES.\nRECOMPENSA LA IDENTIFICACIÓN ACERTADA DE HOSTILES\nY TRANSFORMA ATAQUES EN REFUERZO DE SISTEMA.",
    "pluginimg_01.png",
    "Carnada Dulce", "Rechazar Malware o Trolls otorga +8 de recompensa en lugar de la bonificación base de +5.",
    "Trampa Desplegada", "El próximo mensaje malicioso aceptado no causa daño y otorga +10 a todas tus Estadísticas.",
    6, -1, 11, false, 56
  );

  agregarPluginCatalogo(
    "N.13", "ACELERADOR DE FEED - CAOS // RIESGO-RECOMPENSA", "ACTIVO",
    "CANALIZADOR DE FLUJO DE DATOS SIN FILTRO.\nDISPARA LA VELOCIDAD DE LA BANDEJA AL LÍMITE\nA CAMBIO DE INGRESOS MASIVOS Y PAQUETES LIMPIOS.",
    "pluginimg_01.png",
    "Velocidad Frenética", "Los mensajes llegan un 30% más rápido, pero otorgan +2 Tokens adicionales por acierto.",
    "Avalancha Segura", "Inyecta inmediatamente 3 paquetes Inocentes seguros en tu bandeja de entrada.",
    -1, 45, 12, true, 46
  );

  agregarPluginCatalogo(
    "N.14", "PROXY FANTASMA - SIGILO // EVASIÓN", "ACTIVO",
    "ENRUTADOR CEBO DE CAPA CERO MULTIPROTOCOLO.\nDESVÍA LOS ATAQUES DIRIGIDOS Y PERMITE\nDESAPARECER POR COMPLETO DEL RADAR DE AMENAZAS.",
    "pluginimg_01.png",
    "Red Oscura", "Reduce un 40% la frecuencia de aparición de Malware y ataques hostiles.",
    "Desvanecimiento", "Vuelve tu terminal inmune durante 12s, a costa de perder -5 de Popularidad.",
    5, -1, 13, false, 44
  );

  agregarPluginCatalogo(
    "N.15", "BATERÍA DE EMERGENCIA - SUPERVIVENCIA // ÚLTIMO RECURSO", "ACTIVO",
    "CELDA DE CONDENSACIÓN DE RESERVA CRÍTICA.\nDESFIBRILA CUALQUIER SISTEMA AL BORDE DEL COLAPSO\nCON UNA SOBRECARGA ENERGÉTICA SACRIFICIAL.",
    "pluginimg_01.png",
    "Protocolo de Rescate", "Si cualquier estadística llega a 0, la restaura de inmediato a 25 (1 uso por cada estadística).",
    "Descarga Total", "Restaura todas tus Estadísticas directamente a 50 puntos, pero el plugin se autodestruye.",
    18, -1, 14, false, 145
  );

  agregarPluginCatalogo(
    "N.16", "DISTORSIONADOR DE REALIDAD - CAOS // PSICODÉLICO", "ACTIVO",
    "CORRUPTOR ÓPTICO Y MANIPULADOR DE INTERFAZ.\nALTERA LA ESTÉTICA VISUAL CON GLITCHES CONTINUOS\nA CAMBIO DE GANANCIAS MONUMENTALES.",
    "pluginimg_01.png",
    "Visión Distorsionada", "Incrementa un +25% las recompensas totales, aunque introduce ruido y glitches visuales.",
    "Colapso Dimensional", "Purga y resetea por completo la bandeja de mensajes actual ante situaciones imposibles.",
    -1, 60, 15, true, 62
  );

  agregarPluginCatalogo(
    "N.17", "BOT ASISTENTE - AUTOMATIZACIÓN // IA", "ACTIVO",
    "AGENTE INTELIGENTE AUTÓNOMO DE TERCERA GENERACIÓN.\nMONITOREA SITUACIONES DE RIESGO EXTREMO Y TOMA\nEL CONTROL DE LAS OPERACIONES EN TU LUGAR.",
    "pluginimg_01.png",
    "Copiloto Digital", "Acepta automáticamente mensajes Inocentes cuando su tiempo restante cae por debajo del 15%.",
    "Modo Automático", "La IA toma control y juega durante 10s con una tasa de acierto garantizada del 80%.",
    10, -1, 16, false, 76
  );

  agregarPluginCatalogo(
    "N.18", "CRISTALIZADOR DE COMBO - COLECCIÓN // PROGRESIÓN", "ACTIVO",
    "MATRIZ PIEZOELÉCTRICA DE ALMACENAMIENTO DE MOMENTUM.\nCONVIERTE LA MEMORIA MUSCULAR EN RENDIMIENTO PASIVO\nY LIQUIDA TUS RACHAS EN FONDOS LÍQUIDOS.",
    "pluginimg_01.png",
    "Memoria Muscular", "Otorga +1% de recompensas permanentes por cada nuevo récord de Combo (hasta +15% máx).",
    "Cristalización", "Convierte la mitad de tu Combo actual directamente en Tokens, reiniciando la racha.",
    -1, -1, 17, false, 98
  );

  agregarPluginCatalogo(
    "N.19", "PARÁSITO SIMBIÓTICO - CORRUPCIÓN // SIMBIOSIS", "ACTIVO",
    "ENTIDAD BIOLÓGICA CIBERNÉTICA ALOJADA EN EL KERNEL.\nABSORBE EL IMPACTO DE ERRORES EXTERNOS A CAMBIO\nDE NUTRIRSE DE TUS RECURSOS MÁS VALIOSOS.",
    "pluginimg_01.png",
    "Mutualismo Tóxico", "Reduce un 50% el daño de cada error, pero drena -10 de una estadística aleatoria cada 3 fallos.",
    "Erupción Parasitaria", "Duplica instantáneamente el multiplicador de tu Combo actual, sacrificando -20 de Salud Mental.",
    -1, -1, 18, true, 26
  );

  agregarPluginCatalogo(
    "N.20", "JAMMER ANTI-TROLL - DEFENSA // SOCIAL", "ACTIVO",
    "SUPRESOR DE FRECUENCIAS HOSTILES Y ACOSO DIGITAL.\nDESENMASCARA A PROVOCADORES MALINTENCIONADOS Y\nPERMITE EXPULSARLOS MASIVAMENTE DEL SISTEMA.",
    "pluginimg_01.png",
    "Silencio Selectivo", "Identifica y tacha visualmente a todos los Trolls para neutralizar su impacto sorpresa.",
    "Ban Masivo", "Expulsa a todos los Trolls en cola, recuperando +3 de Salud por cada agresor purgado.",
    4, -1, 19, false, 28
  );

  agregarPluginCatalogo(
    "N.21", "ECLIPSE TOTAL - LEGENDARIO // DEFINITIVO", "ACTIVO",
    "SOBRESCRITURA TOTAL DEL PROTOCOLO DE LA RED NEXUS.\nDESENCADENA CONDICIONES DE COLAPSO TEMPORAL Y\nMULTIPLICA LA POTENCIA A NIVELES SUPREMOS.",
    "pluginimg_01.png",
    "Gravedad Oscura", "Los mensajes llegan un 50% más rápido, pero otorgan el triple de recompensas y +3 Tokens extra.",
    "Singularidad", "Congela el tiempo durante 5s, fija todas las Estadísticas en 75 y multiplica tu Combo x10.",
    28, 120, 20, true, 195
  );

  for (int i = 1; i < numCatalogoPlugins; i++) {
    int k = i;
    if (k < 21) {
      plugCatSheetCol[i] = k % 7;
      plugCatSheetRow[i] = k / 7;
      plugCatArchivoImagen[i] = "PluginCards_Sheet.png";
    }
  }
}

PImage cacheReversoGameplay = null;
PImage cacheReversoIntro = null;
PImage[] cacheImgGameOver = new PImage[5];
boolean recursosPluginsPrecargados = false;

PImage escalarPixelArtCrisp(PImage src, int targetW, int targetH) {
  if (src == null || src.width <= 0 || src.height <= 0 || targetW <= 0 || targetH <= 0) return null;
  PImage dest = createImage(targetW, targetH, ARGB);
  src.loadPixels();
  dest.loadPixels();
  int srcW = src.width;
  int srcH = src.height;
  for (int y = 0; y < targetH; y++) {
    int sy = (y * srcH) / targetH;
    int srcOffset = sy * srcW;
    int dstOffset = y * targetW;
    for (int x = 0; x < targetW; x++) {
      int sx = (x * srcW) / targetW;
      dest.pixels[dstOffset + x] = src.pixels[srcOffset + sx];
    }
  }
  dest.updatePixels();
  return dest;
}

void precargarRecursosPluginsYAudio() {
  if (recursosPluginsPrecargados) return;
  if (numCatalogoPlugins == 0) {
    inicializarCatalogoPlugins();
  }

  PImage revRaw = cargarImagenSegura("reversoplugins.png");
  if (revRaw != null && revRaw.width > 0) {
    cacheReversoGameplay = revRaw.get();
    cacheReversoGameplay.resize(int(anchoRectPlugin), int(altoRectPlugin));
    cacheReversoIntro = revRaw.get();
    cacheReversoIntro.resize(360, 504);
    imagenReversoPlugin = cacheReversoGameplay;
    imagenReverso = cacheReversoIntro;
  }

  PImage sheetPlugins = cargarImagenSegura("PluginCards_Sheet.png");
  if (sheetPlugins == null || sheetPlugins.width <= 0) {
    sheetPlugins = cargarImagenSegura("PluginCards_Sheet_v2.png");
  }
  final int CARD_PX_W = 71;
  final int CARD_PX_H = 95;

  int slotW = int(anchoRectPlugin * escalaSlot);
  int slotH = int(altoRectPlugin * escalaSlot);
  int zoomW = int(anchoRectPlugin * 2.3);
  int zoomH = int(altoRectPlugin * 2.3);
  int tiendaW = 160;
  int tiendaH = 214;
  int introW = 360;
  int introH = 482;

  for (int i = 0; i < numCatalogoPlugins; i++) {
    if (i == 0 || plugCatSheetCol[i] < 0 || plugCatSheetRow[i] < 0 || sheetPlugins == null) {
      PImage raw = cargarImagenSegura(plugCatArchivoImagen[i]);
      if (raw != null && raw.width > 0) {
        plugCatImgBase[i] = raw.get(); plugCatImgBase[i].resize(int(anchoRectPlugin), int(altoRectPlugin));
        plugCatImgSlot[i] = raw.get(); plugCatImgSlot[i].resize(slotW, slotH);
        plugCatImgZoom[i] = raw.get(); plugCatImgZoom[i].resize(zoomW, zoomH);
        plugCatImgTienda[i] = raw.get(); plugCatImgTienda[i].resize(tiendaW, 230);
        plugCatImgIntro[i] = raw.get(); plugCatImgIntro[i].resize(360, 504);
      }
    } else {
      int sx = plugCatSheetCol[i] * CARD_PX_W;
      int sy = plugCatSheetRow[i] * CARD_PX_H;

      if (sx + CARD_PX_W <= sheetPlugins.width && sy + CARD_PX_H <= sheetPlugins.height) {
        PImage raw = sheetPlugins.get(sx, sy, CARD_PX_W, CARD_PX_H);
        plugCatImgSpriteRaw[i] = raw;

        plugCatImgBase[i] = escalarPixelArtCrisp(raw, int(anchoRectPlugin), int(altoRectPlugin));
        plugCatImgSlot[i] = escalarPixelArtCrisp(raw, slotW, slotH);
        plugCatImgZoom[i] = escalarPixelArtCrisp(raw, zoomW, zoomH);
        plugCatImgTienda[i] = escalarPixelArtCrisp(raw, tiendaW, tiendaH);
        plugCatImgIntro[i] = escalarPixelArtCrisp(raw, introW, introH);
      } else {
        PImage raw = cargarImagenSegura("pluginimg_01.png");
        if (raw != null && raw.width > 0) {
          plugCatImgBase[i] = raw.get(); plugCatImgBase[i].resize(int(anchoRectPlugin), int(altoRectPlugin));
          plugCatImgSlot[i] = raw.get(); plugCatImgSlot[i].resize(slotW, slotH);
          plugCatImgZoom[i] = raw.get(); plugCatImgZoom[i].resize(zoomW, zoomH);
          plugCatImgTienda[i] = raw.get(); plugCatImgTienda[i].resize(tiendaW, 230);
          plugCatImgIntro[i] = raw.get(); plugCatImgIntro[i].resize(360, 504);
        }
      }
    }
  }

  PImage imgDerrotaStats = epCargarIlustracionFinal("final_malo_temprano");
  for (int i = 0; i < 5; i++) {
    cacheImgGameOver[i] = imgDerrotaStats;
  }

  precargarSpritesRayo();

  if (sndHoverPlugin == null) sndHoverPlugin = cargarSonido("hoverplugins.mp3");
  if (sndClickPlugin == null) sndClickPlugin = cargarSonido("clickplugins.mp3");
  if (sndVueloPlugin == null) sndVueloPlugin = cargarSonido("vueloplugin.mp3");
  if (sndAterrizajePlugin == null) sndAterrizajePlugin = cargarSonido("aterrizajevueloplugin.mp3");
  sndHover = sndHoverPlugin;
  sndClick = sndClickPlugin;
  sndVuelo = sndVueloPlugin;
  sndAterrizaje = sndAterrizajePlugin;
  if (sonidoShopBuy == null) sonidoShopBuy = cargarSonido("shopbuy.wav");

  verificarYPrecargarAssetsTienda();

  precargarSpritesVouchers();

  recursosPluginsPrecargados = true;
}
