.PHONY: all build

all: build

clean:
	./mvnw clean

verify:
	./mvnw verify

build: clean verify
