library('hexSticker')
library('showtext')
## Loading Google fonts (http://www.google.com/fonts)
font_add_google('Montserrat')
## Automatically use showtext to render text for future devices
showtext_auto()

imgurl <- 'ocean.jpg'

sticker(imgurl,
        package='Kgen', 
        p_family = 'Montserrat',
        p_size=8.5,
        p_y = 1,
        h_color = "grey70",
        h_fill = "black",
        s_x=1, 
        s_y=1, 
        s_width=1, 
        s_height=1,
        url = "https://github.com/PalaeoCarb",
        u_size = 1,
        u_color = "white",
        white_around_sticker = TRUE,
        filename="Kgen_logo_R.png")
