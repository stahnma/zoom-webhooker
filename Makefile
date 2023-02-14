

clean:
	sudo rm -rf Gemfile.lock vendor

image:
	docker build  -t zoomwh .

run:
	@docker rm zoomwh &> /dev/null || true
	docker run -v $$PWD:/app -p 8888:4567 -it --name zoomwh zoomwh /bin/bash

shell:
	docker exec -it zoomwh /bin/bash
