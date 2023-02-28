
.PHONY: image images clean run shell

clean:
	sudo rm -rf Gemfile.lock vendor

images: image

image:
	docker build  -t zoomwh .

run:
	test -f .environment || exit 5
	@mkdir -p log
	@touch log/events.log
	@docker rm zoomwh &> /dev/null || true
	source ./.environment ; docker run -v $$PWD:/app -p 8888:4567 -it --name zoomwh -e ZOOM_SECRET=$$ZOOM_SECRET -e ZOOM_WH_SLACK_WH_URI=$$ZOOM_WH_SLACK_WH_URI zoomwh rake app

shell:
	docker exec -it zoomwh /bin/bash
