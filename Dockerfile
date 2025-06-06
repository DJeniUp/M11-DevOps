FROM golang:1.24-alpine AS build

WORKDIR /app
COPY . .

RUN go build -o main main.go

FROM alpine:latest

WORKDIR /root/
COPY --from=build /app/main .

EXPOSE 4444

CMD ["./main"]
