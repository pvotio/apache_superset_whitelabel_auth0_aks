
########################################################################################################################
# find closest matching HEX colors
########################################################################################################################

import numpy as np
import pandas as pd
import matplotlib.colors as cl

matched_color =[]
def closest(colors,color, matched_color):
    colors = np.array(colors)
    color = np.array(color)
    for x in color:
        distances = np.sqrt(np.sum((colors-x)**2,axis=1))
        index_of_smallest = np.where(distances==np.amin(distances))
        smallest_distance = colors[index_of_smallest[0].flat[0]]
        matched_color.append(smallest_distance)
    return matched_color

# target colors
target_colors_hex         = pd.read_excel(r'target_colors_hex.xlsx', header=None)
target_colors_hex         = target_colors_hex[0].astype(str).tolist()
target_colors_rgb         = np.array([cl.hex2color(c) for c in target_colors_hex])

# current colors
currentcolors_hex       = pd.read_excel(r'colors_hex.xlsx', header=None)
currentcolors_hex       = currentcolors_hex[0].astype(str).tolist()
currentcolors_rgb       = np.array([cl.hex2color(c) for c in currentcolors_hex])

matched_color_rgb     = closest(target_colors_rgb,currentcolors_rgb, matched_color)
matched_color_hex     = [cl.to_hex(c) for c in matched_color_rgb]

#currentcolors_hex   = [element.replace('#', '') for element in currentcolors_hex]
#matched_color_hex = [element.replace('#', '') for element in matched_color_hex]

df1 = pd.DataFrame(currentcolors_hex)
df2 = pd.DataFrame(matched_color_hex)

# matched colors formatted as block to be used in bash script
matched = pd.concat([df1, df2], axis=1)
matched["ready"] = "\"" + df1.astype(str) +"/"+ df2 + "\" "
matched_numpy = matched["ready"].values
matched_numpy = np.resize(matched_numpy, (67, 8))
matched_final = pd.DataFrame(matched_numpy)
matched_final.to_excel("matched_hex.xlsx")

########################################################################################################################
# find closest matching RGBA colors
########################################################################################################################

import numpy as np
import pandas as pd
import matplotlib.colors as cl

matched_color =[]
def closest(colors,color, matched_color):
    colors = np.array(colors)
    color = np.array(color)
    for x in color:
        distances = np.sqrt(np.sum((colors-x)**2,axis=1))
        index_of_smallest = np.where(distances==np.amin(distances))
        smallest_distance = colors[index_of_smallest[0].flat[0]]
        matched_color.append(smallest_distance)
    return matched_color

# target colors
target_colors_rgba          = pd.read_excel(r'target_colors_rgba.xlsx', header=None)
target_colors_rgba          = target_colors_rgba.iloc[:, 0].str.split(',', expand=True).astype(float)
target_colors_rgb           = target_colors_rgba.iloc[:, 0:3]*target_colors_rgba.iloc[:,3]
target_colors_rgb           = np.array(target_colors_rgb.iloc[:, 0:3])

# current colors
currentcolors_rgba        = pd.read_excel(r'colors_rgba.xlsx', header=None)
currentcolors_rgba        = currentcolors_rgba.iloc[:, 0].str.split(',', expand=True).astype(float)
currentcolors_rgb         = currentcolors_rgba.iloc[:, 0:3]*currentcolors_rgba.iloc[:,3]
currentcolors_rgb         = np.array(currentcolors_rgb.iloc[:, 0:3])

matched_color_rgb       = closest(target_colors_rgb,currentcolors_rgb, matched_color)
matched_color_rgba      = np.insert(matched_color_rgb, 3, '1', axis=1)
matched_color_rgba      = pd.DataFrame(matched_color_rgba).astype(str)

df1 = currentcolors_rgba.iloc[:, 0].map(str) + ',' + currentcolors_rgba.iloc[:, 1].map(str) + ',' + currentcolors_rgba.iloc[:, 2].map(str) + ',' + currentcolors_rgba.iloc[:, 3].map(str)
df2 = matched_color_rgba.iloc[:, 0].map(str) + ',' + matched_color_rgba.iloc[:, 1].map(str) + ',' + matched_color_rgba.iloc[:, 2].map(str) + ',' + matched_color_rgba.iloc[:, 3].map(str)

# matched colors formatted as block to be used in bash script
matched = pd.concat([df1, df2], axis=1)
matched["ready"] = "\"" + df1.astype(str) +"/"+ df2 + "\" "
matched_numpy = matched["ready"].values
matched_numpy = np.resize(matched_numpy, (1, 5))
matched_final = pd.DataFrame(matched_numpy)
matched_final.to_excel("matched_rgba.xlsx")
