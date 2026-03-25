# User Documentation

## Services Provided
This stack provides:
- `nginx`: HTTPS reverse proxy (port `443`) and TLS termination.
- `wordpress`: PHP-FPM + WordPress application.
- `mariadb`: WordPress database backend.

## Start And Stop
From the project root:

```bash
make
```

Stop containers:

```bash
make down
```

Restart existing containers:

```bash
make restart
```

## Access The Website And Admin Panel
1. Add this line to your `/etc/hosts`:
   - `127.0.0.1 ltcherep.42.fr`
2. Open:
   - Website: `https://ltcherep.42.fr`
   - Admin panel: `https://ltcherep.42.fr/wp-admin`

## Credentials Location
Credentials are stored as Docker secrets in:
- `secrets/db_root_password.txt`
- `secrets/db_password.txt`
- `secrets/admin_password.txt`

They are mounted inside containers under `/run/secrets/`.

## Verify Services Health
Check service status:

```bash
make ps
```

Follow logs:

```bash
make logs
```

Quick HTTP check:

```bash
curl -k -I --resolve ltcherep.42.fr:443:127.0.0.1 https://ltcherep.42.fr
```
