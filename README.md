# devops-netology

В каталоге terraform/ будут проигнорированы следующие файлы:
1. **/.terraform/* - все файлы, находящиеся в каталогах .terraform/. Сами каталоги .terraform/ могут находиться на любом уровне вложенности.
2. *.tfstate - все файлы с раcширением tfstate
3. *.tfstate.* - все файлы, содержащие в названии строку .tfstate.
4. crash.log - все файлы crash.log
5. *.tfvars - все файлы с раcширением tfvars
6. override.tf - все файлы override.tf
7. override.tf.json - все файлы override.tf.json
8. *_override.tf - все файлы, название которых завершается на _override.tf
9. *_override.tf.json - все файлы, название которых завершается на _override.tf.json
10. .terraformrc - все файлы .terraformrc
11. terraform.rc - все файлы terraform.rc
