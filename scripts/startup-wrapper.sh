#!/bin/sh
if [ -e "${STARTUP_SCRIPT}"  ]
then
    echo "Startup script: ${STARTUP_SCRIPT}"
    echo "Executing startup script"
    sh "${STARTUP_SCRIPT}"

else
    echo "No startup script found"
fi