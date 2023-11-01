# [*CVPR 2023*] StyleRF: Zero-shot 3D Style Transfer of Neural Radiance Fields
## [Project page](https://kunhao-liu.github.io/StyleRF/)

---
## Installation

```commandline
conda create -n StyleRF python=3.9
conda activate StyleRF
pip install torch==1.12.1+cu116 torchvision==0.13.1+cu116 torchaudio==0.12.1 --extra-index-url https://download.pytorch.org/whl/cu116
pip install -r requirements.txt
```

4090 可能存在兼容性问题，尝试使用1.13或以上版本：
```commandline
pip install torch==1.13.1+cu117 torchvision==0.14.1+cu117 torchaudio==0.13.1 --extra-index-url https://download.pytorch.org/whl/cu117
```

## TODO List

- [x] llff - trex - 0~140 styles
- [x] llff - horns - 0~140 styles
- [x] llff - flower - 0~140 styles
- [ ] llff - fern - 0~140 styles
- [ ] llff - orchids - 0~140 styles
- [ ] llff - fortress - 0~140 styles
- [ ] llff - leaves - 0~140 styles
- [ ] llff - room - 0~140 styles


### training and inference time
| scene    | type                        | time |
|----------|-----------------------------|------|
| trex     | Feature grid training stage |      |
| horns    | Feature grid training stage |      |
| flower   | Feature grid training stage |      |
| orchids  | Feature grid training stage |      |
| fortress | Feature grid training stage |      |
| leaves   | Feature grid training stage |      |
| room     | Feature grid training stage |      |
| fern     | Feature grid training stage |      |
| trex     | Stylization training stage  |      |
| horns    | Stylization training stage  |      |
| flower   | Stylization training stage  |      |
| orchids  | Stylization training stage  |      |
| fortress | Stylization training stage  |      |
| leaves   | Stylization training stage  |      |
| room     | Stylization training stage  |      |
| fern     | Stylization training stage  |      |
| trex     | Inference                   |      |
| horns    | Inference                   |      |
| flower   | Inference                   |      |
| orchids  | Inference                   |      |
| fortress | Inference                   |      |
| leaves   | Inference                   |      |
| room     | Inference                   |      |
| fern     | Inference                   |      |

其中Inference以6个style的平均预测时间作为结果。


## cmdline

### training


### output
```commandline
bash ./scripts/output.sh -i {GPU_Id} -d {scene}
```

`scene`: `trex`, `horns`, and `flower`.

## Datasets
Please put the datasets in `./data`. You can put the datasets elsewhere if you modify the corresponding paths in the configs.

### 3D scene datasets
* [nerf_synthetic](https://drive.google.com/drive/folders/128yBriW1IG_3NJ5Rp7APSTZsJqdJdfc1) 
* [llff](https://drive.google.com/drive/folders/128yBriW1IG_3NJ5Rp7APSTZsJqdJdfc1)
### Style image dataset
* [WikiArt](https://www.kaggle.com/datasets/ipythonx/wikiart-gangogh-creating-art-gan)

## Quick Start
We provide some trained checkpoints in: [StyleRF checkpoints](https://drive.google.com/drive/folders/1nF9-6lTIhktG5JjNvnmdYOo1LTvtK7Dw?usp=share_link)

Then modify the following attributes in `scripts/test_style.sh`:
* `--config`: choose `configs/llff_style.txt` or `configs/nerf_synthetic_style.txt` according to which type of dataset is being used
* `--datadir`: dataset's path
* `--ckpt`: checkpoint's path
* `--style_img`: reference style image's path


To generate stylized novel views:
```
bash scripts/test_style.sh [GPU ID]
```
The rendered stylized images can then be found in the directory under the checkpoint's path.

## Training
> Current settings in `configs` are tested on one NVIDIA RTX A5000 Graphics Card with 24G memory. To reduce memory consumption, you can set `batch_size`, `chunk_size` or `patch_size` to a smaller number.

We follow the following 3 steps of training:
### 1. Train original TensoRF （VM-48）
This step is for reconstructing the density field, which contains more precise geometry details compared to mesh-based methods. You can skip this step by directly downloading pre-trained checkpoints provided by [TensoRF checkpoints](https://1drv.ms/u/s!Ard0t_p4QWIMgQ2qSEAs7MUk8hVw?e=dc6hBm).

The configs are stored in `configs/llff.txt` and `configs/nerf_synthetic.txt`. For the details of the settings, please also refer to [TensoRF](https://github.com/apchenstu/TensoRF). The checkpoints are stored in `./log` by default.

You can train the original TensoRF by:
```
bash script/train.sh [GPU ID]
```

### 2. Feature grid training stage
This step is for reconstructing the 3D gird containing the VGG features.

The configs are stored in `configs/llff_feature.txt` and `configs/nerf_synthetic_feature.txt`, in which `ckpt` specifies the checkpoints trained in the **first** step. The checkpoints are stored in `./log_feature` by default.

Then run:
```
bash script/train_feature.sh [GPU ID]
```


### 3. Stylization training stage 
This step is for training the style transfer modules.

The configs are stored in `configs/llff_style.txt` and `configs/nerf_synthetic_style.txt`, in which `ckpt` specifies the checkpoints trained in the **second** step. The checkpoints are stored in `./log_style` by default.

Then run:
```
bash script/train_style.sh [GPU ID]
```

---
## Acknowledgments
This repo is heavily based on the [TensoRF](https://github.com/apchenstu/TensoRF). Thank them for sharing their amazing work!

## Citation
If you find our code or paper helps, please consider citing:
```
@inproceedings{liu2023stylerf,
  title={StyleRF: Zero-shot 3D Style Transfer of Neural Radiance Fields},
  author={Liu, Kunhao and Zhan, Fangneng and Chen, Yiwen and Zhang, Jiahui and Yu, Yingchen and El Saddik, Abdulmotaleb and Lu, Shijian and Xing, Eric P},
  booktitle={Proceedings of the IEEE/CVF Conference on Computer Vision and Pattern Recognition},
  pages={8338--8348},
  year={2023}
}
```

