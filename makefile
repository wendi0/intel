default: doit

doit: build buimage buiso bustamp
	sh build
	sh buimage
	sh buiso
	sh bustamp
