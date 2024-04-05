#!/bin/bash

rm /home/ubuntu/SmartHome/.env.local 
touch /home/ubuntu/SmartHome/.env.local
echo "LIGHTING_SERVICE=http://${lighting}:3000">> /home/ubuntu/SmartHome/.env.local
echo "HEATING_SERVICE=http://${heating}:3000">> /home/ubuntu/SmartHome/.env.local
echo "AUTH_SERVICE=http://${auth}}:3000">> /home/ubuntu/SmartHome/.env.local