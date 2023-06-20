from pathlib import Path

def create_output_dir_if_req(output_path):
    dir_path = Path(output_path)
    dir_path.mkdir(parents=True, exist_ok=True)


def clean_output_dir(output_path):
    dir_path = Path(output_path)
    # Remove files
    for file_path in dir_path.iterdir():
        if file_path.is_file():
            file_path.unlink()
    # Remove subdirectories
    for subdirectory_path in dir_path.iterdir():
        clean_output_dir(subdirectory_path) # recusively remove elements in subdir before removing the dir itself
        if subdirectory_path.is_dir():
            subdirectory_path.rmdir()