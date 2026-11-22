
String[] vouchId = new String[8];
String[] vouchTag = new String[8];
String[] vouchNombre = new String[8];
String[] vouchSubtitulo = new String[8];
String[] vouchDescripcion = new String[8];
int[] vouchPrecio = new int[8];
int[] vouchFrameIndex = new int[8];
boolean[] vouchComprado = new boolean[8];
PImage[] vouchImgSprite = new PImage[8];
boolean catalogoVouchersInicializado = false;

PImage[] imgVouchers = new PImage[8];
PImage[] imgVouchersCrisp = new PImage[8];
PImage[] imgVouchersTienda = new PImage[8];
PImage[] imgVouchersMini = new PImage[8];
int cachedVoucherW = -1;
int cachedVoucherH = -1;
boolean vouchersPrecargados = false;
int voucherTiendaActual = -1;

boolean voucherKernelShieldActivo  = false;
boolean kernelShieldUsadoEnRonda   = false;

boolean voucherSpamFilterActivo    = false;
int spamAutoEliminadosEnRonda      = 0;

boolean voucherDeepFocusActivo     = false;

boolean voucherCertAuthActivo      = false;

boolean voucherLazarusActivo       = false;
boolean lazarusUsadoEnPartida      = false;

boolean voucherExpansionDIMMActivo = false;

boolean voucherStakingPoolActivo   = false;
boolean rerollGratisUsadoEnTienda  = false;

boolean voucherBusOverclockActivo  = false;

void registrarVoucherCatalogo(int idx, String id, String tag, String nombre, String subtitulo, String descripcion, int precio, int frameIndex) {
  vouchId[idx] = id;
  vouchTag[idx] = tag;
  vouchNombre[idx] = nombre;
  vouchSubtitulo[idx] = subtitulo;
  vouchDescripcion[idx] = descripcion;
  vouchPrecio[idx] = precio;
  vouchFrameIndex[idx] = frameIndex;
  vouchComprado[idx] = false;
  vouchImgSprite[idx] = null;
}

void inicializarCatalogoVouchers() {
  registrarVoucherCatalogo(0,
    "SYS", "SYS", "KERNEL SHIELD.BAT", "INMUNIDAD POR RONDA",
    "En cada ronda, el primer fallo crítico que cometas es absorbido y anulado por completo sin romper tu combo ni sufrir penalizaciones.",
    95, 0
  );

  registrarVoucherCatalogo(1,
    "T.01", "T.01", "SPAM FILTER.SYS", "SUPRESIÓN DE RUIDO",
    "Los paquetes Spam y Phishing viajan un 35% más lento hacia el umbral crítico, y los primeros 2 correos basura de cada ronda se auto-eliminan con éxito.",
    75, 1
  );

  registrarVoucherCatalogo(2,
    "T.02", "T.02", "DEEP FOCUS.ROM", "BLINDAJE COGNITIVO",
    "Tu Salud Mental nunca puede caer por debajo del 30% bajo ninguna circunstancia, y sostener un combo mayor a 10 regenera salud continuamente.",
    110, 2
  );

  registrarVoucherCatalogo(3,
    "T.03", "T.03", "CERT-AUTH ENGINE", "CRIPTO-ESCÁNER HEURÍSTICO",
    "Revela la firma oculta de los mensajes marcando las amenazas con balizas de advertencia. Acertar contra Malware otorga +2 Tokens extra.",
    85, 3
  );

  registrarVoucherCatalogo(4,
    "T.04", "T.04", "LAZARUS PROTOCOL", "RESURRECCIÓN DE HARDWARE",
    "Otorga +1 Vida permanente al sistema. Si recibes un fallo que causaría Game Over, el kernel revive una vez restaurando el 60% de tus estadísticas.",
    160, 4
  );

  registrarVoucherCatalogo(5,
    "RAM.01", "RAM", "BUFFER OVERDRIVE.ROM", "ESTABILIDAD TÉRMICA",
    "Estabiliza el ancho de banda del procesador, reduciendo en 30% las fluctuaciones de integridad por fallos en los sistemas.",
    120, 5
  );

  registrarVoucherCatalogo(6,
    "RAM.02", "RAM", "STAKING POOL.EXE", "DIVIDENDOS Y LIQUIDEZ",
    "Ganas +1 Token de interés por cada 10 Tokens ahorrados al final de cada ronda (hasta +15T máx), y el primer Reroll de cada tienda es 100% gratis.",
    105, 6
  );

  registrarVoucherCatalogo(7,
    "RAM.03", "RAM", "BUS OVERCLOCKING", "SINERGIA Y FRECUENCIA",
    "Aumenta la efectividad numérica de todos los efectos pasivos un +35%, y reduce a la mitad el tiempo de recarga (cooldown) de las habilidades activas.",
    140, 7
  );

  catalogoVouchersInicializado = true;
}

void precargarSpritesVouchers() {
  if (vouchersPrecargados) return;
  if (!catalogoVouchersInicializado) {
    inicializarCatalogoVouchers();
  }

  PImage sheet = cargarImagenSegura("vouchers_spritesheet.png");
  if (sheet == null || sheet.width <= 0) {
    println("[Vouchers] AVISO: vouchers_spritesheet.png no encontrada en data.");
    return;
  }

  final int V_W = 71;
  final int V_H = 95;

  for (int i = 0; i < 8; i++) {
    int sx = i * V_W;
    if (sx + V_W <= sheet.width && V_H <= sheet.height) {
      PImage raw = sheet.get(sx, 0, V_W, V_H);
      imgVouchers[i] = raw;

      PImage crisp = (raw != null) ? escalarPixelArtCrisp(raw, V_W * 4, V_H * 4) : null;
      imgVouchersCrisp[i] = crisp;
      imgVouchersMini[i] = (raw != null) ? escalarPixelArtCrisp(raw, 18, 24) : null;
      vouchImgSprite[i] = (crisp != null) ? crisp : raw;
    }
  }

  vouchersPrecargados = true;
  println("[Vouchers] Spritesheet de 8 modulos de RAM precargada exitosamente (Crisp Pixel-Art 4x).");
}

PImage obtenerSpriteVoucherMini(int frameIdx) {
  if (frameIdx < 0 || frameIdx >= 8) return null;
  if (!vouchersPrecargados) {
    precargarSpritesVouchers();
  }
  return imgVouchersMini[frameIdx];
}

PImage obtenerSpriteVoucherCrisp(int frameIdx, int targetW, int targetH) {
  if (frameIdx < 0 || frameIdx >= 8) return null;
  if (!vouchersPrecargados) {
    precargarSpritesVouchers();
  }
  if (targetW <= 0 || targetH <= 0) {
    return (imgVouchersCrisp[frameIdx] != null) ? imgVouchersCrisp[frameIdx] : imgVouchers[frameIdx];
  }

  if (cachedVoucherW != targetW || cachedVoucherH != targetH || imgVouchersTienda[frameIdx] == null) {
    for (int i = 0; i < 8; i++) {
      if (imgVouchers[i] != null) {
        imgVouchersTienda[i] = escalarPixelArtCrisp(imgVouchers[i], targetW, targetH);
      }
    }
    cachedVoucherW = targetW;
    cachedVoucherH = targetH;
  }
  return (imgVouchersTienda[frameIdx] != null) ? imgVouchersTienda[frameIdx] : imgVouchersCrisp[frameIdx];
}

void rotarVoucherTienda() {
  if (!catalogoVouchersInicializado) inicializarCatalogoVouchers();

  int[] disponibles = new int[8];
  int numDisponibles = 0;
  for (int i = 0; i < 8; i++) {
    if (!vouchComprado[i]) {
      disponibles[numDisponibles] = i;
      numDisponibles++;
    }
  }

  if (numDisponibles == 0) {
    voucherTiendaActual = -1;
  } else {
    if (voucherTiendaActual == -1 || vouchComprado[voucherTiendaActual]) {
      voucherTiendaActual = disponibles[int(random(numDisponibles))];
    }
  }
  rerollGratisUsadoEnTienda = false;
}

boolean comprarVoucher(int vIdx) {
  if (vIdx < 0 || vIdx >= 8 || !catalogoVouchersInicializado) return false;
  if (vouchComprado[vIdx] || tokensDolus < vouchPrecio[vIdx]) return false;

  tokensDolus -= vouchPrecio[vIdx];
  pulsoTokensUI = 1.0;
  vouchComprado[vIdx] = true;

  switch (vIdx) {
    case 0:
      voucherKernelShieldActivo = true;
      break;
    case 1:
      voucherSpamFilterActivo = true;
      break;
    case 2:
      voucherDeepFocusActivo = true;
      break;
    case 3:
      voucherCertAuthActivo = true;
      break;
    case 4:
      voucherLazarusActivo = true;
      vidasJugador = min(vidasJugador + 1, 4);
      break;
    case 5:
      voucherExpansionDIMMActivo = true;
      break;
    case 6:
      voucherStakingPoolActivo = true;
      break;
    case 7:
      voucherBusOverclockActivo = true;
      break;
  }

  return true;
}

int limiteMaxPluginsEquipados() {
  return 3;
}

int limiteMaxSlotsRack() {
  return 4;
}

void reiniciarVouchersPartida() {
  voucherKernelShieldActivo  = false;
  kernelShieldUsadoEnRonda   = false;
  voucherSpamFilterActivo    = false;
  spamAutoEliminadosEnRonda  = 0;
  voucherDeepFocusActivo     = false;
  voucherCertAuthActivo      = false;
  voucherLazarusActivo       = false;
  lazarusUsadoEnPartida      = false;
  voucherExpansionDIMMActivo = false;
  voucherStakingPoolActivo   = false;
  rerollGratisUsadoEnTienda  = false;
  voucherBusOverclockActivo  = false;

  voucherTiendaActual = -1;
  if (!catalogoVouchersInicializado) {
    inicializarCatalogoVouchers();
  } else {
    for (int i = 0; i < 8; i++) {
      vouchComprado[i] = false;
    }
  }
}
