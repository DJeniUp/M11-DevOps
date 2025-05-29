FROM debian:bookworm-slim
COPY main /main
EXPOSE 4444
CMD ["/main"]
