# Subdomain Monitor

```sh
./recon.sh <target domain>
```

**Features:**
1. Search for new subdomains.
2. Send Discord Notifications.

**Automation**
- Set up cron job and let it be your subdomain monitor.

```sh
# set up cron job
$ crontab -e
0 9 * * * cd /your-path-to/subdomain-monitor && /bin/bash recon.sh <target> >> recon.log 2>&1

# confirm
$ crontab -l
```

**Environment Variables**
`.env`
```sh
WEBHOOK_URL="discord->channel->settings->Integrations->Webhook"
```

The folder should be like this:
```sh
.
├── README.md
├── recon.log
├── recon.sh
└── targets
    ├── target.one
    │   ├── history.txt
    │   ├── new_live_hosts.txt
    │   ├── new_subdomains.txt
    │   └── subdomains_raw.txt
    ├── target.two
    │   ├── history.txt
    │   ├── new_live_hosts.txt
    │   ├── new_subdomains.txt
    │   └── subdomains_raw.txt
    └── target.three
        ├── history.txt
        ├── new_live_hosts.txt
        ├── new_subdomains.txt
        └── subdomains_raw.txt
```
