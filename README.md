# FGMDCharge-S3

ESP32-S3 port of [FGMDCharge / FD_ROUND V2](https://github.com/pomsfgend/FGMDCharge-FD-ROUND-V2) release 2.8.17. Version here is **3.0.0**, name `FD_ROUND_S3`. The cube repository stays the C3 line. Do not flash this tree into the cube.

An earlier sketch is branch [hw/esp32-s3](https://github.com/pomsfgend/FGMDCharge-FD-ROUND-V2/tree/hw/esp32-s3), cut from 2.8.15. New work is this repository. Hardware, pins and prices: [docs/s3/PORT_RU.md](docs/s3/PORT_RU.md). Who did not design the board: [AUTHORS.md](AUTHORS.md).

# FGMDCharge / FD_ROUND V2

[English](README.md) · [Русский](#русский) · [中文](docs/i18n/README.zh-CN.md) · [Español](docs/i18n/README.es.md) · [Português](docs/i18n/README.pt-BR.md) · [Deutsch](docs/i18n/README.de.md) · [Français](docs/i18n/README.fr.md) · [日本語](docs/i18n/README.ja.md) · [한국어](docs/i18n/README.ko.md)

Issues and pull requests are welcome in any of those languages.

Below is still the description of what the firmware does on CAN. The binary you build here is the S3 one.

Release **3.0.0** (base cube **2.8.17**). Journal: [CHANGELOG.md](CHANGELOG.md). What changed in each old archive: [docs/ARCHIVE_CHANGES.md](docs/ARCHIVE_CHANGES.md). Old source, not this tree: branch [`history`](https://github.com/pomsfgend/FGMDCharge-FD-ROUND-V2/tree/history) and `src/X.Y.Z`. Packages: [archive/](archive/). Branch rules: [docs/BRANCHES.md](docs/BRANCHES.md).

This tree was vibe-coded over a long time from the factory dump in `original/` and from trying the cube on real stations. There is no single author. The factory image itself was not written in this repository. The board was not designed here.

## Who made the hardware

The manufacturer is **not known**.

The factory image was read off the cube. Readable strings in it say:

| Where | Text |
|---|---|
| ESP-IDF project name | `FD_ROUND` |
| On-screen title | `EVCHARGER` |
| BLE name in the image | `FGMDCharge` |
| Chip | ESP32-C3 |
| Screen log in the factory image | ILI9341 (the image logs that name) |

No company name, copyright line or website is in that image. Treat `original/` as a dump of whatever shipped in this cube, not as a work of a named vendor.

## Factory image

`original/` is published so the project can be repeated and so **СТАРАЯ** can still be flashed. It is **not** under the MIT license. See [LICENSE](LICENSE).

| File | What it is |
|---|---|
| `dump1.bin` | 4 MB read of the chip |
| `bootloader_0x1000_0x8000.bin` | factory bootloader |
| `partition_table_0x8000_0x9000.bin` | factory partition table |
| `nvs_0x9000_0xD000.bin` | factory NVS (may hold that device's old settings) |
| `otadata_0xD000_0xF000.bin` | factory OTA boot selection |
| `phy_init_0xF000_0x10000.bin` | PHY init data |
| `ota0_partition_0x190000.bin` | factory app slot, full partition |
| `ota0_from_dump1.bin` | factory app image cut from the dump |
| `ota0_irom.bin`, `ota0_tail.bin` | slices of that app |
| `ota1_partition_0x190000.bin`, `ota1_irom.bin` | second slot as shipped |
| `factory_lzss.bin` | compressed copy used by the boot menu |

OTA of `release/FGMDCharge_FD_ROUND_V2.bin` does not need these files. `GO.bat` does, because it writes the factory image back into `ota_0`.

## What this firmware does

It does not start a charge by itself as a charger. It answers the station. CAN transmit is on. Protocol **auto** follows the first frame:

| Station sends | Protocol |
|---|---|
| Version frame, addresses 0x5F / 0x25 | GB/T 27930-2023 class B (ChaoJi) |
| CHM | GB/T 27930-2015 and 2023 class A |
| CRM, and neither of the above | GB/T 27930-2011 |

Charge current is encoded negative, as GB/T requires. A CCS pause does not end the session. CST, CEM and CSD do.

Wi-Fi **Cube**, password `12345678`, site `http://192.168.4.1/`. The screen code checked in firmware is `1234`. It is not printed on the display.

Prebuilt app image (1 143 440 bytes, SHA256 `7a6ca69a24e2f7c1fb3f312d40313c5862d78a20a244591a26b8cd08b8d263ac`): [`release/FGMDCharge_FD_ROUND_V2.bin`](https://github.com/pomsfgend/FGMDCharge-FD-ROUND-V2/raw/main/release/FGMDCharge_FD_ROUND_V2.bin).

## Parts to build the same thing

Logic is 3.3 V. Do not power a relay coil from a GPIO pin. Use the transistor or driver already on the board, or add one.

| Part | Used here | Notes |
|---|---|---|
| Module | ESP32-C3, 4 MB flash | This tree is built for this chip. ESP-IDF **5.0.9** only (`idf: >=5.0.9,<5.1.0`). |
| Display | SPI ST7789, 240×280 | This firmware drives ST7789 (invert on, BGR, gap Y = 20). The factory image's log text says ILI9341. Match the panel you actually have. |
| Touch | CST816S, I2C address `0x15` | Chip ID seen on the cube: `0xB6`. |
| CAN | 3.3 V CAN transceiver to CANH/CANL | Part number is not in this repo. 250 kbit/s. |
| Relays | two outputs | GPIO high = on. GPIO6 prepare, GPIO7 load. |
| Backlight | LED PWM | GPIO2, 5 kHz, default 70%. |
| USB | external USB-UART on UART0 | Not native USB. See the warning below. |
| Software | ESP-IDF 5.0.9, LVGL **8.3.11**, Python 3.11 on Windows as used to build | LVGL is fetched by the IDF component manager. `components/esp_lcd_ili9341` is vendored. |

### Do not short RX and TX

On this ESP32-C3 the console is UART0: **TX = GPIO21**, **RX = GPIO20**. Those pins go to the USB-UART chip. Shorting RX to TX can destroy the ESP or the USB-UART. GPIO18 and GPIO19 are the display, not USB.

## Pins (ESP32-C3, this cube)

All numbers are GPIO numbers in `main/config.h`.

| Function | GPIO | Direction |
|---|---|---|
| LCD MOSI | 5 | out |
| LCD SCLK | 19 | out |
| LCD CS | 4 | out |
| LCD DC | 18 | out |
| LCD backlight PWM | 2 | out |
| LCD reset | not wired (`-1`) | |
| LCD MISO | not wired | |
| Touch SDA | 1 | I2C |
| Touch SCL | 8 | I2C |
| CAN TX | 10 | to transceiver TXD |
| CAN RX | 9 | from transceiver RXD |
| Relay A | 6 | out, prepare |
| Relay B | 7 | out, load |
| UART0 TX | 21 | console, IDF default |
| UART0 RX | 20 | console, IDF default |

SPI clock 40 MHz. CAN 250 kbit/s, extended frames, accept-all filter.

### Flash map (4 MB)

| Name | Offset | Size |
|---|---|---|
| bootloader | `0x1000` | |
| partition table | `0x8000` | |
| nvs | `0x9000` | 16 KB |
| otadata | `0xD000` | 8 KB |
| phy_init | `0xF000` | 4 KB |
| ota_0 factory app | `0x10000` | 1600 KB |
| ota_1 this firmware | `0x1A0000` | 1600 KB |
| session logs | `0x330000` | 8 × 4 KB, not a partition |

Do not erase the whole chip if the factory app in `ota_0` must remain. To replace only this firmware:

```
esptool.py --chip esp32c3 -p COMx -b 460800 write_flash 0x1A0000 release/FGMDCharge_FD_ROUND_V2.bin
```

`BUILD_RELEASE.bat` builds. `GO.bat` builds and writes bootloader, partition table, factory image and this app. It asks for the COM port.

## ESP32-S3

This repository **is** the S3 line. It was split from the cube at release 2.8.17. `sdkconfig.defaults` targets `esp32s3`. `GO.bat` and `BUILD_RELEASE.bat` exit immediately so they cannot write a cube command at a DevKit.

Default board: ESP32-S3-DevKitC-1 N16R8 (N8R2 uses the same free pins). SPI ST7789 240×280, CST816, TWAI 250 kbit/s, two active-high relay outputs. Buy list, LilyGO, round and RGB panels: [docs/s3/PORT_RU.md](docs/s3/PORT_RU.md).

There is **no prebuilt S3 binary**. ESP-IDF must be `>=5.0.9,<5.1.0`. `GO_S3.bat` builds and flashes a blank board:

| Piece | Address |
|---|---|
| bootloader | `0x0` |
| partition table | `0x8000` |
| app `ota_0` | `0x10000` |

That is not the cube map. The file `release/FGMDCharge_FD_ROUND_V2.bin` is still the cube image from 2.8.17. Do not write it to an S3. On the cube it belongs at `0x1A0000`, with otadata selecting slot 1, and the factory app in `ota_0` stays. The factory blob named `bootloader_0x1000_0x8000.bin` is a dump read from `0x1000`. IDF 5.0.9 on a blank C3 or S3 uses bootloader offset `0x0`.

Pins in `main/boards/esp32s3_devkit.h` (`#ifndef`, so `-D` can override):

| Function | GPIO |
|---|---|
| LCD MOSI / SCLK / CS / DC | 11 / 12 / 10 / 13 |
| LCD RST / backlight PWM | 14 / 21 |
| Touch SDA / SCL | 1 / 2 |
| CAN TX / RX | 17 / 18 |
| Relay A / B, active high | 6 / 7 |
| Status LED | 47 |

CST816 INT and RST may be wired to GPIO4 and GPIO5. `touch_cst816s.c` does not drive them. XPT2046, if used later, has CS 16 and IRQ 8. Do not use the old untested sketch (backlight 14, touch 8/9, relays 15/16).

Leave free: straps 0, 3, 45, 46; USB 19/20; unbonded 22–25; flash 26–32; octal PSRAM 33–37 on N16R8; UART0 43/44 on a CH340 clone; onboard RGB 38 or 48. PSRAM stays off in 3.0.0. `display.c` still inits only ST7789 and ILI9341. GC9A01, QSPI and RGB are documented, not compiled in. The power stage is an external certified GB/T module. This firmware drives 3.3 V, 5 V and a 12 V coil only.

To rebuild the cube pinout from this tree: `-DCUBE_BOARD=CUBE_BOARD_C3_ORIGINAL`, `idf.py set-target esp32c3`, and `sdkconfig.defaults.c3`. Prefer the cube repository for that. Do not full-chip-erase the cube.

## Layout

- `main/` — CAN, GB/T 2011 / 2015 / 2023-A / 2023-B, display, Wi-Fi, site, OTA, session log
- `original/` — factory dump, not MIT
- `docs/` — extra notes
- `host_tests/` — protocol checks with no chip
- `RELEASE_NOTES_RU.md` — what changed in each release

## Русский

Ниже по-прежнему описано, что прошивка отвечает станции по CAN. Собирать здесь нужно уже S3, не куб.

Release **3.0.0** (база куба **2.8.17**). Журнал: [CHANGELOG.md](CHANGELOG.md). Что менялось в каждом старом архиве: [docs/ARCHIVE_CHANGES.md](docs/ARCHIVE_CHANGES.md). Старый исходник, не это дерево: ветка [`history`](https://github.com/pomsfgend/FGMDCharge-FD-ROUND-V2/tree/history) и `src/X.Y.Z`. Пакеты: [archive/](archive/). Ветки: [docs/BRANCHES.md](docs/BRANCHES.md).

Это дерево собрано вайбкодингом, долго, от заводского дампа в `original/` и от поездок к живым станциям. Одного автора нет. Заводской образ написан не здесь. Плату здесь не разрабатывали.

### Кто производитель

**Неизвестно.**

Заводской образ считан с куба. В нём читаются строки:

| Где | Текст |
|---|---|
| Имя проекта ESP-IDF | `FD_ROUND` |
| Надпись на экране | `EVCHARGER` |
| Имя BLE в образе | `FGMDCharge` |
| Чип | ESP32-C3 |
| Строка в журнале заводской прошивки | ILI9341 |

Названия фирмы, строки copyright и сайта в образе нет. `original/` — дамп того, что стояло в этом кубе, а не работа названного завода.

### Заводской образ

Каталог `original/` выложен, чтобы проект можно было повторить и снова прошить **СТАРАЯ**. На него **не** распространяется MIT. См. [LICENSE](LICENSE).

| Файл | Что это |
|---|---|
| `dump1.bin` | чтение чипа, 4 МБ |
| `bootloader_0x1000_0x8000.bin` | заводской загрузчик |
| `partition_table_0x8000_0x9000.bin` | заводская таблица разделов |
| `nvs_0x9000_0xD000.bin` | заводской NVS (там могут быть старые настройки того куба) |
| `otadata_0xD000_0xF000.bin` | выбор слота OTA |
| `phy_init_0xF000_0x10000.bin` | данные PHY |
| `ota0_partition_0x190000.bin` | заводское приложение, весь раздел |
| `ota0_from_dump1.bin` | то же приложение, вырезанное из дампа |
| `ota0_irom.bin`, `ota0_tail.bin` | куски этого приложения |
| `ota1_partition_0x190000.bin`, `ota1_irom.bin` | второй слот, как он был |
| `factory_lzss.bin` | сжатая копия для меню загрузки |

Для OTA файла `release/FGMDCharge_FD_ROUND_V2.bin` эти файлы не нужны. `GO.bat` пишет заводской образ обратно в `ota_0`, поэтому ему они нужны.

### Что делает прошивка

Сама зарядку как станция она не начинает. Она отвечает станции. Передача CAN включена. Протокол **авто** выбирается по первому кадру:

| Что прислала станция | Протокол |
|---|---|
| Кадр версии, адреса 0x5F / 0x25 | GB/T 27930-2023 класс B (ChaoJi) |
| CHM | GB/T 27930-2015 и 2023 класс A |
| CRM, и ничего из строк выше | GB/T 27930-2011 |

Ток заряда кодируется отрицательным, как требует GB/T. Пауза CCS сессию не кончает. Кончают CST, CEM и CSD.

Сеть **Cube**, пароль `12345678`, сайт `http://192.168.4.1/`. Код на экране, который проверяет прошивка, — `1234`. На дисплей он не выводится.

Готовый файл приложения (1 143 440 байт, SHA256 `7a6ca69a24e2f7c1fb3f312d40313c5862d78a20a244591a26b8cd08b8d263ac`): [`release/FGMDCharge_FD_ROUND_V2.bin`](https://github.com/pomsfgend/FGMDCharge-FD-ROUND-V2/raw/main/release/FGMDCharge_FD_ROUND_V2.bin).

### Из чего повторить

Логика — 3,3 В. Катушку реле с ножки GPIO не питать. Нужен транзистор или драйвер, как на плате, либо свой.

| Деталь | Здесь | Замечание |
|---|---|---|
| Модуль | ESP32-C3, flash 4 МБ | Сборка только под этот чип. ESP-IDF **5.0.9** (`idf: >=5.0.9,<5.1.0`). |
| Экран | SPI ST7789, 240×280 | Эта прошивка включает ST7789 (инверсия, BGR, сдвиг по Y = 20). В журнале заводского образа написано ILI9341. Смотрите на ту панель, которая стоит. |
| Тач | CST816S, адрес I2C `0x15` | На кубе ID был `0xB6`. |
| CAN | трансивер 3,3 В на CANH/CANL | Марка в репозитории не указана. 250 кбит/с. |
| Реле | два выхода | высокий уровень = включено. GPIO6 подготовка, GPIO7 нагрузка. |
| Подсветка | ШИМ | GPIO2, 5 кГц, по умолчанию 70%. |
| USB | внешний USB-UART на UART0 | Не родной USB. См. предупреждение ниже. |
| Софт | ESP-IDF 5.0.9, LVGL **8.3.11** | LVGL подтягивает менеджер компонентов. `components/esp_lcd_ili9341` лежит в дереве. |

### Не замыкать RX и TX

На этом ESP32-C3 консоль — UART0: **TX = GPIO21**, **RX = GPIO20**. Они идут на микросхему USB-UART. Замыкание RX на TX убивает ESP или этот преобразователь. GPIO18 и GPIO19 заняты экраном, это не USB.

### Пины (ESP32-C3, этот куб)

Номера — GPIO из `main/config.h`.

| Функция | GPIO | Куда |
|---|---|---|
| LCD MOSI | 5 | выход |
| LCD SCLK | 19 | выход |
| LCD CS | 4 | выход |
| LCD DC | 18 | выход |
| Подсветка, ШИМ | 2 | выход |
| Сброс LCD | не подключён (`-1`) | |
| LCD MISO | нет | |
| Тач SDA | 1 | I2C |
| Тач SCL | 8 | I2C |
| CAN TX | 10 | на TXD трансивера |
| CAN RX | 9 | с RXD трансивера |
| Реле A | 6 | выход, подготовка |
| Реле B | 7 | выход, нагрузка |
| UART0 TX | 21 | консоль, значение IDF по умолчанию |
| UART0 RX | 20 | консоль, значение IDF по умолчанию |

SPI 40 МГц. CAN 250 кбит/с, расширенные кадры, фильтр принимает все.

### Карта flash (4 МБ)

| Имя | Адрес | Размер |
|---|---|---|
| загрузчик | `0x1000` | |
| таблица разделов | `0x8000` | |
| nvs | `0x9000` | 16 КБ |
| otadata | `0xD000` | 8 КБ |
| phy_init | `0xF000` | 4 КБ |
| ota_0 завод | `0x10000` | 1600 КБ |
| ota_1 эта прошивка | `0x1A0000` | 1600 КБ |
| журналы сессий | `0x330000` | 8 × 4 КБ, это не раздел |

Весь чип не стирать, если заводское приложение в `ota_0` нужно оставить. Заменить только эту прошивку:

```
esptool.py --chip esp32c3 -p COMx -b 460800 write_flash 0x1A0000 release/FGMDCharge_FD_ROUND_V2.bin
```

`BUILD_RELEASE.bat` собирает. `GO.bat` собирает и пишет загрузчик, таблицу, заводской образ и это приложение. Порт скрипт спрашивает сам.

### ESP32-S3

Это репозиторий **и есть** линия S3. Он отделён от куба на релизе 2.8.17. `sdkconfig.defaults` целится в `esp32s3`. `GO.bat` и `BUILD_RELEASE.bat` сразу выходят, чтобы команда куба не уехала в DevKit.

Плата по умолчанию: ESP32-S3-DevKitC-1 N16R8 (у N8R2 те же свободные ноги). SPI ST7789 240×280, CST816, TWAI 250 кбит/с, два выхода реле, активный высокий. Что купить, LilyGO, круглые и RGB панели: [docs/s3/PORT_RU.md](docs/s3/PORT_RU.md).

**Готового bin для S3 нет.** Нужен ESP-IDF `>=5.0.9,<5.1.0`. `GO_S3.bat` собирает и шьёт пустую плату: загрузчик `0x0`, таблица `0x8000`, приложение `ota_0` с `0x10000`. Это не карта куба.

Файл `release/FGMDCharge_FD_ROUND_V2.bin` — образ куба 2.8.17. На S3 его не писать. На кубе он живёт в `0x1A0000`, otadata выбирает слот 1, завод в `ota_0` остаётся. Файл `bootloader_0x1000_0x8000.bin` назван по адресу, с которого его читали. У пустой платы на IDF 5.0.9 загрузчик пишется с `0x0`.

Ноги в `main/boards/esp32s3_devkit.h`: MOSI 11, SCLK 12, CS 10, DC 13, RST 14, подсветка 21, тач SDA 1 / SCL 2, CAN 17 / 18, реле A 6 / B 7, светодиод 47. INT и RST тача можно посадить на 4 и 5, прошивка ими не рулит. Старую непроверенную схему (подсветка 14, тач 8/9, реле 15/16) не использовать.

Не занимать: strap 0, 3, 45, 46; USB 19/20; несуществующие 22–25; flash 26–32; octal PSRAM 33–37 у N16R8; UART0 43/44 у клона на CH340; RGB платы 38 или 48. PSRAM в 3.0.0 выключен. `display.c` по-прежнему поднимает только ST7789 и ILI9341. Силовая часть — внешний сертифицированный модуль GB/T. Прошивка трогает только 3,3 В, 5 В и катушку 12 В.

Собрать старые ноги куба из этого дерева можно: `-DCUBE_BOARD=CUBE_BOARD_C3_ORIGINAL`, `idf.py set-target esp32c3`, файл `sdkconfig.defaults.c3`. Для куба проще родительский репозиторий. Весь чип куба не стирать.

### Состав дерева

- `main/` — CAN, GB/T 2011 / 2015 / 2023-A / 2023-B, экран, Wi-Fi, сайт, OTA, журнал
- `original/` — заводской дамп, не MIT
- `docs/` — дополнительные заметки
- `host_tests/` — проверки протокола без чипа
- `RELEASE_NOTES_RU.md` — что менялось в релизах
