OUTPUTS = base-left.sts base-middle.stl base-right.stl lid-half.stl

.PHONY: all clean

all: $(OUTPUTS)

%.stl: %.scad case.scad
	openscad -o $@ $<

clean:
	rm -f $(OUTPUTS)
