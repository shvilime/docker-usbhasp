# docker-usbhasp

## Что это?

Это Docker-контейнер содержащий эмулятор ключей USB HASP.

## Как это установить?

- На вашей linux машине должен быть [развернут docker](https://www.digitalocean.com/community/tutorials/docker-ubuntu-18-04-1-ru).
- Для запуска контейнера склонируйте проект из git:
```Bash
git clone https://github.com/shvilime/docker-usbhasp.git
```
- Положить ключи в формате json в папку keys. 
- Выполнить комманды.
```Bash
./build.sh
./run.sh
```