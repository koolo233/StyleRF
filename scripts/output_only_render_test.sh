#!/bin/bash

usage() {
  echo "Usage: ${0}
        [-i|--gpu_ids]
        [-d|--dataset]
        [-s|--styles]
        " 1>&2
  exit 1
}

while [[ $# -gt 0 ]];do
  key=${1}
  case ${key} in
    -i|--gpu_ids)
      GPU_IDS=${2}
      shift 2
      ;;
    -d|--dataset)
      DATASET=${2}
      shift 2
      ;;
    -s|--styles)
      STYLES=${2}
      shift 2
      ;;
    *)
      usage
      shift
      ;;
  esac
done

datasets=${DATASET:-"fern orchids fortress leaves room"}
styles=${STYLES:-"3 11 45 119 120 130"}

echo "###############################################"

for dataset in ${datasets}
do
  for style_id in ${styles}
  do
    echo "-----------------------------------------------"
    echo "Dataset: $dataset"
    echo "Style_id: $style_id"
    echo "Begin training of NeRF..."
    CUDA_VISIBLE_DEVICES=${GPU_IDS} python train_style.py \
    --config configs/llff_style_${dataset}.txt \
    --datadir ./data/llff/${dataset} \
    --expname ${dataset} --ckpt ./ckpts/llff_${dataset}_style.th \
    --style_img ./data/styles/styles/${style_id}.jpg \
    --render_only 1 \
    --render_test 1 --chunk_size 1024 --rm_weight_mask_thre 0.0001
    echo "Done training of NeRF."
    echo "-----------------------------------------------"
  done
done

echo "###############################################"
echo "Done outputs of all NeRFs."
