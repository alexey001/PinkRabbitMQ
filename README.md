# PinkRabbitMQ library
[![Build Status](http://ci.bit-erp.ru/buildStatus/icon?job=ci/buildCProject/steps/buildCProject)](https://share.bit-erp.ru:4343)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](https://github.com/BITERP/PinkRabbitMQ/blob/master/LICENSE)
[![GitHub release](https://img.shields.io/github/release/BITERP/PinkRabbitMQ.svg)](https://github.com/BITERP/PinkRabbitMQ/releases)

[![Sonar bugs](https://code.bit-erp.ru/sonardev/api/project_badges/measure?project=PinkRabbitMQ&metric=bugs)](https://code.bit-erp.ru/sonardev/dashboard?id=PinkRabbitMQ)
[![Sonar code smells](https://code.bit-erp.ru/sonardev/api/project_badges/measure?project=PinkRabbitMQ&metric=code_smells)](https://code.bit-erp.ru/sonardev/dashboard?id=PinkRabbitMQ)
[![Sonar dublications](https://code.bit-erp.ru/sonardev/api/project_badges/measure?project=PinkRabbitMQ&metric=duplicated_lines_density)](https://code.bit-erp.ru/sonardev/dashboard?id=PinkRabbitMQ)
[![Sonar lines of code](https://code.bit-erp.ru/sonardev/api/project_badges/measure?project=PinkRabbitMQ&metric=ncloc)](https://code.bit-erp.ru/sonardev/dashboard?id=PinkRabbitMQ)
[![Sonar technical debt](https://code.bit-erp.ru/sonardev/api/project_badges/measure?project=PinkRabbitMQ&metric=sqale_index)](https://code.bit-erp.ru/sonardev/dashboard?id=PinkRabbitMQ)
[![Sonar vulnerables](https://code.bit-erp.ru/sonardev/api/project_badges/measure?project=PinkRabbitMQ&metric=vulnerabilities)](https://code.bit-erp.ru/sonardev/dashboard?id=PinkRabbitMQ)

# Введение
Внешняя Native API компонента для 1C 8.3, которая реализует методы для работы с сервером Rabbit MQ через TCP IP протокол. Компонента поддерживается командой разработки [БИТ.Адаптер](https://bit-erp.ru/adapter) и используется в БИТ.Адаптере. Ид компоненты - PinkRabbitMQ. Компонента поставляется для 32 и 64 битной платформы 1С.

## Ограничения

* Компонента поддерживает только Windows

## API
Компонента реализует протокол [AMQP 0.9.1](https://www.rabbitmq.com/resources/specs/amqp0-9-1.pdf).
Компонента имеет ряд методов для работы из встроенного языка 1С. Параметры с тегом [НЕ РЕАЛИЗОВАНО] имеют пустую реализацию, но передавать их все равно требуется. Параметры с тегом [НЕОБЯЗАТЕЛЬНЫЙ] можно не передавать. 

### Список свойств комоненты, связанных с сообщением:

* correlationId - строка, чтение и запись
* messageId - строка, чтение и запись
* Type - строка, чтение и запись
* AppId - строка, чтение и запись
* ContentEncoding - строка, чтение и запись
* ContentType - строка, чтение и запись
* UserId - строка, чтение и запись. В данное свойство разрешается передавать только логин пользователя, использованный для установки соединения
* ClusterId - строка, чтение и запись
* Expiration - число строкой, чтение и запись. Передача строки, отличной от числовой, приведет к вызову исключения.
* ReplyTo - строка, чтение и запись

Эти свойства передаются в качестве метаданных вместе с сообщением в RabbitMQ. Их можно прочитать также на стороне получателя - они реинициализируется в момент вызова basicConsumeMessage().

### Список прочих свойств:

* Version - версия компоненты, только чтение

### Список методов:

<b>Connect</b> - устанавливает соединение с сервером RabbitMQ

Параметры:
* host - Строка - Адрес сервера RabbitMQ
* port - Число - Порт работы через tcp (обычно 5672)
* login - Строка - Имя пользователя
* pwd - Строка - Пароль пользователя
* vhost - Строка - Vhost пользователя
* pingRate - Число - [НЕ РЕАЛИЗОВАНО][НЕОБЯЗАТЕЛЬНЫЙ]. Частота пульса

<b>DeclareExchange</b> - Объявить точку обмена

Параметры:
* name - Строка - Имя exchange
* type - Строка - Тип точки обмена. Поддерживаются "direct", "fanout", "topic"
* onlyCheckIfExists - Булево - Не создавать новую, выбросить исключение, если такой точки нет.
* durable - Булево - Сохранять сообщения на диске на случай рестарта RMQ (не рекомендуется)
* autodelete - Булево -  Удалить после того, как от точки будут отвязаны все очереди.

<b>DeleteExchange</b> - Удаляет очередь с сервера

Параметры:
* name - Строка- Имя точки обмена.
* ifunused - Булево - Удаление будет выполнено, только если точка обмена не используется.

<b>DeclareQueue</b> - Объявить очередь

Параметры:
* name -  Строка - Имя объявляемой очереди.
* onlyCheckIfExists  - Булево - Не создавать очередь с таким именем, использовать существующую
* save - Булево - Кешировать сообщения на диске, на случай падения RMQ.
* exclusive - Булево - [НЕ РЕАЛИЗОВАНО]  Только текущее соединение может иметь доступ к этой очереди.
* autodelete - Булево - Удалить очередь если к ней был подключен, а затем отключен читающий клиент.

Возвращаемое значение:
 - Имя очереди, заданное явно в 1-м параметре.

<b>DeleteQueue</b> - Удаляет очередь с сервера

Параметры:
* name - Строка - Имя очереди
* onlyIfIdle - Булево - Удаление будет выполнено, только если очередь не используется 
* onlyIfEmpty - Булево -  Удаление будет выполнено, только если очередь пуста

<b>BindQueue</b> - Установить связь очереди. Создает маршрут от точки обмена до очереди.

Параметры:
* queue - Строка - Имя очереди
* exchange - Строка - Имя точки обмена
* routingKey - Строка - Rлюч маршрутизации. 

<b>UnbindQueue</b> - Отсоединяет очередь от точки обмена.

Параметры:
* queue - Строка - Имя очереди
* exchange - Строка - Имя точки обмена
* routingKey - Строка - Rлюч маршрутизации. 

<b>BasicPublish</b> -  Отправить сообщение

Параметры:
* exchange - Строка - Имя точки в которую отправляется сообщение
* routingKey - Строка - Ключ маршрутизации (см. руководство RMQ)
* message - Строка - Тело сообщения
* livingTime - Число - [НЕ РЕАЛИЗОВАНО]  Время жизни сообщения в миллисекундах
* persist - Булево - [НЕ РЕАЛИЗОВАНО]  Сбрасывать сообщение на диск

<b>BasicReject</b> - Отказывается от последнего полученного сообщения. Работает по принципу Ack, но в обратную сторону.

Параметры отсутствуют

<b>BasicConsume</b> - Начать чтение. Регистрирует потребителя сообщений для очереди.

Параметры:
* queue - Строка - Очередь из которой будем читать сообщения.
* consumerId - Строка - [НЕ РЕАЛИЗОВАНО]  имя потребителя. Если не задан, то имя потребителя сгенерирует сервер и вернет из метода
* noConfirm - Булево - [НЕ РЕАЛИЗОВАНО]  не ждать подтверждения обработки. Сообщения будут удалены из очереди сразу после отправки на клиента.
* exclusive - Булево - [НЕ РЕАЛИЗОВАНО]  монопольно захватить очередь 
* selectSize - Число - [НЕ РЕАЛИЗОВАНО]  количество сообщений единовременно отправляемых клиенту. Оптимизационный параметр, если > 1 усложняет программирование клиента

Возвращаемое значение:
 - Строка. Имя потребителя, сгенерированное сервером или переданное в параметре ИмяПотребителя.

<b>BasicConsumeMessage</b> - Получить сообщение

Параметры:
* consumerId - Строка - [НЕ РЕАЛИЗОВАНО]  Имя зарегистрированного потребителя
* outdata - Строка - Выходной параметр. Тело сообщения.
* timeout - Число - Таймаут ожидания сообщения в миллисекундах. 0 означает без ожидания

<b>BasicCancel</b> - Закрывает канал для чтения сообщений

Параметры:
* channelId - Строка - Имя созданного ранее потребителя.

<b>BasicAck</b> Отсылает серверу подтверждение (ack), что сообщение обработано и его можно удалить. Подтвердить можно только последнее прочитанное сообщение.

Параметры отсутствуют

<b>GetLastError</b> - получает информацию о последней ошибке

Параметры отсутствуют

Возвращаемое значение:
 - Строка - Последнее сообщение ошибки


Описание параметров методов см. в заголовке RabbitMQClient.h

## Примеры

### Подключение внешней компоненты на клиенте
``` bsl
УстановитьВнешнююКомпоненту("ОбщийМакет.PinkRabbitMQ");
ПодключитьВнешнююКомпоненту("ОбщийМакет.PinkRabbitMQ", "BITERP", ТипВнешнейКомпоненты.Native);
Клиент  = Новый("AddIn.BITERP.PinkRabbitMQ");
```

### Создание точки обмена, очереди и их связывание на клиенте
``` bsl
ИмяТочкиОбмена = "data";
ИмяОчереди = "testroute";
ОтправляемоеСообщение = "Test";
ОтветноеСообщение = "";

УстановитьВнешнююКомпоненту("ОбщийМакет.PinkRabbitMQ");
ПодключитьВнешнююКомпоненту("ОбщийМакет.PinkRabbitMQ", "BITERP", ТипВнешнейКомпоненты.Native);
Клиент  = Новый("AddIn.BITERP.PinkRabbitMQ");

Клиент.Connect("127.0.0.1", 5672, "user", "password", "user");
Клиент.DeclareExchange(ИмяТочкиОбмена, "topic", Ложь, Истина, Ложь);
Клиент.DeclareQueue(ИмяОчереди, Ложь, Ложь, Ложь, Ложь);
Клиент.BindQueue(ИмяОчереди, ИмяТочкиОбмена, "#" + ИмяОчереди + "#");
```

### Создание очереди, отправка и получение сообщения на клиенте
``` bsl
    ИмяОчереди = "testroute";
    ОтправляемоеСообщение = "Test";
    ОтветноеСообщение = "";
    
    УстановитьВнешнююКомпоненту("ОбщийМакет.PinkRabbitMQ");
    ПодключитьВнешнююКомпоненту("ОбщийМакет.PinkRabbitMQ", "BITERP", ТипВнешнейКомпоненты.Native);
    Клиент  = Новый("AddIn.BITERP.PinkRabbitMQ");
    
    Клиент.Connect("127.0.0.1", 5672, "user", "password", "user");
    Клиент.DeclareQueue(ИмяОчереди, Ложь, Ложь, Ложь, Ложь);
    Клиент.BasicPublish("", ИмяОчереди, ОтправляемоеСообщение, 0, Ложь);
    Попытка
        Потребитель = Клиент.BasicConsume(ИмяОчереди, "", Истина, Ложь, 0);
        Пока Клиент.BasicConsumeMessage("", ОтветноеСообщение, 5) Цикл
            Клиент.BasicAck();
            Сообщить("Успешно! Из очереди прочитано сообщение " + ОтветноеСообщение);
        КонецЦикла;
        Клиент.BasicCancel("");
    Исключение
        Сообщить(Клиент.GetLastError());
    КонецПопытки;
```

## Установка в конфигурацию

1. Скачать архив с релизом компоненты.
2. Загрузить в конфигурацию в качестве общего макета с двоичными данными

## Разворачивание окружения разработки на Windows 10 (Рекомендуется)

Вместе с проектом поставляются заранее скомпилированные зависимости в папке libsPrecompiled для 32 и 64 битных платформ в вариантах debug и release. Поэтому для создания окружения разработки нужно сделать только следующее:

1. Установить Visual Studio 2019 (можно Community). При установке выбрать среди обязательных компонентов также WIndows SDK 10 
2. Скачать исходники репозитория данного проекта. 
3. Запустить файл проекта AddIn.sln в корневом каталоге 

## Разворачивание окружения разработки на Windows 10 и самостоятельная компиляция всех зависимостей (Не рекомендуется)

Порядок изложенный ниже требуется, если нужно с нуля собрать весь проект и скомпилировать все зависимые билиотеки. Если это не требуется, то рекомендуется следовать простому порядку разворачивания окружения, приведенному выше.

1. Установить Visual Studio 2019 (можно Community). При установке выбрать среди обязательных компонентов также WIndows SDK 10 
2. Скачать исходники репозиторий данного проекта. 
3. Скачать исходники либы для работы с протоколом раббита AMQP-CPP 4.1.4. https://github.com/CopernicaMarketingSoftware/AMQP-CPP в папку libs
4. Скомпилировать дебажную и релизную dll в папкe libs\AMQP-CPP-4.1.4\build с помощью cmake. 
```
mkdir build
cd build
cmake .. 
cd ..
cmake --build
```
Для компиляции 64-битной release версии либы
* Открыть файл проекта  amqpcpp.sln 
* Выбрать свойства проекта amqcpp => C/C++ => Code generation => Runtime library => Multi-threaded (/MT)
* Скомпилировать проект Release

Для компиляции 32-битной release версии либы

Нужно создать свой проект с нуля на базе проекта 64-битной компоненты, сгенерированного через cmake

5. Скачать исходники либы для работы с сокетом POCO 1.9.0. https://github.com/pocoproject/poco/tree/master в папку libs
6. Скомпилировать дебажную .lib и .dll (debug_shared)  и релизную (release_static_mt) для следующих подпроектов  Foundation и Net. Компиляцию следует выполнять через sln проекты
7. Для дебажного запуска компоненты поместить скомпилированные dll-ки PocoFoundationd64.dll и PocoNet64d.dll в папку 1cv8\8.3.10.2667\bin
8. Запустить файл проекта компоненты NativeRabbitMQClient в каталоге AddIn.sln
10. Проверить линковку зависимостей для заголовков Properties узла проекта -> С/С++ -> General -> Additional include directories (переключить вкладку debug)
- ..\libs\poco-poco-1.9.0-release\Foundation\include;
- ..\libs\poco-poco-1.9.0-release\Net\include;
- ..\libs\AMQP-CPP-4.1.4\include;
11. Проверить линковку зависимостей для папок lib и dll файлов Properties узла проекта -> Linker -> General -> Additional include directories 
- ..\libs\poco-poco-1.9.0-release\lib64;
- ..\libs\AMQP-CPP-4.1.4\build\bin\Debug\;
12. Проверить линкову для lib файлов зависимостей Properties узла проекта -> Linker -> Input -> Additional dependencies 
- amqpcpp.lib;
- PocoFoundationd.lib;
13. Скомпилировать компоненту через проект

## Сборка проекта через cmake
```
mkdir build
cd build
cmake .. 
cmake --build . --config Release
```

## Лицензия

Лицензировано на условиях MIT. Смотрите файл [LICENSE](LICENSE)

## Используемые сторонние продукты

* [AMQP-CPP](https://github.com/CopernicaMarketingSoftware/AMQP-CPP) - для взаимодействия с Rabbit MQ на основе [лицензии Apache](licenses/AMQP-CPP_LICENSE)
* [POCO](https://github.com/pocoproject/poco) - для работы с сокетом по TCP протоколу для windows на основе [лицензии Boost](licenses/POCO_LICENSE)
