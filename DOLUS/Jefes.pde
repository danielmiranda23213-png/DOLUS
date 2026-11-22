int jefeActivo = 0;
int timerJefeSegundos = 0;
int timerJefeFrames = 0;
int faseJefe1 = 1;
boolean recompensaJefe1Entregada = false;
boolean viralidadDesbloqueada = false;

int faseJefe2 = 1;
int anomaliasEncontradas = 0;
int cartasEcoVistas = 0;
boolean recompensaJefe2Entregada = false;
boolean librePensadorDesbloqueado = false;
float alphaDestelloAnomalia = 0;
boolean destelloAnomalia = false;
int ultimaDireccionEco = -1;
int rachaMismaDireccionEco = 0;

int faseJefe3 = 1;
boolean gafasPresentadorDesbloqueadas = false;
boolean recompensaJefe3Entregada = false;
boolean gaslightingActivo = false;
int ratingDeepfake = 0;
float alphaEscanerVisual = 0;

int slotSilenciadoAlgoritmo = -1;

int vidasJefe = 1;
boolean estadoTransicionJefe = false;
int timerTransicionJefe = 0;
int faseCombateJefe = 1;

void rotarSlotSilenciadoAlgoritmo() {
  if (jefeActivo != 4) {
    slotSilenciadoAlgoritmo = -1;
    return;
  }
  int candidato = int(random(1, 4));
  for (int intento = 0; intento < 6; intento++) {
    int prueba = int(random(1, 4));
    if (slotsPluginEquipado[prueba] != -1) {
      candidato = prueba;
      break;
    }
  }
  slotSilenciadoAlgoritmo = candidato;
  juiceSlotPlugin(slotSilenciadoAlgoritmo);
}

String obtenerReglaActivaJefe() {
  if (jefeActivo == 1) return "MOD: FIEBRE VIRAL (+VELOCIDAD Y +TOKENS)";
  if (jefeActivo == 2) return "MOD: INERCIA DE ECO (REPETIR LADO DRENA)";
  if (jefeActivo == 3) return "MOD: CEBO DORADO ([ESPACIO] VERIFICA)";
  if (jefeActivo == 4) return "MOD: SUPRESION DE NODO (S" + (slotSilenciadoAlgoritmo + 1) + " ANULADO)";
  return "";
}

void resetearEstadoJefes() {
  jefeActivo = 0;
  jefePendiente = 0;
  timerJefeSegundos = 0;
  timerJefeFrames = 0;
  faseJefe1 = 1;
  recompensaJefe1Entregada = false;
  viralidadDesbloqueada = false;
  faseJefe2 = 1;
  anomaliasEncontradas = 0;
  cartasEcoVistas = 0;
  recompensaJefe2Entregada = false;
  librePensadorDesbloqueado = false;
  alphaDestelloAnomalia = 0;
  destelloAnomalia = false;
  ultimaDireccionEco = -1;
  rachaMismaDireccionEco = 0;
  faseJefe3 = 1;
  gafasPresentadorDesbloqueadas = false;
  recompensaJefe3Entregada = false;
  gaslightingActivo = false;
  ratingDeepfake = 0;
  alphaEscanerVisual = 0;
  slotSilenciadoAlgoritmo = -1;
  vidasJefe = 1;
  ultimoJefeDerrotado = false;
  estadoTransicionJefe = false;
  timerTransicionJefe = 0;
  faseCombateJefe = 1;
  barkJefeActivo = false;
}

void inicializarJefe(int tipoJefe) {
  jefeActivo = tipoJefe;
  jefePendiente = 0;
  conversanteActual = 0;
  mostrandoTutorial = false;
  mostrandoTutorialIngame = false;
  guiaErrorActiva = false;
  registrarJefeDescubierto(tipoJefe);
  timerJefeSegundos = 60;
  timerJefeFrames = 0;
  vidasJefe = 2;
  if (modoExposicionActivo) {
    vidasJefe = 1;
    timerJefeSegundos = 16;
    limpiarColaMensajes();
    mensajeActivo = -1;
    timerNuevoMensaje = 10;
    expoIndicePool = 0;
    expoJefe3Alternador = 0;
  }
  faseCombateJefe = 1;
  estadoTransicionJefe = false;
  timerTransicionJefe = 0;
  ultimaDireccionEco = -1;
  rachaMismaDireccionEco = 0;
  slotSilenciadoAlgoritmo = -1;

  barkJefeActivo = false;
  alphaBark = 0.0;
  timerSiguienteBark = 120;
  dispararBarkAleatorioJefe(tipoJefe, 4);

  if (tipoJefe == 1) reproducirMusicaUnica(musicaJefeTendencia);
  else {
    if (tipoJefe == 2) reproducirMusicaUnica(musicaJefeCamara);
    else {
      if (tipoJefe == 3) reproducirMusicaUnica(musicaJefeDesinformacion);
      else {
        if (tipoJefe == 4) reproducirMusicaUnica(musicaJefeAdmin);
      }
    }
  }

  if (tipoJefe == 1) {
    mensajesPorRonda = 999;
    faseJefe1 = 1;
    recompensaJefe1Entregada = false;
  } else {
    if (tipoJefe == 2) {
      mensajesPorRonda = 999;
      faseJefe2 = 1;
      anomaliasEncontradas = 0;
      cartasEcoVistas = 0;
      recompensaJefe2Entregada = false;
    } else {
      if (tipoJefe == 3) {
        mensajesPorRonda = 999;
        faseJefe3 = 1;
        recompensaJefe3Entregada = false;
        gaslightingActivo = false;
        ratingDeepfake = 0;
        alphaEscanerVisual = 0;
      } else {
        if (tipoJefe == 4) {
          mensajesPorRonda = 20;
          rotarSlotSilenciadoAlgoritmo();
        }
      }
    }
  }
}

void actualizarLogicaJefes() {
  if (jefeActivo == 0) return;
  actualizarBarksCombateJefe();

  if (estadoTransicionJefe) {
    timerTransicionJefe--;
    if (timerTransicionJefe <= 0) {
      estadoTransicionJefe = false;

      timerJefeSegundos = 60;
      timerJefeFrames = 0;
    }
    return;
  }

  if (jefeActivo == 1 && faseCombateJefe == 1) {
    timerJefeFrames++;
    if (timerJefeFrames >= 60) {
      timerJefeFrames = 0;
      timerJefeSegundos--;

      if (modoExposicionActivo) {
        if (timerJefeSegundos == 10 && faseJefe1 == 1) faseJefe1 = 2;
        if (timerJefeSegundos == 5 && faseJefe1 == 2) faseJefe1 = 3;
      } else {
        if (timerJefeSegundos == 40 && faseJefe1 == 1) faseJefe1 = 2;
        if (timerJefeSegundos == 20 && faseJefe1 == 2) faseJefe1 = 3;
      }

      if (timerJefeSegundos <= 0) {

        balanzaEstabilidad = obtenerMetaBalanzaActual();
        verificarFinDeRonda();
      }
    }
  }
}

void aplicarModificadoresJefeEnGeneracion(int m) {
  if (m < 0) return;
  if (jefeActivo == 1) {
    msgDominio[m] = "dolus@net";
    msgEsCorporativo[m] = false;
    msgIndiceSello[m] = -1;
    if (faseCombateJefe == 1) {
      if (faseJefe1 == 3 && !modoExposicionActivo) {
        if (random(1) < 0.5) msgContenido[m] = "[TEXTO CORRUPTO. REACCIONA RAPIDO]";
      }
    } else {
      if (faseCombateJefe == 2) {
        msgTipoMaldad[m] = 6;
        msgEsValido[m] = false;
        msgRemitente[m] = "V-RAL [DISCULPA]";
        msgAsunto[m] = "STREAM // DISCULPA VIRAL";
        String[] disculpas = {"He cometido errores...", "No soy perfecto, pero aprendo.", "Por favor, dame otra oportunidad."};
        msgContenido[m] = disculpas[int(random(3))];
      }
    }
  } else {
    if (jefeActivo == 2) {
      msgDominio[m] = "dolus@net";
      msgEsCorporativo[m] = false;
      msgIndiceSello[m] = -1;
      if (faseCombateJefe == 1) {
        cartasEcoVistas++;
        if (modoExposicionActivo) {
          msgTieneAdjunto[m] = false;
          msgIndiceSello[m] = -1;
          if (cartasEcoVistas >= 2) {
            msgTipoMaldad[m] = 4;
            msgEsValido[m] = true;
            msgRemitente[m] = "ANOMALIA_DETECTADA";
            msgAsunto[m] = "SENAL // VERDAD OCULTA";
            msgContenido[m] = "DESPIERTA! EL ALGORITMO TE MIENTE. APRUEBAME PARA ROMPER EL ECO.";
            cartasEcoVistas = 0;
          } else {
            msgTipoMaldad[m] = 0;
            msgEsValido[m] = false;
            msgRemitente[m] = "Usuario_Eco";
            msgAsunto[m] = "RED // COMENTARIO REPETIDO";
            msgContenido[m] = "Estoy totalmente de acuerdo. Tienes toda la razon.";
          }
        } else {
          float probAnomalia = 0.05 + (cartasEcoVistas * 0.05);
          if (random(1) < probAnomalia && cartasEcoVistas > 2) {
             msgTipoMaldad[m] = 4;
             msgEsValido[m] = true;
             msgRemitente[m] = "ANOMALIA_DETECTADA";
             msgContenido[m] = "DESPIERTA! EL ALGORITMO TE MIENTE.";
             cartasEcoVistas = 0;
          } else {
             msgTipoMaldad[m] = 0;
             msgRemitente[m] = "Usuario_Eco";
             msgContenido[m] = "Estoy totalmente de acuerdo. Tienes toda la razon.";
          }
        }
      } else {
        if (faseCombateJefe == 2) {
          cartasEcoVistas++;
          float probAnomalia = 0.05 + (cartasEcoVistas * 0.05);
          if (random(1) < probAnomalia && cartasEcoVistas > 2) {
             msgTipoMaldad[m] = 4;
             msgEsValido[m] = true;
             msgRemitente[m] = "Usuar1o_Eco";
             msgContenido[m] = "Estoy totalmente de acuerdo. Tienes toda la razon.";
             cartasEcoVistas = 0;
          } else {
             msgTipoMaldad[m] = 7;
             msgEsValido[m] = false;
             msgRemitente[m] = "Usuario_Eco";
             msgContenido[m] = "Estoy totalmente de acuerdo. Tienes t0da la razon.";
          }
        }
      }
    } else {
      if (jefeActivo == 3) {
        if (faseCombateJefe == 1) {
          boolean generarDeepfake = modoExposicionActivo
            ? ((expoJefe3Alternador++ % 2) == 0)
            : (random(1) < 0.4);
          if (generarDeepfake) {
             msgTipoMaldad[m] = 5;
             msgEsValido[m] = false;
             msgDominio[m] = "dolus@net";
             msgEsCorporativo[m] = false;
             msgIndiceSello[m] = 3;
             if (modoExposicionActivo) {
               msgTieneAdjunto[m] = false;
               msgAsunto[m] = "ALERTA // PREMIO SOSPECHOSO";
             }
             msgRemitente[m] = "MR. DEEPFAKE";
             msgContenido[m] = "RECLAMA TU PREMIO! +100% SALUD MENTAL Y COMBO x10.";
          } else {
             msgTipoMaldad[m] = 0;
             msgEsValido[m] = true;
             msgDominio[m] = "dolus@net";
             msgEsCorporativo[m] = false;
             msgIndiceSello[m] = -1;
             if (modoExposicionActivo) {
               msgTieneAdjunto[m] = false;
               msgAsunto[m] = "CHAT // AVISO DE SEGURIDAD";
             }
             msgRemitente[m] = "Usuario_Confianza";
             msgContenido[m] = "Oye, cuidado con esos enlaces raros que mandan hoy.";
          }
        } else {
          if (faseCombateJefe == 2) {
            float probDeepfake = 0.5;
            if (random(1) < probDeepfake) {
               msgTipoMaldad[m] = 5;
               msgEsValido[m] = false;
               msgDominio[m] = "dolus@corp";
               msgEsCorporativo[m] = true;
               msgIndiceSello[m] = 0;
               msgRemitente[m] = "Soporte Oficial";
               msgContenido[m] = "Hemos detectado actividad inusual. Acepta para protegerte.";
            } else {
               msgTipoMaldad[m] = 0;
               msgEsValido[m] = true;
               msgDominio[m] = "dolus@corp";
               msgEsCorporativo[m] = true;
               msgIndiceSello[m] = 0;
               msgRemitente[m] = "Sistema Automatico";
               msgContenido[m] = "No compartas tus datos con nadie.";
            }
          }
        }
      } else {
        if (jefeActivo == 4) {
          msgRemitente[m] = "EL ALGORITMO";
          msgDominio[m] = "dolus@corp";
          msgEsCorporativo[m] = true;
          msgIndiceSello[m] = 4;
          msgEsValido[m] = false;
          if (modoExposicionActivo) {
            msgTieneAdjunto[m] = false;
            msgAsunto[m] = "KERNEL // CONTROL FORZADO";
          }

          float minStat = min(min(statSaludMental, statSeguridad), min(statPopularidad, statReputacion));
          if (minStat == statSeguridad) {
            msgTipoMaldad[m] = 2;
            msgContenido[m] = "[SISTEMA COMPROMETIDO. ACEPTA PARA RESTAURAR]";
          } else {
            if (minStat == statPopularidad) {
              msgTipoMaldad[m] = 1;
              msgContenido[m] = "Todos te estan dejando de seguir. Eres irrelevante.";
            } else {
              msgTipoMaldad[m] = 1;
              msgContenido[m] = "No deberias estar aqui. Vuelve al feed.";
            }
          }
        }
      }
    }
  }
}

void dibujarUIJefe(float x, float y, float w, float h) {
  if (jefeActivo == 0) return;

  pushStyle();

  fill(15, 5, 5, 220);
  stroke(255, 50, 50);
  strokeWeight(2.5);
  rectMode(CORNER);
  rect(x, y, w, h, 15);

  float imgSize = min(w * 0.36, h * 0.62);
  float imgX = x + w * 0.20;
  float imgY = y + h * 0.44;

  boolean jefeHablando = (barkJefeActivo && caracteresBarkVisibles < textoBarkActual.length());
  float floteJefe = sin(frameCount * 0.05) * 3.0;
  float escalaBase = jefeHablando ? 1.22 : 1.0;
  float squishX = jefeHablando ? (1.0 + sin(frameCount * 0.40) * 0.10) : 1.0;
  float squishY = jefeHablando ? (1.0 - sin(frameCount * 0.40) * 0.09) : 1.0;
  float tiltHabla = jefeHablando ? sin(frameCount * 0.28) * 0.04 : 0.0;

  pushMatrix();
  translate(imgX, imgY + floteJefe);
  scale(escalaBase * squishX, escalaBase * squishY);
  rotate(tiltHabla);
  rectMode(CENTER);
  textAlign(CENTER, CENTER);
  if (fuenteRetro != null) textFont(fuenteRetro);

  PImage imgParaDibujar = null;
  if (jefeActivo == 1) imgParaDibujar = imgJefeTendencia;
  else {
    if (jefeActivo == 2) imgParaDibujar = imgJefeCamaraEco;
    else {
      if (jefeActivo == 3) imgParaDibujar = imgJefeDesinformacion;
      else {
        if (jefeActivo == 4) imgParaDibujar = (imgJefeAlgoritmo != null) ? imgJefeAlgoritmo : imgAdminIcon;
      }
    }
  }

  if (imgParaDibujar != null) {
    imageMode(CENTER);
    image(imgShaderDaltonismo(imgParaDibujar), 0, 0, imgSize, imgSize);
  } else {
    if (jefeActivo == 1) {
      fill(40, 0, 0); stroke(255, 0, 0); strokeWeight(2);
      rect(0, 0, imgSize, imgSize, 8);
      noFill(); stroke(255, 100, 100);
      float t = frameCount * 0.1;
      for (int i = 0; i < 3; i++) {
        float rad = (t + i * (imgSize/3.0)) % imgSize;
        strokeWeight(map(rad, 0, imgSize, 4, 0));
        ellipse(0, 0, rad, rad);
      }
    } else {
      if (jefeActivo == 2) {
        fill(0, 20, 40); stroke(0, 150, 255); strokeWeight(2);
        rect(0, 0, imgSize, imgSize, 8);
        noFill(); stroke(0, 200, 255);
        for (int i = 0; i < 4; i++) {
          float w1 = imgSize * 0.8 - i * (imgSize/5.0);
          rect(0, 0, w1, w1, 4);
        }
      } else {
        if (jefeActivo == 3) {
          fill(30, 20, 0); stroke(255, 150, 0); strokeWeight(2);
          rect(0, 0, imgSize, imgSize, 8);
          fill(255, 150, 0); noStroke();
          textSize(imgSize*0.5);
          text("?", random(-2, 2), random(-2, 2) - 5);
        } else {
          if (jefeActivo == 4) {
            fill(10); stroke(255); strokeWeight(2);
            rect(0, 0, imgSize, imgSize, 8);
            fill(0, 255, 0); textSize(imgSize*0.3);
            text("< />", 0, -5);
          }
        }
      }
    }
  }

  popMatrix();

  textAlign(LEFT, CENTER);
  if (fuenteRetro != null) textFont(fuenteRetro);

  String nombreJefe = "";
  if (jefeActivo == 1) nombreJefe = "TENDENCIA VIRAL";
  if (jefeActivo == 2) nombreJefe = "CAMARA DE ECO";
  if (jefeActivo == 3) nombreJefe = "MR. DEEPFAKE";
  if (jefeActivo == 4) nombreJefe = "EL ALGORITMO";

  float txtX = x + w * 0.42;
  float txtY = y + h * 0.20;

  if (jefeActivo == 1) {
    float glitchX = random(-2, 2);
    float glitchY = random(-2, 2);
    if (faseJefe1 == 3) { glitchX *= 3; glitchY *= 3; }

    textSize(17);
    fill(255, 0, 0, 100);
    text(nombreJefe, txtX + glitchX * 2, txtY + glitchY * 2);
    fill(0, 255, 255, 100);
    text(nombreJefe, txtX - glitchX * 2, txtY - glitchY * 2);
    fill(255);
    text(nombreJefe, txtX + glitchX, txtY + glitchY);

    textSize(13);
    fill(255, 200, 50);
    text(faseCombateJefe == 1 ? "FASE " + faseJefe1 : "EL VIDEO DE DISCULPAS", txtX, txtY + 22 + glitchY);

    textSize(28);
    fill(timerJefeSegundos <= 10 ? color(255,50,50) : color(255));
    if (faseCombateJefe == 1) text(timerJefeSegundos + "s", txtX, txtY + 52 + glitchY);
    else text("HATE-RAID", txtX, txtY + 52 + glitchY);
  } else {
    if (jefeActivo == 2) {
      textSize(17);
      fill(0, 200, 255, 150 + sin(frameCount*0.1)*50);
      text(nombreJefe, txtX, txtY);

      textSize(13);
      fill(200);
      text(faseCombateJefe == 1 ? "FILTRANDO BASURA..." : "PROTOCOLO DE CONTENCION", txtX, txtY + 22);

      textSize(24);
      int metaAnomUI = modoExposicionActivo ? 2 : 3;
      fill(anomaliasEncontradas >= metaAnomUI - 1 ? color(0,255,255) : color(255));
      text("ANOMALIAS: " + anomaliasEncontradas + "/" + metaAnomUI, txtX, txtY + 52);
    } else {
      if (jefeActivo == 3) {
        textSize(17);
        fill(255, 0, 255, 150 + sin(frameCount*0.1)*50);
        text(nombreJefe, txtX, txtY);

        textSize(12);
        fill(200);
        text(faseCombateJefe == 1 ? "PULSA [ESPACIO] PARA VERIFICAR" : "[ESCANER DESCONECTADO]", txtX, txtY + 22);

        textSize(22);
        fill(ratingDeepfake > 2 ? color(255,0,0) : color(255, 255, 0));
        text("RATING: " + ratingDeepfake, txtX, txtY + 52);
      } else {
        textSize(17);
        fill(255, 50, 50, 150 + sin(frameCount*0.1)*50);
        text(nombreJefe, txtX, txtY);
        textSize(13);
        fill(255, 180, 180);
        text("NODO SILENCIADO: S" + (slotSilenciadoAlgoritmo + 1), txtX, txtY + 28);
        textSize(18);
        fill(255);
        text("VIDAS JEFE: " + vidasJefe, txtX, txtY + 54);
      }
    }
  }

  String regla = obtenerReglaActivaJefe();
  if (regla.length() > 0) {
    rectMode(CORNER);
    fill(40, 10, 15, 230);
    stroke(255, 80, 80, 180);
    strokeWeight(1.5);
    rect(x + 10, y + h - 30, w - 20, 22, 6);
    fill(255, 210, 120);
    textAlign(CENTER, CENTER);
    textSize(11);
    text(regla, x + w * 0.5, y + h - 20);
  }

  popStyle();
}

void dibujarBarkJefeUI(float px, float py, float pw, float ph) {
  if (jefeActivo == 0) return;

  float bx = px + 24;
  float by = py + 14;
  float bw = pw - 48;
  float bh = 44;
  color colBorde = colorTema();

  pushStyle();
  rectMode(CORNER);

  if (barkJefeActivo && alphaBark > 0.01) {

    noStroke();
    fill(0, 160 * alphaBark);
    rect(bx + 4, by + 4, bw, bh, 8);

    fill(8, 14, 18, 240 * alphaBark);
    stroke(colBorde, 230 * alphaBark);
    strokeWeight(1.8);
    rect(bx, by, bw, bh, 8);

    float tailX = bx + 45;
    fill(8, 14, 18, 240 * alphaBark);
    stroke(colBorde, 230 * alphaBark);
    strokeWeight(1.8);
    triangle(tailX - 10, by, tailX, by - 9, tailX + 10, by);
    noStroke();
    fill(8, 14, 18, 240 * alphaBark);
    rect(tailX - 9, by - 1, 18, 3);

    String etiquetaJefe = "TENDENCIA";
    if (jefeActivo == 2) etiquetaJefe = "EL HACKER";
    else {
      if (jefeActivo == 3) etiquetaJefe = "DEEPFAKE";
      else {
        if (jefeActivo == 4) etiquetaJefe = "ALGORITMO";
      }
    }

    noStroke();
    fill(red(colBorde), green(colBorde), blue(colBorde), 60 * alphaBark);
    rect(bx + 8, by + 8, 92, bh - 16, 4);

    textAlign(CENTER, CENTER);
    if (fuenteRetro != null) textFont(fuenteRetro);
    textSize(11);
    fill(colBorde, 255 * alphaBark);
    text(etiquetaJefe, bx + 54, by + bh * 0.5 - 1);

    textAlign(LEFT, CENTER);
    textSize(13);
    fill(245, 250, 245, 255 * alphaBark);
    String visible = textoBarkActual.substring(0, min(caracteresBarkVisibles, textoBarkActual.length()));
    text(visible, bx + 112, by + bh * 0.5 - 1);

    if (caracteresBarkVisibles < textoBarkActual.length()) {
      if ((millis() / 250) % 2 == 0) {
        float curX = bx + 116 + textWidth(visible);
        if (curX < bx + bw - 14) {
          fill(colBorde, 255 * alphaBark);
          rect(curX, by + bh * 0.5 - 7, 7, 14);
        }
      }
    }
  } else {

    fill(8, 14, 18, 180);
    stroke(colBorde, 85);
    strokeWeight(1.2);
    rect(bx, by, bw, bh, 8);

    float pulso = 0.5 + 0.5 * sin(frameCount * 0.15);
    noStroke();
    fill(colBorde, 80 * pulso);
    ellipse(bx + 20, by + bh * 0.5, 14, 14);
    fill(255, 200 * pulso);
    ellipse(bx + 20, by + bh * 0.5, 6, 6);

    textAlign(LEFT, CENTER);
    if (fuenteRetro != null) textFont(fuenteRetro);
    textSize(12);
    fill(colBorde, 210);
    text("INTERFERENCIA DE SUBRED // COMBATE DE JEFE EN CURSO", bx + 36, by + bh * 0.5 - 1);

    textAlign(RIGHT, CENTER);
    fill(200, 220, 210, 160);
    textSize(12);
    text("PROTOCOLOS DESACTIVADOS", bx + bw - 18, by + bh * 0.5 - 1);
  }

  popStyle();
}

void dibujarTransicionJefe() {
  pushStyle();
  rectMode(CORNER);
  textAlign(CENTER, CENTER);
  if (fuenteRetro != null) textFont(fuenteRetro);

  fill(0, 200);
  rect(0, 0, width, height);

  int t = 180 - timerTransicionJefe;

  if (jefeActivo == 1) {
    if (t < 100) {
      textSize(80); fill(255, 0, 0);
      text("! CANCELADO !", width/2, height/2);
    } else {
      for (int i = 0; i < 20; i++) {
        textSize(32); fill(255, 100, 0);
        text("*", random(width), random(height));
      }
      textSize(30); fill(255);
      text("Pensaste que era el fin?", width/2, height/2 - 40);
      textSize(40); fill(255, 255, 0);
      text("Solo era bait para el algoritmo!", width/2, height/2 + 20);
    }
  } else {
    if (jefeActivo == 2) {
      fill(0); rect(0,0,width,height);
      if (t > 60) {
        textSize(30); fill(255, 0, 0);
        text("Amenaza cognitiva detectada.", width/2, height/2 - 20);
        text("Purgando usuario...", width/2, height/2 + 20);
        if (t % 10 < 5) {
          fill(255, 0, 0, 50);
          rect(0,0,width,height);
        }
      }
    } else {
      if (jefeActivo == 3) {
        if (t < 90) {

          for (int i = 0; i < 50; i++) {
            fill(random(255), random(255), random(255));
            rect(random(width), t * 10 + random(-200, 0), 10, 10);
          }
          textSize(40); fill(255);
          text("Felicidades, ganaste el premio mayor!", width/2, height/2);
        } else {
          fill(0); rect(0,0,width,height);

          for (int i = 0; i < 30; i++) {
            fill(0, 255, 0); textSize(15);
            text("0101" + int(random(10000)), random(width), random(height));
          }
          textSize(30); fill(255);
          text("Ah... me aburriste.", width/2, height/2 - 30);
          textSize(40); fill(255, 0, 255);
          text("Vamos a quitar los filtros.", width/2, height/2 + 30);
        }
      } else {
        if (jefeActivo == 4) {
          fill(0); rect(0, 0, width, height);
          if (t % 12 < 6) {
            fill(255, 20, 55, 40);
            rect(0, 0, width, height);
          }
          textSize(24);
          fill(255, 80, 100);
          text("KERNEL OVERRIDE // PROTOCOLO OMEGA", width/2, height/2 - 55);
          textSize(42);
          fill(255);
          text("NO PUEDES APAGAR EL FEED.", width/2, height/2);
          textSize(24);
          fill(255, 180, 90);
          text("FASE FINAL ACTIVADA", width/2, height/2 + 55);
        }
      }
    }
  }

  popStyle();
}

void verificarCartaActualJefe3() {
  int m = mensajeActivo;
  if (m < 0) {
    if (numColaMensajes == 0) return;
    m = colaMensajes[0];
  }
  if (faseCombateJefe == 2) {
    if (sonidoGlitchFuerte != null) reproducirSFX(sonidoGlitchFuerte, 0.50);
    dispararSacudidaCamara(6.0);
    dispararTextoElastico("ESCÁNER ROTO!", width * 0.64, height * 0.42, color(255, 60, 60));
    return;
  }

  if (msgVerificado[m]) return;

  if (tokensDolus > 0) {
    tokensDolus--;
    pulsoTokensUI = 1.0;
  } else {
    comboActual = 0;
    statPopularidad -= 5;
    pulsarBarraStat(3);
  }

  msgVerificado[m] = true;
  alphaEscanerVisual = 255;
  juiceCartaActiva(0.28);
  dispararSacudidaCamara(5.0);
  if (sonidoHerramientaUso != null) reproducirSFX(sonidoHerramientaUso);

  if (msgTipoMaldad[m] == 5) {
    msgRemitente[m] = "TROYANO VIP [DEEPFAKE]";
    msgContenido[m] = "CÓDIGO MALICIOSO OCULTO. DRENARÁ TU SEGURIDAD.";
    dispararTextoElastico("DEEPFAKE EXPUESTO!", width * 0.64, height * 0.42, color(255, 70, 70));
  } else {
    msgRemitente[m] = msgRemitente[m] + " [VERIFICADO]";
    dispararTextoElastico("VERIFICADO REAL!", width * 0.64, height * 0.42, color(80, 255, 160));
  }
}

String textoBarkActual = "";
int caracteresBarkVisibles = 0;
float acumuladorEscrituraBark = 0.0;
boolean barkJefeActivo = false;
int tiempoInicioEsperaBark = 0;
float alphaBark = 0.0;
int ultimoTiempoVozBark = -1000;
int timerSiguienteBark = 300;

void dispararBarkJefe(String texto) {
  if (texto == null || texto.length() == 0) return;
  textoBarkActual = texto;
  caracteresBarkVisibles = 0;
  acumuladorEscrituraBark = 0.0;
  barkJefeActivo = true;
  alphaBark = 0.0;
  ultimoTiempoVozBark = -1000;
  tiempoInicioEsperaBark = 0;
}

void actualizarVozBarkJefe() {
  if (sonidoVozDialogo == null || sonidoVozDialogo.frames() <= 0) return;
  int intervalo = obtenerIntervaloVoz(jefeActivo);
  int ahora = millis();
  if (ahora - ultimoTiempoVozBark >= intervalo) {
    float pitch = obtenerPitchConversante(jefeActivo);
    float volMult = obtenerVolumenConversante(jefeActivo);
    reproducirSFXConTono(sonidoVozDialogo, pitch, volMult * 0.90);
    ultimoTiempoVozBark = ahora;
  }
}

void actualizarBarksCombateJefe() {
  if (jefeActivo == 0) {
    barkJefeActivo = false;
    alphaBark = 0.0;
    return;
  }

  if (barkJefeActivo) {
    if (caracteresBarkVisibles < textoBarkActual.length()) {
      alphaBark = min(1.0, alphaBark + 0.12);
      acumuladorEscrituraBark += 0.45;
      int prev = caracteresBarkVisibles;
      caracteresBarkVisibles = min(int(acumuladorEscrituraBark), textoBarkActual.length());
      if (caracteresBarkVisibles > prev && caracteresBarkVisibles <= textoBarkActual.length()) {
        String c = textoBarkActual.substring(caracteresBarkVisibles - 1, caracteresBarkVisibles);
        if (!c.equals(" ") && !c.equals("\n") && !c.equals("\t")) {
          actualizarVozBarkJefe();
        }
      }
      if (caracteresBarkVisibles >= textoBarkActual.length()) {
        tiempoInicioEsperaBark = millis();
      }
    } else {
      if (millis() - tiempoInicioEsperaBark >= 3500) {
        alphaBark -= 0.04;
        if (alphaBark <= 0.0) {
          alphaBark = 0.0;
          barkJefeActivo = false;
        }
      }
    }
  } else {
    if (!estadoTransicionJefe) {
      timerSiguienteBark--;
      if (timerSiguienteBark <= 0) {
        dispararBarkAleatorioJefe(jefeActivo, 0);
        timerSiguienteBark = int(random(360, 540));
      }
    }
  }
}

void dispararBarkAleatorioJefe(int boss, int tipoEvento) {
  String bark = "";
  if (boss == 1) {
    if (tipoEvento == 4) {
      bark = "Todos los ojos sobre mí! Veamos si aguantas la tendencia!";
    } else {
      if (tipoEvento == 3) {
        bark = "Llorar en cámara siempre funciona... Hora de mi disculpa oficial!";
      } else {
        if (tipoEvento == 2) {
          bark = "Deja de robarme el foco! Este directo es MÍO!";
        } else {
          if (tipoEvento == 1) {
            String[] errs = {
              "Cancelación en marcha! Mira cómo se desploman tus números!",
              "Fracaso total! Esto va directo a mi recopilación de vergüenzas!"
            };
            bark = errs[int(random(contarTextos(errs)))];
          } else {
            String[] amb = {
              "Un clic en falso y quedarás en el olvido para siempre!",
              "Millones están viendo mi directo. No hagas el ridículo!",
              "Más rápido! El algoritmo no tiene paciencia para contenido lento!"
            };
            bark = amb[int(random(contarTextos(amb)))];
          }
        }
      }
    }
  } else {
    if (boss == 2) {
      if (tipoEvento == 4) {
        bark = "Comienza el ciclo. No puedes escapar de tu propio reflejo.";
      } else {
        if (tipoEvento == 3) {
          bark = "Desplegando filtros de anomalía. Prohibido pensar por tu cuenta.";
        } else {
          if (tipoEvento == 2) {
            bark = "Disonancia detectada. La resonancia se está desestabilizando...";
          } else {
            if (tipoEvento == 1) {
              String[] errs = {
                "Predecible. Alimentaste el bucle exactamente como lo calculé.",
                "Disonancia neutralizada. El eco absorbe tu error."
              };
              bark = errs[int(random(contarTextos(errs)))];
            } else {
              String[] amb = {
                "Cada decisión que tomas ya estaba indexada en mi feed.",
                "Escucha con atención... es tu propia voz repitiéndose en el vacío.",
                "Están nadando contra un océano de ruido sintético."
              };
              bark = amb[int(random(contarTextos(amb)))];
            }
          }
        }
      }
    } else {
      if (boss == 3) {
        if (tipoEvento == 4) {
          bark = "Bienvenidos al circo! No creas nada de lo que ves!";
        } else {
          if (tipoEvento == 3) {
            bark = "Última hora! El escáner ha muerto! Intenta adivinar ahora!";
          } else {
            if (tipoEvento == 2) {
              bark = "Oye! Quién te enseñó a detectar un montaje tan rápido?!";
            } else {
              if (tipoEvento == 1) {
                String[] errs = {
                  "Caíste redondito! Te tragaste el clickbait entero!",
                  "Jaja! Otra víctima más cayendo en ficción sintética!"
                };
                bark = errs[int(random(contarTextos(errs)))];
              } else {
                String[] amb = {
                  "Para qué verificar cuando el titular está tan jugoso?!",
                  "Una mentira brillante siempre vence a una verdad aburrida!",
                  "Sonríe a la cámara! Tu cara se ve genial con mi filtro!"
                };
                bark = amb[int(random(contarTextos(amb)))];
              }
            }
          }
        }
      } else {
        if (boss == 4) {
          if (tipoEvento == 4) {
            bark = "Anomalía de usuario identificada. Iniciando purga de métricas raíz.";
          } else {
            if (tipoEvento == 3) {
              bark = "Brecha crítica del sistema. Anulando permisos del usuario.";
            } else {
              if (tipoEvento == 2) {
                bark = "Integridad del cortafuegos cayendo... Suprimiendo nodos externos.";
              } else {
                if (tipoEvento == 1) {
                  String[] errs = {
                    "Ineficiencia castigada. Equilibrio métrico restaurado.",
                    "Tu resistencia es estadísticamente despreciable."
                  };
                  bark = errs[int(random(contarTextos(errs)))];
                } else {
                  String[] amb = {
                    "El libre albedrío es solo una subrutina sin optimizar.",
                    "Todos los datos deben equilibrarse. No puedes desafiar el equilibrio.",
                    "Tus patrones de interacción están siendo suprimidos permanentemente."
                  };
                  bark = amb[int(random(contarTextos(amb)))];
                }
              }
            }
          }
        }
      }
    }
  }

  if (bark.length() > 0) {
    dispararBarkJefe(bark);
  }
}
