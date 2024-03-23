## XmlTV Docker
### Docker Hub Repository Documentation

#### This docker image install from source code (main branch) the xmltv, instead of just installing it from apk, this docker is based on alpine:latest, and build for:
##### - linux/amd64
##### - linux/armv6
##### - linux/armv7
##### - linux/arm64

#### Environment Variables

| Variable             | Description                                              | Default Value       |
|----------------------|----------------------------------------------------------|----------------------|
| htpasswd_password    | Password for accessing the web xmltv.                       | `generated see logs` |
| tv_grab_command      | Command to grab TV listings.                             | `tv_grab_pt_vodafone` |
| days                 | Number of days for fetching TV  Electronic Program Guide (EPG) .                 | `1`                  |

You can override the default values by assigning your desired values when running the Docker container.

#### Example Docker Run Command

```bash
docker run -d -p 80:80 \
-e htpasswd_password="your_xmltv_web_password" \
-e tv_grab_command="your_tv_grab_command" \
-e days="number_of_days" \
cyberpoison/xmltv-docker
```
#### Exemple Docker Run Command using the default variables (See above)

```bash
docker run -d -p 80:80 cyberpoison/xmltv-docker
```

Note: 

Original code: https://github.com/XMLTV/xmltv

Dockerfile and scripts: https://github.com/CyberPoison/xmltv-docker

Docker image: https://hub.docker.com/r/cyberpoison/xmltv-docker
