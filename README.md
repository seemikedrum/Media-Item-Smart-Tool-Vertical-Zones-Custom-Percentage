
![Bottom-Quarter-ezgif-com-video-to-gif-converter-1](https://github.com/user-attachments/assets/2722f402-f249-40b0-bb3c-79d548ac3e1d)

I've always wanted to have the option of using the move tool on only the bottom 25% of a media item, and the razor select tool on the top 75%. However with the mouse modifier preferences, we only have the ability to split the media item mouse modifier zones into top and bottom halves.<p>

This script splits the zones into top 75% and bottom 25% portions.<p>

It then automatically switches to the razor select tool when the mouse is hovering over the top 75% of the media item, or the move tool when hovering over the bottom 25%.<p>

The bottom zone percentage can be further adjusted by changing the division amount on line 31 of the code:<p>
```
local test_point = math.floor( y + item_h/4 *OScoeff)<br>
-- edit the division amount if you want a different percentage for the bottom zone (i.e. /5 for 20%)
```
