
int faseTutorialActiva = 1;
int tutorialPaso = 0;
int tutorialCaracteres = 0;
float tutorialAcumulador = 0;
float tutorialVelocidadEscritura = 1.15;
float tutorialAparicion = 0;
float tutorialRebote = 1.0;
int ultimoSonidoVoz = 0;

String tutFeedbackError = "";
boolean tutEnFeedbackError = false;

float tutCardPosX = 0;
float tutCardPosY = 0;
float tutCardVelX = 0;
float tutCardVelY = 0;
boolean tutArrastrandoCarta = false;
float tutDragStartX = 0;
float tutDragStartY = 0;
boolean tutCardSaliendo = false;
int tutCardSalidaDir = 0;
int tutCardSalidaTimer = 0;

boolean tutorialLayoutIniciado = false;
float tutFocoX, tutFocoY, tutFocoW, tutFocoH;
float tutDlgX, tutDlgY, tutDlgH;

final float TUT_PADDING_FOCO = 10;
final float TUT_TEXTO_SIZE = 16.5;
final float TUT_INTERLINEADO = 22.5;

int dummyTutR1_WebPositiva = -1;
int dummyTutR1_WebNegativa = -1;

boolean mostrandoTutorialIngame = false;

int tipoTutorialIngame = 0;
boolean tutIngameEjecutableVisto = false;
boolean tutIngameTyposquatVisto = false;
boolean tutIngameSelloCorpVisto = false;
boolean tutIngameSobornoVisto = false;
boolean tutIngameEncriptadaVisto = false;
boolean tutIngameBombaVisto = false;
boolean tutIngameContaminadaVisto = false;

boolean tutEjecutableEnCola = false;
boolean tutTyposquatEnCola = false;
boolean tutSelloCorpEnCola = false;
boolean tutSobornoEnCola = false;
boolean tutEncriptadaEnCola = false;
boolean tutBombaEnCola = false;
boolean tutContaminadaEnCola = false;

int tutIngameCaracteres = 0;
float tutIngameAcumulador = 0;
float tutIngameAparicion = 0;
float tutIngameRebote = 1.0;
float rectBotonOKX = 0, rectBotonOKY = 0, rectBotonOKW = 210, rectBotonOKH = 50;

boolean guiaErrorActiva = false;
String guiaErrorTexto = "";
int guiaErrorTimer = 0;
int guiaErrorDuracion = 260;
int guiaErrorCaracteres = 0;
float guiaErrorAcumulador = 0;
float guiaErrorSlide = 0.0;
float guiaErrorRebote = 0.0;

void inicializarDummiesTutorial() {
  cursorPoolMensajeFijo = 0;

  dummyTutR1_WebPositiva = crearMensajeDolusFijo(
    "Gato_Naranja",
    "Foto de mi michi durmiendo encima del teclado jaja. Mucho animo a todos los que estan de turno hoy en la red :D",
    0
  );
  msgTiempoRestante[dummyTutR1_WebPositiva] = 1.0;
  msgDominio[dummyTutR1_WebPositiva] = "dolus@net";
  msgAsunto[dummyTutR1_WebPositiva] = "FEED // POST COMUNIDAD";
  msgIndiceSello[dummyTutR1_WebPositiva] = -1;
  msgTieneAdjunto[dummyTutR1_WebPositiva] = true;
  msgIndiceArchivo[dummyTutR1_WebPositiva] = 1;
  msgExtensionArchivo[dummyTutR1_WebPositiva] = ".png";
  msgEsCorporativo[dummyTutR1_WebPositiva] = false;
  msgEsValido[dummyTutR1_WebPositiva] = true;
  msgMotivoInvalidez[dummyTutR1_WebPositiva] = 0;
  msgCategoriaEspecial[dummyTutR1_WebPositiva] = 0;
  msgSemillaAvatar[dummyTutR1_WebPositiva] = 104;

  dummyTutR1_WebNegativa = crearMensajeDolusFijo(
    "Troll_Bot99",
    "Tu cuenta da verguenza borrala ya!! Entra a este portal pirata y regala tu clave para duplicar tokens.",
    1
  );
  msgTiempoRestante[dummyTutR1_WebNegativa] = 1.0;
  msgDominio[dummyTutR1_WebNegativa] = "dolus@net";
  msgAsunto[dummyTutR1_WebNegativa] = "FEED // ACOSO Y SPAM";
  msgIndiceSello[dummyTutR1_WebNegativa] = -1;
  msgTieneAdjunto[dummyTutR1_WebNegativa] = false;
  msgIndiceArchivo[dummyTutR1_WebNegativa] = 0;
  msgExtensionArchivo[dummyTutR1_WebNegativa] = ".png";
  msgEsCorporativo[dummyTutR1_WebNegativa] = false;
  msgEsValido[dummyTutR1_WebNegativa] = false;
  msgMotivoInvalidez[dummyTutR1_WebNegativa] = 1;
  msgCategoriaEspecial[dummyTutR1_WebNegativa] = 0;
  msgSemillaAvatar[dummyTutR1_WebNegativa] = 209;
}

int totalPasosFaseTutorial(int fase) {
  return 4;
}

boolean esPasoDrillTutorial() {
  return (tutorialPaso == 1 || tutorialPaso == 2);
}

int obtenerDecisionEsperadaTutorial() {
  if (tutorialPaso == 1) return 0;
  if (tutorialPaso == 2) return 1;
  return 0;
}

int obtenerDummyActualTutorial() {
  if (dummyTutR1_WebPositiva < 0 || dummyTutR1_WebNegativa < 0) {
    inicializarDummiesTutorial();
  }
  if (tutorialPaso == 1) return dummyTutR1_WebPositiva;
  if (tutorialPaso == 2) return dummyTutR1_WebNegativa;
  return dummyTutR1_WebPositiva;
}

int zonaFocoTutorial() {
  if (tutorialPaso == 0) return 5;
  if (tutorialPaso == 1 || tutorialPaso == 2) return 1;
  return 0;
}

String textoTutorialPaso(int fase, int paso) {
  switch (paso) {
    case 0:
      return "Bienvenido a la terminal, {G}" + nombreJugador + "{/}.\n" +
             "Tu primer encargo es moderar la red publica {C}dolus@net{/} (foros, memes y redes sociales).\n" +
             "Vigila las 4 barras de {Y}INTEGRIDAD{/}: si cualquiera cae a {R}0%{/} o llega al {R}100%{/}, la red colapsa y estas fuera.";
    case 1:
      return "Las tarjetas web de {C}dolus@net{/} {Y}NO necesitan sello de validacion{/} para ser legitimas.\n" +
             "Lee el mensaje: es un post {G}casual y sano{/} de la comunidad.\n" +
             "{G}Deslizala a la DERECHA [DER]{/} para dejarlo pasar.";
    case 2:
      return "Ahora mira esto: insultos, spam y estafas intentando colarse en {C}dolus@net{/}.\n" +
             "Dejar pasar {R}mensajes negativos{/} desplomara la Reputacion y tu Salud Mental.\n" +
             "{R}Deslizala a la IZQUIERDA [IZQ]{/} para bloquearla.";
    case 3:
      return "Bien hecho. Por ahora solo filtraras trafico web de {C}dolus@net{/}.\n" +
             "Aprueba el contenido {G}sano a la DERECHA{/} y rechaza lo {R}toxico o fraudulento a la IZQUIERDA{/}.\n" +
             "Si detecto anomalias nuevas en la red, detendre tu pantalla para avisarte. A trabajar, {G}" + nombreJugador + "{/}!";
  }
  return "";
}

String textoErrorTutorial(int fase, int paso) {
  if (paso == 1) {
    return "{Y}Bajale al gatillo facil, " + nombreJugador + ".{/}\n" +
           "En {C}dolus@net{/} los posts sanos no necesitan sello para ser validos.\n" +
           "{G}Deslizala a la DERECHA{/} para aprobar este mensaje.";
  } else {
    if (paso == 2) {
      return "{R}Mas cuidado, " + nombreJugador + "!{/}\n" +
             "Acabas de dejar pasar un mensaje toxico y fraudulento a la red.\n" +
             "El contenido negativo {R}SE RECHAZA A LA IZQUIERDA{/}. Intentalo otra vez.";
    }
  }
  return "{R}Moderacion incorrecta.{/} Sigue la instruccion del Admin.";
}

String obtenerTextoActualTutorial() {
  if (tutEnFeedbackError && tutFeedbackError.length() > 0) {
    return tutFeedbackError;
  }
  return textoTutorialPaso(faseTutorialActiva, tutorialPaso);
}

float[] rectZonaTutorial(int zona) {
  float breath = sin(frameCount * 0.04) * 4.0;
  float izqX = width * 0.02;
  float integY = height * 0.03 + breath;
  float integH = height * 0.20;
  float izqW = width * 0.26;
  float derX = izqX + izqW + width * 0.02;
  float derW = width * 0.68;
  float topY = height * 0.03 - breath * 0.5;
  float topH = height * 0.20;
  float gameY = topY + topH + height * 0.02;
  float gameH = height * 0.72;

  switch (zona) {
    case 1: return new float[] { derX, gameY, derW, gameH };
    case 5: return new float[] { izqX, integY, izqW, integH };
  }
  return null;
}

float[] posDialogoTutorial(int zona) {
  if (zona == 1) {
    return new float[] { width * 0.64, height * 0.15 };
  }
  if (zona == 5) {
    return new float[] { width * 0.62, height * 0.35 };
  }
  return new float[] { width * 0.5 + 80, height * 0.45 };
}

void sonarBlipVozAdmin(int charActual, int prevChars) {
  if (charActual != prevChars && (charActual % 3 == 0)) {
    if (sonidoVozDialogo != null && sonidoVozDialogo.frames() > 0) {
      float pitchAdmin = obtenerPitchConversante(0);
      reproducirSFXConTono(sonidoVozDialogo, pitchAdmin, 0.42);
    }
  }
}

void dibujarCapaTutorial() {
  if (jefeActivo > 0) {
    mostrandoTutorial = false;
    return;
  }

  pushStyle();
  pushMatrix();
  rectMode(CORNER);
  imageMode(CORNER);
  ellipseMode(CENTER);
  if (fuenteRetro != null) textFont(fuenteRetro);

  int totalPasos = totalPasosFaseTutorial(faseTutorialActiva);
  tutorialPaso = constrain(tutorialPaso, 0, totalPasos - 1);
  int zona = zonaFocoTutorial();
  String texto = obtenerTextoActualTutorial();
  int totalVis = contarCaracteresVisiblesTutorial(texto);

  if (tutorialAparicion == 0.0) {
    reproducirDialogoIn();
  }
  tutorialAparicion = min(1.0, tutorialAparicion + 0.06);
  tutorialRebote *= 0.85;

  if (tutorialCaracteres < totalVis) {
    int prevChars = tutorialCaracteres;
    tutorialAcumulador += tutorialVelocidadEscritura;
    tutorialCaracteres = min((int) tutorialAcumulador, totalVis);
    sonarBlipVozAdmin(tutorialCaracteres, prevChars);
  }

  float dlgW = min(620, width * 0.44);
  textSize(TUT_TEXTO_SIZE);
  String[] lineas = envolverTextoTutorial(texto, dlgW - 48);
  int totalLineas = contarTextos(lineas);
  float dlgHObjetivo = 52 + totalLineas * TUT_INTERLINEADO + 42;

  float[] zr = rectZonaTutorial(zona);
  float objFX, objFY, objFW, objFH;
  if (zr != null) {
    objFX = zr[0] - TUT_PADDING_FOCO;
    objFY = zr[1] - TUT_PADDING_FOCO;
    objFW = zr[2] + TUT_PADDING_FOCO * 2;
    objFH = zr[3] + TUT_PADDING_FOCO * 2;
  } else {
    objFX = width / 2.0; objFY = height / 2.0; objFW = 0; objFH = 0;
  }
  float[] dp = posDialogoTutorial(zona);

  if (!tutorialLayoutIniciado) {
    tutFocoX = objFX; tutFocoY = objFY; tutFocoW = objFW; tutFocoH = objFH;
    tutDlgX = dp[0]; tutDlgY = dp[1]; tutDlgH = dlgHObjetivo;
    tutorialLayoutIniciado = true;
  }
  tutFocoX = lerp(tutFocoX, objFX, 0.18);
  tutFocoY = lerp(tutFocoY, objFY, 0.18);
  tutFocoW = lerp(tutFocoW, objFW, 0.18);
  tutFocoH = lerp(tutFocoH, objFH, 0.18);
  tutDlgX = lerp(tutDlgX, dp[0], 0.15);
  tutDlgY = lerp(tutDlgY, dp[1], 0.15);
  tutDlgH = lerp(tutDlgH, dlgHObjetivo, 0.25);

  color colG = colorTema();
  float a = tutorialAparicion;

  float fx = max(0, tutFocoX);
  float fy = max(0, tutFocoY);
  float fw = max(0, min(tutFocoW, width - fx));
  float fh = max(0, min(tutFocoH, height - fy));
  noStroke();
  fill(0, 195 * a);
  rect(0, 0, width, fy);
  rect(0, fy + fh, width, max(0, height - (fy + fh)));
  rect(0, fy, fx, fh);
  rect(fx + fw, fy, max(0, width - (fx + fw)), fh);

  if (fw > 20 && fh > 20) {
    float pulso = 0.6 + 0.4 * sin(frameCount * 0.12);
    pushMatrix();
    translate(fx, fy);
    noFill();
    stroke(colG, 60 * a * pulso);
    strokeWeight(8);
    dibujarFormaAngularBase(fw, fh, 16);
    stroke(colG, 240 * a);
    strokeWeight(2.5);
    dibujarFormaAngularBase(fw, fh, 16);
    popMatrix();

    dibujarLineaTutorial(tutDlgX - dlgW / 2, tutDlgY - tutDlgH / 2, dlgW, tutDlgH, fx, fy, fw, fh, colG, a);
  }

  if (esPasoDrillTutorial()) {
    dibujarCartaInteractivaDrillTutorial(colG, a);
  }

  boolean hablando = tutorialCaracteres < totalVis;
  dibujarRetratoAdminTutorial(tutDlgX - dlgW / 2 - 20, tutDlgY, a, colG, hablando, tutorialRebote);
  dibujarDialogoTutorial(lineas, totalVis, tutDlgX, tutDlgY, dlgW, tutDlgH, a, colG, totalPasos);

  dibujarBotonSaltarTutorial(colG, a);

  popMatrix();
  popStyle();
}

void dibujarCartaInteractivaDrillTutorial(color colG, float a) {
  int m = obtenerDummyActualTutorial();
  if (m < 0) return;

  float cardBaseX = obtenerPanelGameX() + obtenerPanelGameW() * 0.5;
  float cardBaseY = obtenerPanelGameY() + obtenerPanelGameH() * 0.55;
  float cardW = 500;
  float cardH = 275;

  if (tutCardSaliendo) {
    tutCardPosX += (tutCardSalidaDir == 0 ? 36.0 : -36.0);
    tutCardPosY += 4.0;
    tutCardSalidaTimer--;
    if (tutCardSalidaTimer <= 0) {
      tutCardSaliendo = false;
      tutCardPosX = 0;
      tutCardPosY = 0;
      avanzarPasoExitoDrill();
      return;
    }
  } else {
    if (!tutArrastrandoCarta) {
      tutCardPosX = lerp(tutCardPosX, 0, 0.22);
      tutCardPosY = lerp(tutCardPosY, 0, 0.22);
    }
  }

  float cX = cardBaseX + tutCardPosX;
  float cY = cardBaseY + tutCardPosY;
  float rotacion = (tutCardPosX / 500.0) * 0.22;
  float floteIdle = tutArrastrandoCarta ? 0 : sin(frameCount * 0.04) * 3.5;

  boolean isHov = (!tutCardSaliendo && mouseX >= cX - cardW * 0.5 && mouseX <= cX + cardW * 0.5 &&
                   mouseY >= cY - cardH * 0.5 && mouseY <= cY + cardH * 0.5);
  if (isHov || tutArrastrandoCarta) cursorSobreElementoClicable = true;

  float cScale = tutArrastrandoCarta ? 1.04 : 1.0;
  float cAlpha = 255.0 * a;

  pushMatrix();
  pushStyle();

  rectMode(CENTER);
  noStroke();
  fill(0, 160 * a);
  rect(cX, cY + floteIdle + 8, cardW + 30, cardH + 30, 20);

  dibujarCartaMensaje25D(
    m,
    cX, cY + floteIdle,
    0, 0, rotacion,
    cScale, cScale, cAlpha,
    isHov, tutArrastrandoCarta, cardW, cardH, colG, color(255, 60, 40),
    rotacion * 0.5, 0
  );

  float yPrompt = cY + cardH * 0.5 + 30;
  textAlign(CENTER, CENTER);
  if (fuenteRetro != null) textFont(fuenteRetro);
  textSize(13);

  float pulso = 0.8 + 0.2 * sin(frameCount * 0.2);
  int dirEsperada = obtenerDecisionEsperadaTutorial();

  if (tutCardPosX > 50) {
    fill(80, 245, 160, 255 * pulso);
    text(">> [SOLTAR PARA APROBAR / DERECHA] >>", cX, yPrompt);
  } else {
    if (tutCardPosX < -50) {
      fill(255, 75, 75, 255 * pulso);
      text("<< [SOLTAR PARA RECHAZAR / IZQUIERDA] <<", cX, yPrompt);
    } else {
      if (dirEsperada == 0) {
        fill(160, 175, 170, 190);
        text("<< [IZQ: RECHAZAR]            ", cX - 70, yPrompt);
        fill(80, 245, 160, 255 * pulso);
        text("[DER: ACEPTAR] >>", cX + 115, yPrompt);
      } else {
        fill(255, 75, 75, 255 * pulso);
        text("<< [IZQ: RECHAZAR]", cX - 115, yPrompt);
        fill(160, 175, 170, 190);
        text("            [DER: ACEPTAR] >>", cX + 70, yPrompt);
      }
    }
  }

  popStyle();
  popMatrix();
}

void verificarDisparoTutorialIngame(int m) {
  if (m < 0 || jefeActivo != 0 || mostrandoTutorial || mostrandoTutorialIngame || animandoShowcaseDirectiva || rondaCompletada) {
    return;
  }

  if (msgCategoriaEspecial[m] == 1 && !tutIngameSobornoVisto) {
    tutIngameSobornoVisto = true;
    iniciarTutorialIngame(4);
    return;
  }
  if (msgCategoriaEspecial[m] == 2 && !tutIngameEncriptadaVisto) {
    tutIngameEncriptadaVisto = true;
    iniciarTutorialIngame(5);
    return;
  }
  if (msgCategoriaEspecial[m] == 3 && !tutIngameBombaVisto) {
    tutIngameBombaVisto = true;
    iniciarTutorialIngame(6);
    return;
  }
  if (msgCategoriaEspecial[m] == 4 && !tutIngameContaminadaVisto) {
    tutIngameContaminadaVisto = true;
    iniciarTutorialIngame(7);
    return;
  }
  if (msgCategoriaEspecial[m] != 0) return;

  if (!tutIngameEjecutableVisto) {
    if (msgTieneAdjunto[m] && (msgIndiceArchivo[m] == 3 || msgIndiceArchivo[m] == 4 || msgIndiceArchivo[m] == 5)) {
      tutIngameEjecutableVisto = true;
      iniciarTutorialIngame(1);
      return;
    }
  }

  if (!tutIngameTyposquatVisto) {
    if (msgDominio[m] != null && !msgDominio[m].equals("dolus@net") && !msgDominio[m].equals("dolus@corp")) {
      tutIngameTyposquatVisto = true;
      iniciarTutorialIngame(2);
      return;
    }
  }

  if (!tutIngameSelloCorpVisto) {
    if (msgEsCorporativo[m]) {
      tutIngameSelloCorpVisto = true;
      iniciarTutorialIngame(3);
      return;
    }
  }
}

void iniciarTutorialIngame(int tipo) {
  mostrandoTutorialIngame = true;
  tipoTutorialIngame = tipo;
  tutIngameCaracteres = 0;
  tutIngameAcumulador = 0;
  tutIngameAparicion = 0.0;
  tutIngameRebote = 1.15;

  arrastrando_mensaje = false;
  cardGrabbed = false;
  cardHover = false;
  swipePosX = 0;
  swipePosY = 0;
  swipeSpringVelX = 0;
  swipeSpringVelY = 0;
  reproducirDialogoIn();
  dispararSacudidaCamara(3.5);
}

String textoTutorialIngame(int tipo) {
  if (tipo == 1) {
    return "Eh {G}" + nombreJugador + "{/}, fíjate, este mensaje tiene un adjunto.\n" +
           "En Dolus están permitidos los memes y textos, pero no dejamos entrar cualquier potencial malware; " +
           "si un archivo es {R}.EXE, .BAT o .ZIP{/}, recházalo inmediatamente.";
  }
  if (tipo == 2) {
    return "Mm espera un momento, eso de ahí no tiene sentido.\n" +
           "Mira bien, no es ninguno de nuestros dominios oficiales, no dejes que te cuelen nada proveniente de ninguna red falsa.\n" +
           "Nuestros únicos dominios oficiales son: {G}dolus@corp{/} y {C}dolus@net{/}.";
  }
  if (tipo == 3) {
    return "Espera un segundo, {G}" + nombreJugador + "{/}, revisa el sello de este paquete interno.\n" +
           "A diferencia de {C}dolus@net{/}, toda tarjeta de sistema {G}dolus@corp{/} requiere obligatoriamente el sello oficial {G}DOLUS AUTH{/}.\n" +
           "Si un paquete {G}dolus@corp{/} viene {R}[ SIN SELLO ]{/} o {R}NO VERIFICADO{/}, recházalo inmediatamente.";
  }
  if (tipo == 4) {
    return "Vaya... pero qué tenemos aquí, una carta de {Y}SOBORNO{/}... Bueno, no quiero dar pie a malinterpretaciones, pero, si quieres un pequeño extra de {Y}tokens{/} haré como que no vi nada.\n" +
           "Estas cartas doradas ofrecen dinero a cambio de dejar pasar archivos dudosos, ten en cuenta que esto afectará negativamente tu {R}REPUTACIÓN{/} en la red.";
  }
  if (tipo == 5) {
    return "Alto ahí, {G}" + nombreJugador + "{/}, este paquete viene {C}ENCRIPTADO{/}.\n" +
           "No deslices a ciegas: {C}haz varios clics rápidos encima de la tarjeta{/} para romper el cifrado y ver su contenido real.\n" +
           "Una vez desencriptada, modérala como siempre y te llevarás un extra de {Y}tokens{/}.";
  }
  if (tipo == 6) {
    return "Mucho ojo aquí, {G}" + nombreJugador + "{/}, es una {R}CARTA BOMBA{/} de mecha rápida.\n" +
           "Fíjate en su barra inferior: el tiempo se consume a toda velocidad y si llega a cero detonará contra la red.\n" +
           "Revísala deprisa; si la filtras bien a tiempo ganarás un buen extra de {Y}tokens{/} y {G}COMBO{/}.";
  }
  if (tipo == 7) {
    return "Quieto ahí, {G}" + nombreJugador + "{/}, ni se te ocurra deslizar esa {R}CARTA CONTAMINADA{/}.\n" +
           "Viene cargada de corrupción glitch: si intentas soltarla a izquierda o derecha dañará el sistema.\n" +
           "Mantén presionado el clic sobre ella y {G}SACÚDELA BRUSCAMENTE{/} de lado a lado hasta purgar el {G}100%{/}.";
  }
  return "";
}

color obtenerColorFocoTutorialIngame(int tipo) {
  if (tipo == 1) return color(255, 80, 80);
  if (tipo == 2) return color(255, 205, 60);
  if (tipo == 3) return color(75, 255, 165);
  if (tipo == 4) return color(255, 215, 55);
  if (tipo == 5) return color(0, 235, 255);
  if (tipo == 6) return color(255, 115, 45);
  if (tipo == 7) return color(255, 65, 200);
  return colorTema();
}

void dibujarCapaTutorialIngame() {
  if (!mostrandoTutorialIngame || mensajeActivo < 0 || jefeActivo > 0) {
    mostrandoTutorialIngame = false;
    return;
  }

  pushStyle();
  pushMatrix();
  rectMode(CORNER);
  imageMode(CORNER);
  ellipseMode(CENTER);
  if (fuenteRetro != null) textFont(fuenteRetro);

  String texto = textoTutorialIngame(tipoTutorialIngame);
  int totalVis = contarCaracteresVisiblesTutorial(texto);

  tutIngameAparicion = min(1.0, tutIngameAparicion + 0.08);
  tutIngameRebote *= 0.85;

  if (tutIngameCaracteres < totalVis) {
    int prev = tutIngameCaracteres;
    tutIngameAcumulador += tutorialVelocidadEscritura;
    tutIngameCaracteres = min((int) tutIngameAcumulador, totalVis);
    sonarBlipVozAdmin(tutIngameCaracteres, prev);
  }

  float a = tutIngameAparicion;
  color colG = colorTema();
  color colFoco = obtenerColorFocoTutorialIngame(tipoTutorialIngame);

  float baseCardX = obtenerPanelGameX() + obtenerPanelGameW() * 0.5;
  float baseCardY = obtenerPanelGameY() + obtenerPanelGameH() * 0.45;
  float cardW = 500;
  float cardH = 275;

  float cX = ultimaCartaRenderValida ? ultimaCartaRenderX : baseCardX;
  float cY = ultimaCartaRenderValida ? ultimaCartaRenderY : (baseCardY + (!cardEntrando ? sin(cardFloteAngulo) * 4.5 : 0));
  float cRot = ultimaCartaRenderValida ? ultimaCartaRenderRot : 0;
  float cScX = ultimaCartaRenderValida ? ultimaCartaRenderScX : 1.0;
  float cScY = ultimaCartaRenderValida ? ultimaCartaRenderScY : 1.0;
  float cParX = ultimaCartaRenderValida ? ultimaCartaRenderParallaxX : 0;

  float cutPadTop = 20;
  float cutPadBot = 38;
  float cutW = cardW * cScX + 36;
  float cutH = cardH * cScY + cutPadTop + cutPadBot;
  float cutX = cX - cutW * 0.5;
  float cutY = cY - cardH * cScY * 0.5 - cutPadTop;

  noStroke();
  fill(0, 195 * a);
  rect(0, 0, width, max(0, cutY));
  rect(0, cutY + cutH, width, max(0, height - (cutY + cutH)));
  rect(0, cutY, max(0, cutX), cutH);
  rect(cutX + cutW, cutY, max(0, width - (cutX + cutW)), cutH);

  float localCX = -114;
  float localCY = 62;
  float localW = 220;
  float localH = 50;
  float localTagY = 101;
  String etiquetaResaltado = "TIPO DE ARCHIVO ADJUNTO";

  if (tipoTutorialIngame == 1) {

    localCX = -114;
    localCY = 62;
    localW = 220;
    localH = 50;
    localTagY = 101;
    etiquetaResaltado = "TIPO DE ARCHIVO ADJUNTO";
  } else {
    if (tipoTutorialIngame == 2) {

      String domTxt = msgDominio[mensajeActivo] != null ? msgDominio[mensajeActivo] : (msgEsCorporativo[mensajeActivo] ? "dolus@corp" : "dolus@net");
      String etqDom = (msgEsCorporativo[mensajeActivo] ? "DOMINIO: " : "RED: ") + domTxt;
      textSize(12);
      float wDom = textWidth(etqDom) + 20;
      localCX = -160 + wDom * 0.5;
      localCY = -54.5;
      localW = max(165, wDom + 10);
      localH = 30;
      localTagY = -95;
      etiquetaResaltado = "DOMINIO ERRADO DETECTADO";
    } else {
      if (tipoTutorialIngame == 3) {

        localCX = 114;
        localCY = 62;
        localW = 220;
        localH = 50;
        localTagY = 101;
        etiquetaResaltado = "RANURA DE SELLO DE VERIFICACION";
      } else {
        if (tipoTutorialIngame == 4) {

          localCX = 114;
          localCY = 62;
          localW = 220;
          localH = 50;
          localTagY = 101;
          etiquetaResaltado = "SOBORNO VIP: +TOKENS / -REPUTACION";
        } else {
          if (tipoTutorialIngame == 5) {

            localCX = 0;
            localCY = 14;
            localW = 456;
            localH = 72;
            localTagY = 134;
            etiquetaResaltado = "HAZ CLICS RAPIDOS PARA DESCIFRAR";
          } else {
            if (tipoTutorialIngame == 6) {

              localCX = 0;
              localCY = 112;
              localW = 438;
              localH = 24;
              localTagY = 136;
              etiquetaResaltado = "MECHA RAPIDA: DECIDE A TIEMPO";
            } else {
              if (tipoTutorialIngame == 7) {

                localCX = 0;
                localCY = 14;
                localW = 456;
                localH = 72;
                localTagY = 134;
                etiquetaResaltado = "MANTEN CLIC Y SACUDE PARA PURGAR";
              }
            }
          }
        }
      }
    }
  }

  float pulso = 0.55 + 0.45 * sin(frameCount * 0.18);

  pushMatrix();
  translate(cX, cY);
  rotate(cRot);
  scale(cScX, cScY);
  rectMode(CENTER);

  noFill();
  if (tipoTutorialIngame == 4) {
    stroke(colFoco, 185 * a * pulso);
    strokeWeight(4.0);
    rect(0, 0, cardW + 14, cardH + 14, 19);
  } else {
    stroke(colG, 115 * a);
    strokeWeight(1.8);
    rect(0, 0, cardW + 22, cardH + 22, 18);
  }

  translate(cParX, 0);

  noFill();
  stroke(colFoco, 95 * a * pulso);
  strokeWeight(9);
  rect(localCX, localCY, localW + 6, localH + 6, 11);
  stroke(colFoco, 255 * a);
  strokeWeight(3.0);
  rect(localCX, localCY, localW, localH, 9);

  if (tipoTutorialIngame == 1) {
    float xChipIcon = -114 - 212 * 0.5 + 26;
    float yChipIcon = 62;
    stroke(255, 235, 90, 245 * a * pulso);
    strokeWeight(2.6);
    rect(xChipIcon, yChipIcon, 40 + pulso * 5, 40 + pulso * 5, 8);
  }

  textSize(11.5);
  float tagW = textWidth(etiquetaResaltado) + 20;
  float localTagX = constrain(localCX, -cardW * 0.5 + tagW * 0.5 + 6, cardW * 0.5 - tagW * 0.5 - 6);
  noStroke();
  fill(10, 16, 20, 242 * a);
  rect(localTagX, localTagY, tagW, 20, 5);
  noFill();
  stroke(colFoco, 225 * a);
  strokeWeight(1.4);
  rect(localTagX, localTagY, tagW, 20, 5);
  fill(colFoco, 255 * a);
  textAlign(CENTER, CENTER);
  text(etiquetaResaltado, localTagX, localTagY - 1);

  popMatrix();
  rectMode(CORNER);

  float sx = (localCX + cParX) * cScX;
  float sy = localCY * cScY;
  float worldHlCX = cX + sx * cos(cRot) - sy * sin(cRot);
  float worldHlCY = cY + sx * sin(cRot) + sy * cos(cRot);
  float worldHlW = localW * cScX;
  float worldHlH = localH * cScY;
  float worldHlX = worldHlCX - worldHlW * 0.5;
  float worldHlY = worldHlCY - worldHlH * 0.5;

  float dlgW = min(660, width * 0.47);
  textSize(TUT_TEXTO_SIZE);
  String[] lineas = envolverTextoTutorial(texto, dlgW - 52);
  int totalLineas = contarTextos(lineas);
  float dlgH = 54 + totalLineas * TUT_INTERLINEADO + 76;

  float baseCutTop = baseCardY - cardH * 0.5 - 28;
  float baseCutLeft = baseCardX - cardW * 0.5 - 24;
  float dlgCX = baseCardX + 35;
  float dlgCY = baseCutTop - dlgH * 0.5 - 18;

  if (dlgCY - dlgH * 0.5 < 16) {
    dlgCX = max(dlgW * 0.5 + 195, baseCutLeft - dlgW * 0.5 - 24);
    dlgCY = height * 0.46;
  }
  dlgCX = constrain(dlgCX, dlgW * 0.5 + 205, width - dlgW * 0.5 - 24);

  dibujarLineaTutorial(dlgCX - dlgW * 0.5, dlgCY - dlgH * 0.5, dlgW, dlgH, worldHlX, worldHlY, worldHlW, worldHlH, colFoco, a);

  boolean hablando = tutIngameCaracteres < totalVis;
  dibujarRetratoAdminTutorial(dlgCX - dlgW * 0.5 - 18, dlgCY, a, colFoco, hablando, tutIngameRebote);

  dibujarDialogoTutorialIngame(lineas, totalVis, dlgCX, dlgCY, dlgW, dlgH, a, colG, colFoco);

  popMatrix();
  popStyle();
}

void dibujarDialogoTutorialIngame(String[] lineas, int largoVisible, float cx, float cy, float w, float h, float a, color colG, color colFoco) {
  boolean terminado = tutIngameCaracteres >= largoVisible;
  float mw = w * 0.5;
  float mh = h * 0.5;

  pushMatrix();
  translate(cx, cy);
  rectMode(CENTER);
  noStroke();

  pushMatrix();
  rotate(0.014);
  fill(red(colFoco) * 0.22, green(colFoco) * 0.22, blue(colFoco) * 0.22, 175 * a);
  rect(8, 10, w, h, 16);
  popMatrix();

  fill(5, 13, 10, 248 * a);
  rect(0, 0, w, h, 16);

  noFill();
  stroke(colFoco, 235 * a);
  strokeWeight(2.5);
  rect(0, 0, w, h, 16);

  noStroke();
  textSize(15.5);
  textAlign(LEFT, TOP);
  fill(colFoco, 255 * a);
  String tituloCab = "ADMIN // INTERVENCION EN DIRECTO";
  if (tipoTutorialIngame == 1) tituloCab = "ADMIN // ALERTA DE ADJUNTOS";
  else {
    if (tipoTutorialIngame == 2) tituloCab = "ADMIN // ALERTA DE DOMINIO FALSO";
    else {
      if (tipoTutorialIngame == 3) tituloCab = "ADMIN // PROTOCOLO DOLUS@CORP";
      else {
        if (tipoTutorialIngame == 4) tituloCab = "ADMIN // CARTA DE SOBORNO";
        else {
          if (tipoTutorialIngame == 5) tituloCab = "ADMIN // PAQUETE ENCRIPTADO";
          else {
            if (tipoTutorialIngame == 6) tituloCab = "ADMIN // ALERTA DE CARTA BOMBA";
            else {
              if (tipoTutorialIngame == 7) tituloCab = "ADMIN // CARTA CONTAMINADA";
            }
          }
        }
      }
    }
  }
  text(tituloCab, -mw + 24, -mh + 16);

  textAlign(RIGHT, TOP);
  fill(200, 225, 215, 170 * a);
  text("[PAUSA DE INSPECCION]", mw - 24, -mh + 16);

  textSize(TUT_TEXTO_SIZE);
  textAlign(LEFT, TOP);
  int restantes = tutIngameCaracteres;
  float y = -mh + 48;
  int totalLineas = contarTextos(lineas);
  colTagPersistenteTutorial = color(225, 235, 230);
  for (int i = 0; i < totalLineas && restantes > 0; i++) {
    restantes = dibujarLineaFormateadaTutorial(lineas[i], -mw + 24, y, restantes, a, colG);
    y += TUT_INTERLINEADO;
  }

  rectBotonOKW = 220;
  rectBotonOKH = 48;
  rectBotonOKX = cx;
  rectBotonOKY = cy + mh - 36;

  boolean hovOK = hoverBotonOKTutorialIngame();
  if (hovOK) cursorSobreElementoClicable = true;

  pushMatrix();
  translate(0, mh - 36);
  if (terminado) {
    float pulsoBtn = 0.82 + 0.18 * sin(frameCount * 0.18);
    float escBtn = hovOK ? (mousePressed ? 0.96 : 1.06) : 1.0;
    scale(escBtn);

    noStroke();
    fill(0, 170 * a);
    rect(3, 4, rectBotonOKW, rectBotonOKH, 10);

    fill(hovOK ? colFoco : color(14, 42, 30), 245 * a);
    stroke(hovOK ? color(255) : colFoco, 255 * a * pulsoBtn);
    strokeWeight(hovOK ? 3.0 : 2.4);
    rect(0, 0, rectBotonOKW, rectBotonOKH, 10);

    fill(hovOK ? color(8, 14, 12) : color(255), 255 * a);
    textAlign(CENTER, CENTER);
    textSize(23);
    text("OK", 0, -2);
  } else {

    fill(14, 22, 20, 200 * a);
    stroke(120, 150, 140, 120 * a);
    strokeWeight(1.5);
    rect(0, 0, rectBotonOKW, rectBotonOKH, 10);
    fill(170, 195, 185, 185 * a);
    textAlign(CENTER, CENTER);
    textSize(14);
    text("ESCRIBIENDO...", 0, -1);
  }
  popMatrix();

  popMatrix();
  rectMode(CORNER);
}

boolean hoverBotonOKTutorialIngame() {
  if (!mostrandoTutorialIngame) return false;
  return (mouseX >= rectBotonOKX - rectBotonOKW * 0.5 && mouseX <= rectBotonOKX + rectBotonOKW * 0.5 &&
          mouseY >= rectBotonOKY - rectBotonOKH * 0.5 && mouseY <= rectBotonOKY + rectBotonOKH * 0.5);
}

void dispararGuiaErrorAdmin(int decision, int msg) {
  if (msg < 0) return;

  if (jefeActivo != 0) return;

  String linea = "";
  if (decision == 2) {

    linea = "No te duermas en el puesto, {Y}" + nombreJugador + "{/}. Dejaste expirar un paquete sin revisarlo.";
  } else {
    if (decision == 1 && msgEsValido[msg]) {

      linea = "Bájale al gatillo fácil, {G}" + nombreJugador + "{/}. Ese mensaje cumplía todo y era legítimo.";
    } else {
      if (decision == 0 && !msgEsValido[msg]) {
        int motivo = msgMotivoInvalidez[msg];

        if (motivo == 0) {
          if (msgDominio[msg] != null && !msgDominio[msg].equals("dolus@net") && !msgDominio[msg].equals("dolus@corp")) {
            motivo = 3;
          } else {
            if (msgTieneAdjunto[msg] && (msgIndiceArchivo[msg] == 3 || msgIndiceArchivo[msg] == 4 || msgIndiceArchivo[msg] == 5)) {
              motivo = 4;
            } else {
              if (msgEsCorporativo[msg] && msgIndiceSello[msg] != 0) {
                motivo = 2;
              } else {
                if (msgIndiceSello[msg] == 1) {
                  motivo = 5;
                } else {
                  motivo = 1;
                }
              }
            }
          }
        }

        if (motivo == 2) {

          linea = "Pero se puede saber qué {R}#$!/?{/} haces? Ese mensaje no llevaba sello.";
        } else {
          if (motivo == 3) {

            linea = "Lee bien la dirección, {Y}" + nombreJugador + "{/}. Ese dominio ni siquiera es nuestro.";
          } else {
            if (motivo == 4) {

              linea = "Acabas de colar un ejecutable dañino en la red, {R}" + nombreJugador + "{/}. Más ojo con los adjuntos.";
            } else {
              if (motivo == 5) {

                linea = "Tenía una alerta de {R}MALWARE{/} en toda la cara, {Y}" + nombreJugador + "{/}. No apruebes eso.";
              } else {

                linea = "Más cuidado, {Y}" + nombreJugador + "{/}, has dejado pasar un mensaje negativo.";
              }
            }
          }
        }
      }
    }
  }

  if (linea.length() > 0) {
    dispararGuiaErrorTexto(linea);
  }
}

void dispararGuiaErrorTexto(String linea) {
  if (jefeActivo != 0) return;
  guiaErrorActiva = true;
  guiaErrorTexto = linea;
  guiaErrorTimer = guiaErrorDuracion;
  guiaErrorCaracteres = 0;
  guiaErrorAcumulador = 0;
  guiaErrorRebote = 1.0;
  if (guiaErrorSlide < 0.15) {
    guiaErrorSlide = 0.0;
  }
}

void actualizarYDibujarGuiaErrorAdmin() {
  if (!guiaErrorActiva || jefeActivo != 0 || mostrandoTutorial || mostrandoTutorialIngame || rondaCompletada) {
    if (jefeActivo != 0 || rondaCompletada) guiaErrorActiva = false;
    return;
  }

  guiaErrorTimer--;
  if (guiaErrorTimer <= 0) {
    guiaErrorActiva = false;
    return;
  }

  if (guiaErrorTimer > 28) {
    guiaErrorSlide = lerp(guiaErrorSlide, 1.0, 0.24);
  } else {
    guiaErrorSlide = constrain(guiaErrorTimer / 28.0, 0.0, 1.0);
  }
  guiaErrorRebote *= 0.84;

  int totalVis = contarCaracteresVisiblesTutorial(guiaErrorTexto);
  if (guiaErrorCaracteres < totalVis) {
    int prev = guiaErrorCaracteres;
    guiaErrorAcumulador += 1.65;
    guiaErrorCaracteres = min((int) guiaErrorAcumulador, totalVis);
    sonarBlipVozAdmin(guiaErrorCaracteres, prev);
  }

  pushStyle();
  pushMatrix();
  if (fuenteRetro != null) textFont(fuenteRetro);

  float boxW = min(465, width * 0.34);
  float portraitBoxW = 74;
  float textoMaxW = boxW - portraitBoxW - 34;

  textSize(14.5);
  String[] lineas = envolverTextoTutorial(guiaErrorTexto, textoMaxW);
  int numLineas = contarTextos(lineas);
  float boxH = max(96, 38 + numLineas * 19.5 + 14);

  float xBox = width - boxW - 24;
  float yBoxFinal = height * 0.032;
  float yBox = lerp(-boxH - 20, yBoxFinal, guiaErrorSlide);

  boolean mouseEncima = (mouseX >= xBox - 10 && mouseX <= xBox + boxW + 10 &&
                         mouseY >= yBox - 6 && mouseY <= yBox + boxH + 10);
  float alphaBase = guiaErrorSlide * (mouseEncima ? 0.38 : 0.97);

  color colAlerta = color(255, 80, 75);
  color colG = colorTema();

  translate(xBox + guiaErrorRebote * random(-2.5, 2.5), yBox);
  rectMode(CORNER);

  noStroke();
  fill(0, 175 * alphaBase);
  rect(6, 7, boxW, boxH, 12);

  fill(8, 14, 13, 244 * alphaBase);
  stroke(colAlerta, 225 * alphaBase);
  strokeWeight(2.2);
  rect(0, 0, boxW, boxH, 12);

  noStroke();
  fill(colAlerta, 235 * alphaBase);
  rect(0, 10, 4, boxH - 20, 2);

  float pX = 12;
  float pY = (boxH - 76) * 0.5;
  fill(12, 24, 18, 240 * alphaBase);
  stroke(colG, 170 * alphaBase);
  strokeWeight(1.5);
  rect(pX, pY, 62, 76, 8);

  if (imgAdminIcon != null) {
    boolean hablando = guiaErrorCaracteres < totalVis;
    float hablaOff = hablando ? sin(frameCount * 0.45) * 1.8 : 0;
    imageMode(CENTER);
    tint(255, 255 * alphaBase);
    image(imgShaderDaltonismo(imgAdminIcon), pX + 31, pY + 38 + hablaOff, 54, 68);
    noTint();
    imageMode(CORNER);
  }

  float tx = pX + 74;
  textAlign(LEFT, TOP);
  textSize(11.5);
  fill(colAlerta, 255 * alphaBase);
  text("ADMIN // CANAL DE SUPERVISION", tx, 11);

  if ((frameCount / 16) % 2 == 0) {
    noStroke();
    fill(255, 70, 70, 240 * alphaBase);
    ellipse(boxW - 16, 17, 7, 7);
  }

  textSize(14.5);
  textAlign(LEFT, TOP);
  int rest = guiaErrorCaracteres;
  float ly = 32;
  colTagPersistenteTutorial = color(225, 235, 230);
  for (int i = 0; i < numLineas && rest > 0; i++) {
    rest = dibujarLineaFormateadaTutorial(lineas[i], tx, ly, rest, alphaBase, colG);
    ly += 19.5;
  }

  popMatrix();
  popStyle();
}

int contarCaracteresVisiblesTutorial(String texto) {
  if (texto == null) return 0;
  int c = 0;
  int i = 0;
  while (i < texto.length()) {
    if (i + 2 < texto.length() && texto.substring(i, i + 1).equals("{") && texto.substring(i + 2, i + 3).equals("}")) {
      i += 3;
    } else {
      c++;
      i++;
    }
  }
  return c;
}

String despojarTagsTutorial(String texto) {
  if (texto == null) return "";
  String sb = "";
  int i = 0;
  while (i < texto.length()) {
    if (i + 2 < texto.length() && texto.substring(i, i + 1).equals("{") && texto.substring(i + 2, i + 3).equals("}")) {
      i += 3;
    } else {
      sb = sb + texto.substring(i, i + 1);
      i++;
    }
  }
  return sb;
}

float anchoTextoVisibleTutorial(String texto) {
  return textWidth(despojarTagsTutorial(texto));
}

String[] envolverTextoTutorial(String texto, float anchoMax) {
  String[] bloques = dividirTexto(texto, "\n");
  int numBloques = contarTextos(bloques);
  String[] res = new String[64];
  int numLineas = 0;
  for (int b = 0; b < numBloques; b++) {
    String[] palabras = dividirTexto(bloques[b], " ");
    int numPalabras = contarTextos(palabras);
    String actual = "";
    for (int i = 0; i < numPalabras; i++) {
      String p = palabras[i];
      String candidata = (actual.length() == 0) ? p : actual + " " + p;
      if (anchoTextoVisibleTutorial(candidata) > anchoMax && actual.length() > 0) {
        if (numLineas < 64) {
          res[numLineas] = actual;
          numLineas++;
        }
        actual = p;
      } else {
        actual = candidata;
      }
    }
    if (actual.length() > 0 && numLineas < 64) {
      res[numLineas] = actual;
      numLineas++;
    }
  }
  return res;
}

color colTagPersistenteTutorial = color(225, 235, 230);

int dibujarLineaFormateadaTutorial(String linea, float x, float y, int restantes, float alpha, color colG) {
  float curX = x;
  int i = 0;
  while (i < linea.length() && restantes > 0) {
    if (i + 2 < linea.length() && linea.substring(i, i + 1).equals("{") && linea.substring(i + 2, i + 3).equals("}")) {
      String tag = linea.substring(i + 1, i + 2);
      if (tag.equals("G")) colTagPersistenteTutorial = color(75, 255, 160);
      else {
        if (tag.equals("R")) colTagPersistenteTutorial = color(255, 75, 75);
        else {
          if (tag.equals("Y")) colTagPersistenteTutorial = color(255, 215, 60);
          else {
            if (tag.equals("C")) colTagPersistenteTutorial = color(60, 225, 255);
            else {
              if (tag.equals("/") || tag.equals("W")) colTagPersistenteTutorial = color(225, 235, 230);
            }
          }
        }
      }
      i += 3;
      continue;
    }

    String chStr = linea.substring(i, i + 1);
    fill(red(colTagPersistenteTutorial), green(colTagPersistenteTutorial), blue(colTagPersistenteTutorial), 255 * alpha);
    text(chStr, curX, y);
    curX += textWidth(chStr);
    restantes--;
    i++;
  }

  while (i + 2 < linea.length() && linea.substring(i, i + 1).equals("{") && linea.substring(i + 2, i + 3).equals("}")) {
    String tag = linea.substring(i + 1, i + 2);
    if (tag.equals("G")) colTagPersistenteTutorial = color(75, 255, 160);
    else {
      if (tag.equals("R")) colTagPersistenteTutorial = color(255, 75, 75);
      else {
        if (tag.equals("Y")) colTagPersistenteTutorial = color(255, 215, 60);
        else {
          if (tag.equals("C")) colTagPersistenteTutorial = color(60, 225, 255);
          else {
            if (tag.equals("/") || tag.equals("W")) colTagPersistenteTutorial = color(225, 235, 230);
          }
        }
      }
    }
    i += 3;
  }
  return restantes;
}

void dibujarDialogoTutorial(String[] lineas, int largoVisible, float cx, float cy, float w, float h, float a, color colG, int total) {
  boolean terminado = tutorialCaracteres >= largoVisible;
  float mw = w / 2;
  float mh = h / 2;
  if (mouseX >= cx - mw && mouseX <= cx + mw && mouseY >= cy - mh && mouseY <= cy + mh) {
    cursorSobreElementoClicable = true;
  }

  pushMatrix();
  translate(cx, cy);
  rectMode(CENTER);
  noStroke();

  pushMatrix();
  rotate(0.018);
  fill(red(colG) * 0.25, green(colG) * 0.25, blue(colG) * 0.25, 170 * a);
  rect(8, 10, w, h, 16);
  popMatrix();

  fill(4, 12, 9, 245 * a);
  rect(0, 0, w, h, 16);

  noFill();
  stroke(tutEnFeedbackError ? color(255, 75, 75) : colG, 220 * a);
  strokeWeight(2.2);
  rect(0, 0, w, h, 16);

  noStroke();
  textSize(16);
  textAlign(LEFT, TOP);
  fill(tutEnFeedbackError ? color(255, 80, 80) : colG, 255 * a);
  text(tutEnFeedbackError ? "ADMIN // CORRECCION" : "ADMIN // INDUCCION WEB", -mw + 24, -mh + 18);

  textAlign(RIGHT, TOP);
  fill(colG, 160 * a);
  text("[R1] " + (tutorialPaso + 1) + "/" + total, mw - 24, -mh + 18);

  textSize(TUT_TEXTO_SIZE);
  textAlign(LEFT, TOP);
  int restantes = tutorialCaracteres;
  float y = -mh + 50;
  int totalLineas = contarTextos(lineas);
  colTagPersistenteTutorial = color(225, 235, 230);
  for (int i = 0; i < totalLineas && restantes > 0; i++) {
    restantes = dibujarLineaFormateadaTutorial(lineas[i], -mw + 24, y, restantes, a, colG);
    y += TUT_INTERLINEADO;
  }

  textSize(13);
  if (terminado) {
    float pulsoPie = 0.5 + 0.5 * sin(frameCount * 0.18);
    textAlign(RIGHT, BOTTOM);
    if (tutEnFeedbackError) {
      fill(255, 85, 85, 255 * pulsoPie);
      text("DESLIZA LA TARJETA EN LA DIRECCIÓN CORRECTA PARA CONTINUAR!", mw - 24, mh - 12);
    } else {
      if (esPasoDrillTutorial()) {
        fill(colG, 240 * pulsoPie);
        text(">> DESLIZA LA TARJETA CON EL RATON O TECLAS [A / D] <<", mw - 24, mh - 12);
      } else {
        fill(colG, 240 * pulsoPie);
        String pie = (tutorialPaso >= total - 1) ? "CLICK O ESPACIO PARA EMPEZAR TURNO >>" : "CLICK O ESPACIO PARA CONTINUAR >>";
        text(pie, mw - 24, mh - 12);
      }
    }
  } else {
    if ((millis() / 450) % 2 == 0) {
      fill(colG, 255 * a);
      rectMode(CORNER);
      rect(-mw + 24, mh - 26, 10, 16);
    }
  }

  popMatrix();
  rectMode(CORNER);
}

void dibujarRetratoAdminTutorial(float bordeDerecho, float cy, float a, color colG, boolean hablando, float golpe) {
  float w = 150;
  float h = 190;
  float marcoW = w + 24;
  float marcoH = h + 24;
  float cx = bordeDerecho - marcoW / 2;

  float flote = sin(frameCount * 0.03) * 6;
  float habla = hablando ? abs(sin(frameCount * 0.35)) * 0.025 : 0;

  pushMatrix();
  translate(cx, cy + flote);
  rotate(sin(frameCount * 0.04) * 0.02 - golpe * 0.06);
  scale(1 + habla + golpe * 0.12, 1 + habla - golpe * 0.06);

  rectMode(CENTER);
  noStroke();
  fill(red(colG) * 0.25, green(colG) * 0.25, blue(colG) * 0.25, 140 * a);
  rect(8, 12, marcoW, marcoH, 16);
  fill(6, 16, 12, 240 * a);
  rect(0, 0, marcoW, marcoH, 16);

  if (imgAdminIcon != null) {
    imageMode(CENTER);
    tint(255, 255 * a);
    image(imgShaderDaltonismo(imgAdminIcon), 0, 0, w, h);
    noTint();
    imageMode(CORNER);
  }
  dibujarMarcoProcedural(marcoW, marcoH, 8, a);
  popMatrix();
  rectMode(CORNER);
}

void dibujarLineaTutorial(float dx, float dy, float dw, float dh, float zx, float zy, float zw, float zh, color c, float a) {
  float dcx = dx + dw / 2;
  float dcy = dy + dh / 2;
  float tx = constrain(dcx, zx, zx + zw);
  float ty = constrain(dcy, zy, zy + zh);
  if (tx == dcx && ty == dcy) return;
  float sx = constrain(tx, dx, dx + dw);
  float sy = constrain(ty, dy, dy + dh);
  if (dist(sx, sy, tx, ty) < 8) return;

  stroke(c, 210 * a);
  strokeWeight(2.6);
  line(sx, sy, tx, ty);
  noStroke();
  fill(c, 255 * a);
  ellipse(tx, ty, 9, 9);
}

float[] rectSaltarTutorial() {
  float w = 240;
  float h = 40;
  return new float[] { width - w - 30, height - h - 30, w, h };
}

boolean hoverSaltarTutorial() {
  float[] r = rectSaltarTutorial();
  return mouseX >= r[0] && mouseX <= r[0] + r[2] && mouseY >= r[1] && mouseY <= r[1] + r[3];
}

void dibujarBotonSaltarTutorial(color colG, float a) {
  float[] r = rectSaltarTutorial();
  boolean hov = hoverSaltarTutorial();
  if (hov) cursorSobreElementoClicable = true;
  pushMatrix();
  translate(r[0], r[1]);
  stroke(colG, 200 * a);
  strokeWeight(2);
  fill(hov ? colG : color(6, 16, 12), 230 * a);
  dibujarFormaAngularBase(r[2], r[3], 10);
  noStroke();
  fill(hov ? color(0) : color(220, 235, 225), 255 * a);
  textAlign(CENTER, CENTER);
  textSize(14);
  text("SALTAR TUTORIAL [TAB]", r[2] / 2, r[3] / 2 - 2);
  popMatrix();
}

void avanzarTutorial() {
  String texto = obtenerTextoActualTutorial();
  int totalVis = contarCaracteresVisiblesTutorial(texto);
  if (tutorialCaracteres < totalVis) {
    tutorialCaracteres = totalVis;
    tutorialAcumulador = totalVis;
    return;
  }

  if (esPasoDrillTutorial()) {
    return;
  }

  int totalPasos = totalPasosFaseTutorial(faseTutorialActiva);
  if (tutorialPaso >= totalPasos - 1) {
    terminarTutorial();
    return;
  }

  reproducirTap();
  tutorialPaso++;
  tutEnFeedbackError = false;
  tutFeedbackError = "";
  tutorialCaracteres = 0;
  tutorialAcumulador = 0;
  tutorialRebote = 1.0;
  tutCardPosX = 0;
  tutCardPosY = 0;
  tutArrastrandoCarta = false;
  tutCardSaliendo = false;
}

void avanzarPasoExitoDrill() {
  int totalPasos = totalPasosFaseTutorial(faseTutorialActiva);
  reproducirTap();
  if (tutorialPaso >= totalPasos - 1) {
    terminarTutorial();
    return;
  }
  tutorialPaso++;
  tutEnFeedbackError = false;
  tutFeedbackError = "";
  tutorialCaracteres = 0;
  tutorialAcumulador = 0;
  tutorialRebote = 1.0;
  tutCardPosX = 0;
  tutCardPosY = 0;
  tutArrastrandoCarta = false;
  tutCardSaliendo = false;
}

void evaluarSwipeDrill(int decisionTomada) {
  int esperada = obtenerDecisionEsperadaTutorial();
  if (decisionTomada == esperada) {
    tutCardSaliendo = true;
    tutCardSalidaDir = decisionTomada;
    tutCardSalidaTimer = 14;
    reproducirTap();
    if (sonidoNotificacionOscura != null) reproducirSFX(sonidoNotificacionOscura, 0.45);
  } else {
    if (sonidoGlitchFuerte != null) reproducirSFX(sonidoGlitchFuerte, 0.45);
    dispararSacudidaCamara(6.0);
    tutCardPosX = 0;
    tutCardPosY = 0;
    tutArrastrandoCarta = false;
    tutEnFeedbackError = true;
    tutFeedbackError = textoErrorTutorial(faseTutorialActiva, tutorialPaso);
    tutorialCaracteres = 0;
    tutorialAcumulador = 0;
    tutorialRebote = 1.2;
  }
}

void terminarTutorial() {
  mostrandoTutorial = false;
  tutArrastrandoCarta = false;
  tutCardSaliendo = false;
  animandoShowcaseDirectiva = false;
  reproducirTap();

  if (jefeActivo == 0 && !modoExposicionActivo) {
    dispararShowcaseDirectiva();
  }
}

void resetearTutorial() {
  faseTutorialActiva = 1;
  mostrandoTutorial = true;
  tutorialPaso = 0;
  tutorialCaracteres = 0;
  tutorialAcumulador = 0;
  tutorialAparicion = 0;
  tutorialRebote = 1.0;
  tutorialLayoutIniciado = false;
  tutEnFeedbackError = false;
  tutFeedbackError = "";
  tutCardPosX = 0;
  tutCardPosY = 0;
  tutArrastrandoCarta = false;
  tutCardSaliendo = false;

  mostrandoTutorialIngame = false;
  tipoTutorialIngame = 0;
  tutIngameEjecutableVisto = false;
  tutIngameTyposquatVisto = false;
  tutIngameSelloCorpVisto = false;
  tutIngameSobornoVisto = false;
  tutIngameEncriptadaVisto = false;
  tutIngameBombaVisto = false;
  tutIngameContaminadaVisto = false;
  tutEjecutableEnCola = false;
  tutTyposquatEnCola = false;
  tutSelloCorpEnCola = false;
  tutSobornoEnCola = false;
  tutEncriptadaEnCola = false;
  tutBombaEnCola = false;
  tutContaminadaEnCola = false;
  guiaErrorActiva = false;
  guiaErrorTexto = "";
  guiaErrorTimer = 0;

  tutorialTiendaVisto = false;
  tutorialTiendaActivo = false;
  tutTiendaPaso = 0;
  tutTiendaCaracteres = 0;
  tutTiendaAcumulador = 0;
  tutTiendaAparicion = 0;
  tutTiendaRebote = 1.0;
  tutTiendaLayoutIniciado = false;

  inicializarDummiesTutorial();
}

boolean interceptarClickTutorial() {
  if (jefeActivo > 0) return false;

  if (mostrandoTutorialIngame) {
    String txt = textoTutorialIngame(tipoTutorialIngame);
    int totalVis = contarCaracteresVisiblesTutorial(txt);
    if (tutIngameCaracteres < totalVis) {
      tutIngameCaracteres = totalVis;
      tutIngameAcumulador = totalVis;
      reproducirClickUI(false);
      return true;
    }
    if (hoverBotonOKTutorialIngame()) {
      mostrandoTutorialIngame = false;
      reproducirTap();
      dispararSacudidaCamara(2.0);
    }

    return true;
  }

  if (!mostrandoTutorial) return false;

  if (hoverSaltarTutorial()) {
    terminarTutorial();
    return true;
  }

  if (esPasoDrillTutorial() && !tutCardSaliendo) {
    float cardBaseX = obtenerPanelGameX() + obtenerPanelGameW() * 0.5;
    float cardBaseY = obtenerPanelGameY() + obtenerPanelGameH() * 0.55;
    float cX = cardBaseX + tutCardPosX;
    float cY = cardBaseY + tutCardPosY;
    float cardW = 500;
    float cardH = 275;

    boolean overCard = (mouseX >= cX - cardW * 0.5 && mouseX <= cX + cardW * 0.5 &&
                        mouseY >= cY - cardH * 0.5 && mouseY <= cY + cardH * 0.5);
    if (overCard) {
      tutArrastrandoCarta = true;
      tutDragStartX = mouseX - tutCardPosX;
      tutDragStartY = mouseY - tutCardPosY;
      reproducirClickUI(false);
      return true;
    }
  }

  avanzarTutorial();
  return true;
}

boolean interceptarDragTutorial() {
  if (jefeActivo > 0) return false;
  if (mostrandoTutorialIngame) return true;
  if (!mostrandoTutorial) return false;
  if (tutArrastrandoCarta && !tutCardSaliendo) {
    tutCardPosX = mouseX - tutDragStartX;
    tutCardPosY = mouseY - tutDragStartY;
    cursorSobreElementoClicable = true;
    return true;
  }
  return false;
}

boolean interceptarReleaseTutorial() {
  if (jefeActivo > 0) return false;
  if (mostrandoTutorialIngame) return true;
  if (!mostrandoTutorial) return false;
  if (tutArrastrandoCarta && !tutCardSaliendo) {
    tutArrastrandoCarta = false;
    float SWIPE_THRESHOLD_TUT = 110.0;
    boolean swipeDer = tutCardPosX >= SWIPE_THRESHOLD_TUT;
    boolean swipeIzq = tutCardPosX <= -SWIPE_THRESHOLD_TUT;

    if (swipeDer) {
      evaluarSwipeDrill(0);
    } else {
      if (swipeIzq) {
        evaluarSwipeDrill(1);
      } else {
        tutCardPosX = 0;
        tutCardPosY = 0;
      }
    }
    return true;
  }
  return false;
}

boolean keyPressedTutorial() {
  if (jefeActivo > 0) return false;

  if (mostrandoTutorialIngame) {
    String txt = textoTutorialIngame(tipoTutorialIngame);
    int totalVis = contarCaracteresVisiblesTutorial(txt);
    if (tutIngameCaracteres < totalVis && (key == ' ' || key == ENTER || key == RETURN)) {
      tutIngameCaracteres = totalVis;
      tutIngameAcumulador = totalVis;
    } else if (tutIngameCaracteres >= totalVis && (key == ' ' || key == ENTER || key == RETURN || key == TAB)) {
      mostrandoTutorialIngame = false;
      reproducirTap();
      dispararSacudidaCamara(2.0);
    }
    return true;
  }

  if (!mostrandoTutorial) return false;

  if (key == TAB) {
    terminarTutorial();
    return true;
  }

  if (esPasoDrillTutorial() && !tutCardSaliendo) {
    if (keyCode == RIGHT || key == 'd' || key == 'D') {
      evaluarSwipeDrill(0);
      return true;
    } else {
      if (keyCode == LEFT || key == 'a' || key == 'A') {
        evaluarSwipeDrill(1);
        return true;
      }
    }
  }

  if (key == ' ' || key == ENTER || key == RETURN) {
    avanzarTutorial();
    return true;
  }

  return true;
}

boolean tutorialTiendaVisto = false;
boolean tutorialTiendaActivo = false;
int tutTiendaPaso = 0;
int tutTiendaCaracteres = 0;
float tutTiendaAcumulador = 0;
float tutTiendaAparicion = 0;
float tutTiendaRebote = 1.0;
float tutTiendaFocoX = 0, tutTiendaFocoY = 0, tutTiendaFocoW = 0, tutTiendaFocoH = 0;
float tutTiendaDlgX = 0, tutTiendaDlgY = 0, tutTiendaDlgH = 190;
boolean tutTiendaLayoutIniciado = false;
final int TUT_TIENDA_TOTAL_PASOS = 5;

void iniciarTutorialTienda() {
  if (tutorialTiendaVisto || tutorialTiendaActivo) return;
  tutorialTiendaActivo = true;
  tutTiendaPaso = 0;
  tutTiendaCaracteres = 0;
  tutTiendaAcumulador = 0;
  tutTiendaAparicion = 0;
  tutTiendaRebote = 1.0;
  tutTiendaLayoutIniciado = false;
  reproducirTap();
}

void terminarTutorialTienda() {
  tutorialTiendaActivo = false;
  tutorialTiendaVisto = true;
  reproducirTap();
}

String textoTutorialTienda(int paso) {
  String usuario = (nombreJugador != null && strTrim(nombreJugador).length() > 0) ? strTrim(nombreJugador) : "Operador";
  switch (paso) {
    case 0:
      return "Hey " + usuario + "! Parece que estás usando una versión del sistema que permite modificaciones de usuario; puedes implantarte modificaciones usando {Y}PLUGINS{/}: un plugin es un chip que te dará ventajas, la mayoría tienen habilidades {C}activas{/} y {G}pasivas{/}, léelas con cuidado...";
    case 1:
      return "Bueno " + usuario + ", bienvenido a la {C}tienda{/}. En este mercado digital puedes meterle a tu sistema operativo plugins y modificadores que te darán ventajas. Se te darán {Y}3 opciones{/} por tienda; algunos plugins son mejores que otros evidentemente.";
    case 2:
      return "Si las opciones no te convencen, puedes hacerles {Y}reroll con este botón{/} para renovar el catálogo. Ojo: cada reroll consecutivo cuesta más tokens, así que administra bien tu saldo.";
    case 3:
      return "Lo siguiente es el {C}MÓDULO RAM{/}. Estos módulos son {G}mejoras permanentes{/} para todo tu sistema operativo y no ocupan slot arriba, así que intenta comprarlos siempre que puedas.";
    default:
      return "Por último los {Y}PAQUETES{/}: si no te gustan tus opciones siempre puedes apostar por otras abriendo sobres sellados. Pasa el mouse sobre {C}cualquier elemento{/} para leer su descripción y saber exactamente qué hace.";
  }
}

float[] obtenerRectFocoTutorialTienda(int paso) {
  float margin = width * 0.02;
  float topY = height * 0.03;
  float topH = height * 0.20;
  float startY = topY + topH + height * 0.02;
  float totalH = height * 0.72;
  float leftW = width * 0.26;
  float mainX = margin + leftW + width * 0.02;
  float mainW = width - mainX - margin;

  float row1H = (totalH - 16) * 0.50;
  float row2H = totalH - row1H - 16;
  float row2Y = startY + row1H + 16;

  float cardH = row1H - 22;
  float btnH = 36;
  float spriteH = cardH - btnH - 8;
  float spriteW = round(spriteH * (71.0 / 95.0));
  float cardW = spriteW;
  float cardSpacing = 18.0;
  float startCardX = 22.0 + cardW * 0.5;
  float rightOfCards = startCardX + 2 * (cardW + cardSpacing) + cardW * 0.5;

  switch (paso) {
    case 0:
      return new float[] { margin, topY, width - margin * 2.0, topH };
    case 1:
      return new float[] { mainX + 10, startY + 6, rightOfCards + 6, row1H - 12 };
    case 2:
      float btnContH = 56;
      float btnContY = 52 + btnContH * 0.5;
      float btnRerollH = 50;
      float btnRerollY = startY + (btnContY + btnContH * 0.5 + 14 + btnRerollH * 0.5);
      return new float[] { margin + 16, btnRerollY - btnRerollH * 0.5, leftW - 32, btnRerollH };
    case 3:
      float ramW = max(cardW + 24, 130);
      float ramH = row1H - 14;
      float ramCX = mainX + rightOfCards + (mainW - rightOfCards) * 0.5;
      float ramCY = startY + row1H * 0.5 + 4;
      return new float[] { ramCX - ramW * 0.5, ramCY - ramH * 0.5, ramW, ramH };
    default:
      return new float[] { mainX + 10, row2Y + 8, mainW - 20, row2H - 16 };
  }
}

float[] posDialogoTutorialTienda(int paso, float dlgW) {
  float minCX = dlgW * 0.5 + 215;
  float maxCX = width - dlgW * 0.5 - 30;
  switch (paso) {
    case 0:
      return new float[] { constrain(width * 0.56, minCX, maxCX), height * 0.54 };
    case 1:
      return new float[] { constrain(width * 0.56, minCX, maxCX), height * 0.78 };
    case 2:
      return new float[] { constrain(width * 0.68, minCX, maxCX), height * 0.50 };
    case 3:
      return new float[] { constrain(width * 0.50, minCX, maxCX), height * 0.78 };
    default:
      return new float[] { constrain(width * 0.58, minCX, maxCX), height * 0.40 };
  }
}

float[] rectSaltarTutorialTienda() {
  float w = 240;
  float h = 40;
  return new float[] { width - w - 30, height - h - 30, w, h };
}

boolean hoverSaltarTutorialTienda() {
  float[] r = rectSaltarTutorialTienda();
  return mouseX >= r[0] && mouseX <= r[0] + r[2] && mouseY >= r[1] && mouseY <= r[1] + r[3];
}

void avanzarTutorialTienda() {
  String txt = textoTutorialTienda(tutTiendaPaso);
  int totalVis = contarCaracteresVisiblesTutorial(txt);
  if (tutTiendaCaracteres < totalVis) {
    tutTiendaCaracteres = totalVis;
    tutTiendaAcumulador = totalVis;
    reproducirClickUI(false);
    return;
  }
  if (tutTiendaPaso < TUT_TIENDA_TOTAL_PASOS - 1) {
    tutTiendaPaso++;
    tutTiendaCaracteres = 0;
    tutTiendaAcumulador = 0;
    tutTiendaRebote = 1.0;
    reproducirClickUI(false);
  } else {
    terminarTutorialTienda();
  }
}

void actualizarYDibujarTutorialTienda() {
  if (!tutorialTiendaActivo) return;

  tutTiendaAparicion = lerp(tutTiendaAparicion, 1.0, 0.16);
  tutTiendaRebote = lerp(tutTiendaRebote, 0.0, 0.12);

  String texto = textoTutorialTienda(tutTiendaPaso);
  int totalVis = contarCaracteresVisiblesTutorial(texto);

  if (tutTiendaCaracteres < totalVis) {
    int prevChars = tutTiendaCaracteres;
    tutTiendaAcumulador += tutorialVelocidadEscritura;
    tutTiendaCaracteres = min(totalVis, int(tutTiendaAcumulador));
    sonarBlipVozAdmin(tutTiendaCaracteres, prevChars);
  }

  pushStyle();
  pushMatrix();
  rectMode(CORNER);
  colorMode(RGB, 255);

  float dlgW = min(540, width * 0.44);
  textSize(TUT_TEXTO_SIZE);
  String[] lineas = envolverTextoTutorial(texto, dlgW - 48);
  int numLineas = contarTextos(lineas);
  float dlgHObjetivo = max(168, 98 + numLineas * TUT_INTERLINEADO);

  float[] zr = obtenerRectFocoTutorialTienda(tutTiendaPaso);
  float objFX = zr[0] - TUT_PADDING_FOCO;
  float objFY = zr[1] - TUT_PADDING_FOCO;
  float objFW = zr[2] + TUT_PADDING_FOCO * 2;
  float objFH = zr[3] + TUT_PADDING_FOCO * 2;
  float[] dp = posDialogoTutorialTienda(tutTiendaPaso, dlgW);

  if (!tutTiendaLayoutIniciado) {
    tutTiendaFocoX = objFX; tutTiendaFocoY = objFY; tutTiendaFocoW = objFW; tutTiendaFocoH = objFH;
    tutTiendaDlgX = dp[0]; tutTiendaDlgY = dp[1]; tutTiendaDlgH = dlgHObjetivo;
    tutTiendaLayoutIniciado = true;
  }
  tutTiendaFocoX = lerp(tutTiendaFocoX, objFX, 0.18);
  tutTiendaFocoY = lerp(tutTiendaFocoY, objFY, 0.18);
  tutTiendaFocoW = lerp(tutTiendaFocoW, objFW, 0.18);
  tutTiendaFocoH = lerp(tutTiendaFocoH, objFH, 0.18);
  tutTiendaDlgX = lerp(tutTiendaDlgX, dp[0], 0.16);
  tutTiendaDlgY = lerp(tutTiendaDlgY, dp[1], 0.16);
  tutTiendaDlgH = lerp(tutTiendaDlgH, dlgHObjetivo, 0.25);

  color colG = colorTema();
  float a = tutTiendaAparicion;

  float fx = max(0, tutTiendaFocoX);
  float fy = max(0, tutTiendaFocoY);
  float fw = max(0, min(tutTiendaFocoW, width - fx));
  float fh = max(0, min(tutTiendaFocoH, height - fy));

  noStroke();
  fill(0, 195 * a);
  rect(0, 0, width, fy);
  rect(0, fy + fh, width, max(0, height - (fy + fh)));
  rect(0, fy, fx, fh);
  rect(fx + fw, fy, max(0, width - (fx + fw)), fh);

  if (fw > 20 && fh > 20) {
    float pulso = 0.6 + 0.4 * sin(frameCount * 0.12);
    pushMatrix();
    translate(fx, fy);
    noFill();
    stroke(colG, 60 * a * pulso);
    strokeWeight(8);
    dibujarFormaAngularBase(fw, fh, 16);
    stroke(colG, 240 * a);
    strokeWeight(2.5);
    dibujarFormaAngularBase(fw, fh, 16);
    popMatrix();

    dibujarLineaTutorial(tutTiendaDlgX - dlgW / 2, tutTiendaDlgY - tutTiendaDlgH / 2, dlgW, tutTiendaDlgH, fx, fy, fw, fh, colG, a);

    if (tutTiendaPaso == 2) {
      float tx = fx + fw + 14 + sin(frameCount * 0.18) * 5;
      float ty = fy + fh * 0.5;
      fill(255, 215, 60, 240 * a);
      noStroke();
      triangle(tx, ty, tx + 14, ty - 8, tx + 14, ty + 8);
      textAlign(LEFT, CENTER);
      textSize(13);
      text("REROLL", tx + 20, ty - 1);
    }
  }

  boolean hablando = tutTiendaCaracteres < totalVis;
  dibujarRetratoAdminTutorial(tutTiendaDlgX - dlgW / 2 - 20, tutTiendaDlgY, a, colG, hablando, tutTiendaRebote);
  dibujarDialogoTutorialTienda(lineas, totalVis, tutTiendaDlgX, tutTiendaDlgY, dlgW, tutTiendaDlgH, a, colG);

  float[] rSalt = rectSaltarTutorialTienda();
  boolean hovSalt = hoverSaltarTutorialTienda();
  if (hovSalt) cursorSobreElementoClicable = true;
  pushMatrix();
  translate(rSalt[0], rSalt[1]);
  stroke(colG, 200 * a);
  strokeWeight(2);
  fill(hovSalt ? colG : color(6, 16, 12), 230 * a);
  dibujarFormaAngularBase(rSalt[2], rSalt[3], 10);
  noStroke();
  fill(hovSalt ? color(0) : color(220, 235, 225), 255 * a);
  textAlign(CENTER, CENTER);
  textSize(14);
  text("SALTAR TUTORIAL [TAB]", rSalt[2] / 2, rSalt[3] / 2 - 2);
  popMatrix();

  popMatrix();
  popStyle();
}

void dibujarDialogoTutorialTienda(String[] lineas, int largoVisible, float cx, float cy, float w, float h, float a, color colG) {
  boolean terminado = tutTiendaCaracteres >= largoVisible;
  float mw = w / 2;
  float mh = h / 2;
  if (mouseX >= cx - mw && mouseX <= cx + mw && mouseY >= cy - mh && mouseY <= cy + mh) {
    cursorSobreElementoClicable = true;
  }

  pushMatrix();
  translate(cx, cy);
  rectMode(CENTER);
  noStroke();

  pushMatrix();
  rotate(0.015);
  fill(red(colG) * 0.25, green(colG) * 0.25, blue(colG) * 0.25, 170 * a);
  rect(8, 10, w, h, 16);
  popMatrix();

  fill(4, 12, 9, 245 * a);
  rect(0, 0, w, h, 16);

  noFill();
  stroke(colG, 220 * a);
  strokeWeight(2.2);
  rect(0, 0, w, h, 16);

  noStroke();
  textSize(16);
  textAlign(LEFT, TOP);
  fill(colG, 255 * a);
  text("ADMIN // MERCADO CLANDESTINO", -mw + 24, -mh + 18);

  textAlign(RIGHT, TOP);
  fill(colG, 170 * a);
  text("[TIENDA] " + (tutTiendaPaso + 1) + "/" + TUT_TIENDA_TOTAL_PASOS, mw - 24, -mh + 18);

  textSize(TUT_TEXTO_SIZE);
  textAlign(LEFT, TOP);
  int restantes = tutTiendaCaracteres;
  float y = -mh + 50;
  int totalLineas = contarTextos(lineas);
  colTagPersistenteTutorial = color(225, 235, 230);
  for (int i = 0; i < totalLineas && restantes > 0; i++) {
    restantes = dibujarLineaFormateadaTutorial(lineas[i], -mw + 24, y, restantes, a, colG);
    y += TUT_INTERLINEADO;
  }

  textSize(13);
  if (terminado) {
    float pulsoPie = 0.5 + 0.5 * sin(frameCount * 0.18);
    textAlign(RIGHT, BOTTOM);
    fill(colG, 240 * pulsoPie);
    String pie = (tutTiendaPaso >= TUT_TIENDA_TOTAL_PASOS - 1) ? "CLICK O ESPACIO PARA COMPRAR >>" : "CLICK O ESPACIO PARA CONTINUAR >>";
    text(pie, mw - 24, mh - 12);
  } else {
    if ((millis() / 450) % 2 == 0) {
      fill(colG, 255 * a);
      rectMode(CORNER);
      rect(-mw + 24, mh - 26, 10, 16);
    }
  }

  popMatrix();
  rectMode(CORNER);
}

boolean mousePressedTutorialTienda() {
  if (!tutorialTiendaActivo) return false;
  if (hoverSaltarTutorialTienda()) {
    terminarTutorialTienda();
    return true;
  }
  avanzarTutorialTienda();
  return true;
}

boolean keyPressedTutorialTienda() {
  if (!tutorialTiendaActivo) return false;
  if (key == TAB) {
    terminarTutorialTienda();
    return true;
  }
  if (key == ' ' || key == ENTER || key == RETURN) {
    avanzarTutorialTienda();
    return true;
  }
  return true;
}
