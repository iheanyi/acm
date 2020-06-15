#!/bin/sh
set -e

# NEEDS THE FOLLOWING VARS IN ENV:
# DOMAIN
# DNSIMPLE_TOKEN
# HEROKU_API_KEY
# HEROKU_APP

# Only run once per week (Heroku scheduler runs daily)
if [ "$(date +%u)" = 1 ]
then
  # Download dependencies
  git clone https://github.com/acmesh-official/acme.sh.git
  cd ./acme.sh

  # Force ensures it doesnt fail because of lack of cron
  ./acme.sh --install --force

  # Map to environment variables that the ACME script requires
  export DNSimple_OAUTH_TOKEN=$DNSIMPLE_TOKEN

  # Generate wildcard certificate (this will take approx 130s)
  ~/.acme.sh/acme.sh --issue -d $DOMAIN  -d "*.$DOMAIN"  --dns dns_dnsimple

  # Always attempt to install Heroku CLI because it may not exist on the dyno.
  npm install -g heroku

  # Update the certificate in the live app
  heroku certs:update "/app/.acme.sh/$DOMAIN/fullchain.cer" "/app/.acme.sh/$DOMAIN/$DOMAIN.key" --confirm $HEROKU_APP --app $HEROKU_APP
fi
