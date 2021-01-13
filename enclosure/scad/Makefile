SOURCES = $(wildcard base-*.scad) $(wildcard lid-*.scad)
OUTPUTS = $(patsubst %.scad,%.stl,$(SOURCES))

.PHONY: all clean

all: $(OUTPUTS)

%.stl: %.scad case.scad
	openscad -o $@ $<

clean:
	rm -f $(OUTPUTS)
