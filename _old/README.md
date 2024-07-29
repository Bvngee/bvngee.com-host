# bvngeecord.com Docker Hosting

This is my overly complicated setup for hosting my personal website, bvngeecord.com, on an nginx server in a docker container. It has automated SSL Certificate management via acme.sh, as well as automatic redeployment by listening for the GitHub webhooks I setup for whenever I push to the repo containing the website source files and rebuilds the source.

Key things to note:
acme.sh stores data (automatic configuration files, CA account into, copies of the SSL certs, etc) in a folder located at /root/.acme.sh/ in the docker container. This should be mounted as a volume so that the instance doesn't have to reissue and install the certificates every single time it is started. **The container will detect if the /root/.acme.sh folder exists and is populated and will change its init behaviour automatically.**

If building locally (all of the config files would be needed in the current working directory), build with:
```docker build -t bvngeecord.com .```
The image should then be listen under `docker ps -a`.

Run the container with (assuming bvngeecord.com is the image name):
```docker run -it -v $(pwd)/acme.sh-data:/root/.acme.sh -p 80:80 -p 443:443 -d bvngeecord.com```
(Optionally, a `--name my-container-instance` may be added if id's are too annoying.) The `-v` argument creates a persistent folder in the current working directory called acme.sh-data in which the /root/.acme.sh folder is mounted on each container start.

The container can be safely started and stopped with `docker start <container_id>` and `docker stop <container_id>`, and it will automatically run the redeploy script in case it is out of date.

In case things go wrong, attach to the foreground process of the container with:
```docker attach <container_id>```
Or, start a new interactive bash terminal with:
```docker exec -it <container_id> bash```
