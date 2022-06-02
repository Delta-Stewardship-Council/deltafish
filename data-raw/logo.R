require(ggplot2)
require(sf)
require(magick)
require(cowplot)
require(hexSticker)

map<-ggplot()+
    geom_sf(data=deltamapr::WW_Delta, color="slategray2", fill="slategray2")+
    theme_void()

p<-ggdraw() +
    draw_image("~/Delta smelt.tif", x=-0.05, y=-0.1, scale=0.2) +
    draw_plot(map, x=0, y=0, scale=1)

ggsave(plot=p, filename=file.path(tempdir(), "logo_background.png"), device="png", width = 18.56, height=12.3, units="in")

p<-image_read(file.path(tempdir(), "logo_background.png"))
p2<-image_crop(p, "5068x3690+100")
image_write(p2, file.path(tempdir(), "logo_background.png"))

logo<-sticker(file.path(tempdir(), "logo_background.png"),
              package="deltafish", p_size=25, s_width=1.25, s_y = 1, s_x = 1.0, asp=1,
              h_fil="white", h_color="#F15946", p_color="black", h_size = 1.5,
              white_around_sticker = F,
              filename="data-raw/logo.png")
usethis::use_logo("data-raw/logo.png")
