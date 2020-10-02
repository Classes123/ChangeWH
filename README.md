# Как заставить это работать?

Для начала, в исходнике нужно вписать нужную группу VIP, у которой вы будете этот WH вырубать.
Сама строчка: 
    static const char sGroup[] = "";
Пример:
    static const char sGroup[] = "vip_wh";
и компилим плагин.

Если кто впервые встречает исходник без самого скомпиленного плагина и не знает как компилить, то вот краткий гайд

1. Качаем **последний доступный билд SM** для **WINDOWS** тут - https://www.sourcemod.net/downloads.php?branch=stable (если у вас винда конечно)
2. Распаковываем его и переходим в папку **addons/sourcemod/scripting/**
3. Находим приложение **compile.exe** и переносим наш аддон (**WCS_addon_ChangeWh.sp**) на него. 
4. Переходим в папку **compiled** (в этой же папке), открываем её и видим файл **WCS_addon_ChangeWh.smx**
5. Переносим файл **WCS_addon_ChangeWh.smx** в папку **plugins** на вашем сервере. 

### Также неплохо бы ознакомиться с WIKI - https://github.com/Classes123/ChangeWH/wiki
