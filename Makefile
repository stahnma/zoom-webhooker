
.PHONY: image images clean run shell

clean:
	sudo rm -rf Gemfile.lock vendor

images: image

image:
	docker build  -t zoomwh .
	make -C kafka image

run:
	test -f .environment || exit 5
	@docker rm zoomwh &> /dev/null || true
	source ./.environment ; docker run -v $$PWD:/app -p 8888:4567 -it --name zoomwh -e ZOOM_SECRET=$$ZOOM_SECRET zoomwh /bin/bash

shell:
	docker exec -it zoomwh /bin/bash
