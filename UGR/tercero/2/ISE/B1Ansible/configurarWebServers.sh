#!/bin/bash

# Ejecuto el comando de ansible con el inventario indicado 
ansible-playbook -i inventarios/inventario2.yml playbooks/configuraWebServers.yml

