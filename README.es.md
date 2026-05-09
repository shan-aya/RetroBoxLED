# 🎮 RetroBoxLED

Firmware **ESP32** para **Recalbox** LED marquee (paneles HUB75/DMD 128x32 P4).

✅ Compatible con Recalbox 10.0.5

---

🌐 [English](README.md) | [Français](README.fr.md) | [Español](README.es.md)

---

## ℹ️ Información

Ya había creado aplicaciones de gestión en C++, C# y VB .Net para proyectos personales y profesionales.
Pero debo admitir que la IA me ayudó mucho a realizar esto en pocos días.
Obviamente no es perfecto. Algunas listas grandes como ARCADE, MAME o FBNEO tardan bastante en mostrar una imagen. Por eso dejo este proyecto abierto a todos, a la espera de que alguien lo mejore.

## ✨ Funcionalidades

- **Reproducción de GIFs** : Reproduce GIFs y PNGs (`/Arcade`, `/BEST_OF_TOP_30`, `/Pixel_Art`, etc.)
- **Fallback** : `/systems/_defaults/_default.png`
- **Listas de reproducción** : `Arcade.txt`, `Favoritos.txt`, `Consolas.txt`
- **MQTT** : Eventos de EmulationStation (`rungame`, `shutdown`, etc.)
- **Recalbox** : Modo Arcade automático

## ⭐ Funcionamiento

Por defecto, el ESP32 reproduce una lista de GIFs.
En cuanto recibe información a través de MQTT, cambia automáticamente al modo ARCADE.
Cuando se apaga la Recalbox, el ESP32 reanuda la reproducción de la lista.
Si falta un GIF o PNG, utilizará el archivo de reemplazo ubicado en `/systems/_defaults`.

## 📁 Estructura de la tarjeta SD

La tarjeta SD debe estar formateada en FAT32 con la siguiente estructura.
Copie la carpeta `_defaults` en el directorio `systems` de su tarjeta SD.

```
RetroBoxLED SD Card/
├── gifs/
│   ├── Arcade/, BEST_OF_TOP_30/, Pixel_Art/   | GIFs
├── systems/
│   ├── mame/, neogeo/, snes/                  | Sistemas
│   │   ├── logo_detoure/, marquee             | Carpetas de imágenes
│   ├── _defaults/                             | Archivos de reemplazo
├── playlists/
│   ├── Arcade.txt, Favoritos.txt, Consolas.txt
```

## 🚀 Instalación

Antes de usar, siga estos pasos en orden:

1. **Configuración** : Configurar el archivo `config.ini`
2. **Listas de reproducción** : Crear sus listas de reproducción
3. **Herramientas** : Usar los scripts disponibles
4. **Flash** : Flashear el firmware del ESP32
5. **MQTT** : Entender el funcionamiento de MQTT
6. **Telnet** : Terminal Telnet para pruebas

---

## 1 - ⚙️ Configuración

El archivo `config.ini` debe estar en la raíz de la tarjeta SD.
Permite configurar los siguientes parámetros:

```ini
# Información
info=0                      # 0 = sin info al arrancar, 1 = mostrar info al arrancar

# Lista de reproducción
playlist=TODO.txt           # Reproduce la lista indicada en /playlist
random=1                    # 0 = reproducción en orden, 1 = reproducción aleatoria

# Wi-Fi & Bluetooth
wifi_enabled=1              # 0 = Wi-Fi desactivado, 1 = Wi-Fi activado (dejar en 1)
wifi_ssid=miwifi            # Nombre de su red Wi-Fi
wifi_password=micontraseña  # Contraseña de su red Wi-Fi
bluetooth_enabled=0         # 0 = Bluetooth desactivado, 1 = Bluetooth activado (dejar en 0)
                            # Activar en caso de interferencias (ej: mando 8Bitdo Pro 3)
bluetooth_name=ESP32-GIF    # Nombre Bluetooth

wifi_static_enabled=1       # 0 = DHCP, 1 = IP fija (recomendado)
wifi_static_ip=192.168.20.240   # Solo si wifi_static_enabled=1
wifi_gateway=192.168.20.1       # Solo si wifi_static_enabled=1
wifi_subnet=255.255.255.0       # Solo si wifi_static_enabled=1
wifi_dns1=1.1.1.1               # Solo si wifi_static_enabled=1
wifi_dns2=8.8.8.8               # Solo si wifi_static_enabled=1

# MQTT
recalbox_ip=192.168.20.104  # Dirección IP fija de su Recalbox
image_folder=logo_detoure   # Valor posible: logo_detoure o marquee
```

---

## 2 - ▶️ Listas de reproducción

Puede crear sus propias listas de reproducción.
La herramienta **Generador de Playlists v1.0.1.bat** (modificada desde [RetroPixelLED](https://github.com/fjgordillo86/RetroPixelLED)) se encuentra en la carpeta **tools** de este repositorio.
Lista todas las carpetas presentes en el directorio **gifs**.
Si tiene carpetas como `Arcade`, `BEST_OF_TOP_30`, `Pixel_Art`, etc. con GIFs, puede seleccionar cuáles incluir en su lista (por ejemplo las carpetas 1, 3 y 5).
Para incluirlo todo en una sola lista, escriba `TODO`.

---

## 3 - 🛠️ Herramientas

Tiene a su disposición el siguiente script:

**`RetroBoxLED_toolkit.py`**
- Extrae las imágenes de sus carpetas de medios
- Convierte las imágenes al formato 128x32
- Crea la caché de sistemas y juegos
- Copia todo en la tarjeta SD

Lo ideal es colocar este archivo en una carpeta dedicada para tenerlo todo a mano.
Solo tiene que seguir las instrucciones en pantalla y elegir las opciones deseadas.

La mejor opción para el panel es realizar un scraping completo con Recalbox usando el tipo de imagen **LOGO RECORTADO** o **MARQUEE**, ideales para el panel LED, como se muestra en la captura de pantalla.

![Scrapping_Recalbox](medias/Scrapping_Recalbox.png)

Una vez finalizado el script, encontrará una carpeta `sd_card`. Copie su contenido en la tarjeta SD o consérvelo como copia de seguridad.

Puede descargar los PNG de los sistemas desde el script o usar los suyos propios.
También se incluye un sistema llamado **`_defaults`**. Si coloca un archivo `_default.gif` o `_default.png`, se usará por defecto cuando no se encuentre ninguna imagen del sistema, así como en el arranque.
Por defecto, los GIFs tienen prioridad sobre los PNGs.

---

## 4 - ⚡ Flash

Antes de comenzar, asegúrese de que su PC reconoce el ESP32.

## 💡 ¿ESP32 no detectado?

**Si "Install" no encuentra el puerto COM**:

| Chip USB | Controladores |
|----------|---------------|
| **CP2102** | [Silicon Labs](https://www.silabs.com/developers/usb-to-uart-bridge-vcp-drivers) |
| **CH340/CH341** | [SparkFun](https://learn.sparkfun.com/tutorials/how-to-install-ch340-drivers/all) |

### **[👉 Instalación desde la página web de RETRO PIXEL LED](https://jamyz.github.io/RetroBoxLED/)**

Pasos de instalación:

1. Use un navegador compatible (Google Chrome o Microsoft Edge).
2. Conecte su ESP32 al puerto USB del ordenador.
3. Haga clic en el botón "Install" y seleccione el puerto COM correspondiente.
4. **Importante:** Marque la casilla "Erase device" para realizar un borrado completo de la memoria y evitar errores de fragmentación.

---

## 5 - 🧠 MQTT — El cerebro de RetroBoxLED

MQTT le indica al ESP32 qué debe mostrar.

**Recalbox → "Lanzo MAME" → MQTT → ESP32 → "¡Muestra el GIF o PNG de mame!"**

- **Sincronización** : El panel LED muestra exactamente el juego en curso
- **Red local** : 192.168.XXX.XXX (Wi-Fi arcade)

Ejemplo de funcionamiento:
```
1. Lanza King of Fighters (mame/kof98)
2. El script marquee[rungame,...](permanent).sh detecta el evento → envía "mame/kof98" por MQTT
3. El ESP32 lo recibe → muestra /systems/mame/kof98.gif
4. ¿GIF no encontrado? → muestra /systems/_defaults/_default.gif
```

El archivo `marquee[rungame,endgame,systembrowsing,gamelistbrowsing,sleep,wakeup,stop,start](permanent).sh`
debe colocarse en `/recalbox/share/userscripts/` en su Recalbox.

---

## 6 - >_ Telnet

El firmware incluye un terminal Telnet para probar el ESP32.
Escriba `help` para mostrar la lista de comandos disponibles.
Puede enviar comandos para cambiar los GIFs mostrados, etc.
Esta función se eliminará más adelante, una vez estabilizado el código, para liberar espacio en el ESP32.

---

## 📚 Bibliotecas necesarias

Para compilar el proyecto desde el IDE de Arduino, instale las siguientes bibliotecas a través del Gestor de bibliotecas o desde sus repositorios oficiales:

- **[ESP32-HUB75-MatrixPanel-I2S-DMA](https://github.com/mrfaptastic/ESP32-HUB75-MatrixPanel-I2S-DMA)** : Control de alto rendimiento del panel LED mediante DMA.
- **[AnimatedGIF](https://github.com/bitbank2/AnimatedGIF)** : Decodificador eficiente para leer archivos GIF desde la tarjeta SD.
- **[pngle](https://github.com/kikuchan/pngle)** : Lectura de archivos PNG con canal alfa desde la tarjeta SD.
- **[WiFiManager](https://github.com/tzapu/WiFiManager)** : Gestión de la conexión Wi-Fi mediante portal cautivo.
- **[Adafruit GFX Library](https://github.com/adafruit/Adafruit-GFX-Library)** : Biblioteca base para mostrar texto y formas geométricas.
- **[ArduinoJson](https://github.com/bblanchon/ArduinoJson)** : Gestión de archivos de configuración y comunicación web.

---

## 🛒 Lista de materiales

Para garantizar la compatibilidad, se recomienda usar los componentes probados durante el desarrollo:

- **Microcontrolador** : [ESP32 DevKit V1 (38 pines)](https://es.aliexpress.com/item/1005005704190069.html)
- **Panel LED Matrix (HUB75)** : [Panel RGB P2.5 / P4](https://es.aliexpress.com/item/1005007439017560.html)
- **Lector de tarjetas** : [Módulo adaptador Micro SD (SPI)](https://es.aliexpress.com/item/1005005591145849.html)
- **Placa de conexión ESP32-Panel LED** : [DMDos Board V3 - Mortaca](https://www.mortaca.com/) *(Opcional: sin soldadura + lector SD integrado)*
- **Alimentación** : Fuente 5V (mínimo 4A recomendado para paneles 64x32)

---

## 🤝 Créditos

- [RetroPixelLED original](https://github.com/fjgordillo86/RetroPixelLED)
- [Comunidad Recalbox](https://www.recalbox.com/fr/)
- [Logos de sistemas publicados bajo licencia Creative Commons CC BY-NC-ND 4.0](https://creativecommons.org/licenses/by-nc-nd/4.0/)
- [Bounitos](https://github.com/BenoitBounar)
- 🎮 [Discord Jamyz](https://discord.com/users/.jamyz)

---

## ☠️ Caídos en combate

- Una vieja tarjeta SD de 1 GB usada para pruebas
- 1 ESP32
- 1 panel LED 64x32

---

## ☕ Apoyar el proyecto

Si este proyecto te ha sido útil, puedes invitarme a un café:

👉 [☕ Donar vía PayPal](https://www.paypal.com/paypalme/jamyz77)

---

**RetroBoxLED** = ¡Recalbox + Pixel LED perfección! 😎
