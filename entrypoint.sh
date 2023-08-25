#!/bin/bash
apache2 -v
# Run WP-CLI Info
wp --info
apache2-foreground
service apache2 reload
exit