#!/bin/bash

# Assigning the load_balancer_address to a variable
load_balancer_address="${load_balancer_address}"

# Generating the environment file
cat <<EOF > /home/ubuntu/SmartHome/.env.local
LIGHTING_SERVICE=http://$load_balancer_address
HEATING_SERVICE=http://$load_balancer_address
AUTH_SERVICE=http://$load_balancer_address:3000
EOF
