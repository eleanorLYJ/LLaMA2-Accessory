#!/bin/bash

export PYTORCH_CUDA_ALLOC_CONF="max_split_size_mb:64"

pretrained_path="./pretrained/"
pretrained_type=meta_ori
# The first config file ($2) points to the param.json file released by meta,
# which identifies the size (e.g. 7B, 13B) of the model.
# The second config file defines configs specific to llama-adapter.
llama_config="pretrained/params.json"
tokenizer_path="pretrained/tokenizer.model"
data_config=myconfig/data/llama2.yaml

data_parallel=sdp
model_parallel=1

exp_name=finetune/llama2Adapter
echo "exp name: $exp_name"
mkdir -p output/"$exp_name"

torchrun --master_port=1112 --nproc_per_node=1 accessory/main_finetune.py \
--output_dir output/"$exp_name" --epochs 1 --warmup_epochs 1 \
--batch_size 1 --accum_iter 2 --num_workers 4 \
--max_words 512 \
--lr 0.00005 --min_lr 0.000005 --clip_grad 2 --weight_decay 0.02 \
--data_parallel "$data_parallel" --model_parallel_size "$model_parallel" \
--llama_type llama_adapter --llama_config $llama_config --tokenizer_path "$tokenizer_path" \
--no_visual \
--pretrained_path "$pretrained_path" --pretrained_type="$pretrained_type" \
--data_config $data_config \
2>&1 | tee -a output/"$exp_name"/output.log

echo "exp name: $exp_name"