# VGA Image Display on FPGA

## Overview

This project implements a **VGA Image Display Controller** in Verilog that reads RGB pixel data from on-chip memory and displays the image on a standard VGA monitor.

The design generates standard **640×480 @ 60 Hz VGA timing**, reads pixel data stored in a memory initialization file (`.mem`), and displays a **64×64 RGB image** at user-defined screen locations.

The project is intended as a beginner-to-intermediate FPGA graphics project and serves as a foundation for larger video-processing systems.

---

## Features

* VGA 640×480 @ 60 Hz timing generation
* 25 MHz pixel clock
* Horizontal and Vertical synchronization
* Video enable generation
* 24-bit RGB image storage
* Image initialization using `$readmemh`
* Displays multiple copies of the same image
* Easily configurable image dimensions
* Modular Verilog design

---

## Project Structure

```
VGA-Image-Display/
│
├── rtl/
│   ├── Image_test.v
│   ├── Controller.v
│   ├── Clk_25MHz.v
│
├── constraints/
│   └── Basys3.xdc
│
├── memory/
│   ├── memory1.mem
│   └── sample_image.png
│
├── sim/
│   ├── tb_image_test.v
│   └── waveform.png
│
├── docs/
│   ├── VGA_Timing.png
│   ├── Block_Diagram.png
│   └── Output_Image.jpg
│
└── README.md
```

---

## System Architecture

```
               +----------------+
               | 100 MHz Clock  |
               +-------+--------+
                       |
                       v
               +----------------+
               | Clock Divider  |
               |   (25 MHz)     |
               +-------+--------+
                       |
                       v
               +----------------+
               | VGA Controller |
               | H/V Counters   |
               +-------+--------+
                       |
          +------------+------------+
          |                         |
          v                         v
   Video Enable             HSync / VSync
          |
          |
          v
   +--------------+
   | Image Memory |
   | memory1.mem  |
   +------+-------+
          |
          v
     RGB Extraction
          |
          v
     VGA RGB Output
```

---

## VGA Timing

| Parameter        |      Value |
| ---------------- | ---------: |
| Resolution       |  640 × 480 |
| Refresh Rate     |      60 Hz |
| Pixel Clock      |     25 MHz |
| Horizontal Total | 800 pixels |
| Vertical Total   |  525 lines |

---

## Image Format

The image is stored inside a memory initialization file.

Each pixel occupies **24 bits**:

```
23        16 15        8 7         0
+-----------+-----------+-----------+
|    Red    |   Green   |    Blue   |
+-----------+-----------+-----------+
```

Only the upper 4 bits of each color component are sent to the VGA DAC:

```
Red   : R[7:4]
Green : G[7:4]
Blue  : B[7:4]
```

---

## Memory Addressing

The image is stored in row-major order.

```
Address = (Y × Image_Width) + X
```

For a 64×64 image:

```
Address = Y × 64 + X
```

---

## Display Locations

The current implementation displays the same image at two different screen locations.

```
Image 1 : (128,128)

Image 2 : (256,256)
```

Additional images can be displayed by modifying the display window conditions.

---

## Simulation

Simulation verifies:

* VGA timing generation
* Horizontal counter
* Vertical counter
* Synchronization pulses
* Video enable signal
* Pixel addressing

Waveforms are available in the `sim/` directory.

---

## Hardware Requirements

* FPGA development board
* VGA connector
* VGA monitor
* Vivado Design Suite

---

## Future Improvements

* Multiple image memories
* Hardware sprite engine
* Image scaling
* Frame buffer using BRAM
* Animation support
* Text rendering
* PS/2 keyboard control
* HDMI output
* Double buffering

---

## Applications

* FPGA graphics
* VGA controller learning
* Sprite rendering
* Image processing
* Embedded display systems
* Digital design laboratories

---

## Author

**Sai Shubham Biswal**

Built as part of an FPGA and Digital Design project using Verilog HDL.

