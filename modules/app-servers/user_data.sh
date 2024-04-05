#!/bin/bash

rm /home/ubuntu/SmartHome/.env.local 
touch /home/ubuntu/SmartHome/.env.local
echo "LIGHTING_SERVICE=http://${load_balancer_address}">> /home/ubuntu/SmartHome/.env.local
echo "HEATING_SERVICE=http://${load_balancer_address}">> /home/ubuntu/SmartHome/.env.local
echo "AUTH_SERVICE=http://${load_balancer_address}:3000">> /home/ubuntu/SmartHome/.env.local