# Stage 1: Build Go application
FROM golang:1.22 AS builder

WORKDIR /usr/src/app

COPY go.mod go.sum ./

RUN go mod download && go mod verify

COPY . .

RUN go build -v -o /usr/local/bin/app ./...

# Stage 2: Build Nginx with Go application
FROM nginx:1.27.0-alpine

COPY --from=builder /usr/local/bin/app /usr/local/bin/app

COPY ./nginx/nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD service nginx start && /usr/local/bin/app
