"""Check the slot-machine integration before ndstool packs the ROM.

This checks file structure and references, not gameplay or rendered assets.
"""
import argparse
from pathlib import Path
import struct

import ndspy.narc


def require(condition, message):
    if not condition:
        raise ValueError(message)


def check(base, filesys):
    base, filesys = Path(base), Path(filesys)
    payload = (base / "overlay/overlay_0077.bin").read_bytes()
    table = (base / "overarm9.bin").read_bytes()
    require(len(table) >= 78 * 32, "ARM9 overlay table is missing entry 77")
    entry = struct.unpack_from("<8I", table, 77 * 32)
    require(entry == (77, 0x021E5900, len(payload), 0, 0, 0, 77, 0),
            "Overlay 77 address, size, file ID, or metadata does not match the slot payload")
    require(payload.startswith(b"SlotMachines_Start") and payload.endswith(b"SlotMachines_End"),
            "Overlay 77 does not contain the complete slot-machine payload")
    require(0 < len(payload) <= 0x6000, "Slot payload exceeds the reviewed 24 KiB budget")

    graphics = ndspy.narc.NARC((filesys / "a/1/2/7").read_bytes())
    require(len(graphics.files) >= 25 and all(len(f) > 32 for f in graphics.files[:25]),
            "Restore the slot-machine graphics archive a/1/2/7 (25 non-stub resources)")
    messages = ndspy.narc.NARC((filesys / "a/0/2/7").read_bytes())
    require(len(messages.files) > 436 and len(messages.files[436]) >= 4,
            "Message archive is missing slot-machine bank 436")
    bank = messages.files[436]
    count = struct.unpack_from("<H", bank)[0]
    require(count >= 11 and len(bank) >= 4 + count * 8,
            "Slot-machine message bank 436 needs at least 11 messages")
    print(f"Slot machines: overlay 77 verified ({len(payload)} bytes); graphics and message bank present.")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--base", type=Path, default=Path("base"))
    parser.add_argument("--filesys", type=Path, default=Path("base/root"))
    args = parser.parse_args()
    try:
        check(args.base, args.filesys)
    except (OSError, ValueError, struct.error) as error:
        parser.exit(1, f"Slot-machine integration check failed: {error}\n")


if __name__ == "__main__":
    main()
