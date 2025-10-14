# setup git in case you need to commit changes
git config --global user.email "tomas.ruiz.te@gmail.com"
git config --global user.name "Tomas Ruiz"

# Install python 3.12
sudo add-apt-repository ppa:deadsnakes/ppa -y
sudo apt update
sudo apt install python3.12 python3.12-venv python3.12-dev -y

# Create venv
python3.12 -m venv ~/venv
. ~/venv/bin/activate
pip install uv
uv pip install -U pip

# Install dev vllm
git clone https://github.com/tomasruizt/vllm ~/code/vllm
cd ~/code/vllm
git checkout feature/correct-tensor-parallelism-on-draft-model
VLLM_USE_PRECOMPILED=1 uv pip install -e ".[bench]"
