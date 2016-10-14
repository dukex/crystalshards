all: clean bin/update bin/micrate

update: bin/update
	./bin/update

bin/micrate:
	crystal build bin/micrate.cr -o bin/micrate --release

bin/update:
	crystal build bin/update.cr -o bin/update --release

migrate_up: bin/micrate
	./bin/micrate up

migrate_down: bin/micrate
	./bin/micrate down

clean:
	rm -Rf ./bin/update

.PHONY: update all
