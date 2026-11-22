import processing.sound.*;

SoundFile musicaMenu;
SoundFile sonidoTap;
SoundFile sonidoCursorClick1;
SoundFile sonidoCursorClick2;
SoundFile sonidoDialogoIn;
SoundFile sonidoLogro;
SoundFile sonidoEscritura;
SoundFile sonidoAbsorcionVortice;
SoundFile sonidoGeneracionBurn;
SoundFile sonidoTransferenciaExitosa;
SoundFile sonidoAbsorcionTransicionVortice;
SoundFile sonidoDisrupcion1;
SoundFile sonidoDisrupcion2;
SoundFile sonidoPopupError;
SoundFile sonidoNexusCargarBarra;
SoundFile sonidoEstaticaTituloDolus;
SoundFile sonidoDecisionCorrecta;
SoundFile sonidoErrorMsj;
SoundFile musicaGameplayInicial;
SoundFile musicaGameplayIntenso;
SoundFile stingerTransicion;
SoundFile sonidoHerramientaUso;
SoundFile sonidoNotificacionOscura;
SoundFile sonidoGlitchFuerte;
SoundFile musicaJefeAdmin;
SoundFile musicaJefeCamara;
SoundFile musicaJefeDesinformacion;
SoundFile musicaJefeTendencia;
SoundFile sonidoCursorHover;
SoundFile sonidoVozDialogo;
SoundFile sonidoLightningStrike;
SoundFile sonidoLightningLoop;
SoundFile musicaCredits;
PImage imgDificultad1;
PImage imgDificultad2;
PFont fuenteRetro;
PFont fuenteTitulo;
PImage imgAdminIcon;
PImage imgArrowUpgrade;

final int PANTALLA_MENU = 0;
final int PANTALLA_OPCIONES = 2;
final int PANTALLA_CREDITOS = 3;
final int PANTALLA_DIFICULTAD = 5;
final int PANTALLA_TRANSICION = 6;
final int PANTALLA_CARGA = 7;
final int PANTALLA_JUEGO = 8;
final int PANTALLA_TIENDA = 9;
final int PANTALLA_GAMEOVER = 10;
final int PANTALLA_TRANSICION_JEFE = 11;
final int PANTALLA_CINEMATICA_FINAL = 13;
final int PANTALLA_HABITACION = 14;
final int PANTALLA_SLOTS = 15;
final int PANTALLA_GLITCH_ESCAPE = 16;
final int PANTALLA_MODO_FERIA = 17;

int estadoPantalla = PANTALLA_MENU;

float ztiempo = 0.0;
float ztiempoMarco = 0.0;
float anguloFlotante = 0;

float intensidadSuccionFondo = 0.0;

float progresoEntrada = 0.0;
boolean animandoEntrada = true;

boolean animandoOpciones = false;
float progresoOpciones = 0.0;

boolean animandoCreditos = false;
float progresoCreditos = 0.0;

boolean animandoDificultad = false;
float progresoDificultad = 0.0;

boolean animandoTVOff = false;
float progresoTV = 0.0;

float volumenMaestro = 1.0;
float volumenMusica = 0.8;
float volumenSFX = 0.8;

int sliderActivo = 0;
boolean arrastrandoSlider = false;

boolean efectosCRTActivos = true;

int modoDaltonismo = 0;
boolean menuDaltonismoAbierto = false;

boolean modoDesarrollador = false;
String textoTituloCompleto = "DOLUS";
int caracteresVisibles = 0;
int ultimoTiempoEscritura = 0;
int intervaloEscritura = 180;

int ultimoTiempoSonidoTeclado = 0;
int intervaloSonidoMs = 180;
int offsetAdelantoAudio = 180;

int ultimoTiempoSonidoTap = 0;
int intervaloMinimoTap = 90;

boolean glitchActivo = false;
int tiempoInicioGlitch = 0;
int duracionGlitch = 0;
int ultimoIntentoGlitch = 0;
String textoGlitcheado = "DOLUS";

boolean succionando = false;
float progresoSuccion = 0.0;

boolean quemandoDificultad = false;
float progresoQuemarDificultad = 0.0;

boolean seleccionadoParaJugar = false;
int dificultadSeleccionadaPendiente = 1;

boolean escupiendoMenu = false;
float progresoEscupidoMenu = 0.0;

boolean mostrandoSplash = true;
int marcaTiempoSplash = 0;
int duracionSostenerSplash = 2400;
int duracionDesvanecerSplash = 700;
String nombreEquipoDesarrollo = "Blacklist";

boolean sonidoEstaticaTituloReproducido = false;

boolean teclaSaltarEscenaPresionada = false;
float progresoHoldSaltoEscena = 0.0;
int ultimoSaltoEscenaMs = -5000;

void setup() {

  fullScreen();
  noStroke();
  cursor();

  luy_cargarImagenesYFuentes();
  inicializarCursorPersonalizado();
  inicializarSistemaGuardado();
  inicializarSistemaModoFeria();

  marcaTiempoSplash = millis();

  musicaMenu = cargarSonido("musicamenuprincipal.mp3");
  if (musicaMenu == null) musicaMenu = cargarSonido("musicamenuprincipal.wav");
  if (musicaMenu != null) {
    musicaMenu.loop();
    actualizarVolumenesAudio();
  }

  sonidoHerramientaUso = cargarSonido("sonido_herramienta_uso.mp3");
  sonidoNotificacionOscura = cargarSonido("sonido_notificacion_oscura.mp3");
  sonidoGlitchFuerte = cargarSonido("sonido_glitch_fuerte.mp3");
  musicaJefeAdmin = cargarSonido("musica_jefe_admin.mp3");
  musicaJefeCamara = cargarSonido("musica_jefe_camara.mp3");
  musicaJefeDesinformacion = cargarSonido("musica_jefe_desinformacion.mp3");
  musicaJefeTendencia = cargarSonido("musica_jefe_tendencia.mp3");
  sonidoCursorHover                     = cargarSonido("cursor_hover.wav");
  if (sonidoCursorHover == null) sonidoCursorHover = cargarSonido("cursor_hover.ogg");
  sonidoVozDialogo                      = cargarSonido("vozpjs.wav");
  if (sonidoVozDialogo == null) sonidoVozDialogo = cargarSonido("vozpjs.ogg");
  sonidoTap                             = cargarSonido("tapboton.mp3");
  sonidoCursorClick1                    = cargarSonido("cursor_click.wav");
  sonidoCursorClick2                    = cargarSonido("cursor_click2.wav");
  sonidoDialogoIn                       = cargarSonido("dialog_in.wav");
  sonidoLogro                           = cargarSonido("achievement.mp3");
  sonidoEscritura                    = cargarSonido("escritura.mp3");
  sonidoAbsorcionVortice             = cargarSonido("absorcionvortice.mp3");
  sonidoGeneracionBurn               = cargarSonido("generacionburn.mp3");
  sonidoAbsorcionTransicionVortice = cargarSonido("absorciontransicionvortic.mp3");
  sonidoTransferenciaExitosa         = cargarSonido("transferenciaexitosa.mp3");
  sonidoDisrupcion1                  = cargarSonido("disrupcion1.mp3");
  sonidoDisrupcion2                  = cargarSonido("disrupcion2.mp3");
  sonidoPopupError                   = cargarSonido("popuperror.mp3");
  sonidoNexusCargarBarra             = cargarSonido("nexuscargarbarra.mp3");
  sonidoEstaticaTituloDolus          = cargarSonido("estaticatitulodolus.mp3");
  sonidoDecisionCorrecta             = cargarSonido("decisioncorrectamsj.mp3");
  sonidoErrorMsj                     = cargarSonido("sonidoerrormsj.mp3");
  musicaGameplayInicial              = cargarSonido("musicagameplayinicial.mp3");
  musicaGameplayIntenso              = cargarSonido("musicagameplayintenso.mp3");
  stingerTransicion                  = cargarSonido("stingertransicion.mp3");
  sonidoLightningStrike              = cargarSonido("lightningstrike.wav");
  sonidoLightningLoop                = cargarSonido("lightningsound.wav");
  musicaCredits                      = cargarSonido("credits_song.mp3");

  precargarRecursosPluginsYAudio();

  reproducirSFX(sonidoGeneracionBurn);
  inicializarPausa();
}

PImage imgJefeTendencia;
PImage imgJefeCamaraEco;
PImage imgJefeDesinformacion;
PImage imgJefeAlgoritmo;

PImage imgStatSaludMental;
PImage imgStatSeguridad;
PImage imgStatReputacion;
PImage imgStatPopularidad;
PImage imgLogroIcono;

PImage sheetSellosTags = null;
PImage sheetArchivosTags = null;
PImage[] imgSellosTags = new PImage[6];
PImage[] imgArchivosTags = new PImage[6];
PImage[] imgSellosCrisp = new PImage[6];
PImage[] imgArchivosCrisp = new PImage[6];
boolean tagsPrecargados = false;

PImage preEscalarMax(PImage img, int maxW, int maxH) {
  if (img == null || img.width <= 0 || img.height <= 0) return img;
  if (img.width <= maxW && img.height <= maxH) return img;
  float ratio = min(float(maxW) / img.width, float(maxH) / img.height);
  img.resize(max(1, int(img.width * ratio)), max(1, int(img.height * ratio)));
  return img;
}

void luy_cargarImagenesYFuentes() {
  imgDificultad1 = cargarImagenSegura("dificultad1.png");
  imgDificultad2 = cargarImagenSegura("dificultad2.png");
  imgAdminIcon = preEscalarMax(cargarImagenSegura("iconoadmin.png"), 420, 560);

  imgJefeTendencia = preEscalarMax(cargarImagenSegura("jefe_tendencia.png"), 300, 395);
  imgJefeCamaraEco = preEscalarMax(cargarImagenSegura("jefe_camara.png"), 300, 395);
  imgJefeDesinformacion = preEscalarMax(cargarImagenSegura("jefe_desinformacion.png"), 300, 395);
  imgJefeAlgoritmo = preEscalarMax(cargarImagenSegura("jefe_algoritmo.png"), 300, 395);
  imgCursorBase = prepararCursor32(cargarImagenSegura("cursor.png"));
  imgCursorDedo = prepararCursor32(cargarImagenSegura("cursor_dedo.png"));

  imgStatSaludMental = cargarImagenSegura("stat_saludmental.png");
  imgStatSeguridad = cargarImagenSegura("stat_seguridad.png");
  imgStatReputacion = cargarImagenSegura("stat_reputacion.png");
  imgStatPopularidad = cargarImagenSegura("stat_popularidad.png");
  imgArrowUpgrade = preEscalarMax(cargarImagenSegura("arrowupgrade.png"), 128, 128);
  imgLogroIcono = cargarImagenSegura("achievements_icon.png");

  fuenteRetro = createFont("fuentep.otf", 20);
  fuenteTitulo = createFont("fuentetitulo.otf", 135);
  textFont(fuenteRetro);

  precargarSpritesTags();
  precargarRecursosEpilogo();
}

void precargarSpritesTags() {
  if (tagsPrecargados) return;
  sheetSellosTags = cargarImagenSegura("sellos_tags.png");
  sheetArchivosTags = cargarImagenSegura("archivos_tags.png");
  final int T_SZ = 34;
  for (int i = 0; i < 6; i++) {
    int sx = i * T_SZ;
    if (sheetSellosTags != null && sx + T_SZ <= sheetSellosTags.width) {
      PImage rawS = sheetSellosTags.get(sx, 0, T_SZ, T_SZ);
      imgSellosTags[i] = rawS;
      imgSellosCrisp[i] = (rawS != null) ? escalarPixelArtCrisp(rawS, T_SZ * 2, T_SZ * 2) : null;
    }
    if (sheetArchivosTags != null && sx + T_SZ <= sheetArchivosTags.width) {
      PImage rawA = sheetArchivosTags.get(sx, 0, T_SZ, T_SZ);
      imgArchivosTags[i] = rawA;
      imgArchivosCrisp[i] = (rawA != null) ? escalarPixelArtCrisp(rawA, T_SZ * 2, T_SZ * 2) : null;
    }
  }
  tagsPrecargados = true;
  println("[Tags] Spritesheets sellos_tags y archivos_tags precargadas exitosamente (100% crisp).");
}

void draw() {
  cursorSobreElementoClicable = arrastrandoSlider;
  if (pausaActiva()) {
    actualizarYDibujarPausa();
    actualizarYDibujarCompuertas();

    dibujarPostProcesadoProfesional();
    actualizarCursorPersonalizado();
    return;
  }
  ztiempo += 0.008;
  ztiempoMarco += 0.020;

  boolean debeDibujarFondo = true;
  if (estadoPantalla == PANTALLA_TRANSICION || estadoPantalla == PANTALLA_CARGA || estadoPantalla == PANTALLA_JUEGO ||
      estadoPantalla == PANTALLA_TIENDA || estadoPantalla == PANTALLA_GAMEOVER || estadoPantalla == PANTALLA_TRANSICION_JEFE ||
      estadoPantalla == PANTALLA_CINEMATICA_FINAL || estadoPantalla == PANTALLA_HABITACION || estadoPantalla == PANTALLA_MODO_FERIA) {
    if (!ejecutandoCargaNexus && !ejecutandoPantallaCargaMeta) {
      debeDibujarFondo = false;
    }
  }

  if (debeDibujarFondo) {
    dibujarFondoEnmarcadoFluido();
  }

  if (ejecutandoLinkStart) {
    actualizarYDibujarTransicion();
  }

  if (estadoPantalla == PANTALLA_MENU) {
    if (!pausaActiva() && !succionando && !animandoTVOff && !ejecutandoLinkStart && !mostrandoSplash) {
      if (musicaMenu != null && !musicaMenu.isPlaying()) {
        reproducirMusicaUnica(musicaMenu);
      }
    }
    float escalaX = 1.0;
    float escalaY = 1.0;
    float rotUI = 0.0;

    if (succionando) {
      progresoSuccion += 0.028;
      if (progresoSuccion >= 1.0) {
        progresoSuccion = 1.0;
        succionando = false;
        refrescarRanurasGuardado();
        estadoPantalla = PANTALLA_SLOTS;
      }
      float pIn = pow(progresoSuccion, 3.5);
      escalaX = max(0.001, 1.0 - pIn * 1.2);
      escalaY = max(0.001, 1.0 - pIn * 1.4);
    }

    else {
      if (escupiendoMenu) {
        progresoEscupidoMenu += 0.025;
        if (progresoEscupidoMenu >= 1.0) {
          progresoEscupidoMenu = 1.0;
          escupiendoMenu = false;
        }
        float pOut = progresoEscupidoMenu;

        float factorRebote = 1.0 + 0.32 * sin(pOut * PI * 2.8) * exp(-pOut * 4.0);
        if (progresoEscupidoMenu >= 1.0) factorRebote = 1.0;

        escalaX = (0.01 + pOut * 0.99) * factorRebote;
        escalaY = escalaX;
      }
    }

    pushMatrix();
    translate(width / 2.0, height / 2.0);
    rotate(rotUI);
    scale(escalaX, escalaY);
    translate(-width / 2.0, -height / 2.0);
    dibujarMenuPrincipal();
    popMatrix();

    dibujarMetaJuegoSuperpuesto();
  }

  if (estadoPantalla == PANTALLA_OPCIONES) {
    if (abiertoDesdePausa && fondoPausa != null) {
      pushStyle();
      imageMode(CORNER);
      image(fondoPausa, 0, 0, width, height);
      noStroke();
      fill(0, 150);
      rect(0, 0, width, height);
      popStyle();
    }
    dibujarVentanaOpcionesSuperpuesta();
  } else {
    if (estadoPantalla == PANTALLA_CREDITOS) {
      dibujarVentanaCreditosSuperpuesta();
    } else {
      if (estadoPantalla == PANTALLA_COMPENDIO) {
        if (abiertoCompendioDesdePausa && fondoPausa != null) {
          pushStyle();
          imageMode(CORNER);
          image(fondoPausa, 0, 0, width, height);
          noStroke();
          fill(0, 150);
          rect(0, 0, width, height);
          popStyle();
        }
        dibujarVentanaCompendioSuperpuesta();
      } else {
        if (estadoPantalla == PANTALLA_DIFICULTAD) {
          if (quemandoDificultad) {
            progresoQuemarDificultad += 0.038;
            if (progresoQuemarDificultad >= 1.0) {
              progresoQuemarDificultad = 1.0;
              quemandoDificultad = false;

              if (seleccionadoParaJugar) {
                inicializarJuego(dificultadSeleccionadaPendiente);
                aplicarBonusRocioSiActivo();
                guardarPartidaActual();
                iniciarTransicionLinkStart();
              } else {
                refrescarRanurasGuardado();
                estadoPantalla = PANTALLA_SLOTS;
                progresoSuccion = 0.0;
              }
            }
          }
          if (progresoQuemarDificultad < 1.0) {
            dibujarVentanaDificultadSuperpuesta();
          }
        } else {
          if (estadoPantalla == PANTALLA_SLOTS) {
            actualizarYDibujarPantallaSlots();
          } else if (estadoPantalla == PANTALLA_MODO_FERIA) {
            actualizarYDibujarPantallaModoFeria();
          } else {
            if (estadoPantalla == PANTALLA_TRANSICION || estadoPantalla == PANTALLA_CARGA || estadoPantalla == PANTALLA_JUEGO || estadoPantalla == PANTALLA_TIENDA || estadoPantalla == PANTALLA_GAMEOVER || estadoPantalla == PANTALLA_TRANSICION_JEFE || estadoPantalla == PANTALLA_CINEMATICA_FINAL || estadoPantalla == PANTALLA_HABITACION || estadoPantalla == PANTALLA_GLITCH_ESCAPE) {
              if (ejecutandoCargaNexus) {
                actualizarYDibujarCargaNexus();
              } else {
                if (ejecutandoPantallaCargaMeta) {
                  actualizarYDibujarPantallaCargaMeta();
                } else {
                  if (estadoPantalla == PANTALLA_JUEGO) {
                    actualizarYDibujarInterfazJuego();
                  } else {
                    if (estadoPantalla == PANTALLA_TIENDA) {
                      actualizarYDibujarTienda();
                    } else {
                      if (estadoPantalla == PANTALLA_GAMEOVER) {
                        actualizarYDibujarGameOver();
                      } else {
                        if (estadoPantalla == PANTALLA_TRANSICION_JEFE) {
                          actualizarYDibujarCargaJefe();
                        } else {
                          if (estadoPantalla == PANTALLA_GLITCH_ESCAPE) {
                            actualizarYDibujarGlitchEscape();
                          } else {
                            if (estadoPantalla == PANTALLA_CINEMATICA_FINAL) {
                              actualizarYDibujarCinematicaFinalVR();
                            } else {
                              if (estadoPantalla == PANTALLA_HABITACION) {
                                actualizarYDibujarHabitacionFinal();
                              } else {
                                actualizarYDibujarJuego();
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }

  if (animandoTVOff) {
    dibujarEfectoTVOff();
  }

  if (mostrandoSplash) {
    dibujarPantallaCarga();
  } else {
    if (estadoPantalla != 6 && estadoPantalla != 7 && estadoPantalla != 8 && estadoPantalla != PANTALLA_CINEMATICA_FINAL && estadoPantalla != PANTALLA_HABITACION && estadoPantalla != PANTALLA_MODO_FERIA) {
      dibujarVersionEarlyAccess(255);
    }
  }
  revisarSolicitudPausa();

  dibujarPostProcesadoProfesional();

  actualizarYDibujarCompuertas();
  if (estadoPantalla != PANTALLA_JUEGO && estadoPantalla != PANTALLA_TIENDA && estadoPantalla != PANTALLA_CINEMATICA_FINAL && estadoPantalla != PANTALLA_HABITACION && estadoPantalla != PANTALLA_GLITCH_ESCAPE) {
    actualizarYDibujarFlourishLayer();
  }
  actualizarYDibujarToastLogro();
  actualizarYDibujarSaltoEscenas();

  if (modoDesarrollador) {
    dibujarModoDesarrollador();
  }
  actualizarCursorPersonalizado();
  actualizarAtenuacionMusicaTransicion();
  actualizarAudioRayoContinuo();
}

boolean escenaActualEsSaltable() {
  if (pausaActiva() || estadoTransicionMenu != 0) return false;
  if (mostrandoSplash) return true;
  if (estadoPantalla == PANTALLA_MENU && metaMensajePendiente) return true;
  if (ejecutandoLinkStart || ejecutandoCargaNexus || ejecutandoPantallaCargaMeta) return true;
  if (estadoPantalla == PANTALLA_TRANSICION_JEFE) return true;
  if (estadoPantalla == PANTALLA_TRANSICION && !fasePluginsActiva && (dialogoAbierto || animandoAparicionChat)) return true;
  if (estadoPantalla == PANTALLA_JUEGO && (mostrandoTutorial || mostrandoTutorialIngame || animandoShowcaseDirectiva || estadoTransicionJefe || (rondaCompletada && !animandoSalidaLiquidacion))) return true;
  if (estadoPantalla == PANTALLA_GLITCH_ESCAPE) return true;
  if (estadoPantalla == PANTALLA_CINEMATICA_FINAL) return true;
  if (estadoPantalla == PANTALLA_HABITACION && epEscenaHabitacionEsSaltable()) return true;
  return false;
}

void ejecutarSaltoEscenaActual() {
  ultimoSaltoEscenaMs = millis();

  if (mostrandoSplash) {
    mostrandoSplash = false;
    if (musicaMenu != null && !musicaMenu.isPlaying()) reproducirMusicaUnica(musicaMenu);
    return;
  }
  if (estadoPantalla == PANTALLA_MENU && metaMensajePendiente) {
    metaMensajePendiente = false;
    return;
  }
  if (ejecutandoLinkStart) {
    ejecutandoLinkStart = false;
    progresoLinkStart = 0.0;
    intensidadSuccionFondo = 0.0;
    estadoPantalla = PANTALLA_TRANSICION;
    iniciarCargaNexus();
    return;
  }
  if (ejecutandoCargaNexus) {
    if (sonidoEscritura != null) sonidoEscritura.stop();
    detenerPistaSiSuena(sonidoNexusCargarBarra, null);
    ejecutandoCargaNexus = false;
    ejecutandoPantallaCargaMeta = true;
    tiempoInicioCargaMeta = millis();
    alphaPantallaCargaMeta = 1.0;
    return;
  }
  if (ejecutandoPantallaCargaMeta) {
    if (!pluginsPrecargadosMeta) {
      inicializarSistemaPlugins();
      pluginsPrecargadosMeta = true;
    }
    ejecutandoPantallaCargaMeta = false;
    tiempoInicioCargaMeta = 0;
    fasePluginsActiva = false;
    estadoPantalla = PANTALLA_TRANSICION;
    abrirDialogoAdmin(0);
    return;
  }
  if (estadoPantalla == PANTALLA_TRANSICION_JEFE) {
    saltarAdvertenciaJefe();
    return;
  }
  if (estadoPantalla == PANTALLA_TRANSICION && !fasePluginsActiva) {
    animandoAparicionChat = false;
    progresoAparicionChat = 1.0;
    alphaAparicionJimbo = 1.0;
    if (!dialogoAbierto) abrirDialogoAdmin(0);
    if (mensajeActualDialogo != null) {
      caracteresVisiblesDialogo = mensajeActualDialogo.length();
    }
    detenerVozDialogo();
    seleccionarOpcionAdmin(0);
    return;
  }
  if (estadoPantalla == PANTALLA_JUEGO) {
    if (mostrandoTutorial) {
      terminarTutorial();
    } else {
      if (mostrandoTutorialIngame) {
        mostrandoTutorialIngame = false;
      } else {
        if (animandoShowcaseDirectiva) {
          saltarShowcaseDirectiva();
          frameShowcaseSalida = 19;
        } else {
          if (estadoTransicionJefe) {
            timerTransicionJefe = 1;
          } else {
            if (rondaCompletada && !animandoSalidaLiquidacion) {
              timerTransicionTienda = max(timerTransicionTienda, FRAMES_FIN_LIQUIDACION);
              confirmarLiquidacionRonda();
            }
          }
        }
      }
    }
    return;
  }
  if (estadoPantalla == PANTALLA_GLITCH_ESCAPE) {
    iniciarCinematicaFinalVR();
    return;
  }
  if (estadoPantalla == PANTALLA_CINEMATICA_FINAL) {
    epCinSalidaDisparada = true;
    epCinFadeSalida = 1.0;
    iniciarHabitacionFinal();
    return;
  }
  if (estadoPantalla == PANTALLA_HABITACION) {
    epSaltarEscenaHabitacion();
  }
}

void actualizarYDibujarSaltoEscenas() {
  if (!keyPressed) {
    teclaSaltarEscenaPresionada = false;
  }

  boolean saltable = escenaActualEsSaltable();
  if (!saltable) {
    progresoHoldSaltoEscena = max(0.0, progresoHoldSaltoEscena - 0.12);
    return;
  }

  if (teclaSaltarEscenaPresionada) {
    progresoHoldSaltoEscena = min(1.0, progresoHoldSaltoEscena + 0.055);
    if (progresoHoldSaltoEscena >= 1.0 && millis() - ultimoSaltoEscenaMs >= 180) {
      reproducirTap();
      ejecutarSaltoEscenaActual();
    }
  } else {
    progresoHoldSaltoEscena = max(0.0, progresoHoldSaltoEscena - 0.08);
  }

  pushStyle();
  float pillW = 248;
  float pillH = 34;
  float px = width - pillW - 18;
  float py = 16;
  rectMode(CORNER);
  fill(6, 12, 18, 215);
  stroke(teclaSaltarEscenaPresionada ? color(95, 255, 175) : color(110, 170, 210, 175));
  strokeWeight(1.8);
  rect(px, py, pillW, pillH, 7);

  if (progresoHoldSaltoEscena > 0.01) {
    noStroke();
    fill(65, 255, 165, 95);
    rect(px + 3, py + 3, (pillW - 6) * progresoHoldSaltoEscena, pillH - 6, 5);
  }

  if (fuenteRetro != null) textFont(fuenteRetro);
  textAlign(CENTER, CENTER);
  textSize(12);
  fill(teclaSaltarEscenaPresionada ? color(175, 255, 210) : color(205, 225, 240));
  text("MANTENER [F] SALTAR ESCENA", px + pillW * 0.5, py + pillH * 0.5 - 1);
  popStyle();
}

void dibujarVersionEarlyAccess(float alphaVal) {
  if (estadoPantalla == PANTALLA_TIENDA) return;
  pushStyle();
  if (fuenteRetro != null) textFont(fuenteRetro);
  textAlign(RIGHT, BOTTOM);
  textSize(12);
  fill(120, 180, 150, alphaVal * 0.50);
  text("EARLY ACCESS BUILD V1.0", width - 25, height - 12);
  popStyle();
}

void dibujarPantallaCarga() {
  pushStyle();
  int tiempoTranscurrido = millis() - marcaTiempoSplash;
  float alphaSplash = 255;

  if (tiempoTranscurrido < duracionSostenerSplash) {
    alphaSplash = 255;
  } else {
    if (tiempoTranscurrido < duracionSostenerSplash + duracionDesvanecerSplash) {
      alphaSplash = map(tiempoTranscurrido, duracionSostenerSplash, duracionSostenerSplash + duracionDesvanecerSplash, 255, 0);
    } else {
      alphaSplash = 0;
      mostrandoSplash = false;
      if (musicaMenu != null && !musicaMenu.isPlaying()) {
        reproducirMusicaUnica(musicaMenu);
      }

      ultimoTiempoEscritura = millis();
      ultimoTiempoSonidoTeclado = millis();
    }
  }

  rectMode(CORNER);
  noStroke();
  fill(0, alphaSplash);
  rect(0, 0, width, height);

  textAlign(CENTER, CENTER);
  if (fuenteRetro != null) textFont(fuenteRetro);

  fill(200, 220, 210, alphaSplash);
  textSize(28);
  text("UN JUEGO DESARROLLADO POR:", width / 2, height * 0.20);

  fill(255, alphaSplash);
  textSize(42);
  text(nombreEquipoDesarrollo, width / 2, height * 0.28);

  fill(230, 60, 60, alphaSplash);
  textSize(36);
  text("ADVERTENCIA", width / 2, height * 0.46);

  fill(220, 220, 220, alphaSplash);
  textSize(22);
  text("ESTE JUEGO CONTIENE LUCES INTERMITENTES, EFECTOS DE ESTATICA\nY GLITCH QUE PODRIAN AFECTAR A PERSONAS FOTOSENSIBLES O CON EPILEPSIA.\nSE RECOMIENDA PRECAUCION AL JUGAR.", width / 2, height * 0.56);

  int numPuntos = (millis() / 400) % 4;
  String puntosAnimados = "";
  for (int i = 0; i < numPuntos; i++) {
    puntosAnimados += ".";
  }

  textAlign(RIGHT, BOTTOM);
  fill(80, 255, 160, alphaSplash);
  textSize(26);
  text("CARGANDO" + puntosAnimados, width - 50, height - 50);

  dibujarVersionEarlyAccess(alphaSplash);

  popStyle();
}

void dibujarVentanaCreditosSuperpuesta() {
  if (animandoCreditos) {
    progresoCreditos += 0.03;
    if (progresoCreditos >= 1.0) {
      progresoCreditos = 1.0;
      animandoCreditos = false;
    }
  }

  pushStyle();
  fill(0, 180 * progresoCreditos);
  rectMode(CORNER);
  rect(0, 0, width, height);

  pushMatrix();
  translate(width / 2, height / 2);

  float anchoPanelCreditos = 1100;
  float altoPanelCreditos = 680;
  float grosorBorde = 14;

  dibujarInteriorCajaDisuelta(anchoPanelCreditos, altoPanelCreditos, progresoCreditos);
  dibujarMarcoProcedural(anchoPanelCreditos, altoPanelCreditos, grosorBorde, progresoCreditos);

  if (fuenteRetro != null) textFont(fuenteRetro);
  textAlign(CENTER, CENTER);
  textSize(32);

  color colEncabezado = colorTema();
  fillConAlpha(colEncabezado, 255 * progresoCreditos);
  text("CREDITOS", 0, -altoPanelCreditos / 2 + 45);

  dibujarBotonCerrar(anchoPanelCreditos, altoPanelCreditos, progresoCreditos);

  if (progresoCreditos > 0.3) {
    textAlign(CENTER, CENTER);

    fill(200, 230, 215, 255 * progresoCreditos);
    textSize(22);
    text("Un juego desarrollado por Blacklist", 0, -180);

    fillConAlpha(colEncabezado, 255 * progresoCreditos);
    textSize(26);
    text("INTEGRANTES", 0, -110);

    fill(240, 240, 240, 255 * progresoCreditos);
    textSize(20);
    float yInicioNombres = -50;
    float espacioNombres = 42;

    text("- Daniel Miranda Gomez", 0, yInicioNombres);
    text("- Luyheer Duran Florez", 0, yInicioNombres + espacioNombres);
    text("- Gabriel Castro Lopez", 0, yInicioNombres + (espacioNombres * 2));
    text("- Necer Perez Martinez", 0, yInicioNombres + (espacioNombres * 3));
  }

  popMatrix();
  popStyle();
}

void dibujarVentanaOpcionesSuperpuesta() {
  if (animandoOpciones) {
    progresoOpciones += 0.03;
    if (progresoOpciones >= 1.0) {
      progresoOpciones = 1.0;
      animandoOpciones = false;
    }
  }

  pushStyle();
  fill(0, 180 * progresoOpciones);
  rectMode(CORNER);
  rect(0, 0, width, height);

  pushMatrix();
  translate(width / 2, height / 2);

  float anchoPanelOpciones = 1100;
  float altoPanelOpciones = 680;
  float grosorBorde = 14;

  dibujarInteriorCajaDisuelta(anchoPanelOpciones, altoPanelOpciones, progresoOpciones);
  dibujarMarcoProcedural(anchoPanelOpciones, altoPanelOpciones, grosorBorde, progresoOpciones);

  if (fuenteRetro != null) textFont(fuenteRetro);
  textAlign(CENTER, CENTER);
  textSize(32);

  color colEncabezado = colorTema();
  fillConAlpha(colEncabezado, 255 * progresoOpciones);
  text("CONFIGURACION", 0, -altoPanelOpciones / 2 + 45);

  dibujarBotonCerrar(anchoPanelOpciones, altoPanelOpciones, progresoOpciones);

  if (progresoOpciones > 0.4) {
    float yInicioSliders = -180;
    float separacionSliders = 55;
    float anchoTrack = 400;
    float xTrack = 210;

    dibujarFilaSlider("VOLUMEN MAESTRO", yInicioSliders, anchoTrack, volumenMaestro, 1, xTrack, colEncabezado);
    dibujarFilaSlider("MUSICA", yInicioSliders + separacionSliders, anchoTrack, volumenMusica, 2, xTrack, colEncabezado);
    dibujarFilaSlider("EFECTOS DE SONIDO (SFX)", yInicioSliders + (separacionSliders * 2), anchoTrack, volumenSFX, 3, xTrack, colEncabezado);

    if (arrastrandoSlider) {
      float xPistaAbsCentro = width / 2 + xTrack;
      float mouseRelativoX = mouseX - xPistaAbsCentro;
      float valNuevo = constrain(map(mouseRelativoX, -anchoTrack / 2, anchoTrack / 2, 0.0, 1.0), 0.0, 1.0);

      if (sliderActivo == 1) volumenMaestro = valNuevo;
      else {
        if (sliderActivo == 2) volumenMusica = valNuevo;
        else {
          if (sliderActivo == 3) volumenSFX = valNuevo;
        }
      }

      actualizarVolumenesAudio();
    }

    float yBotonBase = 35;
    float anchoBDonde = 680;
    float altoBDonde = 45;
    float espacioBotones = 65;

    if (!menuDaltonismoAbierto) {
      dibujarBotonOpcionAlternativa(0, yBotonBase, anchoBDonde, altoBDonde,
        "MODO DALTONISMO: " + obtenerTextoDaltonismo(), colEncabezado, 101);

      dibujarBotonOpcionAlternativa(0, yBotonBase + espacioBotones, anchoBDonde, altoBDonde,
        "EFECTOS CRT / ESTATICA: " + (efectosCRTActivos ? "ACTIVADOS" : "DESACTIVADOS"), colEncabezado, 102);
    } else {
      dibujarBotonOpcionAlternativa(0, yBotonBase, anchoBDonde, altoBDonde,
        "SELECCIONAR MODO DALTONISMO (CLIC PARA CERRAR)", colEncabezado, 101);

      String[] opcionesDalt = { "NO", "PROTANOPIA (ROJO)", "DEUTERANOPIA (VERDE)", "TRITANOPIA (AZUL)" };
      float yInicioDalt = yBotonBase + 60;
      float altoOpt = 42;

      for (int i = 0; i < contarTextos(opcionesDalt); i++) {
        float yOptActual = yInicioDalt + (i * (altoOpt + 6));
        boolean hoverOpt = evaluarHover(width / 2, height / 2 + yOptActual, anchoBDonde, altoOpt);
        boolean presionadoOpt = hoverOpt && mousePressed;

        pushMatrix();
        translate(0, yOptActual);
        if (presionadoOpt) translate(0, 2);
        else {
          if (hoverOpt) scale(1.01);
        }

        boolean seleccionado = (modoDaltonismo == i);
        stroke(seleccionado ? color(255) : (hoverOpt ? color(200) : colEncabezado), 255 * progresoOpciones);
        strokeWeight(seleccionado ? 2 : 1);
        fill(seleccionado ? color(30, 90, 60, 250 * progresoOpciones) : (hoverOpt ? color(15, 50, 35, 230 * progresoOpciones) : color(6, 20, 12, 240 * progresoOpciones)));
        rectMode(CENTER);
        rect(0, 0, anchoBDonde, altoOpt, 6);

        fill(seleccionado ? color(255, 255, 150) : color(240, 240, 240), 255 * progresoOpciones);
        textSize(16);
        text(opcionesDalt[i], 0, -2);
        popMatrix();
      }
    }
  }

  popMatrix();
  popStyle();
}

void dibujarFilaSlider(String etiqueta, float posY, float anchoTrack, float valorActual, int idSlider, float xTrack, color colTema) {
  pushStyle();
  textSize(18);
  textAlign(LEFT, CENTER);
  fill(255, 255 * progresoOpciones);
  text(etiqueta, -480, posY);

  textAlign(LEFT, CENTER);
  int porcentajeVal = Math.round(valorActual * 100);
  fillConAlpha(colTema, 255 * progresoOpciones);
  text(porcentajeVal + "%", xTrack + (anchoTrack / 2) + 20, posY);

  rectMode(CENTER);
  stroke(30, 120, 70, 255 * progresoOpciones);
  strokeWeight(2);
  fill(10, 35, 22, 230 * progresoOpciones);
  rect(xTrack, posY, anchoTrack, 14, 6);

  float posHandleX = xTrack + map(valorActual, 0.0, 1.0, -anchoTrack / 2, anchoTrack / 2);
  float anchoRelleno = posHandleX - (xTrack - anchoTrack / 2);

  noStroke();
  fillConAlpha(colorRellenoSlider(), 255 * progresoOpciones);
  rectMode(CORNER);
  rect(xTrack - anchoTrack / 2, posY - 5, anchoRelleno, 10, 4);

  boolean hoverTrack = evaluarHover(width / 2 + xTrack, height / 2 + posY, anchoTrack + 30, 40);
  boolean hoverHandle = evaluarHover(width / 2 + posHandleX, height / 2 + posY, 26, 36);

  pushMatrix();
  translate(posHandleX, posY);
  if (arrastrandoSlider && sliderActivo == idSlider) translate(0, 2);
  else {
    if (hoverHandle) scale(1.15);
  }

  stroke(hoverHandle || (arrastrandoSlider && sliderActivo == idSlider) ? color(255) : colTema, 255 * progresoOpciones);
  strokeWeight(2);
  fill(hoverHandle ? color(255, 160, 20, 255 * progresoOpciones) : color(20, 90, 55, 255 * progresoOpciones));
  rectMode(CENTER);
  rect(0, 0, 22, 32, 5);

  fill(255, 200 * progresoOpciones);
  rect(0, 0, 3, 14);
  popMatrix();
  popStyle();
}

void dibujarBotonOpcionAlternativa(float x, float y, float w, float h, String texto, color colTema, int idBoton) {
  boolean hover = evaluarHover(width / 2 + x, height / 2 + y, w, h);
  boolean presionado = hover && mousePressed;

  pushMatrix();
  translate(x, y);
  if (presionado) translate(0, 2);
  else {
    if (hover) scale(1.02);
  }

  stroke(hover ? color(255) : colTema, 255 * progresoOpciones);
  strokeWeight(2);
  fill(presionado ? color(20, 70, 50, 255 * progresoOpciones) : (hover ? color(15, 60, 40, 230 * progresoOpciones) : color(8, 30, 20, 230 * progresoOpciones)));
  rectMode(CENTER);
  rect(0, 0, w, h, 8);

  fill(255, 255 * progresoOpciones);
  textSize(17);
  textAlign(CENTER, CENTER);
  text(texto, 0, -2);
  popMatrix();
}

void dibujarVentanaDificultadSuperpuesta() {
  if (animandoDificultad && !quemandoDificultad) {
    progresoDificultad += 0.03;
    if (progresoDificultad >= 1.0) {
      progresoDificultad = 1.0;
      animandoDificultad = false;
    }
  }

  pushStyle();
  float alphaFondo = quemandoDificultad ? 180 * (1.0 - progresoQuemarDificultad) : 180 * progresoDificultad;
  fill(0, alphaFondo);
  rectMode(CORNER);
  rect(0, 0, width, height);

  pushMatrix();
  translate(width / 2, height / 2);

  float anchoPanel = 1100;
  float altoPanel = 650;
  float grosorBorde = 14;

  if (!quemandoDificultad) {
    dibujarInteriorCajaDisuelta(anchoPanel, altoPanel, progresoDificultad);
    dibujarMarcoProcedural(anchoPanel, altoPanel, grosorBorde, progresoDificultad);

    if (fuenteRetro != null) textFont(fuenteRetro);
    textAlign(CENTER, CENTER);
    textSize(32);

    fillTema(255 * progresoDificultad);
    text("SELECCIONAR DIFICULTAD", 0, -altoPanel / 2 + 55);

    dibujarBotonCerrar(anchoPanel, altoPanel, progresoDificultad);

    if (progresoDificultad > 0.2) {
      float yTarjetas = -30;
      float anchoCard = 380;
      float altoCard = 220;

      float xNormal = -240;
      boolean hoverNormal = evaluarHover(width / 2 + xNormal, height / 2 + yTarjetas, anchoCard, altoCard + 50);

      pushMatrix();
      translate(xNormal, yTarjetas);
      if (hoverNormal) scale(1.04);

      dibujarTarjetaNormalDisuelta(xNormal, yTarjetas, anchoCard, altoCard, progresoDificultad, hoverNormal);

      color colBordeNormal = color(30, 140, 80);
      color colFillNormal = color(0, 140, 80, 230);
      color colHoverNormal = color(0, 200, 120, 255);
      if (modoDaltonismo == 1) {
        colBordeNormal = color(180, 160, 40);
        colFillNormal = color(140, 120, 20, 230);
        colHoverNormal = color(210, 190, 50, 255);
      } else {
        if (modoDaltonismo == 2) {
          colBordeNormal = color(200, 180, 30);
          colFillNormal = color(160, 140, 10, 230);
          colHoverNormal = color(235, 210, 40, 255);
        } else {
          if (modoDaltonismo == 3) {
            colBordeNormal = color(160, 100, 200);
            colFillNormal = color(110, 60, 150, 230);
            colHoverNormal = color(190, 130, 230, 255);
          }
        }
      }

      stroke(hoverNormal ? color(255) : colBordeNormal, 255 * progresoDificultad);
      fill(hoverNormal ? colHoverNormal : colFillNormal);
      rectMode(CENTER);
      rect(0, altoCard / 2 + 25, anchoCard, 40, 8);

      fill(255, 255 * progresoDificultad);
      textSize(18);
      text("NORMAL", 0, altoCard / 2 + 23);
      popMatrix();

      float xDificil = 240;
      boolean hoverDificil = evaluarHover(width / 2 + xDificil, height / 2 + yTarjetas, anchoCard, altoCard + 50);

      pushMatrix();
      translate(xDificil, yTarjetas);
      if (hoverDificil) scale(1.04);

      dibujarTarjetaDificilDisuelta(xDificil, yTarjetas, anchoCard, altoCard, progresoDificultad, hoverDificil);

      color colBordeDificil = color(200, 120, 0);
      color colFillDificil = color(180, 90, 0, 230);
      color colHoverDificil = color(255, 140, 0, 255);
      if (modoDaltonismo == 1) {
        colBordeDificil = color(120, 120, 120);
        colFillDificil = color(90, 90, 90, 230);
        colHoverDificil = color(160, 160, 160, 255);
      } else {
        if (modoDaltonismo == 2) {
          colBordeDificil = color(130, 130, 130);
          colFillDificil = color(100, 100, 100, 230);
          colHoverDificil = color(175, 175, 175, 255);
        } else {
          if (modoDaltonismo == 3) {
            colBordeDificil = color(255, 100, 150);
            colFillDificil = color(200, 60, 110, 230);
            colHoverDificil = color(255, 130, 180, 255);
          }
        }
      }

      stroke(hoverDificil ? color(255) : colBordeDificil, 255 * progresoDificultad);
      fill(hoverDificil ? colHoverDificil : colFillDificil);
      rectMode(CENTER);
      rect(0, altoCard / 2 + 25, anchoCard, 40, 8);

      fill(255, 255 * progresoDificultad);
      textSize(18);
      text("DIFICIL", 0, altoCard / 2 + 23);
      popMatrix();

      float yImposible = 185;
      float wImposible = 320;
      float hImposible = 50;
      boolean hoverImposible = evaluarHover(width / 2, height / 2 + yImposible, wImposible, hImposible);

      pushMatrix();
      translate(0, yImposible);
      if (hoverImposible) scale(1.06);

      color colBordeImposible = color(180, 80, 255);
      color colFillImposible = color(110, 20, 160, 230);
      color colHoverImposible = color(160, 40, 220, 255);
      if (modoDaltonismo == 1) {
        colBordeImposible = color(80, 140, 220);
        colFillImposible = color(30, 90, 160, 230);
        colHoverImposible = color(60, 120, 200, 255);
      } else {
        if (modoDaltonismo == 2) {
          colBordeImposible = color(70, 130, 210);
          colFillImposible = color(20, 80, 150, 230);
          colHoverImposible = color(50, 110, 190, 255);
        } else {
          if (modoDaltonismo == 3) {
            colBordeImposible = color(255, 220, 50);
            colFillImposible = color(180, 150, 10, 230);
            colHoverImposible = color(230, 200, 40, 255);
          }
        }
      }

      stroke(hoverImposible ? color(255) : colBordeImposible, 255 * progresoDificultad);
      strokeWeight(2);
      fill(hoverImposible ? colHoverImposible : colFillImposible);
      rectMode(CENTER);
      rect(0, 0, wImposible, hImposible, 10);

      fill(255, 255 * progresoDificultad);
      textSize(20);
      text("IMPOSIBLE", 0, -2);
      popMatrix();
    }
  } else {
    dibujarPanelDesintegrandoseDisuelto(anchoPanel, altoPanel, progresoQuemarDificultad);
  }

  popMatrix();
  popStyle();
}

void dibujarTarjetaNormalDisuelta(float absX, float absY, float w, float h, float progreso, boolean hover) {
  pushStyle();
  int paso = 10;
  rectMode(CORNER);

  color colBordeCard = colorTema();

  stroke(hover ? color(255) : colBordeCard, 255 * progreso);
  strokeWeight(2);
  fill(10, 35, 22, 230 * progreso);
  rect(-w/2, -h/2, w, h, 12);

  if (imgDificultad1 != null) {
    imageMode(CENTER);
    tint(255, 255 * progreso);
    image(imgShaderDaltonismo(imgDificultad1), 0, 0, w - 16, h - 16);
    noTint();
    imageMode(CORNER);
  }

  noStroke();
  textSize(paso);
  textAlign(CENTER, CENTER);

  for (float px = -w/2; px < w/2; px += paso) {
    for (float py = -h/2; py < h/2; py += paso) {
      float noiseVal = noise((absX + px + 1000) * 0.015, (absY + py + 1000) * 0.015, ztiempo);

      if (noiseVal >= progreso) {
        fill(4, 12, 9);
        rect(px, py, paso, paso);
      } else {
        if (noiseVal > progreso - 0.08) {
          fill(255, 255, 200, 255 * progreso);
          text(random(1) > 0.5 ? "1" : "0", px + paso/2.0, py + paso/2.0);
        }
      }
    }
  }
  popStyle();
}

void dibujarTarjetaDificilDisuelta(float absX, float absY, float w, float h, float progreso, boolean hover) {
  pushStyle();
  int paso = 10;
  rectMode(CORNER);

  color colBordeCardD = color(255, 160, 20);
  if (modoDaltonismo == 1) colBordeCardD = color(180, 180, 180);
  else {
    if (modoDaltonismo == 2) colBordeCardD = color(190, 190, 190);
    else {
      if (modoDaltonismo == 3) colBordeCardD = color(255, 140, 200);
    }
  }

  stroke(hover ? color(255) : colBordeCardD, 255 * progreso);
  strokeWeight(2);
  fill(35, 20, 10, 230 * progreso);
  rect(-w/2, -h/2, w, h, 12);

  if (imgDificultad2 != null) {
    imageMode(CENTER);
    tint(255, 255 * progreso);
    image(imgShaderDaltonismo(imgDificultad2), 0, 0, w - 16, h - 16);
    noTint();
    imageMode(CORNER);
  }

  noStroke();
  textSize(paso);
  textAlign(CENTER, CENTER);

  for (float px = -w/2; px < w/2; px += paso) {
    for (float py = -h/2; py < h/2; py += paso) {
      float noiseVal = noise((absX + px + 2000) * 0.015, (absY + py + 2000) * 0.015, ztiempo);

      if (noiseVal >= progreso) {
        fill(4, 12, 9);
        rect(px, py, paso, paso);
      } else {
        if (noiseVal > progreso - 0.08) {
          fill(255, 220, 150, 255 * progreso);
          text(random(1) > 0.5 ? "1" : "0", px + paso/2.0, py + paso/2.0);
        }
      }
    }
  }
  popStyle();
}

void dibujarInteriorCajaDisuelta(float w, float h, float progreso) {
  pushStyle();
  rectMode(CORNER);
  noStroke();

  float medioW = w / 2.0;
  float medioH = h / 2.0;
  int paso = 12;

  textSize(paso);
  textAlign(CENTER, CENTER);

  for (float px = -medioW; px < medioW; px += paso) {
    for (float py = -medioH; py < medioH; py += paso) {
      float noiseVal = noise((px + 5000) * 0.008, (py + 5000) * 0.008, ztiempoMarco * 0.5);

      if (noiseVal < progreso) {
        if (noiseVal > progreso - 0.07) {
          fillTema(255 * progreso);
          text(random(1) > 0.5 ? "1" : "0", px + paso/2.0, py + paso/2.0);
        } else {
          fill(4, 12, 9, 240 * progreso);
          rect(px, py, paso, paso);
        }
      }
    }
  }

  rectMode(CENTER);
  strokeWeight(1);
  for (float y = -medioH + 6; y < medioH - 6; y += 6) {
    stroke(12, 45, 30, 60 * progreso);
    line(-medioW + 8, y, medioW - 8, y);
  }

  strokeTema(200 * progreso);
  strokeWeight(2);
  float len = 18;

  line(-medioW + 12, -medioH + 12, -medioW + 12 + len, -medioH + 12);
  line(-medioW + 12, -medioH + 12, -medioW + 12, -medioH + 12 + len);

  line(medioW - 12, -medioH + 12, medioW - 12 - len, -medioH + 12);
  line(medioW - 12, -medioH + 12, medioW - 12, -medioH + 12 + len);

  line(-medioW + 12, medioH - 12, -medioW + 12 + len, medioH - 12);
  line(-medioW + 12, medioH - 12, -medioW + 12, medioH - 12 - len);

  line(medioW - 12, medioH - 12, medioW - 12 - len, medioH - 12);
  line(medioW - 12, medioH - 12, medioW - 12, medioH - 12 - len);

  popStyle();
}

void dibujarMenuPrincipal() {
  if (!mostrandoSplash) {
    if (animandoEntrada) {
      progresoEntrada += 0.012;
      if (progresoEntrada >= 1.0) {
        progresoEntrada = 1.0;
        animandoEntrada = false;
      }
    }
  }

  if (!animandoTVOff && estadoPantalla == 0 && !succionando) {
    anguloFlotante += 0.03;
  }
  float desvioY = sin(anguloFlotante) * 8;

  pushMatrix();
  translate(width / 2.0, height * 0.30 + desvioY);

  float anchoCaja = 980;
  float altoCaja = 380;
  float grosorMarco = 12;

  if (!succionando) {
    dibujarInteriorCajaLimpia(anchoCaja, altoCaja, progresoEntrada);
    dibujarMarcoProcedural(anchoCaja, altoCaja, grosorMarco, progresoEntrada);

    if (progresoEntrada < 0.60) {
      dibujarEfectoEntradaBinariaLogo(920, 340, progresoEntrada);
      sonidoEstaticaTituloReproducido = false;
    } else {
      if (progresoEntrada < 0.92) {
        if (!sonidoEstaticaTituloReproducido) {
          reproducirSFX(sonidoEstaticaTituloDolus);
          sonidoEstaticaTituloReproducido = true;
        }
        dibujarLogoConEstatica(920, 340, progresoEntrada);
        ultimoTiempoEscritura = millis();
        ultimoTiempoSonidoTeclado = millis();
        caracteresVisibles = 0;
      } else {
        if (caracteresVisibles < textoTituloCompleto.length()) {
          if (caracteresVisibles == 0) {
            reproducirSFX(sonidoEscritura);
          }
          if (millis() - ultimoTiempoEscritura >= intervaloEscritura) {
            caracteresVisibles++;
            ultimoTiempoEscritura = millis();
          }
        }

        String textoParcial = textoTituloCompleto.substring(0, caracteresVisibles);

        if (caracteresVisibles == textoTituloCompleto.length()) {
          int tiempoActual = millis();

          if (glitchActivo && (tiempoActual - tiempoInicioGlitch > duracionGlitch)) {
            glitchActivo = false;
            textoGlitcheado = "DOLUS";
          }

          if (!glitchActivo && (tiempoActual - ultimoIntentoGlitch > 3000)) {
            ultimoIntentoGlitch = tiempoActual;
            if (random(1) < 0.35) {
              glitchActivo = true;
              tiempoInicioGlitch = tiempoActual;
              duracionGlitch = (int)random(400, 900);

              String c1 = (random(1) < 0.6) ? "0" : "O";
              String c2 = (random(1) < 0.6) ? "1" : "L";
              String c4 = (random(1) < 0.4) ? "$" : "S";
              textoGlitcheado = "D" + c1 + c2 + "U" + c4;
            }
          }

          if (glitchActivo) {
            textoParcial = textoGlitcheado;
          }
        }

        pushStyle();
        if (fuenteTitulo != null) {
          textFont(fuenteTitulo);
        } else {
          textFont(fuenteRetro);
        }
        textAlign(CENTER, CENTER);
        textSize(135);

        fill(0, 180 * progresoEntrada);
        text(textoParcial, 4, 4);

        fillTema(255 * progresoEntrada);
        text(textoParcial, 0, 0);

        if (caracteresVisibles < textoTituloCompleto.length() || (millis() / 400) % 2 == 0) {
          float anchoTexto = textWidth(textoParcial);
          fillTema(255 * progresoEntrada);
          rectMode(CORNER);
          rect(anchoTexto / 2 + 6, -55, 16, 105);
        }

        popStyle();
      }
    }
  } else {
    float progDesintegracionLogo = map(progresoSuccion, 0.0, 1.0, 0.0, 1.0);
    progDesintegracionLogo = constrain(progDesintegracionLogo, 0.0, 1.0);
    dibujarPanelDesintegrandoseDisuelto(anchoCaja, altoCaja, progDesintegracionLogo);
  }
  popMatrix();

  pushMatrix();
  translate(width / 2.0, height * 0.72 + desvioY);

  if (!succionando) {
    rectMode(CENTER);
    textAlign(CENTER, CENTER);

    float anchoPanel = 340;
    float altoPanel = 376;

    color colMarcoB = color(30, 140, 80);
    if (modoDaltonismo == 1) colMarcoB = color(60, 90, 140);
    else {
      if (modoDaltonismo == 2) colMarcoB = color(50, 100, 160);
      else {
        if (modoDaltonismo == 3) colMarcoB = color(140, 60, 90);
      }
    }

    strokeConAlpha(colMarcoB, 255 * progresoEntrada);
    strokeWeight(2);
    fill(6, 18, 12, 230 * progresoEntrada);
    rect(0, 0, anchoPanel, altoPanel, 18);

    strokeTema(80 * progresoEntrada);
    strokeWeight(1);
    noFill();
    rect(0, 0, anchoPanel - 12, altoPanel - 12, 14);

    float anchoB = 288;
    float altoB = 44;
    float separacionY = 55;

    float yJugar     = -separacionY * 2.5;
    float yFeria     = -separacionY * 1.5;
    float yCompendio = -separacionY * 0.5;
    float yOpciones  = separacionY * 0.5;
    float yCreditos  = separacionY * 1.5;
    float ySalir     = separacionY * 2.5;

    color colJugarBase = color(230, 110, 0);
    color colJugarHover = color(255, 160, 20);
    color colJugarBorde = color(255, 210, 80);
    color colFeriaBase = color(16, 118, 128);
    color colFeriaHover = color(28, 168, 178);
    color colFeriaBorde = color(90, 245, 225);
    color colExpoBase = color(108, 48, 152);
    color colExpoHover = color(146, 72, 200);
    color colExpoBorde = color(255, 205, 95);
    if (modoDaltonismo == 1) {
      colJugarBase = color(30, 110, 180);
      colJugarHover = color(60, 150, 220);
      colJugarBorde = color(120, 190, 255);
      colFeriaBase = color(24, 96, 165);
      colFeriaHover = color(46, 138, 215);
      colFeriaBorde = color(130, 215, 255);
      colExpoBase = color(95, 75, 165);
      colExpoHover = color(130, 105, 205);
      colExpoBorde = color(255, 215, 110);
    } else {
      if (modoDaltonismo == 2) {
        colJugarBase = color(20, 95, 170);
        colJugarHover = color(50, 135, 210);
        colJugarBorde = color(100, 175, 245);
        colFeriaBase = color(24, 96, 165);
        colFeriaHover = color(46, 138, 215);
        colFeriaBorde = color(130, 215, 255);
        colExpoBase = color(95, 75, 165);
        colExpoHover = color(130, 105, 205);
        colExpoBorde = color(255, 215, 110);
      } else {
        if (modoDaltonismo == 3) {
          colJugarBase = color(200, 80, 50);
          colJugarHover = color(240, 120, 80);
          colJugarBorde = color(255, 170, 130);
          colFeriaBase = color(16, 128, 132);
          colFeriaHover = color(35, 175, 180);
          colFeriaBorde = color(115, 248, 240);
          colExpoBase = color(135, 52, 118);
          colExpoHover = color(175, 78, 152);
          colExpoBorde = color(255, 195, 120);
        }
      }
    }

    dibujarBotonInteractive(0, yJugar, anchoB, altoB, "JUGAR",
      colJugarBase, colJugarHover, colJugarBorde);
    float anchoHalf = 138;
    dibujarBotonInteractive(-75, yFeria, anchoHalf, altoB, "MODO FERIA",
      colFeriaBase, colFeriaHover, colFeriaBorde);
    dibujarBotonInteractive(75, yFeria, anchoHalf, altoB, "EXPOSICION",
      colExpoBase, colExpoHover, colExpoBorde);

    color colBaseGris   = color(30, 40, 36);
    color colHoverGris  = color(45, 60, 54);
    color colBordeGris  = color(80, 100, 92);
    if (modoDaltonismo == 1) {
      colBaseGris = color(30, 40, 55);
      colHoverGris = color(50, 65, 85);
      colBordeGris = color(90, 110, 140);
    } else {
      if (modoDaltonismo == 2) {
        colBaseGris = color(25, 35, 50);
        colHoverGris = color(45, 60, 80);
        colBordeGris = color(85, 105, 135);
      } else {
        if (modoDaltonismo == 3) {
          colBaseGris = color(50, 30, 40);
          colHoverGris = color(75, 45, 60);
          colBordeGris = color(120, 80, 100);
        }
      }
    }

    dibujarBotonInteractive(0, yCompendio, anchoB, altoB, "COMPENDIO", colBaseGris, colHoverGris, colBordeGris);
    dibujarBotonInteractive(0, yOpciones, anchoB, altoB, "OPCIONES", colBaseGris, colHoverGris, colBordeGris);
    dibujarBotonInteractive(0, yCreditos, anchoB, altoB, "CREDITOS", colBaseGris, colHoverGris, colBordeGris);
    dibujarBotonInteractive(0, ySalir, anchoB, altoB, "SALIR", colBaseGris, colHoverGris, colBordeGris);

    rectMode(CORNER);
  } else {
    float progDesintegracionBotones = map(progresoSuccion, 0.0, 1.0, 0.0, 1.0);
    progDesintegracionBotones = constrain(progDesintegracionBotones, 0.0, 1.0);
    dibujarPanelDesintegrandoseDisuelto(340, 376, progDesintegracionBotones);
  }
  popMatrix();
}

void dibujarPanelDesintegrandoseDisuelto(float w, float h, float progreso) {
  pushStyle();
  int paso = 10;
  rectMode(CENTER);

  color colMarcoB = color(30, 140, 80);
  if (modoDaltonismo == 1) colMarcoB = color(60, 90, 140);
  else {
    if (modoDaltonismo == 2) colMarcoB = color(50, 100, 160);
    else {
      if (modoDaltonismo == 3) colMarcoB = color(140, 60, 90);
    }
  }

  strokeConAlpha(colMarcoB, 255 * (1.0 - progreso));
  strokeWeight(2);
  fill(6, 18, 12, 230 * (1.0 - progreso));
  rect(0, 0, w, h, 18);

  noStroke();
  textSize(paso);
  textAlign(CENTER, CENTER);

  for (float px = -w/2; px < w/2; px += paso) {
    for (float py = -h/2; py < h/2; py += paso) {
      float noiseVal = noise((px + 7000) * 0.02, (py + 7000) * 0.02, ztiempo);
      if (noiseVal < progreso) {
        if (noiseVal > progreso - 0.1) {
          fill(255, 220, 100, 255 * (1.0 - progreso));
          text(random(1) > 0.5 ? "1" : "0", px + paso/2.0, py + paso/2.0);
        } else {
          fill(4, 12, 9, 240 * (1.0 - progreso));
          rect(px, py, paso, paso);
        }
      }
    }
  }
  popStyle();
}

void dibujarEfectoTVOff() {
  pushStyle();
  rectMode(CENTER);
  progresoTV += 0.035;

  if (musicaMenu != null) {
    float volTV = map(progresoTV, 0.0, 0.8, volumenFinalMusica(), 0.0);
    musicaMenu.amp(constrain(volTV, 0.0, 1.0));
  }

  float cx = width / 2.0;
  float cy = height / 2.0;
  float hCorte = height;
  float wCorte = width;

  if (progresoTV < 0.5) {
    float p1 = map(progresoTV, 0.0, 0.5, 0.0, 1.0);
    float easingH = pow(1.0 - p1, 3);
    hCorte = height * easingH;
    if (hCorte < 4) hCorte = 4;
  } else {
    float p2 = map(progresoTV, 0.5, 0.95, 0.0, 1.0);
    float easingW = pow(1.0 - p2, 3);
    hCorte = 4;
    wCorte = width * easingW;
  }

  fill(0);
  noStroke();

  float altoBandaSup = (height - hCorte) / 2.0;
  rectMode(CORNER);
  rect(0, 0, width, altoBandaSup);
  rect(0, height - altoBandaSup, width, altoBandaSup);

  if (progresoTV >= 0.5) {
    float anchoBandaIzama = (width - wCorte) / 2.0;
    rect(0, 0, anchoBandaIzama, height);
    rect(width - anchoBandaIzama, 0, anchoBandaIzama, height);
  }

  if (progresoTV < 0.95) {
    rectMode(CENTER);
    fill(255);
    rect(cx, cy, wCorte, hCorte);

    stroke(180, 255, 220, 180);
    strokeWeight(3);
    noFill();
    rect(cx, cy, wCorte + 4, hCorte + 2);
  }

  if (progresoTV >= 1.0) {
    if (musicaMenu != null) musicaMenu.stop();
    exit();
  }

  popStyle();
}

void dibujarFondoEnmarcadoFluido() {
  pushStyle();
  int paso = 12;
  float centroX = width / 2.0;
  float centroY = height / 2.0;
  float maxDist = dist(0, 0, centroX, centroY);

  rectMode(CORNER);
  noStroke();

  color cNegro    = color(2, 4, 3);
  color cMedio1   = color(8, 26, 17);
  color cMedio2   = color(14, 45, 27);
  color cMedio3   = color(20, 70, 40);
  color cMedio4   = color(28, 110, 60);
  color cBrillo   = color(45, 160, 95);
  color cResalte  = color(90, 230, 150);

  color nOscuro = color(2, 4, 3);
  color nMedio1 = color(10, 12, 12);
  color nMedio2 = color(18, 22, 22);
  color nMedio3 = color(28, 34, 34);
  color nBrillo = color(45, 60, 58);

  if (modoDaltonismo == 1) {
    cNegro    = color(4, 4, 6);
    cMedio1   = color(20, 26, 45);
    cMedio2   = color(35, 50, 80);
    cMedio3   = color(60, 90, 120);
    cMedio4   = color(90, 130, 160);
    cBrillo   = color(160, 180, 80);
    cResalte  = color(230, 210, 60);
  } else {
    if (modoDaltonismo == 2) {
      cNegro    = color(3, 4, 8);
      cMedio1   = color(15, 30, 50);
      cMedio2   = color(30, 60, 90);
      cMedio3   = color(55, 95, 130);
      cMedio4   = color(85, 140, 170);
      cBrillo   = color(170, 180, 50);
      cResalte  = color(245, 225, 40);
    } else {
      if (modoDaltonismo == 3) {
        cNegro    = color(6, 2, 4);
        cMedio1   = color(35, 15, 25);
        cMedio2   = color(65, 25, 45);
        cMedio3   = color(100, 40, 70);
        cMedio4   = color(140, 65, 95);
        cBrillo   = color(180, 90, 140);
        cResalte  = color(235, 130, 190);
      }
    }
  }

  if (modoAlarmaError) {
    cNegro    = color(15, 0, 0);
    cMedio1   = color(45, 5, 5);
    cMedio2   = color(95, 10, 10);
    cMedio3   = color(160, 20, 20);
    cMedio4   = color(220, 35, 35);
    cBrillo   = color(255, 80, 80);
    cResalte  = color(255, 130, 130);

    nOscuro = color(10, 0, 0);
    nMedio1 = color(30, 5, 5);
    nMedio2 = color(60, 10, 10);
    nMedio3 = color(100, 15, 15);
    nBrillo = color(150, 30, 30);
  }

  float succionEfectiva = intensidadSuccionFondo;
  float multiplicadorTiempo = modoAlarmaError ? 4.5 : 1.0;
  float ztiempoEfectivo = ztiempo * multiplicadorTiempo;

  float radioNucleo    = lerp(0.28, 0.04, succionEfectiva);
  float radioRemolino = lerp(0.60, 0.18, succionEfectiva);

  float cxFinal = centroX;
  float cyFinal = centroY;
  if (modoAlarmaError) {
    cxFinal += random(-12, 12);
    cyFinal += random(-12, 12);
  }

  for (int x = 0; x < width; x += paso) {
    for (int y = 0; y < height; y += paso) {
      float dx = x - cxFinal;
      float dy = y - cyFinal;
      float d = dist(x, y, cxFinal, cyFinal) / maxDist;
      float anguloPolar = atan2(dy, dx);

      float distorsionViolenta = modoAlarmaError ? (noise(x * 0.02, y * 0.02, ztiempo * 4.0) - 0.5) * 60.0 : 0.0;

      float anguloExt = (1.0 - d) * 3.2 + ztiempoEfectivo * (0.15 + succionEfectiva * 1.8);
      float cosE = cos(anguloExt);
      float sinE = sin(anguloExt);
      float xExt = dx * cosE - dy * sinE + distorsionViolenta;
      float yExt = dx * sinE + dy * cosE + distorsionViolenta;

      float warpXExt = noise(xExt * 0.0018, yExt * 0.0018, ztiempoEfectivo * 0.6) * 130.0;
      float warpYExt = noise(xExt * 0.0018 + 500.0, yExt * 0.0018 + 500.0, ztiempoEfectivo * 0.6) * 130.0;
      float valorExt = noise((xExt + warpXExt) * 0.0026, (yExt + warpYExt) * 0.0026, ztiempoEfectivo * 0.5);
      float detalleExt = noise((xExt + warpXExt) * 0.01, (yExt + warpYExt) * 0.01, ztiempoEfectivo * 1.2);
      valorExt = valorExt * 0.75 + detalleExt * 0.15;

      float brazos = sin(anguloPolar * 3.0 + d * 10.0 - ztiempoEfectivo * 1.5) * 0.5 + 0.5;
      valorExt = valorExt * 0.72 + brazos * 0.28;

      float anguloInt = (1.0 - d) * 3.5 - ztiempoEfectivo * (0.22 + succionEfectiva * 2.2);
      float cosI = cos(anguloInt);
      float sinI = sin(anguloInt);
      float xInt = dx * cosI - dy * sinI - distorsionViolenta;
      float yInt = dx * sinI + dy * cosI - distorsionViolenta;

      float warpXInt = noise(xInt * 0.003 + 9000.0, yInt * 0.003 + 9000.0, ztiempoEfectivo * 0.5) * 160.0;
      float warpYInt = noise(xInt * 0.003 + 9500.0, yInt * 0.003 + 9500.0, ztiempoEfectivo * 0.5) * 160.0;
      float valorInt = noise((xInt + warpXInt) * 0.004 + 3000.0, (yInt + warpYInt) * 0.004 + 3000.0, ztiempoEfectivo * 0.7);
      float detalleInt = noise((xInt + warpXInt) * 0.014 + 3000.0, (yInt + warpYInt) * 0.014 + 3000.0, ztiempoEfectivo * 1.4);
      valorInt = valorInt * 0.8 + detalleInt * 0.2;

      color colorExt;
      if (valorExt < 0.25) colorExt = cNegro;
      else {
        if (valorExt < 0.38) colorExt = cMedio1;
        else {
          if (valorExt < 0.50) colorExt = cMedio2;
          else {
            if (valorExt < 0.62) colorExt = cMedio3;
            else {
              if (valorExt < 0.74) colorExt = cMedio4;
              else {
                if (valorExt < 0.87) colorExt = cBrillo;
                else colorExt = cResalte;
              }
            }
          }
        }
      }

      color colorInt;
      if (valorInt < 0.30) colorInt = nOscuro;
      else {
        if (valorInt < 0.50) colorInt = nMedio1;
        else {
          if (valorInt < 0.68) colorInt = nMedio2;
          else {
            if (valorInt < 0.85) colorInt = nMedio3;
            else colorInt = nBrillo;
          }
        }
      }

      color c;
      if (d < radioNucleo) {
        c = colorInt;
      } else {
        if (d > radioRemolino) {
          c = colorExt;
        } else {
          float fraccion = (d - radioNucleo) / (radioRemolino - radioNucleo);
          float umbralDither = noise(x * 0.02, y * 0.02, ztiempoEfectivo * 0.8 + 4000.0);
          c = (umbralDither < fraccion) ? colorExt : colorInt;
        }
      }

      fill(c);
      rect(x, y, paso, paso);
    }
  }
  popStyle();
}

void dibujarInteriorCajaLimpia(float w, float h, float progreso) {
  pushStyle();
  rectMode(CENTER);

  float medioW = w / 2.0;
  float medioH = h / 2.0;

  fill(4, 12, 9, 240 * progreso);
  rect(0, 0, w, h, 14);

  strokeWeight(1);
  for (float y = -medioH + 6; y < medioH - 6; y += 6) {
    stroke(12, 45, 30, 60 * progreso);
    line(-medioW + 8, y, medioW - 8, y);
  }

  strokeTema(200 * progreso);
  strokeWeight(2);
  float len = 18;

  line(-medioW + 12, -medioH + 12, -medioW + 12 + len, -medioH + 12);
  line(-medioW + 12, -medioH + 12, -medioW + 12, -medioH + 12 + len);

  line(medioW - 12, -medioH + 12, medioW - 12 - len, -medioH + 12);
  line(medioW - 12, -medioH + 12, medioW - 12, -medioH + 12 + len);

  line(-medioW + 12, medioH - 12, -medioW + 12 + len, medioH - 12);
  line(-medioW + 12, medioH - 12, -medioW + 12, medioH - 12 - len);

  line(medioW - 12, medioH - 12, medioW - 12 - len, medioH - 12);
  line(medioW - 12, medioH - 12, medioW - 12, medioH - 12 - len);

  popStyle();
}

void dibujarMarcoProcedural(float w, float h, float grosor, float progreso) {
  pushStyle();
  int paso = 8;
  float medioW = w / 2.0;
  float medioH = h / 2.0;

  rectMode(CORNER);
  noStroke();
  for (float px = -medioW - grosor; px <= medioW + grosor; px += paso) {
    for (float py = -medioH - grosor; py <= medioH + grosor; py += paso) {

      boolean estaEnBordeOuter = (px >= -medioW - grosor && px <= medioW + grosor && py >= -medioH - grosor && py <= medioH + grosor);
      boolean estaEnInterior = (px > -medioW && px < medioW && py > -medioH && py < medioH);

      if (estaEnBordeOuter && !estaEnInterior) {
        float nx = px * 0.008;
        float ny = py * 0.008;

        float valRuido = noise(nx + 100.0, ny + 100.0, ztiempoMarco);
        float onda = sin(valRuido * TWO_PI * 2.5 + ztiempoMarco * 3.0);

        if (valRuido <= progreso + 0.15) {
          color colorMarco;
          if (modoDaltonismo == 1) {
            if (onda < -0.2) colorMarco = color(30, 60, 90, 255 * progreso);
            else {
              if (onda < 0.2) colorMarco = color(60, 110, 150, 255 * progreso);
              else {
                if (onda < 0.6) colorMarco = color(100, 160, 200, 255 * progreso);
                else colorMarco = color(230, 200, 80, 255 * progreso);
              }
            }
          } else {
            if (modoDaltonismo == 2) {
              if (onda < -0.2) colorMarco = color(25, 50, 95, 255 * progreso);
              else {
                if (onda < 0.2) colorMarco = color(50, 95, 155, 255 * progreso);
                else {
                  if (onda < 0.6) colorMarco = color(90, 145, 210, 255 * progreso);
                  else colorMarco = color(255, 230, 50, 255 * progreso);
                }
              }
            } else {
              if (modoDaltonismo == 3) {
                if (onda < -0.2) colorMarco = color(90, 30, 50, 255 * progreso);
                else {
                  if (onda < 0.2) colorMarco = color(130, 50, 80, 255 * progreso);
                  else {
                    if (onda < 0.6) colorMarco = color(170, 75, 115, 255 * progreso);
                    else colorMarco = color(220, 150, 255, 255 * progreso);
                  }
                }
              } else {
                if (onda < -0.2) colorMarco = color(10, 80, 90, 255 * progreso);
                else {
                  if (onda < 0.2) colorMarco = color(20, 160, 120, 255 * progreso);
                  else {
                    if (onda < 0.6) colorMarco = color(0, 220, 180, 255 * progreso);
                    else colorMarco = color(80, 255, 160, 255 * progreso);
                  }
                }
              }
            }
          }

          fill(colorMarco);
          rect(px, py, paso, paso);
        }
      }
    }
  }
  popStyle();
}

void dibujarEfectoEntradaBinariaLogo(float w, float h, float progreso) {
  pushStyle();
  int pasoX = 16;
  int pasoY = 16;
  float medioW = w / 2.0;
  float medioH = h / 2.0;

  textSize(12);
  textAlign(CENTER, CENTER);

  for (float px = -medioW; px <= medioW; px += pasoX) {
    for (float py = -medioH; py <= medioH; py += pasoY) {
      float n = noise((px + 500) * 0.01, (py + 500) * 0.01);

      if (n < progreso + 0.25) {
        if (random(1) > 0.3) {
          fill(random(1) > 0.5 ? color(255) : colorTema());
          text(random(1) > 0.3 ? "1" : "0", px, py);
        } else {
          fill(20, 120, 70, 150);
          rect(px, py, pasoX - 2, pasoY - 2);
        }
      }
    }
  }
  popStyle();
}

void dibujarLogoConEstatica(float w, float h, float progreso) {
  pushStyle();

  float medioW = w / 2.0;
  float medioH = h / 2.0;

  if (fuenteTitulo != null) textFont(fuenteTitulo);
  else textFont(fuenteRetro);

  textAlign(CENTER, CENTER);
  textSize(135);
  color colEstatica = colorTema();
  fillConAlpha(colEstatica, map(progreso, 0.60, 0.92, 100, 240));
  text("10101", random(-4, 4), random(-2, 2));

  if (efectosCRTActivos) {
    strokeWeight(2);
    for (int i = 0; i < 40; i++) {
      float rx = random(-medioW, medioW);
      float ry = random(-medioH, medioH);
      stroke(random(1) > 0.5 ? color(255, random(150, 255)) : color(red(colEstatica), green(colEstatica), blue(colEstatica), random(100, 200)));
      line(rx, ry, rx + random(4, 18), ry);
    }

    if (random(1) > 0.4) {
      noStroke();
      fill(255, random(30, 80));
      float yFranja = random(-medioH, medioH);
      rectMode(CENTER);
      rect(0, yFranja, w - 20, random(3, 10));
    }
  }

  popStyle();
}

void dibujarBotonInteractive(float x, float y, float w, float h, String texto, color colBase, color colHover, color colBorde) {
  pushStyle();
  pushMatrix();

  float desvioY = sin(anguloFlotante) * 8;
  float absX = (width / 2) + x;
  float absY = (height * 0.72 + desvioY) + y;

  boolean menuInteractivo = (estadoPantalla == 0 && !animandoEntrada && !animandoTVOff && !succionando && !escupiendoMenu && !mostrandoSplash && !metaMensajePendiente);
  boolean estaHover = menuInteractivo && evaluarHover(absX, absY, w, h);
  boolean presionado = estaHover && mousePressed;

  float scaleX = (estaHover && !animandoTVOff && estadoPantalla == 0) ? 1.07 : 1.0;
  float scaleY = (estaHover && !animandoTVOff && estadoPantalla == 0) ? 1.05 : 1.0;
  if (presionado) {
    scaleX = 1.12;
    scaleY = 0.88;
  }
  translate(x, y);
  scale(scaleX, scaleY);

  if (!presionado) {
    noStroke();
    fill(0, 180 * progresoEntrada);
    rect(3, 6, w, h, 12);
  }

  stroke(estaHover ? color(255, 255 * progresoEntrada) : color(colBorde, 255 * progresoEntrada));
  strokeWeight(estaHover ? 3 : 2);

  color colorFinal = presionado ? color(red(colBase)*0.7, green(colBase)*0.7, blue(colBase)*0.7, 255 * progresoEntrada) :
    (estaHover ? color(red(colHover), green(colHover), blue(colHover), 255 * progresoEntrada)
    : color(red(colBase), green(colBase), blue(colBase), 255 * progresoEntrada));
  fill(colorFinal);
  rect(0, 0, w, h, 12);

  noStroke();
  fill(255, estaHover ? 70 * progresoEntrada : 30 * progresoEntrada);
  rect(0, -h * 0.22, w - 8, h * 0.35, 8);

  if (fuenteRetro != null) textFont(fuenteRetro);

  String textoAMostrar = texto;
  if (progresoEntrada < 0.85) {
    String[] charsBinarios = {"0", "1", "#", "X", "1", "0"};
    String resultado = "";
    for (int i = 0; i < texto.length(); i++) {
      if (random(1) > progresoEntrada) {
        resultado = resultado + charsBinarios[(int)random(6)];
      } else {
        resultado = resultado + textoAMostrar.substring(i, i + 1);
      }
    }
    textoAMostrar = resultado;
  }

  fill(0, 200 * progresoEntrada);
  textSize(w < 200 ? 14 : 18);
  textAlign(CENTER, CENTER);
  text(textoAMostrar, 1, 1);

  fill(estaHover ? color(255, 255, 200, 255 * progresoEntrada) : color(255, 255 * progresoEntrada));
  text(textoAMostrar, 0, -2);

  popMatrix();
  popStyle();
}

void mousePressed() {
  if (modoDesarrollador && manejarMouseDesarrollador()) return;
  if (estadoTransicionMenu != 0) return;
  if (pausaActiva()) {
    mousePressedPausa();
    return;
  }
  if (ejecutandoLinkStart) return;

  if (estadoPantalla == PANTALLA_TRANSICION_JEFE) {
    saltarAdvertenciaJefe();
    return;
  }

  if (estadoPantalla == 6 || estadoPantalla == 7) {
    mousePressedJuego();
    return;
  }
  if (estadoPantalla == PANTALLA_JUEGO) {
    if (interceptarClickTutorial()) return;
    mousePressedDolus();
    return;
  }
  if (estadoPantalla == PANTALLA_TIENDA) {
    mousePressedTienda();
    return;
  }
  if (estadoPantalla == PANTALLA_GAMEOVER) {
    mousePressedGameOver();
    return;
  }

  if (estadoPantalla == PANTALLA_CINEMATICA_FINAL || estadoPantalla == PANTALLA_HABITACION || estadoPantalla == PANTALLA_GLITCH_ESCAPE) {
    mousePressedEpilogo();
    return;
  }

  if (estadoPantalla == 2) {
    float yInicioSliders = height / 2 - 180;
    float separacionSliders = 55;
    float anchoTrack = 400;
    float xTrackAbs = width / 2 + 210;

    for (int i = 1; i <= 3; i++) {
      float ySliderActual = yInicioSliders + ((i - 1) * separacionSliders);
      if (evaluarHover(xTrackAbs, ySliderActual, anchoTrack + 30, 40)) {
        arrastrandoSlider = true;
        sliderActivo = i;
        reproducirClickUI(false);

        float valNuevo = constrain(map(mouseX - xTrackAbs, -anchoTrack / 2, anchoTrack / 2, 0.0, 1.0), 0.0, 1.0);
        if (sliderActivo == 1) volumenMaestro = valNuevo;
        else {
          if (sliderActivo == 2) volumenMusica = valNuevo;
          else {
            if (sliderActivo == 3) volumenSFX = valNuevo;
          }
        }
        actualizarVolumenesAudio();
      }
    }

    float yBotonBase = height / 2 + 35;
    float altoBDonde = 45;
    float espacioBotones = 65;

    if (!menuDaltonismoAbierto) {
      if (evaluarHover(width / 2, yBotonBase, 680, altoBDonde)) {
        reproducirTap();
        menuDaltonismoAbierto = true;
      }

      if (evaluarHover(width / 2, yBotonBase + espacioBotones, 680, altoBDonde)) {
        reproducirTap();
        efectosCRTActivos = !efectosCRTActivos;
      }
    } else {
      if (evaluarHover(width / 2, yBotonBase, 680, altoBDonde)) {
        reproducirTap();
        menuDaltonismoAbierto = false;
      }

      float yInicioDaltAbs = yBotonBase + 60;
      float altoOpt = 42;
      for (int i = 0; i < 4; i++) {
        float yOptAbs = yInicioDaltAbs + (i * (altoOpt + 6));
        if (evaluarHover(width / 2, yOptAbs, 680, altoOpt)) {
          reproducirTap();
          modoDaltonismo = i;
          limpiarCacheShaderDaltonismo();
          actualizarCursorPersonalizado();
          menuDaltonismoAbierto = false;
        }
      }
    }

    if (hoverBotonCerrar(1100, 680)) {
      reproducirTap();
      menuDaltonismoAbierto = false;
      if (abiertoDesdePausa) {
        estadoPantalla = pantallaOrigenPausa;
        estadoPausa = 2;
        abiertoDesdePausa = false;
      } else {
        estadoPantalla = 0;
      }
    }
    return;
  }

  if (estadoPantalla == PANTALLA_COMPENDIO) {
    mousePressedCompendio();
    return;
  }

  if (estadoPantalla == PANTALLA_SLOTS) {
    mousePressedPantallaSlots();
    return;
  }

  if (estadoPantalla == PANTALLA_MODO_FERIA) {
    mousePressedModoFeria();
    return;
  }

  if (estadoPantalla == 0 && !animandoEntrada && !animandoTVOff && !succionando && !escupiendoMenu && !mostrandoSplash && !metaMensajePendiente) {
    float centroX = width / 2;
    float desvioY = sin(anguloFlotante) * 8;
    float centroY = height * 0.72 + desvioY;
    float separacionY = 55;

    float yJugar     = centroY + (-separacionY * 2.5);
    float yFeria     = centroY + (-separacionY * 1.5);
    float yCompendio = centroY + (-separacionY * 0.5);
    float yOpciones  = centroY + (separacionY * 0.5);
    float yCreditos  = centroY + (separacionY * 1.5);
    float ySalir     = centroY + (separacionY * 2.5);

    if (evaluarHover(centroX, yJugar, 288, 44)) {
      reproducirTap();
      reproducirSFX(sonidoAbsorcionVortice);
      succionando = true;
      progresoSuccion = 0.0;
    }

    if (evaluarHover(centroX - 75, yFeria, 138, 44)) {
      reproducirTap();
      reproducirSFX(sonidoGeneracionBurn);
      abrirPantallaModoFeria();
    }

    if (evaluarHover(centroX + 75, yFeria, 138, 44)) {
      reproducirTap();
      reproducirSFX(sonidoGeneracionBurn);
      iniciarModoExposicion();
    }

    if (evaluarHover(centroX, yCompendio, 288, 44)) {
      reproducirTap();
      reproducirSFX(sonidoGeneracionBurn);
      abiertoCompendioDesdePausa = false;
      estadoPantalla = PANTALLA_COMPENDIO;
      animandoCompendio = true;
      progresoCompendio = 0.0;
    }

    if (evaluarHover(centroX, yOpciones, 288, 44)) {
      reproducirTap();
      reproducirSFX(sonidoGeneracionBurn);
      estadoPantalla = 2;
      animandoOpciones = true;
      progresoOpciones = 0.0;
      menuDaltonismoAbierto = false;
    }

    if (evaluarHover(centroX, yCreditos, 288, 44)) {
      reproducirTap();
      reproducirSFX(sonidoGeneracionBurn);
      estadoPantalla = 3;
      animandoCreditos = true;
      progresoCreditos = 0.0;
    }

    if (evaluarHover(centroX, ySalir, 288, 44)) {
      reproducirTap();
      animandoTVOff = true;
      progresoTV = 0.0;
    }
  } else {
    if (estadoPantalla == 3 && !animandoCreditos) {
      if (hoverBotonCerrar(1100, 680)) {
        reproducirTap();
        estadoPantalla = 0;
      }
    } else {
      if (estadoPantalla == 5 && !animandoDificultad && !quemandoDificultad) {
        float xNormalAbs = width / 2 - 240;
        float yTarjetasAbs = height / 2 - 30;
        float xDificilAbs = width / 2 + 240;
        float yImposibleAbs = height / 2 + 185;

        if (evaluarHover(xNormalAbs, yTarjetasAbs, 380, 270)) {
          reproducirTap();
          reproducirSFX(sonidoGeneracionBurn);
          seleccionadoParaJugar = true;
          dificultadSeleccionadaPendiente = 1;
          quemandoDificultad = true;
          progresoQuemarDificultad = 0.0;
        } else {
          if (evaluarHover(xDificilAbs, yTarjetasAbs, 380, 270)) {
            reproducirTap();
            reproducirSFX(sonidoGeneracionBurn);
            seleccionadoParaJugar = true;
            dificultadSeleccionadaPendiente = 2;
            quemandoDificultad = true;
            progresoQuemarDificultad = 0.0;
          } else {
            if (evaluarHover(width / 2, yImposibleAbs, 320, 50)) {
              reproducirTap();
              reproducirSFX(sonidoGeneracionBurn);
              seleccionadoParaJugar = true;
              dificultadSeleccionadaPendiente = 3;
              quemandoDificultad = true;
              progresoQuemarDificultad = 0.0;
            }
          }
        }

        if (hoverBotonCerrar(1100, 650)) {
          reproducirTap();
          reproducirSFX(sonidoGeneracionBurn);
          seleccionadoParaJugar = false;
          quemandoDificultad = true;
          progresoQuemarDificultad = 0.0;
        }
      }
    }
  }
}

void mouseReleased() {
  if (arrastrandoSlider) {
    reproducirClickUI(true);
  }
  arrastrandoSlider = false;
  sliderActivo = 0;

  if (estadoPantalla == 6 || estadoPantalla == 7) {
    mouseReleasedJuego();
  }
  if (estadoPantalla == PANTALLA_JUEGO) {
    if (interceptarReleaseTutorial()) return;
    mouseReleasedDolus();
  } else {
    if (estadoPantalla == PANTALLA_HABITACION) {
      mouseReleasedEpilogo();
    }
  }
}

void mouseDragged() {
  if (estadoPantalla == PANTALLA_JUEGO) {
    if (interceptarDragTutorial()) return;
    mouseDraggedDolus();
  } else {
    if (estadoPantalla == PANTALLA_HABITACION) {
      mouseDraggedEpilogo();
    }
  }
}

void keyPressed() {
  if (estadoPantalla == PANTALLA_SLOTS && modalNombreActivo) {
    keyPressedPantallaSlots();
    return;
  }

  if (estadoPantalla == PANTALLA_MODO_FERIA) {
    if (keyCode == 114) {
      modoDesarrollador = !modoDesarrollador;
      return;
    }
    keyPressedModoFeria();
    return;
  }

  if (key == 'f' || key == 'F') {
    teclaSaltarEscenaPresionada = true;
  }

  if (keyCode == 114) {
    modoDesarrollador = !modoDesarrollador;
    return;
  }

  if (modoDesarrollador) {
    if (manejarTeclasDesarrollador()) return;
  }

  if (manejarTeclaPausa()) return;
  if (ejecutandoLinkStart) return;

  if (estadoPantalla == PANTALLA_SLOTS) {
    keyPressedPantallaSlots();
    return;
  }

  if (estadoPantalla == 6 || estadoPantalla == 7) {
    keyPressedJuego();
    return;
  }

  if (estadoPantalla == PANTALLA_JUEGO) {
    if (animandoShowcaseDirectiva && (key == ' ' || key == ENTER || key == RETURN)) {
      presionandoHoldShowcase = true;
      return;
    }
    if (keyPressedTutorial()) return;
    if (rondaCompletada && (key == ' ' || key == ENTER || key == RETURN)) {
      if (!animandoSalidaLiquidacion) {
        confirmarLiquidacionRonda();
      }
      return;
    }
    if (keyPressedQTE()) return;

    if (key == ' ' && jefeActivo == 3 && !rondaCompletada) {
      verificarCartaActualJefe3();
      return;
    }

    if ((modoFeriaActivo || modoExposicionActivo) && !qteActivo && mensajeActivo >= 0 && !cardEntrando && msgCategoriaEspecial[mensajeActivo] != 4 && !(msgCategoriaEspecial[mensajeActivo] == 2 && msgNivelEncriptado[mensajeActivo] > 0.0)) {
      if (key == CODED && keyCode == RIGHT) {
        iniciarSalidaSwipe(0, 26, 0);
        return;
      } else if (key == CODED && keyCode == LEFT) {
        iniciarSalidaSwipe(1, -26, 0);
        return;
      }
    }
  }

  if (estadoPantalla == PANTALLA_TIENDA && keyPressedTutorialTienda()) {
    return;
  }

  if (estadoPantalla == PANTALLA_CINEMATICA_FINAL || estadoPantalla == PANTALLA_HABITACION || estadoPantalla == PANTALLA_GLITCH_ESCAPE) {
    keyPressedEpilogo();
    return;
  }

  if (key == 'm' || key == 'M') {
    if (estadoPantalla == 5 && !quemandoDificultad) {
      reproducirTap();
      reproducirSFX(sonidoGeneracionBurn);
      seleccionadoParaJugar = false;
      quemandoDificultad = true;
      progresoQuemarDificultad = 0.0;
    } else {
      if (estadoPantalla == 2 || estadoPantalla == 3) {
        reproducirTap();
        volverAlMenuPrincipal();
      }
    }
  }
}

void keyReleased() {
  if (key == 'f' || key == 'F') {
    teclaSaltarEscenaPresionada = false;
    progresoHoldSaltoEscena = 0.0;
  }
  if (estadoPantalla == PANTALLA_HABITACION) {
    keyReleasedEpilogo();
  }
  if (animandoShowcaseDirectiva && (key == ' ' || key == ENTER || key == RETURN)) {
    presionandoHoldShowcase = false;
  }
}
