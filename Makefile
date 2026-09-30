NAME  := Caterina_Pedri_CV
PHOTO := assets/photo.jpg

.PHONY: all photo open clean

all: $(NAME).pdf

$(NAME).pdf: $(NAME).tex pedricv.cls $(PHOTO)
	tectonic -X compile $(NAME).tex

# Square head-and-shoulders crop of the original HEIC portrait (macOS `sips`).
photo:
	mkdir -p assets
	sips -s format jpeg -s formatOptions 92 \
	     --cropToHeightWidth 1946 1946 --cropOffset 0 539 \
	     IMG_3505.heic --out $(PHOTO) >/dev/null
	sips -Z 1000 $(PHOTO) >/dev/null

open: $(NAME).pdf
	open $(NAME).pdf

clean:
	rm -f $(NAME).pdf
