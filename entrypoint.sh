#!/bin/bash
apache2 -v

source /usr/bin/starting.sh

#Starting services
apache2-foreground
service apache2 reload

exit