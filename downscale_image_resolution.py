import argparse
from pathlib import Path

from skimage import io
from skimage.transform import resize
import numpy as np

from utility_functions import create_output_dir_if_req, clean_output_dir

MODEL_IMAGE_DIMS = (480, 640)

# Argument Parser
parser = argparse.ArgumentParser(description='Anti-Aliasing downscaling to the expected model resolution')

parser.add_argument('--orig_frames_path', default='orig', 
                    type=str, help='Path to the extracted frames directory')
parser.add_argument('--output_path', default='downscaled',
                    type=str, help='Path to where the processed frames should be saved')

args = parser.parse_args()


def downscale_images(input_frames_path: Path, output_path: Path):
    for p_ in input_frames_path.glob('*.png'):
        image = io.imread(p_.as_posix())
        downscaled_image = resize(image, MODEL_IMAGE_DIMS, anti_aliasing=True)
        downscaled_image = (downscaled_image * 255).astype(np.uint8)
        save_path = output_path / p_.name
        io.imsave(save_path.as_posix(), downscaled_image)


if __name__ == '__main__':
    orig_frames_path = Path('sampled_frames') / args.orig_frames_path
    output_path = Path('sampled_frames') / args.output_path
    create_output_dir_if_req(output_path)
    clean_output_dir(output_path)
    downscale_images(orig_frames_path, output_path)
