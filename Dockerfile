# Imagem base
FROM ubuntu:latest

# Instala as dependências necessárias
RUN apt-get update && apt-get install -y curl git unzip xz-utils zip libglu1-mesa

# Baixa e instala o SDK do Flutter
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter
ENV PATH="$PATH:/usr/local/flutter/bin"

# Executa os comandos do Flutter para pré-compilar o SDK
RUN flutter precache

# Define o diretório de trabalho
WORKDIR /app

# Copia os arquivos do aplicativo para o container
COPY . .

# Executa o build do aplicativo com o Flutter
RUN flutter build apk --release

# Define o comando padrão para iniciar o aplicativo
CMD ["flutter", "run", "--release"]