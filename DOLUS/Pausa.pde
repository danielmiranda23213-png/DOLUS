String[] opcionesPausa = {
  "REANUDAR",
  "GUARDAR PARTIDA",
  "COMPENDIO",
  "CONFIGURACION",
  "SALIR AL MENU",
  "SALIR AL ESCRITORIO"
};

int numOpcionesPausa;
int estadoPausa = 0;
int destinoCierrePausa = 0;
boolean pausaSolicitada = false;
boolean abiertoDesdePausa = false;
int pantallaOrigenPausa = 8;
PImage fondoPausa;
float alphaVeloPausa = 200;
float multSfxPausa = 1.0;
int pausaInicioMs = 0;
int pausaAcumuladaMs = 0;

float[] progresoCartaPausa;
int[] contadorEsperaPausa;
float[] faseFlotePausa;
float[] desplazamientoYPausa;
float[] desplazamientoXPausa;
int[] hoverElapsedPausa;

float progresoTituloPausa = 0;

float[] posXFinalPausa, posYFinalPausa, rotFinalPausa;
float[] rotLetraHoverPausa = new float[10];
float[] velocidadRotacionPausa = new float[10];

int cartaHoverPausa = -1;
int seleccionPausa = 0;

float anchoCartaPausa = 420;
float altoCartaPausa = 90;

color colVerdePausa;
color colVerdeClaroPausa;
color colNegroPausa = color(4, 9, 7);
color colBlancoPausa = color(245, 245, 240);

float shakePausa = 0;
float ztiempoPausa = 0;
float pulsoTiempoPausa = 0;

SoundFile sonidoPausaApertura;
SoundFile sonidoPausaCierre;
SoundFile sonidoPausaHover;
SoundFile sonidoPausaConfirmar;

PFont fuenteMenuPausa;
PFont fuenteTituloPausa;

char[] charsGlitchPausa = {'0', '1', '$', '#', '%'};

void inicializarPausa() {
  try { fuenteMenuPausa = createFont("fontmenupausa.TTF", 32); } catch (Exception e) {}
  try { fuenteTituloPausa = createFont("fonttitulopausa.otf", 160); } catch (Exception e) {}

  int totalOp = contarTextos(opcionesPausa);
  if (totalOp == 0) {
    opcionesPausa = new String[]{ "REANUDAR" };
    totalOp = 1;
  }
  numOpcionesPausa = totalOp;

  progresoCartaPausa = new float[8];
  contadorEsperaPausa = new int[8];
  faseFlotePausa = new float[8];
  desplazamientoYPausa = new float[8];
  desplazamientoXPausa = new float[8];
  hoverElapsedPausa = new int[8];
  posXFinalPausa = new float[8];
  posYFinalPausa = new float[8];
  rotFinalPausa = new float[8];

  float baseX = width * 0.82;
  float baseY = height * 0.22;
  float pasoX = 8;
  float pasoY = 88;

  for (int i = 0; i < numOpcionesPausa; i++) {
    posXFinalPausa[i] = baseX + i * pasoX;
    posYFinalPausa[i] = baseY + i * pasoY;
    rotFinalPausa[i] = radians(-4);
    faseFlotePausa[i] = i * 1.3;
  }

  sonidoPausaApertura  = cargarSonido("aperturamenupausa.mp3");
  sonidoPausaCierre    = cargarSonido("cerrarmenupausa.mp3");
  sonidoPausaHover     = cargarSonido("hovertarjetapausa.mp3");
  sonidoPausaConfirmar = cargarSonido("confirmarseleccionpausa.mp3");
}

boolean pausaActiva() {
  return estadoPausa != 0;
}

boolean puedePausar() {
  boolean pantallaPausable = (estadoPantalla == PANTALLA_JUEGO)
      || (estadoPantalla == PANTALLA_TIENDA && !animandoTransicionTienda)
      || (estadoPantalla == PANTALLA_HABITACION && !habModalPuzle1Abierto && !habModalPuzle2Abierto && !habModalTelefonoAbierto && habFinalCinematicaEstado == 0);
  return pantallaPausable
      && !ejecutandoCargaNexus
      && !ejecutandoLinkStart
      && !mostrandoSplash
      && !animandoTVOff
      && estadoPausa == 0;
}

int millisJuego() {
  if (pausaActiva()) return pausaInicioMs - pausaAcumuladaMs;
  return millis() - pausaAcumuladaMs;
}

void revisarSolicitudPausa() {
  if (!pausaSolicitada) return;
  pausaSolicitada = false;
  if (!puedePausar()) return;

  try {
    fondoPausa = get();
  } catch (Exception e) {
    fondoPausa = null;
  }
  iniciarAperturaPausa();
}

void iniciarAperturaPausa() {
  if (numOpcionesPausa <= 0) return;
  estadoPausa = 1;
  destinoCierrePausa = 0;
  pausaInicioMs = millis();
  progresoTituloPausa = 0;
  seleccionPausa = 0;
  cartaHoverPausa = -1;

  for (int i = 0; i < numOpcionesPausa; i++) {
    progresoCartaPausa[i] = 0;
    contadorEsperaPausa[i] = i * 6;
    hoverElapsedPausa[i] = 0;
    desplazamientoYPausa[i] = 0;
    desplazamientoXPausa[i] = 0;
  }
  detenerVozDialogo();
  actualizarVolumenesAudio();
  reproducirSFX(sonidoPausaApertura, multSfxPausa);
}

void iniciarCierrePausa(int destino) {
  estadoPausa = 3;
  destinoCierrePausa = destino;
  for (int i = 0; i < numOpcionesPausa; i++) {
    contadorEsperaPausa[i] = (numOpcionesPausa - 1 - i) * 6;
  }
  cartaHoverPausa = -1;
  reproducirSFX(sonidoPausaCierre, multSfxPausa);
}

void terminarPausa() {
  estadoPausa = 0;
  pausaAcumuladaMs += millis() - pausaInicioMs;
  cartaHoverPausa = -1;
  actualizarVolumenesAudio();
}

void actualizarYDibujarPausa() {
  colVerdePausa = colorTema();
  colVerdeClaroPausa = lerpColor(colVerdePausa, color(255), 0.4);

  ztiempoPausa += 0.02;
  pulsoTiempoPausa += 0.045;

  pushStyle();
  noStroke();
  fill(255);
  rectMode(CORNER);
  imageMode(CORNER);
  noTint();

  actualizarAnimacionCartasPausa();

  if (fondoPausa != null) {
    image(fondoPausa, 0, 0, width, height);
  } else {
    background(colNegroPausa);
  }

  float alphaVelo = (destinoCierrePausa == 1) ? alphaVeloPausa : alphaVeloPausa * progresoTituloPausa;
  noStroke();
  fill(0, alphaVelo);
  rect(0, 0, width, height);

  if (estadoPausa != 0) {
    detectarHoverCartasPausa();
    dibujarMenuPausa();
  }
  popStyle();

  if (animandoTVOff) {
    dibujarEfectoTVOff();
  }
}

void actualizarAnimacionCartasPausa() {
  if (progresoCartaPausa == null || contadorEsperaPausa == null) return;

  if (estadoPausa == 1 || estadoPausa == 2) {
    progresoTituloPausa = min(1.0, progresoTituloPausa + 0.05);
  } else {
    if (estadoPausa == 3) {
      progresoTituloPausa = max(0.0, progresoTituloPausa - 0.07);
    }
  }

  boolean todasListas = true;
  for (int i = 0; i < numOpcionesPausa; i++) {
    if (estadoPausa == 1) {
      if (contadorEsperaPausa[i] > 0) { contadorEsperaPausa[i]--; todasListas = false; continue; }
      progresoCartaPausa[i] = min(1.0, progresoCartaPausa[i] + 0.05);
      if (progresoCartaPausa[i] < 1.0) todasListas = false;
    } else {
      if (estadoPausa == 3) {
        if (contadorEsperaPausa[i] > 0) { contadorEsperaPausa[i]--; todasListas = false; continue; }
        progresoCartaPausa[i] = max(0.0, progresoCartaPausa[i] - 0.06);
        if (progresoCartaPausa[i] > 0.0) todasListas = false;
      }
    }
  }

  if (estadoPausa == 1 && todasListas) {
    estadoPausa = 2;
  } else {
    if (estadoPausa == 3 && todasListas && progresoTituloPausa <= 0.01) {
      terminarPausa();
    }
  }
}

boolean manejarTeclaPausa() {
  if (key == ESC) {
    key = 0;
    if (estadoPausa == 0) {
      if (estadoPantalla == PANTALLA_HABITACION && habDialogoInicialActivo) {
        epCerrarDialogoIntroHabitacion();
        return true;
      }
      if (estadoPantalla == PANTALLA_HABITACION && habCelebracionCelularActiva) {
        if (millis() - habCelebracionInicioMs > 650) {
          epAbrirTelefonoGameplay();
        }
        return true;
      }
      if (estadoPantalla == PANTALLA_HABITACION && habFinalCinematicaEstado != 0) {
        if (epCreditosFinalesActivos) {
          if (millis() - epCreditosInicioMs > 500) {
            epFinalizarCreditosAlMenu();
          }
        } else {
          if (epFinActo < 2) {
            epSaltarCinematicaFinalDesenlace();
          }
        }
        return true;
      }
      if (estadoPantalla == PANTALLA_HABITACION && (habModalPuzle1Abierto || habModalPuzle2Abierto || habModalTelefonoAbierto)) {
        if (habModalTelefonoAbierto && (telFaseIntro == 3 || telCierreNegroActivo)) {
          return true;
        }
        reproducirTap();
        habModalPuzle1Abierto = false;
        habModalPuzle2Abierto = false;
        habModalTelefonoAbierto = false;
        telArrastrando = false;
        telSwipeX = 0;
        telSwipeTargetX = 0;
        return true;
      }
      if (estadoPantalla == PANTALLA_HABITACION) {
        limpiarMovimientoHabitacion();
      }
      if (puedePausar()) pausaSolicitada = true;
    } else {
      if (estadoPausa == 2 && !animandoTVOff) {
        iniciarCierrePausa(0);
      }
    }
    return true;
  }

  if (estadoPausa == 0 || estadoPausa != 2 || animandoTVOff || numOpcionesPausa <= 0) return (estadoPausa != 0);

  if (key == CODED && keyCode == UP) {
    seleccionPausa = (seleccionPausa - 1 + numOpcionesPausa) % numOpcionesPausa;
    cartaHoverPausa = -1;
    reproducirSFX(sonidoPausaHover, multSfxPausa);
  } else {
    if (key == CODED && keyCode == DOWN) {
      seleccionPausa = (seleccionPausa + 1) % numOpcionesPausa;
      cartaHoverPausa = -1;
      reproducirSFX(sonidoPausaHover, multSfxPausa);
    } else {
      if (key == ENTER || key == RETURN) {
        confirmarSeleccionPausa(seleccionPausa);
      }
    }
  }
  return true;
}

void mousePressedPausa() {
  if (estadoPausa == 2 && cartaHoverPausa != -1 && !animandoTVOff) {
    confirmarSeleccionPausa(cartaHoverPausa);
  }
}

void confirmarSeleccionPausa(int i) {
  if (i < 0 || opcionesPausa == null || i >= numOpcionesPausa) return;
  shakePausa = 6;
  reproducirSFX(sonidoPausaConfirmar, multSfxPausa);

  String opcion = opcionesPausa[i];
  if (opcion.equals("REANUDAR")) {
    iniciarCierrePausa(0);
  } else {
    if (opcion.equals("GUARDAR PARTIDA")) {
      if (modoFeriaActivo) {
        sincronizarPuntajeFeriaEnPausa();
        reproducirTap();
        if (sonidoDecisionCorrecta != null) reproducirSFX(sonidoDecisionCorrecta);
        dispararTextoElastico("PUNTAJE FERIA SINCRONIZADO EN RANKING", width * 0.5, height * 0.22, color(0, 255, 175));
      } else if (modoExposicionActivo) {
        reproducirTap();
        dispararTextoElastico("MODO EXPOSICION: SESION DEMO SIN GUARDADO", width * 0.5, height * 0.22, color(210, 145, 255));
      } else {
        guardarPartidaActual();
        reproducirTap();
        if (sonidoDecisionCorrecta != null) reproducirSFX(sonidoDecisionCorrecta);
        dispararTextoElastico("PARTIDA GUARDADA (RANURA " + ranuraGuardadoActiva + ")", width * 0.5, height * 0.22, color(0, 255, 175));
      }
    } else {
      if (opcion.equals("COMPENDIO")) {
        pantallaOrigenPausa = estadoPantalla;
        abiertoCompendioDesdePausa = true;
        estadoPausa = 0;
        estadoPantalla = PANTALLA_COMPENDIO;
        animandoCompendio = true;
        progresoCompendio = 0.0;
      } else {
        if (opcion.equals("CONFIGURACION")) {
          pantallaOrigenPausa = estadoPantalla;
          abiertoDesdePausa = true;
          estadoPausa = 0;
          estadoPantalla = PANTALLA_OPCIONES;
          animandoOpciones = true;
          progresoOpciones = 0.0;
        } else {
          if (opcion.equals("SALIR AL MENU")) {
            if (modoFeriaActivo) {
              if (feriaPuntaje > 0) registrarResultadoPartidaFeria();
            } else if (!modoExposicionActivo) {
              guardarPartidaActual();
            }
            estadoPausa = 0;
            actualizarVolumenesAudio();
            iniciarTransicionMenu();
          } else {
            if (opcion.equals("SALIR AL ESCRITORIO")) {
              animandoTVOff = true;
              progresoTV = 0.0;
            }
          }
        }
      }
    }
  }
}

boolean mouseSobreCartaPausa(int i, float mx, float my) {
  float progreso = progresoCartaPausa[i];
  float flote = sin(frameCount * 0.02 + faseFlotePausa[i]) * progreso;
  float cx = posXFinalPausa[i] + flote * 4.0;
  float cy = posYFinalPausa[i] + flote * 3.0;
  float rot = rotFinalPausa[i] + flote * 0.02;

  float dx = mx - cx;
  float dy = my - cy;
  float ca = cos(-rot);
  float sa = sin(-rot);
  float lx = dx * ca - dy * sa;
  float ly = dx * sa + dy * ca;

  return abs(lx) <= anchoCartaPausa / 2 && abs(ly) <= altoCartaPausa / 2;
}

void detectarHoverCartasPausa() {
  if (posXFinalPausa == null || posYFinalPausa == null) return;
  if (estadoPausa == 2 && !animandoTVOff) {
    int nuevoHover = -1;
    for (int i = numOpcionesPausa - 1; i >= 0; i--) {
      if (mouseSobreCartaPausa(i, mouseX, mouseY)) {
        nuevoHover = i;
        break;
      }
    }
    if (nuevoHover != cartaHoverPausa) {
      if (nuevoHover >= 0 && nuevoHover < numOpcionesPausa && nuevoHover != seleccionPausa) {
        seleccionPausa = nuevoHover;
        reproducirSFX(sonidoPausaHover, multSfxPausa);
      }
      cartaHoverPausa = nuevoHover;
    }
    if (cartaHoverPausa != -1) {
      cursorSobreElementoClicable = true;
    }
  }

  for (int i = 0; i < numOpcionesPausa; i++) {
    boolean seleccionada = (estadoPausa == 2 && (cartaHoverPausa == i || (cartaHoverPausa == -1 && seleccionPausa == i)));
    desplazamientoYPausa[i] = lerp(desplazamientoYPausa[i], seleccionada ? -5.0 : 0.0, 0.15);
    desplazamientoXPausa[i] = lerp(desplazamientoXPausa[i], seleccionada ? -50.0 : 0.0, 0.15);
    hoverElapsedPausa[i] = seleccionada ? hoverElapsedPausa[i] + 1 : 0;
  }
}

void dibujarMenuPausa() {
  pushMatrix();
  if (shakePausa > 0.05) {
    translate(random(-shakePausa, shakePausa), random(-shakePausa, shakePausa));
    shakePausa *= 0.85;
  }

  dibujarPanelTituloPausa();
  for (int i = 0; i < numOpcionesPausa; i++) { dibujarTarjetaPausa(i); }
  dibujarPanelPuntuacionPausa();
  popMatrix();
}

void dibujarPanelTituloPausa() {
  if (progresoTituloPausa <= 0.001) return;
  pushStyle();
  pushMatrix();
  float factorSlide = easeOutBack(progresoTituloPausa);
  translate(130, lerp(height + 600, height / 2.0 - 45, factorSlide));
  rotate(radians(-4));

  if (fuenteTituloPausa != null) {
    textFont(fuenteTituloPausa);
    char[] letras = {'P', 'A', 'U', 'S', 'A'};
    float[] tamanios = {250, 268, 235, 208, 215};
    float[] offY = {-330, -150, 0, 185, 380};

    for (int k = 0; k < 5; k++) {
      pushMatrix();
      translate(0, offY[k] + sin(frameCount * 0.04 + k * 1.2) * 6.0);
      fill(colBlancoPausa, 255 * progresoTituloPausa);
      textSize(tamanios[k]);
      text(letras[k], 0, 0);
      popMatrix();
    }
  }
  popMatrix();
  popStyle();
}

void dibujarPanelPuntuacionPausa() {
  pushStyle();
  if (fuenteMenuPausa != null) textFont(fuenteMenuPausa);
  float pAncho = 320, pAlto = 110, pX = width - pAncho - 60, pY = 40;
  float alphaPuntos = 255 * progresoTituloPausa;

  noStroke();
  fill(colNegroPausa, alphaPuntos);
  rect(pX, pY, pAncho, pAlto);

  fill(colVerdePausa, alphaPuntos);
  textSize(18);
  text("PUNTUACION", pX + 20, pY + 16);
  fill(colBlancoPausa, alphaPuntos);
  textAlign(RIGHT, BOTTOM);
  textSize(36);
  text(modoFeriaActivo ? str(feriaPuntaje) : "0", pX + pAncho - 20, pY + pAlto - 18);
  popStyle();
}

void dibujarTarjetaPausa(int i) {
  if (i < 0 || i >= numOpcionesPausa) return;
  pushMatrix();
  pushStyle();
  if (fuenteMenuPausa != null) textFont(fuenteMenuPausa);

  float progreso = progresoCartaPausa[i];
  float factor = (estadoPausa == 3) ? easeInBack(progreso) : easeOutBack(progreso);

  float x = lerp(posXFinalPausa[i] + width * 0.5, posXFinalPausa[i], factor);
  float y = lerp(posYFinalPausa[i] - 50, posYFinalPausa[i], factor);
  float alpha = 255 * constrain(factor * 1.4, 0, 1);

  x += desplazamientoXPausa[i];
  y += desplazamientoYPausa[i];

  boolean seleccionada = (estadoPausa == 2 && (cartaHoverPausa == i || (cartaHoverPausa == -1 && seleccionPausa == i)));

  translate(x, y);
  rotate(rotFinalPausa[i]);
  scale(lerp(0.35, 1.0, factor));

  noStroke();
  fill(seleccionada ? colBlancoPausa : colVerdePausa, alpha);
  dibujarFormaAngularPausa(anchoCartaPausa, altoCartaPausa, 16);

  fill(colNegroPausa, alpha);
  textAlign(LEFT, CENTER);
  textSize(25);
  text(opcionesPausa[i], -anchoCartaPausa / 2 + 24, 0);

  popStyle();
  popMatrix();
}

void dibujarFormaAngularPausa(float w, float h, float corte) {
  float hw = w / 2.0, hh = h / 2.0;
  beginShape();
  vertex(-hw + corte, -hh);
  vertex(hw, -hh);
  vertex(hw, hh - corte);
  vertex(hw - corte, hh);
  vertex(-hw, hh);
  vertex(-hw, -hh + corte);
  endShape(CLOSE);
}

float pulsoElastico(float t, float frecuencia, float decaimiento) {
  return sin(t * frecuencia) * exp(-t * decaimiento);
}
