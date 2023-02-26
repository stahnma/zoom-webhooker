NAME=kafka

clean:
	sudo rm -rf Gemfile.lock vendor

image:
	docker build  -t $(NAME) .

run:
	@docker rm $(NAME) &> /dev/null || true
	docker run -v $$PWD:/app -p 9092:9092 -it --name $(NAME) $(NAME) /bin/bash

shell:
	docker exec -it $(NAME) /bin/bash
