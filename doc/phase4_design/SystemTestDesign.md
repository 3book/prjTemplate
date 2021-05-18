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

# xxxx FPGA project TestDesign

| Name           | xxxx FPGA project SystemTestDesign |
| :------------- | :--------------------------------- |
| Identification |                                    |
| SecretLevel    | secret                             |
| Author         | xxxx                               |
| Coptright      | xxxx                               |

**Revision History**
| Version No | Date | Prepared by<br>Modified by | Significant Changes |
|:-----------|:-----------|:---------------------------|:--------------------|
| 1.0 | 2019-07-30 | xxxx | initial |

# xxxx FPGA project SystemTestDesign

## 测试环境

## 测试点

测试点仅以面积举例

| 编号 | 特性     | 测试点                                     |
| ---- | -------- | ------------------------------------------ |
| 001  | 面积检测 | 目标实际面积恰好在配置范围内               |
| 002  | 面积检测 | 目标实际面积比配置范围内大 1               |
| 003  | 面积检测 | 目标实际面积比配置范围内小 1               |
| 004  | 面积检测 | 目标实际面积比配置范围大很多               |
| 005  | 面积检测 | 目标实际面积比配置范围小很多               |
| 006  | 面积检测 | 目标实际面积任意，配置范围最大             |
| 007  | 面积检测 | 目标实际面积任意，配置范围最小，且为最大值 |
| 008  | 面积检测 | 目标实际面积任意，配置范围最小，且为最小值 |

## 测试用例

### interface

| 编号  | 特性    | 用例                 | 预期                           | 结果 | 日期 |
| ----- | ------- | -------------------- | ------------------------------ | ---- | ---- |
| i.001 | axilite | 回读版本寄存器       | 读数据等于版本号               |      |      |
| i.002 | axilite | 写测试寄存器         | 读数据等于写入值               |      |      |
| i.003 | axilite | 寄存器地址连续读     | 读数据等于预期值               |      |      |
| i.004 | axilite | 寄存器地址连续写     | 读数据等于预期，写入回读相等   |      |      |
| i.005 | axilite | 寄存器地址随机读写   | 读数据等于预期，写入回读相等   |      |      |
| i.008 | ddr     | （可略）手动读写 ddr | 回读与写入一致，关注行列边界处 |      |      |
| i.009 | clk&rst |                      |                                |      |      |

### function

f.001-f.100 对应 fpga 默认配置
| 编号 | 特性 | 用例 | 预期 | 结果 | 日期 |
| ----- | -------- | ---------------------- | -------------------- | ---- | ---- |
| f.001 | 灰度处理 | [p100](#p200) 略 | 结果仅有灰色符合预期 | | |
| f.002 | 高斯滤波 | [p100](#p100) 透传 | 滤波结果符合预期 | | |
| f.003 | 高斯滤波 | [p100](#p100) sigma=1 | 滤波结果符合预期 | | |
| f.004 | 高斯滤波 | [p100](#p100) 均值 | 滤波结果符合预期 | | |
| f.005 | 帧间差分 | [p100](#p100) 门限为 0 | 差分结果为纯白 | | |

### performance

| 编号  | 特性       | 用例                         | 预期           | 结果 | 日期 |
| ----- | ---------- | ---------------------------- | -------------- | ---- | ---- |
| p.001 | 状态寄存器 | 所有用例中均需观察状态寄存器 | 状态符合预期   |      |      |
| p.002 | 统计功能   | 所有用例中均需观察统计寄存器 | 统计符合预期   |      |      |
| p.003 | 统计功能   | 所有用例中均需观察错误寄存器 | 错误符合预期   |      |      |
| p.004 | 检测时间   | 触发测试                     | 计算时延<=50ms |      |      |
| p.005 | 检测率     | 1000 个样本测试              | 全部检测到     |      |      |

### DFT

| 编号  | 特性       | 用例                          | 预期                     | 结果 | 日期 |
| ----- | ---------- | ----------------------------- | ------------------------ | ---- | ---- |
| d.001 | vdma 测试  | prbs 测试                     | 持续 60 分钟无 prbs 错误 |      |      |