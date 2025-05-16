#!/bin/bash

# Ejecuto el comando de ansible con el inventario indicado 
ansible-playbook -i inventarios/inventario2.ini playbooks/web.yaml

