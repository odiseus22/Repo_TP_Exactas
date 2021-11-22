from PIL import Image
import os


def get_spaced_colors(n):
    max_value = 16581375  # 255**3
    interval = int(max_value / n)
    colors = [hex(I)[2:].zfill(6) for I in range(0, max_value, interval)]

    return [(int(i[:2], 16), int(i[2:4], 16), int(i[4:], 16)) for i in colors]

for file in os.listdir("tests/benchmark_diff_K/results"):
    if not file.endswith(".txt"):
        continue
    source_file = open("tests/benchmark_diff_K/results/" + file, "r")
    source_file_lines = source_file.read().splitlines()

    # if source_file_lines[0] != "ALGOIIITPII":
    #     break

    image_list = []
    source_image = []
    pixel_list = []
    for line in source_file_lines[1:]:
        new_line = line.split()
        new_line_to_int = list(map(int, new_line))
        source_image.append(new_line_to_int)

    height = len(source_image)
    width = len(source_image[0])

    max_color = 0
    for line in source_image:
        for pixel in line:
            if max_color < int(pixel):
                max_color = int(pixel)

    list_of_colors = get_spaced_colors(max_color)

    for line in source_image:
        for pixel in line:
            image_list.append(list_of_colors[pixel])

    img = Image.new('RGB', (width, height))
    img.putdata(image_list)
    file_output = file.split('.')[0]
    img.save("tests/benchmark_diff_K/images_results/" + file_output + ".png", format="PNG")
