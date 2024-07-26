### Deploy PhpMyAdmin on Fly.io with Private Tailscale Network

This guide will show you how to deploy PhpMyAdmin on Fly.io with a private Tailscale network. This will allow you to access PhpMyAdmin securely from your local machine or smartphone.

#### When you need this phpMyAdmin setup ?

- When you want to access your database securely from anywhere as long as you have a tailscale client on your device, and you don't want to expose your phpMyAdmin to the public internet.

#### Prerequisites

- A Fly.io account
- A Tailscale account
- A MySQL database

#### Setup

#### 1. Create a tailscale auth key

Create a reusable auth key in tailscale: https://login.tailscale.com/admin/settings/authkeys

#### 2. Setup fly

Give the app the name you want. Don't deploy yet.

```
fly launch --no-deploy
```

? fly.toml file already exits would you like copy its configuration : (yes/no) yes

#### 3. Set the environment variables

- you can copy the `.env.example` file to `.env` and fill in the values.

```
cat .env | fly secrets import
```

#### 4. Deploy and scale (optional)

```
fly deploy
```

Now, you can access your phpMyAdmin by accessing the IP address of the tailscale network.
such as 100.xxx.xxx.xxx

And you can also access by the [Tailnet](https://tailscale.com/kb/1217/tailnet-name) name of the tailscale network. such as `fly-pma.mother-father.ts.net`

And you can also ssh into the machine by running:

```
ssh root@<TAILSCALE_HOSTNAME>
```
You need to enable the magic DNS feature in tailscale to resolve the hostname. and configure ACLs to allow SSH access.
you can read more about allowing ssh access in tailscale [here](https://tailscale.com/kb/1193/tailscale-ssh)

Why do we need to ssh into the machine?

- You might need to run some commands on the machine, such as installing additional packages, or configuring the server.
- You might need to access the logs of the server to debug any issues.
- You might need to access the database directly from the server.
- You might need to access the phpMyAdmin configuration file.

or whatever you need to do on the server. without running fly commands, such as `fly ssh console` and you don't need login to flyctl.