@echo off


REM BEGIN: CLI Arguments
set input_vid_path=%1
set extracted_frames_path=%2
set nb_frames_tb_extracted=%3
set ssd_processed_frames_path=%4
set ssd_model_path=%5
set depth_processed_frames_path=%6
set depth_model_path=%7
REM END: CLI Arguments

REM activate the dense_depth codna env and execute program
cd dense_depth
call conda activate tensorflow
python estimate_depth_and_save.py --orig_frames_path %extracted_frames_path% --output_path %depth_processed_frames_path% --pretrained_model_path %depth_model_path%
call conda deactivate
cd ..

REM activate the multi-box_ssd codna env and execute program
cd multi-box_ssd
call conda activate multi-box_ssd
python extract_frames.py --vid_path %input_vid_path% --output_path %extracted_frames_path% --nb_frames %nb_frames_tb_extracted%
python detect_and_save.py --orig_frames_path %extracted_frames_path% --output_path %ssd_processed_frames_path% --pretrained_model_path %ssd_model_path%
REM deactivate env
call conda deactivate
cd ..

