# sourcehut ♥ docker
Unofficial docker containers for hosting sourcehut.

This project was inspired by [ulyc's](https://git.sr.ht/~ulyc/) [sourcehut-docker](https://git.sr.ht/~ulyc/sourcehut-docker/tree/main)
project.
But since I was unable to get their *init.sh* to work,
I decided to write my own port.

Also I wanted my docker-compose to provide an image for each component
instead of providing one image with preconfigurable components.

## Configuration
There are multiple different ways 
in which you might want to configure your sourcehut deployment:

### Adding/Disabling services
To add or remove services, 
you can simply remove the given services
from the (docker-compose.yml)[./docker-compose.yml]
(I recommend commenting out the services instead, 
because it makes re-adding them again later easier).

Keep in mind, 
that you cannot remove every service,
as some services may be required by others.
It is best to consult the sourcehut documentation
before removing services.
A couple of good places to start,
are the (installation guide)[https://man.sr.ht/installation.md]
and the (configuration guide)[https://man.sr.ht/configuration.md].

### Changing the sourchut configuration

As stated in the (configuration guide)[https://man.sr.ht/configuration.md],
sourcehut uses a central configuration file:

> sr.ht services all use a shared configuration file, [...].
> The specific options you will configure 
> will depend on the subset of 
> and configuration of sr.ht services you choose to run.

We also use this configuration file,
and link it to every sourcehut-service-container.

Before you can start all the services,
you should rename the (config.example.ini)[./config/config.example.ini],
located in the config folder,
to *config.ini* and adjust the content to your liking.

Most importantly, we'll need to generate a couple of keys:
First of all navigate into the base directory,
and run `sudo ./Dockerfile` [^1] to build a base image.
We'll need this image later, when we are building the services,
but for now, we can use it to generate our keys.

To do that, 
we can run the container and append the `srht-keygen` command.

That way we can generate a service key 
using `doas docker run sr.ht-base srht-keygen service` [^1],
and a network key using 
`doas docker run sr.ht-base srht-keygen network` [^1].

Now you have to copy those keys (seperatly) 
and paste them into the appropriate section in the *config.ini*,
you just created.

> service-key=
> network-key=

We also need to create a public/private keypair for webhooks.
Luckily, the *srht-keygen* util can also do that:
`doas docker run sr.ht-base srht-keygen webhook` [^1]
This time around, we only want to copy the private key,
and put it in the *config.ini*

> private-key=

You should store the public key though,
as it has to be distributed to every webhook client.
For now, just put the public key into a *pub.key* file.

Additionally sourcehut requires you to setup email using SMTP.
If you do not have a email account with smtp/imap support,
you might want to have a look at
[docker-mailserver](https://github.com/docker-mailserver/)
or [purelymail](https://purelymail.com).

> smtp-host=<smtp-server>
> smtp-port=<smtp-server-port>
> smtp-from=<sender@email.com>
> smtp-user=<smtp-username>
> smtp-password=<smtp-password>
> error-to=<receiver@email.com>
> error-from=<sender@email.com>

After adding your smtp details,
you have to generate a pgp key,
to enableemail verification.

First of all, run `gpg --generate key` to generate a new keyair.
It should print something like this:
> pub   ed25519 yyyy-mm-dd [SC] [expires: yyyy-mm-dd]
>       <key-id>
> uid                      Jakob Meier <hut@ccw.icu>
> sub   cv25519 yyyy-mm-dd [E] [expires: yyyy-mm-dd]

Now copy the key id and run `gpg --pinentry-mode loopback --passwd <key-id>`
to remove the password from the private key.
Afterwards, you can export the public and private keys:
- public key: `ppg --armor --export <key-id> > config/email.pub`
- private key: `gpg --armor --export-secret-keys <key-id>  > config/email.priv`
and put your key id into the config file:
> pgp-key-id=<your-key-id>

For more information,
you should consult the official sourcehut configuration.
Additionally, 
every sourcehut service (that requires configuration),
has a *config.example.ini* located in its root folder,
i.e the [meta.sh.ht repo](https://git.sr.ht/~sircmpwn/meta.sr.ht/tree/master/item/config.example.ini)

## Building
You can manage this project with *docker-compose*,
but because my base image is not on docker-hub,
you'll have to build it yourself.

After the base container has been build,
you can navigate back into the project root
and use `doas docker compose build`[^1]
to build all other containers.

## Additional configuration
Now that we know how to get a base installation up and running,
it is time to add more services.
This means adding serviced to the docker-compose file,
and configuring them in the config.ini.

Below is a guide for supported services

[^1]: If you have configured docker/podman for non-sudo mode, 
    you may run the command without the sudo. 
    If you are using doas, you might have to replace sudo with doas
