# observium
Observium docker image and docker-compose.yml

Built with RANCID, rsyslog, and smokeping

## Simple method (docker-compose):
1. Install [docker](https://docs.docker.com/engine/installation/), [docker-compose](https://docs.docker.com/compose/install/) and git

2. Clone this repository
```
$ git clone $THIS_GIT_REPO
$ cd observium
```

3. Set config
      - Open and modify `mysql.env`, if you want to configure parameters.
      - Open and modify `observium.env`, and change the domain and admin credentials.
      - Set Timezone and Lang in `system.env`

4. Open docker-compose.yml
      - Set ports if desired. Observium listens on 8080, 514/udp for syslog.
      - Below are the list of volumes used:
- `/data/docker/observium/data/mysql` - MySQL
- `/data/docker/observium/data/rrd` - rrd
- `/data/docker/observium/data/logs` - observium logs
- `/data/docker/observium/data/html` - html data
- `/data/docker/observium/data/mibs` - mibs snmp
- `/data/docker/observium/data/scripts` - scripts
- `/data/docker/observium/data/ssh_keys` - Read later for ssh key details
- `/data/docker/observium/data/rancid_configs` - set RANCID config here
- `/data/docker/observium/data/rancid_logs` - RANCID logs

5. Start the services
```
$ docker-compose up -d
```

6. What is id_rsa for?
Using RANCID to connect to network devices without a password, it should have a
key to log in. Do not set a passphrase on the key. Devices should have a user
named rancid.
```
$ ssh-keygen -t rsa
$ scp ~/.ssh/id_rsa.pub admin@<mikrotik_ip>:mykey.pub
```

### Professional image build
This is the easiest method for building, but it leaves the credentials in
`docker history`.

```
cd images
docker build \
  --build-arg INSTALL_METHOD=pro \
  --build-arg SVN_USER=MYUSER \
  --build-arg SVN_PASS=SECRET \
  -t observium \
  .
```

In order to build without saving the credentials, use this approach instead:

```
cd images
svn co -q $SVN_REPO --username $SVN_USER --password $SVN_PASS observium
docker build \
  --build-arg INSTALL_METHOD=pro \
  --build-arg SVN_USER=MYUSER \
  --build-arg SVN_PASS=SECRET \
  -t observium \
  .
```
