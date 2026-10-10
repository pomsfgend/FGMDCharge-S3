# Who

There is no single author.

This repository is the ESP32-S3 port of [FGMDCharge / FD_ROUND V2](https://github.com/pomsfgend/FGMDCharge-FD-ROUND-V2). That tree was written over a long time from the factory dump in `original/` and from sessions on real stations. The factory image was not written in either repository. The cube board was not designed here.

The manufacturer is not known. Readable strings in the factory image:

| Where | Text |
|---|---|
| ESP-IDF project name | `FD_ROUND` |
| On-screen title | `EVCHARGER` |
| BLE name in the image | `FGMDCharge` |
| Chip | ESP32-C3 |
| Screen log in the factory image | ILI9341 |

No company name, copyright line or website is in that image.

`original/` is a dump of whatever shipped in the cube. It is **not** under the MIT license. See [LICENSE](LICENSE).

The GitHub account that publishes both repositories is [pomsfgend](https://github.com/pomsfgend). That account hosts the work. It is not a claim that one person designed the factory hardware.

The maintained S3 line is this repository, version 3.0.0, name `FD_ROUND_S3`, taken from cube release 2.8.17. The earlier branch [hw/esp32-s3](https://github.com/pomsfgend/FGMDCharge-FD-ROUND-V2/tree/hw/esp32-s3) was cut from cube source 2.8.15 and is kept only so old links still resolve.

# Кто

Одного автора нет.

Этот репозиторий — порт на ESP32-S3 дерева [FGMDCharge / FD_ROUND V2](https://github.com/pomsfgend/FGMDCharge-FD-ROUND-V2). То дерево собиралось долго, от заводского дампа в `original/` и от сеансов на живых станциях. Заводской образ написан не здесь. Плату куба здесь не разрабатывали.

Производитель **неизвестен**. В дампе читаются строки `FD_ROUND`, `EVCHARGER`, `FGMDCharge`, чип ESP32-C3, в журнале экрана ILI9341. Названия фирмы, строки copyright и сайта нет.

`original/` — дамп того, что стояло в кубе. На него **не** распространяется MIT. См. [LICENSE](LICENSE).

Оба репозитория публикует аккаунт [pomsfgend](https://github.com/pomsfgend). Это хостинг работы, а не подпись завода.

Поддерживаемая линия S3 — этот репозиторий, версия 3.0.0, имя `FD_ROUND_S3`, снятая с релиза куба 2.8.17. Ветка [hw/esp32-s3](https://github.com/pomsfgend/FGMDCharge-FD-ROUND-V2/tree/hw/esp32-s3) от исходника 2.8.15 оставлена, чтобы старые ссылки не умерли.
