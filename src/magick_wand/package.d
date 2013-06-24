module magick_wand;

/**
 * The MagickWand Module: A selective wrapper around MagickWand for
 * fast and easy image resizing, color space conversion, and image
 * file loading.
 */

version(Windows) {
	// Many thanks to Destructionator for converting this to OMF
	pragma(lib, "lib\\win\\wand");
} else version(Posix) {
	pragma(lib, "wand");
}

public import magick_wand.types;
public import magick_wand.funcs;
public import magick_wand.colorspace;
public import magick_wand.wand;
