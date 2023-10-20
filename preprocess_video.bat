@echo off


REM read arguments from config file
for /f "usebackq tokens=1* delims==" %%a in ("config_preprocess_video_batch.txt") do (
    set "%%a=%%b"
)

REM activate the dense_depth codna env and execute program
call conda activate tensorflow
python extract_frames.py --vid_path %input_vid_path% --output_path %extracted_frames_path% --nb_frames %nb_frames_tb_extracted%
python downscale_image_resolution.py --orig_frames_path %extracted_frames_path% --output_path %downscaled_frames_path%
cd dense_depth
python estimate_depth_and_save.py --orig_frames_path %downscaled_frames_path% --output_path %depth_processed_frames_path% --pretrained_model_path %depth_model_path%
cd ..
call conda deactivate

REM activate the multi-box_ssd codna env and execute program
cd multi-box_ssd
call conda activate multi-box_ssd
python detect_and_save.py --orig_frames_path %downscaled_frames_path% --output_path %ssd_processed_frames_path% --pretrained_model_path %ssd_model_path%
REM deactivate env
call conda deactivate
cd ..

