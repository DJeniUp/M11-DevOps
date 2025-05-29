# Build stage
FROM golang:1.24 as builder

WORKDIR /app
COPY . .
RUN go build -o main main.go

# Run stage
FROM debian:bookworm-slim
COPY --from=builder /app/main /main
EXPOSE 4444
ENTRYPOINT ["/main"]
