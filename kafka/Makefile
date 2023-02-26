NAME=kafka

.PHONY: kafka clean run shell image

clean:
	sudo rm -rf Gemfile.lock vendor kafka

kafka:
	./setup_builds.sh


image: kafka
	test -d kafka || echo "You need to run kafka/setup.sh" 
	docker build  -t $(NAME) .

run:
	@docker rm $(NAME) &> /dev/null || true
	docker run -v $$PWD:/app -p 9092:9092 -it --name $(NAME) $(NAME) /bin/bash

shell:
	docker exec -it $(NAME) /bin/bash
