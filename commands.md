Allocate a GPU instance
```bash
salloc --partition lrz-hgx-h100-92x4 --gres=gpu:1 --time=4:00:00 --qos=gpu
```

Enter the GPU instance
```bash
srun --pty bash
```

Import an enroot container:
```bash
enroot import docker://ubuntu
enroot import docker://tomasruiz/slurm-dev:1.1
```

Create an enroot container:
```bash
enroot create --name my_custom_pt $DSS_HOME/tomasruiz/my_custom_pt.sqsh
```

Enter a container, e.g. Pytorch
```bash
enroot start --rw --root \
    --mount /dss/dsshome1/0D/di38bec/code:/workspace/code \
    --mount /dss/dsshome1/0D/di38bec/datasets:/workspace/datasets \
    --mount $DSS_HOME:$DSS_HOME \
    my_custom_pt
```

Show your GPU ussage in real time:
```bash
alias wgpu='watch -n0.1 nvidia-smi'
```

In case you are disconnected from a worker node/container, you can re-enter it with:
```bash
sattach <job_id.0>
```

export an enroot container to a sqsh file:
```bash
cd $DSS_HOME/tomasruiz/
mv my_custom_pt.sqsh my_custom_pt.sqsh.bak
enroot export -o my_custom_pt.sqsh my_custom_pt
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

Run a synchronous job (This is not the same as a batch job, which is recommended for running long jobs).
```bash
srun -K \
    --container-mounts /dss/dsshome1/0D/di38bec/code:/workspace/code \
    --container-mounts /dss/dsshome1/0D/di38bec/datasets:/workspace/datasets \
    --container-mounts $DSS_HOME:$DSS_HOME \
    --container-workdir=$(pwd) \
    --container-image=/dss/dsshome1/0D/di38bec/my_custom_pt.sqsh \
    --ntasks=1 \
    --nodes=1 \
    --partition=lrz-hgx-h100-94x4 \
    --gpus=1 \
    --job-name test-job \
    --no-container-remap-root \
    --time 1:00:00 \
    echo "Hello, world!"
```

squeue --me --name=<job name> --states=R -h -O NodeList

Check DSS Storage Details. You must be in the login node.
```shell
dssusrinfo all
```