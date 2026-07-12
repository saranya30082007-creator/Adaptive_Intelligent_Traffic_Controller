# 🚦 Adaptive Intelligent Traffic Signal Controller Using Verilog HDL

## 📌 Project Overview

This project implements an Adaptive Intelligent Traffic Signal Controller using Verilog HDL. The controller is designed as a Finite State Machine (FSM) that manages traffic signals at a four-way intersection while ensuring safe and efficient traffic flow.

The controller adapts to traffic conditions using traffic density inputs and provides priority handling for emergency vehicles, pedestrian requests, night mode, and fault conditions.

---

## ✨ Features

- Adaptive traffic control using traffic density inputs (`ns_heavy`, `ew_heavy`)
- Normal traffic signal sequencing
- Emergency vehicle priority
- Pedestrian crossing mode
- Night mode operation
- Fault mode handling
- Safe state transitions using Yellow and All-Red states
- Priority-based decision logic

Priority Order:

Fault > Emergency > Pedestrian > Night > Normal

---

## 🛠 Tools Used

- Verilog HDL
- EDA Playground
- GitHub

---

## 📂 Project Files

- `traffic_fsm.v` – Main FSM design
- `traffic_tb.v` – Testbench for verification

---

## 🧪 Test Cases Verified

- System Reset
- Normal Traffic Operation
- Pedestrian Mode
- Night Mode
- Emergency Mode
- Fault Mode
- Emergency vs Pedestrian Priority
- Fault vs Emergency Priority

---

## 👩‍🎓 Author

**Vandanala Saranya**

Department of Electronics and Communication Engineering

Aditya University
