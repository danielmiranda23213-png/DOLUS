float progresoLinkStart = 0.0;
boolean ejecutandoLinkStart = false;
int totalBitsTunel = 260;
boolean bitsTunelInicializado = false;
int ultimoMillisTransicion = 0;

float[] bitAngulo;
float[] bitZ;
float[] bitVelocidadZ;
char[] bitValor;
int[] bitSentido;
float[] bitGrosorGiro;
float[] bitRadioOrbita;
float[] bitFaseOrbita;

float[] tamanoArr;
float[] xArr;
float[] yArr;
float[] alphaArr;
float[] proximidadArr;
int[] bIdxArr;
int[] ordenArr;
int[] conteoBucket;
int numBuckets = 12;

boolean ejecutandoCargaNexus = false;
int faseCargaNexus = 0;
float progresoBarraNexus = 0.0;
float tiempoFaseMensaje = 0.0;
float alphaCrossfadeLluvia = 0.0;
int ultimoMillisNexus = 0;

boolean ejecutandoPantallaCargaMeta = false;
float alphaPantallaCargaMeta = 0.0;
int tiempoInicioCargaMeta = 0;
boolean pluginsPrecargadosMeta = false;

boolean terminalHackerInicializada = false;
String[] lineasCodigoPlantilla = {
  "struct group_info init_groups = { .usage = ATOMIC_INIT(2) };",
  "struct group_info *groups_alloc(int gidsetsize) {",
  "    struct group_info *group_info;",
  "    int nblocks;",
  "    int i;",
  "    nblocks = (gidsetsize + NGROUPS_PER_BLOCK - 1) / NGROUPS_PER_BLOCK;",
  "    /* Make sure we always allocate at least one indirect block pointer */",
  "    nblocks = nblocks ? : 1;",
  "    group_info = kmalloc(sizeof(*group_info) + nblocks*sizeof(gid_t *), GFP_USER);",
  "    if (!group_info)",
  "        return NULL;",
  "    group_info->ngroups = gidsetsize;",
  "    group_info->nblocks = nblocks;",
  "    atomic_set(&group_info->usage, 1);",
  "    if (gidsetsize <= NGROUPS_SMALL)",
  "        group_info->blocks[0] = group_info->small_block;",
  "    else {",
  "        for (i = 0; i < nblocks; i++) {",
  "            gid_t *b;",
  "            b = (void *)__get_free_page(GFP_USER);",
  "            if (!b)",
  "                goto out_undo_partial_alloc;",
  "            group_info->blocks[i] = b;",
  "        }",
  "    }",
  "    return group_info;",
  "out_undo_partial_alloc:",
  "    while (--i >= 0) {",
  "        free_page((unsigned long)group_info->blocks[i]);",
  "    }",
  "    kfree(group_info);",
  "    return NULL;",
  "}",
  "EXPORT_SYMBOL(groups_alloc);",
  "void groups_free(struct group_info *group_info) {",
  "    if (group_info->blocks[0] != group_info->small_block) {",
  "        int i;",
  "        for (i = 0; i < group_info->nblocks; i++)"
};

String[] listaErroresRojos = {
  "ERROR CRITICO: NO SE PUDO COMPLETAR EL PROCESO",
  "ERROR CRITICO: SEGURIDAD COMPROMETIDA",
  "ERROR CRITICO: USUARIO NO AUTORIZADO",
  "ERROR CRITICO: RED ILICITA",
  "ERROR CRTICO: INTENTO DE ACCESO NO PERMITIDO DETECTADO",
  "ERROR CRTICO: VIOLACIN DE PROTOCOLO DE SEGURIDAD",
  "ERROR CRTICO: INTEGRIDAD DEL SISTEMA COMPROMETIDA",
  "ERROR CRTICO: CORTAFUEGOS EXPUESTO A AMENAZA EXTERNA",
  "ERROR CRTICO: FIRMA DIGITAL INVLIDA O CADUCADA"
};

String[] consolaTexto = new String[128];
boolean[] consolaEsError = new boolean[128];
boolean[] consolaEsPrimerError = new boolean[128];
int numLineasConsola = 0;

void agregarLineaConsola(String t, boolean err, boolean primerErr) {
  if (numLineasConsola < 128) {
    consolaTexto[numLineasConsola] = t;
    consolaEsError[numLineasConsola] = err;
    consolaEsPrimerError[numLineasConsola] = primerErr;
    numLineasConsola++;
  }
}

void eliminarPrimeraLineaConsola() {
  if (numLineasConsola <= 0) return;
  for (int i = 0; i < numLineasConsola - 1; i++) {
    consolaTexto[i] = consolaTexto[i + 1];
    consolaEsError[i] = consolaEsError[i + 1];
    consolaEsPrimerError[i] = consolaEsPrimerError[i + 1];
  }
  numLineasConsola--;
}

int maxLineasVisiblesConsola = 50;
int indicePlantillaActual = 0;
int caracteresLineaActual = 0;
int ultimoTiempoEscrituraHacker = 0;
int intervaloEscrituraHacker = 0;
int ultimoTiempoSonidoEscrituraHacker = -1000;

float tiempoDuracionTerminal = 0.0;
float duracionTotalTerminalSec = 7.5;

boolean modoAlarmaError = false;
boolean primerErrorGenerado = false;
boolean efectoLupaActivo = false;
float tiempoInicioLupa = 0.0;
float duracionLupa = 2.2;
int indiceLineaPrimerError = -1;
int indiceErrorRojoActual = 0;

float alphaGradienteEntrada = 0.0;

float[] cuadroErrX = new float[512];
float[] cuadroErrY = new float[512];
float[] cuadroErrW = new float[512];
float[] cuadroErrH = new float[512];
float[] cuadroErrTamFuente = new float[512];
int numCuadrosError = 0;
int ultimoTiempoCuadroPop = 0;

void reiniciarBitTunel(int i) {
  bitAngulo[i] = random(TWO_PI);
  bitZ[i] = random(300, 1200);
  bitVelocidadZ[i] = random(18, 38);
  if (random(1) > 0.5) {
    bitValor[i] = '1';
  } else {
    bitValor[i] = '0';
  }
  if (random(1) > 0.5) {
    bitSentido[i] = 1;
  } else {
    bitSentido[i] = -1;
  }
  bitGrosorGiro[i] = random(0.8, 1.2);
  bitRadioOrbita[i] = random(0.75, 1.6);
  bitFaseOrbita[i] = random(TWO_PI);
}

void iniciarTransicionLinkStart() {
  ejecutandoLinkStart = true;
  progresoLinkStart = 0.0;
  ultimoMillisTransicion = millis();
  reproducirSFX(sonidoAbsorcionTransicionVortice);

  if (!bitsTunelInicializado) {
    bitAngulo = new float[260];
    bitZ = new float[260];
    bitVelocidadZ = new float[260];
    bitValor = new char[260];
    bitSentido = new int[260];
    bitGrosorGiro = new float[260];
    bitRadioOrbita = new float[260];
    bitFaseOrbita = new float[260];

    tamanoArr = new float[260];
    xArr = new float[260];
    yArr = new float[260];
    alphaArr = new float[260];
    proximidadArr = new float[260];
    bIdxArr = new int[260];
    ordenArr = new int[260];
    conteoBucket = new int[12];

    for (int i = 0; i < totalBitsTunel; i++) {
      reiniciarBitTunel(i);
    }
    bitsTunelInicializado = true;
  } else {
    for (int i = 0; i < totalBitsTunel; i++) {
      reiniciarBitTunel(i);
    }
  }
}

void dibujarHorizonteSucesosOrganico(float radioBase, color colBase, float cx, float cy) {
  noStroke();

  float pulsacion = sin(ztiempo * 2.2) * 0.035 + 1.0;
  radioBase *= pulsacion;

  fill(0, 245);
  ellipse(cx, cy, radioBase * 1.55, radioBase * 1.55);

  int pasos = 100;
  beginShape(QUAD_STRIP);

  for (int i = 0; i <= pasos; i++) {
    float ang = (TWO_PI / pasos) * i;
    float xSemilla = cos(ang) * radioBase;
    float ySemilla = sin(ang) * radioBase;

    float warpX = noise(xSemilla * 0.008, ySemilla * 0.008, ztiempo * 0.9) * 60.0;
    float warpY = noise(xSemilla * 0.008 + 900, ySemilla * 0.008 + 900, ztiempo * 0.9) * 60.0;

    float ruidoGrueso = noise((xSemilla + warpX) * 0.01, (ySemilla + warpY) * 0.01, ztiempo * 1.5);
    float ruidoFino = noise((xSemilla + warpX) * 0.05, (ySemilla + warpY) * 0.05, ztiempo * 3.0);

    float flicker = ruidoGrueso * 0.65 + ruidoFino * 0.35;

    float radioInterno = radioBase * (0.88 + flicker * 0.16);
    float radioExterno = radioBase * (1.08 + flicker * 0.52);

    color colCaliente = lerpColor(colBase, color(255, 255, 230), constrain(flicker * 1.35, 0, 1));

    fillConAlpha(colCaliente, 225);
    vertex(cx + cos(ang) * radioInterno, cy + sin(ang) * radioInterno);

    fillConAlpha(colCaliente, 0);
    vertex(cx + cos(ang) * radioExterno, cy + sin(ang) * radioExterno);
  }

  endShape();
}

void actualizarYDibujarTransicion() {
  int ahora = millis();
  float deltaFactor = (ahora - ultimoMillisTransicion) / 16.6667;
  deltaFactor = constrain(deltaFactor, 0, 4);
  ultimoMillisTransicion = ahora;

  progresoLinkStart += 0.010 * deltaFactor;
  ztiempo += 0.12 * deltaFactor;

  float progreso = constrain(progresoLinkStart, 0, 1);

  float entrada = constrain(progreso / 0.32, 0, 1);
  float succion = constrain((progreso - 0.18) / 0.62, 0, 1);
  float colapso = constrain((progreso - 0.68) / 0.32, 0, 1);

  entrada = 1.0 - pow(1.0 - entrada, 3.0);
  succion = pow(succion, 2.7);
  colapso = pow(colapso, 3.2);

  intensidadSuccionFondo = constrain(entrada * 0.18 + succion * 0.82, 0, 1);

  pushStyle();

  rectMode(CENTER);
  textAlign(CENTER, CENTER);

  float vibracionBase = pow(succion, 2.8) * 2.2;
  float vibracionFinal = pow(colapso, 4.0) * 7.0;
  float intensidadVibracion = vibracionBase + vibracionFinal;

  float vibNoiseX = noise(ztiempo * 3.1, 10.0) - 0.5;
  float vibNoiseY = noise(20.0, ztiempo * 3.1) - 0.5;

  float cx = width / 2.0 + vibNoiseX * 2.0 * intensidadVibracion;
  float cy = height / 2.0 + vibNoiseY * 2.0 * intensidadVibracion;

  noStroke();

  float oscurecimiento = constrain(entrada * 70.0 + succion * 150.0 + colapso * 45.0, 0, 245);
  fill(0, oscurecimiento);
  rect(width / 2.0, height / 2.0, width, height);

  color colBit = colorBitTunel();

  float radioHorizonteEntrada = pow(entrada, 1.35) * 55.0;
  float radioHorizonteSuccion = pow(succion, 0.72) * 285.0;
  float radioHorizonte;

  if (progreso < 0.18) {
    radioHorizonte = radioHorizonteEntrada;
  } else {
    if (progreso < 0.32) {
      float mezclaHorizonte = constrain((progreso - 0.18) / 0.14, 0, 1);
      radioHorizonte = lerp(radioHorizonteEntrada, radioHorizonteSuccion, mezclaHorizonte);
    } else {
      radioHorizonte = radioHorizonteSuccion;
    }
  }

  float reduccionFinal = 1.0 - colapso * 0.92;
  radioHorizonte *= reduccionFinal;

  if (radioHorizonte > 1) {
    dibujarHorizonteSucesosOrganico(radioHorizonte, colBit, cx, cy);
  }

  if (bitsTunelInicializado) {
    if (fuenteRetro != null) {
      textFont(fuenteRetro);
    }

    float factorVelocidad = 0.32 + pow(succion, 2.4) * 4.2;
    float factorGiro = 1.0 + pow(succion, 2.2) * 5.0;

    float extensionPantalla = max(width, height) * 0.72;

    for (int i = 0; i < numBuckets; i++) {
      conteoBucket[i] = 0;
    }

    for (int i = 0; i < totalBitsTunel; i++) {
      bitZ[i] -= bitVelocidadZ[i] * factorVelocidad * deltaFactor;

      float proximidadVel = constrain(map(bitZ[i], 1200, 20, 0.0, 1.0), 0, 1);
      float aceleracionAngular = pow(proximidadVel, 2.4);
      float velocidadAngular = (0.006 + aceleracionAngular * 0.18) * factorGiro * bitGrosorGiro[i];

      bitAngulo[i] += velocidadAngular * bitSentido[i] * deltaFactor;
      bitFaseOrbita[i] += 0.015 * factorGiro * bitSentido[i] * deltaFactor;

      if (bitZ[i] <= 20) {
        reiniciarBitTunel(i);
        bitZ[i] = 1200;
      }

      float proximidad = constrain(map(bitZ[i], 1200, 20, 0.0, 1.0), 0, 1);
      float profundidad = pow(proximidad, 1.35);
      float k = 420.0 / max(bitZ[i], 30.0);

      float radioLejano = lerp(extensionPantalla, 70.0, profundidad);
      float radioOrbital = radioLejano * k * bitRadioOrbita[i];

      float intensidadCurva = pow(succion, 1.7);
      float curva = sin(bitAngulo[i] * 1.8 + bitFaseOrbita[i]) * radioOrbital * 0.18 * intensidadCurva;
      float anguloCurvado = bitAngulo[i] + sin(profundidad * PI) * 0.85 * bitSentido[i] * intensidadCurva;

      float xOrbital = cos(anguloCurvado) * radioOrbital;
      float yOrbital = sin(anguloCurvado) * radioOrbital;

      xOrbital += -sin(anguloCurvado) * curva;
      yOrbital += cos(anguloCurvado) * curva;

      float factorConvergencia = 1.0 - pow(succion, 1.8) * 0.72;
      factorConvergencia = max(factorConvergencia, 0.18);
      factorConvergencia *= 1.0 - pow(colapso, 2.2);

      xOrbital *= factorConvergencia;
      yOrbital *= factorConvergencia;

      float tamano = constrain(map(bitZ[i], 1200, 20, 7, 44), 6, 48);
      tamano *= 1.0 - pow(colapso, 1.6) * 0.85;
      tamano = max(tamano, 2);

      float alpha = constrain(map(bitZ[i], 1200, 150, 15, 255), 0, 255);
      alpha *= 1.0 - pow(colapso, 1.4);

      xArr[i] = cx + xOrbital;
      yArr[i] = cy + yOrbital;
      tamanoArr[i] = tamano;
      alphaArr[i] = alpha;
      proximidadArr[i] = proximidad;

      int bIdx = (int)((tamano - 6) / 4);
      if (bIdx < 0) {
        bIdx = 0;
      } else {
        if (bIdx >= numBuckets) {
          bIdx = numBuckets - 1;
        }
      }
      bIdxArr[i] = bIdx;
      conteoBucket[bIdx]++;
    }

    int[] inicioBucket = new int[12];
    int acumulado = 0;
    for (int i = 0; i < numBuckets; i++) {
      inicioBucket[i] = acumulado;
      acumulado += conteoBucket[i];
    }

    int[] cursorBucket = new int[12];
    for (int i = 0; i < numBuckets; i++) {
      cursorBucket[i] = inicioBucket[i];
    }

    for (int i = 0; i < totalBitsTunel; i++) {
      int bIdx = bIdxArr[i];
      ordenArr[cursorBucket[bIdx]] = i;
      cursorBucket[bIdx]++;
    }

    int tamanoActual = -1;

    for (int j = 0; j < totalBitsTunel; j++) {
      int idx = ordenArr[j];
      int tamanoRedondeado = 6 + bIdxArr[idx] * 4;

      if (tamanoRedondeado != tamanoActual) {
        textSize(tamanoRedondeado);
        tamanoActual = tamanoRedondeado;
      }

      float glowAlpha = alphaArr[idx] * (0.18 + succion * 0.22);
      fillConAlpha(colBit, glowAlpha);
      text(bitValor[idx], xArr[idx] + random(-0.8, 0.8), yArr[idx] + random(-0.8, 0.8));

      if (proximidadArr[idx] > 0.72) {
        float mezcla = map(proximidadArr[idx], 0.72, 1.0, 0, 1);
        fill(lerpColor(colBit, color(255), mezcla), alphaArr[idx]);
      } else {
        fill(colBit, alphaArr[idx]);
      }

      text(bitValor[idx], xArr[idx], yArr[idx]);
    }
  }

  float tamanoNucleo = lerp(1.0, 0.08, colapso);
  float nucleo = max(radioHorizonte * 0.42 * tamanoNucleo, 3);

  noStroke();
  fill(0, 255);
  ellipse(cx, cy, nucleo, nucleo);

  float anilloFinal = pow(colapso, 2.2);

  if (anilloFinal > 0.01) {
    noFill();
    strokeConAlpha(colBit, 170 * anilloFinal);
    strokeWeight(2.0 + 4.0 * anilloFinal);

    float radioPulso = lerp(25, 8, colapso);
    ellipse(cx, cy, radioPulso, radioPulso);
  }

  if (progreso >= 0.82) {
    float flashProgreso = constrain((progreso - 0.82) / 0.18, 0, 1);
    float alphaFlash = sin(flashProgreso * PI) * 145;

    noStroke();
    fill(255, 255, 255, alphaFlash);
    rect(width / 2.0, height / 2.0, width, height);
  }

  if (progresoLinkStart >= 1.0) {
    ejecutandoLinkStart = false;
    progresoLinkStart = 0.0;
    intensidadSuccionFondo = 0.0;
    estadoPantalla = PANTALLA_TRANSICION;
    iniciarCargaNexus();
  }

  popStyle();
}

void iniciarCargaNexus() {
  ejecutandoCargaNexus = true;
  faseCargaNexus = 0;
  progresoBarraNexus = 0.0;
  tiempoFaseMensaje = 0.0;
  alphaCrossfadeLluvia = 0.0;
  tiempoDuracionTerminal = 0.0;
  alphaGradienteEntrada = 0.0;
  numCuadrosError = 0;
  ultimoTiempoCuadroPop = millis();
  ultimoMillisNexus = millis();

  modoAlarmaError = false;
  primerErrorGenerado = false;
  efectoLupaActivo = false;
  tiempoInicioLupa = 0.0;
  indiceLineaPrimerError = -1;
  indiceErrorRojoActual = 0;

  reproducirSFX(sonidoNexusCargarBarra);

  numLineasConsola = 0;
  indicePlantillaActual = 0;
  caracteresLineaActual = 0;
  ultimoTiempoEscrituraHacker = millis();
  ultimoTiempoSonidoEscrituraHacker = -1000;
  terminalHackerInicializada = true;
}

void actualizarYDibujarCargaNexus() {
  int ahora = millis();
  float deltaFactor = (ahora - ultimoMillisNexus) / 16.6667;
  deltaFactor = constrain(deltaFactor, 0, 4);
  ultimoMillisNexus = ahora;

  pushStyle();

  color colBit = colorBitNexus(modoAlarmaError);
  color colAlarma = colorBitNexus(true);

  if (faseCargaNexus == 0) {
    progresoBarraNexus += 0.011 * deltaFactor;
    progresoBarraNexus = constrain(progresoBarraNexus, 0, 1);

    if (progresoBarraNexus >= 1.0) {
      faseCargaNexus = 1;
      tiempoFaseMensaje = 0.0;
      reproducirSFX(sonidoTransferenciaExitosa);
    }
  } else {
    if (faseCargaNexus == 1) {
      tiempoFaseMensaje += (1.0 / 60.0) * deltaFactor;

      if (tiempoFaseMensaje >= 1.5) {
        faseCargaNexus = 2;
        estadoPantalla = PANTALLA_CARGA;
      }
    } else {
      alphaCrossfadeLluvia += 0.02 * deltaFactor;
      alphaCrossfadeLluvia = constrain(alphaCrossfadeLluvia, 0, 1);

      tiempoDuracionTerminal += (1.0 / 60.0) * deltaFactor;

      if (tiempoDuracionTerminal >= duracionTotalTerminalSec) {
        if (sonidoEscritura != null) sonidoEscritura.stop();
        ejecutandoCargaNexus = false;
        ejecutandoPantallaCargaMeta = true;
        alphaPantallaCargaMeta = 0.0;
      }

      if (!primerErrorGenerado && tiempoDuracionTerminal >= 1.8) {
        primerErrorGenerado = true;
        efectoLupaActivo = true;
        tiempoInicioLupa = tiempoDuracionTerminal;

        reproducirSFX(sonidoDisrupcion1);

        String txtErrorInicial = "ERROR CRITICO: NO SE PUDO VERIFICAR LA SESION";
        agregarLineaConsola(txtErrorInicial, true, true);
        indiceLineaPrimerError = numLineasConsola - 1;

        caracteresLineaActual = 0;
      }

      boolean estaEnPausaLupa = false;
      if (efectoLupaActivo) {
        float duracionTranscurridosLupa = tiempoDuracionTerminal - tiempoInicioLupa;
        if (duracionTranscurridosLupa < duracionLupa) {
          estaEnPausaLupa = true;
        } else {
          efectoLupaActivo = false;
          modoAlarmaError = true;
          reproducirSFX(sonidoDisrupcion2);
        }
      }

      int incrementoChars = 32;

      if (estaEnPausaLupa) {
        incrementoChars = 3;
      } else {
        if (modoAlarmaError) {
          incrementoChars = 110;
        }
      }

      if (incrementoChars > 0 && millis() - ultimoTiempoEscrituraHacker >= intervaloEscrituraHacker) {
        ultimoTiempoEscrituraHacker = millis();

        if (sonidoEscritura != null && (!sonidoEscritura.isPlaying() || millis() - ultimoTiempoSonidoEscrituraHacker >= 780)) {
          reproducirSFX(sonidoEscritura);
          ultimoTiempoSonidoEscrituraHacker = millis();
        }

        String lineaObjetivo;
        boolean esMsgError = false;

        if (modoAlarmaError) {
          if (random(1) < 0.35) {
            lineaObjetivo = lineasCodigoPlantilla[indicePlantillaActual];
            indicePlantillaActual = (indicePlantillaActual + 1) % contarTextos(lineasCodigoPlantilla);
            esMsgError = false;
          } else {
            lineaObjetivo = listaErroresRojos[indiceErrorRojoActual];
            indiceErrorRojoActual = (indiceErrorRojoActual + 1) % contarTextos(listaErroresRojos);
            esMsgError = true;
          }
        } else {
          lineaObjetivo = lineasCodigoPlantilla[indicePlantillaActual];
          indicePlantillaActual = (indicePlantillaActual + 1) % contarTextos(lineasCodigoPlantilla);
          esMsgError = false;
        }

        caracteresLineaActual += incrementoChars;

        if (caracteresLineaActual >= lineaObjetivo.length()) {
          agregarLineaConsola(lineaObjetivo, esMsgError, false);
          caracteresLineaActual = 0;

          maxLineasVisiblesConsola = ceil(height / 22.0) + 2;
          if (numLineasConsola > maxLineasVisiblesConsola || numLineasConsola >= 128) {
            eliminarPrimeraLineaConsola();
            if (indiceLineaPrimerError > 0) {
              indiceLineaPrimerError--;
            }
          }
        }
      }

      if (modoAlarmaError) {
        float progresoFalla = map(tiempoDuracionTerminal, 4.0, duracionTotalTerminalSec, 0.0, 1.0);
        progresoFalla = constrain(progresoFalla, 0.0, 1.0);

        if (progresoFalla > 0.0) {
          int intervaloPop = (int)(map(progresoFalla, 0.0, 1.0, 120, 15));
          if (millis() - ultimoTiempoCuadroPop >= intervaloPop) {
            ultimoTiempoCuadroPop = millis();

            int cantidadAGenerar = (int)(map(progresoFalla, 0.0, 1.0, 1, 6));
            for (int k = 0; k < cantidadAGenerar; k++) {
              float tf = random(32, 110);
              float w = tf * 4.2 + random(40, 120);
              float h = tf * 1.5 + random(20, 50);
              float x = random(w/2, width - w/2);
              float y = random(h/2, height - h/2);

              if (numCuadrosError < 512) {
                cuadroErrX[numCuadrosError] = x;
                cuadroErrY[numCuadrosError] = y;
                cuadroErrW[numCuadrosError] = w;
                cuadroErrH[numCuadrosError] = h;
                cuadroErrTamFuente[numCuadrosError] = tf;
                numCuadrosError++;
              }
              reproducirSFX(sonidoPopupError, 0.65);
            }
          }
        }
      }
    }
  }

  float fondoAlpha = modoAlarmaError ? 130 : 235;
  if (faseCargaNexus == 2) {
    fondoAlpha = lerp(fondoAlpha, modoAlarmaError ? 85 : 100, alphaCrossfadeLluvia);
  }

  rectMode(CORNER);
  noStroke();
  fill(0, fondoAlpha);
  rect(0, 0, width, height);

  if (faseCargaNexus == 2) {
    if (fuenteRetro != null) textFont(fuenteRetro);
    textSize(18);
    textAlign(LEFT, TOP);

    float posX = 20;
    float altoLinea = 22;
    float posY = -altoLinea;

    float yPosPrimerErrorAbs = -1;
    String txtPrimerErrorAbs = "";

    color colCodigo = modoAlarmaError ? colAlarma : colBit;

    for (int i = 0; i < numLineasConsola; i++) {
      float yLineaActual = posY + (i * altoLinea);

      if (consolaEsError[i]) {
        fill(red(colAlarma), green(colAlarma), blue(colAlarma), 255 * alphaCrossfadeLluvia);
      } else {
        fillConAlpha(colCodigo, 220 * alphaCrossfadeLluvia);
      }

      text(consolaTexto[i], posX, yLineaActual);

      if (consolaEsPrimerError[i]) {
        yPosPrimerErrorAbs = yLineaActual;
        txtPrimerErrorAbs = consolaTexto[i];
      }
    }

    String lineaEnProceso = modoAlarmaError ? listaErroresRojos[indiceErrorRojoActual] : lineasCodigoPlantilla[indicePlantillaActual];
    int subIndex = min(caracteresLineaActual, lineaEnProceso.length());
    String textoParcial = lineaEnProceso.substring(0, subIndex);

    float yLineaProceso = posY + (numLineasConsola * altoLinea);

    if (modoAlarmaError) {
      fill(red(colAlarma), green(colAlarma), blue(colAlarma), 255 * alphaCrossfadeLluvia);
    } else {
      fillConAlpha(colBit, 255 * alphaCrossfadeLluvia);
    }

    text(textoParcial, posX, yLineaProceso);

    if ((millis() / 150) % 2 == 0) {
      float anchoParcial = textWidth(textoParcial);
      fillConAlpha(modoAlarmaError ? colAlarma : colBit, 255 * alphaCrossfadeLluvia);
      rect(posX + anchoParcial + 4, yLineaProceso + 2, 10, 18);
    }

    if (efectoLupaActivo && yPosPrimerErrorAbs > 0) {
      pushStyle();
      float durLupaTranscurrida = tiempoDuracionTerminal - tiempoInicioLupa;
      float animLupaProgreso = constrain(durLupaTranscurrida / 0.4, 0, 1);
      animLupaProgreso = 1.0 - pow(1.0 - animLupaProgreso, 3.0);

      float anchoLupaText = textWidth(txtPrimerErrorAbs);
      float xOrigenLupa = posX + anchoLupaText * 0.5;
      float yOrigenLupa = yPosPrimerErrorAbs + 10;

      float xCuadroZoom = width * 0.58;
      float yCuadroZoom = height * 0.42;
      float wCuadroZoom = 680 * animLupaProgreso;
      float hCuadroZoom = 110 * animLupaProgreso;

      stroke(red(colAlarma), green(colAlarma), blue(colAlarma), 220 * animLupaProgreso);
      strokeWeight(2);
      line(xOrigenLupa, yOrigenLupa, xCuadroZoom - wCuadroZoom/2, yCuadroZoom);

      rectMode(CENTER);
      fill(15, 0, 0, 240 * animLupaProgreso);
      stroke(red(colAlarma), green(colAlarma), blue(colAlarma), 255 * animLupaProgreso);
      strokeWeight(3);
      rect(xCuadroZoom, yCuadroZoom, wCuadroZoom, hCuadroZoom, 8);

      if (animLupaProgreso > 0.8) {
        textAlign(CENTER, CENTER);
        textSize(24);
        fill(255, 255, 255, 255 * alphaCrossfadeLluvia);
        text(txtPrimerErrorAbs, xCuadroZoom, yCuadroZoom);
      }
      popStyle();
    }
  }

  if (modoAlarmaError && numCuadrosError > 0) {
    pushStyle();
    if (fuenteRetro != null) textFont(fuenteRetro);
    rectMode(CENTER);
    textAlign(CENTER, CENTER);

    color colAlarmaOscuro = color(red(colAlarma) * 0.7, green(colAlarma) * 0.7, blue(colAlarma) * 0.7);

    for (int i = 0; i < numCuadrosError; i++) {
      fill(0, 250);
      stroke((millis() / 80) % 2 == 0 ? colAlarma : colAlarmaOscuro);
      strokeWeight(3);
      rect(cuadroErrX[i], cuadroErrY[i], cuadroErrW[i], cuadroErrH[i], 6);

      fill(colAlarma);
      textSize(cuadroErrTamFuente[i]);
      text("ERROR", cuadroErrX[i], cuadroErrY[i] - cuadroErrTamFuente[i] * 0.08);
    }
    popStyle();
  }

  if (modoAlarmaError) {
    pushStyle();
    alphaGradienteEntrada = lerp(alphaGradienteEntrada, 1.0, 0.05);

    float pulsoHeartbeat = (sin(ztiempo * 12.0) + 1.0) * 0.5;
    float alphaMax = map(pulsoHeartbeat, 0, 1, 120, 230) * alphaGradienteEntrada;

    int capasGradiente = 18;
    rectMode(CORNER);
    noFill();

    for (int i = 0; i < capasGradiente; i++) {
      float factorGrad = (float)i / capasGradiente;
      float alphaCapa = lerp(alphaMax, 0, factorGrad);
      stroke(red(colAlarma), green(colAlarma), blue(colAlarma), alphaCapa);
      strokeWeight(2);
      rect(i * 2, i * 2, width - (i * 4), height - (i * 4));
    }
    popStyle();
  }

  if (faseCargaNexus == 0) {
    rectMode(CENTER);
    textAlign(CENTER, CENTER);

    if (fuenteTitulo != null) {
      textFont(fuenteTitulo);
    }

    ztiempo += 0.05 * deltaFactor;

    float tamanoTitulo = min(width, height) * 0.14;
    textSize(tamanoTitulo);

    float anchoTexto = textWidth("NEXUS");
    if (anchoTexto > width * 0.85) {
      tamanoTitulo *= (width * 0.85) / anchoTexto;
    }

    float yTitulo = height * 0.36;

    textSize(tamanoTitulo);
    fill(255);
    text("NEXUS", width / 2.0, yTitulo);

    float barraAncho = min(width * 0.62, width - 160);
    float barraAlto = height * 0.045;
    float barraX = width / 2.0 - barraAncho / 2.0;
    float barraY = height * 0.58;

    rectMode(CORNER);
    noFill();
    stroke(colBit);
    strokeWeight(3);
    rect(barraX, barraY, barraAncho, barraAlto, barraAlto * 0.3);

    noStroke();
    fill(0, 180);
    rect(barraX + 4, barraY + 4, barraAncho - 8, barraAlto - 8, barraAlto * 0.25);

    float anchoRelleno = (barraAncho - 8) * progresoBarraNexus;

    if (anchoRelleno > 1) {
      color colRelleno = lerpColor(colBit, color(255), 0.3);
      fill(colRelleno);
      rect(barraX + 4, barraY + 4, anchoRelleno, barraAlto - 8, barraAlto * 0.25);
    }

    if (fuenteRetro != null) {
      textFont(fuenteRetro);
    }

    textAlign(CENTER, CENTER);
    textSize(barraAlto * 0.55);
    fill(255, 230);
    int porcentaje = (int)(progresoBarraNexus * 100);
    text(porcentaje + "%", width / 2.0, barraY + barraAlto + barraAlto * 0.9);
  } else {
    if (faseCargaNexus == 1) {
      rectMode(CENTER);
      float apareceMensaje = constrain(tiempoFaseMensaje / 0.35, 0, 1);
      apareceMensaje = 1.0 - pow(1.0 - apareceMensaje, 3.0);

      if (fuenteRetro != null) {
        textFont(fuenteRetro);
      }

      textAlign(CENTER, CENTER);
      textSize(min(width, height) * 0.055);

      float alphaMensaje = apareceMensaje * 255;

      fillConAlpha(colBit, alphaMensaje * 0.35);
      text("Sistema cargado, Iniciando Transferencia Neuronal", width / 2.0 + 1, height / 2.0 + 1);

      fill(255, alphaMensaje);
      text("Sistema cargado, Iniciando Transferencia Neuronal", width / 2.0, height / 2.0);
    }
  }

  popStyle();
}

void actualizarYDibujarPantallaCargaMeta() {
  pushStyle();

  if (tiempoInicioCargaMeta == 0) {
    tiempoInicioCargaMeta = millis();
    pluginsPrecargadosMeta = false;
    alphaPantallaCargaMeta = 0.0;
  }

  alphaPantallaCargaMeta += 0.03;
  alphaPantallaCargaMeta = constrain(alphaPantallaCargaMeta, 0, 1);

  noStroke();
  fill(0, alphaPantallaCargaMeta * 255);
  rect(0, 0, width, height);

  if (alphaPantallaCargaMeta >= 1.0) {

    if (!pluginsPrecargadosMeta) {
      inicializarSistemaPlugins();
      pluginsPrecargadosMeta = true;
    }

    textAlign(CENTER, CENTER);
    rectMode(CENTER);

    if (fuenteTitulo != null) {
      textFont(fuenteTitulo);
    }
    textSize(min(width, height) * 0.055);
    fill(255, 255, 245, 255);
    text("Fase 1: La metamorfosis", width / 2.0, height / 2.0 - 20);

    if (fuenteRetro != null) {
      textFont(fuenteRetro);
    }
    textSize(16);
    fill(140, 180, 160, 220);
    text("Vires acquirit eundo", width / 2.0, height / 2.0 + 35);

    textAlign(RIGHT, BOTTOM);
    textSize(15);
    fill(200, 220, 210, 150 + sin(frameCount * 0.15) * 100);
    text("Cargando...", width - 50, height - 40);

    int tiempoTranscurrido = millis() - tiempoInicioCargaMeta;
    if (tiempoTranscurrido >= 3500) {
      ejecutandoPantallaCargaMeta = false;
      tiempoInicioCargaMeta = 0;
      fasePluginsActiva = false;
      estadoPantalla = 6;
      abrirDialogoAdmin(0);
    }
  }

  popStyle();
}

boolean ejecutandoCargaJefe = false;
float alphaCargaJefe = 0.0;
int tiempoInicioCargaJefe = 0;
int jefePendiente = 0;

void iniciarCargaJefe(int tipoJefe) {
  ejecutandoCargaJefe = true;
  alphaCargaJefe = 0.0;
  tiempoInicioCargaJefe = 0;
  jefePendiente = tipoJefe;
}

void saltarAdvertenciaJefe() {
  ejecutandoCargaJefe = false;
  tiempoInicioCargaJefe = 0;
  fasePluginsActiva = false;
  mostrandoTutorial = false;
  mostrandoTutorialIngame = false;
  guiaErrorActiva = false;
  estadoPantalla = PANTALLA_TRANSICION;
  conversanteActual = jefePendiente;
  alphaAparicionJimbo = 1.0;
  animandoAparicionChat = false;
  progresoAparicionChat = 1.0;
  if (jefePendiente == 1) construirArbolJefe1(nombreJugador);
  else {
    if (jefePendiente == 2) construirArbolJefe2(nombreJugador);
    else {
      if (jefePendiente == 3) construirArbolJefe3(nombreJugador);
      else {
        if (jefePendiente == 4) construirArbolJefe4(nombreJugador);
      }
    }
  }
  abrirDialogoAdmin(0);
}

void actualizarYDibujarCargaJefe() {
  pushStyle();
  rectMode(CORNER);
  background(4, 6, 8);

  if (tiempoInicioCargaJefe == 0) {
    tiempoInicioCargaJefe = millis();
    if (stingerTransicion != null) reproducirSFX(stingerTransicion);
  }

  alphaCargaJefe += 0.05;
  alphaCargaJefe = constrain(alphaCargaJefe, 0, 1);

  noStroke();
  fill(4, 6, 8);
  rect(0, 0, width, height);

  stroke(255, 50, 50, alphaCargaJefe * 40);
  strokeWeight(1);
  for (int ly = 0; ly < height; ly += 24) {
    line(0, ly, width, ly);
  }

  float glitchY = (frameCount * 14) % height;
  fill(255, 40, 40, alphaCargaJefe * 30);
  noStroke();
  rect(0, glitchY, width, 12);

  float alphaTexto = alphaCargaJefe * 255;
  textAlign(CENTER, CENTER);
  rectMode(CENTER);

  if (fuenteTitulo != null) textFont(fuenteTitulo);
  textSize(42);
  fill(255, 60, 60, alphaTexto);
  text(">>> ADVERTENCIA DE SEGURIDAD <<<", width / 2.0, height / 2.0 - 55);

  stroke(255, 60, 60, alphaTexto * 0.8);
  strokeWeight(2.5);
  line(width * 0.22, height / 2.0 - 24, width * 0.78, height / 2.0 - 24);
  noStroke();

  if (fuenteRetro != null) textFont(fuenteRetro);
  textSize(22);
  fill(240, 245, 240, alphaTexto);
  if (jefePendiente == 1) text("Interceptando Subred: TENDENCIA VIRAL [NEON-V]", width / 2.0, height / 2.0 + 20);
  else {
    if (jefePendiente == 2) text("Interceptando Subred: CAMARA DE ECO [EL HACKER]", width / 2.0, height / 2.0 + 20);
    else {
      if (jefePendiente == 3) text("Interceptando Subred: DESINFORMACION [MR. DEEPFAKE]", width / 2.0, height / 2.0 + 20);
      else {
        if (jefePendiente == 4) text("Interceptando Subred: EL ALGORITMO SUPREMO [ROOT_CORE]", width / 2.0, height / 2.0 + 20);
      }
    }
  }

  textAlign(RIGHT, BOTTOM);
  textSize(15);
  fill(200, 220, 210, (150 + sin(frameCount * 0.20) * 100) * alphaCargaJefe);
  text("Bypassing firewalls... [Clic para saltar]", width - 50, height - 40);

  int tiempoTranscurrido = millis() - tiempoInicioCargaJefe;
  if (tiempoTranscurrido >= 1600) {
    saltarAdvertenciaJefe();
  }
  popStyle();
}
