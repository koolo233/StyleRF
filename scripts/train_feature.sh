#!/bin/bash

usage() {
  echo "Usage: ${0}
        [-i|--gpu_ids]
        [-d|--dataset]
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
    *)
      usage
      shift
      ;;
  esac
done

CUDA_VISIBLE_DEVICES=${GPU_IDS} python train_feature.py --config=configs/llff_feature_${DATASET}.txt