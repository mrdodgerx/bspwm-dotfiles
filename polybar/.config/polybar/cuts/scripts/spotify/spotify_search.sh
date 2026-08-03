#!/usr/bin/env python3

import subprocess, json, os, sys, urllib.request, urllib.parse, time, os.path, base64

CONFIG_DIR = os.path.expanduser("~/.config/polybar/cuts/scripts/spotify")
CREDENTIALS = os.path.join(CONFIG_DIR, "credentials")
CACHE_FILE = "/tmp/spotify_token_cache"
ROFI_THEME = os.path.expanduser("~/.config/polybar/cuts/scripts/rofi/styles.rasi")

def load_credentials():
    creds = {}
    with open(CREDENTIALS) as f:
        for line in f:
            line = line.strip()
            if "=" in line and not line.startswith("#"):
                k, v = line.split("=", 1)
                creds[k.strip()] = v.strip().strip('"').strip("'")
    return creds

def get_token(client_id, client_secret):
    if os.path.exists(CACHE_FILE):
        with open(CACHE_FILE) as f:
            expiry, token = f.read().strip().split(" ", 1)
        if int(time.time()) < int(expiry):
            return token

    data = urllib.parse.urlencode({"grant_type": "client_credentials"}).encode()
    req = urllib.request.Request("https://accounts.spotify.com/api/token", data=data)
    auth = base64.b64encode(f"{client_id}:{client_secret}".encode()).decode()
    req.add_header("Authorization", f"Basic {auth}")
    req.add_header("Content-Type", "application/x-www-form-urlencoded")

    resp = json.loads(urllib.request.urlopen(req).read())
    token = resp["access_token"]
    expiry = int(time.time()) + resp["expires_in"] - 60
    with open(CACHE_FILE, "w") as f:
        f.write(f"{expiry} {token}")
    return token

def rofi_input(prompt):
    p = subprocess.run(
        ["rofi", "-no-config", "-dmenu", "-p", prompt, "-theme", ROFI_THEME, "-l", "1"],
        input="", capture_output=True, text=True
    )
    return p.stdout.strip()

def rofi_select(items, prompt):
    p = subprocess.run(
        ["rofi", "-no-config", "-dmenu", "-p", prompt, "-theme", ROFI_THEME, "-l", "8"],
        input="\n".join(items), capture_output=True, text=True
    )
    return p.stdout.strip()

def search_tracks(token, query):
    params = urllib.parse.urlencode({"q": query, "type": "track", "limit": "10"})
    req = urllib.request.Request(f"https://api.spotify.com/v1/search?{params}")
    req.add_header("Authorization", f"Bearer {token}")
    data = json.loads(urllib.request.urlopen(req).read())

    results = []
    for t in data.get("tracks", {}).get("items", []):
        artists = ", ".join(a["name"] for a in t["artists"])
        name = t["name"].replace("|", "-")
        artists = artists.replace("|", "-")
        dur = t["duration_ms"] // 1000
        label = f'{name} — {artists}  ({dur//60}:{dur%60:02d})'
        results.append((label, t["uri"], t["id"]))
    return results

if not os.path.exists(CREDENTIALS):
    subprocess.run(["notify-send", "-u", "critical", "Spotify Search", f"Missing {CREDENTIALS}"])
    sys.exit(1)

creds = load_credentials()
cid = creds.get("SPOTIFY_CLIENT_ID", "")
csecret = creds.get("SPOTIFY_CLIENT_SECRET", "")

if not cid or not csecret:
    subprocess.run(["notify-send", "-u", "critical", "Spotify Search", "Invalid credentials file"])
    sys.exit(1)

query = rofi_input("  Search Spotify")
if not query:
    sys.exit(0)

try:
    token = get_token(cid, csecret)
except Exception as e:
    subprocess.run(["notify-send", "-u", "critical", "Spotify Search", f"Auth failed: {e}"])
    sys.exit(1)

try:
    results = search_tracks(token, query)
except Exception as e:
    subprocess.run(["notify-send", "-u", "critical", "Spotify Search", f"Search failed: {e}"])
    sys.exit(1)

if not results:
    subprocess.run(["notify-send", "Spotify Search", f"No results for \"{query}\""])
    sys.exit(0)

labels = [r[0] for r in results]
uris = [r[1] for r in results]

sel = rofi_select(labels, "  Select")
if not sel:
    sys.exit(0)

for i, label in enumerate(labels):
    if label == sel:
        subprocess.Popen(["dbus-send", "--print-reply",
            "--dest=org.mpris.MediaPlayer2.spotify",
            "/org/mpris/MediaPlayer2",
            "org.mpris.MediaPlayer2.Player.OpenUri",
            f"string:{uris[i]}"],
            stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        break
