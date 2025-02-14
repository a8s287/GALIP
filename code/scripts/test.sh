cfg=$1
batch_size=64

multi_gpus=True
mixed_precision=True

nodes=1
num_workers=1
master_port=11277

stamp=gpu${nodes}MP_${mixed_precision}

for epoch in $(seq 20 20 1500)
do
    if [ $epoch -lt 100 ]; then
        # Adds a leading zero for epoch numbers less than 100
        pretrained_model="/home/featurize/GALIP/code/saved_models/data/model_save_file/state_epoch_0$epoch.pth"
    else
        pretrained_model="/home/featurize/GALIP/code/saved_models/data/model_save_file/state_epoch_$epoch.pth"
    fi

    CUDA_VISIBLE_DEVICES=0 python -m torch.distributed.launch --nproc_per_node=$nodes --master_port=$master_port src/test.py \
                    --stamp $stamp \
                    --cfg $cfg \
                    --mixed_precision $mixed_precision \
                    --batch_size $batch_size \
                    --num_workers $num_workers \
                    --multi_gpus $multi_gpus \
                    --pretrained_model_path $pretrained_model
done
