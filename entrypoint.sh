#!/bin/bash
apache2 -v

source /usr/bin/install.sh

#Starting services
apache2-foreground
service apache2 reload

exit