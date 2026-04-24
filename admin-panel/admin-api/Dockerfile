# syntax=docker/dockerfile:1

FROM golang:1.22-alpine AS builder
WORKDIR /src

COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o /out/admin-api ./main.go

FROM alpine:3.20
WORKDIR /app

RUN addgroup -S app && adduser -S app -G app

COPY --from=builder /out/admin-api /app/admin-api
RUN mkdir -p /app/uploads && chown -R app:app /app

USER app
EXPOSE 5656

CMD ["/app/admin-api"]
