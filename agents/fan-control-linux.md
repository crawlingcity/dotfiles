# Linux Fan Control Runbook

This documents the fan-control setup created on CachyOS on 2026-08-09. It is
intended to make the setup reproducible after reinstalling Linux or replacing a
kernel.

## Hardware

- Motherboard: MSI MAG B550 TOMAHAWK MAX WIFI (MS-7C91)
- Super-I/O controller: Nuvoton NCT6687D-R, device ID `0xD592`
- CPU: AMD Ryzen 7 5800X3D
- GPU: AMD Radeon RX 9070 XT
- Linux distribution: CachyOS/Arch
- Kernel used during setup: `7.1.6-1-cachyos`

Motherboard channel mapping:

| Linux channel | CoolerControl name | Physical fan |
| --- | --- | --- |
| `fan1` | CPU Fan | CPU cooler |
| `fan3` | Back | Rear case fan |
| `fan5` | Front Top | Upper-front case fan |
| `fan6` | Front Bottom | Lower-front case fan |
| `fan2`, `fan4`, `fan7`, `fan8` | Unused | Leave unmanaged |

## Software and driver installation

Install CoolerControl, its daemon, DKMS, kernel headers, and sensor utilities:

```bash
sudo pacman -S --needed coolercontrol coolercontrold dkms \
  linux-cachyos-headers lm_sensors paru
```

The in-tree `nct6683` module did not expose this board correctly. Install the
out-of-tree NCT6687D driver recommended for MSI/ASUS Nuvoton controllers:

```bash
paru -S nct6687d-dkms-git
```

Enable CoolerControl permanently:

```bash
sudo systemctl enable --now coolercontrold.service
```

The daemon detects the NCT6687D-R at startup and loads `nct6687`. DKMS builds
the driver for installed kernels. Install the matching headers before upgrading
or adding a kernel, including LTS headers when using the LTS kernel.

Verify the driver and daemon:

```bash
lsmod | rg '^nct6687'
sensors
systemctl status coolercontrold
```

Expected active RPM inputs are `fan1`, `fan3`, `fan5`, and `fan6` under the
`nct6687` hwmon device.

## Recovered Windows configuration

The actual Fan Control configuration was found at:

```text
C:\Program Files (x86)\FanControl\Configurations\userConfig.json
```

Older files under OneDrive/Desktop were placeholders and not the live config.
The Windows JSON used CPU temperature source `/amdcpu/0/temperature/2`, which
corresponds to the Linux `k10temp` `CPU Temp Tctl` (`temp1`) sensor.

The original Windows CPU curve was:

| Temperature | Duty |
| ---: | ---: |
| 30.3825 C | 30.4551% |
| 43.0303 C | 37.3884% |
| 56.8107 C | 49.1218% |
| 69.6473 C | 62.7218% |
| 80.8 C | 81.1218% |
| 100 C | 100% |

Fan Control also used 3 C hysteresis in both directions, a two-second response
time, and an 8% command-step limit. CoolerControl stores graph points at 0.1 C
and whole-duty-percent precision, so imported values were rounded accordingly.

## Final CoolerControl configuration

The final setup improves on the Windows configuration in two ways:

1. The CPU fan reaches 100% before the 5800X3D's 90 C Tjmax.
2. Case fans use the greater of CPU demand and GPU demand, and never request
   less than their measured 35% reliable start duty.

### Function: Fan Control hysteresis

- UID: `4f5e51e4-7fc3-4fb6-a9de-6f94cc2d41c7`
- Type: Standard
- Minimum step: 1%
- Maximum step: 8%
- Hysteresis threshold: 3 C
- Hysteresis delay: 2 seconds
- Only downward: false
- Threshold hopping: false
- Always apply limits/extremes bypass: false

### Profile: CPU

- UID: `8522c1ce-c63a-45e3-a872-1dcfd7ecb995`
- Type: Graph
- Source: Ryzen 5800X3D `CPU Temp Tctl` (`temp1`)
- Function: Fan Control hysteresis
- Assigned only to `fan1` (CPU Fan)

| Temperature | Duty |
| ---: | ---: |
| 30.4 C | 30% |
| 43.0 C | 37% |
| 56.8 C | 49% |
| 69.6 C | 63% |
| 80.8 C | 81% |
| 88.0 C | 100% |

### Profile: Case - CPU

- UID: `b2fced42-7ce5-4a3e-9d11-e5521c6d7f52`
- Type: Graph
- Source: Ryzen 5800X3D `CPU Temp Tctl` (`temp1`)
- Function: Fan Control hysteresis

| Temperature | Duty |
| ---: | ---: |
| 30.4 C | 35% |
| 43.0 C | 37% |
| 56.8 C | 49% |
| 69.6 C | 63% |
| 80.8 C | 81% |
| 88.0 C | 100% |

### Profile: Case - GPU

- UID: `c638bb2e-962d-4230-8fc5-fb78f7dcc6c9`
- Type: Graph
- Source: RX 9070 XT `GPU Temp Edge` (`temp1`)
- Function: Fan Control hysteresis

| Temperature | Duty |
| ---: | ---: |
| 30.0 C | 35% |
| 55.0 C | 35% |
| 65.0 C | 50% |
| 75.0 C | 65% |
| 85.0 C | 85% |
| 95.0 C | 100% |

### Profile: Case (CPU or GPU)

- UID: `381be9d9-da65-4b02-8d3a-ff8a9a8c3861`
- Type: Mix
- Mix function: Maximum
- Members: `Case - CPU` and `Case - GPU`
- Assigned to `fan3`, `fan5`, and `fan6`

The RX 9070 XT's own fan is intentionally unmanaged by CoolerControl. Its
firmware retains control. Do not run CoolerControl and LACT fan control against
the GPU simultaneously.

## Persistent configuration

CoolerControl persists this setup in:

```text
/etc/coolercontrol/config.toml
/etc/coolercontrol/config-ui.json
```

The important daemon setting is:

```toml
apply_on_boot = true
```

The desktop application does not need to remain open. The system service
applies profiles in the background and restores them at boot and after sleep.

## Verification after reinstall or upgrade

1. Confirm `nct6687` is loaded and `sensors` reports four active fans.
2. Confirm `coolercontrold.service` is enabled and active.
3. Open CoolerControl and confirm the four channel names and assignments.
4. Confirm CPU Fan uses `CPU`.
5. Confirm Back, Front Top, and Front Bottom use `Case (CPU or GPU)`.
6. Leave unused motherboard channels and the GPU fan unmanaged.
7. At idle, confirm all four physical fans are spinning. A normal observed
   result during setup was roughly 38%/666 RPM for the CPU fan and 40%/660-715
   RPM for the case fans at approximately 49 C CPU and 48 C GPU edge.

Useful checks:

```bash
systemctl is-enabled coolercontrold
systemctl is-active coolercontrold
sensors
rg -n 'profile_uid|apply_on_boot' /etc/coolercontrol/config.toml
```
