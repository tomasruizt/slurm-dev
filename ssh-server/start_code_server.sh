#!/bin/bash
# Replace <PASSWORD HASH> below with the argon2 hash of the
# password of your choice.
# Run the following command and copy the output here:
#
# echo -n <your password> | argon2 $(openssl rand -base64 32) -e
#
export HASHED_PASSWORD='<PASSWORD HASH>'

# Choose a port based on the job id
export PORT=$(((${SLURM_JOB_ID} + 10007) % 16384 + 49152))

# Use the latest version of code server
export CODE_SERVER="$(find /netscratch/software/ -name 'code-server-*-linux-amd64.tar.gz' -printf "%T@ %p\n" | sort -n | cut -d ' ' -f2 | tail -1)"
if [ -z "$CODE_SERVER" ]
then
      echo "ERROR: no code server package found; check that /netscratch/software is in --container-mounts"
      exit 1
fi

# Print the URL where the IDE will become available
echo
echo =========================================
echo =========================================
echo =========================================
echo
echo using $CODE_SERVER
echo
echo IDE will be available at:
echo
echo $HOSTNAME.ai.lrz.de:$PORT
echo
echo Please wait for setup to finish.
echo
echo =========================================
echo =========================================
echo =========================================
echo

# Extract the IDE files
tar -f "$CODE_SERVER" -C /tmp/ -xz

# Install extensions
/tmp/code-server-*/bin/code-server \
    --user-data-dir=.code-server \
    --install-extension="ms-python.python" \
    # --install-extension="ms-python.vscode-pylance" \

# Start the IDE
/tmp/code-server-*/bin/code-server \
    --disable-telemetry \
    --disable-update-check \
    --bind-addr=$HOSTNAME.ai.lrz.de:$PORT \
    --auth password \
    --cert "/home/$SLURM_JOB_USER/.cert/pegasus.crt" \
    --cert-key "/home/$SLURM_JOB_USER/.cert/pegasus.key" \
    --user-data-dir=.code-server \
    "$(pwd)"