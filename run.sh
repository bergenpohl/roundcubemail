#!/bin/zsh

docker run --name localhost -it -p 80:80 -p 443:443 -p 587:587 -p 465:465 -p 143:143 -p 993:993 localhost_image
