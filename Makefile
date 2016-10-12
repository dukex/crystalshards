update: bin/update
	./bin/update

bin/micrate:
	crystal build bin/micrate.cr -o bin/micrate --release

bin/update:
	crystal build bin/update.cr -o bin/update --release

clean:
	rm -Rf ./bin/update


all: clean bin/update bin/micrate

.PHONY: update all
