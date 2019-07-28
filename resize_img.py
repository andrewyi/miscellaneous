# -*- coding: utf8 -*-
# pillow test

import io
import os
import sys

from PIL import Image


def shrink_image(im, size):
    im = im.convert('RGB')
    round_count = 1
    while True:
        b_io = io.BytesIO()
        im.save(b_io, 'JPEG')
        size_l = b_io.tell()
        print('go in round {}, file size: {}.'.format(round_count, size_l))
        round_count += 1
        if size_l < size:
            return im
        else:
            width, height = im.size
            im = im.resize((int(width*0.8), int(height*0.8)), Image.ANTIALIAS)


def _extract_file_path_info(file_path):
    file_dir_path, file_name = os.path.split(file_path)
    no_ext_file_name, file_ext = os.path.splitext(file_name)
    result_file_name = 'result_{}{}'.format(no_ext_file_name, '.jpg') # file_ext)
    file_dir_path = file_dir_path if file_dir_path else '.'
    result_file_path = '{}/{}'.format(file_dir_path, result_file_name)
    return result_file_path


def help():
    print('./tool ${output_size_in_k} ${image_file_path}')
    sys.exit(-1)


def main():
    if len(sys.argv) != 3:
        help()
    size = int(sys.argv[1])
    file_path = sys.argv[2]
    if not os.path.isfile(file_path):
        help()
    res_file_path = _extract_file_path_info(file_path)

    im = Image.open(file_path)
    new_im = shrink_image(im, size * 1000)
    new_im.save(res_file_path)


if __name__ == '__main__':
    sys.exit(main())
