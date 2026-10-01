NAME   := Caterina_Pedri_CV
PHOTO  := assets/photo.jpg
SOURCE := assets/photo-source.jpg

.PHONY: all photo open clean

all: $(NAME).pdf

$(NAME).pdf: $(NAME).tex pedricv.cls $(PHOTO)
	tectonic -X compile $(NAME).tex

# 3:4 portrait, resized from the original (macOS `sips`).
photo:
	sips -s format jpeg -s formatOptions 85 -Z 1200 $(SOURCE) --out $(PHOTO) >/dev/null

open: $(NAME).pdf
	open $(NAME).pdf

clean:
	rm -f $(NAME).pdf
