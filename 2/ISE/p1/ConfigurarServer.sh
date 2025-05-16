#!/bin/bash

# Ejecuto el comando de ansible con el inventario indicado 
ansible-playbook -i inventarios/inventario.ini playbooks/Configurar.yaml

