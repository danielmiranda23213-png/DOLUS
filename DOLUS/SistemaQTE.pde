boolean qteActivo = false;
int qteTipo = 0;
int qteTimer = 0;
int qteTimerMax = 0;

String qteSecuencia = "";
int qteTeclasPulsadas = 0;
float qteX = 0, qteY = 0;
float qteW = 350, qteH = 180;

float qteCursor = 0.0;
float qteSpeed = 0.015;
float qteTargetStart = 0.0;
float qteTargetWidth = 0.15;
int qteDir = 1;

void iniciarQTEMalware() {
  if (qteActivo || mostrandoTutorial) return;
  String chars = "ERQ";
  qteSecuencia = "";
  for (int i = 0; i < 4; i++) {
    int r = int(random(chars.length()));
    qteSecuencia = qteSecuencia + chars.substring(r, r + 1);
  }
  qteTeclasPulsadas = 0;
  qteW = 350;
  qteH = 180;
  qteX = width / 2 - qteW / 2;
  qteY = height / 2 - qteH / 2;
  qteTimerMax = 240;
  qteTimer = qteTimerMax;
  qteActivo = true;
  qteTipo = 0;
}

void iniciarQTEPrecision() {
  if (qteActivo || mostrandoTutorial) return;
  qteCursor = 0.0;
  qteDir = 1;
  qteTargetStart = random(0.2, 0.7);
  qteTargetWidth = 0.15;
  qteTimerMax = 180;
  qteTimer = qteTimerMax;
  qteActivo = true;
  qteTipo = 1;
}

void actualizarYDibujarQTE() {
  if (!qteActivo) return;

  qteTimer--;
  if (qteTimer <= 0) {
    statSeguridad -= 25;
    pulsarBarraStat(1);
    dispararSacudidaCamara(8.0);
    qteActivo = false;
    return;
  }

  pushMatrix();
  pushStyle();
  rectMode(CORNER);
  ellipseMode(CENTER);
  imageMode(CORNER);

  if (qteTipo == 0) {

    fill(0, 200);
    rect(0, 0, width, height);

    translate(qteX, qteY);

    float animQte = 1.0;
    if (qteTimer > qteTimerMax - 15) {
      animQte = map(qteTimer, qteTimerMax, qteTimerMax - 15, 0.0, 1.0);
      animQte = 1.0 - pow(1.0 - animQte, 3);
      scale(animQte);
    }

    fill(20, 20, 25, 230);
    stroke(255, 50, 50);
    strokeWeight(3);
    rect(0, 0, qteW, qteH, 10);

    fill(255, 50, 50);
    textAlign(CENTER, CENTER);
    textSize(24);
    text("MALWARE DETECTADO!", qteW / 2, 30);

    noStroke();
    fill(50);
    rect(20, 60, qteW - 40, 10, 5);
    fill(255, 50, 50);
    float timePct = (float)qteTimer / qteTimerMax;
    rect(20, 60, (qteW - 40) * timePct, 10, 5);

    float keyW = 50;
    float keyH = 50;
    float startX = (qteW - (4 * keyW + 3 * 15)) / 2;
    float keyY = 90;

    for (int i = 0; i < qteSecuencia.length(); i++) {
      float kx = startX + i * (keyW + 15);

      if (i < qteTeclasPulsadas) {
        fill(50, 255, 50);
        stroke(20, 200, 20);
      } else {
        if (i == qteTeclasPulsadas) {
          fill(255, 255, 50);
          stroke(200, 200, 20);
        } else {
          fill(40);
          stroke(100);
        }
      }
      strokeWeight(2);
      rect(kx, keyY, keyW, keyH, 8);

      if (i < qteTeclasPulsadas) {
        fill(0);
      } else {
        fill(255);
      }
      textSize(28);
      text(qteSecuencia.substring(i, i + 1), kx + keyW / 2, keyY + keyH / 2 - 3);
    }
  } else {
    if (qteTipo == 1) {

      float animQte1 = 1.0;
      if (qteTimer > qteTimerMax - 15) {
        animQte1 = map(qteTimer, qteTimerMax, qteTimerMax - 15, 0.0, 1.0);
        animQte1 = 1.0 - pow(1.0 - animQte1, 3);
      }

      pushStyle();
      rectMode(CORNER);
      fill(0, 200 * animQte1);
      rect(0, 0, width, height);
      popStyle();

      pushMatrix();
      translate(width/2, height/2);
      scale(animQte1);
      translate(-width/2, -height/2);

      float barW = width * 0.6;
      float barH = 40;
      float barX = width / 2 - barW / 2;
      float barY = height / 2 - barH / 2;

      fill(255);
      textAlign(CENTER, BOTTOM);
      textSize(24);
      text("PRESIONA ESPACIO EN LA ZONA RESALTADA", width / 2, barY - 20);

      pushMatrix();
      translate(barX, barY);
      fill(20, 20, 25, 230);
      stroke(color(255, 70, 70));
      strokeWeight(2);
      dibujarFormaAngularBase(barW, barH, 10);

      float targetX = qteTargetStart * barW;
      float targetW = qteTargetWidth * barW;

      pushStyle();
      stroke(colorTema());
      strokeWeight(3);
      noFill();

      line(targetX, 0, targetX + 10, 0);
      line(targetX, barH, targetX + 10, barH);
      line(targetX, 0, targetX, barH);

      line(targetX + targetW, 0, targetX + targetW - 10, 0);
      line(targetX + targetW, barH, targetX + targetW - 10, barH);
      line(targetX + targetW, 0, targetX + targetW, barH);

      fill(colorTema(), 150);
      noStroke();
      rect(targetX, 0, targetW, barH);
      popStyle();

      popMatrix();

      qteCursor += qteSpeed * qteDir;
      if (qteCursor > 1 || qteCursor < 0) {
        qteDir *= -1;
        qteCursor = constrain(qteCursor, 0, 1);
      }

      float cursorPosX = barX + qteCursor * barW;

      pushStyle();
      stroke(255);
      strokeWeight(3);
      line(cursorPosX, barY - 15, cursorPosX, barY + barH + 15);

      stroke(colorTema(), 150);
      strokeWeight(8);
      line(cursorPosX, barY - 10, cursorPosX, barY + barH + 10);
      popStyle();

      float timePct = (float)qteTimer / qteTimerMax;
      pushStyle();
      noStroke();
      fill(50);
      rect(width / 2 - 100, barY + barH + 30, 200, 10, 5);
      fill(color(255, 70, 70));
      rect(width / 2 - 100, barY + barH + 30, 200 * timePct, 10, 5);
      popStyle();

      popMatrix();
    }
  }

  popStyle();
  popMatrix();
}

boolean mousePressedQTE() {
  return false;
}

boolean keyPressedQTE() {
  if (!qteActivo) return false;

  if (qteTipo == 0) {
    String expected = qteSecuencia.substring(qteTeclasPulsadas, qteTeclasPulsadas + 1);
    String teclaPulsada = aMayusculaQTE(str(key));
    if (teclaPulsada.equals(expected)) {
      qteTeclasPulsadas++;
      reproducirTap();
      if (qteTeclasPulsadas >= qteSecuencia.length()) {
        statSeguridad += 10;
        pulsarBarraStat(1);
        comboActual += 2;
        pulsoComboUI = 1.0;
        dispararRayoFlourish(width * 0.5, height * 0.45, colorTema(), 0);
        dispararTextoElastico("MALWARE PURGADO!", width * 0.5, height * 0.45, colorTema());
        registrarProgresoLogro(2, 1);
        fijarProgresoMaximoLogro(1, comboActual);
        if (modoFeriaActivo) otorgarPuntosQTEFeria(300);
        qteActivo = false;
      }
    } else {
      qteTimer -= 30;
      dispararSacudidaCamara(5.0);
    }
    return true;
  } else {
    if (qteTipo == 1) {
      if (key == ' ') {
        if (qteCursor >= qteTargetStart && qteCursor <= qteTargetStart + qteTargetWidth) {
          comboActual += 5;
          pulsoComboUI = 1.0;
          dispararRayoFlourish(width * 0.5, height * 0.45, colorTema(), 1);
          dispararTextoElastico("PRECISIÓN +5 COMBO!", width * 0.5, height * 0.45, colorTema());
          registrarProgresoLogro(2, 1);
          fijarProgresoMaximoLogro(1, comboActual);
          if (modoFeriaActivo) otorgarPuntosQTEFeria(300);
          if (sonidoDecisionCorrecta != null) reproducirSFX(sonidoDecisionCorrecta);
          qteActivo = false;
        } else {
          statSeguridad -= 25;
          pulsarBarraStat(1);
          dispararSacudidaCamara(8.0);
          dispararTextoElastico("FALLO DE RED!", width * 0.5, height * 0.45, color(255, 70, 70));
          if (sonidoErrorMsj != null) reproducirSFX(sonidoErrorMsj);
          qteActivo = false;
        }
      }
      return true;
    }
  }
  return false;
}
