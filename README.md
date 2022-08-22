# Fly Italy Adsb-stats
Fly Italy Adsb Statistics Beta

You must be running Fly Italy Adsb feeder.

Stats only.  Be sure to install Fly Italy Adsb feeder package first.

### STEP 1: FEEDER PACKAGE

```
wget -O /tmp/flyitalyadsbfeed.sh https://raw.githubusercontent.com/flyitalyadsb/fly-italy-adsb/master/install.sh
sudo bash /tmp/flyitalyadsbfeed.sh
```

### STEP 2: STATS

```
wget -O /tmp/axstats.sh https://raw.githubusercontent.com/flyitalyadsb/flyitalyadsb-stats/master/stats.sh
sudo bash /tmp/axstats.sh
```

### Show stats URL on console
```
flyitalyadsb-showurl
```


### Systemd Status

```
sudo systemctl status flyitalyadsb-stats
```

### Restart

```
sudo systemctl restart flyitalyadsb-stats
```

### Figure the URL out yourself

Replace UUID with the flyitalyadsb-stats generated uuid and USER:

https://statistiche.flyitalyadsb.com/login?feed=UUID&user=USER



### Uninstall

```
sudo bash /usr/local/share/flyitalyadsb-stats/uninstall.sh
```

