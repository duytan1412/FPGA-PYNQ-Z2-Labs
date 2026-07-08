# CDC Mini-Lab Plan

## Goal

Show timing-aware DV mindset through small clock/reset crossing examples, without pretending this repo is a full UVM project.

## Labs

| Lab | RTL concept | Verification check |
|---|---|---|
| 2-flop synchronizer | single-bit async input crossing | output changes only after sync latency |
| reset synchronizer | async assert, sync deassert | no logic leaves reset on unstable edge |
| pulse synchronizer | event crossing | no lost pulse under expected spacing |
| req/ack mini handshake | safe multi-cycle transfer | request held until acknowledge |

## Evidence To Add Later

- self-checking testbench logs;
- waveform screenshots around crossing events;
- timing/CDC note explaining why direct multi-bit sampling is unsafe.
