#!/bin/bash

# Ejecuto el comando de ansible con el inventario indicado 
ansible-playbook -i inventarios/inventario.yml playbooks/iniciarNodosManejados.yml

