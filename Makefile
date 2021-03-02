.PHONY: deploy
REMOTE_DOCKER_HOST = 178.154.201.73
USER = user

sync:
	wget -mkEpnp --random-wait --reject '*.net,*.txt' https://www.chiark.greenend.org.uk/~sgtatham/bugs.html
	docker build -t bugs-site:latest .
	rm -rf ./www.chiark.greenend.org.uk
deploy:
	./deploy.sh $(USER) $(REMOTE_DOCKER_HOST) 