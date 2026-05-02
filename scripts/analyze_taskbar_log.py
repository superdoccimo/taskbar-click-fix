#!/usr/bin/env python3
"""Summarize taskbar_click_log.csv from the AutoHotkey observation MVP."""
from __future__ import annotations

import argparse
import csv
import statistics
from collections import Counter
from pathlib import Path

TASKBAR_CLASSES = {"Shell_TrayWnd", "Shell_SecondaryTrayWnd"}


def as_int(value: str, default: int = 0) -> int:
    try:
        return int(float(value))
    except (TypeError, ValueError):
        return default


def percentile(values: list[int], pct: float) -> float:
    if not values:
        return 0.0
    if len(values) == 1:
        return float(values[0])
    ordered = sorted(values)
    k = (len(ordered) - 1) * pct
    f = int(k)
    c = min(f + 1, len(ordered) - 1)
    if f == c:
        return float(ordered[f])
    return ordered[f] * (c - k) + ordered[c] * (k - f)


def main() -> int:
    parser = argparse.ArgumentParser(description="Summarize AutoHotkey taskbar click logs.")
    parser.add_argument("csv_path", nargs="?", default="taskbar_click_log.csv")
    parser.add_argument("--short-ms", type=int, default=40, help="threshold for very short clicks")
    parser.add_argument("--move-px", type=int, default=3, help="threshold for moved clicks")
    args = parser.parse_args()

    path = Path(args.csv_path)
    if not path.exists():
        parser.error(f"CSV not found: {path}")

    with path.open(newline="", encoding="utf-8-sig") as f:
        rows = list(csv.DictReader(f))

    durations = [as_int(r.get("duration_ms", "")) for r in rows]
    moves = [as_int(r.get("move_px", "")) for r in rows]
    classes = Counter((r.get("root_class") or "(blank)") for r in rows)
    taskbar_rows = [r for r in rows if (r.get("root_class") or "") in TASKBAR_CLASSES]
    short_rows = [r for r in rows if as_int(r.get("duration_ms", "")) < args.short_ms]
    moved_rows = [r for r in rows if as_int(r.get("move_px", "")) >= args.move_px]
    fg_changed = [r for r in rows if str(r.get("fg_changed", "")).lower() in {"1", "true"}]

    print(f"rows: {len(rows)}")
    if rows:
        print(f"taskbar rows: {len(taskbar_rows)}")
        print(f"foreground changed: {len(fg_changed)}")
        print(f"short clicks (<{args.short_ms}ms): {len(short_rows)}")
        print(f"moved clicks (>={args.move_px}px): {len(moved_rows)}")
        print(
            "duration ms: "
            f"min={min(durations)} median={statistics.median(durations):.1f} "
            f"p90={percentile(durations, 0.90):.1f} max={max(durations)}"
        )
        print(
            "move px: "
            f"min={min(moves)} median={statistics.median(moves):.1f} "
            f"p90={percentile(moves, 0.90):.1f} max={max(moves)}"
        )
        print("root classes:")
        for cls, count in classes.most_common():
            print(f"  {cls}: {count}")

    if short_rows:
        print("\nshort-click samples:")
        for r in short_rows[:10]:
            print(
                f"  duration={r.get('duration_ms')}ms move={r.get('move_px')}px "
                f"class={r.get('root_class')} fg_changed={r.get('fg_changed')}"
            )

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
