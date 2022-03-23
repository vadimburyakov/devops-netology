# 5.1. Введение в виртуализацию. Типы и функции гипервизоров. Обзор рынка вендоров и областей применения.
### 1. Опишите кратко, как вы поняли: в чем основное отличие полной (аппаратной) виртуализации, паравиртуализации и виртуализации на основе ОС.
Главное отличие полной виртуализации, паравиртуализации и виртуализации на основе ОС состоит в степени "модификации" гостевой операционной системы.
```TEXT
а. Полная виртуализация: гостевая ОС не подвергается изменению, остается в исходном состоянии.
б. Паравиртуализация: у гостевых ОС вносятся изменения в ядро.
в. Виртуализации на основе ОС: гостевые ОС используют ядро основной ОС сервера.
```
### 2. Выберите один из вариантов использования организации физических серверов, в зависимости от условий использования.
#### а. Высоконагруженная база данных, чувствительная к отказу.
```TEXT
Физические сервера:
Обеспечивается высокая производительность и минимальное время отклика, более высокая 
отказоустойчивость за счет исключения промежуточного звена - виртуализации.
Ресурсы сервера не разделяются между различными ВМ и оптимальным образом используются 
для главного приложения. 
```
#### б. Различные web-приложения.
```TEXT
Виртуализация уровня ОС:
Оптимальное использование ресурсов, быстрота масштабирования, сокращение издержек, 
связанных с администрированием и сопровождением.
```
#### в. Windows системы для использования бухгалтерским отделом.
```TEXT
Паравиртуализация:
Обеспечивается достаточная отказоустойчивость, при этом нет потребности в высокой 
производительности, т.е. нет необходимости эксклюзивного использования физических 
ресурсов.
```
#### г. Системы, выполняющие высокопроизводительные расчеты на GPU.
```TEXT
Физические сервера:
Обеспечивается высокая производительность за счет эксклюзивного использования аппаратных
ресурсов и исключения промежуточного слоя - виртуализации.
```
### 3. Выберите подходящую систему управления виртуализацией для предложенного сценария. Детально опишите ваш выбор.
```TEXT
1. 100 виртуальных машин на базе Linux и Windows, общие задачи, нет особых требований. 
Преимущественно Windows based инфраструктура, требуется реализация программных
балансировщиков нагрузки, репликации данных и автоматизированного механизма создания 
резервных копий.

Ответ: 
Hyper-V, также можно vSphere.  Удовлетворяют всем требованиям сценария. 
Поддерживают Windows и Linux. Содержат средства балансировки нагрузки, 
репликации данных и автоматизированного механизма создания резервных копий.
```
```TEXT
2. Требуется наиболее производительное бесплатное open source решение для виртуализации небольшой 
(20-30 серверов) инфраструктуры на базе Linux и Windows виртуальных машин.

Ответ:
KVM, Xen PV. Оpen source, поддерживают Linux и Windows.
```
```TEXT
3. Необходимо бесплатное, максимально совместимое и производительное решение для виртуализации 
Windows инфраструктуры.

Ответ:
Hyper-V Server. Максимально совместимый c Windows, бесплатный продукт.
```
```TEXT
4. Необходимо рабочее окружение для тестирования программного продукта на нескольких дистрибутивах Linux.

Ответ:
KVM. Является нативным для большинства ядер Linux, имеет хороршую производительность.
Каждая гостевая машина работает как процесс на хостовой машине, что хорошо для 
обнаружения источника проблемы при тестировании.
```
### 4. Опишите возможные проблемы и недостатки гетерогенной среды виртуализации (использования нескольких систем управления виртуализацией одновременно) и что необходимо сделать для минимизации этих рисков и проблем. Если бы у вас был выбор, то создавали бы вы гетерогенную среду или нет? Мотивируйте ваш ответ примерами.
```TEXT
Проблемы и недостатки гетерогенной среды виртуализации: необходимость поддержки 
разных систем, что требует увеличение затрат на оборудование, ПО и найм 
дорполнительных специалистов. 
Кроме того, более сложные и разноплановые системы снижают управляемость 
инфраструктурой, масштабируемость, а также уменьшают надежность и 
отказоустойчивость.
Поэтому лучше избегать использования гетерогенной среды. Если же нет возможности 
перейти на единообразную платформу, лучше использовать среды виртуализации
с более низким порогом входа. Также в этом случае будет полезно использовать 
программные системы мониторинга (Tivoli Monitoring, System Center и др.), 
чтобы минимизировать риски "зоопарка систем".
```

# 5.2. Применение принципов IaaC в работе с виртуальными машинами
### Задача 1
```TEXT
Опишите своими словами основные преимущества применения на практике IaaC паттернов.

Ответ:
Ускорение процесса создания инфраструктуры за счет автоматизации, стабильность
и предсказуемость инфраструктуры, уменьшение ошибок, более простая и эффективная 
поддержка и развитие сред, более быстрая разработка конечного продукта.
```
```TEXT
Какой из принципов IaaC является основополагающим?

Ответ:
Идемпотентность. Идентичность результата при повторных выполнениях, что 
обеспечивает предсказуемость конфигурации.
 ```
### Задача 2
```TEXT
Чем Ansible выгодно отличается от других систем управление конфигурациями?

Ответ:
Ansible более прост в использовании, использует существующую SSH инфраструктуру, 
в то время как другие инструменты требуют установки специального PKI-окружения,
расширяем (легкое подключение кастомных ролей и иодулей).
```
```TEXT
Какой, на ваш взгляд, метод работы систем конфигурации более надёжный push или pull?

Ответ:
Метод push обеспечивает большую надежность, т.к. при нем происходит централизованное
управление конфигурациями. Это дает возможность в любой момент времени
иметь актуальную информацию о конфигурациях, делает процесс управления конфигурациями
более прозрачным и предсказуемым.  
 ```
### Задача 3
```TEXT
Установить на личный компьютер:
  VirtualBox
  Vagrant
  Ansible
Приложить вывод команд установленных версий каждой из программ, оформленный в markdown.
```
Ответ:
```bash
~$ vboxmanage --version
6.1.28r147628
~$ vagrant --version
Vagrant 2.2.19
~$ ansible --version
ansible 2.9.27
  config file = /etc/ansible/ansible.cfg
  configured module search path = [u'/home/user/.ansible/plugins/modules', u'/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python2.7/dist-packages/ansible
  executable location = /usr/bin/ansible
  python version = 2.7.17 (default, Feb 27 2021, 15:10:58) [GCC 7.5.0]
```

# 5.3. Введение. Экосистема. Архитектура. Жизненный цикл Docker контейнера
### Задача 1
Ссылка на ответ: https://hub.docker.com/r/vadimburyakov/netology-homework53-nginx 
### Задача 2
```TEXT
Сценарий 1
Высоконагруженное монолитное java веб-приложение.

Решение
Физический сервер. При высокой нагруженности затраты ресурсов на виртуализацию - не желательны. 
Монолитность затрудняет возможность реализации в микросервисах. 
С другой стороны, при возможности масштабирования можно использовать докер.
 ```
```TEXT
Сценарий 2
Nodejs веб-приложение.

Решение
Докер. Позволяет быстро разворачивать и масштабировать приложение.
 ```
```TEXT
Сценарий 3
Мобильное приложение c версиями для Android и iOS.

Решение
Возможно подойдет виртуальная машина, что позволит создать окружение для приложения.
 ```
```TEXT
Сценарий 4
Шина данных на базе Apache Kafka.

Решение
Докер. Дает возможность организации кластера с оркестратором и возможность быстрого отката.
 ```
```TEXT
Сценарий 5
Elasticsearch кластер для реализации логирования продуктивного веб-приложения - три ноды elasticsearch, 
два logstash и две ноды kibana.

Решение
Докер или виртуальная машина. Докер удобнее для кластеризации.
 ```
```TEXT
Сценарий 6
Мониторинг-стек на базе Prometheus и Grafana.

Решение
Докер. Невысокая загруженность, быстрое развертывание и масштабируемость под доп. задачи.
 ```
```TEXT
Сценарий 7
MongoDB, как основное хранилище данных для java-приложения.

Решение
Докер или физический сервер. С одной стороны даже есть официальный докер-образ. 
С другой стороны, при высокой нагрузке лучше использовать физический сервер. 
 ```
```TEXT
Сценарий 8
Gitlab сервер для реализации CI/CD процессов и приватный (закрытый) Docker Registry.

Решение
Виртуальная машина. Нет необходимости в масштабировании и постоянном обновлении. Возможна миграция.
 ```
### Задача 3
Запуск первого контейнера (из образа centos c любым тэгом) в фоновом режиме, с подключением папки /data из
текущей рабочей директории на хосте в /data контейнера.
```bash
~$ docker run -it -d --name centos -v ~/data:/data centos
2d9a24497620b4b2d89fa5ff2b59db97d175ac4589d46360a7e856df6485b381
```
Запуск второго контейнера (из образа debian с любым тегом) в фоновом режиме, с подключением папки /data из 
текущей рабочей директории на хосте в /data контейнера.
```bash
~$ docker run -it -d --name debian -v ~/data:/data debian
4c1ac1e24b8ceae6540772b0282bd6bf529a0c48c7d050cccaff687ced604d45
```
Подключение к первому контейнеру с помощью docker exec и создание текстового файла любого содержания в /data.
```bash
~$ docker exec -it centos bash
[root@2d9a24497620 /]# echo "hello frm centos" > /data/centos.txt
[root@2d9a24497620 /]# exit
exit
```
Добавление еще одного файл в папку /data на хостовой машине.
```bash
~$ echo "hello frm host" > ~/data/host.txt
```
Подключение во второй контейнер и отображение листинга и содержания файлов в /data контейнера.
```bash
~$ docker exec -it debian bash
root@4c1ac1e24b8c:/# ls -l /data
total 8
-rw-r--r-- 1 root root 17 Feb  5 11:44 centos.txt
-rw-rw-r-- 1 1000 1000 15 Feb  5 11:46 host.txt
root@4c1ac1e24b8c:/# cat /data/centos.txt
hello frm centos
root@4c1ac1e24b8c:/# cat /data/host.txt
hello frm host
root@4c1ac1e24b8c:/# exit
exit

```

# 5.4. Оркестрация группой Docker контейнеров на примере Docker Compose
### Задача 1
Образ операционной системы, созданный с помощью Packer.
![](screenshots/5.4_task1.1.png)
![](screenshots/5.4_task1.2.png)
### Задача 2
Скриншот страницы свойств созданной ВМ.
![](screenshots/5.4_task2.png)
### Задача 3
Скриншот работающего веб-интерфейса Grafana с текущими метриками.
![](screenshots/5.4_task3.png)

# 5.5. Оркестрация кластером Docker контейнеров на примере Docker Swarm
### Задача 1
Дайте письменные ответы на следующие вопросы:
```TEXT
В чём отличие режимов работы сервисов в Docker Swarm кластере: replication и global?

Ответ:
Режим replication: задается число запускаемых на кластере реплик сервиса. Распределение реплик между узлами 
осуществляется системой таким образом, что на одном узле может быть 0, 1 и более реплик. 
В случае режима global на каждом узле запускается ровно одна реплика сервиса. 
```
```TEXT
Какой алгоритм выбора лидера используется в Docker Swarm кластере?

Ответ:
Используется Raft алгоритм.
```
```TEXT
Что такое Overlay Network?

Ответ:
Overlay Network - это внутренняя сеть, которая охватывает все узлы, участвующие в swarm-кластере, соединяет
демоны Docker между собой и обеспечивает взаимодействие swarm служб.
```
### Задача 2
Создан Docker Swarm кластер в Яндекс.Облаке

Скриншот вывода команды `docker node ls`
![](screenshots/5.5_task2.png)
### Задача 3
Создан готовый к боевой эксплуатации кластер мониторинга, состоящий из стека микросервисов.

Скриншот вывода команды `docker service ls`
![](screenshots/5.5_task3.png)

# 6.1. Типы и структура СУБД
### Задача 1
Выберите подходящие типы СУБД для каждой сущности и объясните свой выбор.
```TEXT
Электронные чеки в json виде.

Ответ:
Документо-ориентированная. Стандартный способ хранения документов json. 
```
```TEXT
Склады и автомобильные дороги для логистической компании.

Ответ:
Графовая. Склады и дороги математически представляют собой граф (вершины и ребра).
```
```TEXT
Генеалогические деревья.

Ответ:
Иерархическая. Генеалогические деревья имеют иерархическую структуру.
```
```TEXT
Кэш идентификаторов клиентов с ограниченным временем жизни для движка аутентификации.

Ответ:
Ключ-значение. Классический подход для данного примера.
```
```TEXT
Отношения клиент-покупка для интернет-магазина.

Ответ:
Реляционная БД. Такие БД специально создавались для работы с отношениями.
```
### Задача 2
Классификация реализаций согласно CAP, PACELC.
```TEXT
1. Если предполагается, что система всегда доступна, но узлы могут ответить не одинаково
(данные не согласованы), т.к. долго не синхронизируются (устойчивы к разделению), то по CAP: AP.
По PACELC - (PA/EL), т.к., действительно, ближе Latency. 
2. Если система все-таки отвечает, хотя и не корректно (или даже сбрасывает соединение),
избегая дать несогласованные данные, то по CAP - СА, по PACELC - (PC/EC), т.к. 
приоритет - согласованность. 
3. Система может не прислать корректный ответ или сбросить соединение: по CAP: CP, по PACELC - (PC/EC)
```
### Задача 3
Могут ли в одной системе сочетаться принципы BASE и ACID? Почему?
```TEXT
Нет. Эти принципы противоречат друг другу. По ACID данные согласованы, а по BASE нет. 
```
### Задача 4
Ответ:
```TEXT
Redis - key-value хранилище, имеющее механизм Pub/Sub. В данном случае установка ключей с ttl +
подписка на нотификацию о просроченных ключах.
Минусы: Ограничение хранилища - все данные должны поместиться в оперативной памяти. Redis предлагает
только базовую безопасность, нет механизма ролей. Отсутствует язык запросов (типа SQL) - теряется гибкость. 
```
