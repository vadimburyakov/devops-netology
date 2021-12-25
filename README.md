# Домашнее задание к занятию "4.3. Языки разметки JSON и YAML"

## Обязательная задача 1
Мы выгрузили JSON, который получили через API запрос к нашему сервису:
```
    { "info" : "Sample JSON output from our service\t",
        "elements" :[
            { "name" : "first",
            "type" : "server",
            "ip" : 7175 
            }
            { "name" : "second",
            "type" : "proxy",
            "ip : 71.78.22.43
            }
        ]
    }
```
  Нужно найти и исправить все ошибки, которые допускает наш сервис

Ответ:
```json
{
   "info": "Sample JSON output from our service\t",
   "elements": [
      {
         "name": "first",
         "type": "server",
         "ip": 7175
      },
      {
         "name": "second",
         "type": "proxy",
         "ip": "71.78.22.43"
      }
   ]
}
```
## Обязательная задача 2
В прошлый рабочий день мы создавали скрипт, позволяющий опрашивать веб-сервисы и получать их IP. К уже реализованному функционалу нам нужно добавить возможность записи JSON и YAML файлов, описывающих наши сервисы. Формат записи JSON по одному сервису: `{ "имя сервиса" : "его IP"}`. Формат записи YAML по одному сервису: `- имя сервиса: его IP`. Если в момент исполнения скрипта меняется IP у сервиса - он должен так же поменяться в yml и json файле.

### Ваш скрипт:
```python
#!/usr/bin/env python3

import json
import yaml
import socket
import pickle

# services = {'drive.google.com': '74.125.131.194', 'mail.google.com': '64.233.165.18', 'google.com': '64.233.163.100'}
with open('services.pickle', 'rb') as f:
    services = pickle.load(f)

for host in services.keys():
    ip = socket.gethostbyname(host)
    if ip == services[host]:
        print(f"{host} - {ip}")
    else:
        print(f"[ERROR] {host} IP mismatch: {services[host]} {ip}")
        services[host] = ip

with open('services.pickle', 'wb') as f:
    pickle.dump(services, f)

with open('services.json', 'w') as f:
    json.dump(services, f, indent = 4)

with open('services.yaml', 'w') as f:
    yaml.dump(services, f, indent = 4, default_flow_style=False, explicit_start=True, explicit_end=True)
```

### Вывод скрипта при запуске при тестировании:
```
$ ./my_scr_4.py
drive.google.com - 74.125.131.194
mail.google.com - 74.125.131.83
[ERROR] google.com IP mismatch: 173.194.73.113 173.194.73.138
```

### json-файл(ы), который(е) записал ваш скрипт:
```json
{
    "drive.google.com": "74.125.131.194",
    "mail.google.com": "74.125.131.83",
    "google.com": "173.194.73.138"
}
```

### yml-файл(ы), который(е) записал ваш скрипт:
```yaml
---
drive.google.com: 74.125.131.194
google.com: 173.194.73.138
mail.google.com: 74.125.131.83
...

```