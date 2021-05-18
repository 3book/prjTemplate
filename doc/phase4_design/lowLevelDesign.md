---
toc:
  depth_from: 2
  depth_to: 4
  ordered: true
html:
  embed_local_images: true
  embed_svg: true
  offline: true
  toc: true
export_on_save:
  cdn: true
  html: true
# output:
#   word_document:
#     toc: true  
---

@import "../assets/doc_style.less"

# xxxx FPGA project LowLevelDesign

| Name           | xxxx FPGA project LowLevelDesign |
| :------------- | :------------------------------- |
| Identification |                                  |
| SecretLevel    | secret                           |
| Author         | xxxx                             |
| Copyright      | xxxx                             |

**Revision History**
| Version No | Date | Prepared by<br>Modified by | Significant Changes |
|:-----------|:-----------|:---------------------------|:--------------------|
| 1.0 | 2019-07-30 | xxxx | initial |

## 术语

| Abbreviation | Description              |
| :----------- | :----------------------- |
| SDI          | serial digital interface |

## 总体设计

### 总体框图

![block diagram](../../assets/BlockDiagram.svg)

### 数据流向

如图所示：

- SDI 接口输入的视频图像经预处理、提取特征、特征判定后，将结果标记在原始帧上，并通知 PS（CPU）；图中路径 Object Detection；
- PS 收到通知后后，将 DDR 中的对应视频帧从 ETH 发送给系统侧服务端；图中路径 Result Report；
- SDI 输入的原始帧分出一路转存到 DDR 中；图中路径 Origin Frame Store；
- 检测结果通过 GPIO 接口触发相机；

### 模块说明

| Module     | Description                                     |
| :--------- | :---------------------------------------------- |
| **ext_if** | **external interface**                          |
| clk_rst    | Clock & Reset                                   |
| cpu_if     | Register                                        |
| sdi_rx     | 3G-SDI Receive                                  |
| ddr_if     | DDR Interface                                   |
| **img_pp** | **Image Pre-process**                           |
| img_gp     | Gray Process                                    |
| img_gb     | Gaussian Blur                                   |
| img_fd     | inter-Frame Difference                          |
| img_bp     | Binary Process                                  |
| img_mt     | Morphological Transformations                   |
| **obj_fd** | **Object Feature Detection**                    |
| obj_fe     | Feature extraction                              |
| obj_fc     | Feature calculation                             |
| obj_cd     | Critical decision                               |
| **mem_rw** | **Memory read write**                           |
| img_lb     | Line Buffer                                     |
| frm_wr     | - raw frame write<br> - pre-process frame write |
| frm_rd     | frame read                                      |
| obj_bw     | Result Back Write                               |
| bin_bw     | Binary Back write                               |

### 资源评估

FPGA 芯片型号 xc7z035
| - | Logic Cells(k) | Block RAM(Mb/36Kb) | DSP Slices | I/O | GT |
|:-------|:---------------|:-------------------|:-----------|:----|:---|
| z-7035 | | 17.6/ | | | 16 |
| | | | | | |

## 模块设计

### Clk&Rst

| 时钟信号名称  | 频率                            | 描述                   |
| :------------ | :------------------------------ | :--------------------- |
| sys_clk       | 148.5M                          | 系统复位               |
| axi_lite_clk  |                                 | 寄存器访问时钟         |
| sdi_rx_usrclk | 148.5M(3G-SDI)<br>74.25(HD-SDI) | SDI 接口接收侧用户时钟 |
| sdi_gt_refclk | 148.5M                          | SDI 接口接收侧用户时钟 |
| sdi_rx_usrclk | 148.5M                          | SDI 接口接收侧用户时钟 |
| sdi_rx_usrclk | 148.5M                          | SDI 接口接收侧用户时钟 |

| 复位信号名称  | 描述                   |
| ------------- | ---------------------- |
| sys_rst       | 系统复位               |
| sdi_rx_rst    | SDI 接口接收侧用户时钟 |
| sdi_gt_refclk | SDI 接口接收侧用户时钟 |
| sdi_rx_usrclk | SDI 接口接收侧用户时钟 |
| sdi_rx_usrclk | SDI 接口接收侧用户时钟 |

| Port                  | I/O   | DESCRIPTION                          |
| :-------------------- | :---- | :----------------------------------- |
| clk                   | IN    | clock                                |
| rst                   | IN    | reset                                |
| gt_refclk_p           | IN    | gt reference clock                   |
| gt_refclk_n           | IN    | gt reference clock                   |
| **REGISTER**--------- | ----- | ------------------------------------ |
| reg_cfg[32-1:0]       | IN    | config{gt_rx_cfg,sdi_cfg}            |
| reg_cnt[32*4-1:0]     | OUT   | counter                              |
| reg_sta[32-1:0]       | OUT   | state{PLL_lock,reset_done}           |
| reg_err[32-1:0]       | OUT   | error                                |
