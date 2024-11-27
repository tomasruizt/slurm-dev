Allocate a GPU instance
```bash
salloc -p lrz-hgx-h100-92x4 --gres=gpu:1
```

Enter the GPU instance
```bash
srun --pty bash
```

Import an enroot container:
```bash
enroot import docker://ubuntu
enroot import docker://tomasruiz/slurm-dev:1.0
```

Create an enroot container:
```bash
enroot create --name my_container ubuntu.sqsh
```

Enter a container, e.g. Pytorch
```bash
enroot start --rw --root --mount /dss/dsshome1/0D/di38bec/code/workspace:/workspace/ pytorch+pytorch+2.4.0-cuda12.4-cudnn9-devel
```

Launch nohup Python process
```bash
nohup python my_script.py >> my_script.log 2>&1 &
```

Launch a python debugger session
```bash
python -m debugpy --listen 0.0.0.0:5678 --wait-for-client scripty.py
```

To install `flash_attn` (from [this link](https://github.com/Dao-AILab/flash-attention/issues/509#issuecomment-1981942916))
```bash
export FLASH_ATTENTION_SKIP_CUDA_BUILD=TRUE
```

show the gpus by node (search for lines like `AllocTRES=cpu=90,mem=600G,gres/gpu=1`)
```bash
scontrol show nodes
```

srun -K \
    --container-mounts /dss/dsshome1/0D/di38bec/code/workspace:/workspace/ \
    --container-workdir=$(pwd) \
    --container-image=/dss/dsshome1/0D/di38bec/tomasruiz+slurm-dev+1.0.sqsh \
    --ntasks=1 \
    --nodes=1 \
    -p lrz-hgx-h100-92x4 \
    --gpus=1 \
    --job-name tomas-slurm-dev-job \
    --no-container-remap-root \
    --time 1:00:00 /usr/sbin/sshd -D -e

squeue --me --name=<job name> --states=R -h -O NodeList


Create an HTTPs certificate (From https://pegasus.dfki.de/docs/slurm-cluster/debugging/).
```shell
mkdir -p ~/.cert
openssl req -x509 -newkey rsa:4096 -days 365 -nodes \
  -keyout ~/.cert/pegasus.key -out ~/.cert/pegasus.crt -sha256 \
  -subj "/C=DE/ST=Bayern/L=Munich/O=LMU/OU=CSS/CN=*.ai.lrz.de"
```

Start the VSCode server:
````
srun \
  --container-image=/dss/dsshome1/0D/di38bec/pytorch+pytorch+2.4.0-cuda12.4-cudnn9-devel.sqsh \
  --container-mounts=/dss/dsshome1/0D/di38bec/code/netscratch/software:/netscratch/software:ro,"`pwd`":"`pwd`" \
  --container-workdir="`pwd`" \
  --time=01:00:00 \
  --gpus=1 \
  -p lrz-hgx-h100-92x4 \
  start_code_server.sh
```