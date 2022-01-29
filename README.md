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
отказоустойчивость за счет исключения промежуточного звена - виртуализации,
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
