# File Centipede auto-activation image

[![Build and publish](https://github.com/smashah/file-centipede-auto-activate/actions/workflows/publish.yml/badge.svg)](https://github.com/smashah/file-centipede-auto-activate/actions/workflows/publish.yml)

This is a small child image of `jlesage/file-centipede`. It fetches the active
public trial code from File Centipede's GitHub page and enters it through the
native activation dialog. It does not patch File Centipede, generate keys, or
write undocumented values into its database.

The watcher stays running, so it also handles the next expiry without requiring
a container restart. Accepted activation state remains in the normal `/config`
volume.

## Use the published image

In Unraid, change the existing File Centipede container's **Repository** field
to:

```text
ghcr.io/smashah/file-centipede-auto-activate:latest
```

Keep the existing mappings, especially the stable writable appdata mapping:

```text
/mnt/user/appdata/file-centipede -> /config (read/write)
```

No privileged mode, Docker socket, or extra capabilities are needed. The image
uses the same `USER_ID`, `GROUP_ID`, `TZ`, ports, and storage/output mappings as
the upstream container.

## Build locally

```sh
docker build -t file-centipede-auto-activate:local .
```

The default base is the tested `jlesage/file-centipede:26.03.1`. To test a newer
base explicitly:

```sh
docker build \
  --build-arg BASE_IMAGE=jlesage/file-centipede:latest \
  -t file-centipede-auto-activate:local .
```

The optional environment variables are:

- `AUTO_ACTIVATE=0` disables the watcher.
- `AUTO_ACTIVATE_POLL_SECONDS=10` controls how often it looks for the dialog.
- `AUTO_ACTIVATE_RETRY_SECONDS=300` controls backoff after a fetch or UI error.
- `AUTO_ACTIVATE_CODE_URL=...` overrides the upstream raw HTML URL for testing.

## Behavior and failure mode

The watcher matches the translated activation-dialog title and verifies its
600x400 geometry before clicking. If GitHub is unavailable, the page cannot be
parsed, or upstream changes the dialog layout, it logs the problem and leaves
the dialog untouched for manual use. Full activation codes are never logged or
stored; logs identify an attempted public code only by a short SHA-256
fingerprint.

The publisher currently uses month-long validity windows even though the
jlesage README still describes seven-day codes, so the parser uses the actual
timestamps in `<pre id="codes">` rather than assuming a duration.

## Upstream and licensing

This repository contains only the container wrapper and automation script. The
resulting image is built from `jlesage/file-centipede`; File Centipede itself is
owned and distributed by its upstream authors. The automation uses only the
trial codes they publish publicly and does not alter activation validation.
