FROM kalilinux/kali-rolling

RUN apt update -y && apt upgrade -y && apt -y install curl

COPY . .

RUN chmod 755 ./google-dorks-grabber.sh

ENTRYPOINT ["./google-dorks-grabber.sh"]