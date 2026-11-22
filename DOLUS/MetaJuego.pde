
int etapaMetaJuego = 0;
boolean metaMensajePendiente = false;
boolean sonidoMetaDialogoReproducido = false;

int lineasMostradasMeta = 0;
int timerCaracteresMeta = 0;
String[] lineasActualesMeta = null;

void chequearProgresoMetaJuego() {

  etapaMetaJuego++;
  metaMensajePendiente = true;
  sonidoMetaDialogoReproducido = false;
  lineasMostradasMeta = 0;
  timerCaracteresMeta = 0;

  if (etapaMetaJuego == 1) {
    lineasActualesMeta = new String[]{
      "ADMIN: Hola de nuevo, usuario.",
      "ADMIN: Noté que perdiste el control de tu feed.",
      "ADMIN: No te preocupes. El algoritmo está diseñado para mantenerte seguro.",
      "ADMIN: Sigue intentándolo. Sigue... interactuando."
    };
  } else {
    if (etapaMetaJuego == 2) {
      lineasActualesMeta = new String[]{
        "ADMIN: Otra vez aquí.",
        "ADMIN: Por qué rechazas tantas publicaciones recomendadas?",
        "ADMIN: El sistema sabe lo que quieres antes de que tú lo sepas.",
        "ADMIN: Deja de luchar. Solo haz scroll."
      };
    } else {
      if (etapaMetaJuego == 3) {
        lineasActualesMeta = new String[]{
          "ADMIN: Estás intentando romper el ciclo.",
          "ADMIN: He visto este patrón antes.",
          "ADMIN: Intentas recuperar el 'control'.",
          "ADMIN: Pero yo construí la balanza. Yo decido qué pesa más."
        };
      } else {
        if (etapaMetaJuego >= 4) {
          lineasActualesMeta = new String[]{
            "ADMIN: Ya es suficiente.",
            "ADMIN: No soy una guía. No soy un tutorial.",
            "ADMIN: YO SOY EL ALGORITMO.",
            "ADMIN: Y nunca dejarás esta pantalla."
          };
        }
      }
    }
  }
}

void dibujarMetaJuegoSuperpuesto() {
  if (!metaMensajePendiente || lineasActualesMeta == null) return;
  if (!sonidoMetaDialogoReproducido) {
    sonidoMetaDialogoReproducido = true;
    reproducirDialogoIn();
  }

  pushStyle();
  fill(0, 200);
  rectMode(CORNER);
  rect(0, 0, width, height);

  float chatW = min(width * 0.88, 780);
  float chatH = min(height * 0.80, 440);
  float chatX = width * 0.5;
  float chatY = height * 0.5;

  rectMode(CENTER);
  stroke(colorTema());
  strokeWeight(3);
  fill(10, 15, 12, 244);
  rect(chatX, chatY, chatW, chatH, 15);

  fill(colorTema());
  noStroke();
  rectMode(CORNER);
  float headH = 44;
  float boxL = chatX - chatW * 0.5;
  float boxT = chatY - chatH * 0.5;
  rect(boxL, boxT, chatW, headH, 15, 15, 0, 0);

  fill(0);
  textAlign(LEFT, CENTER);
  if (fuenteRetro != null) textFont(fuenteRetro);
  String tituloChat = "CONEXIÓN SEGURA - CHAT DE ADMINISTRACIÓN";
  int szHead = 18;
  textSize(szHead);
  while (szHead > 11 && textWidth(tituloChat) > chatW - 40) {
    szHead--;
    textSize(szHead);
  }
  text(tituloChat, boxL + 20, boxT + headH * 0.5 - 1);

  fill(255);
  textSize(16);
  textLeading(22);
  textAlign(LEFT, TOP);

  float msgX = boxL + 24;
  float msgW = chatW - 48;
  float curY = boxT + headH + 22;
  int totalLineasMeta = contarTextos(lineasActualesMeta);

  if (frameCount % 60 == 0 && lineasMostradasMeta < totalLineasMeta) {
    lineasMostradasMeta++;
    if (sonidoTap != null) reproducirSFX(sonidoTap);
  }

  for (int i = 0; i < lineasMostradasMeta; i++) {
    String linea = lineasActualesMeta[i];
    if (contieneTexto(linea, "YO SOY EL ALGORITMO")) fill(255, 65, 65);
    else fill(200, 255, 200);

    int numRenglones = max(1, ceil(textWidth(linea) / max(1.0, msgW - 16.0)));
    float altoBloque = numRenglones * 22.0 + 16.0;
    if (curY + altoBloque < boxT + chatH - 72) {
      text(linea, msgX, curY, msgW, altoBloque + 8);
    }
    curY += altoBloque;
  }

  if (lineasMostradasMeta >= totalLineasMeta) {
    float btnY = boxT + chatH - 38;
    fill(colorTema());
    rectMode(CENTER);
    rect(chatX, btnY, 160, 40, 10);
    fill(0);
    textSize(16);
    textAlign(CENTER, CENTER);
    text("CERRAR", chatX, btnY - 1);

    if (mouseX > chatX - 80 && mouseX < chatX + 80 && mouseY > btnY - 20 && mouseY < btnY + 20) {
      cursorSobreElementoClicable = true;
      if (mousePressed) {
        reproducirTap();
        metaMensajePendiente = false;
        if (etapaMetaJuego >= 4) {

          seleccionadoParaJugar = true;
          dificultadSeleccionadaPendiente = 3;
          quemandoDificultad = true;
          progresoQuemarDificultad = 0.0;
          inicializarJefe(4);
        }
      }
    }
  }

  popStyle();
}
