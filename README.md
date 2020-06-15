# iheanyi-acm

This script can be run on Heroku using CRON and will automatically create and manage a wildcard SSL certificate issued by LetsEncrypt. It differs from the `outline-acm` script in that it uses DNSimple instead of Cloudflare for the DNS challenge.

Be sure to have the Heroku CLI Buildpack added to your application by running `heroku buildpacks:add https://github.com/heroku/heroku-buildpack-cli`.
