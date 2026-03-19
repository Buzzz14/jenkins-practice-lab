FROM ubuntu:22.04 
 
WORKDIR /app 
COPY . . 
 
RUN apt update && apt install -y bash 
 
CMD ["bash", "app.sh"]
