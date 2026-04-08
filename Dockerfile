# 基礎鏡像
FROM ghcr.io/openclaw/openclaw:latest

# 宣告要接收來自 compose 的參數
ARG OPENCLAW_DOCKER_APT_PACKAGES

# 以 root 執行安裝
USER root

# 若有設定預安狀套件變數時，會預先安裝套件
RUN if [ -n "$OPENCLAW_DOCKER_APT_PACKAGES" ]; then \
    apt-get update && \
    apt-get install -y $OPENCLAW_DOCKER_APT_PACKAGES && \
    rm -rf /var/lib/apt/lists/*; \
    fi

# 務必換回 node 使用者確保權限
USER 1000:1000