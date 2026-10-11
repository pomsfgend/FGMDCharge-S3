# Где смотреть

Конструктор: <https://apple-raven-kite-lunar.grok.me>

Группа Telegram: <https://t.me/+Z7iS1mfgtphiMDhi>

Эта ветка `main` — линия S3 3.0.0. Куб в теме ESP32-C3, эта плата в теме ESP32-S3.

# This repository

`main` here is FGMDCharge-S3 **3.0.0**. The cube is not developed in this repository.

Cube firmware and its prebuilt image: <https://github.com/pomsfgend/FGMDCharge-FD-ROUND-V2>

Branch `hw/esp32-s3` on the cube repository is an older sketch from 2.8.15. Do not open new S3 work against it.

# Branches

`main` is the current firmware, 2.8.17. Releases and the prebuilt image come from here.

`develop` is the branch for the next change. Open a pull request into `develop`. Do not commit experiments straight to `main`.

`history` is the old source, one commit per archive that differs. `src/2.4.1` and the other `src/*` branches point at that old source. They are not `main`. What changed in each archive is [ARCHIVE_CHANGES.md](ARCHIVE_CHANGES.md).

Do not add a tag `v2.8.10` on `main`. That would offer today's source under an old version. Use `src/2.8.10`.

There is no branch per folder. CAN, the site, the display and the bootloader are one firmware.

# Ветки

`main` — текущая прошивка, 2.8.17. Релизы и готовый bin идут отсюда.

`develop` — следующая правка. Запрос на слияние открывается в `develop`.

`history` — старые исходники, один коммит на каждый архив, который отличается. `src/2.4.1` и остальные `src/*` указывают на этот старый код. Это не `main`. Что менялось в каждом архиве: [ARCHIVE_CHANGES.md](ARCHIVE_CHANGES.md).

Метку `v2.8.10` на `main` не ставить: под старым номером скачается сегодняшний код. Для старого дерева есть `src/2.8.10`.

Отдельной ветки на каждый каталог нет. CAN, сайт, экран и загрузчик — одна прошивка.
