# 3.2. Работа в терминале, лекция 2
### 1. Какого типа команда cd? Попробуйте объяснить, почему она именно такого типа; опишите ход своих мыслей, если считаете что она могла бы быть другого типа.
`cd` - встроенная команда оболочки.
```bash
vagrant@vagrant:~$ type cd
cd is a shell builtin
```
Если бы она была другого типа (отдельной программой), то рабочий каталог менялся бы только в ее окружениии, и другие программы, запущенные от этого же родительского процесса, не видели бы изменений
### 2. Какая альтернатива без pipe команде grep <some_string> <some_file> | wc -l? man grep поможет в ответе на этот вопрос. Ознакомьтесь с документом о других подобных некорректных вариантах использования pipe.
`grep <some_string> <some_file> -c`
### 3. Какой процесс с PID 1 является родителем для всех процессов в вашей виртуальной машине Ubuntu 20.04?
Процесс `systemd`
### 4. Как будет выглядеть команда, которая перенаправит вывод stderr ls на другую сессию терминала?
`ls /fff 2>/dev/pts/1`
### 5. Получится ли одновременно передать команде файл на stdin и вывести ее stdout в другой файл? Приведите работающий пример.
`cat < file1 > file2`
### 6. Получится ли находясь в графическом режиме, вывести данные из PTY в какой-либо из эмуляторов TTY? Сможете ли вы наблюдать выводимые данные?
Нужно перенаправить вывод:
`echo hello > /dev/tty2`
Для просмотра нужно перейти, в нашем случае, в терминал tty2.
### 7. Выполните команду bash 5>&1. К чему она приведет? Что будет, если вы выполните echo netology > /proc/$$/fd/5? Почему так происходит?
Первая команда создаст новый дескриптор `5` для данной сессии и перенаправит его в `stdout`.
Вторая команда запишет строку `netology` в этот дескриптор, который перенаправит её в `stdout`.
### 8. Получится ли в качестве входного потока для pipe использовать только stderr команды, не потеряв при этом отображение stdout на pty? Напоминаем: по умолчанию через pipe передается только stdout команды слева от | на stdin команды справа. Это можно сделать, поменяв стандартные потоки местами через промежуточный новый дескриптор, который вы научились создавать в предыдущем вопросе.
Получится, например, с такой командой: `ls <some folder> 5>&1 1>&2 2>&5| grep <some string>`.
### 9. Что выведет команда cat /proc/$$/environ? Как еще можно получить аналогичный по содержанию вывод?
Команда `cat /proc/$$/environ` выводит переменные окружения. Аналогичный по содержанию вывод можно получить с помощью команды `env`.
### 10. Используя man, опишите что доступно по адресам `/proc/<PID>/cmdline`, `/proc/<PID>/exe`.
`/proc/[pid]/cmdline` - файл только для чтения, содержащий полную строку команды для процесса.
`/proc/[pid]/exe` - данный файл является символической ссылкой, содержащей актуальный путь исполняемой команды.
### 11. Узнайте, какую наиболее старшую версию набора инструкций SSE поддерживает ваш процессор с помощью /proc/cpuinfo.
`sse4_2`
Ответ получен с помощью команды `cat /proc/cpuinfo | grep sse`.
### 12. При открытии нового окна терминала и vagrant ssh создается новая сессия и выделяется pty. Это можно подтвердить командой tty, которая упоминалась в лекции 3.2. Однако:
```sh
vagrant@netology1:~$ ssh localhost 'tty'
not a tty
```
###    Почитайте, почему так происходит, и как изменить поведение.
Это происходит из-за того что при попытке выполнить команду `tty` удаленно через `SSH` `tty` не выделяется. Для принудительного выделения `tty` необходимо использовать ключ `-t`. В таком случае псевдотерминал 
выделится принудительно, даже если у текущего `SSH` его нет.
### 13. Бывает, что есть необходимость переместить запущенный процесс из одной сессии в другую. Попробуйте сделать это, воспользовавшись reptyr. Например, так можно перенести в screen процесс, который вы запустили по ошибке в обычной SSH-сессии.
Сделано.
### 14. sudo echo string > /root/new_file не даст выполнить перенаправление под обычным пользователем, так как перенаправлением занимается процесс shell'а, который запущен без sudo под вашим пользователем. Для решения данной проблемы можно использовать конструкцию echo string | sudo tee /root/new_file. Узнайте что делает команда tee и почему в отличие от sudo echo команда с sudo tee будет работать.
Команда `tee` читает из `STDIN` и записывает в `STDOUT` или в файл. В данном случае перенаправление в файл /root/new_file осуществляется в момент исполнения команды с sudo и поэтому проходит успешно. 

# 3.3. Операционные системы, лекция 1
### 1. Какой системный вызов делает команда cd? В прошлом ДЗ мы выяснили, что cd не является самостоятельной программой, это shell builtin, поэтому запустить strace непосредственно на cd не получится. Тем не менее, вы можете запустить strace на /bin/bash -c 'cd /tmp'. В этом случае вы увидите полный список системных вызовов, которые делает сам bash при старте. Вам нужно найти тот единственный, который относится именно к cd. Обратите внимание, что strace выдаёт результат своей работы в поток stderr, а не в stdout.
Системный вызов - `chdir("/tmp")`
### 2. Попробуйте использовать команду file на объекты разных типов на файловой системе. Например... Используя strace выясните, где находится база данных file на основании которой она делает свои догадки.
База данных - `/usr/share/misc/magic.mgc`. Кроме того, поиск осуществляется в: `~/.magic.mgc`, `~/.magic`, `/etc/magic.mgc`, `/etc/magic`. 
### 3. Предположим, приложение пишет лог в текстовый файл. Этот файл оказался удален (deleted в lsof), однако возможности сигналом сказать приложению переоткрыть файлы или просто перезапустить приложение – нет. Так как приложение продолжает писать в удаленный файл, место на диске постепенно заканчивается. Основываясь на знаниях о перенаправлении потоков предложите способ обнуления открытого удаленного файла (чтобы освободить место на файловой системе).
1. По `pid` находим дескриптор файла `<fd>`.
2. Записываем в файл пустое значение с удалением содержимого: `echo '' > /proc/<pid>/fd/<fd>`.
### 4. Занимают ли зомби-процессы какие-то ресурсы в ОС (CPU, RAM, IO)?
Зомби-процессы не занимают ресурсы (освобождают их), при этом остается запись в таблице процессов.
### 5. В iovisor BCC есть утилита opensnoop: ... На какие файлы вы увидели вызовы группы open за первую секунду работы утилиты? Воспользуйтесь пакетом bpfcc-tools для Ubuntu 20.04.
``` bash
root@vagrant:~# dpkg -L bpfcc-tools | grep sbin/opensnoop
/usr/sbin/opensnoop-bpfcc
root@vagrant:~# /usr/sbin/opensnoop-bpfcc
PID    COMM               FD ERR PATH
769    vminfo              4   0 /var/run/utmp
579    dbus-daemon        -1   2 /usr/local/share/dbus-1/system-services
579    dbus-daemon        17   0 /usr/share/dbus-1/system-services
579    dbus-daemon        -1   2 /lib/dbus-1/system-services
579    dbus-daemon        17   0 /var/lib/snapd/dbus-1/system-services/
```
### 6. Какой системный вызов использует uname -a? Приведите цитату из man по этому системному вызову, где описывается альтернативное местоположение в /proc, где можно узнать версию ядра и релиз ОС.
Cистемный вызов - `uname()`. 
`man`:
```TEXT
Part of the utsname information is also accessible  via  /proc/sys/kernel/{ostype, hostname, osrelease, version, domainname}.
```
### 7. Чем отличается последовательность команд через ; и через && в bash? Например:... Есть ли смысл использовать в bash &&, если применить set -e?
`;` - разделитель команд, вторая команда запустится независимо от статуса завершения первой. `&&` - тоже разделитель, но в этом случае вторая команда не запустится, если первая завершится с ошибкой.
Если применить `set -e`, то произойдет выход из сценария при ненулевом коде возврата команды, однако если с ошибкой завершится одна из команд, разделённых &&, кроме последней, то выхода из сценария не произойдёт. 
### 8. Из каких опций состоит режим bash set -euxo pipefail и почему его хорошо было бы использовать в сценариях?
```TEXT
  -e - сценарий завершится если команда завершится с ненулевым статусом
  -u - сценарий завершится, при попытке использовать незаданную переменную
  -x - выведет команды и их аргументы по мере выполнения
  -o pipefail - вернет статус последней команды с ошибкой в пайплайне
```
Это хорошо использовать в сценариях т.к.: `-x` подробно покажет работу сценария, `-u` завершит сценарий при попытке использовать незаданную переменную, а `-e` совместно с `pipefail` покажут на какой команде произошла ошибка сценария.

### 9. Используя -o stat для ps, определите, какой наиболее часто встречающийся статус у процессов в системе. В man ps ознакомьтесь (/PROCESS STATE CODES) что значат дополнительные к основной заглавной буквы статуса процессов. Его можно не учитывать при расчете (считать S, Ss или Ssl равнозначными).
Наиболее часто встречающийся статус - `S`: прерываемый сон (ожидает события для завершени), а также - `I`: неактивный процесс ядра. Дополнительные (к основной) буквы статуса процесса: < - процесс с высоким приоритетом, N - процесс с низким приоритетом, s - процесс инициировавший сессию. 

# 3.4. Операционные системы, лекция 2
### 1. На лекции мы познакомились с node_exporter. В демонстрации его исполняемый файл запускался в background. Этого достаточно для демо, но не для настоящей production-системы, где процессы должны находиться под внешним управлением. Используя знания из лекции по systemd, создайте самостоятельно простой unit-файл для node_exporter.

Unit-файл /etc/systemd/system/nex.service:
```TEXT
[Unit]
Description=node_exporter

[Service]
EnvironmentFile=/opt/node_exporter-1.3.0.linux-amd64/nex.env
ExecStart=/opt/node_exporter-1.3.0.linux-amd64/node_exporter $EXTRA_OPTS

[Install]
WantedBy=multi-user.target
```
Файл для добавления опций /opt/node_exporter-1.3.0.linux-amd64/nex_env:
```TEXT
EXTRA_OPTS="--log.level=info"
```
Запущены команды:
```TEXT
systemctl daemon-reload -применение настроек
systemctl enable nodex - добавление в автозагрузку
systemctl start nodex - запуск
systemctl status nodex - просмотр статуса
systemctl stop nodex - остановка
```
Проверено, что с помощью systemctl процесс корректно стартует, завершается, а после перезагрузки автоматически поднимается.

### 2. Ознакомьтесь с опциями node_exporter и выводом /metrics по-умолчанию. Приведите несколько опций, которые вы бы выбрали для базового мониторинга хоста по CPU, памяти, диску и сети.
CPU:
```TEXT
node_cpu_seconds_total{cpu="0",mode="iowait"} 135.71
node_cpu_seconds_total{cpu="0",mode="system"} 49.81
node_cpu_seconds_total{cpu="0",mode="user"} 24.84
node_cpu_seconds_total{cpu="1",mode="iowait"} 141.63
node_cpu_seconds_total{cpu="1",mode="system"} 63.78
node_cpu_seconds_total{cpu="1",mode="user"} 26.47
```
Память:
```TEXT
node_memory_MemAvailable_bytes 7.1888896e+08
node_memory_MemFree_bytes 1.92479232e+08
node_memory_MemTotal_bytes 1.028694016e+09
node_memory_SwapFree_bytes 1.027600384e+09
```
Диск:
```TEXT
node_disk_io_now{device="sda"} 0
node_disk_io_time_seconds_total{device="sda"} 262.75600000000003
node_disk_io_time_weighted_seconds_total{device="sda"} 1083.036
node_disk_read_bytes_total{device="sda"} 3.45965568e+08
```
Сеть:
```TEXT
node_network_receive_bytes_total{device="eth0"} 4.2784829e+07
node_network_receive_drop_total{device="eth0"} 0
node_network_transmit_bytes_total{device="eth0"} 1.592844e+06
node_network_transmit_drop_total{device="eth0"} 0
```
### 3. Установите в свою виртуальную машину Netdata. Воспользуйтесь готовыми пакетами для установки (sudo apt install -y netdata). 
Netdata установлена, в файлы внесены изменения, порт проброшен, vagrant перезагружен. С метриками ознакомился.

### 4. Можно ли по выводу dmesg понять, осознает ли ОС, что загружена не на настоящем оборудовании, а на системе виртуализации?
Да, можно. Вывод `dmesg`:
```bash
[    0.000000] DMI: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[    0.000000] Hypervisor detected: KVM
```
### 5. Как настроен sysctl fs.nr_open на системе по-умолчанию? Узнайте, что означает этот параметр. Какой другой существующий лимит не позволит достичь такого числа (ulimit --help)?
Для получения `fs.nr_open` нужно запустить команду: `sysctl -n fs.nr_open`. Значение показывает максимальное количество открытых файлов на процесс,
по умолчанию - 1048576. Это значение не позволит достичь другой лимит: `open files` из вывода команды: `ulimit -a`, значение по умолчанию у
которого - 1024.

### 6. Запустите любой долгоживущий процесс (не ls, который отработает мгновенно, а, например, sleep 1h) в отдельном неймспейсе процессов; покажите, что ваш процесс работает под PID 1 через nsenter.
```bash
root@vagrant:~# ps -e | grep sleep
   1550 pts/0    00:00:00 sleep
root@vagrant:~# nsenter --target 1550 --pid --mount
root@vagrant:/# ps
    PID TTY          TIME CMD
      1 pts/0    00:00:00 sleep
      2 pts/0    00:00:00 bash
```
### 7. Найдите информацию о том, что такое :(){ :|:& };:. Запустите эту команду в своей виртуальной машине Vagrant с Ubuntu 20.04 (это важно, поведение в других ОС не проверялось). Некоторое время все будет "плохо", после чего (минуты) – ОС должна стабилизироваться. Вызов dmesg расскажет, какой механизм помог автоматической стабилизации. Как настроен этот механизм по-умолчанию, и как изменить число процессов, которое можно создать в сессии?
:(){ :|:& };: - форкбомба. 
Это функция, которая рекурсивно запускает саму себя и результат отправляет через пайп себе на вход для запуска в бэкграунде. Данный процесс упирается в ограничение `ulimit -u` (количество процессов на пользователя).
Сообщение в `dmesg`:
```bash
[ 1934.590198] cgroup: fork rejected by pids controller in /user.slice/user-1000.slice/session-3.scope
```
Количество процессов на пользователя можно поменять командой  `ulimit -u N`, `N`  - новое значение.

# 3.5. Файловые системы
### 1. Узнайте о sparse (разряженных) файлах.
Сделано
### 2. Могут ли файлы, являющиеся жесткой ссылкой на один объект, иметь разные права доступа и владельца? Почему?
Нет, т.к. жесткие ссылки ссылаются на один inode, у которого имеются права доступа и владелец.
### 3. Сделайте vagrant destroy на имеющийся инстанс Ubuntu. Замените содержимое Vagrantfile следующим:... Данная конфигурация создаст новую виртуальную машину с двумя дополнительными неразмеченными дисками по 2.5 Гб.
Добавлены диски `sdb`, `sdc`.
```bash
sdb                    8:16   0  2.5G  0 disk 
sdc                    8:32   0  2.5G  0 disk 
```
### 4. Используя fdisk, разбейте первый диск на 2 раздела: 2 Гб, оставшееся пространство.
Сделано
```bash
root@vagrant:~# fdisk -l /dev/sdb
Disk /dev/sdb: 2.51 GiB, 2684354560 bytes, 5242880 sectors
Disk model: VBOX HARDDISK
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0xf9b6efb5

Device     Boot   Start     End Sectors  Size Id Type
/dev/sdb1          2048 4196351 4194304    2G 83 Linux
/dev/sdb2       4196352 5242879 1046528  511M 83 Linux
```
### 5. Используя sfdisk, перенесите данную таблицу разделов на второй диск.
```bash
root@vagrant:~# sfdisk -d /dev/sdb > partitions
root@vagrant:~# sfdisk /dev/sdc < partitions
...
Device     Boot   Start     End Sectors  Size Id Type
/dev/sdc1          2048 4196351 4194304    2G 83 Linux
/dev/sdc2       4196352 5242879 1046528  511M 83 Linux
```
### 6. Соберите mdadm RAID1 на паре разделов 2 Гб.
```bash
root@vagrant:~# mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/sdb1 /dev/sdc1
```
### 7. Соберите mdadm RAID0 на второй паре маленьких разделов.
```bash
root@vagrant:~# mdadm --create /dev/md1 --level=0 --raid-devices=2 /dev/sdb2 /dev/sdc2
```
### 8. Создайте 2 независимых PV на получившихся md-устройствах.
```bash
root@vagrant:~# pvcreate /dev/md1 /dev/md0
  Physical volume "/dev/md1" successfully created.
  Physical volume "/dev/md0" successfully created.
```
### 9. Создайте общую volume-group на этих двух PV
```bash
root@vagrant:~# vgcreate vol_grp1 /dev/md1 /dev/md0
  Volume group "vol_grp1" successfully created
root@vagrant:~# vgs
  VG        #PV #LV #SN Attr   VSize   VFree 
  vgvagrant   1   2   0 wz--n- <63.50g     0 
  vol_grp1    2   0   0 wz--n-  <2.99g <2.99g
```
### 10. Создайте LV размером 100 Мб, указав его расположение на PV с RAID0.
```bash
root@vagrant:~# lvcreate -L 100M -n log_vol0 vol_grp1 /dev/md1
  Logical volume "log_vol0" created.
root@vagrant:~# lvs
  LV       VG        Attr       LSize   Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  root     vgvagrant -wi-ao---- <62.54g
  swap_1   vgvagrant -wi-ao---- 980.00m
  log_vol0 vol_grp1  -wi-a----- 100.00m
```
### 11. Создайте mkfs.ext4 ФС на получившемся LV.
```bash
root@vagrant:~# mkfs.ext4 /dev/vol_grp1/log_vol0
mke2fs 1.45.5 (07-Jan-2020)
Creating filesystem with 25600 4k blocks and 25600 inodes

Allocating group tables: done                            
Writing inode tables: done                            
Creating journal (1024 blocks): done
Writing superblocks and filesystem accounting information: done
```
### 12. Смонтируйте этот раздел в любую директорию, например, /tmp/new.
```bash
root@vagrant:~# mkdir /tmp/new
root@vagrant:~# mount /dev/vol_grp1/log_vol0 /tmp/new
```
### 13. Поместите туда тестовый файл, например wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz
```bash
root@vagrant:~# wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz
root@vagrant:~# ls -l /tmp/new
total 22064
drwx------ 2 root root    16384 Nov 30 22:49 lost+found
-rw-r--r-- 1 root root 22574425 Nov 29 09:55 test.gz
```
### 14. Прикрепите вывод lsblk.
```bash
root@vagrant:~# lsblk
NAME                    MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
sda                       8:0    0   64G  0 disk
├─sda1                    8:1    0  512M  0 part  /boot/efi
├─sda2                    8:2    0    1K  0 part
└─sda5                    8:5    0 63.5G  0 part
  ├─vgvagrant-root      253:0    0 62.6G  0 lvm   /
  └─vgvagrant-swap_1    253:1    0  980M  0 lvm   [SWAP]
sdb                       8:16   0  2.5G  0 disk
├─sdb1                    8:17   0    2G  0 part
│ └─md0                   9:0    0    2G  0 raid1
└─sdb2                    8:18   0  511M  0 part
  └─md1                   9:1    0 1018M  0 raid0
    └─vol_grp1-log_vol0 253:2    0  100M  0 lvm   /tmp/new
sdc                       8:32   0  2.5G  0 disk
├─sdc1                    8:33   0    2G  0 part
│ └─md0                   9:0    0    2G  0 raid1
└─sdc2                    8:34   0  511M  0 part
  └─md1                   9:1    0 1018M  0 raid0
    └─vol_grp1-log_vol0 253:2    0  100M  0 lvm   /tmp/new
```
### 15. Протестируйте целостность файла:
```bash
root@vagrant:~# gzip -t /tmp/new/test.gz
root@vagrant:~# echo $?
0
```
### 16. Используя pvmove, переместите содержимое PV с RAID0 на RAID1.
```bash
root@vagrant:~# pvmove /dev/md1 /dev/md0
  /dev/md1: Moved: 12.00%
  /dev/md1: Moved: 100.00%
```
### 17. Сделайте --fail на устройство в вашем RAID1 md.
```bash
root@vagrant:~# mdadm /dev/md0 --fail /dev/sdc1
mdadm: set /dev/sdc1 faulty in /dev/md0
```
### 18. Подтвердите выводом dmesg, что RAID1 работает в деградированном состоянии.
```bash
root@vagrant:~# dmesg | grep md0 
...
[ 3335.862185] md/raid1:md0: Disk failure on sdc1, disabling device.
               md/raid1:md0: Operation continuing on 1 devices.
```
### 19. Протестируйте целостность файла, несмотря на "сбойный" диск он должен продолжать быть доступен:
```bash
root@vagrant:~# gzip -t /tmp/new/test.gz
root@vagrant:~# echo $?
0
```
### 20. Погасите тестовый хост, vagrant destroy.
Сделано