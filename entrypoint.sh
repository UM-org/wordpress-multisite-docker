#!/bin/bash
apache2 -v
# Run WP-CLI Info
wp --info
apache2-foreground
exit