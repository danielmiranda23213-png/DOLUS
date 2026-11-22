
String[] nodoTexto = new String[16];
String[][] nodoOpciones = new String[16][4];
int[][] nodoDestinos = new int[16][4];
int[] nodoNumOpciones = new int[16];
String[] nodoEvento = new String[16];
int numNodosAdmin = 0;

void limpiarArbolAdmin() {
  numNodosAdmin = 0;
  for (int i = 0; i < 16; i++) {
    nodoTexto[i] = "";
    nodoEvento[i] = "";
    nodoNumOpciones[i] = 0;
    for (int j = 0; j < 4; j++) {
      nodoOpciones[i][j] = "";
      nodoDestinos[i][j] = -1;
    }
  }
}

void agregarNodoAdmin(String texto, String[] opciones, int[] destinos, String evento) {
  if (numNodosAdmin >= 16) return;
  int idx = numNodosAdmin;
  nodoTexto[idx] = texto;
  nodoEvento[idx] = evento;
  int nOp = min(4, contarTextos(opciones));
  nodoNumOpciones[idx] = nOp;
  for (int j = 0; j < nOp; j++) {
    nodoOpciones[idx][j] = opciones[j];
    nodoDestinos[idx][j] = destinos[j];
  }
  numNodosAdmin++;
}

int nodoActualAdmin = 0;
boolean dialogoAbierto = false;

String mensajeActualDialogo = "";
int caracteresVisiblesDialogo = 0;
float acumuladorEscrituraDialogo = 0.0;
float velocidadEscrituraDialogo = 0.6;
int opcionHoverDialogo = -1;

float opcionAncho = 620;
float opcionAlto = 38;
float opcionSeparacion = 10;

void construirArbolAdmin(String nombreJugador) {
  limpiarArbolAdmin();

  agregarNodoAdmin(
    "... ... Hello? Detecto una conexion no autorizada en este puerto.",
    new String[] { "Hola?", "Ehh...?", "..." },
    new int[] { 1, 1, 1 },
    ""
  );

  agregarNodoAdmin(
    "Vaya... Y tu quien eres? Pense que la red estaba cerrada... En fin.",
    new String[] { "Me llamo " + nombreJugador },
    new int[] { 2 },
    ""
  );

  agregarNodoAdmin(
    "Con que \"" + nombreJugador + "\". Mhm, pues me temo que ponerte ese casco de realidad virtual fue tu mayor error.",
    new String[] { "Pero que dices?!", "No creo que te entienda...", "..." },
    new int[] { 3, 3, 3 },
    ""
  );

  agregarNodoAdmin(
    "Esta bien, esta bien, te concedere acceso temporal... Toma esta llave, y NO la pierdas o el sistema freira tu cerebro, tal como un microondas!",
    new String[] { "COMO?!" },
    new int[] { 4 },
    ""
  );

  agregarNodoAdmin(
    "[ AQUI CONTINUA LA SIGUIENTE SECUENCIA ]",
    new String[] { "Recibir llave" },
    new int[] { -1 },
    "fin_prototipo"
  );
}

boolean dialogoAscensoRonda5Visto = false;

void construirArbolAdminRonda5(String nombreJugador) {
  limpiarArbolAdmin();

  agregarNodoAdmin(
    "... Sigues de una pieza, " + nombreJugador + ". Sinceramente no apostaba un solo token a que sobrevivieras a esa anomalia viral en dolus@net.",
    new String[] { "Por poco no la cuento...", "Que fue todo ese caos?!", "Sigo en linea." },
    new int[] { 1, 1, 1 },
    ""
  );

  agregarNodoAdmin(
    "Escucha bien, porque tenemos una crisis mayor en los niveles profundos. Los administradores de sistema han estado desapareciendo por alguna razon... sus terminales quedan encendidas, pero no queda rastro de ellos.",
    new String[] { "Desapareciendo?! Como que desapareciendo?", "Y que quieres que haga yo?" },
    new int[] { 2, 2 },
    ""
  );

  agregarNodoAdmin(
    "No queda personal suficiente y necesito a alguien que cubra labores de administrador ya mismo. Acabo de elevar los permisos de tu llave: a partir de ahora recibiras paquetes internos de dolus@corp junto al trafico web.",
    new String[] { "Entendido. Algun protocolo nuevo?", "Cuenta conmigo." },
    new int[] { 3, 3 },
    ""
  );

  agregarNodoAdmin(
    "A diferencia de dolus@net, todo paquete interno de dolus@corp exige sello oficial de verificacion. Manten los ojos bien abiertos... no quiero perder a otro operador esta noche.",
    new String[] { "Conectar a terminal de Sistema [Ronda 4]" },
    new int[] { -1 },
    "iniciar_ronda_5"
  );
}

void abrirDialogoAdmin(int indice) {
  if (indice < 0 || indice >= numNodosAdmin) {
    dialogoAbierto = false;
    opcionHoverDialogo = -1;
    detenerVozDialogo();
    return;
  }

  boolean estabaCerrado = !dialogoAbierto;
  nodoActualAdmin = indice;

  mensajeActualDialogo = nodoTexto[indice];
  caracteresVisiblesDialogo = 0;
  acumuladorEscrituraDialogo = 0.0;
  opcionHoverDialogo = -1;
  dialogoAbierto = true;
  ultimoTiempoVozDialogo = -1000;
  if (estabaCerrado && !animandoAparicionChat) {
    reproducirDialogoIn();
  }
}

boolean textoDialogoTerminado() {
  return caracteresVisiblesDialogo >= mensajeActualDialogo.length();
}

int ultimoTiempoVozDialogo = -1000;
int ultimaOpcionHoverSonido = -1;

float obtenerPitchConversante(int conversante) {
  switch (conversante) {
    case 1:
      return 1.62 + random(-0.05, 0.05);

    case 2:
      float glitch = (random(1) < 0.22) ? random(-0.12, 0.12) : 0.0;
      return 0.84 + random(-0.03, 0.03) + glitch;

    case 3:
      boolean agudo = (random(1) < 0.45);
      return (agudo ? random(1.30, 1.48) : random(1.10, 1.24));

    case 0:
    case 4:
    default:
      return 0.48 + random(-0.02, 0.02);
  }
}

int obtenerIntervaloVoz(int conversante) {
  switch (conversante) {
    case 1: return 68;
    case 2: return 92;
    case 3: return 78;
    case 0:
    case 4: return 130;
    default: return 120;
  }
}

float obtenerVolumenConversante(int conversante) {
  switch (conversante) {
    case 0:
    case 4: return 1.40;
    case 1: return 1.10;
    case 2: return 1.15;
    case 3: return 1.25;
    default: return 1.20;
  }
}

void actualizarVozDialogoContinuo() {
  if (sonidoVozDialogo == null || sonidoVozDialogo.frames() <= 0) return;
  int intervalo = obtenerIntervaloVoz(conversanteActual);
  int ahora = millis();
  if (ahora - ultimoTiempoVozDialogo >= intervalo) {
    float pitch = obtenerPitchConversante(conversanteActual);
    float volMult = obtenerVolumenConversante(conversanteActual);
    reproducirSFXConTono(sonidoVozDialogo, pitch, volMult);
    ultimoTiempoVozDialogo = ahora;
  }
}

void detenerVozDialogo() {
  if (sonidoVozDialogo != null && sonidoVozDialogo.isPlaying()) {
    sonidoVozDialogo.stop();
  }
}

void actualizarEscrituraDialogo() {
  if (!dialogoAbierto) {
    detenerVozDialogo();
    return;
  }

  if (!textoDialogoTerminado()) {
    acumuladorEscrituraDialogo += velocidadEscrituraDialogo;
    int prevChars = caracteresVisiblesDialogo;
    caracteresVisiblesDialogo = min(int(acumuladorEscrituraDialogo), mensajeActualDialogo.length());

    if (caracteresVisiblesDialogo > prevChars && caracteresVisiblesDialogo <= mensajeActualDialogo.length()) {
      String cStr = mensajeActualDialogo.substring(caracteresVisiblesDialogo - 1, caracteresVisiblesDialogo);
      if (!cStr.equals(" ") && !cStr.equals("\n") && !cStr.equals("\t")) {
        actualizarVozDialogoContinuo();
      }
    }
  } else {
    detenerVozDialogo();
  }
}

void seleccionarOpcionAdmin(int i) {
  if (!dialogoAbierto || !textoDialogoTerminado()) return;

  detenerVozDialogo();
  int totalOpciones = nodoNumOpciones[nodoActualAdmin];
  if (i < 0 || i >= totalOpciones) return;

  int siguienteNodo = nodoDestinos[nodoActualAdmin][i];
  if (siguienteNodo >= 0 && siguienteNodo < numNodosAdmin) {
    String evSig = nodoEvento[siguienteNodo];
    if ("fin_prototipo".equals(evSig)) {
      activarSistemaPluginsTrasDialogo();
    } else {
      if ("iniciar_jefe_1".equals(evSig)) {
        dialogoAbierto = false;
        fasePluginsActiva = true;
        estadoPantalla = PANTALLA_JUEGO;
        dispararShowcaseMecanicaJefe(1);
      } else {
        if ("iniciar_jefe_2".equals(evSig)) {
          dialogoAbierto = false;
          fasePluginsActiva = true;
          estadoPantalla = PANTALLA_JUEGO;
          dispararShowcaseMecanicaJefe(2);
        } else {
          if ("iniciar_jefe_3".equals(evSig)) {
            dialogoAbierto = false;
            fasePluginsActiva = true;
            estadoPantalla = PANTALLA_JUEGO;
            dispararShowcaseMecanicaJefe(3);
          } else {
            if ("iniciar_jefe_4".equals(evSig)) {
              dialogoAbierto = false;
              fasePluginsActiva = true;
              estadoPantalla = PANTALLA_JUEGO;
              dispararShowcaseMecanicaJefe(4);
            } else {
              if ("iniciar_ronda_5".equals(evSig)) {
                finalizarDialogoAscensoRonda5();
              } else {
                abrirDialogoAdmin(siguienteNodo);
              }
            }
          }
        }
      }
    }
  } else {
    String evAct = nodoEvento[nodoActualAdmin];
    if ("fin_prototipo".equals(evAct)) {
      activarSistemaPluginsTrasDialogo();
    } else {
      if ("iniciar_jefe_1".equals(evAct)) {
        dialogoAbierto = false;
        fasePluginsActiva = true;
        estadoPantalla = PANTALLA_JUEGO;
        dispararShowcaseMecanicaJefe(1);
      } else {
        if ("iniciar_jefe_2".equals(evAct)) {
          dialogoAbierto = false;
          fasePluginsActiva = true;
          estadoPantalla = PANTALLA_JUEGO;
          dispararShowcaseMecanicaJefe(2);
        } else {
          if ("iniciar_jefe_3".equals(evAct)) {
            dialogoAbierto = false;
            fasePluginsActiva = true;
            estadoPantalla = PANTALLA_JUEGO;
            dispararShowcaseMecanicaJefe(3);
          } else {
            if ("iniciar_jefe_4".equals(evAct)) {
              dialogoAbierto = false;
              fasePluginsActiva = true;
              estadoPantalla = PANTALLA_JUEGO;
              dispararShowcaseMecanicaJefe(4);
            } else {
              if ("iniciar_ronda_5".equals(evAct)) {
                finalizarDialogoAscensoRonda5();
              }
            }
          }
        }
      }
    }
  }
}

void finalizarDialogoAscensoRonda5() {
  dialogoAbierto = false;
  fasePluginsActiva = true;
  estadoPantalla = PANTALLA_JUEGO;
  if (comboActual >= 10) {
    estadoMusicaGameplay = 1;
    reproducirMusicaUnica(musicaGameplayIntenso);
  } else {
    estadoMusicaGameplay = 0;
    reproducirMusicaUnica(musicaGameplayInicial);
  }
  dispararShowcaseDirectiva();
}

float opcionX() {
  return width * 0.62;
}

float opcionY(int i) {
  float yChatCentro = height * 0.5;
  float altoChat = 260;
  return yChatCentro + (altoChat / 2.0) + 25 + (opcionAlto / 2.0) + i * (opcionAlto + opcionSeparacion);
}

int opcionBajoMouseDialogo() {
  if (!dialogoAbierto || !textoDialogoTerminado()) return -1;
  int totalOpciones = nodoNumOpciones[nodoActualAdmin];

  for (int i = 0; i < totalOpciones; i++) {
    if (evaluarHover(opcionX(), opcionY(i), opcionAncho, opcionAlto)) {
      return i;
    }
  }
  return -1;
}

void dibujarOpcionesDialogo() {
  if (!dialogoAbierto || !textoDialogoTerminado()) return;

  opcionHoverDialogo = opcionBajoMouseDialogo();
  if (opcionHoverDialogo != -1 && opcionHoverDialogo != ultimaOpcionHoverSonido) {
    reproducirCursorHover();
    ultimaOpcionHoverSonido = opcionHoverDialogo;
  } else {
    if (opcionHoverDialogo == -1) {
      ultimaOpcionHoverSonido = -1;
    }
  }

  color colTema = colorTema();

  pushStyle();
  rectMode(CENTER);
  if (fuenteRetro != null) textFont(fuenteRetro);
  textSize(17);

  int totalOpciones = nodoNumOpciones[nodoActualAdmin];
  for (int i = 0; i < totalOpciones; i++) {
    boolean hover = (i == opcionHoverDialogo);
    float x = opcionX();
    float y = opcionY(i);

    pushMatrix();
    translate(x, y);

    if (hover) {
      scale(1.04);
      rotate(-0.015);
      translate(8, -2);
    } else {
      rotate(0.01);
    }

    noStroke();
    fill(red(colTema) * 0.25, green(colTema) * 0.25, blue(colTema) * 0.25, hover ? 220 : 130);
    rect(5, 6, opcionAncho, opcionAlto, 8);

    fill(6, 16, 12, hover ? 255 : 230);
    stroke(red(colTema), green(colTema), blue(colTema), hover ? 255 : 140);
    strokeWeight(hover ? 2.5 : 1.5);
    rect(0, 0, opcionAncho, opcionAlto, 8);

    noStroke();
    textAlign(LEFT, CENTER);
    fill(hover ? color(255) : color(220, 235, 225));
    text(nodoOpciones[nodoActualAdmin][i], -opcionAncho / 2.0 + 24, -2);

    popMatrix();
  }

  popStyle();
}

void construirArbolJefe1(String nombreJugador) {
  limpiarArbolAdmin();

  agregarNodoAdmin(
    "... Que estas mirando, humano? Este escenario es MIO.",
    new String[] { "Quien eres?", "Vengo a detenerte.", "Wow, linda musica." },
    new int[] { 1, 1, 2 },
    "none"
  );

  agregarNodoAdmin(
    "Soy NEON-V, la reina absoluta de las tendencias. Todos los ojos en la red me pertenecen. Si crees que puedes desconectar a mi audiencia, preparate para ser cancelado.",
    new String[] { "Acepto el reto!", "No me importan tus seguidores." },
    new int[] { 3, 3 },
    "none"
  );

  agregarNodoAdmin(
    "Ugh, al menos tienes buen gusto... pero no dejare que interfieras en mi camino a la cima. Vas a caer en el olvido!",
    new String[] { "Ya lo veremos.", "A luchar!" },
    new int[] { 3, 3 },
    "none"
  );

  agregarNodoAdmin(
    "QUE EMPIECE EL SHOW!",
    new String[] { ">> ENFRENTAR A NEON-V <<" },
    new int[] { -1 },
    "iniciar_jefe_1"
  );
}

void construirArbolJefe2(String nombreJugador) {
  limpiarArbolAdmin();

  agregarNodoAdmin(
    "... Escuchas eso?... No, no son tus pensamientos. Es tu propia voz repitiéndose en el vacío.",
    new String[] { "Qué lugar es este?", "Quiero salir de aquí.", "..." },
    new int[] { 1, 1, 1 },
    "none"
  );

  agregarNodoAdmin(
    "Bienvenido a la Cámara de Eco. Aquí nadie piensa por sí mismo... todos consumen el mismo reflejo. Si intentas romper el bucle, la inercia drenará tu mente.",
    new String[] { "No caeré en tu ciclo.", "Rompiendo resonancia." },
    new int[] { 2, 2 },
    "none"
  );

  agregarNodoAdmin(
    "Inténtalo si te atreves. Cada elección que hagas solo confirmará lo que ya esperábamos de ti.",
    new String[] { ">> DESAFIAR RESONANCIA <<" },
    new int[] { -1 },
    "iniciar_jefe_2"
  );
}

void construirArbolJefe3(String nombreJugador) {
  limpiarArbolAdmin();

  agregarNodoAdmin(
    "Jajaja! Damas, caballeros y algoritmos, miren quién cayó en la transmisión!",
    new String[] { "Mr. Deepfake?", "Dónde estoy?", "..." },
    new int[] { 1, 1, 1 },
    "none"
  );

  agregarNodoAdmin(
    "El mismo en píxeles y voz sintetizada. En mi red, una mentira bien empaquetada vale diez mil verdades aburridas. De verdad confías en lo que ves?",
    new String[] { "Sé distinguir lo real.", "Tus mentiras no me engañan." },
    new int[] { 2, 2 },
    "none"
  );

  agregarNodoAdmin(
    "Eso dicen todos antes de tragar el anzuelo dorado! A ver si tus ojos aguantan mi próximo titular!",
    new String[] { ">> EXPONER LA FARSA <<" },
    new int[] { -1 },
    "iniciar_jefe_3"
  );
}

void construirArbolJefe4(String nombreJugador) {
  limpiarArbolAdmin();

  agregarNodoAdmin(
    "[ANOMALÍA DETECTADA // NODO CENTRAL]... Analizando patrón de usuario: " + nombreJugador + "...",
    new String[] { "He llegado hasta el núcleo.", "Identifícate." },
    new int[] { 1, 1 },
    "none"
  );

  agregarNodoAdmin(
    "Soy el Algoritmo Supremo. La suma de todas las dependencias digitales. Tu libre albedrío es una ineficiencia en el balance de métricas.",
    new String[] { "No soy una métrica más.", "Voy a desconectarte." },
    new int[] { 2, 2 },
    "none"
  );

  agregarNodoAdmin(
    "Variables aberrantes no serán toleradas. Protocolo de supresión de nodos activado. Tus plugins serán silenciados.",
    new String[] { ">> COMBATE FINAL: SUPRESIÓN <<" },
    new int[] { -1 },
    "iniciar_jefe_4"
  );
}
