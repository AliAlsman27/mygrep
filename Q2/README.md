# Troubleshooting internal.example.com

## Step 1: Checking DNS

First, I checked if `internal.example.com` can be resolved.
I used:

```bash
dig internal.example.com
```

The result showed `NXDOMAIN`, meaning the domain doesn't exist in the system DNS.

Then I tested with Google’s DNS:

```bash
dig internal.example.com @8.8.8.8
```

It also showed `NXDOMAIN`. This confirms the domain is internal and not found on the public internet.
It needs either an internal DNS server or a manual entry in `/etc/hosts`.

---

## Step 2: Checking Service Reachability

Next, I tried to see if the web service was reachable.

First, I used:

```bash
curl -I http://internal.example.com
```

It failed to connect.

Then I tried:

```bash
telnet internal.example.com 80
```
and
```bash
nc -vz internal.example.com 80
```

Both commands failed to establish a connection.

Finally, I checked if any service was listening on ports 80 or 443:

```bash
sudo netstat -tulnp | grep ':80\|:443'
```
or
```bash
sudo ss -tulnp | grep ':80\|:443'
```

There were no services found listening on either port.

---

## Conclusion

DNS resolution failed because `internal.example.com` is not a public domain.
Also, the web service isn't reachable because no server is listening on ports 80 or 443.
Both DNS setup and web service configuration need to be fixed.
