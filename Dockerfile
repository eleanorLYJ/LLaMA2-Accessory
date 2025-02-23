# 選擇合適的基礎映像，例如官方的 PyTorch CUDA 映像
# FROM nvidia/cuda:11.7.1-devel-ubuntu22.04
FROM nvidia/cuda:11.1.1-cudnn8-devel-ubuntu20.04


# 設定工作目錄
WORKDIR /workspace

# 安裝基本工具與 Python 3.10
RUN apt update && apt install -y \
    python3.10 python3.10-venv python3-pip git wget nano && \
    ln -s /usr/bin/python3.10 /usr/bin/python && \
    ln -s /usr/bin/pip3 /usr/bin/pip

# 建立 Python 虛擬環境
RUN python -m venv /workspace/venv && \
    . /workspace/venv/bin/activate && \
    pip install --upgrade pip

# 複製當前目錄 (LLaMA2-Accessory/) 到容器內
COPY . /workspace/LLaMA2-Accessory

# 安裝 requirements.txt 內的依賴
RUN . /workspace/venv/bin/activate && pip install -r /workspace/LLaMA2-Accessory/requirements.txt

# 選擇性安裝 FlashAttention
RUN . /workspace/venv/bin/activate && pip install flash-attn --no-build-isolation

# 安裝 Apex (可選)
RUN git clone https://github.com/NVIDIA/apex /workspace/apex && \
    cd /workspace/apex && \
    . /workspace/venv/bin/activate && \
    pip install -v --disable-pip-version-check --no-cache-dir --no-build-isolation --config-settings "--build-option=--cpp_ext" --config-settings "--build-option=--cuda_ext" ./

# 安裝 LLaMA2-Accessory 作為 Python package
RUN cd /workspace/LLaMA2-Accessory && \
    . /workspace/venv/bin/activate && \
    pip install -e .

# 設定環境變數
ENV PATH="/workspace/venv/bin:$PATH"

# 預設進入 bash 環境
CMD ["/bin/bash"]