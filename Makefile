build:
    go build -o bin/goconductor

test:
    go test ./...

fmt:
    gofmt -w .

clean:
    rm -rf ./bin
