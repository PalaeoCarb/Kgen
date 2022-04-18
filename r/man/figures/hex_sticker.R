library('hexSticker')

imgurl <- 'logo.png'

sticker(imgurl,
        package='Kgen', 
        p_size = 0,
        s_x=1, 
        s_y=1, 
        s_width=0.7,
        url = "https://palaeocarb.github.io/Kgen",
        u_size = 1, 
        h_fill = "white",            # background col
        h_color = "#5276DC",           # border col
        white_around_sticker = FALSE,
        filename="Kgen_logo_R.png")
