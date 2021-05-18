---
toc:
  depth_from: 2
  depth_to: 3
  ordered: true
html:
  embed_local_images: true
  embed_svg: true
  eoffline: true
  # toc: true
export_on_save:
  html: true
output:
  pdf_document:
    toc: true  
---

# ODTU FPGA registers Manual

## FPGA Register space Summary

### Base information

- BaseAddress 0x4000_0000;
- 32bit little Endian;
- 1KBytes each Zone;

### Zone memory-mapped

| zone  | Address range | description                 |
| :---- | :------------ | :-------------------------- |
| zone0 | 0x0000-0x03ff | Base registers              |
| zone1 | 0x0400-0x07ff | 3gSdi receive registers     |
| zone2 | 0x0800-0x0bff | image pre-process registers |
| zone3 | 0x0c00-0x0fff | Feature decision registers  |

### Registers type memory-mapped

| Type    | Address range | description                 |
| :------ | :------------ | :-------------------------- |
| config  | 0x0000-0x00ff | control Register            |
| status  | 0x0100-0x017f | running state information   |
| error   | 0x0180-0x01ff | running error information   |
| counter | 0x0200-0x03ff | statistics(frame/operation) |

## Registers

### Zone0 Base registers

| Offset | bits  | Field Name        | D'Value    | A'Type | Description                                   |
| :----- | :---- | :---------------- | :--------- | :----- | :-------------------------------------------- |
| >      | >     | >                 | >          | >      | **Config registers(0x0000~0x00ff)**           |
| 0x0000 | 31-00 | cfgSoftReset      | 0000_0000h | RW     | soft reset config.                            |
| ------ | 31    | cfgSoftResetBD1   | 0b         | RW     | soft reset block design (148.5M Clock domain) |
| ------ | 30    | cfgSoftResetBD0   | 0b         | RW     | soft reset block design (74.25M Clock domain) |
| ------ | 29    | cfgSoftResetImgpp | 0b         | RW     | soft reset img_pp module                      |
| ------ | 28    | cfgSoftResetObjfd | 0b         | RW     | soft reset obj_fd module                      |
| ------ | 27-00 | cfgSoftResetPL    | 0b         | RW     | soft reset PL [usage](#soft-reset)            |
| 0x0004 | 31-00 | cfgTest           | 0000_0000h | RW     | [31:4] reserved                               |
| ------ | 03    | reserved          | 0b         | RW     | reserved                                      |
| ------ | 02    | cfgPRBSErrEn      | 0b         | RW     | VDMA PRBS error enable                        |
| ------ | 01    | cfgPRBSChkEn      | 0b         | RW     | VDMA PRBS check enable                        |
| ------ | 00    | cfgPRBSGenEn      | 0b         | RW     | VDMA PRBS generator enable                    |
| >      | >     | >                 | >          | >      | **Status registers(0x0100~0x017f)**           |
| 0x0100 | 31-0  | projectMajor      | "tbcv"     | RO     | major project                                 |
| 0x0104 | 31-0  | projectMinor      | "odtu"     | RO     | minor project                                 |
| 0x0108 | 31-0  | projectCode       | 0000_0000h | RO     | project code                                  |
| 0x010c | 31-0  | projectID         | 22be3546h  | RO     | project ID                                    |
| 0x0110 | 31-0  | versionNumber     | 1001_0000h | RO     | version number                                |
| ------ | 31-28 | majorVersion      | 0000b      | RO     | major version                                 |
| ------ | 27-24 | minorVersion      | 0000b      | RO     | minor version                                 |
| ------ | 23-16 | reversion         | 00h        | RO     | reversion                                     |
| ------ | 15-00 | patch             | 0000h      | RO     | patch                                         |
| 0x0114 | 31-0  | buildDate         | 2019_1018h | RO     | build date                                    |
| 0x0118 | 31-0  | buildTime         | 1530_0000h | RO     | build time                                    |
| 0x011c | 31-0  | versionNote       | 0000_0000h | RO     | version note                                  |
| 0xxxxx | 31-00 | reserved          | 0000_0000h | RO     | **state reserved**                            |
| >      | >     | >                 | >          | >      | **Error registers(0x0180~0x01ff)**            |
| 0x0180 | 31-00 | errBase           | 0000_0000h | WC     | **[31:01] reserved**                          |
| ------ | 00-00 | errPRBS           | 0b         | WC     | vdma PRBS error;                              |
| >      | >     | >                 | >          | >      | **Counter registers(0x0200~0x03ff)**          |
| 0xxxxx | 31-00 | reserved          | 0000_0000h | RO     | **counter reserved**                          |

#### Soft reset

write 0x1727374, then write 0x0727374

### Zone1 3gsdi receive registers

| Offset | bits   | Field Name         | D'Value     | A'Type | Description                                                           |
| :----- | :----- | :----------------- | :---------- | :----- | :-------------------------------------------------------------------- |
| >      | >      | >                  | >           | >      | **Config registers(0x0400~0x04ff)**                                   |
| 0x0400 | 31-00  | cfgGtx             | 0000_0000h  | RW     | [31:12] reserved <br> [09:00] GTX config                              |
| ^      | 08-00  | cfgGtxRxRst        | 0000_0000b  | RW     | GTX rx reset                                                          |
| 0x0404 | 31-00  | cfgSdi             | 0001_00a1b  | RW     | [31:12] reserved <br> [15:00] 3gSdi config                            |
| <!--   | ------ | 16                 | cfgSdiRxEce | 1b     | RW                                                                    | 3gsdi rx edh error counter enable | --> |
| ------ | 18     | cfgSdiRxLockIgnore | 1b          | RW     | 3gsdi rx t-lock ignore enable                                         |
| ------ | 17     | cfgSdiRxEvenLineEn | 1b          | RW     | 3gsdi rx even line enable                                             |
| ------ | 16     | cfgSdiRxEn         | 1b          | RW     | 3gsdi rx enable                                                       |
| ------ | 15-08  | cfgSdiRxMen        | 0000_0000b  | RW     | 3gsdi rx mode enable <br>{3'b0,12g/1.001,12g,6g,3g,sd,hd}             |
| ------ | 07     | cfgSdiRxRst        | 1b          | RW     | 3gsdi rx reset;                                                       |
| ------ | 06-04  | cfgSdiRxForced     | 010b        | RW     | 3gsdi rx forced mode                                                  |
| ------ | -----  | staSdiRxForced     | 010b        | RW     | 000:HD,001:SD,010:3g,<br>100:6G,101:12G,110:12G/1.001                 |
| ------ | 03     | cfgSdiRxMdr        | 0b          | RW     | 3gsdi rx mode detect reset                                            |
| ------ | 02     | cfgSdiRxMde        | 0b          | RW     | 3gsdi rx mode detect enable                                           |
| ------ | 01     | cfgSdiRxBitRate    | 0b          | RW     | 3gsdi rx bit rate                                                     |
| ------ | 00     | cfgSdiRxFrameEn    | 1b          | RW     | 3gsdi rx frame enable                                                 |
| 0x0408 | 31-00  | cfgUserRxDrA       | 0000_0000h  | RW     | [31:00] the upper left corner of Detection Region                     |
| ------ | 31-16  | cfgUserRxDrAx      | 0000h       | RW     | X-coordinate [Coordinate System](#coordinate-system)                  |
| ------ | 15-00  | cfgUserRxDrAy      | 0000h       | RW     | Y-coordinate                                                          |
| 0x040c | 31-00  | cfgUserRxDrB       | 0000_0000h  | RW     | [31:00] the lower right corner of Detection Region                    |
| ------ | 31-16  | cfgUserRxDrBx      | 0780h       | RW     | X-coordinate [Coordinate System](#coordinate-system)                  |
| ------ | 15-00  | cfgUserRxDrBy      | 0438h       | RW     | Y-coordinate                                                          |
| RSV    |        |                    |             |        | **config reserved**                                                   |
| >      | >      | >                  | >           | >      | **Status registers(0x0500~0x057f)**                                   |
| 0x0500 | 31-00  | staGtx             | 0000_0000h  | RO     | [31:12] reserved <br> [11:00] GTX state                               |
| ------ | 11-08  | staGtxTxBuf        | 0000b       | RO     | GTX Tx Buffer status                                                  |
| ------ | 07-04  | staGtxRxBuf        | 0000b       | RO     | GTX Rx Buffer status <br>                                             |
| ------ | 03     | staGtxTxFsmRstDone | 0b          | RO     | GTX Tx fsm reset done                                                 |
| ------ | 02     | staGtxRxRstDone    | 0b          | RO     | GTX rx reset done                                                     |
| ------ | 01     | staGtxRxFsmRstDone | 0b          | RO     | GTX rx fsm reset done                                                 |
| ------ | 00     | staGtxQpllLock     | 0b          | RO     | GTX QPLL locked                                                       |
| 0x0504 | 31-00  | staSdiRxBase       | 0000_0000h  | RO     | [31:28] reserved <br> [27:00] 3gsdi receive state                     |
| ------ | 27-24  | staSdiRxRate       | 0000b       | RO     | transport rate [link](#transport-rate)                                |
| ------ | 23-20  | staSdiRtf          | 0000b       | RO     | transport family [link](#transport-family)                            |
| ------ | -----  | staSdiRtf          | 0000b       | RO     | 000: 1;001: 2;010: 4;011: 8;100: 16                                   |
| ------ | 19-16  | staSdiRas          | 0000b       | RO     | active streams <br>                                                   |
| ------ | -----  | staSdiRas          | 0000b       | RO     | 000: 1;001: 2;010: 4;011: 8;100: 16                                   |
| ------ | 15-08  | staSdiRlm          | 0000b       | RO     | locked mode <br> {3'b0,12g,6g,3g,sd,hd}                               |
| ------ | 07-04  | staSdiRxM          | 0000b       | RO     | mode <br>                                                             |
| ------ | -----  | staSdiCE           | 0000b       | RO     | RX clock enable output;1:3GA                                          |
| ------ | -----  | staSdiRxm          | 0000b       | RO     | 000:HD,001:SD,010:3g,<br>100:6G,101:12G,110:12G/1.001                 |
| ------ | 03     | staSdiScan         | 0b          | RO     | transport scan <br> 0:interlaced,1:progressive                        |
| ------ | 02     | staSdiLevelB       | 0b          | RO     | level A/B <br> 0:A;1:B                                                |
| ------ | 01     | staSdiRxtLock      | 0b          | RO     | rx transport locked                                                   |
| ------ | 00     | staSdiRxmLock      | 0b          | RO     | rx mode locked                                                        |
| 0x0508 | 31-00  | staSdiRxFlag       | 0000_0000h  | RO     | [31:00] 3gsdi receive Error flag state                                |
| ------ | 31-24  | staSdiRxfPkt       | 0000_0000b  | RO     | most recently Packet error flag [link](#sdi-receive-error)            |
| ------ | 23-16  | staSdiRxfFf        | 0000_0000b  | RO     | ancillary data packet error flag [link](#sdi-receive-error)           |
| ------ | 15-08  | staSdiRxfff        | 0000_0000b  | RO     | full field CRC error flag [link](#sdi-receive-error)                  |
| ------ | 07-00  | staSdiRxfAp        | 0000_0000b  | RO     | active picture CRC error flag [link](#sdi-receive-error)              |
| RSV    |        |                    |             |        | **state reserved**                                                    |
| >      | >      | >                  | >           | >      | **Error registers(0x0580~0x05ff)**                                    |
| 0x0580 | 31-00  | errGtx             | 0000_0000h  | WC     | [31:00] reserved                                                      |
| 0x0584 | 31-00  | errSdiRx           | 0000_0000h  | WC     | [31:08] reserved <br> [03:00] 3gsdi receive error                     |
| ------ | 07-04  | errSdiRxEdh        | 0000b       | WC     | edh error;{anc,ff,ap,1'b0}                                            |
| ------ | 03-00  | errSdiRxCrc        | 0000b       | WC     | crc error;{ds3,ds2,ds1,ds0}                                           |
| 0x0588 | 31-00  | errUserRx          | 0000_0000h  | WC     | [31:05] reserved <br> [04:00] user receive error                      |
| ------ | 04-04  | errUserRxready     | 0000b       | WC     | ready error;                                                          |
| ------ | 03-00  | errUserRxFrame     | 0000b       | WC     | frame error;{sof_early_err,sof_later_err,eol_early_err,eol_later_err} |
| RSV    |        |                    |             |        | **error reserved**                                                    |
| >      | >      | >                  | >           | >      | **Counter registers(0x0600~0x07ff)**                                  |
| 0x0600 | 31-00  | cntSdiRxEol        | 0000_0000h  | RO     | receive eol counter                                                   |
| 0x0604 | 31-00  | cntSdiRxSol        | 0000_0000h  | RO     | receive sol counter                                                   |
| 0x0608 | 31-00  | cntSdiRxEof        | 0000_0000h  | RO     | receive eof counter                                                   |
| 0x060c | 31-00  | cntSdiRxSof        | 0000_0000h  | RO     | receive sof counter                                                   |
| 0x0610 | 31-00  | cntSdiRxErr        | 0000_0000h  | RO     | receive EDH err counter                                               |
| 0x0614 | 31-00  | cntUserRxELErr     | 0000_0000h  | RO     | receive eol later error counter                                       |
| 0x0618 | 31-00  | cntUserRxEEErr     | 0000_0000h  | RO     | receive eol early error counter                                       |
| 0x061c | 31-00  | cntUserRxSLErr     | 0000_0000h  | RO     | receive sof later error counter                                       |
| 0x0620 | 31-00  | cntUserRxSEErr     | 0000_0000h  | RO     | receive sof early error counter                                       |
| RSV    |        |                    |             |        | **counter reserved**                                                  |

#### Coordinate System

the upper left corner of the image is located at (0,0)

| (x,y) | 0        | 1        | 2        | ... ... ... | 1919        |
| ----- | -------- | -------- | -------- | ----------- | ----------- |
| 0     | (0,0)    | (1,0)    | (2,0)    | ... ... ... | (1919,0)    |
| 1     | (0,1)    | (1,1)    | (2,1)    | ... ... ... | (1919,1)    |
| 2     | (0,2)    | (1,2)    | (2,2)    | ... ... ... | (1919,2)    |
| ...   | ...      | ...      | ...      | ... ...     | ...         |
| 1079  | (0,1079) | (1,1079) | (2,1079) | ... ... ... | (1919,1079) |

#### SDI receive error

todo

#### transport rate

**transport Rate Encoding**

| Code   | Frame Rate (Hz) |
| :----- | :-------------- |
| 0000   | None            |
| 0010   | 23.98           |
| 0011   | 24              |
| 0100   | 47.95           |
| 0101   | 25              |
| 0110   | 29.97           |
| 0111   | 30              |
| 1000   | 48              |
| 1001   | 50              |
| 1010   | 59.94           |
| 1011   | 60              |
| Others | Reserved        |

#### transport family

**transport family Encoding**

| Code   | Transport Video Format | Active Pixels |
| :----- | :--------------------- | :------------ |
| 0000   | SMPTE ST 274           | 1920 x 1080   |
| 0001   | SMPTE ST 296           | 1280 x 720    |
| 0010   | SMPTE ST 2048-2        | 2048 x 1080   |
| 0011   | SMPTE ST 295           | 1920 x 1080   |
| 1000   | NTSC                   | 720 x 486     |
| 1001   | PAL                    | 720 x 576     |
| 1111   | Unknown                |               |
| Others | Reserved               |               |

### Zone2 image pre-process registers

| Offset | Bits  | Field Name   | DefaultValue | A'Type | Description                                                                            |
| :----- | :---- | :----------- | -----------: | ------ | :------------------------------------------------------------------------------------- |
| >      | >     | >            |            > | >      | **Config registers(0x0800~0x08ff)**                                                    |
| 0x0800 | 31-00 | cfgGBkernel0 |   0000_0000h | RW     | [31:10] reserved<br>[09:00] Gaussian Blur kernel0 config                               |
| ------ | 09-00 | cfgGBkernel0 |         000h | RW     | GBK config. [Usage](#gaussian-blur-kernel-config)                                      |
| 0x0804 | 31-00 | cfgGBkernel1 |   0000_0000h | RW     | [31:10] reserved<br>[09:00] Gaussian Blur kernel1 config                               |
| 0x0808 | 31-00 | cfgGBkernel2 |   0000_0000h | RW     | [31:10] reserved<br>[09:00] Gaussian Blur kernel2 config                               |
| 0x080c | 31-00 | cfgGBkernel3 |   0000_0000h | RW     | [31:10] reserved<br>[09:00] Gaussian Blur kernel3 config                               |
| 0x0810 | 31-00 | cfgGBkernel4 |   0000_0000h | RW     | [31:10] reserved<br>[09:00] Gaussian Blur kernel4 config                               |
| 0x0814 | 31-00 | cfgGBkernel5 |   0000_0000h | RW     | [31:10] reserved<br>[09:00] Gaussian Blur kernel5 config                               |
| 0x0818 | 31-00 | cfgGBkernel6 |   0000_0000h | RW     | [31:10] reserved<br>[09:00] Gaussian Blur kernel6 config                               |
| 0x081c | 31-00 | cfgGBkernel7 |   0000_0000h | RW     | [31:10] reserved<br>[09:00] Gaussian Blur kernel7 config                               |
| 0x0820 | 31-00 | cfgGBkernel8 |   0000_0000h | RW     | [31:10] reserved<br>[09:00] Gaussian Blur kernel8 config                               |
| 0x0824 | 31-00 | cfgFd        |   0000_0000h | RW     | reserved reserved<br>[09:00] inter-Frame Difference enable                             |
| ------ | 01-01 | cfgFdEn1     |           1b | RW     | foreground gray fewer than background's. [Usage](#inter-frame-difference-config)       |
| ------ | 00-00 | cfgFdEn0     |           1b | RW     | foreground gray more than background's. [Usage](#inter-frame-difference-config)        |
| 0x0828 | 31-00 | cfgBp        |   0000_0080h | RW     | [31:10] reserved<br>[09:00] Binary Process Threshold                                   |
| ------ | 09-00 | cfgBpThd     |         080h | RW     | BPT config. [Usage](#binary-process-config)                                            |
| 0x082c | 31-00 | cfgMt0       |   0001_01ffh | RW     | [31:20] reserved<br>[19:00] Morphological transformations config                       |
| ------ | 19-16 | cfgMt0Thd    |        0001b | RW     | Morphological transformations threshold [Usage](#morphological-transformations-config) |
| ------ | 15-09 | reserved     |    000_0000b | RW     | reserved                                                                               |
| ------ | 08-00 | cfgMt0Kernel | 1_1111_1111b | RW     | Morphological transformations kernel. [Usage](#morphological-transformations-config)   |
| 0x0830 | 31-00 | cfgMt1       |   0001_01ffh | RW     | [31:20] reserved<br>[19:00] Morphological transformations config                       |
| ------ | 19-16 | cfgMt1Thd    |        1001b | RW     | Morphological transformations threshold                                                |
| ------ | 15-09 | reserved     |    000_0000b | RW     | reserved                                                                               |
| ------ | 08-00 | cfgMt1Kernel | 1_1111_1111b | RW     | Morphological transformations kernel[Usage](#mor)                                      |
| 0x0834 | 31-00 | cfgPpDbg     |   0000_0000h | RW     | [31:03] reserved<br>[02:00] pp debug select                                            |
| ------ | 02-00 | cfgPpDbgSel  |         000b | RW     | 000:gb0;001:gb1;010:fd;011:bp;100:mt0;101:mt1;                                         |
| RSV    |       |              |              |        | **config reserved**                                                                    |
| >      | >     | >            |            > | >      | **Status registers(0x0900~0x097f)**                                                    |
| 0x0900 | 31-00 | staGb0       |   0000_0000h | RO     | [31:12] reserved <br> [11:00] Line buffer0 state                                       |
| ------ | 11-08 | staGb0Lb2    |        1010b | RO     | fifo2 state;{almostempty,almostfull,empty,full}                                        |
| ------ | 07-04 | staGb0Lb1    |        1010b | RO     | fifo1 state;{almostempty,almostfull,empty,full}                                        |
| ------ | 03-00 | staGb0Lb0    |        1010b | RO     | fifo0 state;{almostempty,almostfull,empty,full}                                        |
| 0x0904 | 31-00 | staGb1       |   0000_0000h | RO     | [31:12] reserved <br> [11:00] Line buffer1 state                                       |
| ------ | 11-08 | staGb1Lb2    |        1010b | RO     | fifo2 state;{almostempty,almostfull,empty,full}                                        |
| ------ | 07-04 | staGb1Lb1    |        1010b | RO     | fifo1 state;{almostempty,almostfull,empty,full}                                        |
| ------ | 03-00 | staGb1Lb0    |       0x1010 | RO     | fifo0 state;{almostempty,almostfull,empty,full}                                        |
| 0x090c | 31-00 | staBp        |   0000_0000h | RO     | [31:00] reserved                                                                       |
| 0x0908 | 31-00 | staFd        |   0000_0000h | RO     | [31:00] reserved                                                                       |
| 0x0910 | 31-00 | staMt0       |   0000_0000h | RO     | [31:00] reserved                                                                       |
| 0x0914 | 31-00 | staMt1       |   0000_0000h | RO     | [31:00] reserved                                                                       |
| RSV    |       |              |              |        | **state reserved**                                                                     |
| >      | >     | >            |            > | >      | **Error registers(0x0980~0x09ff)**                                                     |
| 0x0980 | 31-00 | errGb0       |   0000_0000h | WC     | [31:04] reserved <br> [03:00] Line buffer0 error                                       |
| ------ | 03-02 | errGb0Lb1    |          00b | WC     | fifo1 error;{read error,write error}                                                   |
| ------ | 01-00 | errGb0Lb0    |          00b | WC     | fifo0 error;{read error,write error}                                                   |
| 0x0984 | 31-00 | errGb1       |   0000_0000h | WC     | [31:04] reserved <br> [03:00] Line buffer1 error                                       |
| ------ | 03-02 | errGb1Lb1    |          00b | WC     | fifo1 error;{read error,write error}                                                   |
| ------ | 01-00 | errGb1Lb0    |          00b | WC     | fifo0 error;{read error,write error}                                                   |
| 0x0988 | 31-00 | errFd        |   0000_0000h | WC     | [31:04] reserved <br> [03:00] bg/fg frame alignment error                              |
| ------ | 03-00 | errFdAlgm    |        0000b | WC     | alignment error;{sof,eof,sol,eol}                                                      |
| 0x098c | 31-00 | errBp        |   0000_0000h | WC     | [31:00] reserved                                                                       |
| 0x0990 | 31-00 | errMt0       |   0000_0000h | WC     | [31:00] reserved                                                                       |
| 0x0991 | 31-00 | errMt1       |   0000_0000h | WC     | [31:00] reserved                                                                       |
| RSV    |       |              |              |        | **error reserved**                                                                     |
| >      | >     | >            |            > | >      | **Counter registers(0x0a00~0x0bff)**                                                   |
| 0x0a00 | 31-00 | cntGb0Eol    |   0000_0000h | RO     | Gaussian Blur eol counter                                                              |
| 0x0a04 | 31-00 | cntGb0Sol    |   0000_0000h | RO     | Gaussian Blur sol counter                                                              |
| 0x0a08 | 31-00 | cntGb0Eof    |   0000_0000h | RO     | Gaussian Blur eof counter                                                              |
| 0x0a0c | 31-00 | cntGb0Sof    |   0000_0000h | RO     | Gaussian Blur sof counter                                                              |
| 0x0a10 | 31-00 | cntGb1Eol    |   0000_0000h | RO     | Gaussian Blur eol counter                                                              |
| 0x0a14 | 31-00 | cntGb1Sol    |   0000_0000h | RO     | Gaussian Blur sol counter                                                              |
| 0x0a18 | 31-00 | cntGb1Eof    |   0000_0000h | RO     | Gaussian Blur eof counter                                                              |
| 0x0a1c | 31-00 | cntGb1Sof    |   0000_0000h | RO     | Gaussian Blur sof counter                                                              |
| 0x0a20 | 31-00 | cntFdEol     |   0000_0000h | RO     | Frame Difference eol counter                                                           |
| 0x0a24 | 31-00 | cntFdSol     |   0000_0000h | RO     | Frame Difference sol counter                                                           |
| 0x0a28 | 31-00 | cntFdEof     |   0000_0000h | RO     | Frame Difference eof counter                                                           |
| 0x0a2c | 31-00 | cntFdSof     |   0000_0000h | RO     | Frame Difference sof counter                                                           |
| 0x0a30 | 31-00 | cntBpEol     |   0000_0000h | RO     | Binary Process eol counter                                                             |
| 0x0a34 | 31-00 | cntBpSol     |   0000_0000h | RO     | Binary Process sol counter                                                             |
| 0x0a38 | 31-00 | cntBpEof     |   0000_0000h | RO     | Binary Process eof counter                                                             |
| 0x0a3c | 31-00 | cntBpSof     |   0000_0000h | RO     | Binary Process sof counter                                                             |
| 0x0a40 | 31-00 | cntMt0Eol    |   0000_0000h | RO     | Morphological Transformations eol counter                                              |
| 0x0a44 | 31-00 | cntMt0Sol    |   0000_0000h | RO     | Morphological Transformations sol counter                                              |
| 0x0a48 | 31-00 | cntMt0Eof    |   0000_0000h | RO     | Morphological Transformations eof counter                                              |
| 0x0a4c | 31-00 | cntMt0Sof    |   0000_0000h | RO     | Morphological Transformations sof counter                                              |
| 0x0a50 | 31-00 | cntMt1Eol    |   0000_0000h | RO     | Morphological Transformations eol counter                                              |
| 0x0a54 | 31-00 | cntMt1Sol    |   0000_0000h | RO     | Morphological Transformations sol counter                                              |
| 0x0a58 | 31-00 | cntMt1Eof    |   0000_0000h | RO     | Morphological Transformations eof counter                                              |
| 0x0a5c | 31-00 | cntMt1Sof    |   0000_0000h | RO     | Morphological Transformations sof counter                                              |
| RSV    |       |              |              |        | **counter reserved**                                                                   |

#### Gaussian Blur kernel config

[coordinate system](#coordinate-system)

1|4|7|. .. ...|
2|5|8|. .. ...|
3|6|9|. .. ...|
. . . . .. ...|
.. .. ... ....|
... ... ......|

// Gaussian Blur kernel default value
// |2|1|2|
// |1|0|1|
// |2|1|2|
// sigma=1
// |0.367879|0.606531|0.367879|
// |0.606531| 1 |0.606531|
// |0.367879|0.606531|0.367879|
// sum=4.89764
// |0.075|0.124|0.075|
// |0.124|0.204|0.124|
// |0.075|0.124|0.075|
// \*1024
// | 77|127| 77|
// |127|209|127|
// | 77|127| 77|
// 1|4|7
// 2|5|8
// 3|6|9

#### inter-frame Difference config

```
        fgGray < bgGray  +  fgGray > bgGray
                         |
      negativeThreshold  |  positiveThreshold
               +         |         +
  -------------+---------+---------+------------>
-0x3ff                   0                    0x3ff
```

#### Binary process config

$0<=BPThreshold<=1023$

#### Morphological transformations config

$Erosion:threshold=1,kernel=111111111,if p_c>=threshold$
$Dilation:threshold=9,kernel=111111111,if p_c>=threshold$

### Zone3 Feature detection registers

| Offset | bits  | Field Name        | D'Value    | A'Type | Description                                                            |
| :----- | :---- | :---------------- | :--------- | :----- | :--------------------------------------------------------------------- |
| >      | >     | >                 | >          | >      | **Config registers(0x0c00~0x0cff)**                                    |
| 0x0c00 | 31-00 | cfgFe             | 0000_0000h | RW     | [31:00] reserved                                                       |
| 0x0c04 | 31-00 | cfgFc             | 0000_0000h | RW     | [31:00] reserved                                                       |
| 0x0c08 | 31-00 | cfgCd             | 0000_0000h | RW     | [31:4] reserved <br> [03:00] critical decision config                  |
| ------ | 03-00 | cfgCdMask         | 0000b      | RW     | Feature decision mask <br> {mask_shift,mask_angle,mask_side,mask_area} |
| 0x0c0c | 31-00 | cfgCdAreaMin      | 0000_0010h | RW     | Minimum Area of Object                                                 |
| 0x0c10 | 31-00 | cfgCdAreaMax      | 0000_0040h | RW     | Maximum Area of Object                                                 |
| 0x0c14 | 31-00 | cfgCdSideARange   | 1000_0000h | RW     | Range of side A length <br> [31:16]:max;[15:00]:min;                   |
| 0x0c18 | 31-00 | cfgCdSideBRange   | 2000_0000h | RW     | Range of side B length <br> [31:16]:max;[15:00]:min;                   |
| 0x0c1c | 31-00 | cfgCdSideCRange   | 3000_0000h | RW     | Range of side C length <br> [31:16]:max;[15:00]:min;                   |
| 0x0c20 | 31-00 | cfgCdAngleRange   | 6488_9b78h | RW     | Range of rotate angle <br> [31:16]:max;[15:00]:min;                    |
| 0x0c24 | 31-00 | cfgCdShiftRange   | 0800_0000h | RW     | Range of shift distance <br> [31:16]:max;[15:00]:min;                  |
| 0x0c28 | 31-00 | cfgCdTrig         | 0000_0010h | RW     | Trig plus config.                                                      |
| ------ | 29-16 | cfgCdTrigMasktime | 03e8h      | RW     | Trig masktime. unit:1ms; max:0x3fff(16383ms+1ms)                       |
| ------ | 15-02 | cfgCdTrigLevel    | 0001b      | RW     | Trig level. 0000:low leve；0001：high level                            |
| ------ | 11-00 | cfgCdTrigHoldtime | 019h       | RW     | Trig holdtime. unit:10us;max:0xfff(40950us).                           |
| >      | >     | >                 | >          | >      | **Status registers(0x0d00~0x0d7f)**                                    |
| 0x0d00 | 31-00 | staFe             | 0000_0000h | RO     | [31:12] reserved <br> [11:00] Feature extract state                    |
| ------ | 03-00 | staFeLb           | 1010b      | RO     | Line buffer state;{almostempty,almostfull,empty,full}                  |
| 0x0d04 | 31-00 | staFc             | 0000_0000h | RO     | [31:00] reserved Feature calculate state                               |
| 0x0d08 | 31-00 | staFcCocT0        | 0000_0000h | RO     | [31:00] coordinates of centroid(temporary storage)                     |
| ------ | 15-00 | staFcC0cT0x       | 0000h      | RO     | X-coordinates of centroid; {valid,4'b0000,xc}                          |
| ------ | 15-00 | staFcC0cT0y       | 0000h      | RO     | Y-coordinates of centroid; {valid,4'b0000,yc}                          |
| 0x0d0c | 31-00 | staFcCocT1        | 0000_0000h | RO     | [31:00] coordinates of centroid                                        |
| 0x0d10 | 31-00 | staFcCocT2        | 0000_0000h | RO     | [31:00] coordinates of centroid                                        |
| 0x0d14 | 31-00 | staFcCocT3        | 0000_0000h | RO     | [31:00] coordinates of centroid                                        |
| 0x0d18 | 31-00 | staFcCocT4        | 0000_0000h | RO     | [31:00] coordinates of centroid                                        |
| 0x0d1c | 31-00 | staFcCocT5        | 0000_0000h | RO     | [31:00] coordinates of centroid                                        |
| 0x0d20 | 31-00 | staFcCocT6        | 0000_0000h | RO     | [31:00] coordinates of centroid                                        |
| 0x0d24 | 31-00 | staFcCocT7        | 0000_0000h | RO     | [31:00] coordinates of centroid                                        |
| 0x0d28 | 31-00 | staFcCoc0         | 0000_0000h | RO     | [31:00] coordinates of centroid                                        |
| ------ | 15-00 | staFcCoc0x        | 0000h      | RO     | X-coordinates of centroid; {valid,4'b0000,xc}                          |
| ------ | 15-00 | staFcCoc0y        | 0000h      | RO     | Y-coordinates of centroid; {valid,4'b0000,yc}                          |
| 0x0d2c | 31-00 | staFcCoc1         | 0000_0000h | RO     | [31:00] coordinates of centroid                                        |
| 0x0d30 | 31-00 | staFcCoc2         | 0000_0000h | RO     | [31:00] coordinates of centroid                                        |
| 0x0d34 | 31-00 | staFcCoc3         | 0000_0000h | RO     | [31:00] coordinates of centroid                                        |
| 0x0d38 | 31-00 | staFcCoc4         | 0000_0000h | RO     | [31:00] coordinates of centroid                                        |
| 0x0d3c | 31-00 | staFcCoc5         | 0000_0000h | RO     | [31:00] coordinates of centroid                                        |
| 0x0d40 | 31-00 | staFcCoc6         | 0000_0000h | RO     | [31:00] coordinates of centroid                                        |
| 0x0d44 | 31-00 | staFcCoc7         | 0000_0000h | RO     | [31:00] coordinates of centroid                                        |
| 0x0d48 | 31-00 | staCdArea         | 0000_0000h | RO     | [31:00] object area state.                                             |
| ------ | 31-24 | staCdAreaIn       | 0000_0000b | RO     | Last match frame areaInRange state. <br> 0:outRange;1:inRange          |
| ------ | 23-16 | staCdAreaIn       | 0000_0000b | RO     | Last before frame areaInRange <br> 0:outRange;1:inRange                |
| ------ | 15-08 | staCdAreaIn       | 0000_0000b | RO     | Last frame areaInRange <br> 0:outRange;1:inRange                       |
| ------ | 07-00 | staCdAreaIn       | 0000_0000b | RO     | Current frame areaInRange state. <br> 0:outRange;1:inRange             |
| 0x0d4c | 31-00 | staCdSide         | 0000_0000h | RO     | [31:00] object side state <br>1:inRange                                |
| ------ | 31-24 | staCdSideIn       | 0000_0000b | RO     | Last match frame sideInRange state. <br> 0:outRange;1:inRange          |
| ------ | 23-16 | staCdSideIn       | 0000_0000b | RO     | Last before frame sideInRange <br> 0:outRange;1:inRange                |
| ------ | 15-08 | staCdSideIn       | 0000_0000b | RO     | Last frame sideInRange <br> 0:outRange;1:inRange                       |
| ------ | 07-00 | staCdSideIn       | 0000_0000b | RO     | Current frame sideInRange state. <br> 0:outRange;1:inRange             |
| 0x0d50 | 31-00 | staCdAngle        | 0000_0000h | RO     | [31:00] object angle state                                             |
| ------ | 31-24 | staCdAngleIn      | 0000_0000b | RO     | Last match frame angleInRange state. <br> 0:outRange;1:inRange         |
| ------ | 23-16 | staCdAngleIn      | 0000_0000b | RO     | Last before frame angleInRange. <br> 0:outRange;1:inRange              |
| ------ | 15-08 | staCdAngleIn      | 0000_0000b | RO     | Last frame angleInRange. <br> 0:outRange;1:inRange                     |
| ------ | 07-00 | staCdAngleIn      | 0000_0000b | RO     | Current frame angleInRange state. <br> 0:outRange;1:inRange            |
| 0x0d54 | 31-00 | staCdShift0       | 0000_0000h | RO     | [31:00] object shift state [link](#shift-distance)                     |
| ------ | 31-00 | staCdShift0In     | 0000_0000b | RO     | Current frame shiftInRange state. <br> 0:outRange;1:inRange            |
| 0x0d58 | 31-00 | staCdShift1       | 0000_0000h | RO     | [31:00] object shift state [link](#shift-distance)                     |
| ------ | 31-00 | staCdShift1In     | 0000_0000b | RO     | Current frame shiftInRange state. <br> 0:outRange;1:inRange            |
| 0x0d5c | 31-00 | staCdShift2       | 0000_0000h | RO     | [31:00] object shift state [link](#shift-distance)                     |
| ------ | 31-00 | staCdShift2In     | 0000_0000b | RO     | Last match frame shiftInRange state. <br> 0:outRange;1:inRange         |
| 0x0d60 | 31-00 | staCdShift3       | 0000_0000h | RO     | [31:00] object shift state [link](#shift-distance)                     |
| ------ | 31-00 | staCdShift3In     | 0000_0000b | RO     | Last match frame shiftInRange state. <br> 0:outRange;1:inRange         |
| >      | >     | >                 | >          | >      | **Error registers(0x0d80~0x0dff)**                                     |
| 0x0d80 | 31-00 | errFe             | 0000_0000h | WC     | [31:04] reserved <br> [03:00] Feature extract error                    |
| ------ | 01-00 | errFeLb           | 00b        | WC     | Line buffer error;{read error,write error}                             |
| 0x0d84 | 31-00 | errFc             | 0000_0000h | WC     | [31:04] reserved <br> [03:00] Feature calculate error                  |
| ------ | 03-00 | errFc             | 0000b      | WC     | Fc error;{1'b0,divider_err ,moments_ff_err,points_ff_err}              |
| 0x0d88 | 31-00 | errCd             | 0000_0000h | WC     | [31:00] reserved                                                       |
| ------ | 00-00 | errCdArea         | 0000b      | WC     | area inRange more than 8.points_ff_err}                                |
| >      | >     | >                 | >          | >      | **Counter registers(0x0e00~0x0fff)**                                   |
| 0x0e00 | 31-00 | cntFeEof          | 0000_0000h | RO     | Feature extract eof counter                                            |
| 0x0e04 | 31-00 | cntFeCC           | 0000_0000h | RO     | Feature extract CC(connected component) counter                        |
| 0x0e08 | 31-00 | cntFcSideEof      | 0000_0000h | RO     | Side eof counter                                                       |
| 0x0e0c | 31-00 | cntFcSideVld      | 0000_0000h | RO     | Side valid counter                                                     |
| 0x0e10 | 31-00 | cntFcAngleEof     | 0000_0000h | RO     | Angle eof counter                                                      |
| 0x0e14 | 31-00 | cntFcAngleVld     | 0000_0000h | RO     | Angle valid counter                                                    |
| 0x0e18 | 31-00 | cntFcShiftEof     | 0000_0000h | RO     | Shift eof counter                                                      |
| 0x0e1c | 31-00 | cntFcShiftVld     | 0000_0000h | RO     | Shift valid counter                                                    |
| 0x0e20 | 31-00 | cntCdEof          | 0000_0000h | RO     | critical decision eof counter                                          |
| 0x0e24 | 31-00 | cntCdSuspect      | 0000_0000h | RO     | Suspected counter                                                      |
| 0x0e28 | 31-00 | cntCdAreaIn       | 0000_0000h | RO     | Area inRange counter                                                   |
| 0x0e2c | 31-00 | cntCdSideIn       | 0000_0000h | RO     | Side inRange counter                                                   |
| 0x0e30 | 31-00 | cntCdAngleIn      | 0000_0000h | RO     | Angle inRange counter                                                  |
| 0x0e34 | 31-00 | cntCdShiftIn      | 0000_0000h | RO     | Shift inRange counter                                                  |
| 0x0e38 | 31-00 | cntCdMatch        | 0000_0000h | RO     | Matches counter                                                        |
| 0x0e3c | 31-00 | cntCdTrig         | 0000_0000h | RO     | Trig counter                                                           |
| 0x0e40 | 31-00 | cntCdIntr         | 0000_0000h | RO     | Interrupt counter                                                      |

#### shift distance

| Byte/bit | bit7 | bit6 | bit5 | bit4 | bit3 | bit2 | bit1 | bit0 |
| :------- | :--- | ---- | ---- | ---- | ---- | ---- | ---- | ---- |
| Byte7    | 8-1  | 8-2  | 8-3  | 8-4  | 8-5  | 8-6  | 8-7  | -    |
| Byte6    | 7-1  | 7-2  | 7-3  | 7-4  | 7-5  | 7-6  | -    | -    |
| Byte5    | 6-1  | 6-2  | 6-3  | 6-4  | 6-5  | -    | -    | -    |
| Byte4    | 5-1  | 5-2  | 5-3  | 5-4  | -    | -    | -    | -    |
| Byte3    | 4-1  | 4-2  | 4-3  | -    | -    | -    | -    | -    |
| Byte2    | 3-1  | 3-2  | -    | -    | -    | -    | -    | -    |
| Byte1    | 2-1  | -    | -    | -    | -    | -    | -    | -    |
| Byte0    | -    | -    | -    | -    | -    | -    | -    | -    |

## Appendix

### VDMA0 registers

| Offset     | bits  | Field Name           | D'Value | A'Type | Description                          |
| :--------- | :---- | :------------------- | :------ | :----- | :----------------------------------- |
| 0x03000000 | 31-00 | MM2S_VDMACR          | -       | RW     | MM2S VDMA Control Register           |
| 0x03000004 | 31-00 | MM2S_VDMASR          | -       | WC     | MM2S VDMA Status Register            |
| 0x03000014 | 31-00 | MM2S_REG_INDEX       | -       | RW     | MM2S Register Index                  |
| 0x03000028 | 31-00 | PARK_PTR_REG         | -       | RW     | MM2S and S2MM Park Pointer Register  |
| 0x0300002C | 31-00 | VDMA_VERSION         | -       | RO     | Video DMA Version Register           |
| 0x03000030 | 31-00 | S2MM_VDMACR          | -       | RW     | S2MM VDMA Control Register           |
| 0x03000034 | 31-00 | S2MM_VDMASR          | -       | WC     | S2MM VDMA Status Register            |
| 0x0300003C | 31-00 | S2MM_VDMA_IRQ_MASK   | -       | RW     | S2MM Error Interrupt Mask Register   |
| 0x03000044 | 31-00 | S2MM_REG_INDEX       | -       | RW     | S2MM Register Index                  |
| 0x03000050 | 31-00 | MM2S_VSIZE           | -       | RW     | MM2S Vertical Size Register          |
| 0x03000054 | 31-00 | MM2S_HSIZE           | -       | RW     | MM2S Horizontal Size Register        |
| 0x03000058 | 31-00 | MM2S_FRMDLY_STRIDE   | -       | RW     | MM2S Frame Delay and Stride Register |
| 0x0300005C | 31-00 | MM2S_START_ADDRESS0  | -       | RW     | MM2S Start Address 0                 |
| 0x03000060 | 31-00 | MM2S_START_ADDRESS1  | -       | RW     | MM2S Start Address 1                 |
| 0x03000064 | 31-00 | MM2S_START_ADDRESS2  | -       | RW     | MM2S Start Address 2                 |
| 0x03000068 | 31-00 | MM2S_START_ADDRESS3  | -       | RW     | MM2S Start Address 3                 |
| 0x0300006c | 31-00 | MM2S_START_ADDRESS4  | -       | RW     | MM2S Start Address 4                 |
| 0x03000070 | 31-00 | MM2S_START_ADDRESS5  | -       | RW     | MM2S Start Address 5                 |
| 0x03000074 | 31-00 | MM2S_START_ADDRESS6  | -       | RW     | MM2S Start Address 6                 |
| 0x03000078 | 31-00 | MM2S_START_ADDRESS7  | -       | RW     | MM2S Start Address 7                 |
| 0x0300007c | 31-00 | MM2S_START_ADDRESS8  | -       | RW     | MM2S Start Address 8                 |
| 0x03000080 | 31-00 | MM2S_START_ADDRESS9  | -       | RW     | MM2S Start Address 9                 |
| 0x03000084 | 31-00 | MM2S_START_ADDRESS10 | -       | RW     | MM2S Start Address 10                |
| 0x03000088 | 31-00 | MM2S_START_ADDRESS11 | -       | RW     | MM2S Start Address 11                |
| 0x0300008c | 31-00 | MM2S_START_ADDRESS12 | -       | RW     | MM2S Start Address 12                |
| 0x03000090 | 31-00 | MM2S_START_ADDRESS13 | -       | RW     | MM2S Start Address 13                |
| 0x03000094 | 31-00 | MM2S_START_ADDRESS14 | -       | RW     | MM2S Start Address 14                |
| 0x03000098 | 31-00 | MM2S_START_ADDRESS15 | -       | RW     | MM2S Start Address 15                |
| 0x030000A0 | 31-00 | S2MM_VSIZE           | -       | RW     | S2MM Vertical Size Register          |
| 0x030000A4 | 31-00 | S2MM_HSIZE           | -       | RW     | S2MM Horizontal Size Register        |
| 0x030000A8 | 31-00 | S2MM_FRMDLY_STRIDE   | -       | RW     | S2MM Frame Delay and Stride Register |
| 0x030000AC | 31-00 | S2MM_START_ADDRESS0  | -       | RW     | S2MM Start Address 0                 |
| 0x030000b0 | 31-00 | S2MM_START_ADDRESS1  | -       | RW     | S2MM Start Address 1                 |
| 0x030000b4 | 31-00 | S2MM_START_ADDRESS2  | -       | RW     | S2MM Start Address 2                 |
| 0x030000b8 | 31-00 | S2MM_START_ADDRESS3  | -       | RW     | S2MM Start Address 3                 |
| 0x030000bc | 31-00 | S2MM_START_ADDRESS4  | -       | RW     | S2MM Start Address 4                 |
| 0x030000c0 | 31-00 | S2MM_START_ADDRESS5  | -       | RW     | S2MM Start Address 5                 |
| 0x030000c4 | 31-00 | S2MM_START_ADDRESS6  | -       | RW     | S2MM Start Address 6                 |
| 0x030000c8 | 31-00 | S2MM_START_ADDRESS7  | -       | RW     | S2MM Start Address 7                 |
| 0x030000cc | 31-00 | S2MM_START_ADDRESS8  | -       | RW     | S2MM Start Address 8                 |
| 0x030000d0 | 31-00 | S2MM_START_ADDRESS9  | -       | RW     | S2MM Start Address 9                 |
| 0x030000d4 | 31-00 | S2MM_START_ADDRESS10 | -       | RW     | S2MM Start Address 10                |
| 0x030000d8 | 31-00 | S2MM_START_ADDRESS11 | -       | RW     | S2MM Start Address 11                |
| 0x030000dc | 31-00 | S2MM_START_ADDRESS12 | -       | RW     | S2MM Start Address 12                |
| 0x030000e0 | 31-00 | S2MM_START_ADDRESS13 | -       | RW     | S2MM Start Address 13                |
| 0x030000e4 | 31-00 | S2MM_START_ADDRESS14 | -       | RW     | S2MM Start Address 14                |
| 0x030000e8 | 31-00 | S2MM_START_ADDRESS15 | -       | RW     | S2MM Start Address 15                |
| 0x030000EC | 31-00 | ENABLE_VERTICAL_FLIP | -       | RW     | Vertical Flip Register               |

### VDMA1 registers

| Offset     | bits  | Field Name           | D'Value | A'Type | Description                          |
| :--------- | :---- | :------------------- | :------ | :----- | :----------------------------------- |
| 0x03010000 | 31-00 | MM2S_VDMACR          | -       | RW     | MM2S VDMA Control Register           |
| 0x03010004 | 31-00 | MM2S_VDMASR          | -       | WC     | MM2S VDMA Status Register            |
| 0x03010014 | 31-00 | MM2S_REG_INDEX       | -       | RW     | MM2S Register Index                  |
| 0x03010028 | 31-00 | PARK_PTR_REG         | -       | RW     | MM2S and S2MM Park Pointer Register  |
| 0x0301002C | 31-00 | VDMA_VERSION         | -       | RO     | Video DMA Version Register           |
| 0x03010030 | 31-00 | S2MM_VDMACR          | -       | RW     | S2MM VDMA Control Register           |
| 0x03010034 | 31-00 | S2MM_VDMASR          | -       | WC     | S2MM VDMA Status Register            |
| 0x0301003C | 31-00 | S2MM_VDMA_IRQ_MASK   | -       | RW     | S2MM Error Interrupt Mask Register   |
| 0x03010044 | 31-00 | S2MM_REG_INDEX       | -       | RW     | S2MM Register Index                  |
| 0x03010050 | 31-00 | MM2S_VSIZE           | -       | RW     | MM2S Vertical Size Register          |
| 0x03010054 | 31-00 | MM2S_HSIZE           | -       | RW     | MM2S Horizontal Size Register        |
| 0x03010058 | 31-00 | MM2S_FRMDLY_STRIDE   | -       | RW     | MM2S Frame Delay and Stride Register |
| 0x0301005C | 31-00 | MM2S_START_ADDRESS0  | -       | RW     | MM2S Start Address 0                 |
| 0x03010060 | 31-00 | MM2S_START_ADDRESS1  | -       | RW     | MM2S Start Address 1                 |
| 0x03010064 | 31-00 | MM2S_START_ADDRESS2  | -       | RW     | MM2S Start Address 2                 |
| 0x03010068 | 31-00 | MM2S_START_ADDRESS3  | -       | RW     | MM2S Start Address 3                 |
| 0x0301006c | 31-00 | MM2S_START_ADDRESS4  | -       | RW     | MM2S Start Address 4                 |
| 0x03010070 | 31-00 | MM2S_START_ADDRESS5  | -       | RW     | MM2S Start Address 5                 |
| 0x03010074 | 31-00 | MM2S_START_ADDRESS6  | -       | RW     | MM2S Start Address 6                 |
| 0x03010078 | 31-00 | MM2S_START_ADDRESS7  | -       | RW     | MM2S Start Address 7                 |
| 0x0301007c | 31-00 | MM2S_START_ADDRESS8  | -       | RW     | MM2S Start Address 8                 |
| 0x03010080 | 31-00 | MM2S_START_ADDRESS9  | -       | RW     | MM2S Start Address 9                 |
| 0x03010084 | 31-00 | MM2S_START_ADDRESS10 | -       | RW     | MM2S Start Address 10                |
| 0x03010088 | 31-00 | MM2S_START_ADDRESS11 | -       | RW     | MM2S Start Address 11                |
| 0x0301008c | 31-00 | MM2S_START_ADDRESS12 | -       | RW     | MM2S Start Address 12                |
| 0x03010090 | 31-00 | MM2S_START_ADDRESS13 | -       | RW     | MM2S Start Address 13                |
| 0x03010094 | 31-00 | MM2S_START_ADDRESS14 | -       | RW     | MM2S Start Address 14                |
| 0x03010098 | 31-00 | MM2S_START_ADDRESS15 | -       | RW     | MM2S Start Address 15                |
| 0x030100A0 | 31-00 | S2MM_VSIZE           | -       | RW     | S2MM Vertical Size Register          |
| 0x030100A4 | 31-00 | S2MM_HSIZE           | -       | RW     | S2MM Horizontal Size Register        |
| 0x030100A8 | 31-00 | S2MM_FRMDLY_STRIDE   | -       | RW     | S2MM Frame Delay and Stride Register |
| 0x030100AC | 31-00 | S2MM_START_ADDRESS0  | -       | RW     | S2MM Start Address 0                 |
| 0x030100b0 | 31-00 | S2MM_START_ADDRESS1  | -       | RW     | S2MM Start Address 1                 |
| 0x030100b4 | 31-00 | S2MM_START_ADDRESS2  | -       | RW     | S2MM Start Address 2                 |
| 0x030100b8 | 31-00 | S2MM_START_ADDRESS3  | -       | RW     | S2MM Start Address 3                 |
| 0x030100bc | 31-00 | S2MM_START_ADDRESS4  | -       | RW     | S2MM Start Address 4                 |
| 0x030100c0 | 31-00 | S2MM_START_ADDRESS5  | -       | RW     | S2MM Start Address 5                 |
| 0x030100c4 | 31-00 | S2MM_START_ADDRESS6  | -       | RW     | S2MM Start Address 6                 |
| 0x030100c8 | 31-00 | S2MM_START_ADDRESS7  | -       | RW     | S2MM Start Address 7                 |
| 0x030100cc | 31-00 | S2MM_START_ADDRESS8  | -       | RW     | S2MM Start Address 8                 |
| 0x030100d0 | 31-00 | S2MM_START_ADDRESS9  | -       | RW     | S2MM Start Address 9                 |
| 0x030100d4 | 31-00 | S2MM_START_ADDRESS10 | -       | RW     | S2MM Start Address 10                |
| 0x030100d8 | 31-00 | S2MM_START_ADDRESS11 | -       | RW     | S2MM Start Address 11                |
| 0x030100dc | 31-00 | S2MM_START_ADDRESS12 | -       | RW     | S2MM Start Address 12                |
| 0x030100e0 | 31-00 | S2MM_START_ADDRESS13 | -       | RW     | S2MM Start Address 13                |
| 0x030100e4 | 31-00 | S2MM_START_ADDRESS14 | -       | RW     | S2MM Start Address 14                |
| 0x030100e8 | 31-00 | S2MM_START_ADDRESS15 | -       | RW     | S2MM Start Address 15                |
| 0x030100EC | 31-00 | ENABLE_VERTICAL_FLIP | -       | RW     | Vertical Flip Register               |
