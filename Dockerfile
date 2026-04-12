# 基礎鏡像
FROM ghcr.io/openclaw/openclaw:latest
# FROM ghcr.io/1186258278/openclaw-zh:latest

# 宣告要接收來自 compose 的參數
ARG OPENCLAW_DOCKER_APT_PACKAGES

# 以 root 執行安裝
USER root

# 1. 針對 Debian 12 安裝 .NET SDK
RUN apt-get update && apt-get install -y wget gpg apt-transport-https && \
    # 加入微軟官方 Debian 12 套件金鑰與來源
    wget https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    rm packages-microsoft-prod.deb && \
    # 安裝 .NET 8 SDK 及其他參數套件
    apt-get update && \
    apt-get install -y dotnet-sdk-8.0 && \
    if [ -n "$OPENCLAW_DOCKER_APT_PACKAGES" ]; then \
    apt-get install -y $OPENCLAW_DOCKER_APT_PACKAGES; \
    fi && \
    rm -rf /var/lib/apt/lists/*

# 2. 安裝 dotnet-script 工具
RUN dotnet tool install dotnet-script --tool-path /usr/local/bin

# 3. 設定環境變數
ENV DOTNET_ROOT="/usr/share/dotnet"
ENV PATH="$PATH:/usr/local/bin"

# 4. 安裝QMD 記憶體後端
RUN npm install -g @tobilu/qmd

# 5. 初始化 dotnet-script 緩存
RUN dotnet-script eval "Console.WriteLine(\"C# Environment Ready\");"

# 務必換回 node 使用者確保權限
USER 1000:1000